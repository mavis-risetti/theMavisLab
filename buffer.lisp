(in-package :the-mavis-lab)

(defclass buffer ()
  ((lines
    :initform (list "")
    :accessor lines
    :allocation :instance)))

(defun make-buf (&key contents)
  (make-instance 'buffer))

(defun add-char (c buffer &key (line-num 1))
  "add c to the line at line-num"
  (setf (car (lines buffer))
        (concat (car (lines buffer))
                c)))
