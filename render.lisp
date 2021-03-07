(in-package :the-mavis-lab)

(defun render (editor buffer)
  "render the screen"
  (format t "~%BUFFER: ~A~%" (lines buffer))
  (setf (inner-html editor)
        (format nil "~A" (car (lines buffer)))))
