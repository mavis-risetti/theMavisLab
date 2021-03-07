(in-package :the-mavis-lab)

(defparameter *body* nil)

(defun init-editor (body)
  "initialize the editor"
  (setf *body* body)
  (let* ((editor (create-div body :class "editor"))
        (pre (create-child editor "<pre></pre>" ))
        (buf (make-buf)))
    (set-on-key-down (html-document body)
                     #'(lambda (obj event-data)
                         (declare (ignore obj))
                         (key-handler event-data buf)
                         (render pre buf)))
    ;; To keep the thread running
    (run body)))

(defun start-lab ()
  "start the editor"
  ;; Make 'init-editor' entry point for the application
  (initialize #'init-editor)
  (open-browser))

(start-lab)
