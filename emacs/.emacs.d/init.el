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

;; add MELPA package server
(require 'package)

(add-to-list 'package-archives 
  '("melpa" . "http://melpa.org/packages/") t)

(unless package-archive-contents
  (package-refresh-contents))

(package-initialize)

;; if not yet installed, install package use-package
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

;; load org package
(require 'org)

;; load up my literate org-mode file
(org-babel-load-file "~/.emacs.d/config.org")

;;; init.el ends here
