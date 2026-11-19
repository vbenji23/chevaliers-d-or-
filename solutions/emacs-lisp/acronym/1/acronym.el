;;; acronym.el --- Acronym (exercism)  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(require 'subr-x)

(defun acronym (phrase)
  "Convert PHRASE into its acronym."
  (let* ((sanitized (replace-regexp-in-string "-" " " phrase))
         (words (split-string sanitized "[ \t\n\r]+" t)))
    (mapconcat
     (lambda (word)
       (when (string-match "[A-Za-z]" word)
         (upcase (match-string 0 word))))
     words
     "")))

(provide 'acronym)
;;; acronym.el ends here