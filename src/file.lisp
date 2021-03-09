(in-package :the-mavis-lab)


(defun find-file ()
  (print "find-file")
  (let* ((file-path "~/.emacs")
         (file-contents (uiop:read-file-lines file-path)))
    (setf (contents (current-buffer)) file-contents)
    (dotimes (i (length file-contents))
      (add-changed-line (1+ i)))))
