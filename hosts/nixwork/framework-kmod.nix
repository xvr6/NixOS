# Workaround: nixpkgs' kmodigest signing needs a .ko.cer per external module, but
# framework-laptop-kmod installs its .ko by hand. Drop once fixed upstream.
{ config, ... }:
let
  kp = config.boot.kernelPackages;
  kmod = kp.framework-laptop-kmod.overrideAttrs {
    # modules_install runs kbuild's sign step, emitting the .ko.cer
    installPhase = ''
      runHook preInstall
      make -C ${kp.kernel.dev}/lib/modules/${kp.kernel.modDirVersion}/build M=$PWD \
        ''${makeFlags[@]} INSTALL_MOD_PATH=$out INSTALL_MOD_DIR=extra modules_install
      runHook postInstall
    '';
  };
in
{
  # Replaces nixos-hardware's kmod.nix, which pulls in the unpatched package
  hardware.framework.enableKmod = false;
  boot = {
    extraModulePackages = [ kmod ];
    kernelModules = [
      "cros_ec"
      "cros_ec_lpcs"
    ];
  };
}
