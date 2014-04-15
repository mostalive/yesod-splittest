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

documentSupports :: String -> Fay Bool
documentSupports = ffi "!(typeof document[%1] == \"undefined\")"

supportsQuerySelector :: Fay Bool
supportsQuerySelector = documentSupports "querySelector"

main :: Fay ()
main = do
    --putStrLn supportsQuerySelector
    putStrLn "Hello Console"
    if supportsQuerySelector -- if seems broken, always print the first, regardless of value
       then putStrLn "query selector supported"
       else putStrLn "no query selector"
    -- qs1 <- supportsQuerySelector
    -- qs <- getAttribute "value" qs1
    putStrLn $ show $  supportsQuerySelector -- prints true, as expected
    putStrLn $ show  $ documentSupports "querySelector" -- prints true as well
    input <- getElementById "fibindex"
    result <- getElementById "fibresult"


    onKeyUp input $ do
        indexS <- getAttribute "value" input
        putStrLn $ show $ indexS
        index <- parseInt indexS
        putStrLn $ show $ index
--        call (GetFib index) $ setInnerHTML result . show
        call (PostQuerySelector True) $ setInnerHTML result . show
