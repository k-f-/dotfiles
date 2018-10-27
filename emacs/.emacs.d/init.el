;; load up Org-mode and Org-babel

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

  (require 'org-install)
  (require 'ob-tangle)

;; load up all literate org-mode files in this directory
(org-babel-load-file "~/.emacs.d/config.org")

;;; init.el ends here
