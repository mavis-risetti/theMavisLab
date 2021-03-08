(in-package :the-mavis-lab)

(defparameter *lower-case-characters*
  '("a" "b" "c" "d" "e" "f" "g" "h" "i"
    "j" "k" "l" "m" "n" "o" "p" "q" "r"
    "s" "t" "u" "v" "w" "x" "y" "z"))

(defparameter *upper-case-characters*
  '("A" "B" "C" "D" "E" "F" "G" "H" "I"
    "J" "K" "L" "M" "N" "O" "P" "Q" "R"
    "S" "T" "U" "V" "W" "X" "Y" "Z"))

(defparameter *numbers* '("1" "2" "3" "4" "5" "6" "7" "8" "9" "0"))

(defparameter *other-characters*
  '("-" "+" "!" "@" "#" "$" "%" "^"
    "*" "(" ")" "`" "~" "[" "]" "|" ";" ":"
    "," "." "?" "/"))

(defparameter *escaped-characters*
  '(" " "<" ">" "&" "\"" "'"))

(defun char-p (c)
  "is an alphabet or a digit"
  (when (or
         (member c *numbers* :test #'string=)
         (member c *lower-case-characters* :test #'string=)
         (member c *upper-case-characters* :test #'string=)
         (member c *other-characters* :test #'string=)
         (member c *escaped-characters* :test #'string=))
    t))

(defun escaped-char-p (c)
  "should the character be escaped?"
  (member c *escaped-characters* :test #'string=))

(defun escape-char (c)
  (scase c
   (" " "&nbsp;")
   ("<" "&lt;")
   (">" "&gt;")
   ("&" "&amp;")
   ("\"" "&quot;")
   ("'" "&#39;")))

;; (defun insert-char (c buffer)
  ;; (let ((char (cond
                ;; ((escaped-char-p c) (escape-char c))
                ;; (t c))))
    ;; (add-char-to-last-line char buffer)))

(defun key-handler (event-data buffer)
  (let* ((key (getf event-data :key))
         (len (length key)))
    (cond ((and (= len 1) (char-p key)) (add-char-to-last-line key buffer))
          ((string= key "Enter") (add-new-line "" buffer))
          (t (print "Not a Character")))))
