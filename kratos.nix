# See: https://github.com/NixOS/nixpkgs/blob/32e940c7c420600ef0d1ef396dc63b04ee9cad37/pkgs/applications/misc/kratos/default.nix
{
  fetchFromGitHub,
  buildGoModule,
}: let
  pname = "kratos";
  revision = "v1.3.1";
  version = "1.3.1";
in
  buildGoModule {
    inherit pname version;

    src = fetchFromGitHub {
      owner = "ory";
      repo = "kratos";
      rev = "${revision}";
      hash = "sha256-FJrBwjWBYwoiy8rWXn+jaVc1b35So1Rb9SjkUlNwAqE=";
    };

    vendorHash = "sha256-zZwunp/433oIYI5ZA3Pznq9jfvIZE5ZUJKxboVef8g0=";

    # Specify subpackages explicitly
    subPackages = [
      "."
    ];

    # Pass versioning information via ldflags
    ldflags = [
      "-X github.com/ory/kratos/driver/config.Version=${version}"
    ];
  }
