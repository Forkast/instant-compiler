CC=ghc
SRC=src/*.hs
GRAM=src/Grammar/*.hs
UTIL=src/Util/*.hs
BDIR=build
JVM=JVMCompiler
LLVM=LLVMCompiler

all: $(JVM) $(LLVM)

$(LLVM): src/LLVMCompiler.hs $(UTIL) $(GRAM)
	$(CC) $^ -o $@ -odir $(BDIR) -hidir $(BDIR)

$(JVM): src/JVMCompiler.hs $(UTIL) $(GRAM)
	$(CC) $^ -o $@ -odir $(BDIR) -hidir $(BDIR)

.PHONY: clean

clean:
	rm -fr build
	rm -f $(JVM) $(LLVM)
