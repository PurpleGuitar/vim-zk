" Generate a note id
function! s:zk_new_id()
    return strftime('%Y-%m-%d-%H%M%S')
endfunction

" Get id of this note
function! s:zk_get_id()
    return expand("%:r")
endfunction

" Create a new note with a timestamp for an id
function! s:zk_new()
    let id = s:zk_new_id()
    execute 'edit' id . '.md'
endfunction
command! ZkNew call s:zk_new()

" Search notes in this directory
function! s:zk_search(search_string)
    if a:search_string == ""
        let search_string = input("Search notes: ")
    else
        let search_string = a:search_string
    endif
    try
        execute 'vimgrep' '"'.search_string.'"' '*.md'
    catch
        echom "No matches."
    endtry
endfunction
command! ZkSearch call s:zk_search("")

" Copy a link to this file into unnamed register
function! s:zk_copylink()
    let id = s:zk_get_id()
    let @@ = "[" . id . "](" . id . ".html)"
endfunction
command! ZkCopyLink call s:zk_copylink()

" Search for backlinks to this note
function! s:zk_backlinks()
    let filename = s:zk_get_id() . ".html"
    try
        execute 'vimgrep' filename '*.md'
    catch
        echom "No matches."
    endtry
endfunction
command! ZkBacklinks call s:zk_backlinks()

" Get list of pages
function! s:zk_getfiles(ArgLead, CmdLine, CursorPos)
    let filenames = globpath('.','*.md', 0, 1)
    let namelist = ""
    for filename in filenames
        let pagename = fnamemodify(filename, ":t:r")
        let namelist = namelist . pagename . "\n"
    endfor
    return namelist
endfunction

" Go to page
function! s:zk_gotopage(pagename)
    execute "edit " . a:pagename . ".md"
endfunction
command! -nargs=1 -complete=custom,s:zk_getfiles ZkGotoPage call s:zk_gotopage(<q-args>)

" Insert link to page
function! s:zk_linktopage(pagename)
    let linktext = "[" . a:pagename . "](" . a:pagename . ".html)"
    execute ':normal! a' . linktext
endfunction
command! -nargs=1 -complete=custom,s:zk_getfiles ZkLinkToPage call s:zk_linktopage(<q-args>)

" Insert link and go to page
function! s:zk_linkandgo(pagename)
    call s:zk_linktopage(a:pagename)
    call s:zk_gotopage(a:pagename)
endfunction
command! -nargs=1 -complete=custom,s:zk_getfiles ZkLinkAndGo call s:zk_linkandgo(<q-args>)

" Extract selection into page
function! s:zk_extractto(pagename) range
    execute a:firstline . "," . a:lastline . "d"
    call s:zk_linktopage(a:pagename)
    call s:zk_gotopage(a:pagename)
    normal Gp
endfunction
command! -nargs=1 -complete=custom,s:zk_getfiles -range ZkExtractTo <line1>,<line2>call s:zk_extractto(<q-args>)

" Go to today's note
function! s:zk_gototoday()
    let id = strftime('%Y-%m-%d')
    execute 'edit' id . '.md'
endfunction
command! ZkGoToToday call s:zk_gototoday()

" Go home
function! s:zk_gotoindex()
    let id = 'index'
    execute 'edit' id . '.md'
endfunction
command! ZkGoToIndex call s:zk_gotoindex()

" Create maps if requested
if exists("g:vim_zk_create_mappings") && g:vim_zk_create_mappings == 1
    nnoremap <Leader>zn :ZkNew<CR>i
    nnoremap <Leader>zs :ZkSearch<CR>
    nnoremap <Leader>zc :ZkCopyLink<CR>
    nnoremap <Leader>zb :ZkBacklinks<CR>
    nnoremap <Leader>zg :ZkGotoPage<Space>
    nnoremap <Leader>zl :ZkLinkToPage<Space>
    inoremap <Leader>zl <Esc>:ZkLinkToPage<Space>
    inoremap [[ <Esc>:ZkLinkToPage<Space>
    nnoremap <Leader>zL :ZkLinkAndGo<Space>
    inoremap <Leader>zL <Esc>:ZkLinkAndGo<Space>
    vnoremap <Leader>zx :ZkExtractTo<Space>
    nnoremap <Leader>zt :ZkGoToToday<CR>
    nnoremap <Leader>zi :ZkGoToIndex<CR>
endif
