-- ============================================================
-- Minimal Neovim-konfiguration
-- ============================================================

-- ── Grundlæggende indstillinger ─────────────────────────────

-- Space som leader key (skal sættes FØR plugins indlæses)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = vim.opt

-- Hybride linjenumre: relativ + absolut på aktuel linje
opt.number = true
opt.relativenumber = true

-- Tabs: 4 mellemrum, konvertér tabs til spaces
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true

-- Slå swap-filer fra
opt.swapfile = false

-- Brug systemets udklipsholder
opt.clipboard = "unnamedplus"

-- Fremhæv den aktuelle linje
opt.cursorline = true

-- Bedre søgning
opt.ignorecase = true
opt.smartcase = true

-- Hurtigere opdatering (god til plugins)
opt.updatetime = 250
opt.signcolumn = "yes"

-- Terminal farver
opt.termguicolors = true

-- ── Keybinds ────────────────────────────────────────────────

local map = vim.keymap.set

-- jk i insert mode = Escape
map("i", "jk", "<Esc>", { desc = "Escape med jk" })

-- ── Lazy.nvim package manager ───────────────────────────────

-- Bootstrap: hent lazy.nvim automatisk hvis den ikke findes
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- ── Plugin-liste ────────────────────────────────────────────

require("lazy").setup({

    -- Colorscheme: Tokyo Night
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000, -- Indlæs før alt andet
        config = function()
            vim.cmd.colorscheme("tokyonight")
        end,
    },

    -- Telescope: fuzzy finder
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            -- Native fzf-sortering for bedre ydeevne
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
            },
        },
        config = function()
            local telescope = require("telescope")
            telescope.setup({})
            telescope.load_extension("fzf")

            local builtin = require("telescope.builtin")
            map("n", "<leader>ff", builtin.find_files, { desc = "Find filer" })
            map("n", "<leader>fg", builtin.live_grep, { desc = "Søg i filer (grep)" })
        end,
    },

    -- Nvim-tree: filstifinder i sidepanelet
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            -- Deaktivér netrw (anbefalet af nvim-tree)
            vim.g.loaded_netrw = 1
            vim.g.loaded_netrwPlugin = 1

            require("nvim-tree").setup({})
            map("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", { desc = "Åbn/luk filstifinder" })
        end,
    },

    -- Treesitter: syntax highlighting
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = {
                    "lua", "python", "bash",
                    "javascript", "html", "css",
                    "json", "yaml", "markdown",
                },
                highlight = { enable = true },
            })
        end,
    },
})
