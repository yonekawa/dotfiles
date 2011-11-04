;===================================
; Language
;===================================
;(require 'un-define)
(set-language-environment "Japanese")
(set-terminal-coding-system 'utf-8-unix)
(set-keyboard-coding-system 'utf-8-unix)
(set-buffer-file-coding-system 'utf-8-unix)
(setq default-buffer-file-coding-system 'utf-8-unix)
(prefer-coding-system 'utf-8-unix)

;===================================
; Load path
;===================================
(setq load-path (cons "~/.emacs.d/auto-install/" load-path))

;===================================
; Wheel mouse
;===================================
(mouse-wheel-mode)
(defun up-slightly () (interactive) (scroll-up 5))
(defun down-slightly () (interactive) (scroll-down 5))
(global-set-key [mouse-4] 'down-slightly)
(global-set-key [mouse-5] 'up-slightly)

(defun up-one () (interactive) (scroll-up 1))
(defun down-one () (interactive) (scroll-down 1))
(global-set-key [S-mouse-4] 'down-one)
(global-set-key [S-mouse-5] 'up-one)

(defun up-a-lot () (interactive) (scroll-up))
(defun down-a-lot () (interactive) (scroll-down))
(global-set-key [C-mouse-4] 'down-a-lot)
(global-set-key [C-mouse-5] 'up-a-lot)

(defun scroll-down-with-lines ()
  "" (interactive) (scroll-down 3))
(defun scroll-up-with-lines ()
  "" (interactive) (scroll-up 3))
(global-set-key [wheel-up] 'scroll-down-with-lines)
(global-set-key [wheel-down] 'scroll-up-with-lines)
(global-set-key [double-wheel-up] 'scroll-down-with-lines)
(global-set-key [double-wheel-down] 'scroll-up-with-lines)
(global-set-key [triple-wheel-up] 'scroll-down-with-lines)
(global-set-key [triple-wheel-down] 'scroll-up-with-lines)

;====================================
; Misc
;====================================
(global-font-lock-mode t)  ;;文字の色つけ
(display-time)             ;;時計を表示
(setq line-number-mode t)  ;;カーソルのある行番号を表示
(auto-compression-mode t)  ;;日本語infoの文字化け防止
(setq frame-title-format   ;;フレームのタイトル指定
      (concat "%b - emacs@" system-name))

;; 全角空白やタブ文字に色づけ
(defface my-face-b-2 '((t (:background "gray26"))) nil)
(defface my-face-u-1 '((t (:foreground "SteelBlue" :underline t))) nil)
(defvar my-face-b-1 'my-face-b-1)
(defvar my-face-b-2 'my-face-b-2)
(defvar my-face-u-1 'my-face-u-1)
(defadvice font-lock-mode (before my-font-lock-mode ())
  (font-lock-add-keywords
   major-mode
   '(("	" 0 my-face-b-2 append)
     ("[ 	]+$" 0 my-face-u-1 append)
     )))
(setq-default transient-mark-mode t)
(ad-enable-advice 'font-lock-mode 'before 'my-font-lock-mode)
(ad-activate 'font-lock-mode)

;; バックアップファイルを作らない
(setq make-backup-files nil)
(setq auto-save-default nil)

;====================================
; Fonts
;====================================
(add-to-list 'default-frame-alist '(font . "fontset-default"))
(set-face-attribute 'default nil
                    :family "consolas"
                    :height 180)
(set-fontset-font "fontset-default" 'japanese-jisx0208
                  '("ヒラギノ角ゴ pro w3" . "jisx0208.1983"))
(set-fontset-font "fontset-default" 'katakana-jisx0201
                  '("ヒラギノ角ゴ pro w3" . "jisx0201.1976"))


;====================================
; Initial フレームサイズ,位置,色,フォントなど
;====================================
(setq initial-frame-alist
      (append (list
               '(foreground-color . "white")   ;; 文字色
               '(background-color . "#000000") ;; 背景色
               '(border-color . "black")
               '(mouse-color . "white")
               '(cursor-color . "white")
               '(width . 80)                   ;; フレームの幅
               '(height . 30)                  ;; フレームの高さ
               '(top . 0)                      ;; Y 表示位置
               '(left . 10)                   ;; X 表示位置
               )
              initial-frame-alist))
(setq default-frame-alist initial-frame-alist)
;;; ツールバーを隠す
(tool-bar-mode 0)
;;; スクロールバーを隠す
(scroll-bar-mode nil)

;====================================
; セッション
;====================================
;Emacsを終了してもファイルを編集してた位置や
;minibuffer への入力内容を覚えててくれます。
(when (require 'session nil t)
(setq session-initialize '(de-saveplace session keys menus places)
      session-globals-include '((kill-ring 50)
                                (session-file-alist 500 t)
                                (file-name-history 10000)))
;; これがないと file-name-history に500個保存する前に max-string に達する
(setq session-globals-max-string 100000000)
;; デフォルトでは30!
(setq history-length t)
(add-hook 'after-init-hook 'session-initialize))

;====================================
;細かい設定
;====================================
;;; Shitf矢印で移動
(windmove-default-keybindings)

;;; Shift + 矢印で選択
(setq pc-select-selection-keys-only t)

;;; C-x bを便利に
(iswitchb-mode t)

;; 最初のメッセージを隠す
(setq inhibit-startup-message t)

;; カレントラインに色をつける
(global-hl-line-mode t)
(defface my-hl-line-face
  '((((class color) (background dark))
     (:background "NavyBlue" t))
    (t (:bold t)))
  "hl-line's my face")
(setq hl-line-face 'my-hl-line-face)

;;; 同じファイル名だったらユニークになる部分までのディレクトリ名を出す
(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)

;;; M-xの候補を補完
(require 'mcomplete) (turn-on-mcomplete-mode)

;;; ac-mode
(autoload 'ac-mode "ac-mode" "Minor mode for advanced completion." t nil)
(setq ac-mode-goto-end-of-word t)

;;; 対応する括弧をハイライト
(show-paren-mode t)

;;; %で対応する括弧にジャンプ
(global-set-key "%" 'match-paren)
(defun match-paren (arg)
  "Go to the matching paren if on a paren; otherwise insert %."
  (interactive "p")
  (cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
        ((looking-at "\\s\)") (forward-char 1) (backward-list 1))
        (t (self-insert-command (or arg 1)))))

;====================================
; Auto Install
;====================================
;(require 'auto-install)
;(setq auto-install-directory "~/.emacs.d/auto-install/")
;(auto-install-update-emacswiki-package-name t)
;(auto-install-compatibility-setup)

;====================================
; Anything
;====================================
(defvar org-directory "")
(require 'anything-startup)

;====================================
; moccur-grep
; ack のが早そう
;====================================
(autoload 'moccur-grep "color-moccur" nil t)
(autoload 'moccur-grep-find "color-moccur" nil t)
(load "moccur-edit")
(setq moccur-edit-highlight-edited-text t)
(setq *moccur-buffer-name-exclusion-list*
      '("\.svn" "*Completions*" "*Messages*"))

;====================================
; elscreen
;====================================
(when (locate-library "elscreen")
   (setq elscreen-prefix-key (if window-system [?\C-\;] "\C-\\"))
   (require 'elscreen)
   (define-key global-map [(control tab)] 'elscreen-next))

;====================================
; Dired
;====================================
;;; ファイルやディレクトリを開くときに新しいバッファを開かない
(defun dired-find-alternate-file ()
  "In dired, visit this file or directory instead of the dired buffer."
  (interactive)
  (set-buffer-modified-p nil)
  (find-alternate-file (dired-get-filename)))

;====================================
; Ack
;====================================
(defun ack ()
  (interactive)
  (let ((grep-find-command "ack -a --nocolor --nogroup "))
    (call-interactively 'grep-find)))

;====================================
; c-mode
;====================================
(add-hook 'c-mode-common-hook
  '(lambda ()
     (c-set-style "bsd")
     (setq c-basic-offset 4)
     (setq indent-tabs-mode nil)))

;====================================
; php-mode
; tab offset 4 & indent-tabs-mode nil
; php-mode extensions are .tpl, .csp, .inc and .php
;====================================

(autoload 'php-mode "php-mode" "Mode for editing PHP source files")
(add-to-list 'auto-mode-alist '("\\.\\(tpl\\|csp\\|inc\\|php[s345]?\\)" . php-mode))
(add-hook 'php-mode-user-hook
          '(lambda ()
             (progn
               (c-toggle-hungry-state 1)
               (setq c-basic-offset 4 indent-tabs-mode nil))))
(add-hook 'php-mode-hook
          (lambda ()
             (require 'php-completion)
             (php-completion-mode t)
             (define-key php-mode-map (kbd "C-p") 'phpcmp-complete)
             (when (require 'auto-complete nil t)
             (make-variable-buffer-local 'ac-sources)
             (add-to-list 'ac-sources 'ac-source-php-completion)
             (auto-complete-mode t))))
;(require 'flymake-php)
;(add-hook 'php-mode-user-hook 'flymake-php-load)

;====================================
; CSS mode
;====================================
(autoload 'css-mode "css-mode")
(setq auto-mode-alist
      (cons '("\\.css\\'" . css-mode) auto-mode-alist))
(setq cssm-indent-function #'cssm-c-style-indenter)

;====================================
; js2-mode
;====================================
;;; js2-mode
(autoload 'js2-mode "js2-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
(add-hook 'js2-mode-hook
          '(lambda ()
             (progn
               (setq js2-basic-offset 2 indent-tabs-mode nil))))

;====================================
; coffee-mode
;====================================
(require 'coffee-mode)
(add-to-list 'auto-mode-alist '("\\.\\(js.shd\\|coffee\\)$" . coffee-mode))
(setq coffee-tab-width 2)

; shadow
;====================================
;(setq shadow-suffix "coffee")
(require 'shadow)
(add-hook 'find-file-hooks 'shadow-on-find-file)
(add-hook 'shadow-find-unshadow-hook
          (lambda () (auto-revert-mode 1)))

;====================================
; snippet
;====================================
(load "snippet")

(defun my-snippet-php ()
  (define-abbrev-table 'php-mode-abbrev-table '())
  (snippet-with-abbrev-table
   'php-mode-abbrev-table
   ("aks"      .  "array_keys($${array})")
   ("ake"      .  "array_key_exists($${key}, $${array})")
   ("req1"     .  "require_once( '$${filepath}' );")
   ("v"        .  "var_dump($${variable});")))

(add-hook 'php-mode-hook 'my-snippet-php)

;====================================
; 動的略語展開の候補を表示
;====================================
;(require 'pabbrev)
;(global-pabbrev-mode)

;====================================
; vc-gitが遅いのでオフ
;====================================
(delete 'Git vc-handled-backends)

;====================================
; diff-mode
;====================================
(autoload 'diff-mode "diff-mode" "Diff major mode" t)
(add-to-list 'auto-mode-alist '("\\.\\(diffs?\\|patch\\|rej\\)\\'" . diff-mode))
(add-hook 'diff-mode-hook
          (lambda ()
            (set-face-foreground 'diff-file-header-face "light goldenrod")
            (set-face-foreground 'diff-index-face "thistle")
            (set-face-foreground 'diff-hunk-header-face "plum")
            (set-face-foreground 'diff-removed-face "pink")
            (set-face-background 'diff-removed-face "gray26")
            (set-face-foreground 'diff-added-face "light green")
            (set-face-background 'diff-added-face "gray26")
            (set-face-foreground 'diff-changed-face "DeepSkyBlue1")
            ))

;====================================
; viper-mode
;====================================
(setq viper-mode 't)
(setq viper-inhibit-startup-message 't)
(require 'viper)

;;; DELとBSで前の改行を削除
(define-key viper-vi-global-user-map [backspace] 'backward-delete-char-untabify)
(define-key viper-vi-global-user-map [delete] 'delete-char)
(define-key viper-insert-global-user-map [backspace] 'backward-delete-char-untabify)
(define-key viper-insert-global-user-map [delete] 'delete-char)

(define-key viper-vi-global-user-map "\C-y" 'yank)
(define-key viper-insert-global-user-map "\C-w" 'clipboard-kill-region)
(define-key viper-vi-global-user-map "\C-z" 'indent-region)
(define-key viper-insert-global-user-map "\C-z" 'indent-region)

;====================================
; Key mapping
;====================================
;;; dynamic abbrev
(define-key global-map "\C-o" 'dabbrev-expand)
;;; indent-region
(define-key global-map "\C-z" 'indent-region)
;;; backward kill word in minibuffer
(define-key global-map "\C-w" 'clipboard-kill-region)

;(define-key minibuffer-local-completion-map "\M-a" 'ack)
(define-key global-map "\M-a" 'ack)

;====================================
; rst (sphinx)
;====================================
(require 'rst)
(setq auto-mode-alist
      (append '(("\\.rst$" . rst-mode)
                ("\\.rest$" . rst-mode)) auto-mode-alist))
(setq frame-background-mode 'dark)
(add-hook 'rst-mode-hook '(lambda() (setq indent-tabs-mode nil)))
