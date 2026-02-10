DASM=bin/dasm.exe
STELLA=bin/Stella.exe
DASM_FLAGS=-Isrc -T1 -f3

out/raiders.bin:
	@if not exist out mkdir out
	$(DASM) src/raiders.asm $(DASM_FLAGS) -sout/raiders.sym -Lout/raiders.lst -o$@

.PHONY: clean
clean:
	-rm -r out

.PHONY: run
run: out/raiders.bin
	$(STELLA) out/raiders.bin
