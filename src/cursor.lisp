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

(defun move-cursor (line col buffer)
  "move cursor to col"
  (let ((cursor (cursor buffer))
        (p (clip-pos line col buffer)))
    (setf line (first p)
          col (second p))
    (setf (style (el cursor) "top") (format nil "~Apx" (* (* *line-height* 10)
                                                          (+ line 0)))
          (style (el cursor) "left") (format nil "~Apx" (* *char-width* col)))
    (set-cursor line col buffer)))

(defun set-cursor (line col buffer)
  "change cursor attributes"
  (let ((cursor (cursor buffer)))
    (setf (line cursor) line
          (col cursor) col)))

(defun render-cursor (buffer)
  (let ((cursor (cursor buffer)))
    (move-cursor (line cursor) (col cursor) buffer)))

(defun cursor->up (buffer)
  "move cursor up"
  (let* ((cursor (cursor buffer))
         (line (line cursor)))
    (setf (line cursor) (1- line))
    (render-cursor buffer)))

(defun cursor->down (buffer)
  "move cursor down"
  (let* ((cursor (cursor buffer))
         (line (line cursor)))
    (setf (line cursor) (1+ line))
    (render-cursor buffer)))

(defun cursor->right (buffer)
  "move cursor right"
  (let* ((cursor (cursor buffer))
         (col (col cursor)))
    (setf (col cursor) (1+ col))
    (render-cursor buffer)))

(defun cursor->left (buffer)
  "move cursor right"
  (let* ((cursor (cursor buffer))
         (col (col cursor)))
    (setf (col cursor) (1- col))
    (render-cursor buffer)))

(defun cursor->bol (buffer)
  "cursor to beginning of line"
  (let* ((cursor (cursor buffer)))
    (set-cursor (line cursor) 1 buffer)
    (render-cursor buffer)))

(defun cursor->eol (buffer)
  "cursor to end of line"
  (let* ((cursor (cursor buffer))
         (len (length (nth-line (line cursor) buffer))))
    (set-cursor (line cursor) (1+ len) buffer)
    (render-cursor buffer)))

(defun cursor->last-char (buffer)
  (let* ((last-line (length (contents buffer)))
         (last-col (1+ (length (nth-line last-line buffer)))))
    (move-cursor last-line last-col buffer)))

(defun clip (min-value n max-value)
  (max (min n max-value) min-value))

(defun clip-pos (line col buffer)
  (let* ((max-line (length (contents buffer)))
         (max-row (1+ (length (nth-line (clip 1 line max-line) buffer)))))
    (setf line (clip 1 line max-line))
    (setf col (clip 1 col max-row))
    (list line col)))

