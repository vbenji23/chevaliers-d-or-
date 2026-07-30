;;; accumulate.el --- Accumulate (exercism)  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(defun accumulate (lst op)
  "Applique la fonction OP à chaque élément de LST et renvoie une nouvelle liste."
  (if (null lst)
      '()
    (cons (funcall op (car lst))
          (accumulate (cdr lst) op))))

(provide 'accumulate)
;;; accumulate.el ends here