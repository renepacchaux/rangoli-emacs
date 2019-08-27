;; rangoli-snippet.el --- yasnippet configuration -*- lexical-binding: t; -*-

;;; Packages

(straight-use-package 'yasnippet)
(straight-use-package 'yasnippet-snippets)
(straight-use-package 'ivy-yasnippet)

;;; YASnippet + snippet expansion

(require 'yasnippet)
(when (f-exists? rangoli/private-emacs-config-dir)
  ;; I want snippets stored only in my private emacs config repository, /not/ in the public rangoli-emacs repository.
  ;; http://joaotavora.github.io/yasnippet/snippet-organization.html#org10ee311
  (setq yas-snippet-dirs (-remove
                        (lambda (item) (s-equals? (f-expand "~/.emacs.d/snippets") item))
                        yas-snippet-dirs))
  (add-to-list 'yas-snippet-dirs (f-join rangoli/private-emacs-config-dir "snippets")))
(yas-global-mode 1)
(diminish 'yas-minor-mode)

(rangoli/set-leader-key "i s" 'ivy-yasnippet "snippet")

(add-to-list 'hippie-expand-try-functions-list ' yas-hippie-try-expand)

(provide 'rangoli-snippet)
;; rangoli-snippet.el ends here


