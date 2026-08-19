-- ┌─────────────────────────┐
-- │ Plugins outside of MINI │
-- └─────────────────────────┘
--
-- This file contains installation and configuration of plugins outside of MINI.
-- They significantly improve user experience in a way not yet possible with MINI.
-- These are mostly plugins that provide programming language specific behavior.
--
-- Use this file to install and configure other such plugins.

-- Make concise helpers for installing/adding plugins in two stages
local add = vim.pack.add
local now_if_args, later, now = Config.now_if_args, Config.later, Config.now

-- Tree-sitter ================================================================

-- Tree-sitter is a tool for fast incremental parsing. It converts text into
-- a hierarchical structure (called tree) that can be used to implement advanced
-- and/or more precise actions: syntax highlighting, textobjects, indent, etc.
--
-- Tree-sitter support is built into Neovim (see `:h treesitter`). However, it
-- requires two extra pieces that don't come with Neovim directly:
-- - Language parsers: programs that convert text into trees. Some are built-in
--   (like for Lua), 'nvim-treesitter' provides many others.
--   NOTE: It requires third party software to build and install parsers.
--   See the link for more info in "Requirements" section of the MiniMax README.
-- - Query files: definitions of how to extract information from trees in
--   a useful manner (see `:h treesitter-query`). 'nvim-treesitter' also provides
--   these, while 'nvim-treesitter-textobjects' provides the ones for Neovim
--   textobjects (see `:h text-objects`, `:h MiniAi.gen_spec.treesitter()`).
--
-- Add these plugins now if file (and not 'mini.starter') is shown after startup.
--
-- Troubleshooting:
-- - Run `:checkhealth vim.treesitter nvim-treesitter` to see potential issues.
-- - In case of errors related to queries for Neovim bundled parsers (like `lua`,
--   `vimdoc`, `markdown`, etc.), manually install them via 'nvim-treesitter'
--   with `:TSInstall <language>`. Be sure to have necessary system dependencies
--   (see MiniMax README section for software requirements).
now_if_args(function()

    -- Config.on_packchanged("nvim-treesitter", { "install", "update" }, vim.cmd.TSUpdate)
    --
    -- vim.pack.add({
    --     Config.github("nvim-treesitter/nvim-treesitter"),
    -- })
    --
    -- local treesitter = require("nvim-treesitter")
    --
    -- ---@type table<string, string>
    -- local installed_for_fts = {}
    --
    -- ---@param lang string
    -- local function mark_fts_as_installed_for_lang(lang)
    --     local fts = vim.treesitter.language.get_filetypes(lang)
    --     for _, ft in ipairs(fts) do
    --         installed_for_fts[ft] = lang
    --     end
    -- end
    --
    -- for _, lang in ipairs(treesitter.get_installed("parsers")) do
    --     mark_fts_as_installed_for_lang(lang)
    -- end
    --
    -- local available_parsers = require("nvim-treesitter.parsers")
    --
    -- Config.new_autocmd("FileType", "*", function(event)
    --     local buf = event.buf
    --     local ft = event.match
    --
    --     local installed_lang = installed_for_fts[ft]
    --     if installed_lang then
    --         vim.treesitter.start(buf, installed_lang)
    --         return
    --     end
    --
    --     local lang = vim.treesitter.language.get_lang(ft) or ft
    --     if not available_parsers[lang] then
    --         return
    --     end
    --
    --     treesitter.install(lang):await(function()
    --         vim.treesitter.start(buf, lang)
    --         mark_fts_as_installed_for_lang(lang)
    --     end)
    -- end)

  -- Define hook to update tree-sitter parsers after plugin is updated
  local ts_update = function() vim.cmd('TSUpdate') end
  Config.on_packchanged('nvim-treesitter', { 'update' }, ts_update, ':TSUpdate')

  add({
    'https://github.com/nvim-treesitter/nvim-treesitter',
    'https://github.com/nvim-treesitter/nvim-treesitter-textobjects',
  })

  -- Define languages which will have parsers installed and auto enabled
  -- After changing this, restart Neovim once to install necessary parsers. Wait
  -- for the installation to finish before opening a file for added language(s).
  local languages = {
    -- These are already pre-installed with Neovim. Used as an example.
    'lua',
    'vimdoc',
    'markdown',
    'java',
    'kotlin'
    -- Add here more languages with which you want to use tree-sitter
    -- To see available languages:
    -- - Execute `:=require('nvim-treesitter').get_available()`
    -- - Visit 'SUPPORTED_LANGUAGES.md' file at
    --   https://github.com/nvim-treesitter/nvim-treesitter/blob/main
  }
  local isnt_installed = function(lang)
    return #vim.api.nvim_get_runtime_file('parser/' .. lang .. '.*', false) == 0
  end
  local to_install = vim.tbl_filter(isnt_installed, languages)
  if #to_install > 0 then require('nvim-treesitter').install(to_install) end

  -- Enable tree-sitter after opening a file for a target language
  local filetypes = {}
  for _, lang in ipairs(languages) do
    for _, ft in ipairs(vim.treesitter.language.get_filetypes(lang)) do
      table.insert(filetypes, ft)
    end
  end
  local ts_start = function(ev) vim.treesitter.start(ev.buf) end
  Config.new_autocmd('FileType', filetypes, ts_start, 'Start tree-sitter')
end)

now(function()
  add({ Config.github("folke/lazydev.nvim") })
  require('lazydev').setup()
end)

now(function()
  add({ 'https://codeberg.org/mfussenegger/nvim-dap' })
  add({ 'https://github.com/Mgenuit/nvim-dap-kotlin' })
  require('dap-kotlin').setup {
    dap_command = "kotlin-debug-adapter",
  }

  local dap = require('dap')
  dap.adapters.kotlin = {
    type = 'executable',
    command = "kotlin-debug-adapter",
  }
  dap.configurations.kotlin = {
    {
      type = 'kotlin',
      request = 'attach',
      name = 'Attach to minecraft (debug)',
      hostName = '127.0.0.1',
      port = 5005,
      timeout = 30000,
      projectRoot = '${workspaceFolder}',
    }
  }
  add({ 'https://github.com/rcarriga/nvim-dap-ui' })
  add({ Config.github('nvim-neotest/nvim-nio')})

  local dapui = require("dapui")
  dapui.setup()
  -- автоматически открывать/закрывать UI при старте/завершении отладки
  dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
  dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
  dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end
  -- add({ 'https://github.com/ChristianChiarulli/neovim-codicons' })
end)

--Language servers ===========================================================
-- Language Server Protocol (LSP) is a set of conventions that power creation of
-- language specific tools. It requires two parts:
-- - Server - program that performs language specific computations.
-- - Client - program that asks server for computations and shows results.
--
-- Here Neovim itself is a client (see `:h vim.lsp`). Language servers need to
-- be installed separately based on your OS, CLI tools, and preferences.
-- See note about 'mason.nvim' at the bottom of the file.
--
-- Neovim's team collects commonly used configurations for most language servers
-- inside 'neovim/nvim-lspconfig' plugin.
--
-- Add it now if file (and not 'mini.starter') is shown after startup.
now(function()
  add({ 'https://github.com/neovim/nvim-lspconfig' })
  add({ 'https://github.com/MunifTanjim/nui.nvim' })
  -- add({ 'https://github.com/nvim-java/nvim-java' })
  -- require('java').setup()
  add({ 'https://github.com/mfussenegger/nvim-jdtls' })
  
  add({ 'https://github.com/mason-org/mason.nvim' })
  require("mason").setup()
  add({ 'https://github.com/mason-org/mason-lspconfig.nvim' })
  require("mason-lspconfig").setup()
  add({ 'https://github.com/stevearc/oil.nvim' })
  require("oil").setup()
  add({ 'https://github.com/folke/trouble.nvim' })
  require('trouble').setup()
  add({ 'https://github.com/AlexandrosAlexiou/kotlin.nvim' })
  require('kotlin').setup()

  -- Arduino
  add({ 'https://github.com/yuukiflow/Arduino-Nvim'})
  require('Arduino-Nvim').setup({
      config_file = ".arduinoNvim_config.lua",
      board = "esp32:esp32:esp32c3",
      port = "/dev/ttyACM0",
      use_default_keymaps = false,
      picker_backend = "nvim"
  })
  -- Use `:h vim.lsp.enable()` to automatically enable language server based on
  -- the rules provided by 'nvim-lspconfig'.
  -- Use `:h vim.lsp.config()` or 'after/lsp/' directory to configure servers.
  -- Uncomment and tweak the following `vim.lsp.enable()` call to enable servers.
  vim.lsp.config("jdtls", {
      root_markers = {"."}
  })
  vim.lsp.enable({
    'lua_ls',
    'ts_ls',
    'gopls',
    'jdtls',
    -- 'kotlin-language-server',
    'kotlin_lsp',
    'arduino_language_server'
    -- For example, if `lua-language-server` is installed, use `'lua_ls'` entry
  })
  vim.lsp.config("arduino_language_server", {
      cmd = {
        "arduino-language-server",
        "-clangd", "clangd",                                      -- Path to clangd binary
        "-cli", "arduino-cli",                                    -- Path to arduino-cli binary
        "-cli-config", vim.fn.expand("~/.arduino15/arduino-cli.yaml"), -- Path to config yaml
        "-fqbn", "esp32:esp32:esp32c3"                                -- The exact board profile
      }
  })
end)

-- now(function()
--     -- add({ 'https://github.com/MunifTanjim/nui.nvim' })
--     -- add({ 'https://github.com/nvim-java/nvim-java' })
-- end)
-- Formatting =================================================================

-- Programs dedicated to text formatting (a.k.a. formatters) are very useful.
-- Neovim has built-in tools for text formatting (see `:h gq` and `:h 'formatprg'`).
-- They can be used to configure external programs, but it might become tedious.
--
-- The 'stevearc/conform.nvim' plugin is a good and maintained solution for easier
-- formatting setup.
later(function()
  add({ 'https://github.com/stevearc/conform.nvim' })

  -- See also:
  -- - `:h Conform`
  -- - `:h conform-options`
  -- - `:h conform-formatters`
  require('conform').setup({
    default_format_opts = {
      -- Allow formatting from LSP server if no dedicated formatter is available
      lsp_format = 'fallback',
    },
    -- Map of filetype to formatters
    -- Make sure that necessary CLI tool is available
    -- formatters_by_ft = { lua = { 'stylua' } },
  })
end)

-- Snippets ===================================================================

-- Although 'mini.snippets' provides functionality to manage snippet files, it
-- deliberately doesn't come with those.
--
-- The 'rafamadriz/friendly-snippets' is currently the largest collection of
-- snippet files. They are organized in 'snippets/' directory (mostly) per language.
-- 'mini.snippets' is designed to work with it as seamlessly as possible.
-- See `:h MiniSnippets.gen_loader.from_lang()`.
later(function() add({ 'https://github.com/rafamadriz/friendly-snippets' }) end)

now(function() 
  add({ 'https://github.com/Mofiqul/dracula.nvim' }) 
  vim.cmd.colorscheme('dracula')
end)


now(function() 
  add({ 'https://github.com/2kabhishek/nerdy.nvim' })

  require('nerdy').setup({
    dependencies = {
        'folke/snacks.nvim',
    },
    cmd = 'Nerdy',
    opts = {
        max_recents = 30, -- Configure recent icons limit
        copy_to_clipboard = false, -- Copy glyph to clipboard instead of inserting
        copy_register = '+', -- Register to use for copying (if `copy_to_clipboard` is true)
    },
    keys = {
        { '<leader>in', ':Nerdy list<CR>', desc = "Browse nerd icons" },
        { '<leader>iN', ':Nerdy recents<CR>', desc = "Browse recent nerd icons" },
    },
  }) 
end)
-- Honorable mentions =========================================================

-- 'mason-org/mason.nvim' (a.k.a. "Mason") is a great tool (package manager) for
-- installing external language servers, formatters, and linters. It provides
-- a unified interface for installing, updating, and deleting such programs.
--
-- The caveat is that these programs will be set up to be mostly used inside Neovim.
-- If you need them to work elsewhere, consider using other package managers.
--
-- You can use it like so:
-- now_if_args(function()
--   add({ 'https://github.com/mason-org/mason.nvim' })
--   require('mason').setup()
-- end)

-- Beautiful, usable, well maintained color schemes outside of 'mini.nvim' and
-- have full support of its highlight groups. Use if you don't like 'miniwinter'
-- enabled in 'plugin/30_mini.lua' or other suggested 'mini.hues' based ones.
-- Config.now(function()
--  -- Install only those that you need
--  add({
--    'https://github.com/sainnhe/everforest',
--    'https://github.com/Shatur/neovim-ayu',
--    'https://github.com/ellisonleao/gruvbox.nvim',
--  })
--
--   -- Enable only one
--   vim.cmd('color everforest')
-- end)
