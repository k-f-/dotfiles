;; load up Org-mode and Org-babel
  (require 'org-install)
  (require 'ob-tangle)

;; load up all literate org-mode files in this directory
(org-babel-load-file "~/.emacs.d/config.org")

;;; init.el ends here
