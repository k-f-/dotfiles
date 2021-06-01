;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Kyle Fring"
      user-mail-address "kyle@fring.io")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
(setq doom-font (font-spec :family "PragmataPro Mono Liga" :size 34))
(setq doom-variable-pitch-font (font-spec :family "Iosevka Sparkle"))
(setq doom-serif-font (font-spec :family "Iosevka Etoile"))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-horizon)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")
;; org-roam directory
(setq org-roam-directory "~/org/")
;; deft directory. Wonder how long till this folder breaks something.
(setq deft-extensions '("org"))
(setq deft-default-extension "org")
(setq deft-directory "~/org/" )
;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

(setq org-log-into-drawer nil)
(setq org-deadline-warning-days 0)
;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c g k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c g d') to jump to their definition and see how
;; they are implemented.

;; Basic Config
(setq backup-directory-alist `(("." . "~/.emacs-tmp/")))
;;(setq auto-save-file-name-transforms `((".*" "~/.emacs-tmp/" t)))

;; Auto revert-mode. Look ma, no hands...
(global-auto-revert-mode t)

;; Auth
(setq auth-sources '("~/.authinfo.gpg"))

;; Sentences end with a single space. Fight me bro.
(setq sentence-end-double-space nil)

;; mu4e configuration
;; mu4e path
(add-to-list 'load-path "/usr/local/share/emacs/site-lisp/mu4e")

(set-email-account! "fring.io"
  '((mu4e-sent-folder       . "/fring.io/Sent")
    (mu4e-drafts-folder     . "/fring.io/Drafts")
    (mu4e-trash-folder      . "/fring.io/Trash")
    (mu4e-refile-folder     . "/fring.io/Archive")
    (smtpmail-smtp-user     . "kyle@fring.io")
    (user-mail-address      . "kyle@fring.io")    ;; only needed for mu < 1.4
    (mu4e-compose-signature . "\nk-f-")
    (mue4e-headers-skip-duplicates  t)
    (mu4e-attachments-dir "~/Downloads")
    (mu4e-compose-signature-auto-include nil)
))
;; send email config
 (setq message-send-mail-function 'smtpmail-send-it
       starttls-use-gnutls t
       smtpmail-starttls-credentials
       '(("smtp.fastmail.com" 587 nil nil))
       smtpmail-auth-credentials
       (expand-file-name "~/.authinfo.gpg")
       smtpmail-default-smtp-server "smtp.fastmail.com"
       smtpmail-smtp-server "smtp.fastmail.com"
       smtpmail-smtp-service 587
       smtpmail-debug-info t)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(send-mail-function (quote mailclient-send-it)))

;; Additional Scripting
;; Alvaro Rameriez's web scraping from URL.
(require 'enlive)
(require 'seq)

(defun ar/scrape-links-from-clipboard-url ()
  "Scrape links from clipboard URL and return as a list. Fails if no URL in clipboard."
  (unless (string-prefix-p "http" (current-kill 0))
    (user-error "no URL in clipboard"))
  (thread-last (enlive-query-all (enlive-fetch (current-kill 0)) [a])
    (mapcar (lambda (element)
              (string-remove-suffix "/" (enlive-attr element 'href))))
    (seq-filter (lambda (link)
                  (string-prefix-p "http" link)))
    (seq-uniq)
    (seq-sort (lambda (l1 l2)
                (string-lessp (replace-regexp-in-string "^http\\(s\\)*://" "" l1)
                              (replace-regexp-in-string "^http\\(s\\)*://" "" l2))))))

(defun ar/view-completing-links-at-clipboard-url ()
  "Scrape links from clipboard URL and open all in external browser."
  (interactive)
  (browse-url (completing-read "links: "
                               (ar/scrape-links-from-clipboard-url))))
(defun ar/browse-links-at-clipboard-url ()
  (interactive)
  (let ((links (ar/scrape-links-from-clipboard-url)))
    (when (y-or-n-p (format "Open all %d links? " (length links)))
      (mapc (lambda (link)
              (browse-url link))
            links))))
(require 'org)

(defun ar/view-links-at-clipboard-url ()
  "Scrape links from clipboard URL and dump to an org buffer."
  (interactive)
  (with-current-buffer (get-buffer-create "*links*")
    (org-mode)
    (erase-buffer)
    (mapc (lambda (link)
            (insert (org-make-link-string link) "\n"))
          (ar/scrape-links-from-clipboard-url))
    (goto-char (point-min))
    (switch-to-buffer (current-buffer))))

;; Clone REPO from URL
(defun ar/git-clone-clipboard-url ()
  "Clone git URL in clipboard asynchronously and open in dired when finished."
  (interactive)
  (cl-assert (string-match-p "^\\(http\\|https\\|ssh\\)://" (current-kill 0)) nil "No URL in clipboard")
  (let* ((url (current-kill 0))
         (download-dir (expand-file-name "~/Downloads/"))
         (project-dir (concat (file-name-as-directory download-dir)
                              (file-name-base url)))
         (default-directory download-dir)
         (command (format "git clone %s" url))
         (buffer (generate-new-buffer (format "*%s*" command)))
         (proc))
    (when (file-exists-p project-dir)
      (if (y-or-n-p (format "%s exists. delete?" (file-name-base url)))
          (delete-directory project-dir t)
        (user-error "Bailed")))
    (switch-to-buffer buffer)
    (setq proc (start-process-shell-command (nth 0 (split-string command)) buffer command))
    (with-current-buffer buffer
      (setq default-directory download-dir)
      (shell-command-save-pos-or-erase)
      (require 'shell)
      (shell-mode)
      (view-mode +1))
    (set-process-sentinel proc (lambda (process state)
                                 (let ((output (with-current-buffer (process-buffer process)
                                                 (buffer-string))))
                                   (kill-buffer (process-buffer process))
                                   (if (= (process-exit-status process) 0)
                                       (progn
                                         (message "finished: %s" command)
                                         (dired project-dir))
                                     (user-error (format "%s\n%s" command output))))))
    (set-process-filter proc #'comint-output-filter)))`
