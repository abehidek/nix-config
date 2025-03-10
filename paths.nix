let
  data = {
    "devs" = "dev";
    "dots" = "dot";
    "functions" = "fn";
    "keys" = "key";
    "hosts" = "host";
    "users" = "home";
  };
in
builtins.mapAttrs (
  k: v: rest:
  (./${v} + ("/" + rest))
) data
