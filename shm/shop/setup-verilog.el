(use-package verilog-mode
             :load-path "~/emacs_cfg/cfg"
             :mode (("\\.[st]*v[hp]*\\'" . verilog-mode) ;.v, .sv, .svh, .tv, .vp
                    ("\\.psl\\'"         . verilog-mode)
                    ("\\.vams\\'"        . verilog-mode)
                    ("\\.vinc\\'"        . verilog-mode))
             :config
             (progn

               (defvar modi/verilog-indent-level 4
                 "Variable to set all `verilog-mode' indents.
Sets `verilog-indent-level', `verilog-indent-level-module',
`verilog-indent-level-declaration',`verilog-indent-level-behavioral',
`verilog-indent-level-directive' and `verilog-case-indent'.")

;;; Variables
               (setq verilog-indent-level modi/verilog-indent-level)             ;3 (default)
               (setq verilog-indent-level-module modi/verilog-indent-level)      ;3
               (setq verilog-indent-level-declaration modi/verilog-indent-level) ;3
               (setq verilog-indent-level-behavioral modi/verilog-indent-level)  ;3
               (setq verilog-indent-level-directive modi/verilog-indent-level)   ;1
               (setq verilog-case-indent modi/verilog-indent-level)              ;2

               (setq verilog-auto-arg-format (\` single))
			   
               ;(setq verilog-auto-newline             nil) ;t
               ;(setq verilog-auto-indent-on-newline   t)   ;t
               ;(setq verilog-tab-always-indent        t)   ;t
               ;(setq verilog-minimum-comment-distance 10)  ;10
               ;(setq verilog-indent-begin-after-if    t)   ;t
               ;(setq verilog-auto-lineup              nil) ;'declarations
               ;(setq verilog-align-ifelse             t)   ;t
               ;(setq verilog-auto-endcomments         t)   ;t
               ;(setq verilog-tab-to-comment           nil) ;nil
               ;(setq verilog-date-scientific-format   t)   ;t

;;; hydra-verilog-template
               (defhydra hydra-verilog-template (:color pink
                                                        :hint nil
														:exit t)
                 "
_i_nitial   _?_ if          _A_ssign        _v_erilog-auto
_b_egin     _:_ else-if     _m_odule        _l_ocal-variables
_a_lways    _f_or           _t_ask          
_W_ire      _w_hile         _F_unction      _d_ ediff-buffers
_R_eg       _r_epeat        _/_ comment     _e_ vc-ediff
_I_nput     _c_ase          _h_eader        _p_ vc-print-log
_O_utput    _k_ fork        ^^              _g_ vc-version-ediff
"
                 ("a"   verilog-sk-always)
                 ("b"   verilog-sk-begin)
                 ("c"   verilog-sk-case)
                 ("f"   verilog-sk-for)
                 ("h"   verilog-sk-header)
                 ("i"   verilog-sk-initial)
                 ("k"   verilog-sk-fork)
                 ("m"   verilog-sk-module)
                 ("r"   verilog-sk-repeat)
                 ("t"   verilog-sk-task)
                 ("w"   verilog-sk-while)
                 ("?"   verilog-sk-if)
                 (":"   verilog-sk-else-if)
                 ("/"   verilog-sk-comment)
                 ("l"   verilog-sk-local-variables)
                 ("A"   verilog-sk-assign)
                 ("F"   verilog-sk-function)
                 ("I"   verilog-sk-input)
                 ("O"   verilog-sk-output)
                 ("s"   verilog-sk-state-machine)
                 ("="   verilog-sk-inout)
                 ("uc"  verilog-sk-uvm-component)
                 ("uo"  verilog-sk-uvm-object)
                 ("W"   verilog-sk-wire)
                 ("R"   verilog-sk-reg)
                 ("v"   verilog-auto)
                 ("e"   vc-ediff)
                 ("p"   vc-print-log)
                 ("g"   vc-version-ediff)
                 ("d"   ediff-buffers)
				 
                 ("q"   nil nil :color blue)
                 ("C-g" nil nil :color blue))

               (add-hook 'verilog-mode-hook '(lambda() (linum-mode t)) )

			   ;(defun search-maker (s)
			   ;	 `(lambda ()
			   ;		(interactive)
			   ;		(let ((regexp-search-ring (cons ,s regexp-search-ring)) ;add regexp to history
			   ;			  (isearch-mode-map (copy-keymap isearch-mode-map)))
			   ;		  (define-key isearch-mode-map (vector last-command-event) 'isearch-repeat-forward) ;make last key repeat
			   ;		  (isearch-forward-regexp)))) ;`
			   ;	
			   ;(defun search-maker_b (s)
			   ;	 `(lambda ()
			   ;		(interactive)
			   ;		(let ((regexp-search-ring (cons ,s regexp-search-ring)) ;add regexp to history
			   ;			  (isearch-mode-map (copy-keymap isearch-mode-map)))
			   ;		  (define-key isearch-mode-map (vector last-command-event) 'isearch-repeat-backward) ;make last key repeat
			   ;		  (isearch-backward-regexp)))) ;`

;;; Key bindings
               (bind-keys
                :map verilog-mode-map
                ;;
                ("C-t"   . hydra-verilog-template/body)
				;([?\C-6] . (search-maker "[a-zA-Z_][a-zA-Z_0-9]+ *[uU]_[a-zA-Z_0-9]+[ \n\(]"))
				;([?\M-6] . (search-maker_b "[a-zA-Z_][a-zA-Z_0-9]+ *[uU]_[a-zA-Z_0-9]+[ \n\(]"))
				
                )
               ))

(provide 'setup-verilog)
