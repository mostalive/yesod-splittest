{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE DeriveDataTypeable #-}
module SharedTypes where

import Prelude
import Data.Data
import Language.Fay.Yesod
#ifdef FAY
import FFI
-- form Haskell Base Data-Maybe, since we don't have a complete maybe in Fay
-- Defined conditionally so we do not pollute namespaces in Yesod
-- TODO extract to a Fay Library, or contribute to Fay.Control.Monad
-- | The 'catMaybes' function takes a list of 'Maybe's and returns
-- -- a list of all the 'Just' values.
catMaybes :: [Maybe a] -> [a]
catMaybes ls = [x | Just x <- ls]
#else
--import Language.Fay.FFI
import Data.Maybe (catMaybes)
import Database.Persist.TH
derivePersistField "BrowserFeaturesList"
#endif

data BrowserSupports = AddEventListener | QuerySelector | RequestAnimationFrame | LocalStorage
    deriving (Read, Show, Typeable, Data)

data MBrowserSupports = Maybe BrowserSupports

data BrowserFeaturesList = BrowserFeatures [BrowserSupports]
    deriving (Read, Show, Typeable, Data)

bool2Maybe :: (a, Bool) -> Maybe a
bool2Maybe (a, True) = Just a
bool2Maybe (_, False) = Nothing

allValues :: [Maybe a] -> [a]
allValues = catMaybes

data Command = GetFib Int (Returns Int) |
               PostQuerySelector [BrowserSupports] (Returns Bool)
    deriving (Read, Typeable, Data)
