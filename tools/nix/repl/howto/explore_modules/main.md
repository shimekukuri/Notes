# nix (command) repl howto - explore modules

## Abstract
Example of how to explore the modules for the nixvim flake:
Deliberated between discovery commands and direct instructions for nixvim evaluation

Step 1 — Open the repl:
```bash
nix repl
```

Step 2 — Load the flakes:
```nix
pkgsFlake = builtins.getFlake "github:nixos/nixpkgs/nixos-unstable"
nvFlake = builtins.getFlake "github:nix-community/nixvim"
```

Step 3 — Find the exact argument names evalNixvim expects:
```nix
builtins.functionArgs nvFlake.lib.evalNixvim
```

Look at the output here before going further. It will look something like { modules = true; system = false; } and tells us exactly what to pass.

Step 4 — Based on what step 3 returns, run one of these:
If it showed system:
nixeval = nvFlake.lib.evalNixvim { system = "x86_64-linux"; modules = []; }
If it showed nixpkgs:
nixeval = nvFlake.lib.evalNixvim { nixpkgs = pkgsFlake; modules = []; }

Step 5 — Browse plugins:
nixeval.options.plugins.<TAB>

nix-repl> nixeval.options.plugins.conform-nvim.settings.type
{
  _type = "option-type";
  check = { ... };
  deprecationMessage = null;
  description = "open submodule of attribute set of lua value";
  descriptionClass = null;
  emptyValue = { ... };
  functor = { ... };
  getSubModules = [ ... ];
  getSubOptions = «lambda getSubOptions @ /nix/store/kn3m407mn5p4dyjb96z12daanqjaqmzc-source/lib/types.nix:1326:9»;
  merge = { ... };
  name = "submodule";
  nestedTypes = { ... };
  substSubModules = «lambda substSubModules @ /nix/store/kn3m407mn5p4dyjb96z12daanqjaqmzc-source/lib/types.nix:1347:9»;
  typeMerge = «lambda defaultTypeMerge @ /nix/store/kn3m407mn5p4dyjb96z12daanqjaqmzc-source/lib/types.nix:152:8»;
}

nix-repl> nixeval.options.plugins.conform-nvim.settings.type.getSubModules
[
  { ... }
]

nix-repl> nixeval.options.plugins.conform-nvim.settings.type.getSubModules
[
  { ... }
]

nix-repl> nixeval.options.plugins.conform-nvim.settings.type.getSubOptions
«lambda getSubOptions @ /nix/store/kn3m407mn5p4dyjb96z12daanqjaqmzc-source/lib/types.nix:1326:9»

nix-repl> nixeval.options.plugins.conform-nvim.settings.type.getSubOptions []
{
  _freeformOptions = { ... };
  _module = { ... };
  default_format_opts = { ... };
  format_after_save = { ... };
  format_on_save = { ... };
  formatters = { ... };
  formatters_by_ft = { ... };
  log_level = { ... };
  notify_no_formatters = { ... };
  notify_on_error = { ... };
}

more examples:
nix-repl> nixeval.options.plugins.trouble.settings.type
{
  _type = "option-type";
  check = { ... };
  deprecationMessage = null;
  description = "open submodule of attribute set of lua value";
  descriptionClass = null;
  emptyValue = { ... };
  functor = { ... };
  getSubModules = [ ... ];
  getSubOptions = «lambda getSubOptions @ /nix/store/kn3m407mn5p4dyjb96z12daanqjaqmzc-source/lib/types.nix:1326:9»;
  merge = { ... };
  name = "submodule";
  nestedTypes = { ... };
  substSubModules = «lambda substSubModules @ /nix/store/kn3m407mn5p4dyjb96z12daanqjaqmzc-source/lib/types.nix:1347:9»;
  typeMerge = «lambda defaultTypeMerge @ /nix/store/kn3m407mn5p4dyjb96z12daanqjaqmzc-source/lib/types.nix:152:8»;
}

nix-repl> nixeval.options.plugins.trouble.settings.type.getSubOptions []
{
  _freeformOptions = { ... };
  _module = { ... };
  auto_close = { ... };
  auto_jump = { ... };
  auto_preview = { ... };
  auto_refresh = { ... };
  focus = { ... };
  follow = { ... };
  icons = { ... };
  indent_guides = { ... };
  keys = { ... };
  max_items = { ... };
  modes = { ... };
  multiline = { ... };
  open_no_results = { ... };
  pinned = { ... };
  preview = { ... };
  restore = { ... };
  warn_no_results = { ... };
  win = { ... };
}

nix-repl> (nixeval.options.plugins.trouble.settings.type.getSubOptions []).keys
{
  __toString = «lambda __toString @ /nix/store/kn3m407mn5p4dyjb96z12daanqjaqmzc-source/lib/modules.nix:1172:20»;
  _type = "option";
  declarationPositions = [ ... ];
  declarations = [ ... ];
  default = null;
  defaultText = { ... };
  definitions = [ ... ];
  definitionsWithLocations = [ ... ];
  description = "Key mappings can be set to the name of a builtin action,\nor you can define your own custom action.\n";
  files = [ ... ];
  highestPrio = 1500;
  isDefined = true;
  loc = [ ... ];
  options = [ ... ];
  type = { ... };
  value = null;
  valueMeta = { ... };
}


## Directory

## Useful Links

## Tags
