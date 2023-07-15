{
  inputs.deploy-rs.url = "github:serokell/deploy-rs";
  inputs.home-manager.url = "github:nix-community/home-manager";

  outputs = { self, nixpkgs, deploy-rs, home-manager }: {
    deploy.nodes.test = {
      hostname = "";
      profiles.hello = {
        user = "";
        path = deploy-rs.lib.x86_64-linux.activate.custom
          nixpkgs.legacyPackages.x86_64-linux.hello "./bin/hello";
      };
      profiles.test = {
        user = "";
        path = deploy-rs.lib.x86_64-linux.activate.home-manager
          (home-manager.lib.homeManagerConfiguration {
            pkgs = nixpkgs.legacyPackages.x86_64-linux;
            modules = [
              (

                { config, pkgs, ... }:

                {
                  # Home Manager needs a bit of information about you and the
                  # paths it should manage.
                  home.username = "";
                  home.homeDirectory = "/home/";

                  # This value determines the Home Manager release that your
                  # configuration is compatible with. This helps avoid breakage
                  # when a new Home Manager release introduces backwards
                  # incompatible changes.
                  #
                  # You can update Home Manager without changing this value. See
                  # the Home Manager release notes for a list of state version
                  # changes in each release.
                  home.stateVersion = "23.05";

                  # Let Home Manager install and manage itself.
                  programs.home-manager.enable = true;
                })
            ];
          });
      };
    };

    deploy = {
      sshUser = "";
      sshOpts = [ "-o" "StrictHostKeyChecking=no" ];
      remoteBuild = true;
    };

    checks =
      builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy)
      deploy-rs.lib;
  };
}
