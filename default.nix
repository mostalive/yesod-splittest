{ haskellPackages ? (import <nixpkgs> {}).haskellPackages }:
let
  inherit (haskellPackages) cabal cabalInstall_1_18_0_3
    text mtl transformers yesod fay yaml yesodAuth yesodForm yesodStatic yesodCore persistentPostgresql
    aeson blazeBuilder blazeHtml blazeMarkup exceptions hspec httpTypes HUnit parsec systemFileio systemFilepath time wai waiAppStatic
    shakespeareJs utf8String monadLoops dataDefault pureMD5
    ; # Haskell dependencies for project on first two lines, then shakespeare, then yesod-fay

shakespeare = cabal.mkDerivation (self: {
  pname = "shakespeare";
  version = "2.0.0.1";
  sha256 = "0c8pkswfm2b940vxincivkk8ibpv13jvf3irk740lmlra0h8bp7a";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    aeson blazeBuilder blazeHtml blazeMarkup exceptions httpTypes
    parsec systemFileio systemFilepath text time transformers wai
    waiAppStatic
  ];
  testDepends = [
    aeson blazeHtml blazeMarkup exceptions hspec HUnit parsec
    systemFileio systemFilepath text time transformers
  ];
  meta = {
    homepage = "http://www.yesodweb.com/book/shakespearean-templates";
    description = "A toolkit for making compile-time interpolated templates";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
});

yesodFay = cabal.mkDerivation (self: {
  pname = "yesod-fay";
  version = "0.4.0.7";
  sha256 = "1dlrqj3m9ng0jrhnyqcxjkzjkfpqq2wlprlk5wjkcc52n638ls1k";
  buildDepends = [
    aeson dataDefault fay monadLoops pureMD5 shakespeareJs
    systemFileio systemFilepath text transformers utf8String yesodCore
    yesodForm yesodStatic
  ];
  meta = {
    homepage = "https://github.com/fpco/yesod-fay";
    description = "Utilities for using the Fay Haskell-to-JS compiler with Yesod";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
});


in cabal.mkDerivation (self: {
  pname = "project-name";
  version = "1.0.0";
  src = ./.;
  buildDepends = [
    # As imported above
    text mtl transformers yesod fay yaml  yesodAuth yesodForm yesodStatic yesodCore shakespeare persistentPostgresql yesodFay
  ];
  buildTools = [ cabalInstall_1_18_0_3 ];
  enableSplitObjs = false;
})
