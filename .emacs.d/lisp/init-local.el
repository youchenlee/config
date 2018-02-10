;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; avy-goto-word
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(global-unset-key (kbd "C-j"))
(when (maybe-require-package 'avy)
  (global-set-key (kbd "C-j") 'avy-goto-word-or-subword-1)
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; grep
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq grep-command "grep --color -nH -e -i ") ; default "grep --color -nH -e "
(setq counsel-grep-base-command "rg -i -M 120 --no-heading --line-number --color never %s %s") ; default: "grep -E -n -e %s %s "

;;;;;;;;;;;;;;;;;;;;;;;;
;; Mac
;;;;;;;;;;;;;;;;;;;;;;;;
(when (eq system-type 'darwin)  ; mac specific bindings
  (setq mac-right-command-modifier 'control)
  (setq mac-option-modifier 'meta)
  (setq mac-command-modifier 'super)
  )

;;;;;;;;;;;;;;;;;;;;;;;;
;; Common key binding
;;;;;;;;;;;;;;;;;;;;;;;;
(global-set-key (kbd "C-?") 'help-command)
(global-set-key (kbd "M-?") 'mark-paragraph)
(global-set-key (kbd "C-h") 'delete-backward-char)
(global-set-key (kbd "M-h") 'backward-kill-word)


;;;;;;;;;;;;;;;;;;;;;;;;;
;; Gutter (fridge)
;;;;;;;;;;;;;;;;;;;;;;;;
(when (maybe-require-package 'git-gutter+)
  (global-git-gutter+-mode +1)
  )


;;;;;;;;;;;;;;;;;;;;;;;;;
;; Emmet
;;;;;;;;;;;;;;;;;;;;;;;;
(when (maybe-require-package 'emmet-mode)
  )

;;;;;;;;;;;;;;;;;;;;;;;;
;; Folding
;;;;;;;;;;;;;;;;;;;;;;;;
(when (maybe-require-package 'yafolding)
  (global-set-key (kbd "<C-M-return>") 'yafolding-toggle-all)
  (global-set-key (kbd "<C-S-return>") 'yafolding-hide-parent-element)
  (global-set-key (kbd "<C-return>") 'yafolding-toggle-element)
  )


;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; JS2
;;;;;;;;;;;;;;;;;;;;;;;;;;;
(when (maybe-require-package 'js2-mode)
  (setq js2-strict-missing-semi-warning nil)
  )


;;;;;;;;;;;;;;;;;;;;;;;;
;; CSS
;;;;;;;;;;;;;;;;;;;;;;;;;
(when (maybe-require-package 'web-mode)
  (setq web-mode-enable-css-colorization t)
  )



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; gtags
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; php
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-hook 'php-mode-hook (lambda ()
                           (flycheck-select-checker 'php)
                           (c-set-style "psr2") ; Works
                           ))


;;;;;;;;;;;;;;;;;;;;;;;;;
;; yas
;;;;;;;;;;;;;;;;;;;;;;;;
(require 'yasnippet)
(yas-global-mode 1)

;;;;;;;;;;;;;;;;;;;;;;;;
;; Vue
;;;;;;;;;;;;;;;;;;;;;;;;
(add-to-list 'auto-mode-alist '("\\.vue?\\'" . web-mode))

;;;;;;;;;;;;;;;;;;;;;;;
;; Web Indent
;;;;;;;;;;;;;;;;;;;;;;;
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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; eslint
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; http://codewinds.com/blog/2015-04-02-emacs-flycheck-eslint-jsx.html#summary
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

(with-eval-after-load 'flycheck
  (flycheck-add-mode 'css-csslint 'web-mode)
  (flycheck-add-mode 'javascript-eslint 'web-mode)
  ;;(flycheck-add-mode 'javascript-eslint 'js2-mode)
  '(progn
     (set-face-attribute 'flycheck-error nil :foreground "pink"))
  )

;;;;;;;;;;;;;;;;;;;;;;;
;; backup files
;;;;;;;;;;;;;;;;;;;;;;;
(setq backup-directory-alist `(("." . "/tmp/emacs-backup")))
(setq backup-by-copying t)
(setq delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t)


;;;;;;;;;;;;;;;;;;;;;
;; Run current file
;;;;;;;;;;;;;;;;;;;;;
(defun xah-run-current-file ()
  "Execute the current file.
For example, if the current buffer is x.py, then it'll call 「python x.py」 in a shell. Output is printed to message buffer.
The file can be Emacs Lisp, PHP, Perl, Python, Ruby, JavaScript, TypeScript, Bash, Ocaml, Visual Basic, TeX, Java, Clojure.
File suffix is used to determine what program to run.

If the file is modified or not saved, save it automatically before run.

URL `http://ergoemacs.org/emacs/elisp_run_current_file.html'
Version 2017-02-10"
  (interactive)
  (let (
        (-suffix-map
         ;; (‹extension› . ‹shell program name›)
         `(
           ("php" . "php")
           ("pl" . "perl")
           ("py" . "python")
           ("py3" . ,(if (string-equal system-type "windows-nt") "c:/Python32/python.exe" "python3"))
           ("rb" . "ruby")
           ("go" . "go run")
           ("js" . "node") ; node.js
           ("ts" . "tsc --alwaysStrict --lib DOM,ES2015,DOM.Iterable,ScriptHost --target ES5") ; TypeScript
           ("sh" . "bash")
           ("clj" . "java -cp /home/xah/apps/clojure-1.6.0/clojure-1.6.0.jar clojure.main")
           ("rkt" . "racket")
           ("ml" . "ocaml")
           ("vbs" . "cscript")
           ("tex" . "pdflatex")
           ("latex" . "pdflatex")
           ("java" . "javac")
           ;; ("pov" . "/usr/local/bin/povray +R2 +A0.1 +J1.2 +Am2 +Q9 +H480 +W640")
           ))
        -fname
        -fSuffix
        -prog-name
        -cmd-str)
    (when (not (buffer-file-name)) (save-buffer))
    (when (buffer-modified-p) (save-buffer))
    (setq -fname (buffer-file-name))
    (setq -fSuffix (file-name-extension -fname))
    (setq -prog-name (cdr (assoc -fSuffix -suffix-map)))
    (setq -cmd-str (concat -prog-name " \""   -fname "\""))
    (cond
     ((string-equal -fSuffix "el") (load -fname))
     ((string-equal -fSuffix "java")
      (progn
        (shell-command -cmd-str "*xah-run-current-file output*" )
        (shell-command
         (format "java %s" (file-name-sans-extension (file-name-nondirectory -fname))))))
     (t (if -prog-name
            (progn
              (message "Running…")
              (shell-command -cmd-str "*xah-run-current-file output*" ))
          (message "No recognized program file suffix for this file."))))))

(global-set-key (kbd "<f8>") 'xah-run-current-file)

;;;;;;;;;;;;;;;;;;;;;;;;
;; org
;;;;;;;;;;;;;;;;;;;;;;;;
(setq org-enforce-todo-dependencies t)
(setq org-agenda-include-diary t)
(setq org-agenda-start-day "-1d")
(setq org-agenda-span 30)
(setq org-agenda-start-on-weekday nil)

(setq org-directory "~/Dropbox/Apps/MobileOrg.bak2")
;;(setq org-mobile-directory "~/Dropbox/Apps/MobileOrg.bak2")
;;(setq org-mobile-inbox-for-pull "~/Dropbox/Apps/MobileOrg.bak2/mobileorg.org")

(setq org-default-notes-file (concat org-directory "/mobileorg.org"))
(define-key global-map "\C-co" 'org-capture)


(add-hook 'org-mode-hook
          (lambda ()
            (local-set-key "\C-j" 'avy-goto-word-or-subword-1)
            )
          )


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; markdown
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq markdown-open-command "/Users/copyleft/config/bin/mark")


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ivy
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(when (maybe-require-package 'rg)
  (setq ivy-use-virtual-buffers t)
  (setq enable-recursive-minibuffers t)
  (global-set-key "\C-s" 'counsel-grep-or-swiper)
  (global-set-key (kbd "C-c C-r") 'ivy-resume)
  (global-set-key (kbd "<f6>") 'ivy-resume)
  (global-set-key (kbd "M-x") 'counsel-M-x)
  (global-set-key (kbd "C-x C-f") 'counsel-find-file)
  (global-set-key (kbd "<f1> f") 'counsel-describe-function)
  (global-set-key (kbd "<f1> v") 'counsel-describe-variable)
  (global-set-key (kbd "<f1> l") 'counsel-find-library)
  (global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
  (global-set-key (kbd "<f2> u") 'counsel-unicode-char)
  (global-set-key (kbd "C-c g") 'counsel-git)
  (global-set-key (kbd "C-c j") 'counsel-git-grep)
  (global-set-key (kbd "C-c k") 'counsel-rg)
  (global-set-key (kbd "C-x l") 'counsel-locate)
  (global-set-key (kbd "C-S-o") 'counsel-rhythmbox)
  (define-key read-expression-map (kbd "C-r") 'counsel-expression-history)
  )

;;;;;;;;;;;;;;;;;;;;;;
;; ripgrep
;;;;;;;;;;;;;;;;;;;;;;
(when (maybe-require-package 'rg)
  (rg-enable-default-bindings "\C-c s")
  )

(provide 'init-local)
;;; init-local.el ends here
