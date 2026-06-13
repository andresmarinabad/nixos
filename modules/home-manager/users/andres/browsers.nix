{ lib, ... }:

let
  bookmarks = import ../../lib/bookmarks.nix { inherit lib; };

  bookmarksList = [
    {
      name = "Personal";
      folder = true;
      children = [
        {
          name = "Mail";
          url = "https://mail.proton.me/u/0/inbox";
        }
        {
          name = "GitHub";
          url = "https://github.com/andresmarinabad?tab=repositories";
        }
      ];
    }
    {
      name = "NixOS";
      folder = true;
      children = [
        {
          name = "NixOS";
          url = "https://nixos.org";
        }
        {
          name = "Search NixOS pkgs";
          url = "https://search.nixos.org/packages";
        }
        {
          name = "MyNixOS";
          url = "https://mynixos.com/";
        }
      ];
    }
    {
      name = "3D";
      folder = true;
      children = [
        {
          name = "Thingiverse";
          url = "https://www.thingiverse.com/";
        }
        {
          name = "MakerWorld";
          url = "https://makerworld.com/es";
        }
        {
          name = "Printables";
          url = "https://www.printables.com/store";
        }
        {
          name = "Tinkercad";
          url = "https://www.tinkercad.com/";
        }
      ];
    }
  ];
in
{
  xdg.configFile."BraveSoftware/Brave-Browser/Default/Bookmarks" = {
    force = true;
    text = bookmarks.buildBookmarks bookmarksList;
  };

  programs.brave = {
    enable = true;
    extensions = [
      { id = "nngceckbapebfimnlniiiahkandclblb"; } # Bitwarden
    ];
  };
}
