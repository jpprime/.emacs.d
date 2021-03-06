;;; bindings-evil.el --- Evil bindings -*- lexical-bindings: t; -*-

;; Author: João Pedro de Amorim Paula <maybe_add_email@later>

;;; Commentary:
;;
;; This was mostly done by Bailey Ling. You can find all of Bailey Lings' Emacs
;; configuration in https://github.com/bling/dotemacs.
;;
;;; Code:
(after 'evil
  ;;; minibuffer maps
  ;; make ex completion behave more like emacs state
  (bindings-define-keys evil-ex-completion-map
    ((kbd "C-f") #'forward-char)
    ((kbd "C-b") #'backward-char)
    ((kbd "C-a") #'move-beginning-of-line)
    ((kbd "C-d") #'delete-forward-char)
    ((kbd "C-k") #'kill-line)
    ((kbd "C-u") #'universal-argument)
    ((kbd "C-w") #'kill-region))

  ;;; normal state maps
  (bindings-define-keys evil-normal-state-map
    ((kbd "C-t") nil)        ; evil rebinds this and i want the default behavior
    ("[ " (bind (save-excursion (evil-insert-newline-above))) "new line up")
    ("] " (bind (save-excursion (evil-insert-newline-below))) "new line down"))

  ;;; normal, visual and motion state bindings
  (evil-define-key '(normal visual motion) 'global
    " " bindings-space-map
    " w" evil-window-map
    "[b" #'previous-buffer
    "]b" #'next-buffer
    "Y" "y$"
    "K" #'evil-lookup
    "gI" #'imenu
    (kbd "M-.") #'xref-find-definitions ; evil overrides this
    (kbd "M-?") #'xref-find-references  ; and this
    "gd" #'xref-find-definitions
    (kbd "C-]") #'xref-find-definitions)

  ;;; normal and visual state bindings
  (evil-define-key '(normal visual) 'global
    "gA" #'align-regexp
    "[e" #'previous-error
    "]e" #'next-error)

  (after 'config-utils
    (evil-define-key '(normal visual) 'global
      "gR" #'utils-rename-current-buffer-file))

  ;;; misc
  (defun evil-mouse-yank-primary ()
    "Insert the contents of primary selection into the location
of point."
    (interactive)
    (let ((default-mouse-yank-at-point (symbol-value mouse-yank-at-point)))
      (setvar 'mouse-yank-at-point t)
      (mouse-yank-primary nil)
      (setvar 'mouse-yank-at-point default-mouse-yank-at-point)))

  (evil-define-key '(insert normal visual) 'global
    (kbd "<S-insert>") #'evil-mouse-yank-primary)

  ;;; third party
  (after 'evil-commentary
    (bindings-define-keys evil-commentary-mode-map
      ((kbd "s-/") nil)
      ((kbd "C-M-;") #'evil-commentary-line))))

(provide 'config-bindings-evil)
;;; bindings-evil.el ends here
