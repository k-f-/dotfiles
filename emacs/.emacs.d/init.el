;; First, create a hook that shows us how long startup takes with garbage collection takes.
;; Use a hook so the message doesn't get clobbered by other messages.
(add-hook 'emacs-startup-hook
	(lambda ()
	  (message "Emacs ready in %s with %d garbage collections."
		   (format "%.2f seconds"
                           (float-time
                              (time-subtract after-init-time before-init-time)))
                     gcs-done)))

;; Turn off mouse interface early in startup to avoid momentary display
(when window-system
  (menu-bar-mode -1)
  (tool-bar-mode -1)
  (scroll-bar-mode -1)
  (tooltip-mode -1))

;;; ignore .xresources
(setq inhibit-x-resources t)

;;; Set up package
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)
(package-initialize)

;;; Bootstrap use-package
;; Install use-package if it's not already installed.
;; use-package is used to configure the rest of the packages.
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; From use-package README
(eval-when-compile
  (require 'use-package))

(require 'bind-key)

;; For debugging
(setq use-package-verbose t)

;; run server if using emacsclient as default EDITOR also useful for
;; org-protocol capture https://www.emacswiki.org/emacs/EmacsClient

(require 'server)
(unless (server-running-p)
  (server-start))
;; load org package
(require 'org)

;; load up my literate org-mode file
(org-babel-load-file "~/.emacs.d/config.org")

;;; init.el ends here
