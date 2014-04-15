module Handler.Fay where

import Import
import Yesod.Fay
import Fay.Convert (readFromFay)
import Data.Time

fibs :: [Int]
fibs = 0 : 1 : zipWith (+) fibs (drop 1 fibs)

--handleBrowserFeatures :: forall t t1 t2. (t2 -> Bool -> t1) -> t -> t2 -> t1

-- protocol it is all right (currently t is a boolean, but that is going to change quickly, and we do not need to
-- know more here)
handleBrowserFeatures :: forall t2 s. (t2 -> Bool -> HandlerT App IO s ) -> Bool -> t2 -> HandlerT App IO s
handleBrowserFeatures render q r = do
  liftIO $ putStrLn ("Query selector supported: " ++ (show q))
  currentTime <- liftIO $ getCurrentTime -- we have to move the result from IO UTCTime to UTCTime, hence the arrow
  let featuresDetected = FeaturesDetected currentTime q
  _ <- runDB $ insert featuresDetected
  render r $ False
                                   --  lift (liftIO $ putStrLn "Hello")
                                   --  render r $ False

onCommand :: CommandHandler App
onCommand render command =
    case readFromFay command of
      Just (GetFib index r) -> render r $ fibs !! index
      Just (PostQuerySelector querySelector r) -> handleBrowserFeatures render querySelector r
      Nothing               -> invalidArgs ["Invalid command"]
