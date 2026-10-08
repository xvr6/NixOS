{ pkgs, ... }:
let
  # Vencord (patched into the official client) reads ~/.config/Vencord/settings/settings.json
  vencordSettings = {
    notifyAboutUpdates = false;
    autoUpdate = true;
    autoUpdateNotification = false;
    useQuickCss = false;
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
      #          FakeNitro.enabled = true;
      FavoriteGifSearch.enabled = true;
      MessageLogger = {
        enabled = false;
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
  programs.discord = {
    enable = true;
    package = pkgs.discord.override { withVencord = true; };
    settings = {
      SKIP_HOST_UPDATE = true; # updates come from nixpkgs
      MINIMIZE_TO_TRAY = true;
    };
  };

  xdg.configFile."Vencord/settings/settings.json".text = builtins.toJSON vencordSettings;
}
