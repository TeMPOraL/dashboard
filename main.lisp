(load (merge-pathnames "quicklisp/setup.lisp" (user-homedir-pathname)))

(ql:quickload 'cl-ppcre)
(ql:quickload 'local-time)

;;; Copied from http://chaitanyagupta.com/lisp/restarts.html#sec-4
(defun parse-csv-file (file)
  (with-open-file (f file :direction :input)
    (loop
       for line = (read-line f nil)
       while line
       collect (cl-ppcre:split "," line))))

;;; MoneyWise stuff
(defun parse-moneywise-expense-type (expense-type)
  (if (string= expense-type "Income")
      :income
      :expense))

(defun parse-moneywise-csv-line (line)
  (list (local-time:parse-timestring (first line)) ; transaction date
        (read-from-string (seventh line)) ; amount (negative for expenses)
        (eighth line)                   ; currency
        (parse-moneywise-expense-type (sixth line)) ;:INCOME or :EXPENSE
        (third line)                    ; category ("Groceries", "Transportation", etc.)
        (fourth line)))                 ; description
