;;; config-eyecandy.el --- Some eyecandy -*- lexical-bindings: t; -*-

;; Author: João Pedro de Amorim Paula <maybe_add_email@later>

;;; Commentary:

;;; Code:
;; disable bars to have a as clean as possible interface
(when (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(when (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
;; (unless (display-graphic-p) (menu-bar-mode -1)) ; enable in GUI Emacs
(when (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(when (fboundp 'horizontal-scroll-bar-mode) (horizontal-scroll-bar-mode -1))

;;; color theme
;; the theme i'm using. if it needs download, it goes here
;; (require-package 'solarized-theme)
;; (setvar 'solarized-high-contrast-mode-line t) ; make the modeline high contrast
;; (setvar 'solarized-use-more-italic t)         ; use more italics
;; (setvar 'solarized-use-variable-pitch nil)    ; all fonts monospaced?
;; (setvar 'solarized-scale-org-headlines nil)   ; don't scale org headings
;; (setvar 'solarized-scale-outline-headlines nil) ; don't scale outline headings
;; ;; avoid all font-size changes
;; (setvar 'solarized-height-minus-1 1.0)
;; (setvar 'solarized-height-plus-1 1.0)
;; (setvar 'solarized-height-plus-2 1.0)
;; (setvar 'solarized-height-plus-3 1.0)
;; (setvar 'solarized-height-plus-4 1.0)
(load-theme 'misterioso t)
;; make fringe same background color as line-number face
(when (version<= "26" emacs-version)
  (set-face-background 'fringe (face-background 'line-number)))

;; disable the bigger scale on bold function fonts (manoj-dark & misterioso)
(set-face-attribute 'font-lock-function-name-face nil :height 1.0)

;; make comments DimGrey (manoj-dark and default)
;; (set-face-foreground 'font-lock-comment-face "DimGrey")
;; (set-face-foreground 'font-lock-comment-delimiter-face "DimGrey")

;; make comment grey60 (misterioso)
(set-face-foreground 'font-lock-comment-face "grey60")
(set-face-foreground 'font-lock-comment-delimiter-face "grey60")

;; change mode-line's face (manoj-dark)
;; (set-face-attribute 'mode-line nil :height 1.0 :underline nil) ;
;; (set-face-attribute 'mode-line-buffer-id nil :height 1.0)
;; (set-face-attribute 'mode-line-inactive nil :height 1.0)

;; some customizations to the color of matching parenthesis
(after 'paren
  (set-face-foreground 'show-paren-match (face-background 'default))
  (set-face-background 'show-paren-match (face-foreground 'default)))

;; some customizations to the color of whitespace
(after 'whitespace
  (set-face-attribute 'whitespace-line nil
                      :background "grey30"
                      :foreground nil)) ; keep syntax highlighting

;; some customizations to the color of the highlighted line
(after 'hl-line
  ;; keep colors when on `hl-line'
  (set-face-attribute 'hl-line nil
                      :inherit nil
                      :background (face-background 'highlight)))

;; i don't like these defaults because of colorblindness (mostly lsp)
(set-face-foreground 'error "OrangeRed")
;; manoj-dark
;; (set-face-foreground 'warning "blue")
;; (set-face-foreground 'success "DarkGreen")
;; misterioso
(set-face-foreground 'warning "DeepSkyBlue")
(set-face-foreground 'success "YellowGreen")

;; a custom theme to run on top of the other custom themes loaded (so it should
;; be here, after (load-theme 'blah)) that shows the name of the host when in
;; using tramp in the modeline alongside the buffer name. see
;; `tramp-theme-face-remapping-alist' for customization options
(require-package 'tramp-theme)
(load-theme 'tramp t)

;;; default font
;; this is how it has to be set so it works on the daemon mode
;; or configure it on the XResources file
;; (add-to-list 'default-frame-alist '(font . "monospace-13"))
(set-frame-font "monospace-13")

;;; line numbers (only available in Emacs 26+)
(defconst eyecandy-line-numbers-disabled-hooks
  '(eshell-mode-hook
    woman-mode-hook
    man-mode-hook
    helpful-mode-hook
    help-mode-hook
    treemacs-mode-hook
    dired-mode-hook
    term-mode-hook
    doc-view-mode-hook
    pdf-view-mode-hook
    lsp-ui-doc-frame-mode-hook
    lsp-ui-imenu-mode-hook
    magit-status-mode-hook
    org-agenda-mode-hook
    man-mode-hook
    pomidor-mode-hook
    proof-goals-mode-hook
    proof-response-mode-hook)
  "Modes to disable `display-line-numbers-mode'.")

(when (fboundp 'display-line-numbers-mode)
  (setvar 'display-line-numbers t)
  (setvar 'display-line-numbers-current-absolute t)

  (dolist (hook eyecandy-line-numbers-disabled-hooks)
    (add-hook hook (lambda ()
                     "Disable `display-line-numbers-mode'."
                     (display-line-numbers-mode -1)))))

;;; hl-line
(defconst eyecandy-hl-line-enabled-hooks
  '(treemacs-mode-hook
    dired-mode-hook
    org-agenda-mode-hook
    package-menu-mode-hook
    profiler-report-mode-hook
    ibuffer-mode-hook)
  "Modes to enable `hl-line-mode'.")

(dolist (hook eyecandy-hl-line-enabled-hooks)
  (add-hook hook (lambda ()
                   "Enable `hl-line-mode'."
                   (hl-line-mode t))))
;;; whitespace
(setvar 'whitespace-style '(face trailing tabs tab-mark lines-tail empty))

;; I don't enable `global-whitespace-mode' because there are non file modes,
;; like `dired', in which I don't want it activated
(add-hook 'prog-mode-hook #'whitespace-mode)
(add-hook 'text-mode-hook #'whitespace-mode)

;; ws-butler is a better way to delete trailing whitespace, it deletes
;; whitespace only on the lines that have been changed. that avoids having
;; commits and such with a bunch of changes that are only whitespace removal.
;; keep the whitespace littered code of other they way they intended, ugly...
;; it only clean whitespace when saving, like the old hook we had
(require-package 'ws-butler)
(ws-butler-global-mode)

;;; misc
(setvar 'x-underline-at-descent-line t)       ; underline below font baseline

;; if using git, strip the backend string from the mode line
(setcdr (assq 'vc-mode mode-line-format)
        '((:eval (replace-regexp-in-string "^ Git" " " vc-mode))))

;; stop blinking cursor
(blink-cursor-mode -1)

;; modeline indicators
(line-number-mode t)
(column-number-mode t)
(size-indication-mode t)

;; hide all minor modes from mode line (not needed with doom-modeline)
(require-package 'rich-minority)
(rich-minority-mode t)
;; TODO: make it so that flycheck only displays erros and warnings without the
;; FlyC text and make a better way to display LSP information without the
;; obnoxious [Disconnected] or [blablabla_server:123412]
;; only show lsp and flycheck on mode line
(setvar 'rm-whitelist (format "^ \\(%s\\)$"
                              (mapconcat #'identity
                                         '("FlyC.*" "LSP.*")
                                         "\\|")))

;; highlight TODO
(require-package 'hl-todo)
(global-hl-todo-mode t)

;; make treemacs a little bit better
(after 'treemacs
  (set-face-attribute 'treemacs-directory-collapsed-face nil :font "Sans Serif")
  (set-face-attribute 'treemacs-directory-face nil :font "Sans Serif")
  (set-face-attribute 'treemacs-file-face nil :font "Sans Serif")
  (set-face-attribute 'treemacs-fringe-indicator-face nil :font "Sans Serif")
  (set-face-attribute 'treemacs-git-added-face nil :font "Sans Serif")
  (set-face-attribute 'treemacs-git-conflict-face nil :font "Sans Serif")
  (set-face-attribute 'treemacs-git-ignored-face nil :font "Sans Serif")
  (set-face-attribute 'treemacs-git-modified-face nil :font "Sans Serif")
  (set-face-attribute 'treemacs-git-renamed-face nil :font "Sans Serif")
  (set-face-attribute 'treemacs-git-unmodified-face nil :font "Sans Serif")
  (set-face-attribute 'treemacs-git-untracked-face nil :font "Sans Serif")
  (set-face-attribute 'treemacs-help-column-face nil :font "Sans Serif")
  (set-face-attribute 'treemacs-help-title-face nil :font "Sans Serif")
  (set-face-attribute 'treemacs-on-failure-pulse-face nil :font "Sans Serif")
  (set-face-attribute 'treemacs-on-success-pulse-face nil :font "Sans Serif")
  (set-face-attribute 'treemacs-root-face nil :font "Sans Serif" :height 1.2)
  (set-face-attribute 'treemacs-root-remote-disconnected-face nil :font "Sans Serif")
  (set-face-attribute 'treemacs-root-remote-face nil :font "Sans Serif")
  (set-face-attribute 'treemacs-root-remote-unreadable-face nil :font "Sans Serif")
  (set-face-attribute 'treemacs-root-unreadable-face nil :font "Sans Serif")
  (set-face-attribute 'treemacs-tags-face nil :font "Sans Serif")
  (set-face-attribute 'treemacs-term-node-face nil :font "Sans Serif"))

(provide 'config-eyecandy)
;;; config-eyecandy.el ends here
