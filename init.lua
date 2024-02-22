return {
  -- Configure AstroNvim updates
  updater = {
    remote = "origin", -- remote to use
    channel = "stable", -- "stable" or "nightly"
    version = "latest", -- "latest", tag name, or regex search like "v1.*" to only do updates before v2 (STABLE ONLY)
    branch = "nightly", -- branch name (NIGHTLY ONLY)
    commit = nil, -- commit hash (NIGHTLY ONLY)
    pin_plugins = nil, -- nil, true, false (nil will pin plugins on stable only)
    skip_prompts = false, -- skip prompts about breaking changes
    show_changelog = true, -- show the changelog after performing an update
    auto_quit = false, -- automatically quit the current session after a successful update
    remotes = { -- easily add new remotes to track
      --   ["remote_name"] = "https://remote_url.come/repo.git", -- full remote url
      --   ["remote2"] = "github_user/repo", -- GitHub user/repo shortcut,
      --   ["remote3"] = "github_user", -- GitHub user assume AstroNvim fork
    },
  },

  -- Set colorscheme to use
  colorscheme = "catppuccin-mocha",

  -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
  diagnostics = {
    virtual_text = true,
    underline = true,
  },

  mappings = {
    ["<leader>gg"] = {
      function()
        astronvim.toggle_term_cmd "lazygit -ucf '/Users/sethetter/Library/Application Support/lazygit/nvim.yml'"
      end,
      desc = "Open lazygit",
    },
  },

  lsp = {
    -- customize lsp formatting options
    formatting = {
      -- control auto formatting on save
      format_on_save = {
        enabled = true, -- enable or disable format on save globally
        allow_filetypes = { -- enable format on save for specified filetypes only
          -- "go",
        },
        ignore_filetypes = { -- disable format on save for specified filetypes
          -- "python",
        },
      },
      disabled = { -- disable formatting capabilities for the listed language servers
        -- disable lua_ls formatting capability if you want to use StyLua to format your lua code
        -- "lua_ls",
      },
      timeout_ms = 1000, -- default format timeout
      -- filter = function(client) -- fully override the default formatting function
      --   return true
      -- end
    },
    -- enable servers that you already have installed without mason
    servers = {
      -- "pyright"
    },
  },

  -- Configure require("lazy").setup() options
  lazy = {
    defaults = { lazy = true },
    performance = {
      rtp = {
        -- customize default disabled vim plugins
        disabled_plugins = { "tohtml", "gzip", "matchit", "zipPlugin", "netrwPlugin", "tarPlugin" },
      },
    },
  },

  -- This function is run last and is a good place to configuring
  -- augroups/autocommands and custom filetypes also this just pure lua so
  -- anything that doesn't fit in the normal config locations above can go here
  polish = function()
    -- vim.cmd "hi Normal guibg=NONE ctermbg=NONE"
    -- vim.cmd "hi EndOfBuffer guibg=NONE ctermbg=NONE"
    -- vim.cmd "hi Normal guibg=NONE ctermbg=NONE"

    vim.cmd [[
" inverted cursor workaround for windows terminal
" guicursor will leave reverse to the terminal, which won't work in WT.
" therefore we will set bg and fg colors explicitly in an autocmd.
" however guicursor also ignores fg colors, so fg color will be set
" with a second group that has gui=reverse.
hi! WindowsTerminalCursorFg gui=none
hi! WindowsTerminalCursorBg gui=none
set guicursor+=n-v-c-sm:block-WindowsTerminalCursorBg

function! WindowsTerminalFixHighlight()
    " reset match to the character under cursor
    silent! call matchdelete(99991)
    call matchadd('WindowsTerminalCursorFg', '\%#.', 100, 99991)

    " find fg color under cursor or fall back to Normal fg then black
    let bg = synIDattr(synIDtrans(synID(line("."), col("."), 1)), 'fg#')
    if bg == "" | let bg = synIDattr(synIDtrans(hlID('Normal')), 'fg#') | endif
    if bg == "" | let bg = "black" | endif
    exec 'hi WindowsTerminalCursorBg guibg=' . bg
    " reset this group so it survives theme changes
    hi! WindowsTerminalCursorFg gui=reverse
endfunction

function! WindowsTerminalFixClear()
    " hide cursor highlight
    silent! call matchdelete(99991)

    " make cursor the default color or black in insert mode
    let bg = synIDattr(synIDtrans(hlID('Normal')), 'fg#')
    if bg == "" | let bg = "black" | endif
    exec 'hi WindowsTerminalCursorBg guibg=' . bg
endfunction

augroup windows_terminal_fix
    autocmd!
    autocmd FocusLost * call WindowsTerminalFixClear()
    autocmd FocusGained * if mode(1) != "i" | call WindowsTerminalFixHighlight() | endif

    autocmd InsertEnter * call WindowsTerminalFixClear()
    autocmd InsertLeave * call WindowsTerminalFixHighlight()
    autocmd CursorMoved * call WindowsTerminalFixHighlight()
augroup END
]]
    -- Set up custom filetypes
    -- vim.filetype.add {
    --   extension = {
    --     foo = "fooscript",
    --   },
    --   filename = {
    --     ["Foofile"] = "fooscript",
    --   },
    --   pattern = {
    --     ["~/%.config/foo/.*"] = "fooscript",
    --   },
    -- }
  end,
}
