;; swa-org.el --- personal orgmode configuration -*- lexical-binding: t; -*-

;;; Locations of orgmode files

(setq org-directory (f-join rangoli/home-dir "org/")
      org-default-notes-file (f-join rangoli/shared-home-dir "inbox.org"))

;;; Overall Behavior customization

(setq
 ;; Agenda display
 ;; Don't display `%c', i.e. category, i.e. file name
 org-agenda-prefix-format  '((agenda . " %i %?-12t% s")
                             (todo . " %i")
                             (tags . " %i")
                             (search . " %i %-12:c"))

 org-agenda-use-time-grid nil 
 )

;;; Todo states

;; ! indicates insert timestamp
;; @ indicates insert note
;; / indicates entering/exiting the state
(setq org-todo-keywords
      '((sequence "TODO(t)" "PROJECT(p)" "NEXT(n)" "REPEAT(r)" "DELEGATED(g)" "WAITING(w)" "SOMEDAY/MAYBE(s)"
		  "|"
		  "DONE(d)" "CANCELLED(c@)"
                  "|"
                  "REMEMBER(m)"))

      org-todo-repeat-to-state "REPEAT")

;;; Agenda

(defun rangoli/org-files ()
  (-concat
   (list org-default-notes-file)
   (f-files org-directory (-partial 's-matches? "\\.org$"))))

(defun rangoli/org-files-work ()
  (-filter (-partial 's-matches? "2_area_work.org") (rangoli/org-files)))

(defun rangoli/org-files-personal ()
  (-remove (-partial 's-matches? "2_area_work.org") (rangoli/org-files)))

(setq org-agenda-files (rangoli/org-files))

(defun rangoli/reload-org-agenda-files ()
  (interactive)
  (setq org-agenda-files (rangoli/org-files)))

;; https://orgmode.org/manual/Block-agenda.html
;; https://orgmode.org/worg/org-tutorials/org-custom-agenda-commands.html
(setq org-agenda-custom-commands
      '(("e" "Everything"
	 ((agenda "")
          (todo "NEXT")
          (todo "REMEMBER"))
         ((org-agenda-files (rangoli/org-files))))
        ("w" "Work"
	 ((agenda "")
          (todo "NEXT"))
         ((org-agenda-files (rangoli/org-files-work))))
        ("p" "Personal"
	 ((agenda "")
          (todo "NEXT")
          (todo "REMEMBER"))
         ((org-agenda-files (rangoli/org-files-personal))))))

;;; Capture templates

;; https://orgmode.org/manual/Template-elements.html

(setq org-capture-templates
      (list
       (list "i"
             "Inbox"
             'entry
             (list 'file+headline org-default-notes-file
                   "Inbox")
             "* %?\n%U\n%i\n")

       (list "w"
             "Work"
             'entry
             (list 'file+headline (concat org-directory "2_area_work.org")
                   "Inbox")
             "* %?\n%U\n%i\n")

       (list "a"
             "Achievement"
             'entry
             (list 'file+olp+datetree (concat org-directory "4_archive_achievement.org"))
             "* %?\n%i\n")

       (list "d"
             "Diary"
             'entry
             (list 'file+olp+datetree (concat org-directory "4_archive_diary.org"))
             "* %?\n%i\n")))

(defun rangoli/jump-work ()
  "Jump to work file."
  (interactive)
  (find-file (f-join org-directory "2_area_work.org")))

(rangoli/set-leader-key "o w" 'rangoli/jump-work "work file")

(provide 'swa-org)
;; swa-org.el ends here
