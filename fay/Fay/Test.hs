{-# LANGUAGE CPP               #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RebindableSyntax  #-}
-- | A simple test framework for Fay
module Fay.Test where

import           Prelude
import           Tags

#ifdef FAY
import           Fay.Text  as T
import           FFI
#else
import           Data.Text
import           Fay.FFI
#endif

data Test = Test Assertion

type Description = Text
type FailureMessage = Text

data TestResult = TestSucceeds Description              -- ^Test succeeded, provides the test's description
                | TestFails Description FailureMessage  -- ^Test failed, provides test's description and error message

type Assertion = TestResult

log' :: a -> Fay ()
log' = ffi "(function(x) { if (console && console.log) console.log(x) })(%1)"

alert :: Text ->  Fay ()
alert =  ffi "alert(%1)"

-- | Assert that two terms evaluate to the same value
assertEqual :: (Eq a) => Description -> a -> a -> Assertion
assertEqual desc act exp =  if act == exp then
                              TestSucceeds desc
                            else
                              TestFails desc "Value are not equal"

-- | Runs given test and display its result in the given DOM node
runTestHTML :: Test -> Text -> Fay ()
runTestHTML (Test a) elementId = do
  let msg = case a of
        TestSucceeds d -> T.concat [ d,  " :PASS" ]
        TestFails d f  -> T.concat [ d , " :FAIL (" , f,  ")"]
  html (txt msg) (byId elementId)
