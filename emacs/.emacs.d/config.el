(load "server")
(unless (server-running-p) (server-start))

(setq user-full-name "Kyle Fring"
      user-mail-address "kyle@fring.io")
(setq calendar-location-name "Chattanooga, TN")
(setq calendar-latitude 39.95)
(setq calendar-longitude -75.16)

(add-to-list 'load-path "~/.emacs.d/lisp")

(require 'package)
(setq package-enable-at-startup nil)
(setq package-archives '(
			 ("melpa" . "http://melpa.org/packages/")
			 ("gnu"   . "http://elpa.gnu.org/packages/")))
(package-refresh-contents)
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(setq use-package-verbose t)
(setq use-package-always-ensure t)
(require 'use-package)

(setq epg-gpg-program "/usr/bin/gpg2")

(setq dabbrev-ignored-buffer-regexps '(".*\.org$" ".*\.gpg$" "^ [*].*"))

(defun kef/company-dabbrev-ignore (buffer)
  (let (res)
    ;; don't search in org files, encrypted files, or hidden buffers
    (dolist (re '("\.org$" "\.gpg$" "^ [*]") res)
      (if (string-match-p re (buffer-name buffer))
          (setq res t)))))
(setq company-dabbrev-ignore-buffers 'kef/company-dabbrev-ignore)

(setq auth-sources '("~/.gnupg/shared/authinfo.gpg"
                     "~/.authinfo.gpg"
                     "~/.authinfo"
                     "~/.netrc"))

(setq custom-file "~/.emacs.d/custom.el")
(when (file-exists-p custom-file) (load custom-file))

(defun package--save-selected-packages (&optional VALUE opt)
  nil)

;; (defvar org-export-output-directory-prefix "~/out/export_" "prefix of directory used for org-mode export")

;; (defadvice org-export-output-file-name (before org-add-export-dir activate)
;;   "Modifies org-export to place exported files in a different directory"
;;   (when (not pub-dir)
;;     (setq pub-dir (concat org-export-output-directory-prefix (substring extension 1)))
;;     (when (not (file-directory-p pub-dir))
;;       (make-directory pub-dir))))

(setq backup-directory-alist '(("." . "~/.emacs.d/backup"))
      backup-by-copying t    ; Don't delink hardlinks
      version-control t      ; Use version numbers on backups
      delete-old-versions t  ; Automatically delete excess backups
      kept-new-versions 20   ; how many of the newest versions to keep
      kept-old-versions 5    ; and how many of the old
      )

(defun kef/backup-file-name (fpath)
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

(setq make-backup-file-name-function 'kef/backup-file-name)

(eval-after-load 'auto-revert-mode
  '(diminish 'auto-revert-mode))
(global-auto-revert-mode 1)
(add-hook 'dired-mode-hook 'auto-revert-mode)
(setq global-auto-revert-non-file-buffers t
      auto-revert-verbose nil)

;; Core settings
;; UTF-8 please
(set-charset-priority 'unicode)
(setq locale-coding-system   'utf-8)   ; pretty
(set-terminal-coding-system  'utf-8)   ; pretty
(set-keyboard-coding-system  'utf-8)   ; pretty
(set-selection-coding-system 'utf-8)   ; please
(prefer-coding-system        'utf-8)   ; with sugar on top
(setq default-process-coding-system '(utf-8-unix . utf-8-unix))

;; (defun kef/setup-indent (n)
;;   ;; java/c/c++
;;   (setq c-basic-offset n)
;;   ;; web development
;;   (setq coffee-tab-width n) ; coffeescript
;;   (setq javascript-indent-level n) ; javascript-mode
;;   (setq js-indent-level n) ; js-mode
;;   (setq js2-basic-offset n) ; js2-mode, in latest js2-mode, it's alias of js-indent-level
;;   (setq web-mode-markup-indent-offset n) ; web-mode, html tag in html file
;;   (setq web-mode-css-indent-offset n) ; web-mode, css in html file
;;   (setq web-mode-code-indent-offset n) ; web-mode, js code in html file
;;   (setq css-indent-offset n) ; css-mode
;;   )

;; (defun kef/tabs-code-style ()
;;   (interactive)
;;   (message "tab code style!")
;;   ;; use tab instead of space
;;   (setq indent-tabs-mode t)
;;   ;; indent 4 spaces width
;;   (kef/setup-indent 4))

;; (defun kef/spaces-code-style ()
;;   (interactive)
;;   (message "spaces code style!")
;;   ;; use space instead of tab
;;   (setq indent-tabs-mode nil)
;;   ;; indent 4 spaces width
;;   (kef/setup-indent 4))

;; (defun kef/setup-develop-environment ()
;;   (interactive)
;;   (let ((proj-dir (file-name-directory (buffer-file-name))))
;;     ;; if hobby project path contains string "hobby-proj1"
;;     (if (string-match-p "hobby-proj1" proj-dir)
;;         (kef/spaces-code-style))

;;     ;; if commericial project path contains string "commerical-proj"
;;     (if (string-match-p "commerical-proj" proj-dir)
;;         (kef/tabs-code-style))))

;; ;; prog-mode-hook requires emacs24+
;; (add-hook 'prog-mode-hook 'kef/setup-develop-environment)
;; ;; a few major-modes does NOT inherited from prog-mode
;; (add-hook 'lua-mode-hook 'kef/setup-develop-environment)
;; (add-hook 'web-mode-hook 'kef/setup-develop-environment)

;; ;; Just switch to tabs now.
;; (kef/tabs-code-style)

(setq sentence-end-double-space nil)     ; Sentences should end in one space, come on!

(use-package fontawesome :ensure t)
(defun insert-fontawesome ()
  (interactive)
  (insert (call-interactively 'fontawesome)))

(setq inhibit-x-resources t)

(scroll-bar-mode -1)
(tool-bar-mode   -1)
(tooltip-mode    -1)
(menu-bar-mode   -1)

(setq ring-bell-function 'ignore)

(display-time-mode 1)

(use-package minions :ensure t)
(minions-mode +1)

(use-package moody :ensure
  :config
  (setq x-underline-at-descent-line t)
  (moody-replace-mode-line-buffer-identification)
  (moody-replace-vc-mode))

(blink-cursor-mode 0)
(setq cursor-in-non-selected-windows t)  ; Hide the cursor in inactive windows

(setq initial-scratch-message nil)
(setq inhibit-startup-screen t)

(setq initial-major-mode 'org-mode)      ; org mode by default

;; (add-hook 'after-init-hook
          ;; (lambda ()
            ;; (org-agenda nil "d")
            ;; (delete-other-windows)))

(fset 'yes-or-no-p 'y-or-n-p)

(setq use-dialog-box nil)

(show-paren-mode 1)

(defun kef/locally-disable-show-paren ()
  (interactive)
  (setq show-paren-mode nil))

(add-hook 'ruby-mode-hook
          #'kef/locally-disable-show-paren)

(global-hl-line-mode +1)

;; Test char and monospace:
;; 0123456789abcdefghijklmnopqrstuvwxyz [] () :;,. !@#$^&*
;; 0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ {} <> "'`  ~-_/|\?
(set-default-font "Iosevka Term Semibold 11")
(add-to-list 'default-frame-alist
             '(font . "Iosevka Term Semibold 11"))

(defvar *kef/theme-dark* 'doom-tomorrow-night)
(defvar *kef/theme-light* 'doom-tomorrow-day)
(defvar *kef/current-theme* *kef/theme-dark*)

(defun kef/next-theme (theme)
  (if (eq theme 'default)
      (disable-theme *kef/current-theme*)
    (progn
      (load-theme theme t)))
  (setq *kef/current-theme* theme))

(defun kef/toggle-theme ()
  (interactive)
  (cond ((eq *kef/current-theme* *kef/theme-dark*) (kef/next-theme *kef/theme-light*))
        ((eq *kef/current-theme* *kef/theme-light*) (kef/next-theme 'default))
        ((eq *kef/current-theme* 'default) (kef/next-theme *kef/theme-dark*))))

;; disable other themes before loading new one
(defadvice load-theme (before theme-dont-propagate activate)
  "Disable theme before loading new one."
  (mapc #'disable-theme custom-enabled-themes))

;; (use-package zenburn-theme :ensure t)
(use-package base16-theme :ensure t)

(use-package doom-themes :ensure)

;; Global settings (defaults)
(setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
      doom-themes-enable-italic t) ; if nil, italics is universally disabled

  ;; Corrects (and improves) org-mode's native fontification.
(doom-themes-org-config)

;;(load-theme 'zenburn t t)
;;(load-theme 'base16-tomorrow t t)

;; Load the theme (doom-one, doom-molokai, etc); keep in mind that each theme
;; may have their own settings.
(load-theme 'doom-tomorrow-night t)
;; (load-theme 'dichromacy t)

(setq echo-keystrokes 0.1)               ; Show keystrokes right away, don't show the message in the scratch buffer

(setq scroll-margin 3
      scroll-conservatively 101
      scroll-up-aggressively 0.01
      scroll-down-aggressively 0.01
      scroll-preserve-screen-position t
      auto-window-vscroll nil
      hscroll-margin 5
      hscroll-step 5)

(use-package golden-ratio :ensure)
;  (setq golden-ratio-auto-scale t)
  (golden-ratio-mode 1)

  (setq golden-ratio-adjust-factor .8
        golden-ratio-wide-adjust-factor .8)

(use-package dimmer :ensure)
(dimmer-mode)
(setq dimmer-fraction 0.50)

(defvar *my-desktop-save* nil
  "Should I save the desktop when Emacs is shutting down?")

(add-hook 'desktop-after-read-hook
          (lambda () (setq *my-desktop-save* t)))

(advice-add 'desktop-save :around
            (lambda (fn &rest args)
              (if (bound-and-true-p *my-desktop-save*)
                  (apply fn args))))

(desktop-save-mode)
(setq desktop-restore-eager 10)
(setq desktop-save t)
(setq desktop-auto-save-timeout 60)
(setq desktop-load-locked-desktop t)

(require 'find-desktop)

(defun kef/kill-current-buffer ()
  "Kill the current buffer without prompting."
  (interactive)
  (kill-buffer (current-buffer)))

;; Don't comfirm on kill buffer, just close it.
(global-set-key (kbd "C-x k") 'kef/kill-current-buffer)

(defun kef/visit-emacs-config ()
  (interactive)
  (find-file "~/.emacs.d/config.org"))

;; Jump to emacs config file.
(global-set-key (kbd "C-c e") 'kef/visit-emacs-config)

;; add `flet'
(require 'cl)

(defadvice save-buffers-kill-emacs
  (around no-query-kill-emacs activate)
  "Prevent \"Active processes exist\" query on exit."
  (cl-flet ((process-list ())) ad-do-it))

;; ref: https://www.reddit.com/r/emacs/comments/a3rajh/chrome_bookmarks_sync_to_org/
(defvar kef/chrome-bookmarks-file
  (cl-find-if
   #'file-exists-p
   ;; Base on `helm-chrome-file'
   (list
    "~/.config/BraveSoftware/Brave-Browser/Default/Bookmarks"
    "~/Library/Application Support/Google/Chrome/Profile 1/Bookmarks"
    "~/Library/Application Support/Google/Chrome/Default/Bookmarks"
    "~/AppData/Local/Google/Chrome/User Data/Default/Bookmarks"
    "~/.config/google-chrome/Default/Bookmarks"
    "~/.config/chromium/Default/Bookmarks"
    (substitute-in-file-name
     "$LOCALAPPDATA/Google/Chrome/User Data/Default/Bookmarks")
    (substitute-in-file-name
     "$USERPROFILE/Local Settings/Application Data/Google/Chrome/User Data/Default/Bookmarks")))
  "Path to Google Chrome Bookmarks file (it's JSON).")

(defun kef/chrome-bookmarks-insert-as-org ()
  "Insert Chrome/Brave Bookmarks as org-mode headings."
  (interactive)
  (require 'json)
  (require 'org)
  (let ((data (let ((json-object-type 'alist)
                    (json-array-type  'list)
                    (json-key-type    'symbol)
                    (json-false       nil)
                    (json-null        nil))
                (json-read-file kef/chrome-bookmarks-file)))
        level)
    (cl-labels ((fn
                 (al)
                 (pcase (alist-get 'type al)
                   ("folder"
                    (insert
                     (format "%s %s\n"
                             (make-string level ?*)
                             (alist-get 'name al)))
                    (cl-incf level)
                    (mapc #'fn (alist-get 'children al))
                    (cl-decf level))
                   ("url"
                    (insert
                     (format "%s %s\n"
                             (make-string level ?*)
                             (org-make-link-string
                              (alist-get 'url al)
                              (alist-get 'name al))))))))
      (setq level 1)
      (fn (alist-get 'bookmark_bar (alist-get 'roots data)))
      (setq level 1)
      (fn (alist-get 'other (alist-get 'roots data))))))

(defun smart-open-line ()
  "Insert an empty line after the current line. Position the cursor at its beginning, according to the current mode."
  (interactive)
  (move-end-of-line nil)
  (newline-and-indent))

(defun smart-open-line-above ()
  "Insert an empty line above the current line. Position the cursor at it's beginning, according to the current mode."
  (interactive)
  (move-beginning-of-line nil)
  (newline-and-indent)
  (forward-line -1)
  (indent-according-to-mode))

(global-set-key (kbd "s-<return>") 'smart-open-line) ;; This is bound to "new-terminal" in i3.
(global-set-key (kbd "s-S-<return>") 'smart-open-line-above) ;; This currently is not bound to anything in i3.

(global-set-key (kbd "M-o") 'other-window)

(defun vsplit-last-buffer ()
  (interactive)
  (split-window-vertically)
  (other-window 1 nil)
  (switch-to-next-buffer))

(defun hsplit-last-buffer ()
  (interactive)
  (split-window-horizontally)
  (other-window 1 nil)
  (switch-to-next-buffer))
;; lets use something other than S or F? S is for search. F is Forward. Left hand side key? C-u?
(global-set-key (kbd "C-q") (kbd "C-x 0")) ;; Like our i3 config of s-q ;; F is used by emacs for movement.. duh.
(global-set-key (kbd "C-S-q") (kbd "C-x 1")) ;; close others with shift. In i3 the translation would be mod$-shift

(global-set-key (kbd "C-u") 'hsplit-last-buffer)   ;; i3: mod-s
(global-set-key (kbd "C-S-u") 'vsplit-last-buffer) ;; i3: mod-shift-s

(use-package ivy :ensure
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t)

  (setq ivy-count-format "(%d/%d) ")
  (setq enable-recursive-minibuffers t)
  (setq ivy-initial-inputs-alist nil)
  (setq ivy-re-builders-alist
        '((swiper . ivy--regex-plus)
          (t      . ivy--regex-fuzzy)))   ;; enable fuzzy searching everywhere except for Swiper
  (global-set-key (kbd "C-S-F") 'ivy-resume))

(use-package swiper :ensure
  :config
  (global-set-key (kbd "C-s") 'swiper)) ;; use swiper-search bound to C-f like browsers. This will take awhile to get used to.

(use-package counsel :ensure
  :config
  (global-set-key (kbd "M-x") 'counsel-M-x)
  (global-set-key (kbd "M-y") 'counsel-yank-pop)
  (setq enable-recursive-minibuffers t)
  ;; enable this if you want `swiper' to use it
  ;; (setq search-default-mode #'char-fold-to-regexp)

  (global-set-key (kbd "M-x") 'counsel-M-x)
  (global-set-key (kbd "C-x C-f") 'counsel-find-file)
  (global-set-key (kbd "<f1> v") 'counsel-describe-variable)
  (global-set-key (kbd "<f1> l") 'counsel-find-library)
  (global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
  (global-set-key (kbd "<f2> u") 'counsel-unicode-char)
  (global-set-key (kbd "C-c g") 'counsel-git)
  (global-set-key (kbd "C-c j") 'counsel-git-grep)
  (global-set-key (kbd "C-c k") 'counsel-ag)
  (global-set-key (kbd "C-x l") 'counsel-locate))

(use-package smex :ensure)
(use-package flx :ensure)
(use-package avy :ensure
    :bind
("C-c C-SPC" . avy-goto-char-timer))

(use-package ivy-rich :ensure
  :config
  (ivy-rich-mode 1)
  (setq ivy-rich-path-style 'abbrev)) ;; To abbreviate paths using abbreviate-file-name (e.g. replace “/home/username” with “~”

(setq save-place-mode t)

(use-package whole-line-or-region :ensure)
(add-to-list 'whole-line-or-region-extensions-alist
             '(comment-dwim whole-line-or-region-comment-dwim nil))
(whole-line-or-region-mode 1)

(add-hook 'before-save-hook 'delete-trailing-whitespace)
(setq require-final-newline t)

(add-hook 'text-mode-hook 'turn-on-auto-fill)
(add-hook 'text-mode-hook
          '(lambda() (set-fill-column 80)))
;; lets just do it globally
(setq-default fill-column 80)

(use-package visual-regexp
  :config
  (define-key global-map (kbd "C-r") 'vr/replace))

(use-package expand-region :ensure
  :config
  (global-set-key (kbd "M-]") 'er/expand-region)
  (global-set-key (kbd "M-[") 'er/contract-region))

(use-package multiple-cursors
  :ensure t
  :config
  (setq mc/always-run-for-all 1)
  (global-set-key (kbd "C-=") 'mc/mark-next-like-this)
  (global-set-key (kbd "C-+") 'mc/mark-all-dwim)
  (define-key mc/keymap (kbd "<return>") nil))

;;  (use-package flycheck :ensure)

(use-package comment-dwim-2 :ensure t)
(global-set-key (kbd "M-;") 'comment-dwim-2)

(use-package web-mode
  :ensure t
  :mode "\\.html?\\'"
  :config
  (progn
    (setq web-mode-markup-indent-offset 4)
    (setq web-mode-code-indent-offset 4)
    (setq web-mode-enable-current-element-highlight t)
    (setq web-mode-enable-auto-expanding t)
    ))

(use-package rainbow-mode :ensure)

(add-hook 'web-mode-hook #'rainbow-mode)
(add-hook 'css-mode-hook #'rainbow-mode)

(use-package skewer-mode :ensure)
(add-hook 'css-mode-hook 'skewer-css-mode)
(add-hook 'html-mode-hook 'skewer-html-mode)

;; js2-mode
;; https://github.com/mooz/js2-mode
(use-package js2-mode :ensure
  :bind (:map js2-mode-map
              (("C-x C-e" . js-send-last-sexp)
               ("C-M-x" . js-send-last-sexp-and-go)
               ("C-c C-b" . js-send-buffer-and-go)
               ("C-c C-l" . js-load-file-and-go)))
  :mode
  ("\\.js$" . js2-mode)
  ("\\.json$" . js2-jsx-mode)
  :config
  (custom-set-variables '(js2-strict-inconsistent-return-warning nil))
  (custom-set-variables '(js2-strict-missing-semi-warning nil))

  (setq js-indent-level 4)
  (setq js2-indent-level 4)
  (setq js2-basic-offset 4)
  (setq js2-highlight-level 1)         ; some highlighting.
  '(js2-auto-indent-p t)               ; it's nice for commas to right themselves.
  '(js2-enter-indents-newline t)       ; don't need to push tab before typing
  '(j2-indent-on-enter-key t)

  ;; tern :- IDE like features for javascript and completion
  ;; http://ternjs.net/doc/manual.html#emacs
  (use-package tern :ensure
    :config
    (defun kef/js-mode-hook ()
      "Hook for `js-mode'."
      (set (make-variable 'company-backends)
           '((company-tern company-files))))
    (add-hook 'js2-mode-hook 'kef/js-mode-hook)
    (add-hook 'js2-mode-hook 'skewer-mode)
    (add-hook 'js2-mode-hook 'company-mode))

  (add-hook 'js2-mode-hook 'tern-mode)

  ;; company backend for tern
  ;; http://ternjs.net/doc/manual.html#emacs
  (use-package company-tern :ensure)

  ;; Run a JavaScript interpreter in an inferior process window
  ;; https://github.com/redguardtoo/js-comint
  (use-package js-comint :ensure
    :config
    (setq inferior-js-program-command "node"))

  ;; js2-refactor :- refactoring options for emacs
  ;; https://github.com/magnars/js2-refactor.el
  (use-package js2-refactor :defer t
    :diminish js2-refactor-mode
    :config
    (js2r-add-keybindings-with-prefix "C-c j r"))
  (add-hook 'js2-mode-hook 'js2-refactor-mode))

;;(use-package ess :ensure)

(use-package company :ensure)
(add-hook 'after-init-hook 'global-company-mode)

(global-set-key (kbd "M-/") 'company-complete-common)

;;  add company back-ends

(use-package yasnippet :ensure)
(use-package yasnippet-snippets
  :after yasnippet
  :config (yasnippet-snippets-initialize))

(use-package yasnippet
  :delight yas-minor-mode " υ"
  :hook (yas-minor-mode . kef/disable-yas-if-no-snippets)
  :config (yas-global-mode)
  :preface
  (defun kef/disable-yas-if-no-snippets ()
    (when (and yas-minor-mode (null (yas--get-snippet-tables)))
      (yas-minor-mode -1))))

(use-package ivy-yasnippet :after yasnippet)
(use-package react-snippets :after yasnippet)

;; (yas-reload-all)
;; (add-hook 'prog-mode-hook #'yas-minor-mode)
;; (yas-global-mode 1)

(setq quietly-read-abbrev-file t)
(setq abbrev-file-name "~/.emacs.d/abbrev_defs")

(use-package define-word :ensure)
(global-set-key (kbd "C-c d") 'define-word-at-point)
(global-set-key (kbd "C-c D") 'define-word)

(use-package powerthesaurus :ensure)
(global-set-key (kbd "C-c t") 'powerthesaurus-lookup-word-dwim)

(use-package flyspell :ensure)
(add-hook 'prog-mode-hook 'flyspell-prog-mode) ;; Flyspell in program mode.
(dolist (hook '(text-mode-hook))
  (add-hook hook (lambda () (flyspell-mode 1)))) ;; On for text-mode
(dolist (hook '(change-log-mode-hook log-edit-mode-hook))
  (add-hook hook (lambda () (flyspell-mode -1)))) ;; Off for log and change-log mode.

(use-package writegood-mode :ensure)
(add-hook 'text-mode-hook 'writegood-mode)

(use-package magit :ensure
  :config
  (setq magit-completing-read-function 'ivy-completing-read)

  :bind
  ;; Magic
  ("C-x g s" . magit-status)
  ("C-x g x" . magit-checkout)
  ("C-x g c" . magit-commit)
  ("C-x g p" . magit-push)
  ("C-x g u" . magit-pull)
  ("C-x g e" . magit-ediff-resolve)
  ("C-x g r" . magit-rebase-interactive))

(use-package magit-popup)

(add-hook 'message-mode-hook 'turn-on-orgtbl)
(add-hook 'message-mode-hook 'turn-on-orgstruct++)

;; installed from release.
(add-to-list 'load-path "/usr/local/share/emacs/site-lisp/mu4e")
(require 'mu4e)

(setq mu4e-maildir       "~/.mail")   ;; top-level Maildir

;; from https://www.reddit.com/r/emacs/comments/bfsck6/mu4e_for_dummies/elgoumx
(add-hook 'mu4e-headers-mode-hook
          (defun my/mu4e-change-headers ()
            (interactive)
            (setq mu4e-headers-fields
                  `((:human-date . 25) ;; alternatively, use :date
                    (:flags . 6)
                    (:from . 22)
                    (:thread-subject . ,(- (window-body-width) 70)) ;; alternatively, use :subject
                    (:size . 7)))))

;; if you use date instead of human-date in the above, use this setting
;; give me ISO(ish) format date-time stamps in the header list
;; (setq mu4e-headers-date-format "%Y-%m-%d %H:%M")

                                        ; get mail
(setq mu4e-get-mail-command "mbsync -c ~/.mbsyncrc -a"
      ;; mu4e-html2text-command "w3m -T text/html" ;;using the default mu4e-shr2text
      mu4e-view-prefer-html t
      mu4e-update-interval 300
      mu4e-headers-auto-update t
      mu4e-compose-signature-auto-include nil
      mu4e-compose-format-flowed t)

;; to view selected message in the browser, no signin, just html mail
(add-to-list 'mu4e-view-actions
             '("ViewInBrowser" . mu4e-action-view-in-browser) t)

;; enable inline images
(setq mu4e-view-show-images t)
;; use imagemagick, if available
(when (fboundp 'imagemagick-register-types)
  (imagemagick-register-types))

;; every new email composition gets its own frame!
(setq mu4e-compose-in-new-buffer t)

;; Note: This shows no email, wonder if it's been fixed in 1.0
;; Ignore duplicates
(setq mu4e-headers-skip-duplicates t)

;; GMail already adds sent mail to the Sent Mail folder.
(setq mu4e-sent-messages-behavior 'delete)

;; don't keep message buffers around
(setq message-kill-buffer-on-exit t)
;;rename files when moving
;;NEEDED FOR MBSYNC
(setq mu4e-change-filenames-when-moving t)

;;set up queue for offline email
;;use mu mkdir  ~/Maildir/acc/queue to set up first
(setq smtpmail-queue-mail nil)  ;; start in normal mode

;;from the info manual
(setq mu4e-attachment-dir  "~/Downloads")
(setq mu4e-compose-dont-reply-to-self t)

(require 'org-mu4e)

;; convert org mode to HTML automatically
;; (setq org-mu4e-convert-to-html t)  ;; Until we can squelch the TOC, we're leaving this off.

;;from vxlabs config
;; show full addresses in view message (instead of just names)
;; toggle per name with M-RET
(setq mu4e-view-show-addresses 't)

;; Some hooks
(add-hook 'mu4e-view-mode-hook #'visual-line-mode)
(add-hook 'mu4e-compose-mode-hook #'org-mu4e-compose-org-mode)
(add-hook 'mu4e-compose-mode-hook #'toc-org-mode -1)  ;; really don't want a table of contents in our emails
;; but this is the wrong place to fix this. It's likely happening when the EXPORT of the email to HTML occurs.
(add-hook 'mu4e-compose-mode-hook 'use-hard-newlines -1)
(add-hook 'mu4e-compose-mode-hook #'flyspell-mode)

;; enable format=flowed
;; - mu4e sets up visual-line-mode and also fill (M-q) to do the right thing
;; - each paragraph is a single long line; at sending, emacs will add the
;;   special line continuation characters.
;; - also see visual-line-fringe-indicators setting below
(setq mu4e-compose-format-flowed t)
;; because it looks like email clients are basically ignoring format=flowed,
;; let's complicate their lives too. send format=flowed with looong lines. :)
;; https://www.ietf.org/rfc/rfc2822.txt
(setq fill-flowed-encode-column 998)
;; in mu4e with format=flowed, this gives me feedback where the soft-wraps are
(setq visual-line-fringe-indicators '(left-curly-arrow right-curly-arrow))

;; This hook correctly modifies the \Inbox and \Starred flags on email when they are marked.
;; Without it refiling (archiving) and flagging (starring) email won't properly result in
;; the corresponding gmail action.
(add-hook 'mu4e-mark-execute-pre-hook
          (lambda (mark msg)
            (cond ((member mark '(refile trash)) (mu4e-action-retag-message msg "-\\Inbox"))
                  ((equal mark 'flag) (mu4e-action-retag-message msg "\\Starred"))
                  ((equal mark 'unflag) (mu4e-action-retag-message msg "-\\Starred")))))

;; mu4e uses its own version of message-mode. The only benefit I know of is that it enables completion for To, CC and BCC fields. That is really useful though!
(setq mail-user-agent 'mu4e-user-agent)

;; For some reason it uses its own signature variable. Not anymore!
(defvaralias 'mu4e-compose-signature 'message-signature)

(setq mu4e-completing-read-function 'ivy-completing-read
      mu4e-confirm-quit nil) ; Ivy for completion

;; Set contexts based on if it's a gmail account or not.
;; ref: http://cachestocaches.com/2017/3/complete-guide-email-emacs-using-mu-and-/
;; This sets up my two different context for my personal and school emails
(setq mu4e-context-policy 'pick-first)
(setq mu4e-compose-context-policy 'always-ask)
(setq mu4e-contexts
      (list
       (make-mu4e-context    ;; me@kfring.com
	:name "me@kfring"
	:enter-func (lambda () (mu4e-message "Switch to the me@kfring context"))
	:match-func (lambda (msg)
		      (when msg
			(mu4e-message-maildir-matches msg "^/kfring")))
	:leave-func (lambda () (mu4e-clear-caches))
	:vars '(
		(user-mail-address     . "me@kfring.com")
		(user-full-name        . "Kyle Fring")
		(mu4e-sent-folder      . "/kfring/Sent")
		(mu4e-drafts-folder    . "/kfring/Drafts")
		(mu4e-trash-folder     . "/kfring/Trash")
		(mu4e-refile-folder    . "/kfring/All-Mail")
		)
	)
       )
      )

;; sending mail -- replace USERNAME with your gmail username
;; also, make sure the gnutls command line utils are installed
;; package 'gnutls-bin' in Debian/Ubuntu, 'gnutls' in Archlinux.

(require 'smtpmail)

(setq message-send-mail-function 'smtpmail-send-it
      starttls-use-gnutls t
      smtpmail-starttls-credentials
      '(("smtp.gmail.com" 587 nil nil))
      smtpmail-auth-credentials
      (expand-file-name "~/.authinfo.gpg")
      smtpmail-default-smtp-server "smtp.gmail.com"
      smtpmail-smtp-server "smtp.gmail.com"
      smtpmail-smtp-service 587
      smtpmail-debug-info t)

(use-package mu4e-conversation :ensure :after mu4e)
;; Use it everywhere
(global-mu4e-conversation-mode)

(use-package mu4e-alert :ensure
    :after mu4e
    :hook ((after-init . mu4e-alert-enable-mode-line-display)
           (after-init . mu4e-alert-enable-notifications))
    :config (mu4e-alert-set-default-style 'libnotify))

;; (use-package mu4e-alert
;;   :ensure t
;;   :after mu4e
;;   :init
;;   (setq mu4e-alert-interesting-mail-query
;;     (concat
;;      "flag:unread maildir:/Exchange/INBOX "
;;      "OR "
;;      "flag:unread maildir:/Gmail/INBOX"
;;      ))
;;   (mu4e-alert-enable-mode-line-display)
;;   (defun gjstein-refresh-mu4e-alert-mode-line ()
;;     (interactive)
;;     (mu4e~proc-kill)
;;     (mu4e-alert-enable-mode-line-display)
;;     )
;;   (run-with-timer 0 60 'gjstein-refresh-mu4e-alert-mode-line)
;;   )

(use-package elfeed
  :ensure t
  :demand
  :config
  :bind (:map elfeed-search-mode-map
              ("A" . kef/elfeed-show-all)
              ("U" . kef/elfeed-show-unread)
              ("C" . kef/elfeed-show-comics)
              ("N" . kef/elfeed-show-news)
              ("S" . kef/elfeed-show-starred)
              ("q" . kef/elfeed-save-db-and-bury)))
 (global-set-key (kbd "C-x r") 'kef/elfeed-load-db-and-open) ; r for reader

;; show all
(defun kef/elfeed-show-all ()
  (interactive)
  (bookmark-maybe-load-default-file)
  (bookmark-jump "elfeed-all"))
;; show just unread
(defun kef/elfeed-show-unread ()
  (interactive)
  (bookmark-maybe-load-default-file)
  (bookmark-jump "elfeed-unread"))
;; show me comics, mostly xkcd
(defun kef/elfeed-show-comics ()
  (interactive)
  (bookmark-maybe-load-default-file)
  (bookmark-jump "elfeed-comics"))
;; just news
(defun kef/elfeed-show-news ()
  (interactive)
  (bookmark-maybe-load-default-file)
  (bookmark-jump "elfeed-news"))
;; shortcut to jump to starred bookmark
(defun kef/elfeed-show-starred ()
  (interactive)
  (bookmark-maybe-load-default-file)
  (bookmark-jump "elfeed-starred"))

;; code to add and remove a starred tag to elfeed article
;; based on http://matt.hackinghistory.ca/2015/11/22/elfeed/
;; http://pragmaticemacs.com/emacs/star-and-unstar-articles-in-elfeed/#disqus_thread
;; more concise version from user: Galrog. Slick.

(defalias 'elfeed-toggle-star
 (elfeed-expose #'elfeed-search-toggle-all 'star))

(eval-after-load 'elfeed-search
 '(define-key elfeed-search-mode-map (kbd "m") 'elfeed-toggle-star))

;; tried *, but m requires one less hand and is closer to the "n" key which were using constantly in this mode.

;; (defface elfeed-search-starred-title-face
;;   '((t :foreground "#f77"))
;;   "Marks a starred Elfeed entry.")

;; (push '(starred elfeed-search-starred-title-face) elfeed-search-face-alist)

(defun kef/elfeed-load-db-and-open ()
  "Wrapper to load the elfeed db from disk before opening"
  (interactive)
  (elfeed-db-load)
  (elfeed)
  (elfeed-update))

;;write to disk when quiting
(defun kef/elfeed-save-db-and-bury ()
  "Wrapper to save the elfeed db to disk before burying buffer"
  (interactive)
  (elfeed-db-save)
  (quit-window))

(defun kef/show-elfeed (buffer)
    (with-current-buffer buffer
      (setq buffer-read-only nil)
      (goto-char (point-min))
      (re-search-forward "\n\n")
      (fill-individual-paragraphs (point) (point-max))
      (setq buffer-read-only t))
    (switch-to-buffer buffer))

(setq elfeed-show-mode-hook
      (lambda ()
    (set-face-attribute 'variable-pitch (selected-frame) :font (font-spec :family "IBM Plex Serif" :foundry "IBM " :height 100))
    (setq fill-column 120)
    (setq elfeed-show-entry-switch #'kef/show-elfeed)))

;; (use-package elfeed-goodies
;;   :ensure t
;;   :config
;;   (elfeed-goodies/setup))

(use-package elfeed-org
  :ensure t
  :requires (elfeed)
  :config
  ;; start
  (elfeed-org)
  ;; location of feed orgfile
  (setq rmh-elfeed-org-files (list "~/org/feeds.org")))

(use-package shell-pop
  :bind (("C-t" . shell-pop))
  :config
  (setq shell-pop-shell-type (quote ("ansi-term" "*ansi-term*" (lambda nil (ansi-term shell-pop-term-shell)))))
  (setq shell-pop-term-shell "/bin/bash")
  ;; need to do this manually or not picked up by `shell-pop'
  (shell-pop--set-shell-type 'shell-pop-shell-type shell-pop-shell-type))

(use-package which-key :ensure
  :config
  (which-key-mode)
  (setq which-key-idle-delay 1.0))

(use-package org
  :config
  (setq org-startup-indented t)           ;; Indent org-file display
  (setq org-src-tab-acts-natively t)
  )

(setq-default org-catch-invisible-edits 'smart)

(global-set-key (kbd "C-c l") 'org-store-link)
(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c c") 'org-capture)

(setq org-directory "~/org")

(setq org-refile-targets (quote ((org-agenda-files :maxlevel . 3))))

(setq org-outline-path-complete-in-steps nil)         ;; Refile in a single go
(setq org-refile-use-outline-path t)                  ;; Show full paths for refiling

(add-to-list 'auto-mode-alist '("\\.\\(org\\|org_archive\\)$" . org-mode))

(setq org-agenda-files '("~/org/life.org"
                         "~/.emacs.d/config.org"))

(setq org-agenda-skip-deadline-if-done t)

; Enable habit tracking
(setq org-modules (quote (org-habit)))

; position the habit graph on the agenda to the right of the default
(setq org-habit-graph-column 50)

(setq org-habit-show-habits-only-for-today t)
(set 'org-habit-show-all-today t)
(setq org-habit-graph-column 60)
(setq org-habit-following-days 3)

(setq org-habit-today-glyph ?‖)
(setq org-habit-completed-glyph ?✓)

(setq org-agenda-custom-commands
      '(("d" "Daily agenda and all TODOs"
         ((tags "PRIORITY=\"A\""
                ((org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
                 (org-agenda-overriding-header "High-priority unfinished tasks:")))
          (agenda "" ((org-agenda-ndays 1)))
          (alltodo ""
                   ((org-agenda-skip-function '(or (kef/org-skip-subtree-if-habit)
                                                   (kef/org-skip-subtree-if-priority ?A)
                                                   (org-agenda-skip-if nil '(scheduled deadline))))
                    (org-agenda-overriding-header "ALL normal priority tasks:"))))
         ((org-agenda-compact-blocks t)))))

(defun kef/org-skip-subtree-if-habit ()
  "Skip an agenda entry if it has a STYLE property equal to \"habit\"."
  (let ((subtree-end (save-excursion (org-end-of-subtree t))))
    (if (string= (org-entry-get nil "STYLE") "habit")
        subtree-end
      nil)))
(defun kef/org-skip-subtree-if-priority (priority)
  "Skip an agenda subtree if it has a priority of PRIORITY.

PRIORITY may be one of the characters ?A, ?B, or ?C."
  (let ((subtree-end (save-excursion (org-end-of-subtree t)))
        (pri-value (* 1000 (- org-lowest-priority priority)))
        (pri-current (org-get-priority (thing-at-point 'line t))))
    (if (= pri-value pri-current)
        subtree-end
      nil)))

(defun kef/pop-to-org-agenda (&optional split)
  "Visit the org agenda, in the current window or a SPLIT."
  (interactive "P")
  (org-agenda nil "d")
  (when (not split)
    (delete-other-windows)))

;; (global-set-key (kbd "s-s") 'kef/pop-to-org-agenda)  ;; We're not really using this? Maybe we are. Revist later

(setq org-src-fontify-natively t)

(setq org-todo-keywords
      (quote ((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)")
              (sequence "WAITING(w@/!)" "HOLD(h@/!)" "|" "CANCELED(c@/!)"))))

(setq org-todo-keyword-faces
      (quote (("NEXT" :foreground "cyan" :weight bold)
              ("DONE" :foreground "gray" :weight bold)
              ("WAITING" :foreground "orange" :weight bold)
              ("HOLD" :foreground "magenta" :weight bold)
              ("CANCELED" :foreground "gray" :weight bold))))

(setq org-treat-S-cursor-todo-selection-as-state-change nil)

(setq org-todo-state-tags-triggers
      (quote (("CANCELED" ("CANCELED" . t))
              ("WAITING" ("WAITING" . t))
              ("HOLD" ("WAITING") ("HOLD" . t))
              (done ("WAITING") ("HOLD"))
              ("TODO" ("WAITING") ("CANCELED") ("HOLD"))
              ("NEXT" ("WAITING") ("CANCELED") ("HOLD"))
              ("DONE" ("WAITING") ("CANCELED") ("HOLD")))))

(setq org-capture-templates '(("t" "Todo [life]" entry
                               ;; A list of things to do that I do NOT get direct compensation for.
                               ;; These things will get refiled into life.org or edu.org eventually.
                               ;; Think about if it is more efficacious to just put them in directly or do the whole weekly refile thing.
                               (file+headline "~/org/life.org" "INBOX")
                               "* TODO %i%? \n:PROPERTIES:\n:CREATED: %U\n:END:\n\n" :prepend t)

                              ;; A todo list for things I get paid money for.
                              ("w" "Todo [work]" entry (file+headline "~/org/life.org" "Tasks")
                               "* TODO %i%? \n:PROPERTIES:\n:CREATED: %U\n:END:\n\n" :prepend t)

                              ;; a place to keep ideas for some other time.  Ideas for Projects that we could maybe one-day accomplish
                              ("m" "New Idea" entry (file+headline "~/org/ideas.org" "Ideas")
                               "* WAITING %^{Short Description}\n:PROPERTIES:\n:CREATED: %U\n:END:\n%?%^{More details?}\n" :prepend t)

                              ;; general Note Capture
                              ("n" "Note" entry (file+headline "~/org/life.org" "INBOX")
                               "* %^{Title}\n:PROPERTIES:\n:CREATED: %U\n:END:\n%^{Content}" :prepend t)

                              ;; Album capture for weekly item.
                              ;; Artist Name: #main > div > div.Root__top-container > div.Root__main-view.Root__main-view--has-upsell-bar > div > div > div > section > div > div > div.col-xs-12.col-lg-3.col-xl-4 > div > header > div:nth-child(1) > div > div > div.mo-meta.ellipsis-one-line > div > a
                              ;; Album Name: #main > div > div.Root__top-container > div.Root__main-view.Root__main-view--has-upsell-bar > div > div > div > section > div > div > div.col-xs-12.col-lg-3.col-xl-4 > div > header > div:nth-child(1) > div > div > div:nth-child(1) > div.mo-info > div > div
                              ;; Album Artwork: #main > div > div.Root__top-container > div.Root__main-view.Root__main-view--has-upsell-bar > div > div > div > section > div > div > div.col-xs-12.col-lg-3.col-xl-4 > div > header > div:nth-child(1) > div > div > div:nth-child(1) > div.react-contextmenu-wrapper > div > div > div.cover-art-image.cover-art-image-loaded
                              ;; Album Year and Track #: #main > div > div.Root__top-container > div.Root__main-view.Root__main-view--has-upsell-bar > div > div > div > section > div > div > div.col-xs-12.col-lg-3.col-xl-4 > div > header > div.TrackListHeader__body > p

                              ;; Things to remove?
                              ;; Locallity
                              ;; Running Time
                              ;; Add Album cover?

                              ;; Not cute that we're using the year here, but file+headline does not support variables and it's one second every twelve months. Whatever.
                              ("a" "Album Notes" entry
                               (file+olp "~/org/life.org" "Albums" "2020")
                               "*** %u %^{Artist} - %^{Album Name}\n:PROPERTIES:\n:CREATED: %U\n:END:\n- Release: %^{Release}\n- Link: [[%^{URL}][Spotify]]\n- Tracks: %^{Tracks}\n- Playtime: %^{Playtime}\n- %^{Content}\n%?" :prepend t)

                              ;; Date-tree
                              ("j" "Journal" entry (file+datetree "~/org/journal.org")
                               "* %?\nEntered on %U\n  %i\n  %a")

                              ;; Climbing capture templates
                              ;; use %u for non-interactive time-stamps
                              ("r" "Route" table-line
                               (file+olp "~/org/life.org" "Climbing" "Routes")
                               "|%u|%?%^{Route Name?|NA}|%^{Yosemite Grade?|5.}|%^{Attempts?|0}|%^{Style?|Sport|Trad}|%^{Notes?}|")

                              ("b" "Boulder Problem" table-line
                               (file+olp "~/org/life.org" "Climbing" "Boulder Problems")
                               "|%u|%?%^{Problem Name?|NA}|%^{V-Grade?|NA}|%^{Attempts?|0}|%^{Notes?}|")
                              ))

(with-eval-after-load 'org-capture
  (defun org-hugo-new-subtree-post-capture-template ()
    "Returns `org-capture' template string for new Hugo post.
See `org-capture-templates' for more information."
    (let* ((title (read-from-minibuffer "Post Title: ")) ;Prompt to enter the post title
           (fname (org-hugo-slug title)))
      (mapconcat #'identity
                 `(
                   ,(concat "* TODO " title)
                   ":PROPERTIES:"
                   ,(concat ":EXPORT_FILE_NAME: " fname)
                   ":END:"
                   "%?\n")          ;Place the cursor here finally
                 "\n")))

  (add-to-list 'org-capture-templates
               '("h"                ;`org-capture' binding + h
                 "Hugo post"
                 entry
                 ;; It is assumed that below file is present in `org-directory'
                 ;; and that it has a "Blog Ideas" heading. It can even be a
                 ;; symlink pointing to the actual location of all-posts.org!
                 (file+olp "life.org" "kfring.com")
                 (function org-hugo-new-subtree-post-capture-template))))

(setq org-log-into-drawer t)

(setq org-log-done 'time)

(use-package org-bullets)
(setq org-bullets-bullet-list '("◉" "◎" "⚫" "○" "►" "◇"))
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))

(use-package org-pomodoro :ensure)

(use-package org-cliplink :ensure t)
(global-set-key (kbd "C-x c l") 'org-cliplink)

(use-package toc-org)
;; :after org
;; :hook (org-mode . toc-org-enable))

;; We want to set up toc-org-mode to ONLY EVER do its thing if the headline has the :TOC: tag.
;; (add-hook 'org-mode (lambda ()
                      ;; (unless (eq major-mode 'mu4e-compose-mode)
                      ;;   (toc-org-enable))))
;; (add-hook 'org~mu4e-mime-convert-to-html #'toc-org-mode -1)

(use-package org-indent :ensure nil :after org :delight)

(use-package pandoc-mode :ensure)

(use-package pdf-tools
  :ensure t
  :mode ("\\.pdf\\'" . pdf-view-mode)
  :config
  (pdf-tools-install)
  (setq-default pdf-view-display-size 'fit-page)
  (setq pdf-annot-activate-created-annotations t))

(use-package ox-hugo
  :ensure t
  :after ox)

(use-package hydra)
(use-package ivy-hydra)

(global-set-key
 (kbd "C-x t")
 (defhydra toggle (:color blue)
   "toggle"
   ("a" abbrev-mode "abbrev")
   ("s" flyspell-mode "flyspell")
   ("d" toggle-debug-on-error "debug")
   ("c" fci-mode "fCi")
   ("f" auto-fill-mode "fill")
   ("t" toggle-truncate-lines "truncate")
   ("w" whitespace-mode "whitespace")
   ("q" nil "cancel")))

(global-set-key
 (kbd "C-x j")
 (defhydra gotoline
   ( :pre (linum-mode 1)
          :post (linum-mode -1))
   "goto"
   ("t" (lambda () (interactive)(move-to-window-line-top-bottom 0)) "top")
   ("b" (lambda () (interactive)(move-to-window-line-top-bottom -1)) "bottom")
   ("m" (lambda () (interactive)(move-to-window-line-top-bottom)) "middle")
   ("e" (lambda () (interactive)(end-of-buffer)) "end")
   ("c" recenter-top-bottom "recenter")
   ("n" next-line "down")
   ("p" (lambda () (interactive) (forward-line -1))  "up")
   ("g" goto-line "goto-line")))

(global-set-key
 (kbd "C-c o")
 (defhydra hydra-global-org (:color blue)
   "Org"
   ("t" org-timer-start "Start Timer")
   ("s" org-timer-stop "Stop Timer")
   ("r" org-timer-set-timer "Set Timer") ; This one requires you be in an orgmode doc, as it sets the timer for the header
   ("p" org-timer "Print Timer") ; output timer value to buffer
   ("w" (org-clock-in '(4)) "Clock-In") ; used with (org-clock-persistence-insinuate) (setq org-clock-persist t)
   ("o" org-clock-out "Clock-Out") ; you might also want (setq org-log-note-clock-out t)
   ("j" org-clock-goto "Clock Goto") ; global visit the clocked task
   ("c" org-capture "Capture") ; Don't forget to define the captures you want http://orgmode.org/manual/Capture.html
   ("l" (or )rg-capture-goto-last-stored "Last Capture")))

(defhydra hydra-mu4e-headers (:color blue :hint nil)
  "
   ^General^   | ^Search^           | _!_: read    | _#_: deferred  | ^Switches^
  -^^----------+-^^-----------------| _?_: unread  | _%_: pattern   |-^^------------------
  _n_: next    | _s_: search        | _r_: refile  | _&_: custom    | _O_: sorting
  _p_: prev    | _S_: edit prev qry | _u_: unmk    | _+_: flag      | _P_: threading
  _]_: n unred | _/_: narrow search | _U_: unmk *  | _-_: unflag    | _Q_: full-search
  _[_: p unred | _b_: search bkmk   | _d_: trash   | _T_: thr       | _V_: skip dups
  _y_: sw view | _B_: edit bkmk     | _D_: delete  | _t_: subthr    | _W_: include-related
  _R_: reply   | _{_: previous qry  | _m_: move    |-^^-------------+-^^------------------
  _C_: compose | _}_: next query    | _a_: action  | _|_: thru shl  | _`_: update, reindex
  _F_: forward | _C-+_: show more   | _A_: mk4actn | _H_: help      | _;_: context-switch
  _o_: org-cap | _C--_: show less   | _*_: *thing  | _q_: quit hdrs | _j_: jump2maildir
  "

  ;; general
  ("n" mu4e-headers-next)
  ("p" mu4e-headers-previous)
  ("[" mu4e-select-next-unread)
  ("]" mu4e-select-previous-unread)
  ("y" mu4e-select-other-view)
  ("R" mu4e-compose-reply)
  ("C" mu4e-compose-new)
  ("F" mu4e-compose-forward)
  ("o" kef/org-capture-mu4e)                  ; differs from built-in

  ;; search
  ("s" mu4e-headers-search)
  ("S" mu4e-headers-search-edit)
  ("/" mu4e-headers-search-narrow)
  ("b" mu4e-headers-search-bookmark)
  ("B" mu4e-headers-search-bookmark-edit)
  ("{" mu4e-headers-query-prev)              ; differs from built-in
  ("}" mu4e-headers-query-next)              ; differs from built-in
  ("C-+" mu4e-headers-split-view-grow)
  ("C--" mu4e-headers-split-view-shrink)

  ;; mark stuff
  ("!" mu4e-headers-mark-for-read)
  ("?" mu4e-headers-mark-for-unread)
  ("r" mu4e-headers-mark-for-refile)
  ("u" mu4e-headers-mark-for-unmark)
  ("U" mu4e-mark-unmark-all)
  ("d" mu4e-headers-mark-for-trash)
  ("D" mu4e-headers-mark-for-delete)
  ("m" mu4e-headers-mark-for-move)
  ("a" mu4e-headers-action)                  ; not really a mark per-se
  ("A" mu4e-headers-mark-for-action)         ; differs from built-in
  ("*" mu4e-headers-mark-for-something)

  ("#" mu4e-mark-resolve-deferred-marks)
  ("%" mu4e-headers-mark-pattern)
  ("&" mu4e-headers-mark-custom)
  ("+" mu4e-headers-mark-for-flag)
  ("-" mu4e-headers-mark-for-unflag)
  ("t" mu4e-headers-mark-subthread)
  ("T" mu4e-headers-mark-thread)

  ;; miscellany
  ("q" mu4e~headers-quit-buffer)
  ("H" mu4e-display-manual)
  ("|" mu4e-view-pipe)                       ; does not seem built-in any longer

  ;; switches
  ("O" mu4e-headers-change-sorting)
  ("P" mu4e-headers-toggle-threading)
  ("Q" mu4e-headers-toggle-full-search)
  ("V" mu4e-headers-toggle-skip-duplicates)
  ("W" mu4e-headers-toggle-include-related)

  ;; more miscellany
  ("`" mu4e-update-mail-and-index)           ; differs from built-in
  (";" mu4e-context-switch)
  ("j" mu4e~headers-jump-to-maildir)

  ("." nil))

(bind-keys
 :map mu4e-headers-mode-map

 ("{" . mu4e-headers-query-prev)             ; differs from built-in
 ("}" . mu4e-headers-query-next)             ; differs from built-in
 ("o" . kef/org-capture-mu4e)                 ; differs from built-in

 ("A" . mu4e-headers-mark-for-action)        ; differs from built-in

 ("`" . mu4e-update-mail-and-index)          ; differs from built-in
 ("|" . mu4e-view-pipe)                      ; does not seem built-in any longer
 ("." . hydra-mu4e-headers/body))

`(defhydra hydra-elfeed ()
"filter"
("c" (elfeed-search-set-filter "@6-months-ago +cs") "cs")
("e" (elfeed-search-set-filter "@6-months-ago +emacs") "emacs")
("d" (elfeed-search-set-filter "@6-months-ago +education") "education")
("*" (elfeed-search-set-filter "@6-months-ago +star") "Starred")
("M" elfeed-toggle-star "Mark")
("A" (elfeed-search-set-filter "@6-months-ago") "All")
("T" (elfeed-search-set-filter "@1-day-ago") "Today")
("Q" bjm/elfeed-save-db-and-bury "Quit Elfeed" :color blue)
("q" nil "quit" :color blue))
