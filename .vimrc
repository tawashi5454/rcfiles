
"********** vim本体の設定 **********

"### プラグインのインストール設定 ###
set nocompatible
filetype off

set rtp+=~/.vim/vundle.git/
call vundle#rc()

Bundle 'vim-ruby/vim-ruby'
Bundle 'fholgado/minibufexpl.vim'
Bundle 'YankRing.vim'
Bundle 'matchit.zip'
Bundle 'rails.vim'
Bundle 'surround.vim'
Bundle 'AutoComplPop'
Bundle 'shanlalit/vim-autoclose.git'
Bundle 'thinca/vim-ref'
Bundle 'thinca/vim-quickrun'
Bundle 'mattn/zencoding-vim.git'  

filetype plugin indent on


"### 色の設定 ###
set background=light
colorscheme solarized

"### 基本系 ###
set nocompatible "viとの互換性を重視しない
syntax on "シンタックスハイライトを有効にする
set filetype=on "開いているファイルタイプに応じて挙動を変える
set backspace=indent,eol,start "賢いバックスペース
set hidden " バッファが編集中でもその他のファイルを開けるように
set autoread " 外部のエディタで編集中のファイルが変更されたら自動で読み直す
set number "行番号を表示させる
set nobackup "バックアップファイルを作成しない
set t_Co=16 "256色を使う


"### 検索系 ###
set ignorecase "検索文字列が小文字の場合は大文字小文字を区別なく検索する
set smartcase "検索文字列に大文字が含まれている場合は区別して検索する
set wrapscan "検索時に最後まで行ったら最初に戻る
set noincsearch "検索文字列入力時に順次対象文字列にヒットさせない
set hlsearch "検索結果文字列のハイライトを有効にする

"### タブとインデント関係 ###
set noexpandtab "insertモードでTABを押したとき空白に展開しない
set nolist "タブや改行を表示しない（表示する場合は行末が$、TABが^Iで表示される）
set tabstop=4 "タブ幅を４文字にする
set shiftwidth=4 "cindentやautoindent時に挿入されるタブの幅（tabstop と揃えておくと良い）
set noshowmatch "括弧入力時の対応する括弧は表示しない
set showcmd "入力中のコマンドをステータスに表示する
"set paste "ペースト時はautoindentを無効に
set smartindent "自動インデント設定

"### ファイルタイプごとの関係 ###

filetype plugin on " ファイルタイプごとのプラグインを利用する
filetype indent on "そのファイルタイプにあわせたインデントを利用する

if has("autocmd")


  " これらのftではインデントを無効に
  "autocmd FileType html :set indentexpr=
  "autocmd FileType xhtml :set indentexpr=

endif

autocmd FileType c,cpp,perl set cindent
autocmd FileType python set tabstop=4 shiftwidth=4 expandtab
autocmd FileType yaml set expandtab ts=2 sw=2 enc=utf-8 fenc=utf-8
autocmd FileType ruby set expandtab ts=2 sw=2 enc=utf-8 fenc=utf-8

"### ステータスライン関係 ###
set laststatus=2 "ステータスラインを常に表示
set ruler "カーソル位置を常に表示
set wildmenu " コマンドライン補完するときに強化されたものを使う(参照 :help wildmenu)
set showcmd "入力中のコマンドをステータスに表示する

function! GetB()
  let c = matchstr(getline('.'), '.', col('.') - 1)
  let c = iconv(c, &enc, &fenc)
  return String2Hex(c)
endfunction
" :help eval-examples
" The function Nr2Hex() returns the Hex string of a number.
func! Nr2Hex(nr)
  let n = a:nr
  let r = ""
  while n
    let r = '0123456789ABCDEF'[n % 16] . r
    let n = n / 16
  endwhile
  return r
endfunc
" The function String2Hex() converts each character in a string to a two
" character Hex string.
func! String2Hex(str)
  let out = ''
  let ix = 0
  while ix < strlen(a:str)
    let out = out . Nr2Hex(char2nr(a:str[ix]))
    let ix = ix + 1
  endwhile
  return out
endfunc

"ステータスラインに文字コードと改行文字を表示する
if winwidth(0) >= 120
  set statusline=%<[%n]%m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}%y\ %F%=[%{GetB()}]\ %l,%c%V%8P
else
  set statusline=%<[%n]%m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}%y\ %f%=[%{GetB()}]\ %l,%c%V%8P
endif


"### 文字コード関連 ###
" from ずんWiki http://www.kawaz.jp/pukiwiki/?vim#content_1_7
if &encoding !=# 'utf-8'
  set encoding=japan
endif
set fileencoding=japan
if has('iconv')
  let s:enc_euc = 'euc-jp'
  let s:enc_jis = 'iso-2022-jp'
  " iconvがJISX0213に対応しているかをチェック
  if iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'euc-jisx0213'
    let s:enc_jis = 'iso-2022-jp-3'
  endif
  " fileencodingsを構築
  if &encoding ==# 'utf-8'
    let s:fileencodings_default = &fileencodings
    let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
    let &fileencodings = &fileencodings .','. s:fileencodings_default
    unlet s:fileencodings_default
  else
    let &fileencodings = &fileencodings .','. s:enc_jis
    set fileencodings+=utf-8,ucs-2le,ucs-2
    if &encoding =~# '^euc-\%(jp\|jisx0213\)$'
      set fileencodings+=cp932
      set fileencodings-=euc-jp
      set fileencodings-=euc-jisx0213
      let &encoding = s:enc_euc
    else
      let &fileencodings = &fileencodings .','. s:enc_euc
    endif
  endif
  " 定数を処分
  unlet s:enc_euc
  unlet s:enc_jis
endif

autocmd FileType svn :set fileencoding=utf-8 " svnの時は文字コードをutf-8に設定
set fileformats=unix,dos,mac " 改行コードの自動認識

" encodingの変換
nmap ,U :set fileencoding=utf-8<CR>
nmap ,E :set fileencoding=euc-jp<CR>
nmap ,S :set fileencoding=cp932<CR>

set fileencoding=utf8
set encoding=utf8

"### オムニ補完関係 ###
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType c set omnifunc=ccomplete#Complete

hi Pmenu ctermbg=darkgray
hi PmenuSel ctermbg=darkred
hi PmenuSbar ctermbg=0

"### マルチバッファの際のカレントディレクトリを動的に変更する ###
"autocmd BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" | lcd %:p:h | endif

"### 表示行単位で行移動する ###
nmap j gj
nmap k gk
vmap j gj
vmap k gk

"### ,e でそのコマンドを実行 ###
nmap ,e :execute '!' &ft ' %'<CR>

"### RUBYの設定 ###
autocmd FileType ruby set omnifunc=rubycomplete#Complete
autocmd FileType eruby set omnifunc=htmlcomplete#CompleteTags
autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
autocmd FileType ruby,eruby let g:rubycomplete_rails = 1
autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1

"補完メニューの色設定
hi Pmenu ctermbg=darkgray
hi PmenuSel ctermbg=darkred
hi PmenuSbar ctermbg=0

" Ctrl+Spaceでオムニ補完を呼び出す
"imap <C-Space> <C-X><C-O>
imap <Nul> <C-X><C-O>

"********** プラグイン関係の設定 **********

"### MiniBufExplorer ###
let g:miniBufExplMapWindowNavVim=1 "hjklで移動
let g:miniBufExplSplitBelow=0  " Put new window above
let g:miniBufExplMapWindowNavArrows=1
let g:miniBufExplMapCTabSwitchBufs=1
let g:miniBufExplModSelTarget=1 
let g:miniBufExplSplitToEdge=1

nmap <Space> :MBEbn<CR>
nnoremap ,n       :MBEbn<CR>
nnoremap ,p       :MBEbp<CR>
nnoremap ,k       :bd<CR>
nnoremap ,w       :ls<CR>
nnoremap ,1   :e #1<CR>
nnoremap ,2   :e #2<CR>
nnoremap ,3   :e #3<CR>
nnoremap ,4   :e #4<CR>
nnoremap ,5   :e #5<CR>
nnoremap ,6   :e #6<CR>
nnoremap ,7   :e #7<CR>
nnoremap ,8   :e #8<CR>
nnoremap ,9   :e #9<CR>

"### YankRing ###
nmap ,y :YRShow<CR>

