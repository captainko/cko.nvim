function! CustomOrgIndent() abort
  let line = getline(v:lnum)
  if match(line, '^\s\+\*\+\s*$') > -1
    return 0
  endif
  return OrgmodeIndentExpr()
endfunction

setlocal indentkeys+=<*>
setlocal indentexpr=CustomOrgIndent()
