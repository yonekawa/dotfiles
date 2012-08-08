;;;
;;; frame-arrange.el --- frame arrange manager for emacs
;;;

;; Copyright (C) 2011 valvallow

;; Author: valvallow <valvalloooooooooow atmark gmail.com>
;; Last modified: Time-stamp: <Thu Jan 27 21:35:34  2011>
;; Filename: frame-arrange.el
;; Maintainer: valvallow
;; Version: 0.1
;; Keywords: frame, position, size

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.


;; ----- initialization -----
;;
;; (require 'frame-arrange)
;; (frame-arrange-mode t)
;;
;; usage
;; http://valvallow.blogspot.com/2011/01/emacs-frame-arrangeel.html
;;
;; code

(setq warning-suppress-types nil)

(require 'cl)

;; http://d.hatena.ne.jp/podhmo/20101103/1288799246
(load "defmacro!")


;; --- variables

(defvar frame-arrange-mode nil)

(defvar frange:max-specpdl-size 6000)
(defvar frange:max-lisp-eval-depth 2000)
(defvar frange:max-specpdl-size-backup max-specpdl-size)
(defvar frange:max-lisp-eval-depth-backup max-lisp-eval-depth)

(defvar frange:position-incremental-value 5)
(defvar frange:size-incremental-value 1)

(defvar frange:arrange-config-alist-file-name "~/.frange")
(defvar frange:load-config? t)
(defvar frange:save-config? t)

(defvar frange:arrange-config-alist nil)


;; --- initialize

(unless (assq 'frame-arrange-mode minor-mode-alist)
  (setq minor-mode-alist
        (cons '(frame-arrange-mode " frange")
              minor-mode-alist)))

(defun frange:initialize ()
  (when (< max-specpdl-size frange:max-specpdl-size)
    (setq max-specpdl-size frange:max-specpdl-size))
  (when (< max-lisp-eval-depth frange:max-lisp-eval-depth)
    (setq max-lisp-eval-depth frange:max-lisp-eval-depth))
  (when frange:load-config?
    (frange:load-arrange-config-alist-file))
  t)

(defun frame-arrange-mode (&optional arg)
  "frame-arrange minor-mode"
  (interactive)
  (cond
   ((< (prefix-numeric-value arg) 0)
    (setq frame-arrange-mode nil))
   (arg (setq frame-arrange-mode t))
   (t (setq frame-arrange-mode (not frame-arrange-mode))))
  ;; (when frame-arrange-mode
  ;;   (frange:initialize))
  (frange:initialize)
  )


;; --- utilities

;; http://www.ne.jp/asahi/alpha/kazu/elisp.html#fold2
(defun frange:foldl (kons knil ls &rest more)
  (do ((ls ls (cdr ls))
       (more more (mapcar #'cdr more))
       (knil knil (apply kons
                         (apply #'list (car ls)
                                (append (mapcar #'car more)
                                        (list knil))))))
      ((null ls) knil)))

(defun frange:acons (sym val ls)
  (cons (cons sym val) ls))

(defun frange:assoc$ (obj)
  (lexical-let ((obj obj))
    #'(lambda (sym)
        (assoc sym obj))))

(defun frange:make-alist (syms vals)
  (frange:foldl #'(lambda (sym val acc)
                    (if val
                        (frange:acons sym val acc)
                      acc))
                nil syms vals))

(defun frange:partial-inject-alist (from to)
  (mapcar #'(lambda (e)
              (let ((exist (assq (car e) from)))
                (or exist e)))
          to))

(defmacro frange:mac (exp)
  `(message (mkstr (macroexpand ,exp))))

(defun frange:param-name-extract (&rest params)
  (frange:foldl #'(lambda (e acc)
                    (if (car e)
                        (cons (car e) acc)
                      acc))
                '() (reverse params)))

(defun frange:position-inc (v frame)
  (+ v frange:position-incremental-value))

(defun frange:position-dec (v frame)
  (- v frange:position-incremental-value))

(defun frange:size-inc (v frame)
  (+ v frange:size-incremental-value))

(defun frange:size-dec (v frame)
  (- v frange:size-incremental-value))

(defun frange:0 (v frame)
  0)

(defun frange:-1 (v frame)
  -1)


;; --- low level api

(defun* frange:frame-parameter (frame &rest param-names)
  (let ((params (frame-parameters frame)))
    (if param-names
        (let ((a$ (frange:assoc$ params)))
          (frange:foldl #'(lambda (sym acc)
                            (cons (funcall a$ sym) acc))
                        nil param-names))
      params)))
;; example
;; (frange:frame-parameter (selected-frame) 'width 'top)

(defun frange:arrange/alist (frame alist)
  (let ((al (cons '(user-position . t) alist)))
    (modify-frame-parameters frame al)))
;; example
;; (frange:arrange/alist (selected-frame) '((top . 30)))

(defun frange:arrange/f (frame alist-gen)
  (frange:arrange/alist frame
                        (funcall alist-gen frame)))
;; example
;; (frange:arrange/f (selected-frame)
;;                   #'(lambda (frame)
;;                       (frange:partial-inject-alist
;;                        (frange:make-alist '(left top)'(0 0))
;;                        (frange:frame-position-parameter frame))))

(defun frange:arrange-partial-gen (syms vals)
  (lexical-let ((syms syms)(vals vals))
    #'(lambda (frame)
        (frange:partial-inject-alist
         (frange:make-alist syms vals)
         (frange:frame-position-parameter frame)))))
;; example
;; (frange:arrange/f (selected-frame)(frange:arrange-partial-gen '(top left)'(0 0)))


;; --- high level api

(defun frange:frame-position-parameter (frame)
  (apply #'frange:frame-parameter frame '(width height left top)))
;; example
;; (frange:frame-position-parameter (selected-frame))

(defun frange:current-frame-position-parameter ()
  (frange:frame-position-parameter (selected-frame)))
;; example
;; (frange:current-frame-position-parameter)

(defun* frange:arrange (frame &key (w nil)(h nil)(x nil)(y nil))
  (let ((syms '(width height left top user-position))
        (vals `(,w ,h ,x ,y ,t)))
    (frange:arrange/f
     frame
     (frange:arrange-partial-gen syms vals))))
;; example
;; (frange:arrange (selected-frame) :y 0)


;; --- macros

(defmacro! def:frange (name &rest params)
  `(defun ,(symb 'frange: name)
     (,G!frame ,@(apply #'frange:param-name-extract params))
     (let ((,G!pp (frange:frame-parameter ,G!frame)))
       (frange:arrange/f
        ,G!frame
        (frange:arrange-partial-gen
         ',(mapcar #'cadr params)
         (mapcar (lexical-let ((,G!ppr ,G!pp))
                   #'(lambda (,G!ls)
                       (let ((,G!av (cdr (assoc (cadr ,G!ls) ,G!ppr))))
                         (if (caddr ,G!ls)
                             ;; (funcall (symbol-function (caddr ,G!ls))
                             (funcall (if (symbolp (caddr ,G!ls))
                                          (symbol-function (caddr ,G!ls))
                                          (eval (caddr ,G!ls)))
                                      (if (car ,G!ls)
                                          (symbol-value (car ,G!ls))
                                        ,G!av)
                                      ,G!frame)
                           ,G!av))))
                 ',params))))))

(defmacro! def:frange/current-frame (name &rest params)
  `(progn
     (def:frange ,name ,@params)
     (defun ,(symb 'frange: name '/current-frame)
       (,@(apply #'frange:param-name-extract params))
       (interactive)
       (,(symb 'frange: name)(selected-frame)
        ,@(apply #'frange:param-name-extract params)))))


;; --- high level api

;; regist
(defun frange:regist-frame-position-parameter/current-frame (sym)
  (let ((fp (frange:frame-position-parameter (selected-frame))))
    (frange:regist-frame-position-parameter sym fp)))

(defun frange:regist-frame-position-parameter (sym als)
  (setq frange:arrange-config-alist
        (frange:acons sym als frange:arrange-config-alist))
  (when frange:save-config?
    (frange:save-arrange-config-alist-file)))

;; restore
(defun frange:restore-frame-position-parameter (frame sym)
  (let ((v (cdr (assoc sym frange:arrange-config-alist))))
    (when v
      (frange:arrange/alist frame v))))


;; ----- print

(defun frange:print-arrange-config-names ()
  (interactive)
  (princ (frange:foldl #'(lambda (e acc)
                           (cons (car e) acc))
                       nil frange:arrange-config-alist))
  t)

(defun frange:print-arrange-config-alist-entries ()
  (interactive)
  (princ frange:arrange-config-alist)
  t)

(defun frange:print-frame-position-parameter/current-frame ()
  (interactive)
  (princ (frange:frame-position-parameter (selected-frame)))
  t)


;; ----- serialize, deserialize

(defun frange:remove-arrange-config-alist-entry (sym)
  (setq frange:arrange-config-alist
        (frange:foldl #'(lambda (e acc)
                          (if (equal (car e) sym)
                              acc
                            (cons e acc)))
                      nil frange:arrange-config-alist))
  (when frange:save-config?
    (frange:save-arrange-config-alist-file)))
;; (frange:remove-arrange-config-alist-entry 'min)


(defun frange:save-arrange-config-alist-file ()
  (with-temp-buffer
    (insert
     (prin1 (mkstr frange:arrange-config-alist)))
    (write-region (point-min) (point-max)
                  frange:arrange-config-alist-file-name
                  nil)))
;; (frange:save-arrange-config-alist)

(defun frange:load-arrange-config-alist-file ()
  (with-temp-buffer
    (when (file-exists-p frange:arrange-config-alist-file-name)
      (insert-file-contents frange:arrange-config-alist-file-name)
      (setq frange:arrange-config-alist
            (read (current-buffer))))))


;; ----- interactive functions

(defun frange:clear-arrange-config-alist ()
  (interactive)
  (setq frange:arrange-config-alist nil))

(defun frange:remove-arrange-config-alist-interactive ()
  (interactive)
  (frange:remove-arrange-config-alist-entry
   (symb (read-from-minibuffer "frame config name: "))))

(defun frange:regist-frame-position-parameter-interactive ()
  (interactive)
  (frange:regist-frame-position-parameter
   (symb (read-from-minibuffer "frame config name: "))
   (frange:current-frame-position-parameter)))
;; (frange:regist-frame-position-parameter/current-frame)

(defun frange:restore-frame-position-parameter-interactive ()
  (interactive)
  (frange:restore-frame-position-parameter
   (selected-frame)
   (symb (read-from-minibuffer "frame config name: "))))


;; cycle
(defun frange:cycle-arrange-config-gen ()
  (lexical-let ((cur 0))
    #'(lambda ()
        (interactive)
        (let ((conf frange:arrange-config-alist))
          (when conf
            (let* ((len (length conf))
                   (next (if (<= len (+ cur 1))
                             0
                           (+ cur 1))))
              (frange:restore-frame-position-parameter
               (selected-frame)
               (car (nth next conf)))
              (setq cur next)))))))

;; generate arrange functions

;; increment, decrement
(def:frange/current-frame increment-position-left
  (nil left frange:position-inc))
(def:frange/current-frame increment-position-right
  (nil left frange:position-dec))
(def:frange/current-frame increment-position-top
  (nil top frange:position-inc))
(def:frange/current-frame increment-position-bottom
  (nil top frange:position-dec))

(def:frange/current-frame arrange/left-most
  (nil left frange:0))
(def:frange/current-frame arrange/right-most
  (nil left frange:-1))
(def:frange/current-frame arrange/top-most
  (nil top frange:0))
(def:frange/current-frame arrange/bottom-most
  (nil top frange:-1))
(def:frange/current-frame arrange/top-left-most
  (nil top frange:0)
  (nil left frange:0))
(def:frange/current-frame arrange/top-right-most
  (nil top frange:0)
  (nil left frange:-1))
(def:frange/current-frame arrange/bottom-left-most
  (nil top frange:-1)
  (nil left frange:0))
(def:frange/current-frame arrange/bottom-right-most
  (nil top frange:-1)
  (nil left frange:-1))

(def:frange/current-frame increment-size
  (nil height #'frange:size-inc)
  (nil width #'frange:size-inc))

(def:frange/current-frame decrement-size
  (nil height #'frange:size-dec)
  (nil width #'frange:size-dec))

(def:frange/current-frame increment-size-w
  (nil width #'frange:size-inc))
(def:frange/current-frame increment-size-h
  (nil height #'frange:size-inc))

(def:frange/current-frame decrement-size-w
  (nil width #'frange:size-dec))
(def:frange/current-frame decrement-size-h
  (nil height #'frange:size-dec))

(provide 'frame-arrange)