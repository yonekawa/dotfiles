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
(let ((default-directory (expand-file-name "~/.emacs.d/elisp")))
 (add-to-list 'load-path default-directory)
 (if (fboundp 'normal-top-level-add-subdirs-to-load-path)
     (normal-top-level-add-subdirs-to-load-path)))

;(add-to-list load-path (cons "~/.emacs.d/auto-install/" load-path))

;====================================
; Frame size/Position/Color
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
               '(left . 10)                    ;; X 表示位置
               )
              initial-frame-alist))
(setq default-frame-alist initial-frame-alist)

;===================================
; Wheel mouse
;===================================
;(mouse-wheel-mode t)
;(defun up-slightly () (interactive) (scroll-up 5))
;(defun down-slightly () (interactive) (scroll-down 5))
;(global-set-key [mouse-4] 'down-slightly)
;(global-set-key [mouse-5] 'up-slightly)

;(defun up-one () (interactive) (scroll-up 1))
;(defun down-one () (interactive) (scroll-down 1))
;(global-set-key [S-mouse-4] 'down-one)
;(global-set-key [S-mouse-5] 'up-one)

;(defun up-a-lot () (interactive) (scroll-up))
;(defun down-a-lot () (interactive) (scroll-down))
;(global-set-key [C-mouse-4] 'down-a-lot)
;(global-set-key [C-mouse-5] 'up-a-lot)

;(defun scroll-down-with-lines ()
;  "" (interactive) (scroll-down 3))
;(defun scroll-up-with-lines ()
;  "" (interactive) (scroll-up 3))
;(global-set-key [wheel-up] 'scroll-down-with-lines)
;(global-set-key [wheel-down] 'scroll-up-with-lines)
;(global-set-key [double-wheel-up] 'scroll-down-with-lines)
;(global-set-key [double-wheel-down] 'scroll-up-with-lines)
;(global-set-key [triple-wheel-up] 'scroll-down-with-lines)
;(global-set-key [triple-wheel-down] 'scroll-up-with-lines)

;====================================
; GUI Dependency
;====================================
(if window-system
    (scroll-bar-mode nil)) ;; スクロールバーを隠す
(if window-system
    (tool-bar-mode 0))     ;; ツールバーを隠す

;====================================
; Misc
;====================================
(global-font-lock-mode t)  ;; 文字の色つけ
(display-time)             ;; 時計を表示
(setq line-number-mode t)  ;; カーソルのある行番号を表示
(auto-compression-mode t)  ;; 日本語infoの文字化け防止
(setq frame-title-format   ;; フレームのタイトル指定
      (concat "%b - emacs@" system-name))

(setq highlight-nonselected-windows t) 
(setq next-line-add-newlines nil) ;バッファ末尾に余計な改行コードを防ぐ
(windmove-default-keybindings) ;; Shitf矢印で移動
(setq pc-select-selection-keys-only t) ;; Shift + 矢印で選択
(setq inhibit-startup-message t) ;; 最初のメッセージを隠す

(setq gc-cons-threshold 5242880)

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

;; カレントラインに色をつける
(global-hl-line-mode t)
(defface my-hl-line-face
  '((((class color) (background dark))
     (:background "NavyBlue" t))
    (t (:bold t)))
  "hl-line's my face")
(setq hl-line-face 'my-hl-line-face)

;;; undo
(setq undo-limit 100000)
(setq undo-strong-limit 130000)
(global-set-key "\M-z" 'undo)

;;; 動的略語展開で大文字小文字を区別しない
(setq dabbrev-case-fold-search nil)

;;; ac-mode
(autoload 'ac-mode "ac-mode" "Minor mode for advanced completion." t nil)
(setq ac-mode-goto-end-of-word t)

;;; kill-summary
;(autoload 'kill-summary "kill-summary" nil t)
;(define-key global-map "\ey" 'kill-summary)

;;; browse-kill-ring
(require 'browse-kill-ring)
(global-set-key "\M-y" 'browse-kill-ring)
(add-hook 'browse-kill-ring-hook
          (lambda ()
            (define-key browse-kill-ring-mode-map (kbd "\C-g") 'browse-kill-ring-quit)))

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

(require 'dabbrev-highlight)

;;; M-xの候補を補完
(require 'mcomplete)
(turn-on-mcomplete-mode)

;;; 同じファイル名だったらユニークになる部分までのディレクトリ名を出す
(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)

(require 'minibuf-isearch)

(defun ack ()
  (interactive)
  (let ((grep-find-command "ack -a --nocolor --nogroup "))
    (call-interactively 'grep-find)))

;;; vc-gitが遅いのでオフ
(delete 'Git vc-handled-backends)

;====================================
; Key mapping
;====================================
(setq ns-command-modifier (quote meta))
(setq ns-alternate-modifier (quote super))

(setq mac-pass-control-to-system nil)
(setq mac-pass-command-to-system nil)
(setq mac-pass-option-to-system nil)

(define-key global-map "\C-o"     'dabbrev-expand)
(define-key global-map "\C-z"     'indent-region)
(define-key global-map "\C-w"     'clipboard-kill-region)
(define-key global-map "\C-h"     'delete-backward-char)
(define-key global-map "\C-x\C-h" 'help-command)
(define-key global-map "\M-a"     'ack)
(define-key ctl-x-map  "l"        'goto-line)

;====================================
; Dired
;====================================
;;; ファイルやディレクトリを開くときに新しいバッファを開かない
(defun dired-find-alternate-file ()
  "In dired, visit this file or directory instead of the dired buffer."
  (interactive)
  (set-buffer-modified-p nil)
  (find-alternate-file (dired-get-filename)))

;==========================================
; session.el
;  Emacsを終了してもファイルを編集してた位置や
;  minibuffer への入力内容を覚えててくれます。
;==========================================
(when (require 'session nil t)
(setq session-initialize '(de-saveplace session keys menus places)
      session-globals-include '((kill-ring 50)
                                (session-file-alist 500 t)
                                (file-name-history 10000)))
(setq session-globals-max-string 100000000)
(setq history-length t)
(add-hook 'after-init-hook 'session-initialize))

;====================================
; iswitchb
;  Improvement switch buffer
;  http://tinyurl.com/8psug
;====================================
(require 'iswitchb)
(add-hook 'iswitchb-define-mode-map-hook
        (lambda ()
          (define-key iswitchb-mode-map "\C-n" 'iswitchb-next-match)
          (define-key iswitchb-mode-map "\C-p" 'iswitchb-prev-match)
          (define-key iswitchb-mode-map "\C-f" 'iswitchb-next-match)
          (define-key iswitchb-mode-map "\C-b" 'iswitchb-prev-match)))
(iswitchb-default-keybindings)

;====================================
; yacomplete
;  Improvement minibuffer search.
;====================================
(require 'yaicomplete)
(yaicomplete-mode)

;====================================
; Fonts
;====================================
(add-to-list 'default-frame-alist '(font . "fontset-default"))
(set-face-attribute 'default nil
                    :family "consolas"
                    :height 180)
(if window-system
    (set-fontset-font
     (frame-parameter nil 'font)
     'japanese-jisx0208
     '("Hiragino Kaku Gothic Pro" . "iso10646-1")))
(if window-system
    (set-fontset-font
     (frame-parameter nil 'font)
     'japanese-jisx0212
     '("Hiragino Kaku Gothic Pro" . "iso10646-1")))
(if window-system
    (set-fontset-font
     (frame-parameter nil 'font)
     'mule-unicode-0100-24ff
     '("monaco" . "iso10646-1")))

(setq face-font-rescale-alist
     '(("^-apple-hiragino.*" . 1.2)
       (".*osaka-bold.*" . 1.2)
       (".*osaka-medium.*" . 1.2)
       (".*courier-bold-.*-mac-roman" . 1.0)
       (".*monaco cy-bold-.*-mac-cyrillic" . 0.9)
       (".*monaco-bold-.*-mac-roman" . 0.9)
       ("-cdac$" . 1.3)))

;; 日本語フォントの幅をASCIIの倍に調整
(setq face-font-rescale-alist '(("-jisx02[^-]*-[^-]*\\'" . 1.2)))
;; 日本語フォントのboldに重ね打ちを使う
(setq face-ignored-fonts '("\\`-[^-]*-[^-]*-bold-.*-jisx02[^-]*-[^-]*\\'"))

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

(defun my-anything-filelist+ ()
  (interactive)
  (anything-other-buffer
   '(anything-c-source-files-in-current-dir+
     anything-c-source-buffers+
     anything-c-source-recentf
     anything-c-source-mac-spotlight
     anything-c-source-locate)
   " *my-anything-filelist+*"))

(global-set-key "\C-x\C-b" 'anything-buffers+)
(global-set-key "\C-x\C-v" 'my-anything-filelist+)

;====================================
; elscreen
;====================================
(when (locate-library "elscreen")
   (setq elscreen-prefix-key (if window-system [?\C-\;] "\C-\\"))
   (require 'elscreen)
   (define-key global-map [(control tab)] 'elscreen-next))

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
;====================================
(autoload 'php-mode "php-mode" "Mode for editing PHP source files")
(add-to-list 'auto-mode-alist '("\\.\\(csp\\|inc\\|php[s345]?\\)" . php-mode))
(add-hook 'php-mode-user-hook
          '(lambda ()
             (progn
               (c-toggle-hungry-state 1)
               (setq c-basic-offset 4 indent-tabs-mode nil))))
               (c-set-offset 'arglist-intro '+)
               (c-set-offset 'arglist-close 0)

(add-hook 'php-mode-hook
          (lambda ()
             (require 'php-completion)
             (php-completion-mode t)
             (define-key php-mode-map (kbd "C-p") 'phpcmp-complete)
             (when (require 'auto-complete nil t)
             (make-variable-buffer-local 'ac-sources)
             (add-to-list 'ac-sources 'ac-source-php-completion)
             (auto-complete-mode t))))

;;; Smarty
(add-to-list 'auto-mode-alist (cons "\\.tpl\\'" 'smarty-mode))
(autoload 'smarty-mode "smarty-mode" "Smarty Mode" t)

;====================================
; HTML mode
;====================================
(add-hook 'html-mode-hook
          (lambda()
            (setq sgml-basic-offset 2)
            (setq indent-tabs-mode nil)))

;====================================
; CSS mode
;====================================
(autoload 'css-mode "css-mode")
(setq auto-mode-alist
      (cons '("\\.css\\'" . css-mode) auto-mode-alist))
(setq cssm-indent-level 2)
(setq cssm-indent-function #'cssm-c-style-indenter)

;====================================
; js2-mode
;====================================
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

;====================================
; shadow
;====================================
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
; rst-mode (sphinx)
;====================================
(require 'rst)
(setq auto-mode-alist
      (append '(("\\.rst$" . rst-mode)
                ("\\.rest$" . rst-mode)) auto-mode-alist))
(setq frame-background-mode 'dark)
(add-hook 'rst-mode-hook '(lambda() (setq indent-tabs-mode nil)))

