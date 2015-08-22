;; .emacs
(setq inhibit-splash-screen t)

(setq additional-paths '("/IDE/emacs" "/IDE/emacs/auto-complete" "/IDE/emacs/popup" "/IDE/emacs/fuzzy"))
(setq load-path (append additional-paths load-path))
;(require 'auto-complete-config)
;(ac-config-default)
;(require 'auto-complete-clang)
;(require 'sr-speedbar)
(ffap-bindings)

;(load "desktop")
;(desktop-load-default)
(autoload 'verilog-mode "verilog-mode" "Verilog mode" t )
(add-to-list 'auto-mode-alist '("\\.[ds]?vh?\\'" . verilog-mode))
(add-hook 'verilog-mode-hook '(lambda () (font-lock-mode 1)))

;(require 'cua)
(cua-mode t)
(setq cua-auto-tabify-rectangles nil) ;; Don't tabify after rectangle commands
(transient-mark-mode 1) ;; No region when it is not highlighted
;(setq cua-keep-region-after-copy t) ;; Standard Windows behaviour
 ;; shift + click select region
(define-key global-map (kbd "<S-down-mouse-1>") 'ignore) ; turn off font dialog
(define-key global-map (kbd "<S-mouse-1>") 'mouse-set-point)
(put 'mouse-set-point 'CUA 'move)
;(pc-selection-mode)
(setq x-select-enable-clipboard t)
;(setq default-fill-column 80)

(custom-set-variables '(comint-completion-fignore '( "~" "#" "%" ".o")))
(custom-set-variables '(next-line-add-newlines nil))
(auto-compression-mode)
(setq make-backup-files nil)
(global-set-key "\C-e" 'goto-match-paren)
(defun goto-match-paren (arg)
  "Go to the matching parenthesis if on parenthesis, otherwise insert %.
vi style of % jumping to matching brace."
  (interactive "p")
  (cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
        ((looking-at "\\s\)") (forward-char 1) (backward-list 1))
        (t (self-insert-command (or arg 1)))))


;(defcustom comint-password-prompt-regexp
;"\\(\\|[Oo]ld \\|[Nn]ew \\|keyberoa \\|'s \\|login \\|^CVS \\|^[Pp]assword\\ (again)\\? \\|pass phrase \\|Enter passphrase \\)\ \\(for [^@ \t\n] + @[^@ \t\n]+\\)?:\\s *\\'"
;(Regexp matching prompts for passwords in the inferior process . This is used by 
;'(comint-match-for-password-prompt '."
;:type 'regexp
;:group 'comint)
(add-hook 'comint-output-filter-functions
 'comint-watch-for-password-prompt)
(setq dispaly-time-24hr-format t)
(setq display-day-and-date t)
(column-number-mode t)
(setq mouse-buffer-menu-mode-mult 2)
(menu-bar-mode '-1)
(if (not (equal (getenv "HOSTTYPE") "sparc" ))
	(tool-bar-mode '-1))
(custom-set-variables '(scroll-bar-mode (equal right)))
(temp-buffer-resize-mode '1)
(global-font-lock-mode t)
(set-foreground-color "white")
(set-background-color "Gray22")
(set-mouse-color "yellow")
(set-cursor-color "red")
;(set-face-foreground 'info-xref "cyan")
;(set-face-foreground 'info-node "red")
;(setq Man-overstribe-face 'info-node)
;(setq Man-underline-face 'info-xref)
(set-face-foreground 'font-lock-comment-face "orangeRed")

(global-set-key [?\M-1] 'bookmark-jump-default1)
(defun bookmark-jump-default1 (pos)
"set a default bookmark1 default-bookmark1 at current position"
(interactive "d")
(bookmark-jump "default-bookmark1")
(bookmark_set "default-bookmark1"))
(global-set-key [?\C-1] 'bookmark-set-default1 )
(defun bookmark-set-default1 (pos)
 "Jump to the default bookmark1 default-bookmark1"
(interactive "d")
(bookmark-set "default-bookmark1"))

(global-set-key [?\M-2] 'bookmark-jump-default2)
(defun bookmark-jump-default2 (pos)
"set a default bookmark2 default-bookmark1 at current position"
(interactive "d")
(bookmark-jump "default-bookmark2")
(bookmark_set "default-bookmark2"))
(global-set-key [?\C-2] 'bookmark-set-default2 )
(defun bookmark-set-default2 (pos)
 "Jump to the default bookmark2 default-bookmark2"
(interactive "d")
(bookmark-set "default-bookmark2"))

(global-set-key [C-f1] 'kill-this-buffer)
(global-set-key [M-f1] 'kill-this-buffer)
(global-set-key [f1] 'switch-to-buffer)
(global-set-key [f2] 'buffer-menu)

(global-set-key [S-f2] 'bookmark-jump)
(global-set-key [S-C-f2] 'bookmark-set)
(define-key global-map [f3] 'isearch-forward)
(define-key isearch-mode-map [f3] 'isearch-repeat-forward)
(define-key global-map [C-f3] 'isearch-repeat-forward)
(define-key global-map [S-f3] 'isearch-backward)
(define-key isearch-mode-map [S-f3] 'isearch-repeat-backward)
(global-set-key [C-f4] 'kill-this-buffer)
(global-set-key [M-f4] 'save-buffer-kill-emacs)
;;(global-set-key [f4] 'copy-to-register-t)
(global-set-key [f4] 'isearch-repeat-backward)
(defun copy-to-register-t (start end)
"copy the select region into a default register t"
(interactive "d")
(insert-register t 1))
(global-set-key [S-f4] 'insert-register-t)
(defun insert-to-register-t (pos)
"Insert the content of default register, t into insert position"
(interactive "d")
(insert-register t 1))
(global-set-key [f5] 'goto-line)
(global-set-key [C-f5] 'linum-mode)
(global-set-key [f6] 'other-window)
(global-set-key [C-f6] 'switch-to-buffer)
(global-set-key [S-f6] 'buffer-menu)
(global-set-key [S-f7] 'comint-next-matching-input-from-input)
(global-set-key [f7] 'comint-previous-matching-input-from-input)
(global-set-key [f9] 'query-replace)
(global-set-key [f8] 'dirs)
(global-set-key [C-f8] 'auto-complete-mode)
(global-set-key [C-f9] 'query-replace-regexp)
(global-set-key [S-f9] 'query-replace-reg-t)
(defun query-replace-reg-t (to-string)
(interactive (let (to)
		(setq to (read-from-minibuffer
			(format "Query-replace \"%s\" with :"(get-register t)) nil nil nil
			query-replace-to-history-variable nil t))
		(list to))
		(perform-replace (get-register t) to-string t nil nil )))
;(global-set-key "\C-d" 'kill-whole-line)
;(defun kill-whole-line (pos)
;"kill the whole line the cursor located"
;(interactive) (beginning-of-line nil)
;(kill-line nil) (kill-line nil))
(global-set-key [f10] 'replace-string)
(global-set-key [C-f10] 'replace-string-regexp)
(global-set-key [S-f10] 'replace-string-reg-t)
(defun replace-string-reg-t (to-string)
" replace-string-reg t"
(interactive (let (to)
		(setq to (read-from-minibuffer
			(format "Replace \"%s\" with : "(get-register t)) nil nil nil
	query-replace-to-history-variable nil t ))
	(list to))
	(perform-replace (get-register t) to-string nil nil nil)))
(global-set-key [f11] 'delete-other-windows)
(global-set-key [S-f11] 'delete-window)
(global-set-key [f12] 'split-window-vertically)
(global-set-key [S-f12] 'split-window-horizontally)
(global-set-key [mouse-3] 'mouse-buffer-menu)
(global-set-key "\C-o" 'find-file)
(global-set-key "\C-s" 'save-buffer)
(global-set-key "\C-p" 'pwd)
(global-set-key "\C-j" 'find-file-at-point)
(global-set-key "\C-a" 'mark-whole-buffer)
(global-set-key [C-backspace] 'backward-kill-word)
(global-set-key [C-delete] 'kill-word)
(global-set-key [escape] 'keyboard-escape-quit)

(global-set-key [?\C-'] 'revert-buffer)
(global-set-key [?\C-.] 'ffap-copy-string-as-kill)
(global-set-key [?\C-/] 'isearch-symbol-at-point)

;;; Code: 
(defun isearch-yank-regexp (regexp) 
  "Pull REGEXP into search regexp." 
  (let ((isearch-regexp nil)) ;; Dynamic binding of global. 
    (isearch-yank-string regexp)) 
  (isearch-search-and-update)) 

(defun isearch-yank-symbol (&optional partialp) 
  "Put at symbol at point into search string. 
 
  If PARTIALP is non-nil, find all partial matches." 
  (interactive "P") 
  (let* ((sym (find-tag-default)) 
         ;; Use call of `re-search-forward' by `find-tag-default' to 
         ;; retrieve the end point of the symbol. 
         (sym-end (match-end 0)) 
         (sym-start (- sym-end (length sym)))) 
    (if (null sym) 
        (message "No symbol at point") 
      (goto-char sym-start) 
      ;; For consistent behavior, restart Isearch from starting point 
      ;; (or end point if using `isearch-backward') of symbol. 
      (isearch-search) 
      (if partialp 
          (isearch-yank-string sym) 
        (isearch-yank-regexp 
         (regexp-quote sym)))))) 


;;;###autoload 
(defun isearch-symbol-at-point (&optional partialp) 
  "Incremental search forward with symbol under point. 
 
  Prefixed with \\[universal-argument] will find all partial 
  matches." 
  (interactive "P") 
  (let ((start (point))) 
    (isearch-forward-regexp nil 1) 
    (isearch-yank-symbol partialp))) 

(shell)
(rename-buffer "shell-1")
