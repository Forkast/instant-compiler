module JVMEmits where

data Op
    = OAdd
    | OSub
    | OMul
    | ODiv

emitStore :: Integer -> String
emitStore x
  | x >= 0 && x <= 3 = "  istore_" ++ show x
  | otherwise = "  istore " ++ show x

emitLoad :: Integer -> String
emitLoad x
  | x >= 0 && x <= 3 = "  iload_" ++ show x
  | otherwise = "  iload " ++ show x

emitSuf :: Op -> String
emitSuf OAdd = "\n  iadd"
emitSuf OSub = "\n  isub"
emitSuf OMul = "\n  imul"
emitSuf ODiv = "\n  idiv"

emitLit :: Integer -> String
emitLit integer
    | integer == -1 = "  iconst_m1"
    | integer >= 0 && integer <= 5 = "  iconst_" ++ (show integer)
    | otherwise = "  ldc " ++ (show integer)

emitPrint :: String
emitPrint =
  "\n  getstatic java/lang/System/out Ljava/io/PrintStream;"
  ++ "\n  swap"
  ++ "\n  invokevirtual java/io/PrintStream/println(I)V"

emitClass :: String
emitClass =
  ".class public Main"
  ++ "\n.super java/lang/Object"
  ++ "\n.method public <init>()V"
  ++ "\n  aload_0"
  ++ "\n  invokespecial java/lang/Object/<init>()V"
  ++ "\n  return"
  ++ "\n.end method"

emitHead :: Integer -> Integer -> String
emitHead s l =
  "\n.method public static main([Ljava/lang/String;)V"
  ++ "\n .limit stack " ++ show s
  ++ "\n .limit locals " ++ show l

emitTail :: String
emitTail =
  "\n  return"
  ++ "\n.end method"
