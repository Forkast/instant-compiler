module Main where

import System.IO
import System.FilePath.Posix
import System.Environment
import Control.Monad.State
import Data.Map as Map
import Grammar.LexInstant
import Grammar.ParInstant
import Grammar.AbsInstant
import Grammar.ErrM

import Util.LLVMSkel

main :: IO ()
main = do
  args <- getArgs
  filename <- return $ head args
  file <- openFile filename ReadMode
  input <- hGetContents file
  case (pProgram (myLexer input)) of
    (Bad why) -> putStrLn why
    (Ok tree) -> do
      (output, stack) <- return $ evalState (transProgram tree) (singleton (Ident counterName) 0)
      writefilename <- return $ replaceExtension filename "ll"
      writeFile writefilename output
