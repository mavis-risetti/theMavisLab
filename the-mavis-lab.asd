;;;; the-mavis-lab.asd
(in-package :cl-user)

(asdf:defsystem :the-mavis-lab
  :version "0.1"
  :description "A Home for my Experiments"
  :author "mavis-risetti"
  :depends-on (:clog)
  :serial t
  :components ((:file "package")
               (:file "utils")
               (:file "keys")
               (:file "render")
               (:file "cursor")
               (:file "buffer")
               (:file "editor")))
