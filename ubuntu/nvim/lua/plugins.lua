 vim.cmd [[
     call plug#begin('~/.config/nvim/plugged')
         Plug 'neoclide/coc.nvim', {'branch': 'release'}
         Plug 'preservim/nerdtree'
         Plug 'itchyny/lightline.vim'
         Plug 'nvim-lua/plenary.nvim'
         Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.x' }
     call plug#end()
 ]]
