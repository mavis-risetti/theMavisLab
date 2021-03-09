;;;; cami.asd
(in-package :cl-user)

(asdf:defsystem :cami
  :version "0.1"
  :description "A Home to my Experiments"
  :author "mavis-risetti"
  :depends-on (:clog :str)
  :serial t
  :components ((:file "src/package")
               (:file "src/utils")
               (:file "src/cursor")

               (:file "src/keys")
               (:file "src/render")
               (:file "src/buffer")
               (:file "src/commands")               
               (:file "src/file")
               (:file "src/keymap")
               (:file "src/editor")))
