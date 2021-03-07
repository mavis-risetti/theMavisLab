(in-package :the-mavis-lab)

(defparameter *body* nil)
(defparameter *editor* nil)
(defparameter *buf* nil)

(defun init-editor (body)
  "initialize the editor"
  (setf *buf* (make-buffer))
  (setf *body* body)
  (setf *editor* (clog:create-div body :class "editor"))
  (set-on-key-down (html-document body) #'key-handler)
  ;; To keep the thread running
  (run body))


(defun start-lab ()
  "start the editor"
  ;; Make 'init-editor' entry point for the application
  (initialize #'init-editor)
  (open-browser))

(defun concat (&rest strings)
  (apply #'concatenate `(string ,@strings)))

(defun render ()
  "render the screen"
  (let ((line-num (length (lines *buf*))))
    (setf (inner-html *editor*) "")
    (mapcar (lambda (line)
              (decf line-num)
              (create-div *editor*
                          :class (concat "line-" (write-to-string line-num))
                          :content line))
            (reverse (lines *buf*)))))

(defun key-handler (obj event-data)
  (declare (ignore obj))
  (let ((key (getf event-data :key)))
    (if (string= key "Enter")
        (push "" (lines *buf*))
        (setf (car (lines *buf*))
              (concat (car (lines *buf*)) key)
              )))
  (render))

(start-lab)
