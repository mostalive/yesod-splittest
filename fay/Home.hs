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

supportsQuerySelector :: Bool
supportsQuerySelector = documentSupports "querySelector"

registerFibonacciHandler :: Fay ()
registerFibonacciHandler = do
    input <- getElementById "fibindex"
    result <- getElementById "fibresult"

    onKeyUp input $ do
        indexS <- getAttribute "value" input
        putStrLn $ show $ indexS
        index <- parseInt indexS
        putStrLn $ show $ index
        call (GetFib index) $ setInnerHTML result . show

main :: Fay ()
main = do
    let qs1 = supportsQuerySelector -- let necessary to make the call happen?
    call (PostQuerySelector supportsQuerySelector)

    browserfeaturesElement <- getElementById "browserfeatures"

    if qs1
       then setInnerHTML browserfeaturesElement "your browser does not support query selector"
       else setInnerHTML browserfeaturesElement "queryselector supported"



    registerFibonacciHandler
