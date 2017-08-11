(setq mac-option-modifier 'meta)
(setq mac-command-modifier 'super)
(global-unset-key (kbd "C-j"))
(global-set-key (kbd "C-j") 'avy-goto-word-or-subword-1)


(when (maybe-require-package 'git-gutter+)
  (global-git-gutter+-mode +1)
  )

(when (maybe-require-package 'avy)

  )

; gtags
(when (maybe-require-package 'gtags)
  (add-hook 'c-mode-common-hook
          (lambda ()
            (when (derived-mode-p 'c-mode 'c++-mode 'java-mode)
              (ggtags-mode 1))))

  (add-hook 'php-mode-common-hook
          (lambda ()
            (when (derived-mode-p 'php-mode)
              (ggtags-mode 1))))

  )



; backup files
(setq backup-directory-alist `(("." . "/tmp/emacs-backup")))
(setq backup-by-copying t)
(setq delete-old-versions t
  kept-new-versions 6
  kept-old-versions 2
  version-control t)


(provide 'init-local)
