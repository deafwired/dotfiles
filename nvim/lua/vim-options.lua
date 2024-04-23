-- setting indents
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smartindent = true
vim.opt.breakindent = true

-- leader
vim.g.mapleader = " "

-- numbers
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.fillchars = { eob = " " }

-- better searching
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- 8 lines above and below view
vim.opt.scrolloff = 8

-- always have side column
vim.opt.signcolumn = "yes"

-- clipboard
vim.opt.clipboard = "unnamedplus"

-- no wrap
vim.opt.wrap = false

-- conceal level
vim.o.concealevel = 2

-- auto-session said i should do this
vim.o.sessionoptions="blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
