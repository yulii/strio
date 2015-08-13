module TCP.Server
    ( run
    ) where

import Network
import Control.Monad
import System.IO
import System.Environment (getArgs)

import Control.Exception
import Control.Concurrent
import Prelude hiding (catch)

run = withSocketsDo $ do
  -- args <- getArgs
  -- let port = fromIntegral (read (head args) :: Int)
  soc <- listenOn $ PortNumber 8000
  putStrLn $ "start server, listening on: " ++ show 8000
  acceptLoop soc `finally` sClose soc

acceptLoop soc = do
  (hd, host, port) <- accept soc
  forkOS $ echoLoop hd
  acceptLoop soc

echoLoop hd = do
  sequence_ (repeat (do { -- ioアクションの無限リスト
                          l <- hGetLine hd;
                          hPutStrLn hd l;
                          hFlush hd
                     }))
  `catch` (\(SomeException e) -> return ())
  `finally` hClose hd
