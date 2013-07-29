(in-package #:lisphys)

(defclass vector3 (math)
  ((x :reader vector3-x :initarg :x :initform 0.0)
   (y :reader vector3-y :initarg :y :initform 0.0)
   (z :reader vector3-z :initarg :z :initform 0.0)))

(defmethod (setf vector3-x) (x (v vector3))
  (setf (slot-value v 'x) x))

(defmethod (setf vector3-y) (y (v vector3))
  (setf (slot-value v 'y) y))

(defmethod (setf vector3-z) (z (v vector3))
  (setf (slot-value v 'z) z))


(defmethod .+ ((va vector3) (vb vector3))
"Add two vector3."
  (with-slots (x y z (.+ add)) va
    (with-slots ((tx x) (ty y) (tz z)) vb
      (make-instance (type-of va)
		     :x (funcall .+ x tx) 
		     :y (funcall .+ y ty) 
		     :z (funcall .+ z tz) )
      )
    )
  )

(defmethod .- ((va vector3) (vb vector3))
"Substract vector3 vb from va."
  (with-slots (x y z (.- sub) ) va
    (with-slots ((tx x) (ty y) (tz z)) vb
      (make-instance (type-of va) 
		     :x (funcall .- x tx)
		     :y (funcall .- y ty) 
		     :z (funcall .- z tz) )
      )
    )
  )

(defmethod .* ((va vector3) a)
"Multiply vector3 va by scalar a."
  (with-slots (x y z (.* mult)) va
      (make-instance (type-of va) 
		     :x (funcall .* x a)
		     :y (funcall .* y a) 
		     :z (funcall .* z a ))))

(defmethod axpy (a (x vector3) (y vector3))
  (.+ (.* x a) y))

;;(setq v (make-instance 'vector3 ))
;;(funcall (vector3-add v) 1 2 3)

;;(setq vp (make-instance 'vector3p ))
;;(funcall (vector3-add vp) 1 2 3)


(defmethod dot ((va vector3) (vb vector3))
"Compute the dot product of two vector3"
  (with-slots (x y z (.+ add) (.* mult)) va
    (with-slots ((tx x) (ty y) (tz z)) vb
      (funcall .+ (funcall .* x tx) (funcall .* y ty) (funcall .* z tz))
      )
    )
  )

;;(dot v v)
;;(dot vp vp)


(defmethod cross ((va vector3) (vb vector3))
"Compute the cross product of two vector3"
  (with-slots ((u1 x) (u2 y) (u3 z) (.- sub) (.* mult)) va
    (with-slots ((v1 x) (v2 y) (v3 z)) vb
      (make-instance (type-of va)
		     :x (funcall .- (funcall .* u2 v3) (funcall .* u3 v2)) 
		     :y (funcall .- (funcall .* u3 v1) (funcall .* u1 v3)) 
		     :z (funcall .- (funcall .* u1 v2) (funcall .* u2 v1)) )
      )
    )
  )

(defmethod norm2 ((v vector3))
"Compute the squared norm of a vector3"
  (with-slots (x y z) v
    (dot v v)
      )
  )

(defmethod norm ((v vector3))
"Compute the norm of a vector3"
(with-slots ((.sqrt sqrt)) v
    (funcall .sqrt (norm2 v) )
  )
)

(defmethod normalize ((v vector3))
  "Compute the norm of a vector3"
  (with-slots (x y z (./ div)) v
    (let ((nrm (norm v)))
      (make-instance (type-of v)
		     :x (funcall ./ x nrm)
		     :y (funcall ./ y nrm)
		     :z (funcall ./ z nrm) )
      )
    )
  )

(defmethod is-null ((v vector3))
  "Return t if vectir i null. Avoid to compute the norm and its undefined derivative in 0."
  (with-slots (x y z) v
    (and (= (val x ) 0) (= (val y) 0) (= (val z) 0))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;              Helper                           ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(set-dispatch-macro-character #\# #\v
			      #'(lambda (stream subchar arg)
				  (let* ((sexp (read stream t))
					 (ty (case (fourth sexp)
					       ('ad 'vector3ad)
					       (otherwise 'vector3 ))))
				    `(make-instance ',ty
						    :x ,(first sexp)
						    :y ,(second sexp)
						    :z ,(third sexp)
						    ))))

(defmethod print-object ((v vector3) stream)
  (with-slots (x y z) v
       (format t "~a : ~f ~f ~f ~%" (type-of v) x y z)))

