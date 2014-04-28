{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE DeriveDataTypeable #-}
module SharedTypes where

import Prelude
import Data.Data
import Language.Fay.Yesod
#ifdef FAY
import FFI

#else
--import Language.Fay.FFI
import Database.Persist.TH
derivePersistField "BrowserFeaturesList"
#endif

data BrowserSupports = AddEventListener | QuerySelector | RequestAnimationFrame | LocalStorage
    deriving (Read, Show, Typeable, Data)

data MBrowserSupports = Maybe BrowserSupports

data BrowserFeaturesList = BrowserFeatures [BrowserSupports]
    deriving (Read, Show, Typeable, Data)

data Command = PostQuerySelector [BrowserSupports] (Returns Bool)
    deriving (Read, Typeable, Data)
