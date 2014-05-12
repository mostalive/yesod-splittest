{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RebindableSyntax  #-}

module ATest where

import           Fay.Test
import           Fay.Text
import           Prelude
import           Tags

someTest :: Test
someTest = Test $ assertEqual "1 is equal to 1" (1 :: Int) 1

main :: Fay ()
main = ready $ runTestHTML someTest "test"
