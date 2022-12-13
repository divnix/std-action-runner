{pkgs, ...}: {
  nix = {
    gc.automatic = false;

    nixPath = [
      "nixpkgs=${pkgs.path}"
    ];

    settings = {
      auto-optimise-store = true;
      allowed-users = ["@wheel"];
      trusted-users = ["root" "@wheel"];
      experimental-features = [
        "flakes"
        "nix-command"
      ];
      accept-flake-config = true;
    };
  };
}
