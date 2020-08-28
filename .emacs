;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(require 'mu4e)
(require 'smtpmail)
(package-initialize)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["black" "#d55e00" "#009e73" "#f8ec59" "#0072b2" "#cc79a7" "#56b4e9" "white"])
 '(custom-enabled-themes (quote (tsdh-dark)))
 '(inhibit-startup-screen t)
 '(menu-bar-mode nil)
 '(scroll-bar-mode nil)
 '(tool-bar-mode nil)
 '(tooltip-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )



 ;; mu4e configuration

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

