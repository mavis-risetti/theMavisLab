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
    :initform nil
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

(defun nth-object (n buffer &key (html nil))
  "get object or set inner-html"
  (if html
      (setf (inner-html (elt (line-objects buffer) (1- n)))
            html)
      (elt (line-objects buffer) (1- n))))

(defun insert-at-point (s buffer)
  (let* ((cursor (cursor buffer))
         (line (line cursor))
         (col (col cursor)))
    (nth-line line buffer :line (insert s (1- col) (nth-line line buffer)))
    (cursor->right buffer)
    (add-changed-line line buffer)))

(defun remove-line (line buffer)
  ;; remove from the screen first
  (remove-from-dom (nth-object line buffer))
  ;; remove from the line-objects now
  (delete-item (1- line) (line-objects buffer))
  ;; remove from buffer contents
  (setf (contents buffer) (delete-item (1- line) (contents buffer))))

(defun add-line (line buffer &key (line-contents ""))
  "adds an empty line at 'line', pushing all the lines"
  ;; add to buffer contents
  (setf (contents buffer) (add-item (1- line) line-contents (contents buffer)))
  ;; add to line objects, screen
  (setf (line-objects buffer) (add-item (1- line)
                                        (if (= line 1)
                                            (place-before
                                             (elt (line-objects buffer) 0)
                                             (create-div *ed*
                                                         :content line-contents
                                                         :class "line"))
                                            (place-after
                                             (elt (line-objects buffer) (- line 2))
                                             (create-div *ed*
                                                         :content line-contents
                                                         :class "line")))
                                        (line-objects buffer)))
  ;; adjust cursor
  (cursor->down buffer)
  (cursor->bol buffer)
  ;; track change
  (add-changed-line line buffer))

(defun get-buffer-length (buffer)
  (length (contents buffer)))

(defun add-new-line (contents buffer)
  "add a new line to buffer"
  (let ((len (length (contents buffer))))
    (setf (contents buffer)
          `(,@(contents buffer) ,contents))
    (cursor->last-char buffer)
    (add-changed-line (1+ len) buffer)))
