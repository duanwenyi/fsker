(setq addition-paths '("~/emacs_cfg/cfg" "~/emacs_cfg/cfg/auto-complete" "~/emacs_cfg/cfg/popup" "~/emacs_cfg/cfg/fuzzy" "~/emacs_cfg/cfg/yasnippet-0.6.1c" "~/emacs_cfg/cfg/async" "~/emacs_cfg/cfg/helm" "~/emacs_cfg/cfg/benchmark-init"))
(setq load-path (append addition-paths load-path))

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

                                        ;(require 'golden-ratio)

(require 'hl-anything)
(hl-highlight-mode)

                                        ;(golden-ratio-mode 1)

(require 'discover-my-major)

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
(require 'helm-bookmark)
                                        ;(require 'projectile)
                                        ;(require 'helm-projectile)
                                        ;(projectile-global-mode)
                                        ;(setq projectile-completion-system 'helm)
                                        ;(setq projectile-indexing-method 'alien)
                                        ;(setq projectile-enable-caching t)
                                        ;(helm-projectile-on)

(require 'helm-multi-match)


                                        ;(autoload
                                        ;  'ace-window
                                        ;  "ace-window"
                                        ;  "Emacs quick switch windows"
                                        ;  t)

(global-set-key "\C-p" 'helm-show-kill-ring) ;;//  fiplr-find-file ;helm-find only start in shell buffer

(global-set-key [?\C-0] 'xah-copy-file-path)
                                        ;(global-set-key [?\C-9] 'helm-projectile-find-file)
                                        ;(global-set-key [?\C-8] 'minimap-mode)

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
                                        ;(define-key global-map (kbd "C-c SPC") 'ace-jump-mode)
(global-set-key [?\C-,] 'ace-jump-char-mode)



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

                                        ;(autoload 'info-xref "info-xref" "info xref" t)
                                        ;(require 'verilog-mode)
(autoload 'verilog-mode "verilog-mode" "Verilog mode" t)
(add-to-list 'auto-mode-alist '("\\.v\\'" . verilog-mode))
(add-to-list 'auto-mode-alist '("\\.sv\\'" . verilog-mode))
                                        ;(add-to-list 'auto-mode-alist '("\\.[ds]?vh?\\'" . verilog-mode))


;; custom change emacs by emacs self
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(indent-tabs-mode nil)
 '(package-selected-packages (quote (helm-ag)))
 '(scroll-bar-mode (quote right))
 '(verilog-auto-arg-format (\` single))
 '(verilog-auto-arg-sort nil)
 '(verilog-auto-indent-on-newline t)
 '(verilog-auto-newline nil)
 '(verilog-case-indent 4)
 '(verilog-indent-begin-after-if t)
 '(verilog-indent-level 4)
 '(verilog-indent-level-behavioral 4)
 '(verilog-indent-level-declaration 4)
 '(verilog-indent-level-module 4))

(add-hook 'verilog-mode-hook '(lambda() (linum-mode t)))

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
                                        ;(mouse-avoidance-mode 'animate)

;; Key others
;; Mouse operation
(global-set-key [mouse-3] 'mouse-buffer-menu)

;; Make the C-% key jump to the matching {}[]() if on another, like VI
(global-set-key "\C-e" 'goto-match-paren)
(defun goto-match-paren (arg)
  "Go to the matching parenthesis if on parenthesis otherwise insert %."
  (interactive "p")
  (cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
        ((looking-at "\\s\)") (forward-char 1) (backward-list 1))
        (t (self-insert-command (or arg 1)))))

(global-set-key "\C-a" 'mark-whole-buffer)

(global-set-key [?\M-1] 'bookmark-jump-default1)
(defun bookmark-jump-default1 (pos) 
  "jump to the default bookmark1 default-bookmark1"
  (interactive "d")
  (bookmark-jump "BookMark-1")
  (bookmark-set "BookMark-1")
  (message " Jumped BookMark-1.") )

(global-set-key [?\C-1] 'bookmark-set-default1)
(defun bookmark-set-default1 (pos) 
  "set a default bookmark1 default-bookmark1 at current position"
  (interactive "d")
  (bookmark-set "BookMark-1")
  (message "Set BookMark-1 , press <Alt + 1> jump back .") )

(global-set-key [?\M-2] 'bookmark-jump-default2)
(defun bookmark-jump-default2 (pos) 
  "jump to the default bookmark1 default-bookmark2"
  (interactive "d")
  (bookmark-jump "BookMark-2")
  (bookmark-set "BookMark-2")
  (message " Jumped BookMark-2.") )

(global-set-key [?\C-2] 'bookmark-set-default2)
(defun bookmark-set-default2 (pos) 
  "set a default bookmark2 default-bookmark2 at current position"
  (interactive "d")
  (bookmark-set "BookMark-2")
  (message "Set BookMark-2 , press <alt + 2> jump back .") )

(global-set-key [?\C-3] 'bookmark-set)
(global-set-key [?\M-3] 'helm-bookmarks)
                                        ;(global-set-key [?\c-3] 'helm-show-kill-ring)
                                        ;(global-set-key "\M-i" 'helm-show-kill-ring)
(global-set-key "\M-g" 'helm-imenu)

                                        ;(global-set-key "\m-s" 'find-name-dired)
(global-set-key "\M-s" 'helm-etags-select)
                                        ;(global-set-key "\M-s" 'gpicker-find-file)

(defun xah-search-current-word ()
  "Call `isearch' on current word or text selection.
“word” here is A to Z, a to z, and hyphen 「-」 and underline 「_」, independent of syntax table.
URL `http://ergoemacs.org/emacs/modernization_isearch.html'
Version 2015-04-09"
  (interactive)
  (let ( ξp1 ξp2 )
    (if (use-region-p)
        (progn
          (setq ξp1 (region-beginning))
          (setq ξp2 (region-end)))
      (save-excursion
        (skip-chars-backward "-_A-Za-z0-9")
        (setq ξp1 (point))
        (right-char)
        (skip-chars-forward "-_A-Za-z0-9")
        (setq ξp2 (point))))
    (setq mark-active nil)
    (when (< ξp1 (point))
      (goto-char ξp1))
    (isearch-mode t)
    (isearch-yank-string (buffer-substring-no-properties ξp1 ξp2))))

(setq speedbar-show-unknown-files t)


(global-set-key [f1] 'switch-to-buffer)
(global-set-key [M-f1] 'kill-this-buffer)

(global-set-key [f2] 'helm-buffers-list) ;ibuffer   helm-mini

(global-set-key [f3] 'isearch-forward)
(define-key isearch-mode-map [f3] 'isearch-repeat-forward)

                                        ;(global-set-key [S-f3] 'isearch-forward-regexp) ;conflict with Citrix
(global-set-key [f4] 'isearch-backward)
(define-key isearch-mode-map [f4] 'isearch-repeat-backward)

(global-set-key [S-C-f3] 'isearch-backward-regexp)

(global-set-key [C-f4] 'kill-this-buffer)
                                        ;(global-set-key [M-f4] 'save-buffer-kill-emacs);; this is already kill emacs !!!!

(global-set-key [f5] 'goto-line)
(global-set-key [C-f5] 'linum-mode)
(global-set-key [S-f5] 'hl-line-mode)

(global-set-key [f6] 'other-window) ;ace-window
(global-set-key [C-f6] 'helm-imenu) ;ace-window

(global-set-key "\C-w" 'other-window) ;ace-window


(global-set-key [f7] 'hl-highlight-thingatpt-local); repeat will cancle highlight! 'hl-unhighlight-all-local
(global-set-key [C-f7] 'hl-find-next-thing)
(global-set-key [S-f7] 'hl-find-prev-thing)


(global-set-key [f8] 'fiplr-find-file) 
(global-set-key [C-f8] 'speedbar)
(global-set-key [S-f8] 'auto-complete-mode)

(setq fiplr-ignored-globs '((directories ("pre_sim" ".*"))
                            (files ("*novas*" "*.rc" "TAGS" ".tags" "#*" ".*"))
                            ))

(global-set-key [f9] 'query-replace)
(global-set-key [C-f9] 'replace-string)


(global-set-key [C-f10] 'helm-swoop-without-pre-input);ace-isearch-helm-swoop-from-isearch
(global-set-key [f10] 'helm-swoop)


(global-set-key [f11] 'delete-other-windows)
(global-set-key [S-f11] 'delete-window)
(global-set-key [M-f12] 'split-window-vertically)
(global-set-key [f12] 'split-window-horizontally)

;; Key others
;; Mouse operation
(global-set-key [mouse-3] 'mouse-buffer-menu)



                                        ;(global-set-key "\M-p"  'previous-buffer) 
                                        ;(global-set-key "\M-n" 'next-buffer) 

(global-set-key "\M-]"  'scroll-up-line) 
(global-set-key "\M-[" 'scroll-down-line) 


;; Common MSWIN like keys
(global-set-key "\C-o" 'find-file)
(global-set-key "\C-b" 'ido-mode)
(global-set-key "\C-s" 'save-buffer)
                                        ;(global-set-key "\C-m" 'helm-projectile-find-file)

(global-set-key [C-backspace] 'backward-kill-word)
(global-set-key [C-delete] 'kill-word)
(global-set-key "\C-j" 'ffap)

(define-key isearch-mode-map [escape] 'isearch-abort)
                                        ; Using one "ESC" replace of "ESC ESC ESC"
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(global-set-key [?\C-'] 'revert-buffer)

(global-set-key [?\C-.] 'ffap-copy-string-as-kill)

(global-set-key [?\C-/] 'xah-search-current-word)

(global-set-key [?\M-\\] 'shell-command-on-region)


(ffap-bindings)


(defun xah-cut-line-or-region ()
  "Cut current line, or text selection.
When `universal-argument' is called first, cut whole buffer (but respect `narrow-to-region')."
  (interactive)
  (let (p1 p2)
    (if (null current-prefix-arg)
        (progn (if (use-region-p)
                   (progn (setq p1 (region-beginning))
                          (setq p2 (region-end)))
                 (progn (setq p1 (line-beginning-position))
                        (setq p2 (line-beginning-position 2)))))
      (progn (setq p1 (point-min))
             (setq p2 (point-max))))
    (kill-region p1 p2))
  (message "Cut a line to Ring"))



(defun int-to-binary-string (i)
  "convert an integer into it's binary representation in string fomrat"
  (let ((res ""))
    (while (not (= i 0))
      (setq res (concat (if (=1 (logand i 1)) "1" "0") res ))
      (setq i (lsh i -1)))
    (if (string= res "")
        (setq res "0"))
    res))

(defun xah-copy-file-path (&optional @dir-path-only-p)
  "Copy the current buffer's file path or dired path to `kill-ring'.
Result is full path.
If `universal-argument' is called first, copy only the dir path.

If in dired, copy the file/dir cursor is on, or marked files.

If a buffer is not file and not dired, copy value of `default-directory' (which is usually the “current” dir when that buffer was created)

URL `http://ergoemacs.org/emacs/emacs_copy_file_path.html'
Version 2017-09-01"
  (interactive "P")
  (let (($fpath
         (if (string-equal major-mode 'dired-mode)
             (progn
               (let (($result (mapconcat 'identity (dired-get-marked-files) "\n")))
                 (if (equal (length $result) 0)
                     (progn default-directory )
                   (progn $result))))
           (if (buffer-file-name)
               (buffer-file-name)
             (expand-file-name default-directory)))))
    (kill-new
     (if @dir-path-only-p
         (progn
           (message "Directory path copied: %s" (file-name-directory $fpath))
           (file-name-directory $fpath))
       (progn
         (message "File path copied: %s" $fpath)
         $fpath )))))

(global-set-key "\C-d" 'xah-cut-line-or-region) ; cut ; why is only can be used in text mode ?

                                        ;(global-set-key "\C-y" 'yank) ; paste
(global-set-key "\C-f" 'ace-isearch-helm-swoop-from-isearch)
                                        ;(global-set-key "\C-f" 'helm-swoop-without-pre-input)
;; personal like
                                        ;(global-linum-mode t)

(setq c-basic-offset 4)
(setq indent-tabs-mode nil)
(setq default-tab-width 4)
(setq tab-width 4)
(setq lazy-highlight-cleanup nil)

                                        ;(windmove-default-keybindings)
(defadvice keyboard-escape-quit
    (around keyboard-escape-quit-dont-close-windows activate)
  (let ((buffer-quit-function (lambda () () )))
    ad-do-it))


(icomplete-mode)
                                        ;(gpicker-visit-project "~/emacs_cfg")

(defun build-ctags ()
  (interactive)
  (message "building project tags")
  (shell-command (concat "ctags -e -R --languages=SystemVerilog --langmap=SystemVerilog:+.v --exclude=pre_sim "))
  (message "tags built successfully"))

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


(shell "aa")
                                        ;(rename-buffer "aa")
(shell "z")
                                        ;(rename-buffer "z")
(put 'erase-buffer 'disable nil)
(delete-other-windows)

