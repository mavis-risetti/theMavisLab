(in-package :cami)

(defun insert-at-point (s)
  (let* ((cursor (cursor (current-buffer)))
         (line (line cursor))
         (col (col cursor)))
    (nth-line line :line (insert s (1- col) (nth-line line)))
    (cursor->right)
    (add-changed-line line)))

(defun delete-forward-char ()
  "delete character after point"
  (let* ((buffer (current-buffer))
         (cursor (cursor buffer))
         (line (line cursor))
         (col (col cursor)))
    (unless (and (= line (length (contents buffer)))
                 (> col (length (nth-line line))))
      (if (> col (length (nth-line line)))
          (progn
            (nth-line line :line (concat (nth-line line)
                                         (nth-line (1+ line))))
            (remove-line (1+ line)))
          (nth-line line :line (delete-char (- col 1) (nth-line line)))))))

(defun delete-backward-char ()
  "delete character before point"
  (let ((buffer (current-buffer)))
    (if (= (col (cursor buffer)) 1)
        (delete-line-at-point)
        (let* ((cursor (cursor buffer))
               (line (line cursor))
               (col (col cursor))
               (l (delete-char (- col 2) (nth-line line))))
          (nth-line line :line l)
          (cursor->left)))))

(defun kill-line ()
  "emacs C-k"
  (let* ((buffer (current-buffer))
         (cursor (cursor buffer))
         (line (line cursor))
         (col (col cursor)))
    (nth-line line :line (subseq (nth-line line) 0 (1- col)))))

(defun delete-line-at-point ()
  (let* ((buffer (current-buffer))
         (cursor (cursor buffer))
         (line (line cursor)))
    (unless (= line 1)
      ;; adjust the cursor first
      (cursor->up)
      (cursor->eol)
      ;; add the contents of the line about to be deleted to the line above
      (insert-at-point (nth-line line))
      ;; remove line from screen, objects and buffer contents
      (remove-line line))))

(defun add-new-line-at-point ()
  (let* ((buffer (current-buffer))
         (cursor (cursor buffer))
         (line (line cursor))
         (col (col cursor))
         (contents (nth-line line))
         (before-cursor (subseq contents 0 (1- col)))
         (after-cursor (subseq contents (1- col))))
    ;; change the current line first
    (nth-line line :line before-cursor)
    ;; create a new line in buffer, objects and screen
    (add-line (1+ line) :line-contents after-cursor)))

(defun refresh-screen ()
  (let ((loc (location *body*)))
    (reload loc)))
