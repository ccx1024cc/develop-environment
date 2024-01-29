-- trival stuff
vim.o.number = true
vim.o.fileencodings = "utf-8,ucs-bom,gb18030,gbk,gb2312,cp936"
vim.o.termencoding = "utf-8"
vim.o.encoding = "utf-8"
vim.o.cursorline = true
vim.o.showmatch = true
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.wrap = true
vim.o.linebreak = true
vim.o.wrapmargin = 2
vim.o.scrolloff = 5
vim.o.ruler = true
vim.o.history = 1000
vim.o.listchars = "tab:»■,trail:■"
vim.o.maxmempattern = 2000
vim.o.switchbuf = "usetab,newtab"
vim.o.cursorcolumn = true
vim.o.colorcolumn = "80"
vim.o.bomb = false -- remove BOM of UTF8-file
vim.opt.swapfile = false -- close swap

-- autocommand
vim.api.nvim_create_autocmd("FileType", {
    pattern = "rust",
    callback = function() vim.opt_local.foldmethod = "syntax" end
})
vim.api.nvim_create_autocmd("FileType", {
    pattern = "go",
    callback = function() vim.opt_local.foldmethod = "syntax" end
})
vim.api.nvim_create_autocmd("FileType", {
    pattern = "python",
    callback = function() vim.opt_local.foldmethod = "indent" end
})
-- vim.api.nvim_create_autocmd("User", {
--     pattern = "CocStatusChange",
--     command = "redraws"
-- })
-- update lightline automaticlly
vim.api.nvim_create_autocmd("User", {
  pattern = "CocStatusChange",
  callback = function()
    vim.fn['lightline#update']()
  end
})

-- plugins installation
require("plugins")

-- coc configuration
require("coc")

-- statusline configuration
require("statusline")

-- search configuration
require("search")

-- terminal configuration
require("term")

-- hex edition configuration
require("hexedit")
