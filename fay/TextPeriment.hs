{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RebindableSyntax #-}

module TextPeriment
(someString
) where


import Fay.Text (Text, fromString)
import Fay.Text as T
import Prelude (String)
import SomeString (someString)

someText :: T.Text
someText = T.concat ["some", " ", "text", pack someString]
