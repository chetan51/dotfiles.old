" histwin.vim - Vim global plugin for browsing the undo tree
" -------------------------------------------------------------
" Last Change: Tue, 31 Aug 2010 13:58:01 +0200
" Maintainer:  Christian Brabandt <cb@256bit.org>
" Version:     0.13
" Copyright:   (c) 2009, 2010 by Christian Brabandt
"              The VIM LICENSE applies to histwin.vim 
"              (see |copyright|) except use "histwin.vim" 
"              instead of "Vim".
"              No warranty, express or implied.
"    *** ***   Use At-Your-Own-Risk!   *** ***
"    TODO:     - make tags permanent
"			   - rewrite script and make use of undotree() functionality
"			     that is available since Vim 7.3
"              - Bugfix: Sometimes the histwin window contains invalid data,
"                        not sure how to reproduce it. Closing and reoping is
"                        the workaround.
"

" Init: {{{1
let s:cpo= &cpo
set cpo&vim

" Show help banner?
" per default enabled, you can change it,
" if you set g:undobrowse_help to 0 e.g.
" put in your .vimrc
" :let g:undo_tree_help=0
let s:undo_help=((exists("s:undo_help") ? s:undo_help : 1) )
let s:undo_tree_dtl   = (exists('g:undo_tree_dtl')   ? g:undo_tree_dtl   :   (exists("s:undo_tree_dtl") ? s:undo_tree_dtl : 1))



" Functions:
" 
fun! histwin#WarningMsg(msg)"{{{1
	echohl WarningMsg
	let msg = "histwin: " . a:msg
	if exists(":unsilent") == 2
		unsilent echomsg msg
	else
		echomsg msg
	endif
	echohl Normal
	let v:errmsg = msg
endfun "}}}
fun! s:Init()"{{{1
	if exists("g:undo_tree_help")
	   let s:undo_help=g:undo_tree_help
	endif
	if !exists("s:undo_winname")
		let s:undo_winname='Undo_Tree'
	endif
	" speed, with which the replay will be played
	" (duration between each change in milliseconds)
	" set :let g:undo_tree_speed=250 in your .vimrc to override
	let s:undo_tree_speed = (exists('g:undo_tree_speed') ? g:undo_tree_speed : 100)
	" Set prefered width
	let s:undo_tree_wdth  = (exists('g:undo_tree_wdth')  ? g:undo_tree_wdth  :  30)
	" Show detail with Change nr?
	let s:undo_tree_dtl   = (exists('g:undo_tree_dtl')   ? g:undo_tree_dtl   :  s:undo_tree_dtl)
	" Set old versions nomodifiable
	let s:undo_tree_nomod = (exists('g:undo_tree_nomod') ? g:undo_tree_nomod :   1)

	if !exists("s:undo_tree_wdth_orig")
		let s:undo_tree_wdth_orig = s:undo_tree_wdth
	endif
	if !exists("s:undo_tree_wdth_max")
		let s:undo_tree_wdth_max  = 50
	endif

	if bufname('') != s:undo_winname
		let s:orig_buffer = bufnr('')
	endif
	
	" Make sure we are in the right buffer
	" and this window still exists
	if bufwinnr(s:orig_buffer) == -1
		wincmd p
		let s:orig_buffer=bufnr('')
	endif

	" Move to the buffer, we are monitoring
	exe bufwinnr(s:orig_buffer) . 'wincmd w'
	if !exists("b:undo_customtags")
		let b:undo_customtags={}
	endif
	if !exists("b:undo_dict")
	    let b:undo_dict={}
	endif
endfun "}}}
fun! s:ReturnHistList(winnr)"{{{1
	redir => a
	sil :undol
	redir end
	" First item contains the header
	let templist=split(a, '\n')[1:]
	let customtags=copy(b:undo_customtags)
	let histdict={}
	" include the starting point as the first change.
	" unfortunately, there does not seem to exist an 
	" easy way to obtain the state of the first change,
	" so we will be inserting a dummy entry and need to
	" check later, if this is called.
	"if exists("b:undo_dict") && !empty(get(b:undo_dict,0,''))
		"call add(histdict, b:undo_dict[0])
"	else
"    if !has_key(b:undo_tagdict, '0')
		"let b:undo_customtags['0'] = {'number': 0, 'change': 0, 'time': '00:00:00', 'tag': 'Start Editing'}
	let histdict[0] = {'number': 0, 'change': 0, 'time': '00:00:00', 'tag': 'Start Editing' ,'save':0}
"	endif

	let i=1
	for item in templist
		let change	=  matchstr(item, '^\s\+\zs\d\+') + 0
		let nr		=  matchstr(item, '^\s\+\d\+\s\+\zs\d\+') + 0
		let time	=  matchstr(item, '^\%(\s\+\d\+\)\{2}\s\+\zs.\{-}\ze\s*\d*$')
		let save	=  matchstr(item, '\s\+\zs\d\+$') + 0
		if time !~ '\d\d:\d\d:\d\d'
		   let time=matchstr(time, '^\d\+')
		   let time=strftime('%H:%M:%S', localtime()-time)
		endif
		if has_key(customtags, change)
			let tag=customtags[change].tag
			call remove(customtags,change)
		else
			let tag=''
		endif
	   let histdict[change]={'change': change, 'number': nr, 'time': time, 'tag': tag, 'save': save}
	   let i+=1
	endfor
	return extend(histdict,customtags,"force")
endfun "}}}
fun! s:SortValues(a,b)"{{{1
	return (a:a.change+0)==(a:b.change+0) ? 0 : (a:a.change+0) > (a:b.change+0) ? 1 : -1
endfun"}}}
fun! s:MaxTagsLen()"{{{1
	let tags = getbufvar(s:orig_buffer, 'undo_customtags')
	let d=[]
	" return a list of all tags
	let d=values(map(copy(tags), 'v:val["tag"]'))
	let d+= ["Start Editing"]
	"call map(d, 'strlen(substitute(v:val, ".", "x", "g"))')
	call map(d, 'strlen(v:val)')
	return max(d)
endfu "}}}
fun! s:HistWin()"{{{1
	let undo_buf=bufwinnr('^'.s:undo_winname.'$')
	" Adjust size so that each tag will fit on the screen
	" 16 is just the default length, that should fit within 30 chars
	"let maxlen=s:MaxTagsLen() % (s:undo_tree_wdth_max)
	let maxlen=s:MaxTagsLen()
"	if !s:undo_tree_dtl
"		let maxlen+=20     " detailed pane
"	else
"		let maxlen+=13     " short pane
"	endif
    let rd = (!s:undo_tree_dtl ? 20 : 13)

	if maxlen > 16
		let s:undo_tree_wdth = (s:undo_tree_wdth + maxlen - rd) % s:undo_tree_wdth_max
		let s:undo_tree_wdth = (s:undo_tree_wdth < s:undo_tree_wdth_orig ? s:undo_tree_wdth_orig : s:undo_tree_wdth)
	endif
	" for the detail view, we need more space
	if (!s:undo_tree_dtl) 
		let s:undo_tree_wdth = s:undo_tree_wdth_orig + 10
	else
		let s:undo_tree_wdth = s:undo_tree_wdth_orig
	endif
	"if (maxlen + (!s:undo_tree_dtl*7)) > 13 + (!s:undo_tree_dtl*7)
	"	let s:undo_tree_wdth+=(s:undo_tree_wdth + maxlen) % s:undo_tree_wdth_max
	"endif
	if undo_buf != -1
		exe undo_buf . 'wincmd w'
		if winwidth(0) != s:undo_tree_wdth
			exe "vert res " . s:undo_tree_wdth
		endif
	else
	execute s:undo_tree_wdth . "vsp " . s:undo_winname
	setl noswapfile buftype=nowrite bufhidden=delete foldcolumn=0 nobuflisted winfixwidth
	let undo_buf=bufwinnr("")
	endif
	exe bufwinnr(s:orig_buffer) . ' wincmd w'
	return undo_buf
endfun "}}}
fun! s:PrintUndoTree(winnr)"{{{1
	let bufname     = (empty(bufname(s:orig_buffer)) ? '[No Name]' : fnamemodify(bufname(s:orig_buffer),':t'))
	let changenr    = changenr()
	let histdict    = b:undo_tagdict
	exe a:winnr . 'wincmd w'
	let save_cursor=getpos('.')
	setl modifiable
	" silent because :%d outputs this message:
	" --No lines in buffer--
	silent %d _
	call setline(1,'Undo-Tree: '.bufname)
	put =repeat('=', strlen(getline(1)))
	put =''
	call s:PrintHelp(s:undo_help)
	if s:undo_tree_dtl
		call append('$', printf("%-*s %-9s %s", strlen(len(histdict)), "Nr", "  Time", "Tag"))
	else
		call append('$', printf("%-*s %-9s %-6s %-4s %s", strlen(len(histdict)), "Nr", "  Time", "Change", "Save", "Tag"))
	endif

	let i=1
	"for line in histdict+values(tagdict)
	let list=sort(values(histdict), 's:SortValues')
	for line in list
		let tag=line.tag
		" this is only an educated guess.
		" This should be calculated
		let width=winwidth(0) -  (!s:undo_tree_dtl ? 22 : 14)
		if strlen(tag) > width
			let tag=substitute(tag, '.\{'.width.'}', '&\r', 'g')
		endif
		let tag = (empty(tag) ? tag : '/'.tag.'/')
		if !s:undo_tree_dtl
			call append('$', 
			\ printf("%0*d) %8s %6d %4d %s", 
			\ strlen(len(histdict)), i, line['time'], line['change'], line['save'], 
			\ tag))
		else
			call append('$', 
			\ printf("%0*d) %8s %1s %s", 
			\ strlen(len(histdict)), i, line['time'], (line['save'] ? '*' : ' '),
			\ tag))
		endif
		let i+=1
	endfor
	%s/\r/\=submatch(0).repeat(' ', match(getline('.'), '\/')+1)/eg
	call s:MapKeys()
	call s:HilightLines(s:GetLineNr(changenr,list)+1)
	setl nomodifiable
	call setpos('.', save_cursor)
endfun "}}}
fun! s:HilightLines(changenr)"{{{1
	syn match UBTitle      '^\%1lUndo-Tree: \zs.*$'
	syn match UBInfo       '^".*$' contains=UBKEY
	syn match UBKey        '^"\s\zs\%(\(<[^>]*>\)\|\u\)\ze\s'
	syn match UBList       '^\d\+\ze'
	syn match UBTime       '\d\d:\d\d:\d\d' "nextgroup=UBDelimStart
	syn region UBTag matchgroup=UBDelim start='/' end='/$' keepend
	if a:changenr 
		exe 'syn match UBActive "^0*'.a:changenr.')[^/]*"'
	endif

	hi def link UBTitle			 Title
	hi def link UBInfo	 		 Comment
	hi def link UBList	 		 Identifier
	hi def link UBTag	 		 Special
	hi def link UBTime	 		 Underlined
	hi def link UBDelim			 Ignore
	hi def link UBActive		 PmenuSel
	hi def link UBKey            SpecialKey
endfun "}}}
fun! s:PrintHelp(...)"{{{1
	let mess=['" actv. keys in this window']
	call add(mess, '" I toggles help screen')
	if a:1
		call add(mess, "\" <Enter> goto undo branch")
		call add(mess, "\" <C-L>\t  Update view")
		call add(mess, "\" T\t  Tag sel. branch")
		call add(mess, "\" P\t  Toggle view")
		call add(mess, "\" D\t  Diff sel. branch")
		call add(mess, "\" R\t  Replay sel. branch")
		call add(mess, "\" C\t  Clear all tags")
		call add(mess, "\" Q\t  Quit window")
		call add(mess, '"')
		call add(mess, "\" Undo-Tree, v" . printf("%.02f",g:loaded_undo_browse))
	endif
	call add(mess, '')
	call append('$', mess)
endfun "}}}
fun! s:DiffUndoBranch(change)"{{{1
	let prevchangenr=<sid>UndoBranch()
	if empty(prevchangenr)
		return ''
	endif
	let cur_ft = &ft
	let buffer=getline(1,'$')
	try
		exe ':u ' . prevchangenr
		setl modifiable
	catch /Vim(undo):Undo number \d\+ not found/
		call s:WarningMsg("Undo Change not found!")
	    "echohl WarningMsg | unsilent echo "Undo Change not found." |echohl Normal
		return ''
	endtry
	exe ':botright vsp '.tempname()
	call setline(1, bufname(s:orig_buffer) . ' undo-branch: ' . a:change)
	call append('$',buffer)
    exe "setl ft=".cur_ft
	silent w!
	diffthis
	exe bufwinnr(s:orig_buffer) . 'wincmd w'
	diffthis
endfun "}}}
fun! s:ReturnTime()"{{{1
	let a=matchstr(getline('.'),'^\d\+)\s\+\zs\d\d:\d\d:\d\d\ze\s')
	if a == -1
		call search('^\d\+)', 'b')
		let a=matchstr(getline('.'),'^\d\+)\s\+\zs\d\d:\d\d:\d\d\ze\s')
	endif
	return a
endfun"}}}
fun! s:ReturnItem(time, histdict)"{{{1
	for [key, item] in items(a:histdict)
		if item['time'] == a:time
			return key
		endif
	endfor
	return ''
endfun"}}}
fun! s:GetLineNr(changenr,list)"{{{1
	let i=0
	for item in a:list
	    if item['change'] >= a:changenr
		   return i
		endif
		let i+=1
	endfor
	return -1
endfun!"}}}
fun! s:ReplayUndoBranch()"{{{1
	let time	   =  s:ReturnTime()
	exe bufwinnr(s:orig_buffer) . ' wincmd w'
	let change_old = changenr()
	let key        =  s:ReturnItem(time, b:undo_tagdict)
	if empty(key) || !time
	   echo "Nothing to do"
	   return
	endif
	try
		exe ':u '     . b:undo_tagdict[key]['change']
		exe 'earlier 99999999'
		redraw
		while changenr() < b:undo_tagdict[key]['change']
			red
			redraw
			exe ':sleep ' . s:undo_tree_speed . 'm'
		endw
	"catch /Undo number \d\+ not found/
	catch /Vim(undo):Undo number 0 not found/
		exe ':u ' . change_old
	    call s:WarningMsg("Replay not possible for initial state")
	    "echohl WarningMsg | echo "Replay not possible for initial state" |echohl Normal
	catch /Vim(undo):Undo number \d\+ not found/
		exe ':u ' . change_old
	    call s:WarningMsg("Replay not possible\nDid you reload the file?")
	    "echohl WarningMsg | echo "Replay not possible\nDid you reload the file?" |echohl Normal
	endtry
endfun "}}}
fun! s:ReturnBranch()"{{{1
	let a=matchstr(getline('.'), '^\d\+\ze')+0
	if a == -1
		call search('^\d\+)', 'b')
		let a=matchstr(getline('.'), '^\d\+\ze')+0
	endif
	return a
endfun "}}}
fun! s:ToggleHelpScreen()"{{{1
	let s:undo_help=!s:undo_help
	exe bufwinnr(s:orig_buffer) . ' wincmd w'
	call s:PrintUndoTree(s:HistWin())
endfun "}}}
fun! s:ToggleDetail()"{{{1
	let s:undo_tree_dtl=!s:undo_tree_dtl
	call s:PrintUndoTree(s:HistWin())
endfun "}}}
fun! s:UndoBranchTag(change, time)"{{{1
""	exe bufwinnr(s:orig_buffer) . 'wincmd w'
"	let changenr=changenr()
"    exe b:undo_win . 'wincmd w'

	let tags       =  getbufvar(s:orig_buffer, 'undo_tagdict')
	let cdict	   =  getbufvar(s:orig_buffer, 'undo_customtags')
	let key        =  s:ReturnItem(a:time, tags)
	if empty(key)
		return
	endif
	call inputsave()
	let tag=input("Tagname " . a:change . ": ", tags[key]['tag'])
	call inputrestore()

	let cdict[key]	 		 = {'tag': tag, 'number': 0, 'time': strftime('%H:%M:%S'), 'change': key}
	"let tags[changenr]		 = {'tag': cdict[changenr][tag], 'change': changenr, 'number': tags[key]['number'], 'time': tags[key]['time']}
	let tags[key]['tag']		 = tag
	call setbufvar(s:orig_buffer, 'undo_tagdict', tags)
	call setbufvar(s:orig_buffer, 'undo_customtags', cdict)
	call s:PrintUndoTree(s:HistWin())
endfun "}}}
fun! s:UndoBranch()"{{{1
	let dict			 =	 getbufvar(s:orig_buffer, 'undo_tagdict')
	let key=s:ReturnItem(s:ReturnTime(),dict)
	if empty(key)
		echo "Nothing to do"
	endif
	" Last line?
	if line('.') == line('$')
		let tmod = 0
	else
		let tmod = 1
	endif
	exe bufwinnr(s:orig_buffer) . 'wincmd w'
	" Save cursor pos
	let cpos = getpos('.')
	let cmd=''
	let cur_changenr=changenr()
	"let list=sort(values(b:undo_tagdict), 's:SortValues')
	"let len = len(b:undo_tagdict)
	" if len==1, then there is no
	" undo branch available, which means
	" we can't undo anyway
	try
		if key==0
		   " Jump back to initial state
			"let cmd=':earlier 9999999'
			:u1 
			if !&modifiable
				setl modifiable
			endif
			:norm 1u
		else
			exe ':u '.dict[key]['change']
		endif
		if s:undo_tree_nomod && tmod
			setl nomodifiable
		else
			setl modifiable
		endif
	catch /Vim(undo):Undo number \d\+ not found/
		exe ':u ' . cur_changenr
	    call s:WarningMsg("Undo Change not found.")
	    "echohl WarningMsg | echomsg "Undo Change not found." |echohl Normal
		return 
	endtry
	" this might have changed, so we return to the old cursor
	" position. This could still be wrong, so
	" So this is our best effort approach.
	call setpos('.', cpos)
	return cur_changenr
endfun "}}}
fun! s:MapKeys()"{{{1
	nnoremap <script> <silent> <buffer> I     :<C-U>silent :call <sid>ToggleHelpScreen()<CR>
	nnoremap <script> <silent> <buffer> <C-L> :<C-U>silent :call histwin#UndoBrowse()<CR>
	nnoremap <script> <silent> <buffer> <CR>  :<C-U>silent :call <sid>UndoBranch()<CR>:call histwin#UndoBrowse()<CR>
	nnoremap <script> <silent> <buffer> D     :<C-U>silent :call <sid>DiffUndoBranch(<sid>ReturnBranch())<CR>
	nnoremap <script> <silent> <buffer>	R     :<C-U>call <sid>ReplayUndoBranch()<CR>:silent! :call histwin#UndoBrowse()<CR>
	nnoremap <script> <silent> <buffer> Q     :<C-U>q<CR>
	nmap     <script> <silent> <buffer>	P     :<C-U>silent :call <sid>ToggleDetail()<CR><C-L>
	nmap	 <script> <silent> <buffer> T     :call <sid>UndoBranchTag(<sid>ReturnBranch(),<sid>ReturnTime())<CR>:<C-U>silent :call histwin#UndoBrowse()<CR>
	nmap	 <script> <silent> <buffer> C     :call <sid>ClearTags()<CR><C-L>
endfun "}}}
fun! s:ClearTags()"{{{1
	exe bufwinnr(s:orig_buffer) . 'wincmd w'
	let b:undo_customtags={}
endfun"}}}
fun! histwin#UndoBrowse()"{{{1
	if &ul != -1
		call s:Init()
		let b:undo_win  = s:HistWin()
		let b:undo_tagdict=s:ReturnHistList(bufwinnr(s:orig_buffer))
		call s:PrintUndoTree(b:undo_win)
	else
		echoerr "Histwin: Undo has been disabled. Check your undolevel setting!"
	endif
endfun "}}}
" Modeline and Finish stuff: {{{1
let &cpo=s:cpo
unlet s:cpo
" vim: ts=4 sts=4 fdm=marker com+=l\:\" fdl=0
