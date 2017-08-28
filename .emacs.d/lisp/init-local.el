(setq mac-option-modifier 'meta)
(setq mac-command-modifier 'super)
(global-unset-key (kbd "C-j"))
(global-set-key (kbd "C-j") 'avy-goto-word-or-subword-1)


(global-set-key (kbd "C-?") 'help-command)
(global-set-key (kbd "M-?") 'mark-paragraph)
(global-set-key (kbd "C-h") 'delete-backward-char)
(global-set-key (kbd "M-h") 'backward-kill-word)


(when (maybe-require-package 'git-gutter+)
  (global-git-gutter+-mode +1)
  )

(when (maybe-require-package 'avy)

  )

(when (maybe-require-package 'emmet-mode)
)



(when (maybe-require-package 'js2-mode)

  (setq js2-strict-missing-semi-warning nil)
  )


(when (maybe-require-package 'web-mode)
  (setq web-mode-enable-css-colorization t)
  )


(with-eval-after-load 'flycheck
  (flycheck-add-mode 'css-csslint 'web-mode)
  (flycheck-add-mode 'javascript-eslint 'web-mode)
  ;(flycheck-add-mode 'javascript-eslint 'js2-mode)
    '(progn
      (set-face-attribute 'flycheck-error nil :foreground "pink"))
  )


; gtags
(when (maybe-require-package 'ggtags)
  (add-hook 'c-mode-common-hook
            (lambda ()
              (when (derived-mode-p 'c-mode 'c++-mode 'java-mode)
                (ggtags-mode 1))))

  (add-hook 'php-mode-common-hook
            (lambda ()
              (when (derived-mode-p 'php-mode)
                (ggtags-mode 1))))
  )




(add-to-list 'auto-mode-alist '("\\.vue?\\'" . web-mode))

(defun my-setup-indent (n)
  ;; java/c/c++
  ;;(setq c-basic-offset n)
  ;; web development
  (setq coffee-tab-width n) ; coffeescript
  (setq javascript-indent-level n) ; javascript-mode
  (setq js-indent-level n) ; js-mode
  (setq js2-basic-offset n) ; js2-mode, in latest js2-mode, it's alias of js-indent-level
  (setq web-mode-markup-indent-offset n) ; web-mode, html tag in html file
  (setq web-mode-css-indent-offset n) ; web-mode, css in html file
  (setq web-mode-code-indent-offset n) ; web-mode, js code in html file
  (setq web-mode-attr-indent-offset n) ; web-mode, attributes
  (setq web-mode-style-padding n)
  (setq web-mode-script-padding n)
  (setq web-mode-block-padding n)
  (setq web-mode-comment-style n)
  (setq css-indent-offset n) ; css-mode
  )

(my-setup-indent 2)



; http://codewinds.com/blog/2015-04-02-emacs-flycheck-eslint-jsx.html#summary
(defun my/use-eslint-from-node-modules ()
  (let* ((root (locate-dominating-file
                (or (buffer-file-name) default-directory)
                "node_modules"))
         (eslint (and root
                      (expand-file-name "node_modules/eslint/bin/eslint.js"
                                        root))))
    (when (and eslint (file-executable-p eslint))
      (setq-local flycheck-javascript-eslint-executable eslint))))
(add-hook 'flycheck-mode-hook #'my/use-eslint-from-node-modules)


                                        ; backup files
(setq backup-directory-alist `(("." . "/tmp/emacs-backup")))
(setq backup-by-copying t)
(setq delete-old-versions t
  kept-new-versions 6
  kept-old-versions 2
  version-control t)


(provide 'init-local)
