;; Not that we needed all that for the trip,
;; but once you get locked into a serious drug collection,
;; the tendency is to push it as far as you can.

;;       --- Hunter S. Thompson, Fear and Loathing in Las Vegas


;; Don't display the help screen at start-up
(setq inhibit-startup-screen t)

;; Disable bell
(setq ring-bell-function 'ignore)

;; Minimal UI
(scroll-bar-mode -1)
(tool-bar-mode   -1)
(tooltip-mode    -1)
(menu-bar-mode   -1)

;; Package configs
(require 'package)
(setq package-enable-at-startup nil)
(setq package-archives '(("org"   . "http://orgmode.org/elpa/")
                         ("gnu"   . "http://elpa.gnu.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")))
(package-initialize)

;; Bootstrap `use-package`
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)

;; Color Theme
(use-package apropospriate-theme
  :ensure t
  :config
  ;;(load-theme 'apropospriate-dark t)
  ;; or
  (load-theme 'apropospriate-light t))

;; Set default font
; Test char and monospace:
; 0123456789abcdefghijklmnopqrstuvwxyz [] () :;,. !@#$^&*
; 0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ {} <> "'`  ~-_/|\?
(set-face-attribute 'default t :font "InputMono-12" )

;; Packages

;; Enable Ido
(ido-mode t)

;; Ranger 4 Emacs
(use-package ranger :ensure :defer)

;; Magit
(use-package magit :ensure :defer)

;; Company
(use-package company :ensure :defer)

;; PDF-Tools
;; Better pdf viewer with search, annotate, highlighting etc
;; 'poppler' and 'poppler-glib' must be installed
(use-package pdf-tools
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

;; Let us centralize where emac's keeps backups
(setq backup-directory-alist '(("." . "~/.emacs.d/backup"))
    backup-by-copying t    ; Don't delink hardlinks
    version-control t      ; Use version numbers on backups
    delete-old-versions t  ; Automatically delete excess backups
    kept-new-versions 20   ; how many of the newest versions to keep
    kept-old-versions 5    ; and how many of the old
    )

;; with-editor: Use local Emacs instance as $EDITOR (e.g. in `git commit’ or `crontab -e’)
(use-package with-editor
  ;; Use local Emacs instance as $EDITOR (e.g. in `git commit' or `crontab -e')
  :hook ((shell-mode eshell-mode term-exec) . with-editor-export-editor))

;; ws-butler: Remove whitespace, but only if I put it there.
(use-package ws-butler
  :hook ((text-mode prog-mode) . ws-butler-mode)
  :config (setq ws-butler-keep-whitespace-before-point nil))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (ws-butler pdf-tools company powerline-evil ranger ## magit powerline nord-theme apropospriate-theme use-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
