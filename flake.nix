{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
    ...
  }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      modules = [
        {nix.settings.experimental-features = ["nix-command" "flakes"];}
        ./configuration.nix
      ];
    };
  };
}
