-- | Bridge to node.js
module Fay.Node where

import           FFI

exit :: Int -> Fay ()
exit = ffi "process.exit(%1)"
