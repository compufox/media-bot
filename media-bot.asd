;;;; media-bot.asd

(asdf:defsystem #:media-bot
  :description "mastodon bot that posts provided media file(s) at specified days & times"
  :author "a. fox"
  :license  "NVPLv1+"
  :version "0.1.0"
  :serial t
  :depends-on (#:glacier #:simple-config #:with-user-abort #:unix-opts)
  :components ((:file "media-bot"))
  :entry-point "media-bot:main"
  :build-operation "program-op"
  :build-pathname "bin/media-bot")

#+sb-core-compression
(defmethod asdf:perform ((o asdf:image-op) (c asdf:system))
  (uiop:dump-image (asdf:output-file o c) :executable t :compression t))
