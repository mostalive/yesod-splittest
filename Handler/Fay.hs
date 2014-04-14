module Handler.Fay where

import Import
import Yesod.Fay
import Fay.Convert (readFromFay)

fibs :: [Int]
fibs = 0 : 1 : zipWith (+) fibs (drop 1 fibs)

handleBrowserFeatures :: forall t t1 t2. (t2 -> Bool -> t1) -> t -> t2 -> t1
handleBrowserFeatures render q r = render r $ False

onCommand :: CommandHandler App
onCommand render command =
    case readFromFay command of
      Just (GetFib index r) -> render r $ fibs !! index
      Just (PostQuerySelector querySelector r) -> handleBrowserFeatures render querySelector r
      Nothing               -> invalidArgs ["Invalid command"]
