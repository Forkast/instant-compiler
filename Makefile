CC=ghc
SRC=src/*.hs
GRAM=src/Grammar/*.hs
UTIL=src/Util/*.hs
BDIR=build

all: $(BDIR) $(BDIR)/LLVMCompiler $(BDIR)/JVMCompiler

$(BDIR):
	mkdir -p $@
	chmod +x insc_llvm
	chmod +x insc_jvm

$(BDIR)/LLVMCompiler: src/LLVMCompiler.hs $(UTIL) $(GRAM)
	$(CC) $^ -o $@

$(BDIR)/JVMCompiler: src/JVMCompiler.hs $(UTIL) $(GRAM)
	$(CC) $^ -o $@

.PHONY: clean

clean:
	rm -f src/*.o src/Grammar/*.o src/Util/*.o src/*.hi src/Grammar/*.hi src/Util/*.hi
	rm -fr build
