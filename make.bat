@echo off
REM Check if "out" directory exists
if not exist out (
    mkdir out
)
echo Compiling raiders
if exist out\raiders.bin del out\raiders.bin
bin\dasm.exe src\raiders.asm -Isrc -sout\raiders.sym -T1 -Lout\raiders.lst -f3 -oout\raiders.bin
