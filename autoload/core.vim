if !exists('*core#save_and_exec')
  function! core#save_and_exec() abort
    if &filetype == 'vim' || &filetype == "lua"
      :silent! write
      :source %
    endif
    return
  endfunction
endif


function! core#close_hidden_buffers()
  let open_buffers = []

  for i in range(tabpagenr('$'))
    call extend(open_buffers, tabpagebuflist(i + 1))
  endfor

  for num in range(1, bufnr("$") + 1)
    let bt = getbufvar(num, "&buftype")
    if buflisted(num) && index(open_buffers, num) == -1 && bt != "terminal"
      exec "bwipeout ".num
    endif
  endfor
endfunction
