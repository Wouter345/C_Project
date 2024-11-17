program testprogram #(
    config_t cfg
) (
    intf intf_i
);

  Environment #(cfg) env1 = new(intf_i); //initialize and create new environment

  initial begin
    //$dumpfile("out/dump.vcd");
    //$dumpvars;
    //$dumpon;
    env1.run();
    $finish;
  end

endprogram : testprogram
