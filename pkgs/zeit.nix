{pkgs}:
pkgs.buildGoModule rec {
  pname = "zeit";
  version = "1.0.1";

  src = pkgs.fetchFromGitHub {
    owner = "mrusme";
    repo = "zeit";
    rev = "v${version}";
    sha256 = "sha256-EfsH0U2zHnblK3f9ysmqpqyonQKPKr3tpjZgWWiORtE=";
  };

  vendorHash = "sha256-qhpWOb1VpEidsgaA3sMnvEl2RD/uR4cTaD8aT0fYOAU=";

  ldflags = [
    "-X github.com/mrusme/zeit/z.VERSION=${version}"
  ];

  meta = {
    description = "Zeit, erfassen. A command line tool for tracking time spent on tasks & projects.";
    mainProgram = "zeit";
    homepage = "https://github.com/mrusme/zeit";
  };
}
