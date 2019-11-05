CC=ghc
SRC=src/*.hs
GRAM=src/Grammar/*.hs
UTIL=src/Util/*.hs
BDIR=build

all: $(BDIR)/LLVMCompiler $(BDIR)/JVMCompiler

$(BDIR)/LLVMCompiler: src/LLVMCompiler.hs $(UTIL) $(GRAM)
	mkdir -p $(BDIR)
	$(CC) $^ -o $@

$(BDIR)/JVMCompiler: src/JVMCompiler.hs $(UTIL) $(GRAM)
	mkdir -p $(BDIR)
	$(CC) $^ -o $@

.PHONY: clean

clean:
	rm -fr src/*.o src/Grammar/*.o src/Util/*.o src/*.hi src/Grammar/*.hi src/Util/*.hi $(BDIR)/LLVMCompiler $(BDIR)JVMCompiler
