{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RebindableSyntax #-}

module TextPeriment where

import Fay.Text (Text, fromString)
import Fay.Text as T
import Prelude hiding ((++))
--import Language.Fay.Yesod (fromString)

someText :: Text
someText = T.concat ["some", " ", "text"]

someString :: String
someString =  unpack "some string"
