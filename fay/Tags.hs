{-# LANGUAGE EmptyDataDecls    #-}
{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RebindableSyntax  #-}

module Tags where

import           DOM
import           Fay.FFI
import           Fay.Text (Text, concat, concatMap, fromString)
import           Prelude  (fail, foldl, map, return, ($), (++), (.), (>>=))

data Node

data Tag = Tag Text [Tag]  -- ^A named tag
         | Txt Text        -- ^Text content

render :: Tag  ->  Text
render (Tag t cs) = concat [ "<", t, ">", concat $ map render cs, "</", t, ">" ]
render (Txt t)    = t

setInnerHTML :: Node -> Text -> Fay ()
setInnerHTML = ffi "%1.innerHTML=%2"

byId :: Text -> Fay Node
byId = ffi "document['getElementById'](%1)"

html :: Tag
     -> Text  -- ^Element Id to inject tag int
     -> Fay ()
html t el = do
  element <- byId el
  setInnerHTML element (render t)

(+>) ::  Tag ->  Tag -> Tag
(Tag t cs) +> c        = Tag t (cs ++ [c])
(Txt t   ) +> (Txt t') = Txt (concat [t,t'])
(Txt t   ) +> c        = Tag "p" [Txt t, c]

(++>) :: Tag -> [Tag] ->  Tag
f ++> tags = foldl (+>) f  tags

li :: Tag -> Tag
li t = Tag "li" [t]

ul :: Tag -> Tag
ul = Tag "ul" . (:[])

ul0 :: Tag
ul0 = Tag "ul" []

p :: Tag -> Tag
p t = Tag "p" [t]

txt :: Text -> Tag
txt = Txt
