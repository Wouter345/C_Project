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
    intf_i.cb.bus_valid <= 0;
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
      @(intf_i.cb); 
      intf_i.cb.start <= 0;
      
      intf_i.cb.bus_valid <= 1;
      //// SEND KERNEL DATA
      $display("[DRV] ----- Driving a new input kernel map -----");
      for (int inch = 0; inch < cfg.INPUT_NB_CHANNELS; inch++) begin
        for (int outch = 0; outch < cfg.OUTPUT_NB_CHANNELS; outch += 2) begin
          for (int ky = 0; ky < cfg.KERNEL_SIZE; ky++) begin
            for (int kx = 0; kx < cfg.KERNEL_SIZE; kx++) begin
                intf_i.cb.to_bus_1 <= tract_kernel.kernel[ky][kx][inch][outch];
                intf_i.cb.to_bus_2 <= tract_kernel.kernel[ky][kx][inch][outch+1];
                @(intf_i.cb iff intf_i.cb.bus_ready); //wait until next edge and bus_ready is high 
            end
          end
        end
      end
      $display("[DRV] ----- FINISHED Driving kernel map -----");
      //// SEND FEATURE DATA
      $display("[DRV] ----- Driving a new input feature map -----");
      for (int x = 0; x < cfg.FEATURE_MAP_WIDTH; x = x + cfg.CONV_STEP) begin
        if (x % 8 == 0)
            $display("[DRV] %.2f %% of the input is transferred",
                 ((x) * 100.0) / cfg.FEATURE_MAP_WIDTH); // displays progress as percentage
        for (int y = 0; y < cfg.FEATURE_MAP_HEIGHT; y = y + cfg.CONV_STEP) begin
          for (int inch = 0; inch < cfg.INPUT_NB_CHANNELS; inch ++) begin
              for (int ky = 0; ky < cfg.KERNEL_SIZE; ky++) begin
                for (int kx = 0; kx < cfg.KERNEL_SIZE; kx++) begin
                  
                  if( x+kx-cfg.KERNEL_SIZE/2 >= 0 && x+kx-cfg.KERNEL_SIZE/2 < cfg.FEATURE_MAP_WIDTH
                    &&y+ky-cfg.KERNEL_SIZE/2 >= 0 && y+ky-cfg.KERNEL_SIZE/2 < cfg.FEATURE_MAP_HEIGHT) begin
                    assert (!$isunknown(
                        tract_feature.inputs[y+ky-cfg.KERNEL_SIZE/2][x+kx-cfg.KERNEL_SIZE/2][inch]
                    ));
                    if (kx == 0) intf_i.cb.to_bus_1 <= tract_feature.inputs[y+ky-cfg.KERNEL_SIZE/2 ][x+kx-cfg.KERNEL_SIZE/2][inch];
                    if (kx == 1) intf_i.cb.to_bus_2 <= tract_feature.inputs[y+ky-cfg.KERNEL_SIZE/2 ][x+kx-cfg.KERNEL_SIZE/2][inch];
                    if (kx == 2) intf_i.cb.to_bus_3 <= tract_feature.inputs[y+ky-cfg.KERNEL_SIZE/2 ][x+kx-cfg.KERNEL_SIZE/2][inch];
                  end else begin
                    if (kx == 0) intf_i.cb.to_bus_1 <= 0;
                    if (kx == 1) intf_i.cb.to_bus_2 <= 0;
                    if (kx == 2) intf_i.cb.to_bus_3 <= 0;
                  end
                  

                end
                @(intf_i.cb iff intf_i.cb.bus_ready); // update the next 3 bus values 
              end
            end
          end
      end
      
      $display("[DRV] 100%% of the input is transferred");
      @(intf_i.clk iff !intf_i.running); 
      // wait for dut to finish running
      $display("[DRV] DUT finished running");
      
      $display("\n\n------------------\nLATENCY: input processed in %t\n------------------\n", $time() - starttime);

      $display("------------------\nENERGY:  %0d\n------------------\n", tbench_top.energy);

      $display("------------------\nENERGYxLATENCY PRODUCT (/1e9):  %0d\n------------------\n", (longint'(tbench_top.energy) * ($time() - starttime)) / 1e9);

      $display("------------------\nAREA (breakdown see start): %0d\n------------------\n", tbench_top.area);
      
      tbench_top.energy = 0;
      repeat (2) @(intf_i.clk iff !intf_i.running);
      // wait before starting the next test
      

    end
  endtask : run
endclass : Driver
