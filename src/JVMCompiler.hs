module Main where

import System.IO
import System.Environment
import Control.Monad.State
import Data.Map as Map
import Grammar.LexInstant
import Grammar.ParInstant
import Grammar.AbsInstant
import Grammar.ErrM

import Util.JVMInstant

main :: IO ()
main = do
  args <- getArgs
  file <- openFile (head args) ReadMode
  input <- hGetContents file
  case (pProgram (myLexer input)) of
    (Bad why) -> putStrLn why
    (Ok tree) -> do
      (output, stack) <- return $ evalState (transProgram tree) (singleton (Ident counterName) 0)
      putStrLn output
