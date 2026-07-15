;;; outline-occur.el --- Navigate the buffer's outline using `occur' -*- lexical-binding: t -*-

;; Copyright (C) 2026 Roi Martin

;; Author: Roi Martin <jroi.martin@gmail.com>
;; Version: 1.0.50
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
;; outline using `occur'.  The variables `outline-occur-regexp-alist'
;; and `outline-regexp' determine how to find the outline headings.

;;; Code:

(require 'outline)

(defgroup outline-occur nil
  "Buffer outline navigation based on `occur'."
  :group 'matching)

(defcustom outline-occur-regexp-alist nil
  "Alist of regexps matching outline headings for major modes.
Each element has the form (MAJOR-MODE . REGEXP).  MAJOR-MODE is a
symbol, a list of symbols or a regular expression that matches the major
mode name.  REGEXP is a regular expression that matches the outline
headings in that major mode."
  :type '(alist :tag "Outline heading regexps"
		:key-type (choice :tag "Major mode"
				  (symbol :tag "Name")
				  (repeat :tag "List of names" symbol)
				  (string :tag "Regexp"))
		:value-type (string :tag "Regexp")))

(defun outline-occur--key-match-p (alist-key key)
  "Return non-nil if KEY matches ALIST-KEY.
This function is used as a custom TESTFN to look up keys in
`outline-occur-regexp-alist'."
  (cond
   ((listp alist-key) (memq key alist-key))
   ((stringp alist-key) (string-match-p alist-key (symbol-name key)))
   (t (eq alist-key key))))

;;;###autoload
(defun outline-occur ()
  "Navigate the current buffer's outline using `occur'.
The regular expression passed to `occur' depends on the current buffer's
major mode, as configured in the `outline-occur-regexp-alist' variable.
If the current major mode has no entry in that alist, this function
falls back to `outline-regexp' to find the start of headings."
  (interactive)
  (if-let* ((regexps (or (alist-get major-mode outline-occur-regexp-alist
				    nil nil #'outline-occur--key-match-p)
			 (and outline-regexp (concat "^\\(?:" outline-regexp "\\)")))))
      (let ((occur-hook (lambda () (pop-to-buffer "*Occur*"))))
	(occur regexps))
    (user-error "Unsupported major mode")))

(provide 'outline-occur)

;;; outline-occur.el ends here
