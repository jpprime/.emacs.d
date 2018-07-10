
(setq vc-make-backup-files t)

(when (executable-find "git")
  (require-package 'magit)

  (defun /vcs/magit-post-display-buffer-hook()
    (if (string-match "*magit:" (buffer-name))
        (delete-other-windows)))
  (add-hook 'magit-post-display-buffer-hook #'/vcs/magit-post-display-buffer-hook)

  (setq magit-section-show-child-count t)
  (setq magit-diff-arguments '("--histogram"))
  (setq magit-ediff-dwim-show-on-hunks t)
  (setq magit-display-buffer-function #'magit-display-buffer-fullcolumn-most-v1)

  (require-package 'magit-todos)
  (add-hook 'prog-mode-hook 'hl-todo-mode)
  (setq magit-todos-fontify-org nil)
  (when (executable-find "rg")
    (setq magit-todos-scanner 'magit-todos--scan-with-rg))
  (magit-todos-mode t))

(/boot/lazy-major-mode "^\\.gitignore$" gitignore-mode)
(/boot/lazy-major-mode "^\\.gitattributes$" gitattributes-mode)

(after [evil diff-mode]
  (evil-define-key 'normal diff-mode diff-mode-map
    "j" #'diff-hunk-next
    "k" #'diff-hunk-prev))
(after [evil vc-annotate]
  (evil-define-key 'normal vc-annotate-mode-map
    (kbd "M-p") #'vc-annotate-prev-revision
    (kbd "M-n") #'vc-annotate-next-revision
    "l" #'vc-annotate-show-log-revision-at-line))

(provide 'config-vcs)
