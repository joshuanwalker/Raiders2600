@echo off
REM Check if "out" directory exists
if not exist out (
    mkdir out
)
echo Compiling raiders
del out\raiders.bin
dasm.exe Raiders.asm -sout\raiders.sym -T1 -Lout\raiders.lst -f3 -oout\raiders.bin
