module Handler.Fay where

import Import
import Yesod.Fay
import Fay.Convert (readFromFay)

fibs :: [Int]
fibs = 0 : 1 : zipWith (+) fibs (drop 1 fibs)

--handleBrowserFeatures :: forall t t1 t2. (t2 -> Bool -> t1) -> t -> t2 -> t1
-- The Show t on the left hand side is an example of duck typing in Haskell. As long as T implements the Show
-- protocol it is all right (currently t is a boolean, but that is going to change quickly, and we do not need to
-- know more here)
handleBrowserFeatures :: forall t t2 s. Show t => (t2 -> Bool -> HandlerT App IO s ) -> t -> t2 -> HandlerT App IO s
handleBrowserFeatures render q r = do
  liftIO $ putStrLn ("Query selector supported: " ++ (show q))
  render r $ False
                                   --  lift (liftIO $ putStrLn "Hello")
                                   --  render r $ False

onCommand :: CommandHandler App
onCommand render command =
    case readFromFay command of
      Just (GetFib index r) -> render r $ fibs !! index
      Just (PostQuerySelector querySelector r) -> handleBrowserFeatures render querySelector r
      Nothing               -> invalidArgs ["Invalid command"]
