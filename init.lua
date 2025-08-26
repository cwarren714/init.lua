---@diagnostic disable: undefined-global
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)
require('lazy').setup({
  'tpope/vim-fugitive',
  'tpope/vim-sleuth',
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      { 'j-hui/fidget.nvim', tag = 'legacy', opts = {} },
      'folke/neodev.nvim',
    },
  },
  {
    "L3MON4D3/LuaSnip",
    -- follow latest release.
    version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
    -- install jsregexp (optional!).
    build = "make install_jsregexp"
  },
  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lsp',
      'rafamadriz/friendly-snippets',
    },
  },
  {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        -- preview hunk
        vim.keymap.set('n', '<leader>ph', require('gitsigns').preview_hunk, { buffer = bufnr, desc = 'Preview git hunk' })
        -- back hunk, auto previews
        vim.keymap.set('n', '<leader>bh', function()
          require("gitsigns").nav_hunk('prev', { buffer = bufnr, preview = true })
        end)
        -- next hunk, auto previews
        vim.keymap.set('n', '<leader>nh', function()
          require("gitsigns").nav_hunk('next', { buffer = bufnr, preview = true })
        end)
        -- reset hunk
        vim.keymap.set('n', '<leader>rh', function()
          require("gitsigns").reset_hunk()
        end)
      end,
    },
  },
  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    opts = {
      options = {
        icons_enabled = true,
        theme = 'onedark',
        component_separators = '|',
        section_separators = '',
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { { 'filename', path = 1 } },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' }
      },

    },
  },
  { 'echasnovski/mini.indentscope', version = false },
  -- "gc" to comment visual regions/lines
  -- "gcc" to commment a line in normal mode
  {
    'numToStr/Comment.nvim',
    opts = {}
  },
  {
    'ibhagwan/fzf-lua',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
      'nvim-lua/plenary.nvim'
    },
    config = function()
      require('fzf-lua').setup({
        "telescope",
        grep = {
          cmd = "rg --vimgrep --hidden --column --line-number --no-heading --color=always --smart-case"
              .. " -g '!.git/'"
              .. " -g '!node_modules/'"
              .. " -g '!*.min.*'"
              .. " -g '!*.sql'"
              .. " -g '!*.xml'"
              .. " -g '!*.svg'",
          debug = false,
        },
        winopts = {},
      })
    end
  },
  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
  },
  {
    "ray-x/lsp_signature.nvim",
    event = "VeryLazy",
    opts = {
      hint_prefix = '',
    },
    config = function(_, opts) require 'lsp_signature'.setup(opts) end
  },
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    opts = {}
  },
  -- Surround with quotes, brackets, etc
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup()
    end
  },
  -- Harpoon to quickly switch between docs
  { "ThePrimeagen/harpoon" },
  {
    "supermaven-inc/supermaven-nvim",
    config = function()
      require("supermaven-nvim").setup({})
    end,
  },
  { "vim-test/vim-test" },
  { "chentoast/marks.nvim" },
  {
    "danymat/neogen",
    config = true,
  },
  { 'prichrd/netrw.nvim' },
  { 'nvim-tree/nvim-web-devicons', opts = {} },
  { "rebelot/kanagawa.nvim" },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {}
  },
  { 'junegunn/vim-easy-align' },
  {
    "hat0uma/csvview.nvim",
    opts = {}
  },
  {
    "jake-stewart/multicursor.nvim",
    branch = "1.0",
    config = function()
      local mc = require("multicursor-nvim")
      mc.setup()
      local set = vim.keymap.set
      -- Add or skip cursor above/below the main cursor.
      set({ "n", "x" }, "<up>", function() mc.lineAddCursor(-1) end)
      set({ "n", "x" }, "<down>", function() mc.lineAddCursor(1) end)
      set({ "n", "x" }, "<leader><up>", function() mc.lineSkipCursor(-1) end)
      set({ "n", "x" }, "<leader><down>", function() mc.lineSkipCursor(1) end)
      set({ "n", "x" }, "<leader>A", function() mc.matchAllAddCursors() end)

      -- Add or skip adding a new cursor by matching word/selection
      set({ "n", "x" }, "<leader>n", function() mc.matchAddCursor(1) end)
      set({ "n", "x" }, "<leader>N", function() mc.matchAddCursor(-1) end)

      mc.addKeymapLayer(function(layerSet)
        -- Enable and clear cursors using escape.
        layerSet("n", "<esc>", function()
          if not mc.cursorsEnabled() then
            mc.enableCursors()
          else
            mc.clearCursors()
          end
        end)
      end)

      local hl = vim.api.nvim_set_hl
      hl(0, "MultiCursorCursor", { link = "Cursor" })
      hl(0, "MultiCursorVisual", { link = "Visual" })
      hl(0, "MultiCursorSign", { link = "SignColumn" })
      hl(0, "MultiCursorMatchPreview", { link = "Search" })
      hl(0, "MultiCursorDisabledCursor", { link = "Visual" })
      hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
      hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
    end
  },
  -- LSP Plugins
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  {
    -- Main LSP Configuration
    'neovim/nvim-lspconfig',
    event = "VeryLazy",
    cmd = { 'LspInfo', 'LspInstall', 'LspUninstall' },
    dependencies = {
      { 'mason-org/mason.nvim', opts = {} },
      'mason-org/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      { 'j-hui/fidget.nvim',    opts = {} },
      'saghen/blink.cmp',
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end
          map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
          map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })
          map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
          map('gd', function() require('fzf-lua').lsp_definitions() end, '[G]oto [D]efinition')
          map('gr', function() require('fzf-lua').lsp_references() end, '[G]oto [R]eferences')
          local function client_supports_method(client, method, bufnr)
            if vim.fn.has 'nvim-0.11' == 1 then
              return client:supports_method(method, bufnr)
            else
              return client.supports_method(method, { bufnr = bufnr })
            end
          end
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      -- Diagnostic Config
      vim.diagnostic.config {
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
          },
        } or {},
        virtual_text = {
          source = 'if_many',
          spacing = 2,
          format = function(diagnostic)
            local diagnostic_message = {
              [vim.diagnostic.severity.ERROR] = diagnostic.message,
              [vim.diagnostic.severity.WARN] = diagnostic.message,
              [vim.diagnostic.severity.INFO] = diagnostic.message,
              [vim.diagnostic.severity.HINT] = diagnostic.message,
            }
            return diagnostic_message[diagnostic.severity]
          end,
        },
      }

      local capabilities = require('blink.cmp').get_lsp_capabilities()
      local servers = {
        mason = {
          lua_ls = {
            settings = {
              Lua = {
                completion = {
                  callSnippet = 'Replace',
                },
              },
            },
          },
          intelephense = {
            init_options = {
              globalStoragePath = vim.fn.expand('~/.local/share/nvim/intelephense'),
            },
            settings = {
              intelephense = {
                stubs = {
                  "apache", "bcmath", "bz2", "calendar", "com_dotnet", "Core",
                  "ctype", "curl", "date", "dba", "dom", "enchant", "exif", "FFI",
                  "fileinfo", "filter", "fpm", "ftp", "gd", "gettext", "gmp", "hash",
                  "iconv", "imap", "intl", "json", "ldap", "libxml", "mbstring", "meta",
                  "mysqli", "oci8", "odbc", "openssl", "pcntl", "pcre", "PDO",
                  "pdo_ibm", "pdo_mysql", "pdo_pgsql", "pdo_sqlite", "pgsql", "Phar",
                  "posix", "pspell", "readline", "Reflection", "session", "shmop",
                  "SimpleXML", "snmp", "soap", "sockets", "sodium", "SPL", "sqlite3",
                  "standard", "superglobals", "sysvmsg", "sysvsem", "sysvshm", "tidy",
                  "tokenizer", "xml", "xmlreader", "xmlrpc", "xmlwriter", "wordpress",
                  "xsl", "Zend OPcache", "zip", "zlib"
                },
              }
            },
          }
        },
        others = {}
      }

      local ensure_installed = vim.tbl_keys(servers.mason or {})
      vim.list_extend(ensure_installed, {
        'stylua',
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      for server, config in pairs(vim.tbl_extend('keep', servers.mason, servers.others)) do
        config.capabilities = vim.tbl_deep_extend('force', {}, capabilities, config.capabilities or {})
        vim.lsp.config(server, config)
      end

      require('mason-lspconfig').setup {
        ensure_installed = {},
        automatic_enable = true,
      }

      if not vim.tbl_isempty(servers.others) then
        vim.lsp.enable(vim.tbl_keys(servers.others))
      end
    end,
  },
}, {})

-- [[ OPTIONS ]]
vim.o.hlsearch = false
vim.opt.spell = true
vim.opt.spelllang = "en_us"
vim.opt.incsearch = true
vim.opt.smartindent = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.colorcolumn = "90"
vim.opt.wrap = false
vim.o.mouse = 'a'
vim.o.clipboard = 'unnamedplus'
vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.wo.signcolumn = 'yes'
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.completeopt = 'menuone,noselect'
vim.o.termguicolors = true
vim.o.cursorline = true
vim.o.foldmethod = "expr"
vim.o.foldexpr = "nvim_treesitter#foldexpr()"
vim.o.foldlevel = 99
vim.o.foldtext = "v:lua.Fold_text()"
vim.o.autoread = true

function Fold_text()
  local line = vim.fn.getline(vim.v.foldstart)
  local line_count = vim.v.foldend - vim.v.foldstart + 1
  return " ⚡ " .. line .. ": " .. line_count .. " lines"
end

-- [[ KEYMAPS ]]
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
-- [P]roject [V]iew to return to netrw
vim.keymap.set("n", '<leader>pv', vim.cmd.Ex)

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- moving selection up and down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- moving up and down while centered
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- delete and paste but don't yank deletion into buffer
vim.keymap.set("x", "<leader>p", [["_dP]])

-- copy to system clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])

-- delete without yanking into buffer
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- change without yanking into buffer
vim.keymap.set({ "n", "v" }, "<leader>c", [["_c]])

-- replace word globally
vim.keymap.set("n", "<leader>sw", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- add ; to the end of line
vim.keymap.set('n', '<leader>;', '<esc>A;<esc>')

-- ctrl + s to save like a savage
vim.keymap.set('n', '<C-s>', '<esc>:w<CR>')

-- annotation like phpdoc
vim.keymap.set('n', '<leader>pd', ':lua require("neogen").generate()<cr>')

-- return to last buffer with leader l
vim.keymap.set({ "n", "v" }, "<leader>l", "<C-6>")

vim.keymap.set('n', '<leader>td', '<cmd>TodoTelescope<CR>', { desc = '[T]odo [D]ocument (fzf-lua)' })
vim.keymap.set('n', '<leader>tdq', '<cmd>TodoQuickFix<CR>', { desc = '[T]odo [D]ocument [Q]uickfix' })

-- search only in visual selection when in visual mode
vim.keymap.set("x", "/", "<Esc>/\\%V")

-- trying to format doc on save
-- vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.format()]]

-- Format selection
vim.keymap.set({ "n", "v" }, "<leader><space>", function()
  vim.lsp.buf.format({ async = true })
end)

--quickfix command shortcuts
vim.keymap.set('n', '<leader>qn', ':cnext<CR>')
vim.keymap.set('n', '<leader>qp', ':cprevious<CR>')
vim.keymap.set('n', '<leader>qf', ':cfirst<CR>')
vim.keymap.set('n', '<leader>ql', ':clast<CR>')

-- vim align keymaps
vim.keymap.set('v', '<leader>a', '<Plug>(EasyAlign)')

-- toggle supermaven
vim.keymap.set('n', '<leader>sm', function()
  local api = require('supermaven-nvim.api')
  api.toggle()
  print('Supermaven running: ' .. tostring(api.is_running()))
end)


-- harpoon keymaps
local mark = require("harpoon.mark")
local ui = require("harpoon.ui")
vim.keymap.set("n", "<leader>m", mark.add_file)
vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu)
vim.keymap.set("n", "<leader>1", function() ui.nav_file(1) end)
vim.keymap.set("n", "<leader>2", function() ui.nav_file(2) end)
vim.keymap.set("n", "<leader>3", function() ui.nav_file(3) end)
vim.keymap.set("n", "<leader>4", function() ui.nav_file(4) end)
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- Testing keymaps
vim.keymap.set("n", "<leader>t", "<cmd>TestNearest<CR>")
vim.keymap.set("n", "<leader>tf", "<cmd>TestFile<CR>")
vim.keymap.set("n", "<leader>ts", "<cmd>TestSuite<CR>")

require("nvim-surround").setup()
require("marks").setup(
  {
    force_write_shada = true,
    mappings = {
      preview = "pm",
      annotate = "am"
    }
  }
)
require("mini.indentscope").setup()
require('netrw').setup()
vim.cmd("colorscheme kanagawa-wave")

local fzf = require('fzf-lua')
vim.keymap.set('n', '<leader>?', fzf.oldfiles, { desc = '[?] Find recently opened files' })
-- vim.keymap.set('n', '<leader><space>', fzf.buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', fzf.blines, { desc = '[/] Fuzzily search in current buffer lines' })
vim.keymap.set('n', '<leader>gf', fzf.git_files, { desc = 'Search [G]it [F]iles' })
vim.keymap.set('n', '<leader>sf', fzf.files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', fzf.help_tags, { desc = '[S]earch [H]elp' })
-- vim.keymap.set('n', '<leader>sw', fzf.grep_cword, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', fzf.live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', fzf.diagnostics_document, { desc = '[S]earch [D]ocument Diagnostics' })
vim.keymap.set('n', '<leader>sr', fzf.resume, { desc = '[S]earch [R]esume' })

vim.defer_fn(function()
  require('nvim-treesitter.configs').setup {
    modules = {},
    sync_install = false,
    ignore_install = {},
    ensure_installed = { 'lua', 'tsx', 'javascript', 'typescript', 'vimdoc', 'vim',
      'bash', 'php', 'html', 'markdown', 'json' },
    auto_install = false,
    highlight = { enable = true },
    indent = { enable = true },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = '<c-space>',
        node_incremental = '<c-space>',
        scope_incremental = '<c-s>',
        node_decremental = '<M-space>',
      },
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          ['aa'] = '@parameter.outer',
          ['ia'] = '@parameter.inner',
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
          ['ac'] = '@class.outer',
          ['ic'] = '@class.inner',
        },
      },
      move = {
        enable = true,
        set_jumps = true,
        goto_next_start = {
          [']m'] = '@function.outer',
          [']]'] = '@class.outer',
        },
        goto_next_end = {
          [']M'] = '@function.outer',
          [']['] = '@class.outer',
        },
        goto_previous_start = {
          ['[m'] = '@function.outer',
          ['[['] = '@class.outer',
        },
        goto_previous_end = {
          ['[M'] = '@function.outer',
          ['[]'] = '@class.outer',
        },
      },
      swap = {
        enable = true,
        swap_next = {
          ['<leader>a'] = '@parameter.inner',
        },
        swap_previous = {
          ['<leader>A'] = '@parameter.inner',
        },
      },
    },
  }
end, 0)

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

function Remove_qf_item()
  local curqfidx = vim.fn.line('.')
  local qfall = vim.fn.getqflist({ idx = 0, items = 0 }).items

  if not qfall or #qfall == 0 then return end
  if curqfidx <= 0 or curqfidx > #qfall then
    print("Invalid quickfix item index")
    return
  end

  -- Remove the item from the quickfix list
  table.remove(qfall, curqfidx)

  -- Get the current quickfix list properties
  local qfinfo = vim.fn.getqflist({ title = 1 })
  local qftitle = qfinfo and qfinfo.title or ""

  -- Set the modified list back, preserving the title
  vim.fn.setqflist(qfall, 'r', { title = qftitle })

  -- If the quickfix window is open, refresh and move cursor
  local qf_winid = vim.fn.getqflist({ winid = 0 }).winid
  if qf_winid ~= 0 and vim.api.nvim_win_is_valid(qf_winid) then
    vim.cmd.copen()
    local new_total = #qfall
    local new_idx = curqfidx
    if new_total == 0 then
      return
    elseif curqfidx > new_total then
      new_idx = new_total
    end
    -- Set cursor position in the quickfix window
    vim.api.nvim_win_set_cursor(qf_winid, { new_idx, 0 })
  end
end

-- quickfix list delete keymap bound to "dd" when hovering over item in quickfix list
vim.api.nvim_create_autocmd("FileType", {
  pattern = "qf",
  callback = function()
    vim.keymap.set('n', 'dd', Remove_qf_item, { buffer = true, silent = true, desc = "Delete item from quickfix list" })
  end
})

-- remove underline from spelling errors
vim.api.nvim_set_hl(0, "SpellBad", { undercurl = false })
vim.api.nvim_set_hl(0, "SpellCap", { undercurl = false })
