-- ~/.config/nvim/lua/basic.lua

-- [[ 核心设置 ]]
vim.opt.encoding = 'utf-8'
vim.o.fileencoding = "utf-8"
vim.opt.termguicolors = true    -- 启用 True Color 支持 (需要终端支持)
vim.opt.mouse = 'a'             -- 在所有模式下启用鼠标支持

-- [[ 界面与外观 ]]
vim.opt.number = true           -- 显示行号
-- vim.opt.relativenumber = true   -- 显示相对行号 (与 number 结合)
vim.opt.scrolloff = 8           -- 光标上下保留 8 行可见
vim.opt.sidescrolloff = 5       -- 光标左右保留 5 列可见
vim.opt.wrap = false            -- 禁用自动换行
vim.opt.list = true             -- 显示特殊字符 (Tab, 行尾空格等)

vim.opt.backup = false          -- 关闭备份文件
vim.opt.swapfile = false        -- 关闭交换文件 (.swp)
vim.opt.history = 1000          -- 增加命令历史记录
vim.opt.autoread = true         -- 当文件在外部被修改时自动重新读取 (如果未在 nvim 中修改)

-- [[ 缩进 ]]
vim.opt.tabstop = 4             -- Tab 宽度为 4 个空格
vim.opt.softtabstop = 4         -- 按退格键时删除 4 个空格
vim.opt.shiftwidth = 4          -- 自动缩进和 >> << 命令使用 4 个空格
vim.opt.expandtab = true        -- 输入 Tab 时插入空格，而不是制表符
vim.opt.smartindent = true      -- 启用基于 C 语言风格的智能缩进
vim.opt.autoindent = true       -- 自动将当前行的缩进应用到新行

-- [[ 搜索 ]]
vim.opt.hlsearch = true         -- 高亮所有搜索匹配项
vim.opt.incsearch = true        -- 输入搜索模式时实时显示匹配项
vim.opt.ignorecase = true       -- 搜索时忽略大小写
vim.opt.smartcase = true        -- 如果搜索模式包含大写字母，则不忽略大小写

-- [[ 性能与响应 ]]
vim.opt.updatetime = 300        -- 将光标停止后的更新时间缩短 (默认 4000ms)
vim.opt.timeoutlen = 500        -- 映射超时时间缩短 (默认 1000ms)
vim.opt.ttimeoutlen = 10        -- <Esc> 键序列的超时时间 (如果需要更快响应 Esc)
