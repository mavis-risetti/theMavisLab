;;;; the-mavis-lab.asd
(in-package :cl-user)

(asdf:defsystem :the-mavis-lab
  :version "0.1"
  :description "A Home for my Experiments"
  :author "mavis-risetti"
  :depends-on (:clog :str)
  :serial t
  :components ((:file "src/package")
               (:file "src/utils")
               (:file "src/cursor")
               (:file "src/commands")
               (:file "src/keymap")
               (:file "src/keys")
               (:file "src/render")
               (:file "src/buffer")
               (:file "src/editor")))
