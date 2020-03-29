;;; config-flycheck.el --- Flycheck configuration

;; Author: João Pedro de Amorim Paula <maybe_add_email@later>

;;; Commentary:

;;; Code:
;; install flycheck
(require-package 'flycheck)

(when (display-graphic-p)
  (after 'flycheck
    ;; show the error on a bellow it instead of on the minibuffer
    (require-package 'flycheck-inline)
    (global-flycheck-inline-mode)))

(setvar 'flycheck-display-errors-function ; only display errors if the error
        #'flycheck-display-error-messages-unless-error-list) ; list is not on
(setvar 'flycheck-indication-mode 'right-fringe) ; where to show the error

;; not really sure what this does
;; (after "web-mode-autoloads"
;;   (flycheck-add-mode 'javascript-eslint 'web-mode))

(add-hook 'after-init-hook #'global-flycheck-mode)

;; make emacs display the erros similar to IDE's
(add-to-list 'display-buffer-alist
             `(,(rx bos "*Flycheck errors*" eos)
               (display-buffer-reuse-window
                display-buffer-in-side-window)
               (side            . bottom)
               (reusable-frames . visible)
               (window-height   . 0.33)))

(provide 'config-flycheck)
;;; config-flycheck.el ends here