(in-package :the-mavis-lab)

(defun delete-char-before-point (buffer)
  (if (= (col (cursor buffer)) 1)
      (delete-line-at-point buffer)
      (let* ((cursor (cursor buffer))
             (line (line cursor))
             (col (col cursor))
             (l (delete-char (- col 2) (nth-line line buffer))))
        (nth-line line buffer :line l)
        (cursor->left buffer))))

(defun delete-line-at-point (buffer)
  (let* ((cursor (cursor buffer))
         (line (line cursor)))
    (unless (= line 1)
      ;; adjust the cursor first
      (cursor->up buffer)
      (cursor->eol buffer)
      ;; add the contents of the line about to be deleted to the line above
      (insert-at-point (nth-line line buffer) buffer)
      ;; remove line from screen, objects and buffer contents
      (remove-line line buffer)
      ;; track the change
      (add-changed-line (1- line) buffer))))
