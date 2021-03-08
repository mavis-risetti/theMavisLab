(in-package :the-mavis-lab)

(defun render (editor buffer)
  "render the screen"
  (mapcar (lambda (n)
            (let ((line (nth-line n buffer)))
              (aif (gethash n (line-objects buffer))
                (setf (inner-html it) line)
                (setf (gethash n (line-objects buffer))
                      (create-div editor
                                  :content line
                                  :class (format nil "line line-~A" n))))))
          (changed-lines buffer))
  (empty-changed-lines buffer))
