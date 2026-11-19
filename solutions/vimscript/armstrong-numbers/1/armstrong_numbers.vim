function! IsArmstrongNumber(number) abort
  " Convertir le nombre en chaîne pour obtenir ses chiffres et sa longueur
  let l:digits = split(string(a:number), '\zs')
  let l:length = len(l:digits)

  " Calculer la somme des chiffres élevés à la puissance 'length'
  let l:sum = 0
  for l:digit in l:digits
    let l:sum += float2nr(pow(str2nr(l:digit), l:length))
  endfor

  " Renvoyer 1 (vrai) si la somme est égale au nombre d'origine, sinon 0 (faux)
  return l:sum == a:number
endfunction
