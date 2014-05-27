{-# LANGUAGE CPP               #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RebindableSyntax  #-}

-- | A simple test framework for Fay
module Fay.Test where

import           Prelude   as P
import           Tags

#ifdef FAY
import           Fay.Text  as T
import           FFI
#else
import           Data.Text
import           Fay.FFI
#endif

data Test = Test Assertion
          | TestList [ Test ]

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
assertEqual :: (Eq a) => Description -> a -> a -> Test
assertEqual desc act exp =  Test $ if act == exp then
                              TestSucceeds desc
                            else
                              TestFails desc "Value are not equal"


-- | Runs given test and returns its result as a DOM node
toDOM :: Test -> Tag
toDOM (TestList ts) = ol0 ++> (P.map toDOM ts)
toDOM (Test a) = case a of
  TestSucceeds d -> li (txt d)              !> klass "test-success"
  TestFails d f  -> li (txt d) +> p (txt f) !> klass "test-failure"
