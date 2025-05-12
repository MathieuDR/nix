{pkgs}:
pkgs.buildGoModule rec {
  pname = "zeit";
  version = "0.0.9";

  src = pkgs.fetchFromGitHub {
    owner = "mrusme";
    repo = "zeit";
    rev = "v${version}";
    sha256 = "sha256-CRECjhTHen4bIHZmQ2scL7cSuaxn5LKhok4dlXkOIpU=";
  };

  vendorHash = "sha256-SObUqLESRDyqqYzIIh9zdASXs6+uxHIZg7XMGn98mvk=";

  ldflags = [
    "-X github.com/mrusme/zeit/z.VERSION=${version}"
  ];

  meta = {
    description = "Zeit, erfassen. A command line tool for tracking time spent on tasks & projects.";
    mainProgram = "zeit";
    homepage = "https://github.com/mrusme/zeit";
  };
}
