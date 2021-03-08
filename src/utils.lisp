;; utilities
(in-package :the-mavis-lab)

(defun last1 (list)
  (car (last list)))

;; (defun concat (&rest strings)
  ;; (apply #'concatenate `(string ,@strings)))

(defun delete-char (i s)
  (let* ((len (length s)))
    (cond ((zerop i) (subseq s 1))
          ((= i (1- len)) (subseq s 0 (1- len)))
          (t (concat (subseq s 0 i) (subseq s (1+ i)))))))

(defun delete-item (i list)
  (let* ((index 0)
         (final-list nil))
    (mapcar (lambda (item)
              (unless (= index i)
                (push item final-list))
              (incf index))
            list)
    (reverse final-list)))

(defmacro aif (aif-cond &body aif-body)
  `(let ((it ,aif-cond))
     (if it ,@aif-body)))

(defmacro while (while-condition &body while-body)
  `(do ()
       ((not ,while-condition) t)
     ,@while-body))

(defmacro scase (s &body case-body)
  "case with :test #'string="
  `(cond ,@(mapcar #'(lambda (case-clause)
                       `((string= ,s ,(car case-clause)) ,(cadr case-clause)))
                   case-body)))
