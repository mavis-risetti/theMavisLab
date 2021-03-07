(in-package :the-mavis-lab)

(defclass buffer ()
  ((lines
    :initform (list "")
    :accessor lines)
   (changed-lines
    :initform nil
    :accessor changed-lines)
   (line-objects
    :initform (make-hash-table)
    :accessor line-objects)))

(defun make-buf (&key contents)
  (make-instance 'buffer))

(defun add-changed-line (line-num buffer)
  (pushnew line-num (changed-lines buffer)))

(defun nth-line (n buffer &key (contents nil))
  "get or set nth line"
  (if contents                          ;contents is a string
      (setf (elt (lines buffer) (1- n)) contents)
      (elt (lines buffer) (1- n))))

(defun add-char-to-last-line (c buffer)
  "add c to the line at line-num"
  (let ((len (length (lines buffer))))
    (nth-line len buffer :contents (concat (last1 (lines buffer)) c))
    (add-changed-line len buffer)))

(defun add-new-line (contents buffer)
  "add a new line to buffer"
  (let ((len (length (lines buffer))))
    (setf (lines buffer)
          `(,@(lines buffer) ,contents))
    (add-changed-line len buffer)))
