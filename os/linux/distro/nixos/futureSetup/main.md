# NixOs - Future Setup

## Abstract
Great question! If you want a **deterministic**, **reproducible** system that supports **multiple users**, Nix + Flakes + Home Manager is a fantastic stack. Here’s a practical, plain-English overview with examples and a recommended setup strategy.

***

## The Big Picture

*   **Nix** is a package manager that builds everything from **declarative recipes** and caches. It uses cryptographic hashes, so builds are reproducible.
*   **Flakes** add **locked, composable inputs** and a standardized structure. They make configurations reproducible across machines by pinning exact versions.
*   **Home Manager** uses Nix to **manage user dotfiles and programs** (shell, editors, fonts, services) in a declarative way—per user.

This combo lets you:

*   Define system-wide packages/services once.
*   Define per-user environments independently.
*   Reproduce everything from scratch on any machine.

***

## Core Concepts (in human language)

### Nix (multi-user mode)

*   Nix stores packages in `/nix/store`. Each build is content-addressed (hash-based), so installing the same config yields the same result.
*   Multi-user support is handled by the **nix-daemon**. Each user gets their own profile; the daemon builds in shared sandboxes.
*   Determinism comes from the **store paths**, **fixed inputs**, and **sandboxing**.

### Flakes

*   A **flake** is a Nix project with:
    *   `flake.nix` (definition),
    *   `flake.lock` (pins exact versions of dependencies).
*   Inputs (e.g., nixpkgs, home-manager) are **locked**, which guarantees you’ll get the same versions on every machine unless you consciously update.
*   Outputs expose things like `packages`, `nixosConfigurations`, `homeConfigurations`, etc.

### Home Manager

*   Home Manager applies Nix declarative config to your **home directory**:
    *   Dotfiles (zsh, bash, git, neovim),
    *   GUI apps,
    *   Per-user services (e.g., syncthing, keybase),
    *   Fonts and themes.
*   Works on **NixOS** (as a module) or **non-NixOS** (standalone).
*   Each user has their own Home Manager config; users don’t step on each other.

***

## Recommended Architecture for Multiple Users

**Option A: NixOS (best determinism, easy multi-user)**

*   Use a single repo (flake) with:
    *   `nixosConfigurations.<host>` for system-level config,
    *   `homeConfigurations.<username>@<host>` for each user’s home config.
*   Home Manager is added as a **NixOS module**, so users inherit system channels and you avoid drift.

**Option B: Non-NixOS (macOS, Ubuntu, etc.)**

*   Use the same flake repo.
*   Install nix-daemon with multi-user mode.
*   Run Home Manager per user from the flake (standalone).
*   System packages/services remain outside Nix (less deterministic).

If your goal is **maximum determinism**, NixOS is the winner.

***

## A Working Example (single flake for system + multiple users)

**Directory structure:**

    .
    ├── flake.nix
    ├── hosts/
    │   └── maryville-laptop.nix           # NixOS system config
    └── users/
        ├── james.nix                      # James' Home Manager config
        └── pat.nix                        # Pat's Home Manager config

### `flake.nix`

```nix
{
  description = "Deterministic NixOS + Home Manager setup for multiple users";

  inputs = {
    # Pin exact versions for determinism
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";  # choose desired channel
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    # Optional: deploy-rs, flake-utils, etc.
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
    in {
      # --- NixOS system configuration ---
      nixosConfigurations.maryville-laptop = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./hosts/maryville-laptop.nix

          # Integrate Home Manager as a NixOS module (most reliable)
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            # Per-user HM configs referenced here
            home-manager.users.james = import ./users/james.nix;
            home-manager.users.pat   = import ./users/pat.nix;
          }
        ];
      };

      # --- Optional: standalone Home Manager for non-NixOS or testing ---
      homeConfigurations = {
        "james@maryville-laptop" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./users/james.nix ];
        };
        "pat@maryville-laptop" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./users/pat.nix ];
        };
      };
    };
}
```

### `hosts/maryville-laptop.nix` (system settings)

```nix
{ config, pkgs, ... }:

{
  # Boot, filesystems, networking, etc.
  networking.hostName = "maryville-laptop";
  time.timeZone = "America/New_York";  # TN local
  i18n.defaultLocale = "en_US.UTF-8";

  users.users.james = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.zsh;
  };

  users.users.pat = {
    isNormalUser = true;
    shell = pkgs.bash;
  };

  # System packages (available to all users)
  environment.systemPackages = with pkgs; [
    git
    curl
    vim
    htop
    unzip
  ];

  # Example services
  services.openssh.enable = true;
  networking.networkmanager.enable = true;

  # Make Nix more deterministic
  nix.settings = {
    sandbox = true;
    extra-experimental-features = [ "nix-command" "flakes" ];
    warn-dirty = true;
    # Optional: restrict networks or use substituters/caches you trust
  };

  # Optional: state version
  system.stateVersion = "24.11";  # set once at install
}
```

### `users/james.nix` (Home Manager config)

```nix
{ config, pkgs, ... }:

{
  home.username = "james";
  home.homeDirectory = "/home/james";
  home.stateVersion = "24.11";  # HM schema version

  programs.zsh.enable = true;
  programs.zsh.promptInit = ''
    PROMPT="%F{cyan}%n@%m%f %F{yellow}%~%f %# "
  '';

  programs.git = {
    enable = true;
    userName = "James Hutchinson";
    userEmail = "james@example.com";
    extraConfig = {
      pull.rebase = true;
      init.defaultBranch = "main";
    };
  };

  programs.neovim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [ vim-nix nerdtree ];
    extraConfig = ''
      set number
      set expandtab
    '';
  };

  home.packages = with pkgs; [
    fd ripgrep bat jq
  ];

  # Example per-user service (on NixOS)
  services.gpg-agent.enable = true;

  # Dotfiles managed declaratively
  home.file.".config/alacritty/alacritty.toml".text = ''
    [window]
    opacity = 0.95
  '';
}
```

### `users/pat.nix` (another user, different preferences)

```nix
{ config, pkgs, ... }:

{
  home.username = "pat";
  home.homeDirectory = "/home/pat";
  home.stateVersion = "24.11";

  programs.bash.enable = true;
  programs.git.enable = true;

  home.packages = with pkgs; [
    ripgrep
    tree
  ];
}
```

***

## Operating the System

### Build/activate on NixOS

```bash
# From your flake repo:
sudo nixos-rebuild switch --flake .#maryville-laptop
```

### Update inputs (conscious, controlled)

```bash
# Review changes after:
nix flake update
git diff flake.lock
```

### Per-user HM activation (standalone or testing)

```bash
# If using homeConfigurations output:
home-manager switch --flake .#"james@maryville-laptop"
home-manager switch --flake .#"pat@maryville-laptop"
```

***

## How This Achieves Determinism

*   **`flake.lock` pins exact revisions** of nixpkgs and home-manager. Everyone gets the same build.
*   **Declarative configs** (NixOS modules + HM) mean no snowflake machines—no hidden manual tweaks.
*   **Sandboxed builds** and **hash-addressed store paths** ensure equivalent inputs → equivalent outputs.
*   **Versioned state** (`system.stateVersion`, `home.stateVersion`) stabilizes module behaviors.

***

## Multi-User Good Practices

1.  **Single flake repo** with folders for hosts and users.
2.  **Use Home Manager as a NixOS module**, not standalone, for consistent inputs & easier upgrades.
3.  **Role-based modules**: Factor common configs (e.g., dev tools, ops tools) into reusable Nix modules, then import per user.
4.  **Secrets**: Keep secrets out of the flake; use `sops-nix` or `age` + HM integrations for encrypted secrets.
5.  **Access control**: System packages are in `environment.systemPackages`; per-user packages go in `home.packages`.
6.  **Caching**: Use trusted binary caches (e.g., `cache.nixos.org`) or your own to speed builds across users.
7.  **Pin channels** only via flakes; avoid legacy channels to prevent drift.

***

## Common Pitfalls & Tips

*   **Non-NixOS services**: On Ubuntu/macOS, system services aren’t managed by Nix; determinism is lower for system bits.
*   **Fonts & GUI**: Remember to manage fonts and per-user GUI settings in HM to avoid manual steps.
*   **Unfree packages**: Enable `config.allowUnfree = true;` consciously (license constraints).
*   **Networking/Kernel**: On NixOS, everything is deterministic; on non-NixOS, kernel/driver differences can break parity.

***

## Where do you want to run this?

Since you’re in Maryville, TN and working as a **contingent worker**, I want to tailor this to your environment:

*   Are you planning to run **NixOS** on your primary workstation, or use **Nix on macOS/Ubuntu**?
*   How many users do you need to support (just you and, say, Pat, or a bigger team)?
*   Do you need **per-user services** (e.g., dev daemons, gpg-agent) or shared system services?

If you share that, I can adapt the flake skeleton and modules to your exact needs and provide a copy-paste repo scaffold.


## Directory

## Useful Links

## Tags
