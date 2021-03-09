(in-package :the-mavis-lab)

(defparameter *keymap* (make-hash-table :test #'equal))

(defun set-key (key-sequence command)
  (setf (gethash key-sequence *keymap*) command))

(defun get-command (seq)
  (gethash seq *keymap*))

;;; Key Maps
(set-key "enter" #'add-new-line-at-point)
(set-key "arrow right" #'cursor->right)
(set-key "arrow left" #'cursor->left)
(set-key "arrow up" #'cursor->up)
(set-key "arrow down" #'cursor->down)
(set-key "backspace" #'delete-char-before-point)
(set-key "C-e" #'cursor->eol)
(set-key "C-a" #'cursor->bol)
