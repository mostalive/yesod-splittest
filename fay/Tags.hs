{-# LANGUAGE EmptyDataDecls    #-}
{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RebindableSyntax  #-}

module Tags where

import           DOM
import           Fay.Text (Text, concat, concatMap, fromString)
import           FFI
import           Prelude  (fail, foldl, map, return, ($), (++), (.), (>>=))

data Node
data Event

data Tag = Tag [Attribute] Text [Tag]  -- ^A named tag
         | Txt Text        -- ^Text content

data Attribute = Attribute Text Text

render :: Tag  ->  Text
render (Tag [] t cs) = concat [ "<", t, ">", concat $ map render cs, "</", t, ">" ]
render (Tag at t cs) = concat [ "<", t, " ", concat $ map renderAt at,">",  concat $ map render cs, "</", t, ">" ]
render (Txt t)    = t

renderAt :: Attribute -> Text
renderAt (Attribute k v) = concat [k , "=\"", v , "\"" ]

setInnerHTML :: Node -> Text -> Fay ()
setInnerHTML = ffi "%1.innerHTML=%2"

byId :: Text -> Node
byId = ffi "document['getElementById'](%1)"

body :: Node
body = ffi "document.body"

-- |Delay function until DOM is ready
-- Uses `DOMContentLoaded` event so won't work on older browsers...
-- see http://stackoverflow.com/questions/799981/document-ready-equivalent-without-jquery
ready :: Fay ()  -> Fay ()
ready = ffi "document.addEventListener('DOMContentLoaded', %1)"

html :: Tag
     -> Node  -- ^Element Id to inject tag int
     -> Fay ()
html t el =
  setInnerHTML el (render t)

(+>) ::  Tag ->  Tag -> Tag
(Tag a t cs) +> c        = Tag a t (cs ++ [c])
(Txt t   ) +> (Txt t') = Txt (concat [t,t'])
(Txt t   ) +> c        = Tag [] "p" [Txt t, c]

(!>) :: Tag -> Attribute -> Tag
(Tag as t cs) !> a       = Tag (a:as) t cs
t             !> _       = t


(++>) :: Tag -> [Tag] ->  Tag
f ++> tags = foldl (+>) f tags

li :: Tag -> Tag
li t = Tag [] "li" [t]

ul :: Tag -> Tag
ul = Tag [] "ul" . (:[])

ol :: [ Tag ] -> Tag
ol tags = Tag [] "ol" tags

ol0 :: Tag
ol0 = Tag [] "ol" []

ul0 :: Tag
ul0 = Tag [] "ul" []

p :: Tag -> Tag
p t = Tag [] "p" [t]

txt :: Text -> Tag
txt = Txt

at :: Text -> Text ->  Attribute
at = Attribute

klass :: Text -> Attribute
klass c = Attribute "class" c
