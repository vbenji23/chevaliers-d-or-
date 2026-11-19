function! Abbreviate(phrase) abort
  " 1. Remplacer les tirets et tirets bas par des espaces pour séparer correctement les mots
  let l:cleaned = substitute(a:phrase, '[-_]', ' ', 'g')

  " 2. Supprimer la ponctuation restante (tout ce qui n'est ni lettre ni espace)
  let l:cleaned = substitute(l:cleaned, '[^\t A-Za-z]', '', 'g')

  " 3. Extraire la première lettre de chaque mot et la convertir en majuscule
  let l:acronym = ''
  for l:word in split(l:cleaned)
    let l:acronym .= toupper(l:word[0])
  endfor

  return l:acronym
endfunction