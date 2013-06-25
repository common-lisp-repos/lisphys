;;;; lisphys.asd

(asdf:defsystem #:lisphys
  :serial t
  :description "Describe lisphys here"
  :author "Guillaume <guillaume.saupin@gmail.com>"
  :license "Specify license here"
  :depends-on (#:clunit
	       #:alexandria)
  :components ((:file "infpre")
	       (:file "package")
	       (:file "memoization")
               (:file "autodiff")
               (:file "autodiff-test")
               (:file "math")
               (:file "vector3")
               (:file "vector3-test")
               (:file "vector3ad")
               (:file "quaternion")
               (:file "quaternionad")
               (:file "twist")
               (:file "displacement")
               (:file "lisphys")))

