;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; appearance
(setq doom-font (font-spec :family "Iosevka Curly" :size 14)
    doom-variable-pitch-font (font-spec :family "Iosevka Curly" :size 14))
(setq doom-theme 'doom-palenight)
(setq display-line-numbers-type t)

;; elfeed configuration
(require 'elfeed)
(require 'elfeed-org)
(elfeed-org)
(setq rmh-elfeed-org-files (list "~/Dropbox/org/elfeed.org"))
(require 'elfeed-goodies)
(elfeed-goodies/setup)

;; mu4e configuration
(add-to-list 'load-path "/usr/share/emacs/site-lisp/mu4e")
(require 'mu4e)
(require 'smtpmail)
(setq mail-user-agent 'mu4e-user-agent)
(setq mu4e-maildir "~/.mail"
    mu4e-attachment-dir "~/downloads"
    mu4e-sent-folder "/sent"
    mu4e-drafts-folder "/drafts"
    mu4e-trash-folder "/trash"
    mu4e-refile-folder "/archive")
(setq message-send-mail-function 'smtpmail-send-it) ;; sending mail
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
(setq mu4e-get-mail-command "mbsync -a" ;; syncing mail
    mu4e-change-filenames-when-moving t
    mu4e-update-interval 120)
(setq mu4e-sent-messages-behavior 'delete)

;; org configuration
(after! org
  (setq org-directory "~/Dropbox/org")
  (setq org-agenda-files '("~/Dropbox/org/agenda.org"))
)
