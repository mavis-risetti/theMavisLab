(in-package :the-mavis-lab)

(defun render (editor)
  "render the screen selectively"
  (let ((buffer (current-buffer)))
    (mapcar (lambda (n)
              (if (> n (length (line-objects buffer)))
                  (push (create-div editor
                                    :content (nth-line n)
                                    :class "line")
                        (line-objects buffer))
                  (nth-object n :html (nth-line n))))
            (changed-lines buffer))
    (empty-changed-lines)))

;; (defun render (editor buffer)
  ;; "render the screen"
  ;; (mapcar (lambda (n)
            ;; (let ((line (nth-line n buffer)))
              ;; (aif (< n (length (line-objects buffer)))
                ;; (setf (inner-html it) line)
                ;; (setf (line-objects buffer)
                      
                      ;; (gethash n (line-objects buffer))
                      ;; (create-div editor
                                  ;; :content line
                                  ;; :class (format nil "line line-~A" n))))))
          ;; (changed-lines buffer))
  ;; (empty-changed-lines buffer))
