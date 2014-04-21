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

showLi :: BrowserSupports -> String
showLi bs = "<li>" ++ (show bs) ++ "</li>"

main :: Fay ()
main = do
    let qs1 = supportsQuerySelector -- let necessary to make the call happen?
    call (PostQuerySelector supportsQuerySelector) emptyCallback -- we are not interested in the result

    let checks = [(AddEventListener, hasEventListener),
                  (QuerySelector, supportsQuerySelector),
                  (RequestAnimationFrame, hasRequestAnimationFrame),
                  (LocalStorage, hasLocalStorage)]
    let b2m = map showLi (allValues (map bool2Maybe checks))
    let ael = hasEventListener

    let animFrame = hasRequestAnimationFrame
    let localStor = hasLocalStorage
    let supportHtm = concat [(showSupport qs1 "querySelector"), (showSupport ael "addEventListener"), (showSupport localStor "local Storage"), (showSupport animFrame "requestAnimationFrame") ]
    let htm = "<ul>" ++ supportHtm ++ "</ul>"

    browserfeaturesElement <- getElementById "browserfeatures"
    setInnerHTML browserfeaturesElement htm
