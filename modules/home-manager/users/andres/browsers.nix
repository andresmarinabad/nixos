{ lib, ... }:

let
  ts = "13304473600000000";

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

  processItem =
    item: id:
    if item ? url then
      {
        node = {
          id = toString id;
          type = "url";
          name = item.name;
          url = item.url;
          date_added = ts;
          date_modified = ts;
        };
        nextId = id + 1;
      }
    else
      let
        processed =
          lib.foldl
            (
              acc: child:
              let
                r = processItem child acc.nextId;
              in
              {
                nodes = acc.nodes ++ [ r.node ];
                nextId = r.nextId;
              }
            )
            {
              nodes = [ ];
              nextId = id + 1;
            }
            item.children;
      in
      {
        node = {
          id = toString id;
          type = "folder";
          name = item.name;
          date_added = ts;
          date_modified = ts;
          children = processed.nodes;
        };
        nextId = processed.nextId;
      };

  barProcessed =
    lib.foldl
      (
        acc: item:
        let
          r = processItem item acc.nextId;
        in
        {
          nodes = acc.nodes ++ [ r.node ];
          nextId = r.nextId;
        }
      )
      {
        nodes = [ ];
        nextId = 10;
      }
      bookmarksList;

  roots = {
    bookmark_bar = {
      id = "1";
      type = "folder";
      name = "Bookmarks bar";
      date_added = ts;
      date_modified = ts;
      children = barProcessed.nodes;
    };
    other = {
      id = "2";
      type = "folder";
      name = "Other Bookmarks";
      date_added = ts;
      date_modified = ts;
      children = [ ];
    };
    synced = {
      id = "3";
      type = "folder";
      name = "Mobile bookmarks";
      date_added = ts;
      date_modified = ts;
      children = [ ];
    };
  };
in
{
  xdg.configFile."BraveSoftware/Brave-Browser/Default/Bookmarks" = {
    force = true;
    text = builtins.toJSON {
      version = 1;
      roots = roots;
    };
  };

  programs.brave = {
    enable = true;
    extensions = [
      { id = "nngceckbapebfimnlniiiahkandclblb"; } # Bitwarden
    ];
  };
}
