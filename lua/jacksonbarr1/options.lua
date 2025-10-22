local g = vim.g
local o = vim.o

g.mapleader = " "
g.maplocalleader = " "

g.have_nerd_font = true

g.loaded_netrw = 1
g.loaded_netrwPlugin = 1

o.number = true
o.relativenumber = true

o.mouse = "a"

o.clipboard = "unnamedplus"

o.tabstop = 4
o.softtabstop = 4
o.shiftwidth = 4
o.expandtab = true

o.smartindent = true

o.wrap = false

o.swapfile = false
o.backup = false
o.undodir = os.getenv("HOME") .. "/.vim/undodir"
o.undofile = true

o.hlsearch = false
o.incsearch = true

o.termguicolors = true

o.scrolloff = 8
o.signcolumn = "yes"

o.updatetime = 50

o.exrc = true
o.secure = true
