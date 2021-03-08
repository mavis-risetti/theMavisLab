(in-package :the-mavis-lab)

(defclass cursor ()
  ((el
    :initform nil
    :initarg :el
    :accessor el)
   (line
    :initform 1
    :initarg :line
    :accessor line)
   (col
    :initform 1
    :initarg :col
    :accessor col)))

(defun make-cursor (parent-el)
  "make a cursor in parent-el"
  (let ((cursor-el (create-div parent-el :class "cursor"))
        (cursor (make-instance 'cursor)))
    (setf (style cursor-el "width") "1px")
    (setf (style cursor-el "height") "1em")
    (setf (style cursor-el "background") "black")
    (setf (style cursor-el "position") "absolute")
    (setf (style cursor-el "z-index") "10")
    (setf (el cursor) cursor-el)
    cursor))

(defun move-cursor (line col cursor)
  "move cursor to col"
  (let ()
    (setf (style (el cursor) "top") (format nil "~Apx" (* (* *line-height* 10)
                                                          (+ line 0))))
    (setf (style (el cursor) "left") (format nil "~Apx" (* *char-width* (+ col 2))))
    (setf (line cursor) line)
    (setf (col cursor) col)))

(defun clip-pos (col)
  (cond ((< col 1) 1)
        (t col)))
