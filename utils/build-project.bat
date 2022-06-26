@echo off

setlocal

set PATH=%PATH%;C:\intelFPGA_lite\18.1\quartus\bin64

break>cpu.tcl
more setup_proj.tcl>cpu.tcl

call :BuildProject DataMemory
call :BuildProject InstructionMemory
call :BuildProject PC
call :BuildProject MUX
call :BuildProject ALU
call :BuildProject Multiplicador
call :BuildProject Control
call :BuildProject RegisterFile
call :BuildProject Extend
call :BuildProject Register
call :BuildProject ADDRDecoding
call :BuildProject PLL

del *.qpf
del *.qsf
del *.v
rmdir db /S /Q
quartus_sh -t cpu.tcl cpu
move cpu_TB.v TB.v

exit /B 0

:BuildProject

rmdir %~1 /S /Q
mkdir %~1
cd %~1

quartus_sh -t ..\setup_proj.tcl %~1

cd ..

echo set_global_assignment -name VERILOG_FILE "%~1/%~1.v">> cpu.tcl

exit /B 0


