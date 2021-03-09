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
    (setf (style cursor-el "height") "15px")
    (setf (style cursor-el "background") "black")
    (setf (style cursor-el "position") "absolute")
    (setf (style cursor-el "z-index") "10")
    (setf (el cursor) cursor-el)
    cursor))

(defun move-cursor (line col)
  "move cursor to col"
  (let* ((buffer (current-buffer))
         (cursor (cursor buffer))
         (p (clip-pos line col)))
    (setf line (first p)
          col (second p))
    (setf (style (el cursor) "top") (format nil "~Apx" (* 15 line))
          (style (el cursor) "left") (format nil "~Apx" (* *char-width* col)))
    (set-cursor line col)))

(defun set-cursor (line col)
  "change cursor attributes"
  (let ((cursor (cursor (current-buffer))))
    (setf (line cursor) line
          (col cursor) col)))

(defun render-cursor ()
  (let ((cursor (cursor (current-buffer))))
    (move-cursor (line cursor) (col cursor))))

(defun cursor->up ()
  "move cursor up"
  (let* ((cursor (cursor (current-buffer)))
         (line (line cursor)))
    (setf (line cursor) (1- line))
    (render-cursor)))

(defun cursor->down ()
  "move cursor down"
  (let* ((cursor (cursor (current-buffer)))
         (line (line cursor)))
    (setf (line cursor) (1+ line))
    (render-cursor)))

(defun cursor->right ()
  "move cursor right"
  (let* ((cursor (cursor (current-buffer)))
         (col (col cursor)))
    (setf (col cursor) (1+ col))
    (render-cursor)))

(defun cursor->left ()
  "move cursor right"
  (let* ((cursor (cursor (current-buffer)))
         (col (col cursor)))
    (setf (col cursor) (1- col))
    (render-cursor)))

(defun cursor->bol ()
  "cursor to beginning of line"
  (let* ((cursor (cursor (current-buffer))))
    (set-cursor (line cursor) 1)
    (render-cursor)))

(defun cursor->eol ()
  "cursor to end of line"
  (let* ((cursor (cursor (current-buffer)))
         (len (length (nth-line (line cursor)))))
    (set-cursor (line cursor) (1+ len))
    (render-cursor)))

(defun cursor->last-char ()
  (let* ((last-line (length (contents (current-buffer))))
         (last-col (1+ (length (nth-line last-line)))))
    (move-cursor last-line last-col)))

(defun clip (min-value n max-value)
  (max (min n max-value) min-value))

(defun clip-pos (line col)
  (let* ((buffer (current-buffer))
         (max-line (length (contents buffer)))
         (max-row (1+ (length (nth-line (clip 1 line max-line))))))
    (setf line (clip 1 line max-line))
    (setf col (clip 1 col max-row))
    (list line col)))

