(in-package :the-mavis-lab)

(defparameter *body* nil)
(defparameter *char-width* nil)
(defparameter *line-height* nil)

(defun get-line-height (el)
  "line' on screen height"
  (let* ((content "MadhuVamsi")
         (len (length content))
         (span (create-span el :content content))
         (height))
    (setf (style span "height") "auto")
    (setf (style span "width") "auto")
    (setf (style span "position") "absolute")
    (setf (style span "white-space") "no-wrap")
    (setf height (/ (client-height span)
                   (coerce len 'single-float)))
    (remove-from-dom span)
    height))

(defun get-char-width (el)
  "get the char's width on screen"
  (let* ((content "MadhuVamsi")
         (len (length content))
         (span (create-span el :content content))
         (width))
    (setf (style span "height") "auto")
    (setf (style span "width") "auto")
    (setf (style span "position") "absolute")
    (setf (style span "white-space") "no-wrap")
    (setf width (/ (client-width span)
                   (coerce len 'single-float)))
    (remove-from-dom span)
    width))

(defun init-editor (body)
  "initialize the editor"
  (setf *body* body)
  (let* ((editor-div (create-div body :class "editor"))
         (editor-pre (create-child editor-div "<pre></pre>" ))
         (buf (make-buf editor-pre)))
    (setf *char-width* (get-char-width editor-pre))
    (setf *line-height* (get-line-height editor-pre))
    (set-on-key-down (html-document body)
                     #'(lambda (obj event-data)
                         (declare (ignore obj))
                         (key-handler event-data buf)
                         (render editor-pre buf)))
    ;; To keep the thread running
    (run body)))

(defun start-lab ()
  "start the editor"
  ;; Make 'init-editor' entry point for the application
  (initialize #'init-editor)
  (open-browser))

(start-lab)
