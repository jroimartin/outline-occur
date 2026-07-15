;;; outline-occur-tests.el --- ERT tests for outline-occur.el -*- lexical-binding: t -*-

;; Copyright (C) 2026 Roi Martin

;; Author: Roi Martin <jroi.martin@gmail.com>

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

;; Tests for the `outline-occur' feature.

;;; Code:

(require 'ert)
(require 'outline-occur)

(ert-deftest outline-occur-tests--outline-occur--key-match-p ()
  "Test the `outline-occur--key-match-p' function."
  (let ((regexp-alist '((a . "regexp-a")
			((b c) . "regexp-b-c")
			(".?d.?" . "regexp-d"))))
    (should (string-equal (alist-get 'a regexp-alist nil nil #'outline-occur--key-match-p)
			  "regexp-a"))
    (should (string-equal (alist-get 'b regexp-alist nil nil #'outline-occur--key-match-p)
			  "regexp-b-c"))
    (should (string-equal (alist-get 'c regexp-alist nil nil #'outline-occur--key-match-p)
			  "regexp-b-c"))
    (should (string-equal (alist-get 'abcdefg regexp-alist nil nil #'outline-occur--key-match-p)
			  "regexp-d"))
    (should (string-equal (alist-get 'd regexp-alist nil nil #'outline-occur--key-match-p)
			  "regexp-d"))
    (should-not (alist-get 'e regexp-alist nil nil #'outline-occur--key-match-p))))


(provide 'outline-occur-tests)

;;; outline-occur-tests.el ends here
