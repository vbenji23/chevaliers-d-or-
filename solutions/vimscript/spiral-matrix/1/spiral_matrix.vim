function! SpiralMatrix(n) abort
  if a:n <= 0
    return []
  endif

  " 1. Initialiser une matrice n x n remplie de 0
  let l:matrix = []
  for l:i in range(a:n)
    call add(l:matrix, repeat([0], a:n))
  endfor

  " 2. Définir les limites de la grille
  let l:top = 0
  let l:bottom = a:n - 1
  let l:left = 0
  let l:right = a:n - 1

  let l:num = 1
  let l:max_num = a:n * a:n

  " 3. Parcourir en spirale dans le sens des aiguilles d'une montre
  while l:num <= l:max_num
    " De gauche à droite (ligne du haut)
    for l:col in range(l:left, l:right)
      let l:matrix[l:top][l:col] = l:num
      let l:num += 1
    endfor
    let l:top += 1

    " De haut en bas (colonne de droite)
    for l:row in range(l:top, l:bottom)
      let l:matrix[l:row][l:right] = l:num
      let l:num += 1
    endfor
    let l:right -= 1

    " De droite à gauche (ligne du bas)
    if l:top <= l:bottom
      for l:col in range(l:right, l:left, -1)
        let l:matrix[l:bottom][l:col] = l:num
        let l:num += 1
      endfor
      let l:bottom -= 1
    endif

    " De bas en haut (colonne de gauche)
    if l:left <= l:right
      for l:row in range(l:bottom, l:top, -1)
        let l:matrix[l:row][l:left] = l:num
        let l:num += 1
      endfor
      let l:left += 1
    endif
  endwhile

  return l:matrix
endfunction