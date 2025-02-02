let
  data = {
    "dots" = "dot";
    "functions" = "fn";
    "keys" = "k";
    "hosts" = "s";
    "users" = "u";
  };
in
builtins.mapAttrs (
  k: v: rest:
  (./${v} + ("/" + rest))
) data
