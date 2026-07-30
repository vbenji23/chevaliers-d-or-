function! Transpose(lines) abort
  if empty(a:lines)
    return ''
  endif

  " 1. Découper la chaîne d'entrée en une liste de lignes
  let l:rows = split(a:lines, "\n", 1)

  " 2. Trouver la longueur maximale parmi toutes les lignes
  let l:max_len = 0
  for l:row in l:rows
    if len(l:row) > l:max_len
      let l:max_len = len(l:row)
    endif
  endfor

  " 3. Transposer caractère par caractère
  let l:transposed_rows = []
  for l:col_idx in range(l:max_len)
    let l:col_chars = []
    
    for l:row_idx in range(len(l:rows))
      let l:row = l:rows[l:row_idx]
      
      if l:col_idx < len(l:row)
        " Le caractère existe dans cette ligne
        call add(l:col_chars, l:row[l:col_idx])
      else
        " Vérifier s'il y a une ligne plus bas qui possède au moins l:col_idx + 1 caractères
        let l:has_later_char = 0
        for l:future_row in l:rows[l:row_idx + 1 :]
          if l:col_idx < len(l:future_row)
            let l:has_later_char = 1
            break
          endif
        endfor

        " On n'ajoute un espace de remplissage (padding) que si nécessaire
        if l:has_later_char
          call add(l:col_chars, ' ')
        endif
      endif
    endfor

    call add(l:transposed_rows, join(l:col_chars, ''))
  endfor

  " 4. Assembler les nouvelles lignes avec des sauts de ligne (\n)
  return join(l:transposed_rows, "\n")
endfunction