# Nix Lang How To - Build Docker Images On Mac

## Abstract
### What I have done so far:
nix run nixpkgs#darwin.linux-builder

Need this as well:
https://nixos.org/manual/nixpkgs/stable/#sec-darwin-builder

------------------------------------------------------------------------------------------------------------------------
How to fix all of the ssh stuff:
Today
You said:
❯ nix build .#packages.aarch64-linux.echo-docker
error: bad machine specification: failed to convert column #3 in a row: 'ssh-ng://builder@linux-builder ${ARCH}-linux /etc/nix/builder_ed25519 ${MAX_JOBS} - - - c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUpCV2N4Yi9CbGFxdDFhdU90RStGOFFVV3JVb3RpQzVxQkorVXVFV2RWQ2Igcm9vdEBuaXhvcwo=' to 'unsigned int'
error:
       … while reading the response from the build hook

       error: unexpected EOF reading a line


Example flake usage
Reconfiguring the remote builder
Troubleshooting the generated configuration
Warning
By default, darwin.linux-builder uses a publicly-known private SSH host key (this is different from the SSH key used by the user that connects to the builder).

Given the intended use case for it (a Linux builder that runs on the same machine), this shouldn’t be an issue. However, if you plan to deviate from this use case in any way (e.g. by exposing this builder to remote machines), you should understand the security implications of doing so and take any appropriate measures.

darwin.linux-builder provides a way to bootstrap a Linux remote builder on a macOS machine.

This requires macOS version 12.4 or later.

The remote builder runs on host port 31022 by default. You can change it by overriding virtualisation.darwin-builder.hostPort. See the example.

You will also need to be a trusted user for your Nix installation. In other words, your /etc/nix/nix.conf should have something like:

extra-trusted-users = <your username goes here>
To launch the remote builder, run the following flake:

nix run nixpkgs#darwin.linux-builder
That will prompt you to enter your sudo password:

+ sudo --reset-timestamp /nix/store/…-install-credentials.sh ./keys
Password:
… so that it can install a private key used to ssh into the build server. After that the script will launch the virtual machine and automatically log you in as the builder user:

<<< Welcome to NixOS 22.11.20220901.1bd8d11 (aarch64) - ttyAMA0 >>>

Run 'nixos-help' for the NixOS manual.

nixos login: builder (automatic login)


[builder@nixos:~]$
Note: When you need to stop the VM, run shutdown now as the builder user.

To delegate builds to the remote builder, add the following options to your nix.conf file:

# - Replace ${ARCH} with either aarch64 or x86_64 to match your host machine
# - Replace ${MAX_JOBS} with the maximum number of builds (pick 4 if you're not sure)
builders = ssh-ng://builder@linux-builder ${ARCH}-linux /etc/nix/builder_ed25519 ${MAX_JOBS} - - - c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUpCV2N4Yi9CbGFxdDFhdU90RStGOFFVV3JVb3RpQzVxQkorVXVFV2RWQ2Igcm9vdEBuaXhvcwo=

# Not strictly necessary, but this will reduce your disk utilization
builders-use-substitutes = true
To allow Nix to connect to the default remote builder, which does not run on port 22, you will also need to create a new file at /etc/ssh/ssh_config.d/100-linux-builder.conf:

Host linux-builder
  Hostname localhost
  HostKeyAlias linux-builder
  Port 31022
  User builder
  IdentityFile /etc/nix/builder_ed25519
… and then restart your Nix daemon to apply the change:

sudo launchctl kickstart -k system/org.nixos.nix-daemon
Note that if the builder is running and you have created the above ssh conf file, you can ssh into the builder with sudo ssh builder@linux-builder.

Example flake usage
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-22.11-darwin";
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      darwin,
      nixpkgs,
      ...
    }@inputs:
    let

      inherit (darwin.lib) darwinSystem;
      system = "aarch64-darwin";
      pkgs = nixpkgs.legacyPackages."${system}";
      linuxSystem = builtins.replaceStrings [ "darwin" ] [ "linux" ] system;

      darwin-builder = nixpkgs.lib.nixosSystem {
        system = linuxSystem;
        modules = [
          "${nixpkgs}/nixos/modules/profiles/nix-builder-vm.nix"
          {
            virtualisation = {
              host.pkgs = pkgs;
              darwin-builder.workingDirectory = "/var/lib/darwin-builder";
              darwin-builder.hostPort = 22;
            };
          }
        ];
      };
    in
    {

      darwinConfigurations = {
        machine1 = darwinSystem {
          inherit system;
          modules = [
            {
              nix.distributedBuilds = true;
              nix.buildMachines = [
                {
                  hostName = "localhost";
                  sshUser = "builder";
                  sshKey = "/etc/nix/builder_ed25519";
                  system = linuxSystem;
                  maxJobs = 4;
                  supportedFeatures = [
                    "kvm"
                    "benchmark"
                    "big-parallel"
                  ];
                }
              ];

              launchd.daemons.darwin-builder = {
                command = "${darwin-builder.config.system.build.macos-builder-installer}/bin/create-builder";
                serviceConfig = {
                  KeepAlive = true;
                  RunAtLoad = true;
                  StandardOutPath = "/var/log/darwin-builder.log";
                  StandardErrorPath = "/var/log/darwin-builder.log";
                };
              };
            }
          ];
        };
      };

    };
}
Reconfiguring the remote builder
Initially you should not change the remote builder configuration else you will not be able to use the binary cache. However, after you have the remote builder running locally you may use it to build a modified remote builder with additional storage or memory.

To do this, you just need to set the virtualisation.darwin-builder.* parameters as in the example below and rebuild.

{
  darwin-builder = nixpkgs.lib.nixosSystem {
    system = linuxSystem;
    modules = [
      "${nixpkgs}/nixos/modules/profiles/nix-builder-vm.nix"
      {
        virtualisation.host.pkgs = pkgs;
        virtualisation.darwin-builder.diskSize = 5120;
        virtualisation.darwin-builder.memorySize = 1024;
        virtualisation.darwin-builder.hostPort = 33022;
        virtualisation.darwin-builder.workingDirectory = "/var/lib/darwin-builder";
      }
    ];
  };
}
You may make any other changes to your VM in this attribute set. For example, you could enable Docker or X11 forwarding to your Darwin host.

Troubleshooting the generated configuration
The linux-builder package exposes the attributes nixosConfig and nixosOptions that allow you to inspect the generated NixOS configuration in the nix repl. For example:

nix repl --file ~/src/nixpkgs --argstr system aarch64-darwin
darwin.linux-builder.nixosConfig.nix.package
«derivation /nix/store/...-nix-2.17.0.drv»
:p darwin.linux-builder.nixosOptions.virtualisation.memorySize.definitionsWithLocations
[ { file = "/home/user/src/nixpkgs/nixos/modules/profiles/nix-builder-vm.nix"; value = 3072; } ]

Copilot said:
Copilot

Reasoned for 20s

Troubleshooting column confusion

Searching

Searching

Searching

Troubleshooting field order

Revisiting the manual

Identifying issues

Confirming Nix settings
Looks like Nix is choking on your builders line and mis-parsing the columns—specifically, it’s trying to read column #3 as an unsigned int (the max-jobs field), but your third token is a path (/etc/nix/builder_ed25519). That usually means Nix didn’t recognize the second field (platforms) and “shifted” the column meanings, so everything after the URI is off by one. The two most common causes:

Variables aren’t expanded in nix.conf.
${ARCH} and ${MAX_JOBS} in nix.conf are taken literally; Nix won’t substitute them. Replace them with concrete values (e.g., aarch64 or x86_64, and a number like 4).
nixos

Wrong protocol or malformed machine spec.
The Nix manual outlines the exact machine spec fields and their order. If Nix can’t parse one field (e.g., platform list), it will try to interpret the next token as the next field, which triggers the “column #3 must be unsigned int” error when your identity file is read where max-jobs is expected. The required order is:
URI platforms ssh-key max-jobs speed features mandatory-features publicHostKeyBase64
Only the URI is strictly required; each subsequent field must be present or replaced with - as a single token.
nixos

Fix it quickly
Edit /etc/nix/nix.conf (system-wide) to use concrete values and the standard ssh:// URI form (it works with both new and old Nix releases). For a macOS host using the default darwin.linux-builder VM on port 31022, this is a good, known-good line:




INI
# Pick the exact architecture your builder VM reports, typically aarch64-linux on Apple Silicon
builders = ssh://builder@linux-builder aarch64-linux /etc/nix/builder_ed25519 4 1 - - c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUpCV2N4Yi9CbGFxdDFhdU90RStGOFFVV3JVb3RpQzVxQkorVXVFV2RWQ2Igcm9vdEBuaXhvcwo=
builders-use-substitutes = true
Notes:

Replace aarch64-linux with x86_64-linux only if your builder VM is x86_64. Most Apple Silicon macOS hosts will run an aarch64 NixOS VM.
nixos
4 is the number of parallel jobs; pick what your VM can handle.
Keep the base64-encoded host key as a single token (no spaces or newlines). The manual expects base64 of the host public key line (e.g., ssh-ed25519 AAAA… host) so you don’t inject spaces into the spec.
nixos
Then ensure your SSH client alias points at the right port and identity:




Plain Text
sshconfig isn’t fully supported. Syntax highlighting is based on Plain Text.

# /etc/ssh/ssh_config.d/100-linux-builder.conf
Host linux-builder
  Hostname localhost
  HostKeyAlias linux-builder
  Port 31022
  User builder
  IdentityFile /etc/nix/builder_ed25519
Restart the Nix daemon to apply changes:




Shell
sudo launchctl kickstart -k system/org.nixos.nix-daemon
These steps match the official distributed builds spec and typical macOS remote-builder guidance.
nixos
+1

Why your original line failed
Literal ${ARCH} → Nix treated the second token as something it couldn’t parse as a comma-separated platform list (because it literally contained braces), so it “shifted” parsing: it took /etc/nix/builder_ed25519 as column #3 (which, according to the spec, is max-jobs), and then complained it isn’t an integer.
nixos
The “unexpected EOF reading a line” that followed typically shows up when the daemon’s build hook receives a malformed spec and drops the connection mid-parse. The root cause is still the bad machine spec.
nixos
Sanity checks (do these after you edit)
Is the builder reachable for the daemon (root)?
From macOS:



Shell
sudo ssh builder@linux-builder -i /etc/nix/builder_ed25519 -p 31022 true
``
If this succeeds, SSH is fine. (Remote builder setups require daemon/root to have non-interactive SSH access.)
nixos

Does Nix see the remote store?



Shell
nix store info --store ssh://builder@linux-builder?ssh-key=/etc/nix/builder_ed25519
``
If this prints store info, the URI and key are correct.
nixos

Show what Nix thinks your builders are:



Shell
nix config show builders
``
Confirm the line is exactly what you expect (no ${...} placeholders, no line wraps).
nix

Optional: put the spec in /etc/nix/machines
If you prefer keeping nix.conf tidy, you can do:




INI
builders = @/etc/nix/machines
and then put the single-line spec into /etc/nix/machines (no variables, no wrapping). This method is supported by the manual and often avoids subtle quoting issues.
nixos

Reference: exact field order (keep this handy)
From the Nix manual (Remote Builds):

URI of remote store (e.g., ssh://builder@linux-builder)
platforms (e.g., aarch64-linux)
ssh-key (path to private key)
max-jobs (integer)
speed factor (integer)
features (comma-separated, or -)
mandatory-features (comma-separated, or -)
public host key (base64) (single token, no spaces)
nixos
If you’d like, paste your current /etc/nix/nix.conf builders line (redact the key if you prefer), and I’ll spot-check it. Also—are you building for aarch64-linux (Apple Silicon) or x86_64-linux? That one field must match your VM’s architecture to avoid silent delegations back to local.

Sources
Favicon typeFavicon typeFavicon type







You said:
how do I use the builder to build my flake
Copilot said:
Copilot
Once your remote builder is configured and reachable, using it to build your flake is straightforward because Nix automatically delegates builds to machines listed in nix.conf (or /etc/nix/machines) when nix.distributedBuilds = true.

Here’s the process:

✅ 1. Confirm the builder is active
Run:




Shell
sudo ssh builder@linux-builder -i /etc/nix/builder_ed25519 -p 31022 true
If this succeeds, the VM is up and accessible.

✅ 2. Ensure distributed builds are enabled
Check:




Shell
nix config show | grep distributed-builds
If it’s not enabled, add:




INI
distributed-builds = true
to /etc/nix/nix.conf.

✅ 3. Build your flake
Use the normal nix build command; Nix will automatically delegate jobs to the builder if the target system matches its system attribute:




Shell
nix build .#packages.aarch64-linux.echo-docker
Key point:

The system in your flake output (aarch64-linux) must match the builder’s platform (aarch64-linux for Apple Silicon VM).
If your host is macOS (aarch64-darwin), Nix will build Darwin outputs locally and Linux outputs remotely.
✅ 4. Check delegation
Run:




Shell
nix build --print-build-logs .#packages.aarch64-linux.echo-docker
You should see logs like:

copying path '/nix/store/...-echo-docker' from 'ssh://builder@linux-builder'...
That confirms the remote builder handled the build.

✅ 5. Optional: force remote build
If you want to ensure the build happens remotely (and not locally), you can:




Shell
nix build --builders 'ssh://builder@linux-builder aarch64-linux /etc/nix/builder_ed25519 4 1 - - <hostkey>'
This overrides the global config for that command.

Do you want me to give you a full example flake command for cross-building on macOS using the remote builder, or a step-by-step script to bootstrap and build automatically?








You said:
❯ nix build .#packages.aarch64-linux.echo-docker
error: Cannot build '/nix/store/m7c4ksyqlxdlpg15rkqly5msh4lcbnc0-echo-server.drv'.
       Reason: required system or feature not available
       Required system: 'aarch64-linux' with features {}
       Current system: 'aarch64-darwin' with features {apple-virt, benchmark, big-parallel, nixos-test}
error: Cannot build '/nix/store/35b8ccpagx883wnhd3n2iq5q7qi7ivvz-pythoncheck.sh.drv'.
       Reason: required system or feature not available
       Required system: 'aarch64-linux' with features {}
       Current system: 'aarch64-darwin' with features {apple-virt, benchmark, big-parallel, nixos-test}
error: Cannot build '/nix/store/dcfznqy52jnkskqf0db9qvg3vy7djp8f-echo-server-base.json.drv'.
       Reason: 1 dependency failed.
       Output paths:
         /nix/store/c384ppswa5n1j6yybg07flmr7s9h7rji-echo-server-base.json
error: Cannot build '/nix/store/aikc7yzab4wmy9s3v9v2r7azdpnipcw5-echo-server-customisation-layer.drv'.
       Reason: 1 dependency failed.
       Output paths:
         /nix/store/44dpivl2yknnpncbd1pq5i1wrqq5pq2v-echo-server-customisation-layer
error: Cannot build '/nix/store/6afhsa848n765rmw0zbqcdy5gbadg5a7-pythoncheck.sh.drv'.
       Reason: 1 dependency failed.
       Output paths:
         /nix/store/r3l6j7rr9nkfia46sq153c4fv0nx6dm7-pythoncheck.sh
error: Build failed due to failed dependency
error: Build failed due to failed dependency
error: Cannot build '/nix/store/zv8v6p5nrmkz76vlcjdmc05bjg0wsbpp-closure.drv'.
       Reason: 1 dependency failed.
       Output paths:
         /nix/store/1vzkrq3jdzmr90m3gqj8x4d8dw4srqjm-closure
error: Cannot build '/nix/store/is154dkaqhn2pi1dw3fzcbi3410vn65q-echo-server-conf.json.drv'.
       Reason: 1 dependency failed.
       Output paths:
         /nix/store/9fhka84yna4swsk11jgihjkfizzyccj8-echo-server-conf.json
error: Cannot build '/nix/store/3nqynjnnwdsw7xyyh2jpc03lnp75dpwg-stream.drv'.
       Reason: 1 dependency failed.
       Output paths:
         /nix/store/zfg52m6xjr0grl0ynhkkaqqxjnh93v04-stream
error: Build failed due to failed dependency
error: Build failed due to failed dependency
error: Cannot build '/nix/store/gzan3a6g9p0w9dv3zs5gsy4k1wff3yka-stream-echo-server.drv'.
       Reason: 1 dependency failed.
       Output paths:
         /nix/store/2rq6gqglsiaxqxj1ss8rd0dr8m603475-stream-echo-server
error: Build failed due to failed dependency
error: Cannot build '/nix/store/9hmwmj1r7wr2v7cnfarng456l632drmz-echo-server.tar.gz.drv'.
       Reason: 1 dependency failed.
       Output paths:
         /nix/store/msd0a7yr3lh6ngy2b8aqzbzq1vqvdnnv-echo-server.tar.gz
error: Build failed due to failed dependency
❯ nix build .#packages.aarch64-darwin.echo-docker
error: flake 'path:/Users/hutchinsoj/Documents/learn_nix/01' does not provide attribute 'packages.aarch64-darwin.packages.aarch64-darwin.echo-docker', 'legacyPackages.aarch64-darwin.packages.aarch64-darwin.echo-docker' or 'packages.aarch64-darwin.echo-docker'
Copilot said:
Copilot

Reasoned for 1s

Thinking through steps

Navigating errors
You’re very close. Two things are happening:

Nix isn’t delegating the aarch64-linux builds to your remote builder, so on macOS (aarch64-darwin) it refuses to build a Linux derivation locally:
Required system: 'aarch64-linux' … Current system: 'aarch64-darwin'
Nix should forward such builds to a remote machine when builders are correctly configured and distributed builds are enabled.
nixos
+1

Your flake doesn’t define packages.aarch64-darwin.echo-docker, so trying to build a Darwin variant fails with:
does not provide attribute packages.aarch64-darwin.echo-docker
Below is a practical checklist to get remote building working for your flake, plus how to expose/verify the correct flake outputs.

A. Make sure delegation to the remote builder works
1) Verify the builder and your config
SSH reachability for the daemon (root):




Shell
sudo ssh builder@linux-builder -i /etc/nix/builder_ed25519 -p 31022 true
If this succeeds, the VM is up and the key/port are correct. (Remote builds require the Nix daemon user—root—to have non‑interactive SSH access.)
nixos

nix.conf builders line should be concrete (no ${...}):




INI
builders = ssh://builder@linux-builder aarch64-linux /etc/nix/builder_ed25519 4 1 - - c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUpCV2N4Yi9CbGFxdDFhdU90RStGOFFVV3JVb3RpQzVxQkorVXVFV2RWQ2Igcm9vdEBuaXhvcwo=
builders-use-substitutes = true
distributed-builds = true
The machine spec must follow the exact field order and types (URI, platforms, SSH key, max-jobs, speed, features, mandatory-features, base64 host key). Variables like ${ARCH}/${MAX_JOBS} are not expanded in nix.conf.
nixos

Restart the daemon (macOS):




Shell
sudo launchctl kickstart -k system/org.nixos.nix-daemon
Check what Nix sees:




Shell
nix config show builders

Confirm the line shows aarch64-linux and no literal ${...}.
nix

2) Prove delegation with an explicit --builders override (one-off test)
Try a forced delegation to eliminate doubts about global config:




Shell
nix build .#packages.aarch64-linux.echo-docker \
  --builders 'ssh://builder@linux-builder aarch64-linux /etc/nix/builder_ed25519 4 1 - - c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUpCV2N4Yi9CbGFxdDFhdU90RStGOFFVV3JVb3RpQzVxQkorVXVFV2RWQ2Igcm9vdEBuaXhvcwo=' \
  --print-build-logs
``
In the logs you should see it building on ssh://builder@linux-builder or copying from that store. If this works, your global config just needs to match this working spec.
nixos

B. Make sure your flake exposes the outputs you’re asking for
1) See what your flake currently provides
From your flake directory:




Shell
nix flake show --all-systems
This prints the systems and attributes (e.g., packages.aarch64-linux.echo-docker). If aarch64-linux.echo-docker isn’t listed, Nix can’t build it.
nix

2) Define packages.${system}.echo-docker for the right systems
In your flake.nix, a common pattern is:




Nix
{
  description = "Echo server flake";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs";

  outputs = { self, nixpkgs, ... }:
    let
      supportedSystems = [ "aarch64-linux" "x86_64-linux" "aarch64-darwin" "x86_64-darwin" ];
      forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems (system:
        let pkgs = import nixpkgs { inherit system; };
        in f { inherit system pkgs; });
    in
    {
      packages = forAllSystems ({ system, pkgs }: {
        echo-docker = pkgs.callPackage ./pkgs/echo-docker { };
      });

      # optionally:
      # apps.${system}.echo-docker = { type = "app"; program = "${self.packages.${system}.echo-docker}/bin/echo-docker"; };
    };
}


Show more lines
This ensures packages.aarch64-linux.echo-docker and (if you want) packages.aarch64-darwin.echo-docker exist. If you only intend to build for Linux on macOS, defining just aarch64-linux is fine; Nix will delegate to the remote builder when configured.
nixos

C. Run the build the “normal” way
Once A and B are set:




Shell
# Linux target via remote builder
nix build .#packages.aarch64-linux.echo-docker
``
If everything is aligned, Nix will evaluate the flake on your Mac, detect it requires aarch64-linux, and forward the build to your Linux builder VM. That behavior is standard per the Remote Builds manual and the distributed builds guide.
nixos
+1

D. If you still see “required system not available”
Work through these known footguns:

The builder’s platform must match the requested system (uname -m in the VM should be aarch64, and the remote Nix should report aarch64-linux). If you accidentally used x86_64-linux in nix.conf while your VM is aarch64, delegation won’t happen.
nixos

The daemon must have access to the SSH key without a passphrase. A passphrase-protected key can’t be used by the daemon. Use a key with no passphrase or load it for root appropriately.
nixos

Trusted users on the builder: the SSH user you connect as must be in the builder’s trusted-users (or a trusted group) so it can execute builds. (On NixOS VM: nix.settings.trusted-users = [ "root" "builder" ];)
nixos

Test the remote store directly:




Shell
nix store info --store ssh://builder@linux-builder?ssh-key=/etc/nix/builder_ed25519
If this fails, fix PATH/Nix availability for non-interactive shells on the VM.
nixos

Want me to review your flake.nix?
If you paste the outputs section (and the path for echo-docker), I can point out exactly why packages.aarch64-darwin.echo-docker isn’t showing up and confirm the Linux output name is correct.

Once we confirm your flake defines packages.aarch64-linux.echo-docker and the daemon can reach the builder, your original command should “just work.”

Sources
Favicon typeFavicon typeFavicon type







You said:
❯ sudo ssh builder@linux-builder -i /etc/nix/builder_ed25519 -p 31022 true
ssh: connect to host localhost port 31022: Connection refused
Copilot said:
Copilot
The Connection refused means the Linux builder VM isn’t running or isn’t listening on port 31022. Here’s how to fix it:

✅ 1. Start the builder VM
On macOS, the builder is managed by darwin.linux-builder. If you haven’t started it yet, run:




Shell
nix run nixpkgs#darwin.linux-builder
``
This will:

Prompt for your sudo password (to install SSH keys).
Launch the NixOS VM and auto-login as builder.
You should see something like:

<<< Welcome to NixOS ... (aarch64) >>>
✅ 2. Confirm the VM is running
After starting, check:




Shell
ps aux | grep qemu
``
You should see a QEMU process for the VM.

✅ 3. Verify the port
By default, darwin.linux-builder uses 31022. If you changed virtualisation.darwin-builder.hostPort in your flake, use that port instead. If unsure, restart with the default.

✅ 4. Retry SSH
Once the VM is up:




Shell
sudo ssh builder@linux-builder -i /etc/nix/builder_ed25519 -p 31022 true
If this succeeds, the builder is ready.

✅ 5. If it still fails
Check /etc/ssh/ssh_config.d/100-linux-builder.conf exists and has:
Host linux-builder
  Hostname localhost
  HostKeyAlias linux-builder
  Port 31022
  User builder
  IdentityFile /etc/nix/builder_ed25519
Restart the Nix daemon:



Shell
sudo launchctl kickstart -k system/org.nixos.nix-daemon
Do you want me to give you a one-liner to start the builder and verify it’s listening on 31022, or a full script to bootstrap the builder and test SSH automatically?








You said:
❯ sudo ssh builder@linux-builder -i /etc/nix/builder_ed25519 -p 31022 true
ssh: connect to host localhost port 31022: Connection refused
❯ nix build .#packages.aarch64-linux.echo-docker
error: Cannot build '/nix/store/m7c4ksyqlxdlpg15rkqly5msh4lcbnc0-echo-server.drv'.
       Reason: required system or feature not available
       Required system: 'aarch64-linux' with features {}
       Current system: 'aarch64-darwin' with features {apple-virt, benchmark, big-parallel, nixos-test}
error: Cannot build '/nix/store/35b8ccpagx883wnhd3n2iq5q7qi7ivvz-pythoncheck.sh.drv'.
       Reason: required system or feature not available
       Required system: 'aarch64-linux' with features {}
       Current system: 'aarch64-darwin' with features {apple-virt, benchmark, big-parallel, nixos-test}
error: Cannot build '/nix/store/dcfznqy52jnkskqf0db9qvg3vy7djp8f-echo-server-base.json.drv'.
       Reason: 1 dependency failed.
       Output paths:
         /nix/store/c384ppswa5n1j6yybg07flmr7s9h7rji-echo-server-base.json
error: Cannot build '/nix/store/aikc7yzab4wmy9s3v9v2r7azdpnipcw5-echo-server-customisation-layer.drv'.
       Reason: 1 dependency failed.
       Output paths:
         /nix/store/44dpivl2yknnpncbd1pq5i1wrqq5pq2v-echo-server-customisation-layer
error: Cannot build '/nix/store/6afhsa848n765rmw0zbqcdy5gbadg5a7-pythoncheck.sh.drv'.
       Reason: 1 dependency failed.
       Output paths:
         /nix/store/r3l6j7rr9nkfia46sq153c4fv0nx6dm7-pythoncheck.sh
error: Build failed due to failed dependency
error: Build failed due to failed dependency
error: Cannot build '/nix/store/zv8v6p5nrmkz76vlcjdmc05bjg0wsbpp-closure.drv'.
       Reason: 1 dependency failed.
       Output paths:
         /nix/store/1vzkrq3jdzmr90m3gqj8x4d8dw4srqjm-closure
error: Cannot build '/nix/store/is154dkaqhn2pi1dw3fzcbi3410vn65q-echo-server-conf.json.drv'.
       Reason: 1 dependency failed.
       Output paths:
         /nix/store/9fhka84yna4swsk11jgihjkfizzyccj8-echo-server-conf.json
error: Cannot build '/nix/store/3nqynjnnwdsw7xyyh2jpc03lnp75dpwg-stream.drv'.
       Reason: 1 dependency failed.
       Output paths:
         /nix/store/zfg52m6xjr0grl0ynhkkaqqxjnh93v04-stream
error: Build failed due to failed dependency
error: Build failed due to failed dependency
error: Cannot build '/nix/store/gzan3a6g9p0w9dv3zs5gsy4k1wff3yka-stream-echo-server.drv'.
       Reason: 1 dependency failed.
       Output paths:
         /nix/store/2rq6gqglsiaxqxj1ss8rd0dr8m603475-stream-echo-server
error: Build failed due to failed dependency
error: Cannot build '/nix/store/9hmwmj1r7wr2v7cnfarng456l632drmz-echo-server.tar.gz.drv'.
       Reason: 1 dependency failed.
       Output paths:
         /nix/store/msd0a7yr3lh6ngy2b8aqzbzq1vqvdnnv-echo-server.tar.gz
error: Build failed due to failed dependency
❯ nix build .#packages.aarch64-darwin.echo-docker
error: flake 'path:/Users/hutchinsoj/Documents/learn_nix/01' does not provide attribute 'packages.aarch64-darwin.packages.aarch64-darwin.echo-docker', 'legacyPackages.aarch64-darwin.packages.aarch64-darwin.echo-docker' or 'packages.aarch64-darwin.echo-docker'
Copilot said:
Copilot
The errors confirm two separate issues:

1. Remote builder is not running
ssh: connect to host localhost port 31022: Connection refused means the VM isn’t up. Until the builder VM is running and listening on port 31022, Nix cannot delegate builds.

Fix: Run:




Shell
nix run nixpkgs#darwin.linux-builder
This boots the Linux builder VM. You should see a NixOS login banner. Leave it running in the background.

Then verify:




Shell
sudo ssh builder@linux-builder -i /etc/nix/builder_ed25519 -p 31022 true
``
If this succeeds, the builder is ready.

2. Flake doesn’t define packages.aarch64-darwin.echo-docker
Your flake only has packages.aarch64-linux.echo-docker. That’s why the Darwin build fails. If you want a macOS-native build, you need to add an output for aarch64-darwin in flake.nix.

Example pattern:




Nix
outputs = { self, nixpkgs, ... }:
  let
    systems = [ "aarch64-linux" "aarch64-darwin" ];
    forAllSystems = f: nixpkgs.lib.genAttrs systems (system:
      let pkgs = import nixpkgs { inherit system; };
      in f pkgs);
  in {
    packages = forAllSystems (pkgs: {
      echo-docker = pkgs.callPackage ./pkgs/echo-docker { };
    });
  };
``
Next steps
Start the builder VM (nix run nixpkgs#darwin.linux-builder).
Confirm SSH works (sudo ssh builder@linux-builder -p 31022 true).
Retry:



Shell
nix build .#packages.aarch64-linux.echo-docker
Now Nix should delegate to the remote builder.

Do you want me to give you: ✅ A full working flake template that supports both aarch64-linux and aarch64-darwin?
✅ Or a quick script to start the builder and verify connectivity automatically?








You said:
       Reason: 1 dependency failed.
       Output paths:
         /nix/store/9fhka84yna4swsk11jgihjkfizzyccj8-echo-server-conf.json
error: Cannot build '/nix/store/3nqynjnnwdsw7xyyh2jpc03lnp75dpwg-stream.drv'.
       Reason: 1 dependency failed.
       Output paths:
         /nix/store/zfg52m6xjr0grl0ynhkkaqqxjnh93v04-stream
error: Build failed due to failed dependency
error: Build failed due to failed dependency
error: Cannot build '/nix/store/gzan3a6g9p0w9dv3zs5gsy4k1wff3yka-stream-echo-server.drv'.
       Reason: 1 dependency failed.
       Output paths:
         /nix/store/2rq6gqglsiaxqxj1ss8rd0dr8m603475-stream-echo-server
error: Build failed due to failed dependency
error: Cannot build '/nix/store/9hmwmj1r7wr2v7cnfarng456l632drmz-echo-server.tar.gz.drv'.
       Reason: 1 dependency failed.
       Output paths:
         /nix/store/msd0a7yr3lh6ngy2b8aqzbzq1vqvdnnv-echo-server.tar.gz
error: Build failed due to failed dependency
❯ nix build .#packages.aarch64-darwin.echo-docker
error: flake 'path:/Users/hutchinsoj/Documents/learn_nix/01' does not provide attribute 'packages.aarch64-darwin.packages.aarch64-darwin.echo-docker', 'legacyPackages.aarch64-darwin.packages.aarch64-darwin.echo-docker' or 'packages.aarch64-darwin.echo-docker'
❯ [200~sudo ssh builder@linux-builder -i /etc/nix/builder_ed25519 -p 31022 true~
❯ sudo ssh builder@linux-builder -i /etc/nix/builder_ed25519 -p 31022 true
The authenticity of host 'linux-builder ([127.0.0.1]:31022)' can't be established.
ED25519 key fingerprint is SHA256:73nCAX7tESRWJ4ZN8RkOlqB+0bgxKVmbNRUcFPbXMkE.
This key is not known by any other names.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added 'linux-builder' (ED25519) to the list of known hosts.
❯ nix build .#packages.aarch64-darwin.echo-docker
error: flake 'path:/Users/hutchinsoj/Documents/learn_nix/01' does not provide attribute 'packages.aarch64-darwin.packages.aarch64-darwin.echo-docker', 'legacyPackages.aarch64-darwin.packages.aarch64-darwin.echo-docker' or 'packages.aarch64-darwin.echo-docker'
❯ nix build .#packages.aarch64-darwin.echo-docker
error: flake 'path:/Users/hutchinsoj/Documents/learn_nix/01' does not provide attribute 'packages.aarch64-darwin.packages.aarch64-darwin.echo-docker', 'legacyPackages.aarch64-darwin.packages.aarch64-darwin.echo-docker' or 'packages.aarch64-darwin.echo-docker'
❯ nix build .#packages.aarch64-linux.echo-docker
error: Cannot build '/nix/store/m7c4ksyqlxdlpg15rkqly5msh4lcbnc0-echo-server.drv'.
       Reason: required system or feature not available
       Required system: 'aarch64-linux' with features {}
       Current system: 'aarch64-darwin' with features {apple-virt, benchmark, big-parallel, nixos-test}
error: Cannot build '/nix/store/35b8ccpagx883wnhd3n2iq5q7qi7ivvz-pythoncheck.sh.drv'.
       Reason: required system or feature not available
       Required system: 'aarch64-linux' with features {}
       Current system: 'aarch64-darwin' with features {apple-virt, benchmark, big-parallel, nixos-test}
error: Cannot build '/nix/store/dcfznqy52jnkskqf0db9qvg3vy7djp8f-echo-server-base.json.drv'.
       Reason: 1 dependency failed.
       Output paths:
         /nix/store/c384ppswa5n1j6yybg07flmr7s9h7rji-echo-server-base.json
error: Cannot build '/nix/store/aikc7yzab4wmy9s3v9v2r7azdpnipcw5-echo-server-customisation-layer.drv'.
       Reason: 1 dependency failed.
       Output paths:
         /nix/store/44dpivl2yknnpncbd1pq5i1wrqq5pq2v-echo-server-customisation-layer
error: Cannot build '/nix/store/6afhsa848n765rmw0zbqcdy5gbadg5a7-pythoncheck.sh.drv'.
       Reason: 1 dependency failed.
       Output paths:
         /nix/store/r3l6j7rr9nkfia46sq153c4fv0nx6dm7-pythoncheck.sh
error: Build failed due to failed dependency
error: Build failed due to failed dependency
error: Cannot build '/nix/store/zv8v6p5nrmkz76vlcjdmc05bjg0wsbpp-closure.drv'.
       Reason: 1 dependency failed.
       Output paths:
         /nix/store/1vzkrq3jdzmr90m3gqj8x4d8dw4srqjm-closure
error: Cannot build '/nix/store/is154dkaqhn2pi1dw3fzcbi3410vn65q-echo-server-conf.json.drv'.
       Reason: 1 dependency failed.
       Output paths:
         /nix/store/9fhka84yna4swsk11jgihjkfizzyccj8-echo-server-conf.json
error: Cannot build '/nix/store/3nqynjnnwdsw7xyyh2jpc03lnp75dpwg-stream.drv'.
       Reason: 1 dependency failed.
       Output paths:
         /nix/store/zfg52m6xjr0grl0ynhkkaqqxjnh93v04-stream
error: Build failed due to failed dependency
error: Build failed due to failed dependency
error: Cannot build '/nix/store/gzan3a6g9p0w9dv3zs5gsy4k1wff3yka-stream-echo-server.drv'.
       Reason: 1 dependency failed.
       Output paths:
         /nix/store/2rq6gqglsiaxqxj1ss8rd0dr8m603475-stream-echo-server
error: Build failed due to failed dependency
error: Cannot build '/nix/store/9hmwmj1r7wr2v7cnfarng456l632drmz-echo-server.tar.gz.drv'.
       Reason: 1 dependency failed.
       Output paths:
         /nix/store/msd0a7yr3lh6ngy2b8aqzbzq1vqvdnnv-echo-server.tar.gz
error: Build failed due to failed dependency
Copilot said:
Copilot

Reasoned for 1s

Ensuring builder precision
Great—now we can see what’s happening and close the loop.

You’ve just accepted the SSH host key for linux-builder, which means the VM is (at least briefly) reachable. But the builds are still not being delegated, so Nix is trying to build aarch64-linux outputs on your macOS machine (aarch64-darwin) and bailing with “required system not available.”

This almost always comes down to the builders configuration not being active for the Nix daemon (or being malformed), so the daemon doesn’t know there’s an aarch64-linux builder to use. Below is a short, deterministic checklist that will get delegation working.

All commands and field order are per the Nix Remote Builds manual and the Distributed builds guide.
nixos
+1

1) Make sure the VM is actually running and listening on 31022
Start (or re‑start) the builder VM:




Shell
nix run nixpkgs#darwin.linux-builder
``
You should see a NixOS banner and an automatic login as builder. Leave this terminal running (or background the process).

Confirm it’s listening:




Shell
sudo ssh -o 'IdentityAgent none' -i /etc/nix/builder_ed25519 builder@linux-builder -p 31022 true
If this prints nothing and exits with code 0, SSH is good.
If you still get Connection refused, the VM isn’t running or using a different port—start it again, or check if you overrode virtualisation.darwin-builder.hostPort.

Remote builders require non‑interactive SSH for the daemon (root). That’s why we use sudo and a key without a passphrase.
nixos

2) Fix the builders line in /etc/nix/nix.conf (no variables, correct order)
Open /etc/nix/nix.conf and make sure your builders line is a single line, with concrete values (no ${ARCH} or ${MAX_JOBS}), and the fields are in the exact order:

URI  platforms  ssh-key  max-jobs  speed  features  mandatory-features  publicHostKeyBase64
A known‑good example for Apple Silicon + the default VM:




INI
builders = ssh://builder@linux-builder aarch64-linux /etc/nix/builder_ed25519 4 1 - - c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUpCV2N4Yi9CbGFxdDFhdU90RStGOFFVV3JVb3RpQzVxQkorVXVFV2RWQ2Igcm9vdEBuaXhvcwo=
builders-use-substitutes = true
distributed-builds = true
max-jobs = 0  # optional: prevent local builds on the Mac
``
Important details:

aarch64-linux must match the VM’s architecture (Apple Silicon VM is aarch64).
4 is how many parallel jobs the VM should run—adjust as needed.
The last field (host key) is one base64 token with no spaces/line breaks.
Use ssh:// (works across Nix versions) and keep everything on one line.
Don’t use ${ARCH} or ${MAX_JOBS}—Nix won’t expand variables in nix.conf.
nixos
Restart the daemon so it picks up the change:




Shell
sudo launchctl kickstart -k system/org.nixos.nix-daemon
3) Sanity‑check Nix configuration (client side)
Ask Nix what builders it sees:




Shell
nix config show builders
You should see the exact line you wrote (with aarch64-linux), not a path like @/etc/nix/machines, and not any ${...} placeholders.
nix

Verify the remote store is accessible:




Shell
nix store info --store 'ssh://builder@linux-builder?ssh-key=/etc/nix/builder_ed25519'
If this returns store info, the daemon can talk to the VM. If not, the builder’s shell may not have Nix on non‑interactive PATH—fix that on the VM per the manual.
nixos

4) Re‑run the build and watch for delegation
Now retry:




Shell
nix build .#packages.aarch64-linux.echo-docker --print-build-logs
You should see logs indicating building or copying via ssh://builder@linux-builder. If it still says “required system not available,” something is still off in the builders line—use a one‑off override to force delegation and confirm the spec works:




Shell
nix build .#packages.aarch64-linux.echo-docker \
  --builders 'ssh://builder@linux-builder aarch64-linux /etc/nix/builder_ed25519 4 1 - - c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUpCV2N4Yi9CbGFxdDFhdU90RStGOFFVV3JVb3RpQzVxQkorVXVFV2RWQ2Igcm9vdEBuaXhvcwo=' \
  --print-build-logs
``
If this works, the override proves your machine spec is correct; the daemon config just needs to match it.
nixos

5) (Optional) Define a Darwin package in your flake
Your flake currently does not provide packages.aarch64-darwin.echo-docker, so Darwin builds fail immediately. If you want a macOS variant, add it:




Nix
# flake.nix (example pattern)
{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs";
  outputs = { self, nixpkgs, ... }:
    let
      systems = [ "aarch64-linux" "aarch64-darwin" ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system:
        let pkgs = import nixpkgs { inherit system; };
        in f { inherit pkgs system; });
    in {
      packages = forAllSystems ({ pkgs, system }: {
        echo-docker = pkgs.callPackage ./pkgs/echo-docker { };
      });
    };
}
``

Show more lines
Check what the flake exposes:




Shell
nix flake show --all-systems
You should see both packages.aarch64-linux.echo-docker and packages.aarch64-darwin.echo-docker.
nix

Why you saw those “1 dependency failed” chains
Those are just fallout from the first error: once Nix refuses to build the initial aarch64-linux derivation on macOS, every downstream derivation that depends on it fails. Fix delegation, and those cascades disappear. This behavior is expected per Nix’s build graph semantics in the Remote Builds docs.
nixos

If it still doesn’t delegate
Post your exact builders line (redact the key if you prefer) and the output of:



Shell
nix config show builders
nix store info --store 'ssh://builder@linux-builder?ssh-key=/etc/nix/builder_ed25519'
uname -m  # on the VM (should be aarch64)

I’ll pinpoint the mismatch (platform token, host key, port, or features) and give you the corrected line.
Once the VM is running and the daemon has the correct builders spec, your original command:




Shell
nix build .#packages.aarch64-linux.echo-docker
will offload to the Linux builder automatically—no extra flags needed.
nixos
+1

Sources
Favicon typeFavicon typeFavicon type







You said:
Store URL: ssh://builder@linux-builder?ssh-key=/etc/nix/builder_ed25519
Load key "/etc/nix/builder_ed25519": Permission denied
Load key "/etc/nix/builder_ed25519": Permission denied
(builder@linux-builder) Password:
(builder@linux-builder) Password:
(builder@linux-builder) Password:
Copilot said:
Copilot
The Permission denied when loading /etc/nix/builder_ed25519 means the Nix daemon (running as root) cannot read the private key file. This is why it falls back to password prompts.

Here’s how to fix it:

✅ 1. Check file permissions
The key must be readable by root (and ideally only root). Run:




Shell
ls -l /etc/nix/builder_ed25519
Expected:

-r--------  1 root  wheel  ... /etc/nix/builder_ed25519
If it’s owned by your user or has restrictive permissions, fix it:




Shell
sudo chown root:wheel /etc/nix/builder_ed25519
sudo chmod 600 /etc/nix/builder_ed25519

✅ 2. Restart the Nix daemon
After fixing permissions:




Shell
sudo launchctl kickstart -k system/org.nixos.nix-daemon
``
✅ 3. Test again
Run:




Shell
sudo ssh -i /etc/nix/builder_ed25519 builder@linux-builder -p 31022 true
If this works without prompting for a password, the daemon will also succeed.

✅ 4. Why this matters
The Nix daemon uses that key for remote builds. If it can’t read the key, it tries password auth (which fails for non-interactive builds). Fixing permissions ensures delegation works.

Do you want me to give you a quick script to fix permissions and verify SSH connectivity automatically? Or a checklist to confirm the builder is fully ready for Nix builds?








You said:
okay now give me what I should do to run this
Copilot said:
Copilot
Here’s the complete sequence to get your remote builder working and build your flake:

✅ 1. Start the Linux builder VM
Run:




Shell
nix run nixpkgs#darwin.linux-builder
Leave this running in a terminal. It boots the NixOS VM and listens on port 31022.

✅ 2. Fix SSH key permissions
Ensure the key is readable by root:




Shell
sudo chown root:wheel /etc/nix/builder_ed25519
sudo chmod 600 /etc/nix/builder_ed25519
✅ 3. Configure Nix for remote builds
Edit /etc/nix/nix.conf and add:




INI
builders = ssh://builder@linux-builder aarch64-linux /etc/nix/builder_ed25519 4 1 - - c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUpCV2N4Yi9CbGFxdDFhdU90RStGOFFVV3JVb3RpQzVxQkorVXVFV2RWQ2Igcm9vdEBuaXhvcwo=
builders-use-substitutes = true
distributed-builds = true
max-jobs = 0
``
Restart the daemon:




Shell
sudo launchctl kickstart -k system/org.nixos.nix-daemon
✅ 4. Verify connectivity
Run:




Shell
sudo ssh -i /etc/nix/builder_ed25519 builder@linux-builder -p 31022 true
If no password prompt appears, you’re good.

✅ 5. Build your flake
Now run:




Shell
nix build .#packages.aarch64-linux.echo-docker --print-build-logs
You should see logs showing remote builds via ssh://builder@linux-builder.

✅ 6. (Optional) Add Darwin output
If you want macOS-native builds, update your flake.nix to include packages.aarch64-darwin.echo-docker using the pattern I shared earlier.

Do you want me to give you a single script that automates steps 2–4 and then runs the build, or a flake template that supports both Linux and Darwin builds?

------------------------------------------------------------------------------------------------------------------------

Need to test this from copilot:

Yes, you can absolutely use a **Linux builder inside Docker** to build Nix derivations (including `dockerTools.buildImage`) from macOS. This is a common workaround for Darwin limitations.

Here’s how it works:

***

### ✅ Why it works

*   Nix builds are sandboxed and expect Linux kernel features for `dockerTools`.
*   If you run a **Linux container with Nix installed**, you can delegate builds to it via Nix’s **remote builder protocol**.
*   macOS acts as the client; the Docker container acts as the builder.

***

### ✅ Setup Steps

#### 1. Start a Linux container with Nix

```bash
docker run --privileged -d \
  --name nix-builder \
  nixos/nix:latest \
  sleep infinity
```

(`--privileged` is needed for sandboxing and mounting.)

#### 2. Enable SSH inside the container

Install `openssh` and start the SSH daemon:

```bash
docker exec -it nix-builder bash
nix-env -iA nixpkgs.openssh
service ssh start
passwd root  # set a password or use keys
```

#### 3. Configure macOS Nix to use the container as a builder

Edit `/etc/nix/machines` on macOS:

    root@<container-ip> x86_64-linux - - 1

Or use `--builders` flag:

```bash
nix build .#svcXImage --builders 'ssh://root@<container-ip> x86_64-linux'
```

#### 4. Test

```bash
nix show-derivation .#svcXImage
nix build .#svcXImage
```

The build runs inside the Linux container and produces the Docker image tarball.

***

### ✅ Pros

*   No need for a full VM (lighter than Colima/Lima).
*   Works with `dockerTools` because the builder is Linux.
*   Reproducible and integrates with flakes.

### ✅ Cons

*   Requires SSH setup inside the container.
*   Performance depends on Docker’s filesystem and networking.

***

### ✅ Alternative: Use `nix build --impure` inside the container

Instead of remote builder, you can:

```bash
docker exec -it nix-builder bash
nix build .#svcXImage
```

Then copy the result tarball out:

```bash
docker cp nix-builder:/path/to/result ./result
```

***

Do you want me to **write a full script that spins up a Docker-based Nix builder and configures your macOS Nix to use it automatically**? Or **create a flake that includes a helper app to build via Docker and load into Minikube in one command**?


## Directory

## Useful Links

## Tags
