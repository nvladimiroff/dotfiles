vim.g.mapleader = ','

-- Use the system clipboard
vim.opt.clipboard:append { 'unnamed', 'unnamedplus' }

-- Set tabs to 2 spaces
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smarttab = true

-- This maybe is needed in macos?
vim.opt.ttimeoutlen = 50

-- Always have line numbers
vim.opt.number = true

-- Keep the sign column there so UI shifting doesn't happen.
vim.opt.signcolumn = 'yes'

-- Good lord I'm bad at spelling.
vim.opt.spelllang = 'en_us'
vim.opt.spell = true


--
-- LAZY.NVIM
--
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- The only theme anyone ever needs.
    { "catppuccin/nvim", name = "catppuccin", priority = 1000 },

    -- Better syntax highlighting.
    {
      'nvim-treesitter/nvim-treesitter',
      build = ':TSUpdate',
      main = 'nvim-treesitter.configs', -- Sets main module to use for opts
      -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
      opts = {
        auto_install = true,
        highlight = {
          enable = true,
          -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
          --  If you are experiencing weird indenting issues, add the language to
          --  the list of additional_vim_regex_highlighting and disabled languages for indent.
          additional_vim_regex_highlighting = { 'ruby' },
        }
      },
    },

    -- Easy comments!
    { 'numToStr/Comment.nvim', opts = {} },

    -- File picker.
    -- TODO: on the chopping block.
    {
      "nvim-neo-tree/neo-tree.nvim",
      branch = "v3.x",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        "nvim-tree/nvim-web-devicons", -- optional, but recommended
      },
      lazy = false, -- neo-tree will lazily load itself
      opts = {
        window = {
          width = 30
        }
      }
    },

    -- fzf integration.
    {
      'nvim-telescope/telescope.nvim',
      branch = '0.1.x',
      dependencies = { 'nvim-lua/plenary.nvim' }
    },

    -- More text objects.
    { 'nvim-treesitter/nvim-treesitter-textobjects' },
    { 'nvim-mini/mini.ai', version = '*', opts = {} },

    -- LSP
    { 'neovim/nvim-lspconfig' },

    -- Sessions
    {
      "rmagatti/auto-session",
      lazy = false,

      ---enables autocomplete for opts
      ---@module "auto-session"
      ---@type AutoSession.Config
      opts = {
        suppressed_dirs = { "~/", "~/code", "~/Downloads", "/" },
        -- log_level = 'debug',
      },
    },

    -- Smooth scrolling.
    { 'karb94/neoscroll.nvim', opts = {} },

    -- Better terminal support. I use this solely for the floating terminal.
    {'akinsho/toggleterm.nvim', version = "*", config = true},
  },
  checker = { enabled = true },
})

-- Automatically update.
local function augroup(name)
  return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end

vim.api.nvim_create_autocmd("VimEnter", {
  group = augroup("autoupdate"),
  callback = function()
    if require("lazy.status").has_updates then
      require("lazy").update({ show = false, })
    end
 end,
})


--
-- THEME
--
vim.cmd.colorscheme "catppuccin-mocha"


--
-- KEYBINDS
--

-- Neotree toggle.
vim.keymap.set('n', '<leader>e', ':Neotree toggle=true<CR>', { silent = true })

-- Double escape to clear searches.
vim.keymap.set('n', '<Esc><Esc>', '<Esc>:nohlsearch<CR><Esc>', {silent = true})

-- Telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

-- Buffers.
vim.keymap.set('n', 'L', '<Esc>:bn<CR>', { silent = true })
vim.keymap.set('n', 'H', '<Esc>:bp<CR>', { silent = true })
vim.keymap.set('n', '<leader>x', ':bd<CR>', { silent = true })

-- Smooth scrolling with a mouse.
vim.keymap.set('n', '<ScrollWheelUp>', '<C-y>')
vim.keymap.set('n', '<ScrollWheelDown>', '<C-e>')
vim.keymap.set('i', '<ScrollWheelUp>', '<C-y>')
vim.keymap.set('i', '<ScrollWheelDown>', '<C-e>')
vim.keymap.set('v', '<ScrollWheelUp>', '<C-y>')
vim.keymap.set('v', '<ScrollWheelDown>', '<C-e>')


-- LazyGit toggle.
local Terminal  = require('toggleterm.terminal').Terminal
local lazygit = Terminal:new({ cmd = "lazygit", hidden = true, direction = 'float' })

function _lazygit_toggle()
  lazygit:toggle()
end

vim.keymap.set('n', '<leader>g', '<cmd>lua _lazygit_toggle()<CR>', {noremap = true, silent = true})


-- Blame
vim.keymap.set('n', '<leader>b', function()
  local bufnr = vim.api.nvim_get_current_buf()
  local filename = vim.api.nvim_buf_get_name(bufnr)
  local row = vim.api.nvim_win_get_cursor(0)[1]

  local blame_info = vim.fn.systemlist('git blame -L ' .. row .. ',+1 ' .. filename .. ' --porcelain')
  if blame_info[2] ~= nil then
    local hash = string.sub(blame_info[1], 1, 8)
    local author_name = string.sub(blame_info[2], 8)
    local author_date = os.date('%Y %b %d', tonumber(string.sub(blame_info[4], 12)))
    local summary = string.sub(blame_info[10], 9)
    print(hash .. " - " .. author_name .. " - " .. author_date .. " - " ..  summary)
  else
    print(blame_info[1])
  end
end)

-- Toggle terminal
vim.keymap.set('n', '<leader>t', '<cmd>ToggleTerm dir=git_dir direction=float<CR>', { silent = true })
vim.keymap.set('t', '<leader>t', '<cmd>ToggleTerm dir=git_dir direction=float<CR>', { silent = true })

-- Format JSON.
vim.keymap.set('n', '<leader>j', "<cmd>%!jq '.'<CR>", { silent = true })


--
-- AUTOSAVE
--
vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertLeave" }, {
  callback = function()
    if vim.bo.modified and not vim.bo.readonly and vim.fn.expand("%") ~= "" and vim.bo.buftype == "" then
      -- Remove trailing whitespace.
      save_cursor = vim.fn.getpos(".")
      vim.cmd([[%s/\s\+$//e]])
      vim.fn.setpos(".", save_cursor)

      -- Save.
      vim.api.nvim_command('silent update')
    end
  end,
})


--
-- LSP
--
vim.lsp.enable('ruby_lsp')
