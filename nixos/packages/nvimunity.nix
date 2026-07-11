{
  lib,
  makeWrapper,
  runCommand,
  fetchurl,
  bash,
  jq,
}:
let
  src = fetchurl {
    url = "https://raw.githubusercontent.com/apyra/nvim-unity-standalone/master/nvim-unity-linux/appimage/usr/bin/nvimunity.sh";
    hash = "sha256-vbkSafWP5whJBKrFRYzCLUNE0xni07t/2+rlhg5hFxk=";
  };
  binName = "nvimunity";
  deps = [
    bash
    jq
  ];
in
runCommand binName
  {
    nativeBuildInputs = [ makeWrapper ];
    meta = {
      description = "Neovim external editor integration for Unity";
      mainProgram = binName;
    };
  }
  ''
    mkdir -p $out/bin
    install -m +x ${src} $out/bin/${binName}
    wrapProgram $out/bin/${binName} \
      --prefix PATH : ${lib.makeBinPath deps}
  ''
