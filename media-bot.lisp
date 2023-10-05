;;;; media-bot.lisp

(defpackage #:media-bot
  (:use #:cl #:with-user-abort)
  (:import-from :simple-config
   :config)
  (:import-from :unix-opts
   :define-opts
   :get-opts)
  (:import-from :glacier
   :on
   :post
   :run-bot
   :mastodon-bot)
  (:export :main))

(in-package #:media-bot)

(defmacro print-and-quit (status message &rest args)
  `(progn
     (format t (concatenate 'string ,message "~%") ,@args)
     (uiop:quit ,status)))

(defun string->keyword (str)
  (intern (string-upcase str) :keyword))

(defun validate-day (day)
  (car
   (member (string->keyword day)
           '(:sunday :monday :tuesday :wednesday
             :thursday :friday :saturday))))

(defun validate-visibility (vis)
  (car
   (member (string->keyword vis)
           '(:public :unlisted :private :direct))))

(define-opts
  (:name :config
   :short #\c
   :long "config"
   :description "config file to use"
   :arg-parser #'identity)
  (:name :help
   :short #\h
   :long "help"
   :description "prints this help")
  (:name :alt-text
   :short #\a
   :long "alt-text"
   :description "alt text to post for supplied media (enclose in quotes)"
   :arg-parser #'identity
   :meta-var "ALT-TEXT")
  (:name :media
   :short #\m
   :long "media"
   :description "media to post"
   :arg-parser #'pathname
   :meta-var "MEDIA")
  (:name :day
   :short #\d
   :long "day"
   :description "day to make the post"
   :arg-parser #'validate-day
   :meta-var "DAY")
  (:name :time
   :short #\t
   :long "time"
   :description "time to make the post in the format HH:MM"
   :arg-parser #'identity
   :meta-var "TIME")
  (:name :visibility
   :short #\v
   :long "visibility"
   :description "visibility of post (defaults to unlisted)"
   :arg-parser #'validate-visibility
   :meta-var "VISIBILITY")
  (:name :is-sensitive
   :short #\s
   :long "sensitive"
   :description "if provided, the media will be marked as sensitive when posted")
  (:name :version
   :long "version"
   :description "prints the version"))

(defun main ()
  (multiple-value-bind (opts args) (get-opts)
    (when (getf opts :version)
      (print-and-quit 0 "media-bot v~A"
                      #.(asdf:component-version (asdf:find-system :media-bot))))

    (when (getf opts :help)
      (opts:describe :usage-of "media-bot")
      (uiop:quit 0))

    (unless (getf opts :config)
      (print-and-quit 1 "please specify path to config file"))

    (unless (getf opts :day)
      (print-and-quit 1 "please specify a proper day"))

    (unless (getf opts :time)
      (print-and-quit 1 "please specify a proper timestring (see help)"))

    (unless (getf opts :media)
      (print-and-quit 1 "please specify media to post"))

    (handler-case
        (with-user-abort
          (run-bot ((make-instance 'mastodon-bot :config-file (getf opts :config))
                    :with-websocket nil)
            (on ((getf opts :day) :at (getf opts :time))
              (post (config :post-status)
                    :visibility (getf opts :visibility :unlisted)
                    :media (if (getf opts :alt-text)
                               `((,(getf opts :media) ,(getf opts :alt-text)))
                               (getf opts :media))
                    :sensitive (getf opts :is-sensitive)))))
      
      (user-abort ()
        (uiop:quit 0))

      (error (e)
        (print-and-quit 1 "~A" e)))))
