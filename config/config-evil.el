;;; config-evil.el --- Evil-mode config file

;; Author: João Pedro de Amorim Paula <maybe_add_email@later>

;;; Commentary:

;;; Code:
(defvar dotemacs-evil/emacs-state-hooks
  '(org-log-buffer-setup-hook
    org-capture-mode-hook)
  "List of hooks to automatically start up in Evil Emacs state.")

(defvar dotemacs-evil/emacs-state-major-modes
  '(ibuffer-mode
    bookmark-bmenu-mode
    calculator-mode
    makey-key-mode
    dired-mode
    compilation-mode
    package-menu-mode
    treemacs-mode)
  "List of major modes that should default to Emacs state.")

(defvar dotemacs-evil/emacs-state-minor-modes
  '(magit-blame-mode)
  "List of minor modes that when active should switch to Emacs state.")

(defvar dotemacs-evil/insert-state-minor-modes
  '(git-commit-mode)
  "List of minor modes that when active should switch to Insert state.")

(defvar dotemacs-evil/insert-state-major-modes nil
  "List of major modes that when active should switch to Insert state.")

(defvar dotemacs-evil/emacs-insert-mode nil
  "If non-nil, insert mode will act as Emacs state.")

;;; variables
(setvar evil-search-module 'evil-search) ; emulate vim's search
(setvar evil-magic t)                    ; vim's magicness (for 'evil-search)
(setvar evil-shift-width 4)              ; offset of < and >
(setvar evil-regexp-search t)
(setvar evil-search-wrap t)
(setvar evil-want-C-i-jump t)
(setvar evil-want-C-u-scroll t)
(setvar evil-want-fine-undo nil)
(setvar evil-want-integration t)
(setvar evil-want-keybinding nil)
;; (setvar evil-want-abbrev-expand-on-insert-exit nil)
(setvar evil-vsplit-window-right t)
(setvar evil-split-window-below t)
(setvar evil-ex-search-vim-style-regexp t)
;; move evil tag to beginning of modeline
(setvar evil-mode-line-format '(before . mode-line-front-space))

(setvar evil-emacs-state-cursor    '("red" box))
(setvar evil-motion-state-cursor   '("white" box))
(setvar evil-normal-state-cursor   '("magenta" box))
(setvar evil-visual-state-cursor   '("orange" box))
(setvar evil-insert-state-cursor   '("red" bar))
(setvar evil-replace-state-cursor  '("red" hbar))
(setvar evil-operator-state-cursor '("magenta" hollow))

;; recenter after any jump in evil-mode
(add-hook 'evil-jumps-post-jump-hook #'recenter)

;; load `evil'
(require-package 'evil)
(evil-mode 1)

;; load `evil-collection'
;; (require-package 'evil-collection)
;; (evil-collection-init)

;; emacs state in minor modes
(dolist (mode dotemacs-evil/emacs-state-minor-modes)
  (let ((hook (concat (symbol-name mode) "-hook")))
    (add-hook (intern hook) `(lambda ()
                               "Start mode in emacs state."
                               (if ,mode
                                   (evil-emacs-state)
                                 (evil-normal-state))))))

;; insert state in major modes
(dolist (mode dotemacs-evil/insert-state-minor-modes)
  (let ((hook (concat (symbol-name mode) "-hook")))
    (add-hook (intern hook) `(lambda ()
                               "Start mode in insert state."
                               (if ,mode
                                   (evil-insert-state)
                                 (evil-normal-state))))))

;; emacs state hooks
(dolist (hook dotemacs-evil/emacs-state-hooks)
  (add-hook hook #'evil-emacs-state))

;; emacs state in major modes
(dolist (mode dotemacs-evil/emacs-state-major-modes)
  (evil-set-initial-state mode 'emacs))

;; insert state in major modes
(dolist (mode dotemacs-evil/insert-state-major-modes)
  (evil-set-initial-state mode 'insert))

;; change the modeline tag for each state
(evil-put-property 'evil-state-properties 'normal   :tag " NORMAL ")
(evil-put-property 'evil-state-properties 'insert   :tag " INSERT ")
(evil-put-property 'evil-state-properties 'visual   :tag " VISUAL ")
(evil-put-property 'evil-state-properties 'motion   :tag " MOTION ")
(evil-put-property 'evil-state-properties 'emacs    :tag " EMACS ")
(evil-put-property 'evil-state-properties 'replace  :tag " REPLACE ")
(evil-put-property 'evil-state-properties 'operator :tag " OPERATOR ")

(when dotemacs-evil/emacs-insert-mode
  (defalias 'evil-insert-state 'evil-emacs-state)
  (/bindings/define-key evil-emacs-state-map
    (kbd "<escape>") #'evil-normal-state))

(unless (display-graphic-p)
  (evil-esc-mode 1))

(after 'magit
  (require-package 'evil-magit)
  (evil-magit-init))

(after 'org
  (require-package 'evil-org)
  (add-hook 'org-mode-hook 'evil-org-mode)
  (after 'evil-org
    (evil-org-set-key-theme
     '(navigation insert textobjects additional calendar))
    (after 'evil-org-agenda
      (evil-org-agenda-set-keys))))

;; match tags like <b> in html or \begin{env} in LaTeX
(require-package 'evil-matchit)
(global-evil-matchit-mode t)

;; add a new text object for surrounding characters like (), {}, "", ...
(require-package 'evil-surround)
(global-evil-surround-mode)

(add-hook 'emacs-lisp-mode-hook         ; add a new surround in `elisp-mode'
          (lambda ()
            (push '(?` . ("`" . "'")) evil-surround-pairs-alist)))

;; add new surroundings in `LaTeX-mode' and `TeX-mode'
(add-hook 'LaTeX-mode-hook
          (lambda ()
            (push '(?` . ("`" . "'")) evil-surround-pairs-alist)
            (push '(?~ . ("``" . "''")) evil-surround-pairs-alist)))
(add-hook 'TeX-mode-hook
          (lambda ()
            (push '(?` . ("`" . "'")) evil-surround-pairs-alist)
            (push '(?~ . ("``" . "''")) evil-surround-pairs-alist)))

;; increment and decrement numbers with a shortcut like in Vim
(require-package 'evil-numbers)
(/bindings/define-keys evil-normal-state-map
  ((kbd "M-+") #'evil-numbers/inc-at-pt)
  ((kbd "M-_") #'evil-numbers/dec-at-pt))

(defadvice evil-ex-search-next (after dotemacs activate)
  "Recenter after going to the next result of a ex search."
  (recenter))

(defadvice evil-ex-search-previous (after dotemacs activate)
  "Recenter after going to the previous result of a ex search."
  (recenter))

;; bindings
;; normal and visual state bindings
(evil-define-key '(normal visual) 'global
  "Y" "y$"
  "gC" #'compile
  "gc" #'recompile
  "gA" #'align-regexp)

(defun /evil/mouse-yank-primary ()
  "Insert the contents of primary selection into the location of point."
  (interactive)
  (let ((default-mouse-yank-at-point (symbol-value mouse-yank-at-point)))
    (setvar mouse-yank-at-point t)
    (mouse-yank-primary nil)
    (setvar mouse-yank-at-point default-mouse-yank-at-point)))

(evil-define-key '(insert normal visual) 'global
  (kbd "<S-insert>") #'/evil/mouse-yank-primary)

(provide 'config-evil)
;;; config-evil.el ends here