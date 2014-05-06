{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RebindableSyntax #-}
module SharedIDs where

--import Prelude
#ifdef FAY
import FFI
import Fay.Text

#else
--import Language.Fay.FFI
import Data.Text
import Data.String
import Text.Blaze

instance ToMarkup CssID where
  toMarkup (CssID t) = toMarkup t

#endif

data CssID = CssID Text

featureCountID :: CssID
featureCountID = CssID "featurecount"

detectedFeaturesID :: CssID
detectedFeaturesID = CssID "detectedFeatures"

unsupportedFeaturesID :: CssID
unsupportedFeaturesID = CssID "supportedFeatures"
