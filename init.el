(setq frame-resize-pixelwise t)
	      (setq custom-file "~/.emacs.d/.emacs.custom.el")


;;show battery, data and time 
(display-battery-mode 1)
(setq display-time-day-and-date 1)
(display-time-mode 1)

;; The default is 800 kilobytes.  Measured in bytes.
(setq gc-cons-threshold (* 50 1000 1000))

      (add-hook 'text-mode-hook 'visual-line-mode)
	      (tool-bar-mode -1)
	      (menu-bar-mode -1)
	      (scroll-bar-mode -1)
	      (global-display-line-numbers-mode)


	      (load-file custom-file)

	  (setq display-line-numbers-type 'relative)
	(setq backup-directory-alist '(("." . "~/.emacs.d/emacs_backup")))

    (dolist (mode `(shell-mode-hook
    eshell-mode-hook
  term-mode-hook))
    (add-hook mode (lambda () (display-line-numbers-mode 0))))

(set-face-attribute 'default nil :family "Hack Bold" :height 150)

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/") t)
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
;; Comment/uncomment this line to enable MELPA Stable if desired.  See `package-archive-priorities`
;; and `package-pinned-packages`. Most users will not need or want to do this.
(package-initialize)

(use-package vertico
	   :ensure t
	   :bind (:map vertico-map
	   ("C-j" . vertico-next)
	   ("C-k" . vertico-previous))
	   :custom 
	   (vertico-cycle t)
	   :init 
	   (vertico-mode))

	   (use-package marginalia
	   :after vertico
	   :ensure t
	   :custom
	   (marginalia-annotators '(marginalia-annotators-heavy marginalia-annotators-light nil))
	   :init
	   (marginalia-mode))

	     (use-package orderless
	     :ensure t
	     :config
	     (setq completion-styles '(orderless basic))
	     (setq completion-category-defaults nil)
	     (setq completion-category-overrride nil))

	     (use-package savehist
	     :ensure nil ; it is built-in
	     :hook (after-init . savehist-mode))

	     (use-package consult
	     :ensure t
	     :bind (;; A recursive grep
	     ("M-s M-g" . consult-grep)
	     ;; Search for files names recursively
	     ("M-s M-f" . consult-find)
	     ;; Search through the outline (headings) of the file
	     ("M-s M-o" . consult-outline)
	     ;; Search the current buffer
	     ("M-s M-l" . consult-line)
	     ;; Switch to another buffer, or bookmarked file, or recently
	     ;; opened file.
	     ("M-s M-b" . consult-buffer)))


	     (use-package evil
	     :ensure t
             :init
             (setq evil-want-integration t) ;; This is optional since it's already set to t by default.
             (setq evil-want-keybinding nil)
	     :config
	     (evil-mode 1))

	     (use-package evil-escape
	     :ensure t
	     :init ; executes the code before the package is loaded
	     (setq-default evil-escape-key-sequence "kj")
	     :config ; exectues the code after the package is loaded
	     (evil-escape-mode 1))

	     (use-package org-bullets
	     :ensure t
	     :hook
	     (org-mode . org-bullets-mode))

 (use-package org-roam
   :ensure t
   :custom
   (org-roam-directory (file-truename "~/org/org_notes/"))
   :bind (("C-c n l" . org-roam-buffer-toggle)
	  ("C-c n f" . org-roam-node-find)
	  ("C-c n g" . org-roam-graph)
	  ("C-c n i" . org-roam-node-insert)
	  ("C-c n c" . org-roam-capture))
   :config
   ;; If you're using a vertical completion framework, you might want a more informative completion interface
   (setq org-roam-node-display-template (concat "${title:*} " (propertize "${tags:10}" 'face 'org-tag)))
   (org-roam-db-autosync-mode))


	     (use-package org
	     :ensure t
	     :config
	     (setq org-agenda-files
	     '("~/org/tasks.org"
	     "~/org/habits.org"
	     "~/org/birthdays.org")
	     org-hide-emphasis-markers t
	     org-agenda-start-with-log-mode t
	     org-log-done 'time
	     org-log-into-drawer t)

	 (setq org-todo-keywords
	   '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d!)")
	     ))

	 ;; Configure custom agenda views
	 (setq org-agenda-custom-commands
	  '(("d" "Dashboard"
	    ((agenda "" ((org-deadline-warning-days 7)))
	     (todo "NEXT"
	       ((org-agenda-overriding-header "Next Tasks")))
	     ))

	   ("n" "Next Tasks"
	    ((todo "NEXT"
	       ((org-agenda-overriding-header "Next Tasks")))))
     )))

	     (use-package evil-org
	     :ensure t
	     :after org
	     :hook (org-mode . (lambda () evil-org-mode))
	     :config
	     (require 'evil-org-agenda)
	     (evil-org-agenda-set-keys))

	     (use-package doom-modeline
	     :ensure t
	     :init (doom-modeline-mode 1))

;; Read ePub files
 (use-package nov
   :ensure t
   :init
   (add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode)))

(use-package magit
:ensure t)

    (use-package evil-collection
     :ensure t
     :after evil
     :config
     (evil-collection-init))

;; Automatically tangle our Emacs.org config file when we save it
(defun efs/org-babel-tangle-config ()
  (when (string-equal (file-name-directory (buffer-file-name))
                      (expand-file-name "~/.emacs.d/"))
    ;; Dynamic scoping to the rescue
    (let ((org-confirm-babel-evaluate nil))
      (org-babel-tangle))))

(add-hook 'org-mode-hook (lambda () (add-hook 'after-save-hook #'efs/org-babel-tangle-config)))
