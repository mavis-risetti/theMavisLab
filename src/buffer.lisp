(in-package :the-mavis-lab)

(defclass buffer ()
  ((lines
    :initform (list "")
    :accessor lines)
   (root
    :initform nil
    :initarg :root
    :accessor root)
   (cursor
    :initform nil
    :accessor cursor)
   (changed-lines
    :initform nil
    :accessor changed-lines)
   (line-objects
    :initform (make-hash-table)
    :accessor line-objects)))

(defun make-buf (root-el)
  (let ((buf (make-instance 'buffer :root root-el)))
    (setf (slot-value buf 'cursor) (make-cursor (root buf)))
    (add-changed-line 1 buf)
    buf))

(defun add-changed-line (line-num buffer)
  (pushnew line-num (changed-lines buffer)))

(defun empty-changed-lines (buffer)
  (setf (changed-lines buffer) nil))

(defun nth-line (n buffer &key (contents nil))
  "get or set nth line"
  (if contents                          ;contents is a string
      (progn
        (setf (elt (lines buffer) (1- n)) contents)
        (add-changed-line n buffer))
      (elt (lines buffer) (1- n))))

(defun add-char-to-last-line (c buffer)
  "add c to the line at line-num"
  (let ((len (length (lines buffer)))
        (last-line (last1 (lines buffer))))
    (nth-line len buffer :contents (concat last-line c))
    (cursor->last-char buffer)
    (add-changed-line len buffer)))

(defun add-new-line (contents buffer)
  "add a new line to buffer"
  (let ((len (length (lines buffer))))
    (setf (lines buffer)
          `(,@(lines buffer) ,contents))
    (cursor->last-char buffer)
    (add-changed-line (1+ len) buffer)))
