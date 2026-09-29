{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  wayland-scanner,
  qt6,
  wayland,
  libxkbcommon,
  libei,
  valent,
}:

# xdg-desktop-portal doesn't ship a RemoteDesktop backend for wlroots-based
# compositors (Hyprland, niri, ...), so KDE Connect can't move the mouse or
# type on them. This backend fills that one interface by injecting input
# through zwp_virtual_keyboard_manager_v1 / zwlr_virtual_pointer_manager_v1.
# Not packaged in nixpkgs; upstream only documents a local ~/.local install.
stdenv.mkDerivation {
  pname = "hypr-kdeconnect-fix";
  version = "0-unstable-2026-09-24";

  src = fetchFromGitHub {
    owner = "gfhdhytghd";
    repo = "hypr-kdeconnect-fix";
    rev = "362b904235c1b1d679eef73cbd5ad08d313d8954";
    hash = "sha256-fswdn3iq1iCXALLWC/p5EgRYbHIMgNHWEhxEtbHtCFY=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    wayland-scanner
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    wayland
    libxkbcommon
    libei
  ];

  postPatch = ''
    substituteInPlace src/security_policy.hpp \
      --replace-fail "if (isDeskflowExecutablePath(executablePath))" \
        "if (executablePath == QStringLiteral(\"${valent}/bin/.valent-wrapped\") || isDeskflowExecutablePath(executablePath))"
  '';

  postInstall = ''
    sed -i "/^\(PrivateTmp\|ProtectSystem\|ProtectHome\)=/d" $out/share/systemd/user/hypr-kdeconnect-portal.service
  '';

  doCheck = true;

  meta = {
    description = "xdg-desktop-portal RemoteDesktop backend that makes KDE Connect remote input work on Hyprland/wlroots compositors";
    homepage = "https://github.com/gfhdhytghd/hypr-kdeconnect-fix";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "hypr-kdeconnect-portal";
  };
}
