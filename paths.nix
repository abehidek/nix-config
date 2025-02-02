let
  data = {
    "dots" = "d";
    "functions" = "f";
    "keys" = "k";
    "hosts" = "s";
    "users" = "u";
  };
in
builtins.mapAttrs (
  k: v: rest:
  (./${v} + ("/" + rest))
) data
