# Swift Setup - Nvim

## Abstract
How to setup Swift for Nvim
```lua
        -- Manual setup for sourcekit-lsp
        require("lspconfig").sourcekit.setup({
            --cmd = { "xcrun", "sourcekit-lsp" }, -- or full path if needed
            capabilities = vim.tbl_deep_extend("force", capabilities, {
                workspace = {
                    didChangeWatchedFiles = {
                        dynamicRegistration = true,
                    },
                },
            }),
            --filetypes = { "swift", "objective-c", "objective-cpp", "c", "cpp" },
            root_dir = require("lspconfig.util").root_pattern("Package.swift", ".git"),
        })

```

## Directory

## Useful Links
("Setup Guide")[https://www.swift.org/documentation/articles/zero-to-swift-nvim.html#language-server-support]

## Tags
[[swift-setup]]
