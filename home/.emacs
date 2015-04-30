;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; GNU Emacs�ݒ�
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; ���[�h�p�X�̐ݒ�
(let ((default-directory (expand-file-name "~/.emacs.d")))
  (setq load-path (cons default-directory load-path))
  (normal-top-level-add-subdirs-to-load-path))

:; �����t���[���̐ݒ�
(setq default-frame-alist
      (append (list
               '(foreground-color . "black")             ; �����F
               '(background-color . "ghost white")       ; �w�i�F
               '(mouse-color      . "ghost white")       ; �}�E�X�|�C���^�F
               '(cursor-color     . "ghost white")       ; �J�[�\���F
               '(left             . 90)                  ; X���W
               '(top              . 10)                  ; Y���W
               '(width            . 90)                  ; ���T�C�Y
               '(height           . 40))                 ; �c�T�C�Y
              default-frame-alist))

;; �N�����̓z�[���f�B���N�g���� dired ���Ăяo��
(setq user-home-directory "c:/Users/fujioka015/Home")
(dired user-home-directory)

;; �C���f���g���X�y�[�X�ɂ���
(setq indent-tabs-mode nil)
(setq-default indent-tabs-mode nil)

;; �^�u�̓X�y�[�X4�ɓW�J�ɂ��ĕ\��
(setq-default tab-width 4)

;; �����I�ɍs��ǉ����Ȃ�
(setq next-line-add-newlines nil)

;; �N�����̃��b�Z�[�W���\��
(setq inhibit-startup-message t)

;; �o�b�t�@�؂�ւ��x��
(setq iswitchb-mode t)

;; ���[�h���C���ɃJ�[�\���ʒu�̍s���E�񐔂�\��
(line-number-mode t)
(column-number-mode t)

;; ���[�h���C���ɓ��t������\��
(setq dayname-j-alist
      '(("Sun" . "��") ("Mon" . "��") ("Tue" . "��") ("Wed" . "��")
        ("Thu" . "��") ("Fri" . "��") ("Sat" . "�y")))
(setq display-time-string-forms
      '((format "%s��%s��(%s) %s:%s"
                month day (cdr (assoc dayname dayname-j-alist))
                24-hours minutes load)))
(display-time-mode t)

;; ����t�@�C�����̎��C�f�B���N�g���������ɕ\��
(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)
(setq uniquify-ignore-buffers-re "*[^*]+*")

;; �t�@�C�����̕⊮�ő啶������������ʂ��Ȃ�
(setq completion-ignore-case t)

;; �t�@�C���̐擪��#!�Ŏn�܂�ꍇ�A���s�������ĕۑ�����
(add-hook 'after-save-hook
          'executable-make-buffer-file-executable-if-script-p)

;; *.~ *#�Ȃǂ̃o�b�N�A�b�v�t�@�C�������Ȃ�
(setq make-backup-files nil)
(setq auto-save-default nil)

;; �^�C���X�^���v�ݒ�
(if (not (memq 'time-stamp write-file-hooks))
 (setq write-file-hooks
    (cons 'time-stamp write-file-hooks)))
(setq time-stamp-start "Last-Updated: [ \t]*<")
(setq time-stamp-end ">")

;; �u��������̑啶���ϊ��������Ȃ�Ȃ�
(setq case-replace nil)

;; ���s������
(setq run-w32     (equal system-type 'windows-nt)
      run-linux   (equal system-type 'gnu/linux)
      run-darwin  (equal system-type 'darwin))

;; dired
(require 'dired)
(setq ls-lisp-dirs-first t)
(setq find-ls-option '("-exec ls -AFGl {} \\;" . "-AFGl"))
(setq grep-find-command "find . -type f -print0 | xargs -0 -e grep -ns ")

;; RET���ɐV�����o�b�t�@���쐬���Ȃ�
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

;; ���{����ݒ�
(set-language-environment "Japanese")

;; �o�b�t�@�̕����R�[�h
(setq default-buffer-file-coding-system 'utf-8)

;; �Ή����銇�ʂ����点��
(show-paren-mode t)

;; �n�C���C�g
(transient-mark-mode t)           ; �I�𕔕�
(setq search-highlight t)         ; �����P��
(setq query-replace-highlight t)  ; �u���P��

;; �o�b�t�@���^�u�\������
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

      ;; ���j���[�o�[�\��
      (menu-bar-mode t)

      ;; �X�N���[���o�[�\��
      (scroll-bar-mode t)

      ;; �c�[���o�[�\��
      (tool-bar-mode 0)

      ;; �󔒕����ƃ^�u�ɐF������
      (defface my-face-b-1
        '((t (:background "SlateGray1"))) nil)
      (defface my-face-b-2
        '((t (:background "rgb:E000/E000/E000"))) nil)
      (defface my-face-u-1
        '((t (:foreground "SteelBlue" :underline t))) nil)
      (defvar my-face-b-1 'my-face-b-1)   ; �S�p�X�y�[�X
      (defvar my-face-b-2 'my-face-b-2)   ; �^�u
      (defvar my-face-u-1 'my-face-u-1)   ; �s���̋�
      (defadvice font-lock-mode (before my-font-lock-mode ())
        (font-lock-add-keywords
         major-mode
         '(("\t" 0 my-face-b-2 append)
           ("�@" 0 my-face-b-1 append)
           ("[ \t]+$" 0 my-face-u-1 append)
           )))
      (ad-enable-advice 'font-lock-mode 'before 'my-font-lock-mode)
      (ad-activate 'font-lock-mode)

      ;; �E�B���h�E�Ԃ� Shift+ <�J�[�\���L�[> �ňړ�
      (windmove-default-keybindings)

      ;; Windows
      (when run-w32
        (set-face-attribute 'default nil :family "�l�r �S�V�b�N" :height 120))

      ;; Mac
      (when run-darwin
        (setq mac-allow-anti-aliasing t)
        (set-face-attribute 'default nil :family "�l�r �S�V�b�N" :height 160))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; �v���O���~���O
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; �g���q�ƃ��W���[���[�h�̑Ή��t��
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
;;; �L�[�o�C���h
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(global-set-key "\C-h" 'backward-delete-char)      ; �o�b�N�X�y�[�X
(global-set-key "\C-j" 'dabbrev-expand)            ; ���͕⊮
(global-set-key "\C-c\C-r" 'revert-buffer)         ; revert-buffer

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; �V�F��
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq shell-file-name (executable-find "bash"))
(setenv "SHELL" shell-file-name)
(setq explicit-shell-file-name shell-file-name)
(add-hook 'shell-mode-hook
          '(lambda ()
             ;; �L�[�o�C���h
             (local-set-key "\C-cl" 'erase-buffer)
             ;; �s���̋󔒂Ȃǂ̓n�C���C�g���Ȃ�
             (ad-deactivate 'font-lock-mode)
             ;; Bash�⊮��L���ɂ���
             (require 'bash-completion)
             (bash-completion-setup)))

