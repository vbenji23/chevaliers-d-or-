" Fonction principale pour calculer le PGCD (Plus Grand Commun Diviseur)
function! s:Gcd(a, b) abort
  let l:x = a:a
  let l:y = a:b
  while l:y != 0
    let l:t = l:y
    let l:y = l:x % l:y
    let l:x = l:t
  endwhile
  return l:x
endfunction

function! TwoBucket(input) abort
  let l:c1 = a:input.bucketOne
  let l:c2 = a:input.bucketTwo
  let l:goal = a:input.goal
  let l:start = a:input.startBucket

  " 1. Validation de la possibilité de résoudre le problème
  if l:goal > max([l:c1, l:c2])
    throw 'impossible'
  endif

  if l:goal % s:Gcd(l:c1, l:c2) != 0
    throw 'impossible'
  endif

  " Définition de l'état initial selon le seau de départ
  if l:start ==# 'one'
    let l:init_b1 = l:c1
    let l:init_b2 = 0
    let l:forbidden = '0,' . l:c2
  else
    let l:init_b1 = 0
    let l:init_b2 = l:c2
    let l:forbidden = l:c1 . ',0'
  endif

  " 2. Parcours en largeur (BFS)
  let l:queue = [[l:init_b1, l:init_b2, 1]]
  let l:visited = {}
  let l:visited[l:init_b1 . ',' . l:init_b2] = 1
  let l:visited[l:forbidden] = 1

  let l:result = {}

  while !empty(l:queue)
    let l:curr = remove(l:queue, 0)
    let l:b1 = l:curr[0]
    let l:b2 = l:curr[1]
    let l:moves = l:curr[2]

    " Vérification de l'objectif
    if l:b1 == l:goal || l:b2 == l:goal
      if l:b1 == l:goal
        let l:result = {
              \ 'moves': l:moves,
              \ 'goalBucket': 'one',
              \ 'otherBucket': l:b2
              \ }
      else
        let l:result = {
              \ 'moves': l:moves,
              \ 'goalBucket': 'two',
              \ 'otherBucket': l:b1
              \ }
      endif
      break
    endif

    " Génération de tous les mouvements possibles
    " 1) Remplir B1  2) Remplir B2
    " 3) Vider B1    4) Vider B2
    " 5) Verser B1 -> B2
    " 6) Verser B2 -> B1
    let l:p1 = min([l:b1, l:c2 - l:b2])
    let l:p2 = min([l:b2, l:c1 - l:b1])

    let l:next_states = [
          \ [l:c1, l:b2],
          \ [l:b1, l:c2],
          \ [0, l:b2],
          \ [l:b1, 0],
          \ [l:b1 - l:p1, l:b2 + l:p1],
          \ [l:b1 + l:p2, l:b2 - l:p2]
          \ ]

    for l:state in l:next_states
      let l:nb1 = l:state[0]
      let l:nb2 = l:state[1]
      let l:key = l:nb1 . ',' . l:nb2

      if !has_key(l:visited, l:key)
        let l:visited[l:key] = 1
        call add(l:queue, [l:nb1, l:nb2, l:moves + 1])
      endif
    endfor
  endwhile

  if empty(l:result)
    throw 'impossible'
  endif

  " 3. Objet de retour contenant la méthode `.Measure()`
  let l:game = {'res': l:result}
  function! l:game.Measure() dict abort
    return self.res
  endfunction

  return l:game
endfunction