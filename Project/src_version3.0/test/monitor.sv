class Monitor #(
    config_t cfg
);
  virtual intf #(cfg) intf_i;
  mailbox #(Transaction_Output_Word #(cfg)) mon2chk;

  function new(virtual intf #(cfg) intf_i, mailbox#(Transaction_Output_Word#(cfg)) m2c);
    this.intf_i = intf_i;
    mon2chk = m2c;
  endfunction : new

  task run;
    @(intf_i.cb iff intf_i.arst_n);
    forever begin
      Transaction_Output_Word #(cfg) tract_output1;
      Transaction_Output_Word #(cfg) tract_output2;
      Transaction_Output_Word #(cfg) tract_output3;
      tract_output1 = new();
      tract_output2 = new();
      tract_output3 = new();
      @(intf_i.cb iff intf_i.cb.output_valid);
      
      tract_output1.output_data = intf_i.cb.from_bus_1;
      tract_output1.output_x    = intf_i.cb.output_x;
      tract_output1.output_y    = intf_i.cb.output_y;
      tract_output1.output_ch   = intf_i.cb.output_ch;
      mon2chk.put(tract_output1); // put output from bus 1
      
      if (intf_i.cb.output_ch != 15) begin
          tract_output2.output_data = intf_i.cb.from_bus_2;
          tract_output2.output_x    = intf_i.cb.output_x;
          tract_output2.output_y    = intf_i.cb.output_y;
          tract_output2.output_ch   = intf_i.cb.output_ch + 1;
          mon2chk.put(tract_output2); // put output from bus 2
          
          tract_output3.output_data = intf_i.cb.from_bus_3;
          tract_output3.output_x    = intf_i.cb.output_x;
          tract_output3.output_y    = intf_i.cb.output_y;
          tract_output3.output_ch   = intf_i.cb.output_ch + 2;
          mon2chk.put(tract_output3); // put output from bus 3
      end
      
    end
  endtask

endclass : Monitor
