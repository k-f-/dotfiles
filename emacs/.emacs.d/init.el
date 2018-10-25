;; Not that we needed all that for the trip,
;; but once you get locked into a serious drug collection,
;; the tendency is to push it as far as you can.

;;       --- Hunter S. Thompson, Fear and Loathing in Las Vegas

;; --------------------------------------------------
;; Set global user
(setq user-full-name "Kyle Fring"
	  user-mail-address "me@kfring.com")

;; --------------------------------------------------
;; org-mode
;; --------------------------------------------------
;; org-mode is my savior
(require 'org)
(add-to-list 'auto-mode-alist '("\\.\\(org\\|org_archive\\)$" . org-mode))

;; org-mode auto save only
;;(add-hook 'org-mode-hook 'my-org-mode-autosave-settings)
;;(defun my-org-mode-autosave-settings ()
;;  (set (make-local-variable 'auto-save-visited-file-name) t)
;;  (setq auto-save-interval 20))

;; org files in dropbox
(setq org-agenda-files (list "~/Dropbox/org/"))

;; --------------------------------------------------
;; flyspell - in all text modes
(add-hook 'text-mode-hook 'flyspell-mode)

;; --------------------------------------------------
;; User Interface
;; --------------------------------------------------
;; Don't display the help screen at start-up
(setq inhibit-startup-screen t)

;; --------------------------------------------------
;; Disable bell
(setq ring-bell-function 'ignore)

;; --------------------------------------------------
;; Minimal UI
(scroll-bar-mode -1)
(tool-bar-mode   -1)
(tooltip-mode    -1)
(menu-bar-mode   -1)

;; Time in modeline
(display-time-mode 1)

;; --------------------------------------------------
;; Fonts
;; --------------------------------------------------
;; Test char and monospace:
;; 0123456789abcdefghijklmnopqrstuvwxyz [] () :;,. !@#$^&*
;; 0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ {} <> "'`  ~-_/|\?
;;(set-face-attribute 'default t :font "InputMono-12" )
(add-to-list 'default-frame-alist
             '(font . "InputMono-12"))

;; --------------------------------------------------
;; Backups
;; --------------------------------------------------
; Let us centralize where emac's keeps backups
(setq backup-directory-alist '(("." . "~/.emacs.d/backup"))
	backup-by-copying t    ; Don't delink hardlinks
	version-control t      ; Use version numbers on backups
	delete-old-versions t  ; Automatically delete excess backups
	kept-new-versions 20   ; how many of the newest versions to keep
	kept-old-versions 5    ; and how many of the old
	)

;; make backup to a designated dir, mirroring the full path
;; ala ergomacs
(defun my-backup-file-name (fpath)
  "Return a new file path of a given file path.
If the new path's directories does not exist, create them."
  (let* (
		(backupRootDir "~/.emacs.d/backup/")
		(filePath (replace-regexp-in-string "[A-Za-z]:" "" fpath )) ; remove Windows driver letter in path, for example, “C:”
		(backupFilePath (replace-regexp-in-string "//" "/" (concat backupRootDir filePath "~") ))
		)
	(make-directory (file-name-directory backupFilePath) (file-name-directory backupFilePath))
	backupFilePath
  )
)

(setq make-backup-file-name-function 'my-backup-file-name)

;; --------------------------------------------------
;; Movement & Formatting
;; --------------------------------------------------

;; --------------------------------------------------
;; Page Down

;; Smooth scrolling means when you hit C-n to go to the next line
;; at the bottom of the page, instead of doing a page-down,
;; it shifts down by a single line. The margin means that
;; much space is kept between the cursor and the bottom of the buffer.

(setq scroll-margin 3
	  scroll-conservatively 101
	  scroll-up-aggressively 0.01
	  scroll-down-aggressively 0.01
	  scroll-preserve-screen-position t
	  auto-window-vscroll nil
	  hscroll-margin 5
	  hscroll-step 5)

;; --------------------------------------------------
;; Tabs as 4 spaces
(setq-default tab-width 4)
(setq-default tab-stop-list (list 4 8 12))

;; --------------------------------------------------
;; Packages
;; --------------------------------------------------
;; Package configs
(require 'package)
(setq package-enable-at-startup nil)
(setq package-archives '(("org"   . "http://orgmode.org/elpa/")
						 ("gnu"   . "http://elpa.gnu.org/packages/")
						 ("melpa" . "https://melpa.org/packages/")))
(package-initialize)

;; --------------------------------------------------
;; Bootstrap `use-package`
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)

;; --------------------------------------------------
;; Color Themes
;; apropospriate, nord, dracula
(use-package apropospriate-theme :ensure :defer)
(use-package dracula-theme :ensure :defer)

;; Packages
;; --------------------------------------------------
;; Enable Ido
(ido-mode t)

;; --------------------------------------------------
;; theme-changer
(use-package theme-changer :ensure :defer)
(setq calendar-location-name "Philadelphia, PA")
(setq calendar-latitude 39.95)
(setq calendar-longitude -75.16)
(require 'theme-changer)
(change-theme 'apropospriate-light 'dracula)

;; --------------------------------------------------
;; Magit
(use-package magit :ensure :defer)

;; --------------------------------------------------
;; Company
(use-package company :ensure :defer)

;; --------------------------------------------------
(use-package org-pomodoro :ensure :defer)

;; --------------------------------------------------
;; Deft
(use-package deft :ensure :defer
  :bind ("<f8>" . deft)
  :commands (deft)
  :config (setq deft-directory "~/Dropbox/org/notes/"
				deft-extensions '("md" "org" "txt")))
(setq deft-default-extension "org")
(setq deft-use-filename-as-title nil)
(setq deft-use-filter-string-for-filename t)
(setq deft-file-naming-rules '((noslash . "-")
							   (nospace . "-")
							   (case-fn . downcase)))
(setq deft-text-mode 'org-mode)

;; filenames - replace space and slash with - lcase
(setq deft-file-naming-rules
	  '((noslash . "-")
		(nospace . "-")
		(case-fn . downcase)))

;; --------------------------------------------------
;; Deft-Mode custom functions via: http://pragmaticemacs.com/emacs/tweaking-deft-quicker-notes/
;; Custom function to save window-layout when launching deft-mode
;; advise deft to save window config
(defun kef-deft-save-windows (orig-fun &rest args)
  (setq kef-pre-deft-window-config (current-window-configuration))
  (apply orig-fun args)
  )

(advice-add 'deft :around #'kef-deft-save-windows)

;; function to quit a deft edit cleanly back to pre deft window
(defun kef-quit-deft ()
  "Save buffer, kill buffer, kill deft buffer, and restore window config to the way it was before deft was invoked"
  (interactive)
  (save-buffer)
  (kill-this-buffer)
  (switch-to-buffer "*Deft*")
  (kill-this-buffer)
  (when (window-configuration-p kef-pre-deft-window-config)
    (set-window-configuration kef-pre-deft-window-config)
    )
  )

(global-set-key (kef "C-c q") 'kef-quit-deft)

;; --------------------------------------------------
;; PDF-Tools
;; Better pdf viewer with search, annotate, highlighting etc
;; 'poppler' and 'poppler-glib' must be installed
(use-package pdf-tools :ensure :defer
  ;; manually update
  ;; after each update we have to call:
  ;; Install pdf-tools but don't ask or raise error (otherwise daemon mode will wait for input)
  ;; (pdf-tools-install t t t)
  :magic ("%PDF" . pdf-view-mode)
  :mode (("\\.pdf\\'" . pdf-view-mode))
  :bind (:map pdf-view-mode-map
		 ("C-s" . isearch-forward)
		 ("M-p" . print-pdf))
  :config
  ;; Use `gtklp' to print as it has better cups support
  (defun print-pdf (&optional pdf)
	"Print PDF using external program `gtklp'."
	(interactive "P")
	(start-process-shell-command "gtklp" nil (format "gtklp %s" (shell-quote-argument (buffer-file-name)))))

  ;; more fine-grained zooming; +/- 10% instead of default 25%
  (setq pdf-view-resize-factor 1.1)
  ;; Always use midnight-mode and almost same color as default font.
  ;; Just slightly brighter background to see the page boarders
  (setq pdf-view-midnight-colors '("#c6c6c6" . "#363636"))
  (add-hook 'pdf-view-mode-hook (lambda ()
								  (pdf-view-midnight-minor-mode))))

;; with-editor: Use local Emacs instance as $EDITOR (e.g. in `git commit’ or `crontab -e’)
(use-package with-editor :ensure :defer
  ;; Use local Emacs instance as $EDITOR (e.g. in `git commit' or `crontab -e')
  :hook ((shell-mode eshell-mode term-exec) . with-editor-export-editor))

;; undo-tree
(use-package undo-tree :ensure :defer)

(add-to-list 'load-path "~/.emacs.d/undo-tree")
(global-undo-tree-mode)

;; --------------------------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-agenda-files
   (quote
	("/home/kef/Dropbox/org/Evernote.org" "/home/kef/Dropbox/org/inbox.org" "/home/kef/Dropbox/org/journal.org" "/home/kef/Dropbox/org/projects.org" "/home/kef/Dropbox/org/someday.org" "/home/kef/Dropbox/org/timeclock.org")))
 '(package-selected-packages
   (quote
	(pdf-tools smart-mode-line use-package undo-tree theme-changer magit dracula-theme deft company apropospriate-theme)))
 '(spaceline-info-mode t)
 '(tab-stop-list (quote (4 8 12))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
