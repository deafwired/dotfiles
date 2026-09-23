{
  coreutils,
  gnused,
  git,
  lib,
  stdenv,
  maven,
  makeWrapper,
  openjdk,
  libGL,
  alsa-lib,
  makeDesktopItem,
  copyDesktopItems,
  imagemagick,
  cacert,
}:

# nixpkgs only packages tagged Forge releases; this always builds Forge's
# rolling "daily-snapshots" branch (master) instead. It clones and builds
# live at build time (no fetched source hash, no maven-dependency hash) so
# every rebuild picks up whatever is newest on GitHub. That requires
# `nix.settings.sandbox = "relaxed";` (set in ./modules/common.nix) so this
# derivation can opt out of the network-less sandbox via __noChroot.
stdenv.mkDerivation {
  pname = "forge-mtg";
  version = "unstable";

  __noChroot = true;

  nativeBuildInputs = [
    git
    maven
    makeWrapper
    copyDesktopItems
    imagemagick
  ];

  # __noChroot builds don't get Nix's usual sandboxed CA-cert wiring, so git
  # and maven need to be pointed at a CA bundle explicitly to reach https.
  env = {
    GIT_SSL_CAINFO = "${cacert}/etc/ssl/certs/ca-bundle.crt";
    SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";
    NIX_SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";
  };

  unpackPhase = ''
    runHook preUnpack
    git clone --depth 1 https://github.com/Card-Forge/forge.git source
    sourceRoot=source
    runHook postUnpack
  '';

  # launch4j downloads and runs a native binary during the package phase.
  patches = [ ./forge-mtg-no-launch4j.patch ];

  doCheck = false; # Needs a running Xorg

  buildPhase = ''
    runHook preBuild
    mvn -B package \
      -Dmaven.repo.local="$TMPDIR/m2" \
      -DskipTests \
      -pl :adventure-editor,:forge-gui-desktop,:forge-gui-mobile-dev --also-make
    runHook postBuild
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "forge";
      exec = "forge";
      actions = {
        forge-adventure = {
          exec = "forge-adventure";
          name = "Play Adventure";
        };
        forge-adventure-editor = {
          exec = "forge-adventure-editor";
          name = "Adventure Editor";
        };
        forge-classic = {
          exec = "forge";
          name = "Play Classic";
        };
      };
      icon = "forge-mtg";
      comment = "Magic: the Gathering card game with rules enforcement";
      desktopName = "Forge MTG";
      genericName = "Card Game";
      categories = [
        "Game"
        "BoardGame"
      ];
      keywords = [
        "Magic"
        "MTG"
        "Card Game"
        "Trading Card Game"
        "TCG"
      ];
    })
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/share/forge
    cp -a \
      forge-gui-desktop/target/forge.sh \
      forge-gui-desktop/target/forge-gui-desktop-*-jar-with-dependencies.jar \
      forge-gui-mobile-dev/target/forge-adventure.sh \
      forge-gui-mobile-dev/target/forge-gui-mobile-dev-*-jar-with-dependencies.jar \
      adventure-editor/target/adventure-editor-jar-with-dependencies.jar \
      forge-gui/res \
      $out/share/forge
    cp adventure-editor/target/adventure-editor.sh $out/share/forge/forge-adventure-editor.sh

    mkdir -p $out/share/icons/hicolor/128x128/apps
    magick AppIcon.png -resize 128x128 $out/share/icons/hicolor/128x128/apps/forge-mtg.png

    runHook postInstall
  '';

  preFixup = ''
    for commandToInstall in forge forge-adventure forge-adventure-editor; do
      chmod 555 $out/share/forge/$commandToInstall.sh
      PREFIX_CMD=""
      if [ "$commandToInstall" = "forge-adventure" ]; then
        PREFIX_CMD="--prefix LD_LIBRARY_PATH : ${
          lib.makeLibraryPath (
            [
              libGL
            ]
            ++ lib.optionals (lib.meta.availableOn stdenv.hostPlatform alsa-lib) [ alsa-lib ]
          )
        }"
      fi

      makeWrapper $out/share/forge/$commandToInstall.sh $out/bin/$commandToInstall \
        --prefix PATH : ${
          lib.makeBinPath [
            coreutils
            openjdk
            gnused
          ]
        } \
        --set JAVA_HOME ${openjdk}/lib/openjdk \
        --set SENTRY_DSN "" \
        $PREFIX_CMD
    done
  '';

  meta = {
    description = "Magic: the Gathering card game with rules enforcement (rolling snapshot build)";
    homepage = "https://card-forge.github.io/forge";
    license = lib.licenses.gpl3Plus;
  };
}
