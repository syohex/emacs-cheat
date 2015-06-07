;;; cheat.el --- cheat command from Emacs

;; Copyright (C) 2015 by Syohei YOSHIDA

;; Author: Syohei YOSHIDA <syohex@gmail.com>
;; URL: https://github.com/syohex/emacs-cheat
;; Version: 0.01
;; Package-Requires: ((cl-lib "0.5"))

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; `cheat' command from Emacs

;;; Code:

(require 'cl-lib)
(require 'ansi-color)

(defvar cheat--history nil)

(defun cheat--list ()
  (with-temp-buffer
    (unless (process-file "cheat" nil t nil "list")
      (error "Failed: 'cheat list'"))
    (goto-char (point-min))
    (cl-loop while (not (eobp))
             collect (buffer-substring-no-properties
                      (line-beginning-position) (line-end-position))
             do
             (forward-line 1))))

(defun cheat--show (command)
  (with-current-buffer (get-buffer-create "*cheat*")
    (setq buffer-read-only nil)
    (erase-buffer)
    (unless (process-file "cheat" nil t nil "show" command)
      (error "Failed: 'cheat show %s'" command))
    (goto-char (point-min))
    (ansi-color-apply-on-region (point-min) (point-max))
    (setq buffer-read-only t)
    (pop-to-buffer (current-buffer))))

;;;###autoload
(defun cheat (command)
  (interactive
   (list (completing-read "Command: " (cheat--list) nil t nil 'cheat--history)))
  (cheat--show command))

(provide 'cheat)

;;; cheat.el ends here
