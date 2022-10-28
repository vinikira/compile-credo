;;; compile-credo.el --- Configures compilation-mode to support Credo warnings -*- lexical-binding: t -*-

;; Author: Vinícius Simões
;; Maintainer: Vinícius Simões
;; Version: 0.0.1
;; Package-Requires: (emacs26)
;; Homepage: https://github.com/vinikira/compile-credo
;; Keywords: emacs elixir credo compilation


;; This file is not part of GNU Emacs

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

;;; Code:

(require 'compile)

;;;###autoload
(defun compile-credo--find-filename ()
  "Find the file name for current credo error/warning."
  (save-match-data
    (save-excursion
      (beginning-of-line)
      (when (re-search-forward "\\([a-zA-Z0-9/_.]+\.exs?\\)")
        `(,(match-string 1) . ,default-directory)))))

(with-eval-after-load 'compile
  (let ((form `(credo
                "\\([a-zA-Z0-9/_.]+\.exs?:\\([0-9]+\\):?\\([0-9]+\\)?\\)"
                compile-credo--find-filename
                2 3 1 1)))
    (if (assq 'credo compilation-error-regexp-alist-alist)
        (setf (cdr (assq 'credo compilation-error-regexp-alist-alist)) (cdr form))
      (push form compilation-error-regexp-alist-alist))
    (add-to-list 'compilation-error-regexp-alist 'credo)))

(provide 'compile-credo)

;;; compile-credo.el ends here
