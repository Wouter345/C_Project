ifndef ZYNQ
$(error Please source the source_me file first for the environment variables!)
endif

no-target:
	$(error please specify function)

build:
	vivado -mode batch -source tcl/build_project.tcl
	mkdir tmp

open:
	vivado project_hw/project_hw.xpr -tempDir tmp &

clean:
	del /f /q vivado.* vivado_* .Xil\* webtalk* NA
	rmdir /s /q project_hw project_ipcores tmp .Xil

