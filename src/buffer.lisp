(in-package :the-mavis-lab)

(defclass buffer ()
  ((contents
    :initform (list "")
    :accessor contents)
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

(defun nth-line (n buffer &key (line nil))
  "get or set nth line"
  (if line                          ;contents is a string
      (progn
        (setf (elt (contents buffer) (1- n)) line)
        (add-changed-line n buffer))
      (elt (contents buffer) (1- n))))

;; (defun insert-char (c line col buffer)
  ;; (let* (
  ;; )
    ;; (setf line (clip 1 line (get-buffer-length buffer))
          ;; col (clip 1 col (1+ len)))
    ;; (format t "~%s is ~A~%" (insert c (1- col) s))
    ;; (nth-line line buffer :line (insert c col s))
    ;; (add-changed-line line buffer)))

(defun insert-at-point (s buffer)
  (let* ((cursor (cursor buffer))
         (line (line cursor))
         (col (col cursor)))
    (nth-line line buffer :line (insert s (1- col) (nth-line line buffer)))
    (cursor->right buffer)
    (add-changed-line line buffer)))

(defun remove-line (line buffer)
  ;; remove from the screen first
  (remove-from-dom (gethash line (line-objects buffer)))
  ;; remove from the line-objects now
  (remhash line (line-objects buffer))
  ;; remove from buffer contents
  (setf (contents buffer) (delete-item (1- line) (contents buffer))))

(defun get-buffer-length (buffer)
  (length (contents buffer)))

(defun add-char-to-last-line (c buffer)
  (let* ((last-line (get-buffer-length buffer))
         (last-col (length (nth-line last-line buffer))))
    (insert-char c
                 (clip 1 last-line last-line)
                 (clip 1  last-col last-col)
                 buffer)))

(defun add-new-line (contents buffer)
  "add a new line to buffer"
  (let ((len (length (contents buffer))))
    (setf (contents buffer)
          `(,@(contents buffer) ,contents))
    (cursor->last-char buffer)
    (add-changed-line (1+ len) buffer)))
