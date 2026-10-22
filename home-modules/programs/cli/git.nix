{ ... }: {
  programs.git = {
    enable = true;
    settings = {
      branch.autoSetupMerge = "always";
      user = {
        name = "xvr6";
        email = "xvr0612@gmail.com";
        init.defaultBranch = "main";
      };
    };
  };
}
