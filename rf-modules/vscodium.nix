{ lib, config, pkgs, unstable, name, user, ... }:
with lib;
let cfg = config.modules.vscodium;
in {
  options.modules.vscodium = {
    enable = mkEnableOption "Install VSCodium";
    enableVSCodeMarketPlace = mkEnableOption "Enables VSCode Marketplace";
  };

  config = mkIf cfg.enable {
    environment = {
      systemPackages = with pkgs; [ unstable.vscodium ];
      sessionVariables = mkIf cfg.enableVSCodeMarketPlace {
        VSCODE_GALLERY_SERVICE_URL = "https://marketplace.visualstudio.com/_apis/public/gallery";
        VSCODE_GALLERY_CACHE_URL = "https://vscode.blob.core.windows.net/gallery/index";
        VSCODE_GALLERY_ITEM_URL = "https://marketplace.visualstudio.com/items";
        VSCODE_GALLERY_CONTROL_URL="";
        VSCODE_GALLERY_RECOMMENDATIONS_URL="";
      };
    };
  };
}
