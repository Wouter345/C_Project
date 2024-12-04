src/rtl_building_blocks/device/adder.sv  	--> Module that performs 16 bit addition

src/rtl_building_blocks/device/super_adders.sv 	--> Module instantiates 16 adder units, used for the final summation of outputs from input channel 1, and input channel 2

src/rtl_building_blocks/device/multiplier.sv 	--> Module that performs 16 bit multiplication

src/rtl_building_blocks/device/register.sv 	--> Register module

src/rtl_building_blocks/device/memory.sv 	--> Memory module

src/rtl_building_blocks/device/KERNEL_SRAM.sv	--> Module that instantiates 32 SRAM memory blocks, each block stores the 9 kernel coefficients of 1 kernel map

src/rtl_building_blocks/device/mac.sv		--> Module performs a pipelined multiply-accumulate: 1 multiplier, 1 adder, 2 16-bit registers

src/rtl_building_blocks/device/super_mac.sv	--> Module that instantiates 32 mac units, 16 used for input channel 1, and 16 for input channel 2, all working in parallel

src/device/controller_fsm.sv			--> Finite state machine controller, sets all control signals



src/device/top_chip.sv				--> Main file
	
src/device/top_system.sv			--> No external memory used, so only instantiates the top_chip module

-------- TESTBENCH FILES --------
src/test/common.sv				--> All are self explanatory

src/test/intf.sv				

src/test/transaction.sv				

src/test/driver.sv				

src/test/monitor.sv				

src/test/generator.sv				

src/test/checker.sv				

src/test/scoreboard.sv				

src/test/environment.sv				

src/test/testprogram.sv				

src/test/tbench_top.sv				
