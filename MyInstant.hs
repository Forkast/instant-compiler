module MyInstant where

import Control.Monad.State
import Data.Map as Map
import AbsInstant
import ErrM
import Data.Tuple
import JVMEmits

type Value = (String, Integer)
type Result = State (Map Ident Integer) Value

counterName :: String
counterName = "=counter"

transProgram :: Program -> Result
transProgram x = do
  s1 <- return emitClass
  (s3, i) <- transProg x
  m <- get
  (Just num) <- return $ Map.lookup (Ident counterName) m
  s2 <- return $ emitHead i (num + 1)
  return $ (s1 ++ s2 ++ s3, i)

transProg :: Program -> Result
transProg x = case x of
  Prog (x:xs) -> do
    (s1, i1) <- transStmt x
    (s2, i2) <- transProg (Prog xs)
    return $ (s1 ++ s2, max i1 i2)
  Prog [] -> return $ (emitTail, 0)

transStmt :: Stmt -> Result
transStmt x = case x of
  SAss ident exp1 -> do
    m <- get
    (s, i) <- transExp exp1
    (Just num) <- return $ Map.lookup (Ident counterName) m
    case Map.lookup ident m of
      (Just n) -> return $ (s ++ (emitStore n), i)
      Nothing -> do
        put $ Map.insert (Ident counterName) (num + 1) $ Map.insert ident (num + 1) m
        return $ (s ++ ("\n" ++ (emitStore (num + 1))), i)
  SExp exp1 -> do
    (s, i) <- transExp exp1
    return $ (s ++ emitPrint, i)

iplus :: Integer -> Integer
iplus i
  | i <= 1 = i + 1
  | otherwise = i

transExp :: Exp -> Result
transExp (ExpAdd exp1 exp2) = emitOp exp1 exp2 OAdd
transExp (ExpSub exp1 exp2) = emitOp exp1 exp2 OSub
transExp (ExpMul exp1 exp2) = emitOp exp1 exp2 OMul
transExp (ExpDiv exp1 exp2) = emitOp exp1 exp2 ODiv
transExp (ExpLit integer) = return $ ("\n" ++ emitLit integer, 1)
transExp x@(ExpVar ident) = do
  m <- get
  let
    (Just val) = Map.lookup ident m
  return ("\n" ++ (emitLoad val), 1)

emitOp :: Exp -> Exp -> Op -> Result
emitOp exp1 exp2 op = do
  v1 <- transExp exp1
  v2 <- transExp exp2
  ((s1, i1), (s2, i2)) <- return $ swapper v1 v2
  let sufix = emitSuf op
  let maximus = case i1 == i2 of
        True -> i1 + 1
        False -> i1
  return (s1 ++ s2 ++ sufix, maximus)

swapper :: Value -> Value -> (Value, Value)
swapper v1@(s1, i1) v2@(s2, i2)
  | i1 < i2 = (v2, v1)
  | otherwise = (v1, v2)

