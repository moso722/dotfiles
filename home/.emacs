;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; GNU Emacs設定
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; ロードパスの設定
(let ((default-directory (expand-file-name "~/.emacs.d")))
  (setq load-path (cons default-directory load-path))
  (normal-top-level-add-subdirs-to-load-path))

:; 初期フレームの設定
(setq default-frame-alist
      (append (list
               '(foreground-color . "black")             ; 文字色
               '(background-color . "ghost white")       ; 背景色
               '(mouse-color      . "ghost white")       ; マウスポインタ色
               '(cursor-color     . "ghost white")       ; カーソル色
               '(left             . 90)                  ; X座標
               '(top              . 10)                  ; Y座標
               '(width            . 90)                  ; 横サイズ
               '(height           . 40))                 ; 縦サイズ
              default-frame-alist))

;; 起動時はホームディレクトリで dired を呼び出す
(setq user-home-directory "c:/Users/fujioka015/Home")
(dired user-home-directory)

;; インデントをスペースにする
(setq indent-tabs-mode nil)
(setq-default indent-tabs-mode nil)

;; タブはスペース4つに展開にして表示
(setq-default tab-width 4)

;; 自動的に行を追加しない
(setq next-line-add-newlines nil)

;; 起動時のメッセージを非表示
(setq inhibit-startup-message t)

;; バッファ切り替え支援
(setq iswitchb-mode t)

;; モードラインにカーソル位置の行数・列数を表示
(line-number-mode t)
(column-number-mode t)

;; モードラインに日付時刻を表示
(setq dayname-j-alist
      '(("Sun" . "日") ("Mon" . "月") ("Tue" . "火") ("Wed" . "水")
        ("Thu" . "木") ("Fri" . "金") ("Sat" . "土")))
(setq display-time-string-forms
      '((format "%s月%s日(%s) %s:%s"
                month day (cdr (assoc dayname dayname-j-alist))
                24-hours minutes load)))
(display-time-mode t)

;; 同一ファイル名の時，ディレクトリも同時に表示
(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)
(setq uniquify-ignore-buffers-re "*[^*]+*")

;; ファイル名の補完で大文字小文字を区別しない
(setq completion-ignore-case t)

;; ファイルの先頭が#!で始まる場合、実行権をつけて保存する
(add-hook 'after-save-hook
          'executable-make-buffer-file-executable-if-script-p)

;; *.~ *#などのバックアップファイルを作らない
(setq make-backup-files nil)
(setq auto-save-default nil)

;; タイムスタンプ設定
(if (not (memq 'time-stamp write-file-hooks))
 (setq write-file-hooks
    (cons 'time-stamp write-file-hooks)))
(setq time-stamp-start "Last-Updated: [ \t]*<")
(setq time-stamp-end ">")

;; 置換文字列の大文字変換をおこなわない
(setq case-replace nil)

;; 実行環境判別
(setq run-w32     (equal system-type 'windows-nt)
      run-linux   (equal system-type 'gnu/linux)
      run-darwin  (equal system-type 'darwin))

;; dired
(require 'dired)
(setq ls-lisp-dirs-first t)
(setq find-ls-option '("-exec ls -AFGl {} \\;" . "-AFGl"))
(setq grep-find-command "find . -type f -print0 | xargs -0 -e grep -ns ")

;; RET時に新しくバッファを作成しない
(put 'dired-find-alternate-file 'disabled nil)
(define-key dired-mode-map (kbd "RET") 'dired-find-alternate-file)
(define-key dired-mode-map "a" 'dired-advertised-find-file)

(add-hook 'dired-mode-hook
          (lambda () (define-key dired-mode-map "z" 'dired-call-find)))

(defun dired-call-find (arg)
  (interactive "P")

  ;; Windows
  (when run-w32
    (let ((process-name  "explorer")
          (buffer-name   "diredfiber")
          (program       "explorer.exe"))

      (defun unix-to-dos-filename (s)
        (concat (mapcar '(lambda (x) (if(= x ?/) ?\\ x)) (string-to-list s))))

      (if arg
          (start-process process-name buffer-name program
                         (unix-to-dos-filename (directory-file-name dired-directory))))
      (let ((file (dired-get-filename)))
        (if (file-directory-p file)
            (start-process process-name buffer-name program
                           (unix-to-dos-filename file)))
        (let ((program "fiber.exe"))
          (start-process process-name buffer-name program file)))))

  ;; Mac
  (when run-darwin
    (let ((process-name  "open")
          (buffer-name   "diredopen")
          (program       "open"))

      (start-process process-name buffer-name program (dired-get-filename)))))

;; 日本語環境設定
(set-language-environment "Japanese")

;; バッファの文字コード
(setq default-buffer-file-coding-system 'utf-8)

;; 対応する括弧を光らせる
(show-paren-mode t)

;; ハイライト
(transient-mark-mode t)           ; 選択部分
(setq search-highlight t)         ; 検索単語
(setq query-replace-highlight t)  ; 置換単語

;; バッファをタブ表示する
(when (locate-library "tabbar")
  (require 'tabbar)
  (setq tabbar-buffer-groups-function
        (lambda (b) (list "All Buffers")))
  (setq tabbar-buffer-list-function
        (lambda ()
          (remove-if
           (lambda(buffer)
             (find (aref (buffer-name buffer) 0) " *"))
           (buffer-list))))

  (global-set-key "\M-[" 'tabbar-forward)
  (global-set-key "\M-]" 'tabbar-backward)
  (tabbar-mode))

(if window-system
    (progn

      ;; メニューバー表示
      (menu-bar-mode t)

      ;; スクロールバー表示
      (scroll-bar-mode t)

      ;; ツールバー表示
      (tool-bar-mode 0)

      ;; 空白文字とタブに色をつける
      (defface my-face-b-1
        '((t (:background "SlateGray1"))) nil)
      (defface my-face-b-2
        '((t (:background "rgb:E000/E000/E000"))) nil)
      (defface my-face-u-1
        '((t (:foreground "SteelBlue" :underline t))) nil)
      (defvar my-face-b-1 'my-face-b-1)   ; 全角スペース
      (defvar my-face-b-2 'my-face-b-2)   ; タブ
      (defvar my-face-u-1 'my-face-u-1)   ; 行末の空白
      (defadvice font-lock-mode (before my-font-lock-mode ())
        (font-lock-add-keywords
         major-mode
         '(("\t" 0 my-face-b-2 append)
           ("　" 0 my-face-b-1 append)
           ("[ \t]+$" 0 my-face-u-1 append)
           )))
      (ad-enable-advice 'font-lock-mode 'before 'my-font-lock-mode)
      (ad-activate 'font-lock-mode)

      ;; ウィンドウ間を Shift+ <カーソルキー> で移動
      (windmove-default-keybindings)

      ;; Windows
      (when run-w32
        (set-face-attribute 'default nil :family "ＭＳ ゴシック" :height 120))

      ;; Mac
      (when run-darwin
        (setq mac-allow-anti-aliasing t)
        (set-face-attribute 'default nil :family "ＭＳ ゴシック" :height 160))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; プログラミング
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; 拡張子とメジャーモードの対応付け
(setq auto-mode-alist
      (append '(("\\.java"                  . java-mode)   ; Java
                ("\\.\\(js\\|json\\)$"      . js2-mode)    ; JavaScript
                ("\\.rb"                    . ruby-mode)   ; Ruby
                ("\\.css$"                  . css-mode)    ; CSS
                ) auto-mode-alist))

;; JavaScript
(when (locate-library "js2")
  (autoload 'js2-mode "js2" "JavaScript Development Environment for Emacs" t)
  (add-hook 'js2-mode-hook
            '(lambda ()
               (setq js2-cleanup-whitespace nil)
               (setq js2-mirror-mode nil)
               (setq js2-bounce-indent-flag nil)
               (setq js2-basic-offset 2)
               (define-key js2-mode-map "\C-m" 'newline-and-indent)
               (define-key js2-mode-map "\C-i" 'indent-and-back-to-indentation)))

  (defun indent-and-back-to-indentation ()
    (interactive)
    (indent-for-tab-command)
    (let ((point-of-indentation
           (save-excursion
             (back-to-indentation)
             (point))))
      (skip-chars-forward "\s " point-of-indentation))))

;; Ruby
(when (locate-library "ruby-mode")
  (autoload 'ruby-mode "ruby-mode" "ruby mode" t)
  (setq ruby-indent-level 2)
  (setq ruby-indent-tabs-mode nil))

;; CSS
(when (locate-library "css-mode")
  (setq cssm-indent-level 4)
  (setq cssm-newline-before-closing-bracket t)
  (setq cssm-indent-function #'cssm-c-style-indenter))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; キーバインド
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(global-set-key "\C-h" 'backward-delete-char)      ; バックスペース
(global-set-key "\C-j" 'dabbrev-expand)            ; 入力補完
(global-set-key "\C-c\C-r" 'revert-buffer)         ; revert-buffer

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; シェル
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq shell-file-name (executable-find "bash"))
(setenv "SHELL" shell-file-name)
(setq explicit-shell-file-name shell-file-name)
(add-hook 'shell-mode-hook
          '(lambda ()
             ;; キーバインド
             (local-set-key "\C-cl" 'erase-buffer)
             ;; 行末の空白などはハイライトしない
             (ad-deactivate 'font-lock-mode)
             ;; Bash補完を有効にする
             (require 'bash-completion)
             (bash-completion-setup)))

