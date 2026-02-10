ifeq ($(OS),Windows_NT)
    DASM=bin/dasm.exe
    STELLA=bin/Stella.exe
    MKDIR=@if not exist out mkdir out
else
    DASM=dasm
    STELLA=stella
    MKDIR=@mkdir -p out
endif

DASM_FLAGS=-Isrc -T1 -f3

out/raiders.bin:
	$(MKDIR)
	$(DASM) src/raiders.asm $(DASM_FLAGS) -sout/raiders.sym -Lout/raiders.lst -o$@

.PHONY: clean
clean:
	-rm -r out

.PHONY: run
run: out/raiders.bin
	$(STELLA) out/raiders.bin
