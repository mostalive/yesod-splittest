{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE DeriveDataTypeable #-}
module SharedTypes where

import Prelude
import Data.Data
import Language.Fay.Yesod
#ifdef FAY
import FFI
import Fay.Text as T
#else
--import Language.Fay.FFI
import Database.Persist.TH
import Data.Text as T
derivePersistField "BrowserFeaturesList"
#endif

data BrowserSupports = AddEventListener | QuerySelector | RequestAnimationFrame | LocalStorage
    deriving (Read, Show, Typeable, Data)

data MBrowserSupports = Maybe BrowserSupports

data BrowserFeaturesList = BrowserFeatures [BrowserSupports]
    deriving (Read, Show, Typeable, Data)

data Command = PostQuerySelector [BrowserSupports] (Returns Bool)
    deriving (Read, Typeable, Data)

data CssID = CssID T.Text

featureCountID :: CssID
featureCountID = CssID (T.pack "featurecount")
