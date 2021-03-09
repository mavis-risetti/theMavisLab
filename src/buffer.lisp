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
    (add-changed-line 1 :buffer buf)
    buf))

(defun current-buffer ()
  *buf*)

(defun add-changed-line (line-num &key (buffer nil))
  (pushnew line-num (changed-lines (or buffer (current-buffer)))))

(defun empty-changed-lines ()
  (setf (changed-lines (current-buffer)) nil))

(defun nth-line (n &key (line nil))
  "get or set nth line"
  (if line                          ;contents is a string
      (progn
        (setf (elt (contents (current-buffer)) (1- n)) line)
        (add-changed-line n))
      (elt (contents (current-buffer)) (1- n))))

(defun nth-object (n &key (html nil))
  "get object or set inner-html"
  (if html
      (setf (inner-html (elt (line-objects (current-buffer)) (1- n)))
            html)
      (elt (line-objects (current-buffer)) (1- n))))

(defun remove-line (line)
  (let ((buffer (current-buffer)))
    ;; remove from the screen first
    (remove-from-dom (nth-object line))
    ;; remove from the line-objects now
    (delete-item (1- line) (line-objects buffer))
    ;; remove from buffer contents
    (setf (contents buffer) (delete-item (1- line) (contents buffer)))))

(defun add-line (line &key (line-contents ""))
  (let ((buffer (current-buffer)))
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
                                          (line-objects buffer))))
  ;; adjust cursor
  (cursor->down)
  (cursor->bol)
  ;; track change
  (add-changed-line line))

(defun get-buffer-length ()
  (length (contents (current-buffer))))

(defun add-new-line (contents)
  "add a new line to buffer"
  (let* ((buffer (current-buffer))
         (len (length (contents buffer))))
    (setf (contents buffer)
          `(,@(contents buffer) ,contents))
    (cursor->last-char)
    (add-changed-line (1+ len))))
