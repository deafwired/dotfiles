{
  lib,
  appimageTools,
  fetchurl,
}:

let
  pname = "learnharness";
  version = "0.7.0";

  src = fetchurl {
    url = "https://github.com/amosblomqvist/learnharness/releases/download/v${version}/LearnHarness-${version}-x86_64.AppImage";
    hash = "sha256-dyteBNOAy+inKnXb/yaa62pH9NRFJxGx2oBZqHIGdhM=";
  };

  appimageContents = appimageTools.extractType2 { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  # The AppImage's .desktop runs AppRun directly; point it at the wrapper and
  # ask Electron to use native Wayland on Hyprland instead of XWayland.
  extraInstallCommands = ''
    install -Dm644 ${appimageContents}/learnharness.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/learnharness.desktop \
      --replace-fail 'Exec=AppRun --no-sandbox %U' 'Exec=learnharness --ozone-platform-hint=auto %U'
    install -Dm644 ${appimageContents}/usr/share/icons/hicolor/512x512/apps/learnharness.png \
      -t $out/share/icons/hicolor/512x512/apps
  '';

  meta = {
    description = "Agent harness for learning: adaptive teaching, practice and a persistent knowledge graph";
    homepage = "https://learnharness.ai/";
    changelog = "https://github.com/amosblomqvist/learnharness/releases/tag/v${version}";
    license = lib.licenses.agpl3Only;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    mainProgram = "learnharness";
    platforms = [ "x86_64-linux" ];
  };
}
