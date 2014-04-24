{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE EmptyDataDecls    #-}
module Home where

import Prelude
import Fay.FFI
import Language.Fay.Yesod
import SharedTypes

data Element

getElementById :: String -> Fay Element
getElementById = ffi "document.getElementById(%1)"

getAttribute :: String -> Element -> Fay String
getAttribute = ffi "%2[%1]"

setInnerHTML :: Element -> String -> Fay ()
setInnerHTML = ffi "%1.innerHTML=%2"

onKeyUp :: Element -> Fay () -> Fay ()
onKeyUp = ffi "%1.onkeyup=%2"

alert :: String -> Fay ()
alert = ffi "window.alert(%1)"

parseInt :: String -> Fay Int
parseInt = ffi "window.parseInt(%1, 10)"

-- useful documentation https://github.com/faylang/fay/wiki/Foreign-function-interface

documentSupports :: String -> Bool
documentSupports = ffi "!(typeof document[%1] == \"undefined\")"

hasEventListener :: Bool
hasEventListener = ffi "(typeof window['addEventListener'] == \"function\")"

hasRequestAnimationFrame :: Bool
hasRequestAnimationFrame = ffi "(typeof window['requestAnimationFrame'] == \"function\")"

hasLocalStorage :: Bool
hasLocalStorage = ffi "(typeof window['localStorage'] == \"object\")"

supportsQuerySelector :: Bool
supportsQuerySelector = documentSupports "querySelector"

-- hasClassList :: String -> Bool

showSupport :: Bool -> String -> String
showSupport True display = "<li>" ++ display ++ "</li>"
showSupport False _ = ""

emptyCallback :: Bool -> Fay ()
emptyCallback = ffi "2 + 3"

-- hack, all things with an instance should be able to print their type name
displayName :: BrowserSupports -> String
displayName = ffi "%1['instance']"

showLi :: BrowserSupports -> String
showLi bs = "<li>" ++ (displayName bs) ++ "</li>"

-- from Data.List, but haskell version is special - inlined.
-- this is a naive version, inspired by the comment in Data.List documentation but it works.
-- This could work as a quickcheck property against a smarter version
partition :: (a -> Bool) -> [a] -> ([a],[a])
partition p xs = (filter p xs, filter (not . p) xs)

main :: Fay ()
main = do
    let qs1 = supportsQuerySelector -- let necessary to make the call happen?
    call (PostQuerySelector supportsQuerySelector) emptyCallback -- we are not interested in the result

    let checks = [(AddEventListener, hasEventListener),
                  (QuerySelector, supportsQuerySelector),
                  (RequestAnimationFrame, hasRequestAnimationFrame),
                  (LocalStorage, hasLocalStorage)]

    let (passed, failed) = partition snd checks
    let supportedElementsLi = concat (map (showLi . fst) passed)

    let htm = "<ul>" ++ supportedElementsLi ++ "</ul>"
    browserfeaturesElement <- getElementById "detectedfeatures"
    setInnerHTML browserfeaturesElement htm
