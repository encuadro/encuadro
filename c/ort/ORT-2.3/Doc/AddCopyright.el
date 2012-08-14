;;;
; This macro adds a COPYRIGHT notice to the top of all C programs when invoked:
;
; find . -name '*.c' -print -exec emacs -q -batch {} -l /FULLPATH/AddCopyright.el -f doit \;
;;; 
(defun doit ()
  (insert-file "/FULLPATH/ORT/Doc/COPYRIGHT")
  (save-buffer)
  (kill-emacs)
)
