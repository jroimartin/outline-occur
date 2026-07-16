;;; outline-occur.el --- Navigate the buffer's outline using `occur' -*- lexical-binding: t -*-

;; Copyright (C) 2026 Roi Martin

;; Author: Roi Martin <jroi.martin@gmail.com>
;; Version: 1.0.50
;; Package-Requires: ((emacs "26.1"))
;; Keywords: matching, outlines
;; URL: https://github.com/jroimartin/outline-occur

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; Run the `outline-occur' command to navigate the current buffer's
;; outline using `occur'.  The `outline-regexp' variable is used to
;; find the beginning of the outline headings.  The
;; `outline-occur-regexp-override-alist' variable allows overriding
;; this regexp per major mode.

;;; Code:

(require 'outline)

(defgroup outline-occur nil
  "Buffer outline navigation based on `occur'."
  :group 'matching)

(defcustom outline-occur-regexp-override-alist nil
  "Alist that overrides `outline-regexp' for specific major modes.
Each element has the form (MAJOR-MODE . REGEXP).  MAJOR-MODE is a
symbol, a list of symbols or a regexp that matches the major mode name.
REGEXP is a regexp that matches the beginning of the outline headings in
that major mode.  Any line whose beginning matches this regexp is
considered to start a heading.  As Outline mode does with
`outline-regexp', `outline-occur' only checks this regexp at the start
of a line, so the regexp need not (and usually does not) start with `^'."
  :type '(alist :tag "Outline heading regexps"
		:key-type (choice :tag "Major mode"
				  (symbol :tag "Name")
				  (repeat :tag "List of names" symbol)
				  (string :tag "Regexp"))
		:value-type (string :tag "Regexp")))

(defun outline-occur--key-match-p (alist-key key)
  "Return non-nil if KEY matches ALIST-KEY.
This function is used as a custom TESTFN to look up keys in
`outline-occur-regexp-override-alist'."
  (cond
   ((listp alist-key) (memq key alist-key))
   ((stringp alist-key) (string-match-p alist-key (symbol-name key)))
   (t (eq alist-key key))))

;;;###autoload
(defun outline-occur ()
  "Navigate the current buffer's outline using `occur'.
The `outline-regexp' variable is used to find the beginning of the
outline headings.  The `outline-occur-regexp-override-alist' variable
allows overriding this regexp per major mode."
  (interactive)
  (if-let* ((regexp (or (alist-get major-mode outline-occur-regexp-override-alist
				   nil nil #'outline-occur--key-match-p)
			outline-regexp)))
      (let ((occur-hook (lambda () (pop-to-buffer "*Occur*"))))
	(occur (concat "^\\(?:" regexp "\\)")))
    (user-error "No outline regexp defined")))

(provide 'outline-occur)

;;; outline-occur.el ends here
