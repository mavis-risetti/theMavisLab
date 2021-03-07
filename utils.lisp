;; utilities
(in-package :the-mavis-lab)

(defun last1 (list)
  (car (last list)))

(defun concat (&rest strings)
  (apply #'concatenate `(string ,@strings)))

(defmacro while (while-condition &body while-body)
  `(do ()
       ((not ,while-condition) t)
     ,@while-body))

(defmacro scase (s &body case-body)
  "case with :test #'string="
  `(cond ,@(mapcar #'(lambda (case-clause)
                       `((string= ,s ,(car case-clause)) ,(cadr case-clause)))
                   case-body)))
