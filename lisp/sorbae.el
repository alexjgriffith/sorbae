;;; sorbae.el --- Data Entry Assistance for Compliance Advisory  -*- lexical-binding: t -*-

;; Copyright (C) 2019 Alexander Griffith
;; Author: Alexander Griffith <griffitaj@gmail.com>
;; Version: 0.1.0
;; Package-Requires: ((emacs "26.3"))
;; Homepage: https://github.com/alexjgriffith/sorbae

;; This file is not part of GNU Emacs.

;; This file is part of sorbae.el.

;; sorbae.el is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; sorbae.el is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with sorbae.el.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;;; Code:
(defvar sorbae-brands-flavours
  '(("Sorbae Raspberry Sour Apple" "Sour Apple" SA)
    ("Sorbae Peach Apricot" "Peach Apricot" PA )
    ("Sorbae Blueberry Kiwi" "Blueberry Kiwi" BK)
    ("Sorbae Mango Lychee" "Mango Lychee" ML)
    ("Sorbae Passion Fruit Aloe"  "Passion Fruit Aloe" PF)
    ("Sorbae Grapefruit Watermelon" "Grapefruit Watermelon" GW)
    ("Sorbae Pomegranate Orange" "Pomegranate Orange" PO)
    ("Sorbae Raspberry Jackfruit" "Raspberry Jackfruit" JF)
    ("Sorbae Strawberry Guava" "Strawberry Guava" SG)
    ("Sorbae Watermelon Honeydew" "Watermelon Honeydew" WH)
    ("Sorbae Pineapple Guava" "Pineapple Guava" PG)
    ("Sorbae Apple Berry" "Apple Berry" AB)
    ("Sorbae Salts Blueberry Kiwi" "Salts Blueberry Kiwi" SBK)
    ("Sorbae Salts Grapefuit Watermelon" "Salts Grapefuit Watermelon" SGW)
    ("Sorbae Salts Apple Berry" "Salts Apple Berry" SAB)
    ("Sorbae Salts Strawberry Guava" "Salts Strawberry Guava" SSG)
    ("Sorbae Salts Watermelon Honeydew" "Salts Watermelon Honeydew" SWH)
    ("Sorbae Salts Pineapple Guava" "Salts Pineapple Guava" SPG )
    ("Sorbae Salts Mango Lychee" "Salts Mango Lychee" SML)
    ("Sorbae Salts Passionfruit Aloe" "Salts Passionfruit Aloe" SPF )
    ("Sorbae Salts Peach Apricot" "Salts Peach Apricot" SPA)
    ("Sorbae Salts Pomegrenate Orange" "Salts Pomegrenate Orange" SPO )
    ("Sorbae Salts Raspberry Jackfruit" "Salts Raspberry Jackfruit" SJF)
    ("Sorbae Salts Raspberry Sour Apple" "Salts Raspberry Sour Apple" SSA))
  "List of current Sorbae branded flavours.")

(defun sorbae-brands-code-to-name (code)
  "Convert CODE to brand as stored in `sorbae-brands-flavours'."
  (caar (remove-if-not (lambda(x) (equal code (caddr x))) sorbae-brands-flavours)))

(defun sorbae-brands-list-to-table (list &optional offset first)
  "Convert LIST containing brands to a table.
Optional arguments OFFSET and FIRST
OFFSET how many columns from the front should the table be offset.
FIRST should there be text infront of the first entry.
Note, FIRST overrides OFFSET for the first row."
  (let ((offset (or offset 0))
        (return "")
        (code (pop list))
        (count (pop list)))
    (while (and code count)
      (setq return (concat
                    return
                    (if (not first)
                        (concat "\n"
                                (make-string offset ?,))
                      (progn (setq first nil)
                             nil))
                    (sorbae-brands-code-to-name code)
                    ", "
                    (number-to-string count)))
      (setq code (pop list))
      (setq count (pop list)))
    return))

(defmacro sorbae-brands-insert-table-macro (&rest list)
  "Insert a LIST of brand codes as a table of brands."
  (insert (sorbae-brands-list-to-table list)))

(defmacro sorbae-mwtm
    (inspector establishment region date &rest list)
  "Make working table.
INSPECTOR who inspected the ESTABLISHMENT
REGION which region did the inspection take place in
DATE on which date did the inspection take place (can't contain ,)
LIST list of codes and counts e.g. PG 1 SG 4 ..."
  (concat inspector "," establishment "," region "," date ","
          (sorbae-brands-list-to-table list 4 't)))

(defun sorbae-insert-multi (&rest strings)
  "Insert multiple STRINGS seperated by newlines."
  (insert (mapconcat 'identity strings "\n")))

(defun sorbae-example ()
  "A sample of how to enter data using sorbe.el."
  (sorbae-insert-multi
   (sorbae-mwtm
    "Inspector A" "Estamlishment 1" "Region 0" "2019-10-1"
    GW 3 SA 2 SG 5 SG 5 SA 3 GW 4)
   (sorbae-mwtm
    "Inspector B" "Establishment 2" "Region 0" "2019-11-1"
    SA 1)
   (sorbae-mwtm
    "Inspector C" "Establishment 3" "Region 0" "2019-11-01"
    PG 1 PG 1 SG 2 SG 2 SG 1 SA 2 PA 1 BK 1 BK 2 BK 1 AB 1 AB 2 ML 1 ML 1
    ML 1 ML 2 ML 1 PA 2 SA 1 SA 2 BK 1 BK 1 BK 2 SG 2 SG 2 PO 1 PO 2 PO 1
    GW 1 GW 1 GW 1 PF 1 PF 1)))

(provide 'sorbae)
;;; sorbae.el ends here
