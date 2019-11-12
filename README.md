# README
## Kompilator instant - kompilator gramatyki języka instant.
Gramatyka bezkontekstowa dla bnfc umieszczona w pliku src/Instant.cf.
### 1. Uruchomienie i kompilacja programu:
Program kompilujemy poleceniem make, które zbuduje pliki wykonywalne w tym katalogu.
Uruchamiamy przy pomocy plików znajdujących się w korzeniu projektu: insc_llvm oraz insc_jvm jako argument podając plik źródłowy *.ins. Jako wynik otrzymujemy odpowiednio pliki: "*.ll" i "*.bc" oraz "*.j" i "*.class" w katalogu źródłowym.
Żeby uruchomiś skompilowane programy należy wykonać odpowiednio:
dla LLVM: lli <program>.bc
dla JVM:  java -cp <nazwa klasy>
### 2. Użyte biblioteki:
Projekt w całości został napisany w Haskellu. Gramatyka została wygenerowana przy pomocy bnfc.
W katalogu lib znajduje się plik jasmin.jar oraz plik wykonywalny runtime.bc z funkcją printInt(i32) dla llvm.
### 3. Zastosowane optymalizacje:
JVMCompiler sprawdza wielkość stosu każdego z podwyrażeń i wykonuje najpierw większe drzewo ze względu na wielkość stosu oraz używa odpowiednich typów poleceń dla małych liczb.
### 4. Struktura programu:
W korzeniu projektu znajdują się pliki insc_jvm i insc_llvm, które uruchamiają pliki wykonywalne skompilowane poleceniem make. W katalogu src jest plik gramatyki oraz pliki główne kompilatora, które korzystają z plików wygenerowanych przez bnfc znajdujących sie w folderze Grammar oraz plików pomocniczych znajdujących się w folderze Util.
