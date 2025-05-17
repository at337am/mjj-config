-- ~/.config/nvim/lua/keymap.lua

-- 1. 设置 Leader 键为空格
vim.g.mapleader = ' '
vim.g.maplocalleader = ' ' -- 通常也一起设置 localleader

-- 准备设置快捷键的函数和常用选项
local keymap = vim.keymap.set

-- 2. 定义快捷键 (仅限 Normal 模式)

-- Leader + w => 保存文件 (:w)
keymap('n', '<leader>w', '<cmd>w<cr>', { desc = "保存文件", noremap = true, silent = true })

-- Leader + q => 退出 (:q)
keymap('n', '<leader>q', '<cmd>q<cr>', { desc = "退出", noremap = true, silent = true })

-- Leader + x => 保存并退出 (:wq)
keymap('n', '<leader>x', '<cmd>wq<cr>', { desc = "保存并退出", noremap = true, silent = true })

-- Leader + Q => 强制退出 (:q!)
keymap('n', '<leader>Q', '<cmd>q!<cr>', { desc = "强制退出", noremap = true, silent = true })

-- 3. 定义快捷键 (Insert 模式)

-- 将 jk 映射为 Esc，用于退出插入模式
keymap('i', 'jk', '<Esc>', { desc = "退出插入模式 (jk)", noremap = true, silent = true })

