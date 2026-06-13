{ lib }:

let
  ts = "13304473600000000";

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

  # Convierte una lista de bookmarks/carpetas al JSON que espera Chromium/Brave.
  # Cada item: { name = "..."; url = "..."; } o { name = "..."; folder = true; children = [...]; }
  buildBookmarks =
    bookmarksList:
    let
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
    in
    builtins.toJSON {
      version = 1;
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
    };
in
{
  inherit buildBookmarks;
}
