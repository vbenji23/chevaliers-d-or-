" Alphabets de référence pour la substitution
let s:plain  = 'abcdefghijklmnopqrstuvwxyz'
let s:cipher = 'zyxwvutsrqponmlkjihgfedcba'

function! AtbashEncode(plaintext) abort
  " 1. Passer en minuscules et nettoyer (garder uniquement lettres et chiffres)
  let l:clean = substitute(tolower(a:plaintext), '[^a-z0-9]', '', 'g')
  
  " 2. Appliquer la substitution d'Atbash (tr)
  let l:transformed = tr(l:clean, s:plain, s:cipher)
  
  " 3. Découper par blocs de 5 caractères
  return join(split(l:transformed, '.\{1,5}\zs'), ' ')
endfunction

function! AtbashDecode(cipher) abort
  " 1. Supprimer tous les espaces du texte chiffré
  let l:clean = substitute(a:cipher, '\s\+', '', 'g')
  
  " 2. Réversibilité : Atbash est symétrique, tr() fait le décodage directement
  return tr(l:clean, s:plain, s:cipher)
endfunction