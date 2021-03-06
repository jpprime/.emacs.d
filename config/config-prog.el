;;; config-prog.el --- Prog mode configurations -*- lexical-bindings: t; -*-

;; Author: João Pedro de Amorim Paula <maybe_add_email@later>

;;; Commentary:
;;
;; General configurations for `prog-mode' and some modes that don't come pre
;; installed with Emacs, like `vimrc-mode'.
;;
;;; Code:
;;; infer indentation
(defun infer-indentation-style ()
  "Automatically infer if indentation is using spaces or tabs.

If the file has more tabs than (four) spaces, use tabs instead
for indentation. If it has more spaces, use spaces instead of
tabs."
  (interactive)
  (let ((space-count (how-many "^    " (point-min) (point-max)))
        (tab-count (how-many "^\t" (point-min) (point-max))))
    (when (> tab-count space-count)
      (setvar 'indent-tabs-mode t 'local))))
;; always infer-indentation on `prog-mode' files
(add-hook 'prog-mode-hook #'infer-indentation-style)

;;; enable tabs instead of spaces in makefiles
;; TODO: move this to config-makefile.el maybe???
(add-hook 'makefile-mode-hook (lambda () (setvar 'indent-tabs-mode t 'local)))

;;; folding
;; (add-hook 'prog-mode-hook #'hs-minor-mode)

(defun hs-fold-overlay (overlay)
  "Function set up the OVERLAY to be displayed by `hs-minor-mode'."
  (when (eq 'code (overlay-get overlay 'hs))
    (let ((col (save-excursion
                 (move-end-of-line 0)
                 (current-column)))
          (count (count-lines (overlay-start overlay) (overlay-end overlay))))
      (overlay-put overlay 'after-string
                   (format " [ %d lines ] "
                           ;; (make-string (- (window-width) col 16)
                           ;;              (string-to-char " "))
                           count)))))

(setvar 'hs-set-up-overlay #'hs-fold-overlay)

;;; bunch of modes that don't come with emacs and are not worth having a file
(lazy-major-mode "\\.toml\\'" 'toml-mode)
(lazy-major-mode "\\.yaml\\'" 'yaml-mode)
(lazy-major-mode "\\.exrc\\'" 'vimrc-mode)
(lazy-major-mode "[._]?g?vimrc\\'" 'vimrc-mode)
(lazy-major-mode "\\.vim\\'" 'vimrc-mode)
(lazy-major-mode "\\.lua\\'" 'lua-mode)
(lazy-major-mode "\\.csv\\'" 'csv-mode)
(lazy-major-mode "\\.?cron\\() (tab\\)?\\'" 'crontab-mode)
(lazy-major-mode "\\.js\\(?:on\\|[hl]int\\(?:rc\\)?\\)\\'" 'json-mode)


;;; aggressive indent
(defconst prog-aggressive-indent-modes
  '(c-mode
    cc-mode
    lisp-mode
    emacs-lisp-mode
    sh-mode
    java-mode
    python-mode
    makefile-mode)
  "Major modes to activate `aggressive-indent-mode'.")

(require-package 'aggressive-indent)
(add-hook-to-modes prog-aggressive-indent-modes #'aggressive-indent-mode)
;; add some commands that should not trigger aggressive indent
(after [aggressive-indent evil]
  (add-to-list 'aggressive-indent-protected-commands 'evil-undo t)
  (add-to-list 'aggressive-indent-protected-commands 'evil-redo t))
(after [aggressive-indent ws-butler]
  (add-to-list 'aggressive-indent-protected-commands 'ws-butler-before-save t)
  (add-to-list 'aggressive-indent-protected-commands 'ws-butler-after-save t)
  (add-to-list 'aggressive-indent-protected-commands 'ws-butler-before-revert t))

;;; rainbow mode (show background color for strings)
(require-package 'rainbow-mode)
(add-hook 'prog-mode-hook #'rainbow-mode)

(provide 'config-prog.el)
;;; config-prog.el ends here
