{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RebindableSyntax  #-}

module Tags where

import           Fay.FFI
import           Fay.Text (Text, concat, concatMap, fromString)
import           Prelude  (foldl, map, ($), (++))

data Tag = Tag Text [Tag]  -- ^A named tag
         | Txt Text        -- ^Text content

render :: Tag  ->  Text
render (Tag t cs) = concat [ "<", t, ">", concat $ map render cs, "</", t, ">" ]
render (Txt t)    = t

(+>) ::  Tag ->  Tag -> Tag
(Tag t cs) +> c        = Tag t (cs ++ [c])
(Txt t   ) +> (Txt t') = Txt (concat [t,t'])
(Txt t   ) +> c        = Tag "p" [Txt t, c]

(++>) :: Tag -> [Tag] ->  Tag
f ++> tags = foldl (+>) f  tags

li :: Tag -> Tag
li t = Tag "li" [t]

ul :: Tag -> Tag
ul t = Tag "ul" [t]

ul0 :: Tag
ul0 = Tag "ul" []

p :: Tag -> Tag
p t = Tag "p" [t]

txt :: Text -> Tag
txt = Txt
