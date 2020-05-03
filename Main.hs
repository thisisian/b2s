module Main where

import Data.Char
import System.Environment
import System.Exit
import Numeric

data NumSystem = Bin | Oct | Dec | Hex

main :: IO ()
main = do
  args <- getArgs
  case args of
    ("-h":_) -> printHelp
    ("--help":_) -> printHelp
    [] -> printHelp
    (input:opts) -> case parseInput input of
      (Left err) -> die err
      (Right x) -> case parseOpts opts of
        (Left err) -> die err
        (Right to) -> do
          putStrLn (convert to x)
          exitSuccess

printHelp :: IO ()
printHelp = do
  putStrLn helpMessage
  exitSuccess

helpMessage :: String
helpMessage =
  "Examples:\n\n" ++
  "Binary number to decimal:\n" ++
  "$ b2s b1101\n" ++
  "> 21\n\n" ++
  "Octal number to hex:\n" ++
  "$ b2s o111 -tx\n" ++
  "> 0x49\n\n" ++
  "Hex number to binary:\n" ++
  "$ b2s 0xff -tb\n" ++
  "> b11111111\n\n" ++
  "Decimal to binary:\n"  ++
  "$ b2s 100 -tb\n" ++
  "> b1100100"

parseOpts :: [String] -> Either String NumSystem
parseOpts as = case as of
  [] -> Right Dec
  ("-tb":_) -> Right Bin
  ("-to":_) -> Right Oct
  ("-td":_) -> Right Dec
  ("-tx":_) -> Right Hex
  (s:_)     -> Left $ "Invalid option: " ++ s

parseInput :: String -> Either String Integer
parseInput s = case map toLower s of
  ('b':s')     -> parseBin s'
  ('o':s')     -> parseOct s'
  ('d':s')     -> parseDec s'
  ('0':'x':s') -> parseHex s'
  s'           -> parseDec s'

convert :: NumSystem -> Integer -> String
convert Bin x = 'b' : showIntAtBase 2 (\x -> case x of
                                           0 -> '0'
                                           1 -> '1'
                                           _ -> undefined) x ""
convert Oct x = 'o':showOct x ""
convert Dec x = show x
convert Hex x = '0':'x':showHex x ""

parseHex :: String -> Either String Integer
parseHex s =
  if null v then Left "Invalid octal number" else Right . fst . head $ v
 where v = readHex s

parseBin :: String -> Either String Integer
parseBin s = parseBin' s 0
 where parseBin' (c:cs) acc =
         let v = case c of
               '0' -> Just 0
               '1' -> Just 1
               _ -> Nothing
         in case v of
           Nothing -> Left "Invalid binary number"
           Just v -> parseBin' cs (2*acc + v)
       parseBin' [] acc = Right acc

parseDec :: String -> Either String Integer
parseDec s = Right $ read s

parseOct :: String -> Either String Integer
parseOct s =
  if null v then Left "Invalid octal number" else Right . fst . head $ v
 where v = readOct s
