;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; mu4e configuration
(require 'mu4e)
(require 'smtpmail)
(setq mail-user-agent 'mu4e-user-agent)
(setq mu4e-maildir "~/.mail"
    mu4e-attachment-dir "~/downloads"
    mu4e-sent-folder "/sent"
    mu4e-drafts-folder "/drafts"
    mu4e-trash-folder "/trash"
    mu4e-refile-folder "/archive")
 ;; sending mail
(setq message-send-mail-function 'smtpmail-send-it)
(setq mu4e-contexts
    `( ,(make-mu4e-context
	  :name "pm"
	  :enter-func (lambda () (mu4e-message "Entering protonmail context"))
          :leave-func (lambda () (mu4e-message "Leaving protonmail context"))
	  :match-func (lambda (msg)
			(when msg
			  (mu4e-message-contact-field-matches msg
			    :to "bryan@bryanbean.com")))
	  :vars '( (user-mail-address . "bryan@bryanbean.com")
		   (user-full-name . "Bryan Bean")
                   (smtpmail-default-smtp-server . "127.0.0.1") 
                   (smtpmail-smtp-server . "127.0.0.1")
                   (smtpmail-smtp-service . 1025)
                   (smtpmail-auth-credentials . "~/authinfo.gpg")))
       ,(make-mu4e-context
	  :name "gm"
	  :enter-func (lambda () (mu4e-message "Entering gmail context"))
	  :leave-func (lambda () (mu4e-message "Leaving gmail context"))
	  :match-func (lambda (msg)
			(when msg
			  (mu4e-message-contact-field-matches msg
			    :to "bryanandersbean@gmail.com")))
	  :vars '( (user-mail-address . "bryanandersbean@gmail.com")
		   (user-full-name . "Bryan Bean")
 		   (starttls-use-gnutls . t)
 		   (smtpmail-default-smtp-server . "smtp.gmail.com")
                   (smtpmail-smtp-server . "smtp.gmail.com")
                   (smtpmail-smtp-service . 587)
                   (smtpmail-auth-credentials . "~/authinfo.gpg")))))
 ;; syncing mail
(setq mu4e-get-mail-command "mbsync -a"
    mu4e-change-filenames-when-moving t
    mu4e-update-interval 120)
(setq mu4e-sent-messages-behavior 'delete)

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
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-laserwave)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
