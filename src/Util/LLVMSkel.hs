module Util.LLVMSkel where

import Control.Monad.State
import Data.Map as Map
import AbsInstant
import ErrM
import Data.Tuple
import LLVMEmits

type Value = (String, Integer)
type Result = State (Map Ident Integer) Value

counterName :: String
counterName = "=counter"

transProgram :: Program -> Result
transProgram x = do
  s1 <- return emitPrintH
  (s3, i) <- transProg x
  s2 <- return $ emitHead
  return $ (s1 ++ s2 ++ s3, i)

transProg :: Program -> Result
transProg x = case x of
  Prog (x:xs) -> do
    (s1, i1) <- transStmt x
    (s2, i2) <- transProg (Prog xs)
    return $ (s1 ++ s2, i2)
  Prog [] -> return $ (emitTail, 0)

transStmt :: Stmt -> Result
transStmt x = case x of
  SAss ident@(Ident name) exp1 -> do
    m <- get
    let s1 = case Map.lookup ident m of
          (Just _) -> "" 
          Nothing -> emitAlloc name
    (s2, i) <- transExp exp1
    s3 <- return $ emitStore name i
    modify $ \m -> Map.insert ident i m
    return $ (s1 ++ s2 ++ s3, i)
  SExp exp1 -> do
    (s, i) <- transExp exp1
    return $ (s ++ emitPrint i, i)

transExp :: Exp -> Result
transExp (ExpAdd exp1 exp2) = emitOp exp1 exp2 OAdd
transExp (ExpSub exp1 exp2) = emitOp exp1 exp2 OSub
transExp (ExpMul exp1 exp2) = emitOp exp1 exp2 OMul
transExp (ExpDiv exp1 exp2) = emitOp exp1 exp2 ODiv
transExp (ExpLit integer) = do
  (s, i) <- emitReg
  return $ (s ++ emitLit integer, i)
transExp (ExpVar ident@(Ident name)) = do
  (s1, i1) <- emitReg
  s2 <- return $ emitLoad name
  return $ (s1 ++ s2, i1)

emitOp :: Exp -> Exp -> Op -> Result
emitOp exp1 exp2 op = do
  v1@(s1, i1) <- transExp exp1
  v2@(s2, i2) <- transExp exp2
  let prefix = emitPref op
  v3@(s3, i3) <- emitReg
  return (s1 ++ s2 ++ s3 ++ prefix ++ "%t" ++ show(i1) ++ ", %t" ++ show(i2), i3)

emitReg :: Result
emitReg = do
  (Just num) <- get >>= (return . Map.lookup (Ident counterName))
  let ctr = num + 1
  modify $ \m -> Map.insert (Ident counterName) ctr m
  return ("\n  %t" ++ show ctr ++ " = ", ctr)
