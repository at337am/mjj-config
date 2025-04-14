-- ~/.config/nvim/lua/keymap.lua

-- 1. 设置 Leader 键为空格
vim.g.mapleader = ' '
vim.g.maplocalleader = ' ' -- 通常也一起设置 localleader

-- 准备设置快捷键的函数和常用选项
local keymap = vim.keymap.set

-- 2. 定义快捷键 (仅限 Normal 模式)

-- Leader + s => 保存文件 (:w)
keymap('n', '<leader>s', '<cmd>w<cr>', { desc = "保存文件", noremap = true, silent = true })

-- Leader + q => 退出 (:q)
keymap('n', '<leader>q', '<cmd>q<cr>', { desc = "退出", noremap = true, silent = true })

-- Leader + x => 保存并退出 (:wq)
keymap('n', '<leader>x', '<cmd>wq<cr>', { desc = "保存并退出", noremap = true, silent = true })

-- Leader + Q => 强制退出 (:q!)
keymap('n', '<leader>Q', '<cmd>q!<cr>', { desc = "强制退出", noremap = true, silent = true })
