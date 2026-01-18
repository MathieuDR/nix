{pkgs}: let
  dungeondraft-extracted = pkgs.requireFile {
    name = "Dungeondraft-1.2.0.1-Linux64.zip";
    sha256 = "sha256-SMNQ7XWSca2G4pieWFV97NMLv2Plqzu2bQlRC5MUwCY=";
    message = ''
      Please add Dungeondraft to the nix store:
        nix-store --add-fixed sha256 ~/path/to/Dungeondraft-1.2.0.1-Linux64.zip
    '';
  };
in
  pkgs.stdenv.mkDerivation {
    pname = "dungeondraft";
    version = "1.2.0.1";

    src = dungeondraft-extracted;

    nativeBuildInputs = [pkgs.unzip pkgs.makeWrapper];

    unpackPhase = ''
      unzip $src
    '';

    installPhase = ''
          mkdir -p $out/share/dungeondraft $out/bin $out/share/applications $out/share/pixmaps

          # Copy application files
          cp -r * $out/share/dungeondraft/
          chmod +x $out/share/dungeondraft/Dungeondraft.x86_64

          # Copy icon
          cp $out/share/dungeondraft/Dungeondraft.png $out/share/pixmaps/dungeondraft.png

          # Create wrapper using steam-run
          makeWrapper ${pkgs.steam-run}/bin/steam-run $out/bin/dungeondraft \
            --add-flags "$out/share/dungeondraft/Dungeondraft.x86_64" \
            --chdir "$out/share/dungeondraft"

          # Create desktop file
          cat > $out/share/applications/dungeondraft.desktop << EOF
      [Desktop Entry]
      Version=1.0
      Type=Application
      Name=Dungeondraft
      Comment=Tabletop encounter map creation tool
      Exec=$out/bin/dungeondraft
      Icon=dungeondraft
      Terminal=false
      Categories=Graphics;Game;
      EOF
    '';

    meta = with pkgs.lib; {
      description = "Dungeondraft map maker";
      platforms = platforms.linux;
    };
  }
