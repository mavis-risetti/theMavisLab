(in-package :the-mavis-lab)

(defun render (editor)
  "render the screen selectively"
  (let* ((buffer (current-buffer))
         (changes (sort (copy-seq (changed-lines buffer)) #'<)))
    (print changes)
    (mapcar (lambda (n)
              (if (> n (length (line-objects buffer)))
                  (setf (line-objects buffer)
                        `(,@(line-objects buffer)
                          ,(create-div editor
                                       :content (nth-line n)
                                       :class "line")))
                  (nth-object n :html (nth-line n))))
            changes)
    (empty-changed-lines)))
