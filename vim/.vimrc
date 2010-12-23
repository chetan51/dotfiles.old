" Vim editor and display settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Disable compatibility
set nocompatible

" Hide toolbar by default
if has("gui_running")
	set guioptions=egmrt
endif

" Hide buffers instead of closing them
set hidden

" Disable modelines for security
set modelines=0

" Customize the status bar
set showmode
set showcmd
set laststatus=2    " always shows status bar

" Set history and undo levels
set history=1000         " remember more commands and search history
set undolevels=1000      " use many muchos levels of undo

" Ignore some file extensions for tab auto-completion
set wildignore=*.swp,*.bak,*.pyc,*.class

" File editing and backups
set backupdir=~/.vim/tmp/backup// " backups
set directory=~/.vim/tmp/swap//   " swap files
set backup                        " enable backups

" Encoding / end of file (EOF) settings
set encoding=utf-8
set binary noeol 	" do NOT put a carriage return at the end of the last line! if you are programming for the web the default will cause http headers to be sent. that's bad.

" General display settings
set vb							" turn on the "visual bell" - which is much quieter than the "audio blink"
set lines=50 columns=84 		" initial window size
set relativenumber				" turn on relative line numbers
set ruler						" turn on ruler
set wrap						" turn on soft wrap and word wrap
set linebreak
set guifont=Menlo\ Regular:h14	" set default font

" Display settings in insert mode
set cursorline
syntax on           " syntax highlighting
set showmatch       " automatically show matching brackets

" Editing in insert mode
set ai              " auto-indenting for programming

" Settings for tabs
set tabstop=6
set shiftwidth=6
"set expandtab

" Filetype stuff
filetype on
filetype plugin on
filetype indent on

" Make autocompletion work like bash's autocompletion
set wildmenu
set wildmode=list:longest

" Turn on spell checking
set spell

" Settings for search and replace
set incsearch 		" turn on incremental search 
set ignorecase
set smartcase 		" turn on smart case search
set gdefault 		" make regex searching default to global

" Turn on context for page forward and back
set scrolloff=2

" Share clipboard between windows
set clipboard=unnamed


" Key remappings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Change <leader> key
let mapleader = ","

" Change movement keys for Colemak
noremap h k
noremap j h
noremap k j

" Easier page up / page down
noremap H <C-b>
noremap K <C-f>

" One less key (<shift>) to press each time
nnoremap ; :


" Shortcuts for vim
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" <Leader>vrc brings up .vimrc in a split window for editing
map <Leader>vrc :sp $MYVIMRC<CR><C-W>_

" Split windows
nnoremap <leader>ws <C-w>s<C-w>l

" Moving around split windows
nnoremap <C-j> <C-w>h
nnoremap <C-k> <C-w>j
nnoremap <C-h> <C-w>k
nnoremap <C-l> <C-w>l

nnoremap <leader>wj <C-w>h
nnoremap <leader>wk <C-w>j
nnoremap <leader>wh <C-w>k
nnoremap <leader>wl <C-w>l


" Shortcuts for LaTeX
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"  <Leader>lie inserts a LaTeX environment or package by simulating <F5>
map <Leader>lie <F5>
"  <Leader>lic inserts a LaTeX command by simulating <F7>
map <Leader>lic <F7>
" <Leader>lj jumps to next placeholder by simulating <C-j>
map <Leader>lj <C-j>



" LaTeX
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" REQUIRED. This makes vim invoke Latex-Suite when you open a tex file.
filetype plugin on

" IMPORTANT: win32 users will need to have 'shellslash' set so that latex
" can be called correctly.
set shellslash

" IMPORTANT: grep will sometimes skip displaying the file name if you
" search in a singe file. This will confuse Latex-Suite. Set your grep
" program to always generate a file-name.
set grepprg=grep\ -nH\ $*

" OPTIONAL: This enables automatic indentation as you type.
filetype indent on

" OPTIONAL: Starting with Vim 7, the filetype of empty .tex files defaults to
" 'plaintex' instead of 'tex', which results in vim-latex not being loaded.
" The following changes the default filetype back to 'tex':
let g:tex_flavor='latex'

" Turn on forward search with Skim
let g:Tex_DefaultTargetFormat = 'pdf'
 
let g:Tex_CompileRule_dvi = 'latex --interaction=nonstopmode $*'
let g:Tex_CompileRule_ps = 'dvips -Pwww -o $*.ps $*.dvi'
let g:Tex_CompileRule_pspdf = 'ps2pdf $*.ps'
let g:Tex_CompileRule_dvipdf = 'dvipdfm $*.dvi'
let g:Tex_CompileRule_pdf = 'pdflatex -synctex=1 --interaction=nonstopmode $*'
 
let g:Tex_ViewRule_dvi = 'texniscope'
let g:Tex_ViewRule_ps = 'Preview'
let g:Tex_ViewRule_pdf = 'Skim'
 
let g:Tex_FormatDependency_ps  = 'dvi,ps'
let g:Tex_FormatDependency_pspdf = 'dvi,ps,pspdf'
let g:Tex_FormatDependency_dvipdf = 'dvi,dvipdf'
 
" let g:Tex_IgnoredWarnings ='
"       \"Underfull\n".
"       \"Overfull\n".
"       \"specifier changed to\n".
"       \"You have requested\n".
"       \"Missing number, treated as zero.\n".
"       \"There were undefined references\n".
"       \"Citation %.%# undefined\n".
"       \"\oval, \circle, or \line size unavailable\n"' 


" NERDTree Shortcuts
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Shortcut mapping
map <leader>nt :NERDTreeToggle<CR>


" Pathogen
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

filetype off
call pathogen#runtime_append_all_bundles()
filetype plugin indent on


" Rainbow Parentheses
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Shortcut mapping
nmap <leader>rp :RainbowParenthesesToggle<CR>


" FuzzyFileFinder_Textmate
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Shortcut mapping
map <leader>nf :FuzzyFinderTextMate<CR>


" Stuff that has to be last
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Set color scheme
colorscheme wombat
