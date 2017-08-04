(setq mac-option-modifier 'meta)
(setq mac-command-modifier 'super)
(global-unset-key (kbd "C-j"))
(global-set-key (kbd "C-j") 'avy-goto-word-or-subword-1)

(when (maybe-require-package 'git-gutter+)
  (global-git-gutter+-mode +1)
  )

(when (maybe-require-package 'avy)

  )

(provide 'init-local)
