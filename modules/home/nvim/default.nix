{inputs, ...}: {
  perSystem = {
    pkgs,
    system,
    ...
  }: let
    otp = pkgs.beam.packages.erlang_26;
    elixir = otp.elixir_1_17;
    lexicalPackage = (inputs.lexical.lib.mkLexical {erlang = otp;}).override {
      inherit elixir;
      fodHash = "sha256-g6BZGJ33oBDXmjbb/kBfPhart4En/iDlt4yQJYeuBzw=";
    };
  in {
    packages.nvim = inputs.nixvim.legacyPackages.${system}.makeNixvimWithModule {
      inherit pkgs;
      module = import ./_config {inherit lexicalPackage pkgs;};
    };
  };

  flake.modules.homeManager.nvim = {
    pkgs,
    inputs,
    ...
  }: {
    home.packages = [inputs.self.packages.${pkgs.system}.nvim];
  };
}
