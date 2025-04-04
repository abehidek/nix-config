let
  data = {
    "devs" = "dev";
    "dots" = "dot";
    "functions" = "fn";
    "keys" = "key";
    "hosts" = "host";
    "users" = "home";
    "vms" = "host/vm";
    "templates" = "templ";
  };
in
builtins.mapAttrs (
  k: v: rest:
  (./${v} + ("/" + rest))
) data
