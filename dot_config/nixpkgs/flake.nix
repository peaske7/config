{
  description = "Jay's configs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/master";
    home-manager.url = "github:nix-community/home-manager";
  };

  outputs = inputs @ { self, nixpkgs, home-manager }: {
    homeConfigurations = {
      PDYMBP-00401 = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = inputs.nixpkgs.legacyPackages.aarch64-darwin;
        modules = [ ./PDYMBP-00401.nix ];
      };
    };
  };
}
