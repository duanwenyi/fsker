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

               (setq verilog-auto-newline             nil) ;t
               (setq verilog-auto-indent-on-newline   t)   ;t
               (setq verilog-tab-always-indent        t)   ;t
               (setq verilog-minimum-comment-distance 10)  ;10
               (setq verilog-indent-begin-after-if    t)   ;t
               (setq verilog-auto-lineup              nil) ;'declarations
               (setq verilog-align-ifelse             t)   ;t
               (setq verilog-auto-endcomments         t)   ;t
               (setq verilog-tab-to-comment           nil) ;nil
               (setq verilog-date-scientific-format   t)   ;t

;;; hydra-verilog-template
               (defhydra hydra-verilog-template (:color pink
                                                        :hint nil)
                 "
_i_nitial        _?_ if             _j_ fork           _A_ssign                _uc_ uvm-component
_b_egin          _:_ else-if        _m_odule           _I_nput                 _uo_ uvm-object
_a_lways         _f_or              _g_enerate         _O_utput
^^               _w_hile            _p_rimitive        _=_ inout               _v_ verilog-auto
^^               _r_epeat           _s_pecify          _S_tate-machine         _h_eader
^^               _c_ase             _t_ask             _W_ire                  _/_ comment
^^               case_x_            _F_unction         _R_eg
^^               case_z_            ^^                 _D_efine-signal
"
                 ("a"   verilog-sk-always)
                 ("b"   verilog-sk-begin)
                 ("c"   verilog-sk-case)
                 ("f"   verilog-sk-for)
                 ("g"   verilog-sk-generate)
                 ("h"   verilog-sk-header)
                 ("i"   verilog-sk-initial)
                 ("j"   verilog-sk-fork)
                 ("m"   verilog-sk-module)
                 ("p"   verilog-sk-primitive)
                 ("r"   verilog-sk-repeat)
                 ("s"   verilog-sk-specify)
                 ("t"   verilog-sk-task)
                 ("w"   verilog-sk-while)
                 ("x"   verilog-sk-casex)
                 ("z"   verilog-sk-casez)
                 ("?"   verilog-sk-if)
                 (":"   verilog-sk-else-if)
                 ("/"   verilog-sk-comment)
                 ("A"   verilog-sk-assign)
                 ("F"   verilog-sk-function)
                 ("I"   verilog-sk-input)
                 ("O"   verilog-sk-output)
                 ("S"   verilog-sk-state-machine)
                 ("="   verilog-sk-inout)
                 ("uc"  verilog-sk-uvm-component)
                 ("uo"  verilog-sk-uvm-object)
                 ("W"   verilog-sk-wire)
                 ("R"   verilog-sk-reg)
                 ("D"   verilog-sk-define-signal)
                 ("v"   verilog-auto)
                 ("q"   nil nil :color blue)
                 ("C-g" nil nil :color blue))

               (add-hook 'verilog-mode-hook '(lambda() (linum-mode t)) )

;;; Key bindings
               (bind-keys
                :map verilog-mode-map
                ;;
                ("C-t"   . hydra-verilog-template/body)
                )
               ))

(provide 'setup-verilog)
