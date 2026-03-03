
{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "packwiz";
  version = "dfd8b68";

  src = fetchFromGitHub {
    owner = "packwiz";
    repo = "packwiz";
    rev = "dfd8b68";
    hash = "sha256-QK8sY7e6QHhg+GH8NiiePGFlsQBI0jjUlsgBuq1Yopc="; # Replace with the actual hash
  };

  vendorHash = "sha256-ChUE4hWl+UyPpbzK0GbJTD0AoBCogI7qGstga4+WujI="; # Hash for vendored dependencies


  # Optional: specify Go version if needed
  # goDeps = pkgs.go.deps { src = ./.; };
}
