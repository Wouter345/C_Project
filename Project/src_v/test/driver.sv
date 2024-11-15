class Driver #(
    config_t cfg
);

  virtual intf #(cfg) intf_i;

  mailbox #(Transaction_Feature #(cfg)) gen2drv_feature;
  mailbox #(Transaction_Kernel #(cfg)) gen2drv_kernel;

  function new(virtual intf #(cfg) i, mailbox#(Transaction_Feature#(cfg)) g2d_feature,
               mailbox#(Transaction_Kernel#(cfg)) g2d_kernel);
    intf_i = i;
    gen2drv_feature = g2d_feature;
    gen2drv_kernel = g2d_kernel;
  endfunction : new

  task reset;
    $display("[DRV] ----- Reset Started -----");
    //asynchronous start of reset
    intf_i.cb.start <= 0;
    intf_i.cb.conv_stride_mode <= 0;
    intf_i.cb.a_valid <= 0;
    intf_i.cb.arst_n <= 0; // set reset enable
    repeat (2) @(intf_i.cb); // wait two consecutive clock edges on clocking block
    intf_i.cb.arst_n <= 1;  //synchronous release of reset
    repeat (2) @(intf_i.cb);
    $display("[DRV] -----  Reset Ended  -----");
  endtask

  task run();
    // Get a transaction with kernel from the Generator
    // Kernel remains same throughput the verification
    Transaction_Kernel #(cfg) tract_kernel;
    gen2drv_kernel.get(tract_kernel); //read tract_kernel from mailbox

    $display("[DRV] -----  Start execution -----");

    forever begin
      time starttime;
      // Get a transaction with feature from the Generator
      Transaction_Feature #(cfg) tract_feature; 
      gen2drv_feature.get(tract_feature); //read tract_feature from mailbox
      $display("[DRV] Programming configuration bits");
      intf_i.cb.conv_stride_mode <= $clog2(cfg.CONV_STEP);

      $display("[DRV] Giving start signal");
      intf_i.cb.start <= 1;
      starttime = $time();
      @(intf_i.cb); // wait 1 cycle i guess
      intf_i.cb.start <= 0;
      
      intf_i.cb.a_valid <= 1;
      //// SEND KERNEL DATA
      $display("[DRV] ----- Driving a new input kernel map -----");
      for (int outch = 0; outch < cfg.OUTPUT_NB_CHANNELS; outch += 2) begin
        for (int inch = 0; inch < cfg.INPUT_NB_CHANNELS; inch++) begin
          for (int ky = 0; ky < cfg.KERNEL_SIZE; ky++) begin
            for (int kx = 0; kx < cfg.KERNEL_SIZE; kx++) begin
                intf_i.cb.a_input <= tract_kernel.kernel[ky][kx][inch][outch];
                intf_i.cb.b_input <= tract_kernel.kernel[ky][kx][inch][outch+1];
                @(intf_i.cb iff intf_i.cb.a_ready); //if a ready goes high 
            end
          end
        end
      end
      $display("[DRV] ----- FINISHED a new input kernel map -----");
      
      //// SEND FEATURE DATA
      $display("[DRV] ----- Driving a new input feature map -----");
      for (int x = 0; x < cfg.FEATURE_MAP_WIDTH; x = x + cfg.CONV_STEP) begin
        $display("[DRV] %.2f %% of the input is transferred",
                 ((x) * 100.0) / cfg.FEATURE_MAP_WIDTH); // displays progress as percentage
        for (int y = 0; y < cfg.FEATURE_MAP_HEIGHT; y = y + cfg.CONV_STEP) begin
          for (int inch = 0; inch < cfg.INPUT_NB_CHANNELS; inch += 2) begin
              for (int ky = 0; ky < cfg.KERNEL_SIZE; ky++) begin
                for (int kx = 0; kx < cfg.KERNEL_SIZE; kx++) begin

                  //drive a (one word from feature)
                  if( x+kx-cfg.KERNEL_SIZE/2 >= 0 && x+kx-cfg.KERNEL_SIZE/2 < cfg.FEATURE_MAP_WIDTH
                    &&y+ky-cfg.KERNEL_SIZE/2 >= 0 && y+ky-cfg.KERNEL_SIZE/2 < cfg.FEATURE_MAP_HEIGHT) begin
                    assert (!$isunknown(
                        tract_feature.inputs[y+ky-cfg.KERNEL_SIZE/2][x+kx-cfg.KERNEL_SIZE/2][inch]
                    ));
                    assert (!$isunknown(
                        tract_feature.inputs[y+ky-cfg.KERNEL_SIZE/2][x+kx-cfg.KERNEL_SIZE/2][inch+1]
                    ));
                    intf_i.cb.a_input <= tract_feature.inputs[y+ky-cfg.KERNEL_SIZE/2 ][x+kx-cfg.KERNEL_SIZE/2][inch];
                    intf_i.cb.b_input <= tract_feature.inputs[y+ky-cfg.KERNEL_SIZE/2 ][x+kx-cfg.KERNEL_SIZE/2][inch+1];
                  end else begin
                    intf_i.cb.a_input <= 0;  // zero padding for boundary cases
                    intf_i.cb.b_input <= 0;
                  end
                  @(intf_i.cb iff intf_i.cb.a_ready); //if a ready goes high 

                end
              end
            end
          end
      end


      $display("\n\n------------------\nLATENCY: input processed in %t\n------------------\n",
               $time() - starttime);

      $display("------------------\nENERGY:  %0d\n------------------\n", tbench_top.energy);

      $display("------------------\nENERGYxLATENCY PRODUCT (/1e9):  %0d\n------------------\n",
               (longint'(tbench_top.energy) * ($time() - starttime)) / 1e9);

      tbench_top.energy = 0;

      $display("\n------------------\nAREA (breakdown see start): %0d\n------------------\n",
               tbench_top.area);

    end
  endtask : run
endclass : Driver
