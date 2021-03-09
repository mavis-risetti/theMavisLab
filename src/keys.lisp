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

(defun read-key-sequence (event-data)
  "return a string representation of key seqeunce"
  (let* ((alt (if (getf event-data :alt-key) "A-" ""))
         (ctrl (if (getf event-data :ctrl-key) "C-" ""))
         (shift (if (getf event-data :shift-key) "S-" ""))
         (meta (if (getf event-data :meta-key) "M-" ""))
         (key (getf event-data :key))
         (s ""))
    (if (or (equal key "Control")
            (equal key "Meta")
            (equal key "Shift")
            (equal key "Alt"))
        (format nil "~A" (concat s key))
        (format nil "~A~A~A~A~A"
                alt ctrl shift meta (no-case key)))))

(defun key-handler (event-data)
  (let* ((key (getf event-data :key))
         (len (length key))
         (seq (read-key-sequence event-data)))
    (aif (get-command seq)
      (funcall it)
      (if (and (= len 1) (char-p seq))
          (insert-at-point key)
          (format t "Unrecognized Key Sequence~%")))))
