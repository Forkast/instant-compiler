module LLVMEmits where

data Op
    = OAdd
    | OSub
    | OMul
    | ODiv

emitPref :: Op -> String
emitPref OAdd = "add i32 "
emitPref OSub = "sub i32 "
emitPref OMul = "mul i32 "
emitPref ODiv = "sdiv i32 "

emitLit :: Integer -> String
emitLit integer = "add i32 0, " ++ show(integer) 

emitPrint :: Integer -> String
emitPrint x =
  "\n  call void @printInt(i32 %t" ++ show(x) ++ ")"

emitAlloc :: String -> String
emitAlloc ident =
  "\n  %"
  ++ ident
  ++ " = alloca i32"

emitStore :: String -> Integer -> String
emitStore ident val =
  "\n  store i32 %t"
  ++ show val
  ++ ", i32* %"
  ++ ident

emitLoad :: String -> String
emitLoad ident =
  "load i32, i32* %"
  ++ ident

emitPrintH :: String
emitPrintH =
  "declare void @printInt(i32)"

emitHead :: String
emitHead =
  "\ndefine i32 @main() {"

emitTail :: String
emitTail =
  "\n  ret i32 0"
  ++ "\n}"
