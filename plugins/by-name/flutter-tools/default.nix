{
  lib,
  pkgs,
  config,
  ...
}:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "flutter-tools";
  packPathName = "flutter-tools.nvim";
  package = "flutter-tools-nvim";

  maintainers = [ lib.maintainers.khaneliman ];

  extraOptions = {
    flutterPackage = lib.mkPackageOption pkgs "flutter" {
      nullable = true;
    };
  };
  extraConfig = cfg: {
    extraPackages = [ cfg.flutterPackage ];

    warnings =
      lib.optional
        (
          (cfg.settings ? debugger.enable)
          && (lib.isBool cfg.settings.debugger.enable)
          && cfg.settings.debugger.enable
          && (!config.plugins.dap.enable)
        )
        ''
          Nixvim (plugins.flutter-tools): You have enabled the dap integration (`settings.debugger.enable`) but `plugins.dap` is disabled.
        '';
  };

  settingsOptions = import ./settings-options.nix lib;

  settingsExample = {
    decorations = {
      statusline = {
        app_version = true;
        device = true;
      };
    };
    dev_tools = {
      autostart = true;
      auto_open_browser = true;
    };
    lsp.color.enabled = true;
    widget_guides.enabled = true;
    closing_tags = {
      highlight = "ErrorMsg";
      prefix = ">";
      priority = 10;
      enabled = false;
    };
  };
}
