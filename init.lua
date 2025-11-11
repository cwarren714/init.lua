---@diagnostic disable: undefined-global
vim.o.number = true
vim.o.relativenumber = true
vim.o.wrap = false
vim.o.tabstop = 4
vim.o.swapfile = false
vim.g.mapleader = ' '
vim.o.hlsearch = false
vim.o.spelllang = "en_us"
vim.o.incsearch = true
vim.o.smartindent = true
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.winborder = "rounded"
vim.o.smartcase = true
vim.o.ignorecase = true

-- shout out
vim.keymap.set('n', '<leader>o', ':update<CR> :source<CR>')

vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
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

-- find and centered
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

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

-- quickfix navigation
vim.keymap.set('n', '<C-N>', ':cnext<CR>')
vim.keymap.set('n', '<C-P>', ':cprev<CR>')
vim.keymap.set('n', '<leader>qc', ':cclose<CR>')
vim.keymap.set('n', '<leader>qo', ':copen<CR>')

-- managing packages --
vim.pack.add({
    { src = "https://github.com/neovim/nvim-lspconfig" },
    { src = "https://github.com/ibhagwan/fzf-lua" },
    { src = "https://github.com/nvim-mini/mini.completion" },
    { src = "https://github.com/nvim-mini/mini.icons" },
    { src = "https://github.com/prichrd/netrw.nvim" },
    { src = "https://github.com/mason-org/mason.nvim" },
    { src = "https://github.com/lewis6991/gitsigns.nvim" },
    { src = "https://github.com/tpope/vim-fugitive" },
    { src = "https://github.com/vim-test/vim-test" },
    { src = "https://github.com/rose-pine/neovim" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
    { src = "https://github.com/danymat/neogen" },
    { src = "https://github.com/junegunn/vim-easy-align" },
    { src = "https://github.com/OXY2DEV/markview.nvim" },
    { src = "https://github.com/monkoose/neocodeium" },
})

require "mini.completion".setup()
require "mini.icons".setup()
require "netrw".setup()
require "mason".setup()
require "neogen".setup()
require "rose-pine".setup()
require "fzf-lua".setup({ "telescope" })
require "gitsigns".setup(
    {
        signs = {
            add = { text = '+' },
            change = { text = '~' },
            delete = { text = '_' },
            topdelete = { text = '‾' },
            changedelete = { text = '~' },
        },
        on_attach = function(bufnr)
            -- preview hunk
            vim.keymap.set('n', '<leader>ph', require('gitsigns').preview_hunk,
                { buffer = bufnr, desc = 'Preview git hunk' })
            -- next hunk, auto previews
            vim.keymap.set('n', '<leader>nh', function()
                require("gitsigns").nav_hunk('next', { buffer = bufnr, preview = true })
            end)
            -- reset hunk
            vim.keymap.set('n', '<leader>rh', function()
                require("gitsigns").reset_hunk()
            end)
        end,
    })

-- note ts_ls requires presence of package manager file:
-- https://github.com/neovim/nvim-lspconfig/blob/master/lsp/ts_ls.lua#L61
vim.lsp.enable({ "lua_ls", "ts_ls", "gopls", "yamlls", "dockerls", "jsonls", "docker_compose_language_service", "bashls",
    "html", "cssls", "marksman", "helm_ls", "intelephense" })

-- wordpress interactivity lsp config and enable
-- vim.lsp.config('wordpress-interactivity-lsp', {
--     cmd = { 'wordpress-interactivity-lsp', '--stdio' },
--     filetypes = { 'html', 'php' },
--     root_markers = { 'package.json', '.git', 'composer.json' },
-- })
-- vim.api.nvim_create_autocmd('FileType', {
--     pattern = { 'html', 'php' },
--     callback = function(args)
--         vim.lsp.enable('wordpress-interactivity-lsp')
--     end,
-- })


vim.lsp.config('intelephense', {
    settings = {
        intelephense = {
            stubs = {
                "apache", "bcmath", "bz2", "calendar", "com_dotnet", "Core", "ctype", "curl", "date",
                "dba", "dom", "enchant", "exif", "FFI", "fileinfo", "filter", "fpm", "ftp", "gd",
                "gettext", "gmp", "hash", "iconv", "imap", "intl", "json", "ldap", "libxml", "mbstring",
                "meta", "mysqli", "oci8", "odbc", "openssl", "pcntl", "pcre", "PDO", "pdo_ibm",
                "pdo_mysql", "pdo_pgsql", "pdo_sqlite", "pgsql", "Phar", "posix", "pspell", "readline",
                "Reflection", "session", "shmop", "SimpleXML", "snmp", "soap", "sockets", "sodium",
                "SPL", "sqlite3", "standard", "superglobals", "sysvmsg", "sysvsem", "sysvshm", "tidy",
                "tokenizer", "xml", "xmlreader", "xmlrpc", "xmlwriter", "xsl", "Zend OPcache", "zip",
                "zlib", "wordpress"
            },
        }
    }
})

require 'nvim-treesitter.configs'.setup {
    sync_install = false,
    auto_install = true,
    highlight = {
        enable                            = true,
        additional_vim_regex_highlighting = false,
    },
    indent = {
        enable = true,
    },
}

-- more keymaps
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

vim.keymap.set('n', 'gd', vim.lsp.buf.type_definition)
vim.keymap.set('n', 'gr', vim.lsp.buf.references)
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename)

vim.keymap.set('n', '<leader>sf', ":FzfLua files<CR>")
vim.keymap.set('n', '<leader>/', ":FzfLua blines<CR>")
vim.keymap.set('n', '<leader>sr', ":FzfLua resume<CR>")
vim.keymap.set('n', '<leader>sd', ":FzfLua diagnostics_document<CR>")
vim.keymap.set('n', '<leader>sh', ":FzfLua help_tags<CR>")
vim.keymap.set('n', '<leader>sg', ":FzfLua live_grep_native<CR>")
vim.keymap.set('n', '<leader>gd', ":FzfLua lsp_definitions<CR>")
vim.keymap.set('n', '<leader>gr', ":FzfLua lsp_references<CR>")

vim.keymap.set({ 'n', 'v' }, '<leader>lf', vim.lsp.buf.format)

vim.keymap.set("n", "<leader>t", "<cmd>TestNearest<CR>")

-- annotation like phpdoc
vim.keymap.set('n', '<leader>pd', ':lua require("neogen").generate()<cr>')

-- vim align keymaps
vim.keymap.set('v', '<leader>a', '<Plug>(EasyAlign)')

-- pack update
vim.keymap.set('n', '<leader>u', ":lua vim.pack.update()<CR>")

-- neocodeium keymaps
local nc = require("neocodeium")
nc.setup()
vim.keymap.set("i", "<Tab>", function()
    nc.accept()
end)
vim.keymap.set("i", "<C-j>", function()
    nc.cycle_or_complete()
end)
vim.keymap.set("i", "<C-k>", function()
    nc.cycle_or_complete(-1)
end)

vim.cmd("colorscheme rose-pine-moon")
