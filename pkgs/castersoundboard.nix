# ./pkgs/castersoundboard.nix
{pkgs}:
pkgs.stdenv.mkDerivation {
  pname = "castersoundboard";
  version = "unstable-2016-01-15";

  src = pkgs.fetchFromGitHub {
    owner = "JupiterBroadcasting";
    repo = "CasterSoundboard";
    rev = "1a84315b3a3d4bdca1a4b784bd19460637f44438";
    sha256 = "sha256-YXM3QzOJxJZJ+tjbaXE0jWVhF9VshM1hRBsSMHhn8to=";
  };

  sourceRoot = "source/CasterSoundboard";

  nativeBuildInputs = with pkgs.qt5; [
    wrapQtAppsHook
    qmake
  ];

  buildInputs = with pkgs; [
    qt5.qtmultimedia
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
  ];

  enableParallelBuilding = true;

  # postInstall = ''
  #   wrapQtProgram "$out/bin/CasterSoundboard" \
  #     --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0"
  # '';

  qtWrapperArgs = [
    "--prefix"
    "GST_PLUGIN_SYSTEM_PATH_1_0"
    ":"
    "$GST_PLUGIN_SYSTEM_PATH_1_0"
  ];

  meta = with pkgs.lib; {
    description = "A soundboard for hot-keying and playing back sounds";
    homepage = "https://github.com/JupiterBroadcasting/CasterSoundboard";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
