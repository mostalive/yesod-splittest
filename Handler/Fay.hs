module Handler.Fay where

import Import
import Yesod.Fay
import Fay.Convert (readFromFay)
import Data.Time

handleBrowserFeatures :: forall t2 s. (t2 -> Bool -> HandlerT App IO s ) -> BrowserFeaturesList -> t2 -> HandlerT App IO s
handleBrowserFeatures render featuresFound r = do
  currentTime <- liftIO $ getCurrentTime -- we have to move the result from IO UTCTime to UTCTime, hence the arrow
  let featuresDetected = FeaturesDetected { featuresDetectedTimestamp = currentTime,
                                            featuresDetectedQuerySelector = False, -- legacy field, to be removed
                                            featuresDetectedDetectedFeatures = featuresFound}
  _ <- runDB $ insert featuresDetected
  render r $ True

onCommand :: CommandHandler App
onCommand render command =
    case readFromFay command of
      Just (PostQuerySelector passedChecks r) -> handleBrowserFeatures render (BrowserFeatures passedChecks) r
      Nothing               -> invalidArgs ["Invalid command"]
