(add-to-list 'package-archives '("cselpa" . "https://elpa.thecybershadow.net/packages/"))
(when (maybe-require-package 'term-keys)
  (term-keys-mode t)
  )

(require 'term-keys-xterm)
(with-temp-buffer
    (insert (term-keys/xterm-script))
      (write-region (point-min) (point-max) "~/launch-xterm-with-term-keys.sh"))

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

;(require 'expand-region)
;(global-set-key (kbd "C-i") 'er/expand-region)


;; smart C-a
;; http://emacsredux.com/blog/2013/05/22/smarter-navigation-to-the-beginning-of-a-line/
(defun smarter-move-beginning-of-line (arg)
  "Move point back to indentation of beginning of line.

Move point to the first non-whitespace character on this line.
If point is already there, move to the beginning of the line.
Effectively toggle between the first non-whitespace character and
the beginning of the line.

If ARG is not nil or 1, move forward ARG - 1 lines first.  If
point reaches the beginning or end of the buffer, stop there."
  (interactive "^p")
  (setq arg (or arg 1))

  ;; Move lines first
  (when (/= arg 1)
    (let ((line-move-visual nil))
      (forward-line (1- arg))))

  (let ((orig-point (point)))
    (back-to-indentation)
    (when (= orig-point (point))
      (move-beginning-of-line 1))))

;; remap C-a to 'smarter-move-beginning-of-line'
(global-set-key [remap move-beginning-of-line]
                'smarter-move-beginning-of-line)


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
  (global-set-key (kbd "C-l") 'emmet-expand-yas)
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; avy-goto-word
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(global-unset-key (kbd "C-j"))
(when (maybe-require-package 'avy)
  (global-set-key (kbd "C-j") 'avy-goto-word-or-subword-1)
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
  (setq web-mode-script-padding 0)
  (setq web-mode-block-padding n)
  (setq web-mode-comment-style n)
  (setq css-indent-offset n) ; css-mode
  (setq typescript-indent-level 2) ; typescript-mode
  )

(my-setup-indent 4)


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
           ("pl6" . "perl6")
           ("p6" . "perl6")
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
           ("rs" . "cargo script")
           ("exs" . "elixir")
           ("ex" . "elixir")
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

;;(setq org-directory "~/Dropbox/Apps/MobileOrg.bak2")
;;(setq org-mobile-directory "~/Dropbox/Apps/MobileOrg.bak2")
;;(setq org-mobile-inbox-for-pull "~/Dropbox/Apps/MobileOrg.bak2/mobileorg.org")

;;(setq org-default-notes-file (concat org-directory "/mobileorg.org"))
;;(define-key global-map "\C-co" 'org-capture)


(add-hook 'org-mode-hook
          (lambda ()
            (local-set-key "\C-j" 'avy-goto-word-or-subword-1)
            )
          )

;; https://emacs.cafe/emacs/orgmode/gtd/2017/06/30/orgmode-gtd.html
(setq org-capture-templates '(("t" "Todo [inbox]" entry
                               (file+headline "~/Dropbox/org/inbox.org" "Tasks")
                               "* TODO %i%?")
                              ("T" "Tickler" entry
                               (file+headline "~/Dropbox/org/tickler.org" "Tickler")
                               "* %i%? \n %U")))

(setq org-refile-targets '(("~/Dropbox/org/gtd.org" :maxlevel . 3)
                           ("~/Dropbox/org/someday.org" :level . 1)
                           ("~/Dropbox/org/tickler.org" :maxlevel . 2)))

(setq org-agenda-custom-commands
      '(("o" "At the office" tags-todo "@coding"
         ((org-agenda-overriding-header "Coding")
          (org-agenda-skip-function #'my-org-agenda-skip-all-siblings-but-first)))))

(setq org-agenda-custom-commands
      '(("g" . "GTD contexts")
        ("go" "Office" search "@office")
        ("gc" "Coding" search "@coding")
        ("gp" "Plan" search "@plan")
        ("G" "GTD Block Agenda"
         ((search "@office")
          (search "@coding")
          (search "@plan"))
         nil                      ;; i.e., no local settings
         ("~/next-actions.html")) ;; exports block to this file with C-c a e
        ;; ..other commands here
        ))

(defun my-org-agenda-skip-all-siblings-but-first ()
  "Skip all but the first non-done entry."
  (let (should-skip-entry)
    (unless (org-current-is-todo)
      (setq should-skip-entry t))
    (save-excursion
      (while (and (not should-skip-entry) (org-goto-sibling t))
        (when (org-current-is-todo)
          (setq should-skip-entry t))))
    (when should-skip-entry
      (or (outline-next-heading)
          (goto-char (point-max))))))

(defun org-current-is-todo ()
  (string= "TODO" (org-get-todo-state)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; org-mode clocktable & clocking
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq org-clock-persist 'history)
(org-clock-persistence-insinuate)


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
  ;;(global-set-key "\C-s" 'counsel-grep)
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


;;;;;;;;;;;;;;;;;;;;;;
;; rust
;;;;;;;;;;;;;;;;;;;;;;
(when (maybe-require-package 'flycheck-rust)
  (with-eval-after-load 'rust-mode
    (add-hook 'flycheck-mode-hook #'flycheck-rust-setup)))


(add-to-list 'load-path "~/.emacs.d/site-lisp/")

;; (load-library "org-opml")
;; (load-library "ox-opml")
;; (load-library "org-kanban")


;;;;;;;;;;;;;;;;;;;;;;
;; copy / paste
;;;;;;;;;;;;;;;;;;;;;;
(when (eq system-type 'darwin)  ; mac specific bindings
  (defun copy-from-osx ()
    (shell-command-to-string "pbpaste"))

  (defun paste-to-osx (text &optional push)
    (let ((process-connection-type nil))
      (let ((proc (start-process "pbcopy" "*Messages*" "pbcopy")))
        (process-send-string proc text)
        (process-send-eof proc))))

  (setq interprogram-cut-function 'paste-to-osx)
  (setq interprogram-paste-function 'copy-from-osx)
  )

;;;;;;;;;;;;;;;;;;;;;;
;; projectile
;;;;;;;;;;;;;;;;;;;;;;
;; (require 'projectile-mode)
(projectile-mode +1)
(define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)

;; (require 'init-keymap)


;; Goto to file under cursor, gf in vim
(defun shell-command-to-string (command)
  "Execute shell command COMMAND and return its output as a string."
  (with-output-to-string
    (with-current-buffer standard-output
      (call-process shell-file-name nil t nil shell-command-switch command))))

(defun goto-file ()
  "open file under cursor"
  (interactive)
  (find-file (shell-command-to-string
              (concat "locate " (current-word) "|head -c -1"))))
(global-set-key (kbd "C-c C-f") 'goto-file)



(elpy-enable)

(provide 'init-local)
;;; init-local.el ends here
