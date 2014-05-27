{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RebindableSyntax  #-}

module ATest where

import           DOM
import           Fay.Test
import           Fay.Text
import           Prelude
import           Tags

someTest :: Test
someTest = TestList [
  assertEqual "1 is equal to 1" (1 :: Int) 1
  ,assertEqual "1 is equal to 2" (1 :: Int) 2
  , TestList [
    assertEqual "1 is equal to 1" (1 :: Int) 1
    ,assertEqual "1 is equal to 2" (1 :: Int) 2
    ]
  ]

main :: Fay ()
main = do
  let res =  (toDOM someTest)
  ready $ html res (byId "test")
