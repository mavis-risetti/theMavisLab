(in-package :the-mavis-lab)

(defclass buffer ()
  ((lines
    :initarg :lines
    :initform '("")
    :accessor lines)))

(defun make-buffer (&key lines)
  (if lines
      (make-instance 'buffer :lines lines)
      (make-instance 'buffer)))
