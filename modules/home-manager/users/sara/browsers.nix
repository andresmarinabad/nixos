{ lib, ... }:

let
  bookmarks = import ../../lib/bookmarks.nix { inherit lib; };

  bookmarksList = [
    {
      name = "Google";
      url = "https://www.google.com";
    }
    {
      name = "YouTube";
      url = "https://www.youtube.com";
    }
  ];
in
{
  xdg.configFile."chromium/Default/Bookmarks" = {
    force = true;
    text = bookmarks.buildBookmarks bookmarksList;
  };

  programs.chromium = {
    enable = true;
    commandLineArgs = [ "--restore-last-session" ];
    extensions = [
      { id = "nngceckbapebfimnlniiiahkandclblb"; } # Bitwarden
    ];
  };
}
