" Constructeur de nœud pour la liste chaînée
function! s:CreateNode(val, next_node) abort
  let l:node = {
        \ 'val': a:val,
        \ 'next_node': a:next_node
        \ }

  function! l:node.Value() dict abort
    return self.val
  endfunction

  function! l:node.Next() dict abort
    return self.next_node
  endfunction

  return l:node
endfunction

" Constructeur principal de la liste chaînée simple
function! SimpleLinkedList(values) abort
  let l:list = {
        \ 'head_node': v:null,
        \ 'count': 0
        \ }

  " Obtenir la longueur de la liste
  function! l:list.Length() dict abort
    return self.count
  endfunction

  " Obtenir le premier nœud de la liste
  function! l:list.Head() dict abort
    if self.head_node is v:null
      throw 'The list is empty'
    endif
    return self.head_node
  endfunction

  " Empiler une valeur au sommet (devient la nouvelle tête)
  function! l:list.Push(val) dict abort
    let self.head_node = s:CreateNode(a:val, self.head_node)
    let self.count += 1
  endfunction

  " Dépiler et renvoyer la valeur de la tête
  function! l:list.Pop() dict abort
    if self.head_node is v:null
      throw 'The list is empty'
    endif
    let l:val = self.head_node.Value()
    let self.head_node = self.head_node.Next()
    let self.count -= 1
    return l:val
  endfunction

  " Convertir la liste en tableau Vim script (de la tête vers la fin)
  function! l:list.AsList() dict abort
    let l:result = []
    let l:curr = self.head_node
    while l:curr isnot v:null
      call add(l:result, l:curr.Value())
      let l:curr = l:curr.Next()
    endwhile
    return l:result
  endfunction

  " Inverser l'ordre des éléments
  function! l:list.Reversed() dict abort
    let l:reversed_list = SimpleLinkedList([])
    let l:curr = self.head_node
    while l:curr isnot v:null
      call l:reversed_list.Push(l:curr.Value())
      let l:curr = l:curr.Next()
    endwhile
    return l:reversed_list
  endfunction

  " Initialiser avec les valeurs fournies (dans l'ordre du tableau)
  for l:val in a:values
    call l:list.Push(l:val)
  endfor

  return l:list
endfunction