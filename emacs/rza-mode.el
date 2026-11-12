;;; -*- lexical-binding: t; -*-

(require 'prog-mode)

(defconst rza-opcodes
  '("cav" "res" "med" "raise" "decay" "probe" "load" "loadb"
    "mov" "store" "storeb" "slt" "inc" "dec" "await" "print"
    "jmp" "brz" "brnz" "call" "proc" "casc" "acasc" "endc" "ret"
    "layout" "add" "sub" "mul" "div" "mod" "and" "or" "xor"
    "shl" "shr"))

(defconst rza-scalar-types '("u8" "i64"))

(defconst rza-font-lock-keywords
  `((,(regexp-opt rza-opcodes 'symbols) . font-lock-keyword-face)
    (,(regexp-opt rza-scalar-types 'symbols) . font-lock-builtin-face)
    ("\\<[A-Z][A-Za-z0-9_]*\\>" . font-lock-type-face)
    ("\\_<field\\_>" . font-lock-constant-face)
    ("%r\\(?:[0-9]\\|1[0-5]\\)\\_>" . font-lock-variable-name-face)
    ("\\]\\.\\([a-z_][a-z0-9_]*\\)" 1 font-lock-builtin-face)
    ("\\_<proc[ \t]+\\([a-z_][a-z0-9_]*\\):" 1 font-lock-function-name-face)
    ("^[ \t]*\\([a-z_][a-z0-9_]*\\):" 1 font-lock-function-name-face)
    ("\\(?:^\\|[^A-Za-z0-9_]\\)\\(-?0x[0-9A-Fa-f]+\\)\\_>" 1 font-lock-constant-face)
    ("\\(?:^\\|[^A-Za-z0-9_]\\)\\(-?[0-9]+\\)\\_>" 1 font-lock-constant-face)))

(defvar rza-mode-syntax-table
  (let ((table (make-syntax-table)))
    (modify-syntax-entry ?\; "<" table)
    (modify-syntax-entry ?\n ">" table)
    table))

(define-derived-mode rza-mode prog-mode "RZA"
  "Major mode for RZA assembly."
  :syntax-table rza-mode-syntax-table
  (setq-local font-lock-defaults '(rza-font-lock-keywords))
  (setq-local comment-start "; ")
  (setq-local comment-end ""))

(add-to-list 'auto-mode-alist '("\\.rza\\'" . rza-mode))

(provide 'rza-mode)
