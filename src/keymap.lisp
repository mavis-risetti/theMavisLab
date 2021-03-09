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
(set-key "backspace" #'delete-backward-char)
(set-key "C-a" #'cursor->bol)
(set-key "C-e" #'cursor->eol)
(set-key "C-d" #'delete-forward-char)
(set-key "C-k" #'kill-line)
(set-key "C-n" #'cursor->down)
(set-key "C-p" #'cursor->up)
(set-key "C-f" #'cursor->right)
(set-key "C-b" #'cursor->left)
;;; temporary
(set-key "C-;" #'find-file)
