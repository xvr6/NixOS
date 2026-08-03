{
  inputs,
  pkgs,
  ...
}:
{

  perSystem = { pkgs, ... }: {
    packages.myNoctalia = inputs.wrapper-modules.wrappers.noctalia-shell.wrap {

      settings = (builtins.fromJSON (builtins.readFile ./noctalia-settings.json));

    };
  };
}
