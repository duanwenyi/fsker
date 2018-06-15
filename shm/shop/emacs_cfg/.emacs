(eval-when-compile
  ;; Following line is not needed if use-package.el is in ~/.emacs.d
  (add-to-list 'load-path "/icdev/emacs/cfg/use-package")
  (require 'use-package))

(setq addition-paths '("/icdev/emacs/cfg" "/icdev/emacs/cfg/auto-complete" "/icdev/emacs/cfg/popup" "/icdev/emacs/cfg/fuzzy" "/icdev/emacs/cfg/async" "/icdev/emacs/cfg/helm" "/icdev/emacs/cfg/benchmark-init" "/icdev/emacs/cfg/hydra" "/icdev/emacs/cfg/swiper" "/icdev/emacs/cfg/expand-region"))
(setq load-path (append addition-paths load-path))
;(setq exec-path (append exec-path '("/icdev/emacs/cfg")))

(require 'hydra)

(require 'find-file-in-project)

;(require 'symon)
;(symon-mode t)

;(autoload 'gtags-mode "gtags" "" t)
;(require 'gxref)
;(add-to-list 'xref-backend-functions 'gxref-xref-backend)

;(require 'benchmark-init-loaddefs)
;(benchmark-init/activate)
;(add-hook 'after-init-hook 'benchmark-init/deactivate)

;; emacs
(setq inhibit-startup-message t)
(setq comint-move-point-for-output nil)
(setq comint-scroll-show-maximum-output nil)

(setq tramp-default-method "ssh")
;(setq tramp-file-name-inhibit-cache nil)
;(setq vc-ignore-dir-regexp
;      (format "%s\\|%s"
;              vc-ignore-dir-regexp
;              tramp-file-name-regexp))
;(setq tramp-verbose 1)

(setq ediff-split-window-function 'split-window-horizontally)

(ansi-color-for-comint-mode-on)
;; No too many #*, *~ files
(setq make-backup-files nil)

(if (display-graphic-p)
    (progn
      (setq initial-frame-alist
            '(
              (tool-bar-lines . 0)
              (width . 150) ; chars
              (height . 51) ; lines
              ;;
              ))

      (setq default-frame-alist
            '(
              (tool-bar-lines . 0)
              (width . 150)
              (height . 51)
              ;;
              )))
  (progn
    (setq initial-frame-alist
          '(
            (tool-bar-lines . 0)))
    (setq default-frame-alist
          '(
            (tool-bar-lines . 0)))))


;; Don't display menu bar and tool bar.
(menu-bar-mode 0)
(tool-bar-mode 0)
(column-number-mode t)
(size-indication-mode t)

(require 'xcscope)
(cscope-setup)

(require 'indent-guide)
;(indent-guide-global-mode)
(global-set-key [?\C-!] 'indent-guide-global-mode)

;(require 'beacon)
;(beacon-mode 1)

; not good
(require 'dumb-jump)
(dumb-jump-mode)
(setq dumb-jump-selector 'helm)
(setq dumb-jump-prefer-searcher 'ag)

;(require 'focus)

;(require 'imenu-anywhere)

(require 'drag-stuff)
;(drag-stuff-global-mode 1)
;(global-set-key [?\C-!] 'drag-stuff-mode)
(global-set-key [?\C--] 'drag-stuff-up)
(global-set-key [?\C-=] 'drag-stuff-down)
(global-set-key [?\M--] 'drag-stuff-left)
(global-set-key [?\M-=] 'drag-stuff-right)
;(drag-stuff-define-keys)


;(require 'highlight-thing)
;(require 'git-gutter)
;(add-hook 'verilog-mode-hook 'git-gutter-mode)

(require 'expand-region)
(global-set-key "\M-w" 'er/expand-region)

(require 'smex)
(global-set-key (kbd "M-x") 'smex)

;(require 'golden-ratio)

(autoload 'bm-toggle   "bm" "Toggle bookmark in current buffer." t)
(autoload 'bm-next     "bm" "Goto bookmark."                     t)
(autoload 'bm-previous "bm" "Goto previous bookmark."            t)
;(setq bm-marker 'bm-marker-right)
(setq bm-in-lifo-order t)
(setq bm-cycle-all-buffers t)
(global-set-key [?\C-1] 'bm-toggle)
(global-set-key [?\M-1] 'bm-show-all)
(global-set-key [?\C-2] 'bm-next)
(global-set-key [?\M-2] 'bm-previous)


;; Make the C-% key jump to the matching {}[]() if on another, like VI
(defun goto-match-paren (arg)
  "Go to the matching parenthesis if on parenthesis otherwise insert %."
  (interactive "p")
  (cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
        ((looking-at "\\s\)") (forward-char 1) (backward-list 1))
        (t (self-insert-command (or arg 1)))))
; C-e : move-end-of-line 
(global-set-key [?\M-3] 'goto-match-paren)

;(require 'dkeke)
;(global-set-key [?\C-/] 'dkeke-thing-at-point)
(require 'highlight-symbol)
(global-set-key [?\C->] 'highlight-symbol-next)
(global-set-key [?\C-<] 'highlight-symbol-prev)
(global-set-key [?\C-/] 'highlight-symbol)
;(global-set-key [?\C-,] 'highlight-symbol-remove-all)

(global-set-key [?\C-.] 'ffap-copy-string-as-kill)

(global-set-key [?\C-'] 'revert-buffer)


;(golden-ratio-mode 1)

(require 'discover-my-major)
(global-set-key [?\M-0] 'discover-my-major)

(require 'helm-ag)

(require 'helm-config)
(setq helm-alive-p nil)
(setq helm-ff-skip-boring-files t)
(setq helm-locate-command "find -type f -name %s %s")
;updatedb --require-visibility 0 -U . -o .mlocate.db
;(setq helm-locate-command "locate --database=./.mlocate.db %s %s")

;(require 'sublimity)
;(require 'sublimity-scroll)
;(sublimity-mode)


;(require 'fuzzy-find)
;(require 'helm-fuzzy-find)

(require 'grizzl)
(require 'fiplr)

;(require 'minimap)
(require 'restart-emacs)
(require 'helm-swoop)
(setq helm-swoop-split-direction 'split-window-horizontally)

;(ido-mode 1)

(require 'helm-grep)

(require 'helm-multi-match)

;(require 'helm-gtags)

;(autoload
;  'ace-window
;  "ace-window"
;  "Emacs quick switch windows"
;  t)

(global-set-key "\C-p" 'helm-show-kill-ring) ;;//  fiplr-find-file ;helm-find only start in shell buffer

(global-set-key [?\C-0] 'dkeke-copy-file-path)

(defun search-maker (s)
  `(lambda ()
     (interactive)
     (let ((regexp-search-ring (cons ,s regexp-search-ring)) ;add regexp to history
           (isearch-mode-map (copy-keymap isearch-mode-map)))
       (define-key isearch-mode-map (vector last-command-event) 'isearch-repeat-forward) ;make last key repeat
       (isearch-forward-regexp)))) ;`


(defun open-shell-rename ()
  "Open the new shell then invoke rename-buffer"
  (interactive)
  (command-execute 'shell)
  (command-execute 'rename-buffer)
  )

(global-set-key [?\C-9] 'open-shell-rename)
(global-set-key [?\M-9] 'rename-buffer)

(remove-hook 'find-file-hooks 'vc-find-file-hook)
(remove-hook 'find-file-hooks 'global-font-lock-mode-check-buffers)
;(remove-hook 'find-file-hooks 'projectile-find-file-hook-function)

;; 
;; enable a more powerful jump back function from ace jump mode
;;
(autoload
  'ace-jump-mode-pop-mark
  "ace-jump-mode"
  "Ace jump back:-)"
  t)
(eval-after-load "ace-jump-mode"
  '(ace-jump-mode-enable-mark-sync))
;(define-key global-map (kbd "C-x SPC") 'ace-jump-mode-pop-mark)
(global-set-key [?\C-`] 'ace-jump-mode-pop-mark)

(autoload
  'ace-jump-mode
  "ace-jump-mode"
  "Emacs quick move minor mode"
  t)
(global-set-key [?\C-,] 'ace-jump-mode-pop-mark)
;(global-set-key ( kbd "C-SPC") 'ace-jump-mode)



(autoload 'dired-async-mode "dired-async.el" nil t)
(dired-async-mode 1)

(require 'ace-isearch)

;;If you use viper mode :
;(define-key viper-vi-global-user-map (kbd "SPC") 'ace-jump-mode)
;;If you use evil
;(define-key evil-normal-state-map (kbd "SPC") 'ace-jump-mode)

;; No too many #*, *~ files
(setq make-backup-files nil)

;(require 'font-lock+)


(require 'auto-complete-config);
;(ac-config-default)
;(setq ac-auto-start 5)
;(setq ac-dwim t)
;(setq ac-trigger-commands 
;      (cons 'backward-delete-char-untabify ac-trigger-commands))
;(add-hook 'verilog-mode-hook '(lambda() (auto-complete-mode t)))
;(setq ac-delay 0.2)
;(setq ac-quick-help-delay 1.5)

;(ac-set-trigger-key "<C>")
;(global-auto-complete-mode t)

;(auto-revert-mode t) ; default is on

;(global-ede-mode t)
;(semantic-mode t)
;(local-set-key "." 'semantic-complete-self-insert)
;(require 'auto-complete-clang)
(require 'sr-speedbar);
;(require 'gpicker);

(require 'setup-verilog)
(require 'counsel-etags)
(add-hook 'prog-mode-hook
		  (lambda ()
			(add-hook 'after-save-hook
					  'counsel-etags-virtual-update-tags 'append 'local)))

(global-set-key "\M-." 'counsel-etags-find-tag-at-point) 
(global-set-key "\M-<" 'counsel-etags-recent-tag)
;(global-set-key [?\C-<] 'counsel-etags-recent-tag)
;(setq counsel-etags-update-tags-backend (lambda () (shell-command "find . -type f -iname \"*.[ch]\" | etags -")))

;(require 'setup-hydra)

;(display-time-mode t)
;(setq display-time-24hr-format t)
;(setq display-day-and-date t)
;(temp-buffer-resize-mode 1)
;(global-font-lock-mode t)

(set-foreground-color "white")
(set-background-color "gray18")
(set-mouse-color "yellow")
(set-cursor-color "red")
;(set-face-foreground 'info-xref "cyan")
;(set-face-foreground 'info-node "red")
;(set-Man-overstribe-face 'info-node)
;(set-Man-underline-face 'info-xref)
(set-face-foreground 'font-lock-comment-face "orangeRed")

;(setq font-lock-support-mode 'fast-lock-mode)
;(setq font-lock-support-mode 'jit-lock-debug-mode)
(setq font-lock-maximum-size 512)
;; font is OK ! 
;(set-default-font "-B&H-LucidaTypewriter-normal-normal-normal-Sans-14-*-*-*-m-90-iso10646-1")
(set-default-font "-unknown-DejaVu Sans Mono-normal-normal-normal-*-14-*-*-*-m-0-iso10646-1")
;(set-default-font "-unknown-Liberation Mono-normal-normal-normal-*-14-*-*-*-m-0-iso10646-1")

(cua-mode '(t nil(cua-base)))
(show-paren-mode t)
;(transient-paren-mode t)
(transient-mark-mode nil)
;(mouse-avoidance-mode 'animate)

;; Key others
;; Mouse operation
(global-set-key [mouse-3] 'mouse-buffer-menu)

(global-set-key "\C-a" 'mark-whole-buffer)

(global-set-key "\M-g" 'helm-imenu);helm-imenu-anywhere
(global-set-key "\C-j" 'ace-isearch-helm-swoop-from-isearch);;helm-swoop-without-pre-input

;(setq speedbar-show-unknown-files t)


(global-set-key [f1] 'switch-to-buffer)
(global-set-key [M-f1] 'kill-this-buffer)

(global-set-key [f2] 'helm-buffers-list) ;ibuffer   helm-mini

(global-set-key [f3] 'isearch-forward)
(define-key isearch-mode-map [f3] 'isearch-repeat-forward)

;(global-set-key [S-f3] 'isearch-forward-regexp) ;conflict with Citrix
(global-set-key [f4] 'isearch-backward)
(define-key isearch-mode-map [f4] 'isearch-repeat-backward)

(global-set-key [S-C-f3] 'isearch-backward-regexp)

(global-set-key [C-f4] 'restart-emacs);kill-this-buffer
;(global-set-key [M-f4] 'save-buffer-kill-emacs);; this is already kill emacs !!!!

(global-set-key [f5] 'goto-line)
(global-set-key [C-f5] 'global-linum-mode)
(global-set-key [S-f5] 'hl-line-mode)

(global-set-key [f6] 'other-window) ;ace-window
(global-set-key [C-f6] 'sr-speedbar-toggle)

(global-set-key [f7] 'comint-previous-matching-input-from-input)
(global-set-key [C-f7] 'auto-complete-mode)

(global-set-key [f8] 'fiplr-find-file)
(global-set-key [C-f8] 'find-file-in-project)


;(setq fiplr-ignored-globs '((directories ("pre_sim" ".*" "sim"))
;                            (files ("*novas*" "*.rc" "TAGS" ".tags" "#*" ".*"))
;                            ))

(global-set-key [f9] 'query-replace)

(global-set-key [f10] 'replace-string)

(global-set-key [f11] 'delete-other-windows)
(global-set-key [S-f11] 'delete-window)
(global-set-key [M-f12] 'split-window-vertically)
(global-set-key [f12] 'split-window-horizontally)

;; Key others
;; Mouse operation
(global-set-key [mouse-3] 'mouse-buffer-menu)


;; Common MSWIN like keys
(global-set-key "\C-o" 'helm-find-files)
;(global-set-key "\C-b" ' do-mode)
(global-set-key "\C-s" 'save-buffer)
;(global-set-key "\C-m" 'helm-projectile-find-file)

(global-set-key [C-backspace] 'backward-kill-word)
(global-set-key [C-delete] 'kill-word)

(define-key isearch-mode-map [escape] 'isearch-abort)
; Using one "ESC" replace of "ESC ESC ESC"
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;(global-set-key [?\M-\\] 'shell-command-on-region);;M-|             shell-command-on-region


(ffap-bindings)


(defun int-to-binary-string (i)
  "convert an integer into it's binary representation in string fomrat"
  (let ((res ""))
    (while (not (= i 0))
      (setq res (concat (if (=1 (logand i 1)) "1" "0") res ))
      (setq i (lsh i -1)))
    (if (string= res "")
        (setq res "0"))
    res))


(setq c-basic-offset 4)
(setq-default indent-tabs-mode nil)
(setq default-tab-width 4)
(setq tab-width 4)
(setq lazy-highlight-cleanup nil)

;(windmove-default-keybindings)
(defadvice keyboard-escape-quit
    (around keyboard-escape-quit-dont-close-windows activate)
  (let ((buffer-quit-function (lambda () () )))
    ad-do-it))

;(icomplete-mode)

(setq tags-revert-without-query t)
(setq large-file-warning-threshold nil)
;(defun build-root-tags ()
;  (interactive)
;  (message "building project tags")
;  (shell-command (concat "ctags -e -R --languages=SystemVerilog --languages=+Verilog --languages=+C --languages=+C++ --exclude=cov --exclude=wave --exclude=exec --exclude=verdi "))
;  (visit-tags-table "TAGS")
;  (message "tags built successfully"))

(defun shell-procfs-dirtrack (str)
  (prog1 str
    (when (string-match comint-prompt-regexp str)
      (let ((directory (file-symlink-p
                        (format "/proc/%s/cwd"
                                (process-id
                                 (get-buffer-process
                                  (current-buffer)))))))
        (when (file-directory-p directory)
          (cd directory))))))

(define-minor-mode shell-procfs-dirtrack-mode
  "Track shell directory by inspecting procfs."
  nil nil nil
  (cond (shell-procfs-dirtrack-mode
         (when (bound-and-true-p shell-dirtrack-mode)
           (shell-dirtrack-mode 0))
         (when (bound-and-true-p dirtrack-mode)
           (dirtrack-mode 0))
         (add-hook 'comint-preoutput-filter-functions
                   'shell-procfs-dirtrack nil t))
        (t
         (remove-hook 'comint-preoutput-filter-functions
                      'shell-procfs-dirtrack t))))

(defun track-shell-directory/procfs ()
  (shell-dirtrack-mode 0)
  (add-hook 'comint-preoutput-filter-functions
            (lambda (str)
              (prog1 str
                (when (string-match comint-prompt-regexp str)
                  (cd (file-symlink-p
                       (format "/proc/%s/cwd" (process-id
                                               (get-buffer-process
                                                (current-buffer)))))))))
            nil t))
(add-hook 'shell-mode-hook 'track-shell-directory/procfs)

;(global-set-key "\M-p"  'previous-buffer) 
;(global-set-key "\M-n" 'next-buffer) 

(global-set-key "\M-]"  'scroll-up-line) 
(global-set-key "\M-[" 'scroll-down-line) 


(put 'erase-buffer 'disable nil)
(shell "aa")
(shell "z")


(delete-other-windows)

;(desktop-save-mode t)
