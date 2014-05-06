{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE EmptyDataDecls    #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RebindableSyntax #-}

module Home where

import Prelude ((>>), Int, Bool(True, False), map, (.), filter, not, (>>=), fail, return, length,show, Show, snd, fst, print )
import Fay.FFI
import Fay.Text as T
import DOM
import Language.Fay.Yesod hiding (fromString, Text)
import SharedTypes

setInnerHTML :: Element -> Text -> Fay ()
setInnerHTML = ffi "%1.innerHTML=%2"

-- useful documentation https://github.com/faylang/fay/wiki/Foreign-function-interface

documentSupports :: Text -> Bool
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

showSupport :: Bool -> Text -> Text
showSupport True display = T.concat ["<li>", display,  "</li>"]
showSupport False _ = ""

emptyCallback :: Bool -> Fay ()
emptyCallback = ffi "2 + 3"

log :: Text -> Fay()
log = ffi "console.log(%1)"

showText :: Show a => a -> Text
showText = pack . show

-- hack, all things with an instance should be able to print their type name
displayName :: BrowserSupports -> Text
displayName = ffi "%1['instance']"

showLi :: BrowserSupports -> Text
showLi bs = T.concat [ "<li>", (displayName bs), "</li>"]


listOf _ [] = "<p>No items in this category</p>"
listOf fn lst = T.concat ["<ul>" , (T.concat (Prelude.map (showLi . fn) lst)) , "</ul>"]


-- from Data.List, but haskell version is special - inlined.
-- this is a naive version, inspired by the comment in Data.List documentation but it works.
-- This could work as a quickcheck property against a smarter version
partition :: (a -> Bool) -> [a] -> ([a],[a])
partition p xs = (filter p xs, filter (not . p) xs)

displayFeatures fn lst (CssID elementId) =  do
    let htm = listOf fn lst
    el <- getElementById elementId
    setInnerHTML el htm

displayScore checks passed (CssID elementId) = do
    let total_count = Prelude.length checks
    let passed_count = Prelude.length passed
    el <- getElementById elementId
    let html = T.concat [(showText passed_count), "/", (showText total_count)]
    setInnerHTML el html

data HtmlElement = Elem Name [Attribute] [Content]
data Content = CElem HtmlElement | CText Text
data Attribute = Attr Key Value
--     deriving (Show) -- No Show for Text
type Name = Text
type Key = Text
type Value = Text


--- (Ul (Li (A (Href "http://bla") "text")))

main :: Fay ()
main = do
    let qs1 = supportsQuerySelector -- let necessary to make the call happen?


    let checks = [(AddEventListener, hasEventListener),
                  (QuerySelector, supportsQuerySelector),
                  (RequestAnimationFrame, hasRequestAnimationFrame),
                  (LocalStorage, hasLocalStorage)]

    let (passed, failed) = partition snd checks

    displayScore checks passed featureCountID
    displayFeatures fst passed detectedFeaturesID -- still strings here. should be shared constants between Fay and Hamlet
    displayFeatures fst failed unsupportedFeaturesID -- possibly intruce newtype CssId = String to make sure we don't mix css identifiers and classes

    --log (showText (Attr "Href" "http://bla"))
    call (PostQuerySelector (Prelude.map fst passed)) emptyCallback -- we are not interested in the result
