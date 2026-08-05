{ self, inputs, ... }:
{
  flake.nixosModules.discord =
    {
      host,
      pkgs,
      lib,
      ...
    }:
    let
      inherit (import ../../../hosts/${host}/_variables.nix) username;
      home = "/home/${username}";

      vencordSettings = {
        notifyAboutUpdates = false;
        autoUpdate = false;
        autoUpdateNotification = false;
        useQuickCss = false;
        themeLinks = [
          "https://catppuccin.github.io/userstyles/styles/discord/catppuccin.user.css?flavor=mocha&accent=mauve"
        ];
        enabledThemes = [ ];
        enableReactDevtools = false;
        frameless = false;
        transparent = false;
        winCtrlQ = false;
        disableMinSize = false;
        winNativeTitleBar = false;
        plugins = {
          CommandsAPI.enabled = true;
          MessageAccessoriesAPI.enabled = true;
          UserSettingsAPI.enabled = true;
          AlwaysTrust.enabled = true;
          ClearURLs.enabled = true;
          CopyFileContents.enabled = true;
          CrashHandler.enabled = true;
          ExpressionCloner.enabled = true;
          Experiments.enabled = true;
          FakeNitro.enabled = true;
          FavoriteGifSearch.enabled = true;
          MessageLogger = {
            enabled = true;
            logDeletes = true;
            collapseDeleted = false;
            logEdits = false;
            inlineEdits = false;
            ignoreBots = true;
            ignoreSelf = true;
          };
          NSFWGateBypass.enabled = true;
          PinDMs.enabled = true;
          ReplaceGoogleSearch = {
            enabled = false;
            customEngineName = "Startpage";
            customEngineURL = "https://www.startpage.com/sp/search?prfe=c602752472dd4a3d8286a7ce441403da08e5c4656092384ed3091a946a5a4a4c99962d0935b509f2866ff1fdeaa3c33a007d4d26e89149869f2f7d0bdfdb1b51aa7ae7f5f17ff4a233ff313d&query=";
          };
          ReverseImageSearch.enabled = true;
          ShowHiddenThings.enabled = true;
          SilentTyping = {
            enabled = true;
            showIcon = true;
            contextMenu = true;
            isEnabled = false;
          };
          SpotifyCrack.enabled = true;
          YoutubeAdblock.enabled = true;
          NoTrack = {
            enabled = true;
            disableAnalytics = true;
          };
          Settings = {
            enabled = true;
            settingsLocation = "aboveNitro";
          };
          SupportHelper.enabled = true;
        };
        notifications = {
          timeout = 5000;
          position = "bottom-right";
          useNative = "not-focused";
          logLimit = 50;
        };
        cloud = {
          authenticated = false;
          url = "https://api.vencord.dev/";
          settingsSync = false;
          settingsSyncVersion = 1737589382741;
        };
      };
    in
    {
      environment.systemPackages = [ pkgs.vesktop ];

      environment.etc."vesktop/settings/settings.json".text = builtins.toJSON vencordSettings;

      systemd.tmpfiles.rules = [
        "d ${home}/.config/vesktop 0755 ${username} users -"
        "d ${home}/.config/vesktop/settings 0755 ${username} users -"
        "L+ ${home}/.config/vesktop/settings/settings.json - - - - /etc/vesktop/settings/settings.json"
      ];
    };
}
