# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
pkgs: {
  example = pkgs.callPackage ./example { };
  # code-cursor = pkgs.callPackage ./code-cursor.nix {
  #   vscode-generic = pkgs.path + "/pkgs/applications/editors/vscode/generic.nix";
  # };
  gemini-cli = pkgs.callPackage ./gemini-cli.nix { };

}
