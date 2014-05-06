{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE OverloadedStrings #-}
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
import Text.Blaze
derivePersistField "BrowserFeaturesList"

instance ToMarkup CssID where
  toMarkup (CssID t) = toMarkup t

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
featureCountID = CssID "featurecount"

detectedFeaturesID :: CssID
detectedFeaturesID = CssID "detectedFeatures"

unsupportedFeaturesID :: CssID
unsupportedFeaturesID = CssID "supportedFeatures"
