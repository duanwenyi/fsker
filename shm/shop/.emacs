(setq addition-paths '("~/emacs_cfg/cfg" "~/emacs_cfg/cfg/auto-complete" "~/emacs_cfg/cfg/popup" "~/emacs_cfg/cfg/fuzzy" "~/emacs_cfg/cfg/yasnippet-0.6.1c" "~/emacs_cfg/cfg/async" "~/emacs_cfg/cfg/helm" "~/emacs_cfg/cfg/benchmark-init"))^M(setq load-path (append addition-paths load-path))^M^M;(require 'benchmark-init-loaddefs)^M;(benchmark-init/activate)^M;(add-hook 'after-init-hook 'benchmark-init/deactivate)^M^M;; emacs^M(setq inhibit-startup-message t)^M(setq comint-move-point-for-output nil)^M(setq comint-scroll-show-maximum-output nil)^M^M(setq tramp-default-method "ssh")^M;(setq tramp-file-name-inhibit-cache nil)^M;(setq vc-ignore-dir-regexp^M;      (format "%s\\|%s"^M;              vc-ignore-dir-regexp^M;              tramp-file-name-regexp))^M;(setq tramp-verbose 1)^M^M(ansi-color-for-comint-mode-on)^M;; No too many #*, *~ files^M(setq make-backup-files nil)^M^M(if (display-graphic-p)^M    (progn^M      (setq initial-frame-alist^M            '(^M              (tool-bar-lines . 0)^M              (width . 150) ; chars^M              (height . 51) ; lines^M              ;;^M              ))^M^M      (setq default-frame-alist^M            '(^M              (tool-bar-lines . 0)^M              (width . 150)^M              (height . 51)^M              ;;^M              )))^M  (progn^M    (setq initial-frame-alist^M          '(^M            (tool-bar-lines . 0)))^M    (setq default-frame-alist^M          '(^M            (tool-bar-lines . 0)))))^M^M^M;; Don't display menu bar and tool bar.^M(menu-bar-mode 0)^M(tool-bar-mode 0)^M(column-number-mode t)^M(size-indication-mode t)^M^M(require 'xcscope)^M(cscope-setup)^M^M;(require 'golden-ratio)^M^M(require 'hl-anything)^M(hl-highlight-mode)^M^M;(golden-ratio-mode 1)^M^M(require 'discover-my-major)^M^M(require 'helm-config)^M(setq helm-alive-p nil)^M(setq helm-ff-skip-boring-files t)^M(setq helm-locate-command "find -type f -name %s %s")^M;updatedb --require-visibility 0 -U . -o .mlocate.db^M;(setq helm-locate-command "locate --database=./.mlocate.db %s %s")^M^M;(require 'sublimity)^M;(require 'sublimity-scroll)^M;(sublimity-mode)^M^M^M;(require 'fuzzy-find)^M;(require 'helm-fuzzy-find)^M^M(require 'grizzl)^M(require 'fiplr)^M^M;(require 'minimap)^M(require 'restart-emacs)^M(require 'helm-swoop)^M(setq helm-swoop-split-direction 'split-window-horizontally)^M^M;(ido-mode 1)^M^M(require 'helm-grep)^M(require 'helm-bookmark)^M;(require 'projectile)^M;(require 'helm-projectile)^M;(projectile-global-mode)^M;(setq projectile-completion-system 'helm)^M;(setq projectile-indexing-method 'alien)^M;(setq projectile-enable-caching t)^M;(helm-projectile-on)^M^M(require 'helm-multi-match)^M^M^M;(autoload^M;  'ace-window^M;  "ace-window"^M;  "Emacs quick switch windows"^M;  t)^M^M(global-set-key "\C-p" 'helm-show-kill-ring) ;;//  fiplr-find-file ;helm-find only start in shell buffer^M^M(global-set-key [?\C-0] 'xah-copy-file-path)^M;(global-set-key [?\C-9] 'helm-projectile-find-file)^M;(global-set-key [?\C-8] 'minimap-mode)^M^M(remove-hook 'find-file-hooks 'vc-find-file-hook)^M(remove-hook 'find-file-hooks 'global-font-lock-mode-check-buffers)^M;(remove-hook 'find-file-hooks 'projectile-find-file-hook-function)^M^M;; ^M;; enable a more powerful jump back function from ace jump mode^M;;^M(autoload^M  'ace-jump-mode-pop-mark^M  "ace-jump-mode"^M  "Ace jump back:-)"^M  t)^M(eval-after-load "ace-jump-mode"^M  '(ace-jump-mode-enable-mark-sync))^M;(define-key global-map (kbd "C-x SPC") 'ace-jump-mode-pop-mark)^M(global-set-key [?\C-`] 'ace-jump-mode-pop-mark)^M^M(autoload^M  'ace-jump-mode^M  "ace-jump-mode"^M  "Emacs quick move minor mode"^M  t)^M;(define-key global-map (kbd "C-c SPC") 'ace-jump-mode)^M(global-set-key [?\C-,] 'ace-jump-char-mode)^M^M^M^M(autoload 'dired-async-mode "dired-async.el" nil t)^M(dired-async-mode 1)^M^M(require 'ace-isearch)^M^M;;If you use viper mode :^M;(define-key viper-vi-global-user-map (kbd "SPC") 'ace-jump-mode)^M;;If you use evil^M;(define-key evil-normal-state-map (kbd "SPC") 'ace-jump-mode)^M^M;; No too many #*, *~ files^M(setq make-backup-files nil)^M^M;(require 'font-lock+)^M^M^M(require 'auto-complete-config);^M;(ac-config-default)^M;(setq ac-auto-start 5)^M;(setq ac-dwim t)^M;(setq ac-trigger-commands ^M;      (cons 'backward-delete-char-untabify ac-trigger-commands))^M;(add-hook 'verilog-mode-hook '(lambda() (auto-complete-mode t)))^M;(setq ac-delay 0.2)^M;(setq ac-quick-help-delay 1.5)^M^M;(ac-set-trigger-key "<C>")^M;(global-auto-complete-mode t)^M^M;(auto-revert-mode t) ; default is on^M^M;(global-ede-mode t)^M;(semantic-mode t)^M;(local-set-key "." 'semantic-complete-self-insert)^M;(require 'auto-complete-clang)^M(require 'sr-speedbar);^M;(require 'gpicker);^M^M;(autoload 'info-xref "info-xref" "info xref" t)^M;(require 'verilog-mode)^M(autoload 'verilog-mode "verilog-mode" "Verilog mode" t)^M(add-to-list 'auto-mode-alist '("\\.v\\'" . verilog-mode))^M(add-to-list 'auto-mode-alist '("\\.sv\\'" . verilog-mode))^M;(add-to-list 'auto-mode-alist '("\\.[ds]?vh?\\'" . verilog-mode))^M^M^M;; custom change emacs by emacs self^M(custom-set-variables^M ;; custom-set-variables was added by Custom.^M ;; If you edit it by hand, you could mess it up, so be careful.^M ;; Your init file should contain only one such instance.^M ;; If there is more than one, they won't work right.^M '(indent-tabs-mode nil)^M '(package-selected-packages (quote (helm-ag)))^M '(scroll-bar-mode (quote right))^M '(verilog-auto-arg-format (\` single))^M '(verilog-auto-arg-sort nil)^M '(verilog-auto-indent-on-newline t)^M '(verilog-auto-newline nil)^M '(verilog-case-indent 4)^M '(verilog-indent-begin-after-if t)^M '(verilog-indent-level 4)^M '(verilog-indent-level-behavioral 4)^M '(verilog-indent-level-declaration 4)^M '(verilog-indent-level-module 4))^M^M(add-hook 'verilog-mode-hook '(lambda() (linum-mode t)))^M^M;(display-time-mode t)^M;(setq display-time-24hr-format t)^M;(setq display-day-and-date t)^M;(temp-buffer-resize-mode 1)^M;(global-font-lock-mode t)^M^M(set-foreground-color "white")^M(set-background-color "gray18")^M(set-mouse-color "yellow")^M(set-cursor-color "red")^M;(set-face-foreground 'info-xref "cyan")^M;(set-face-foreground 'info-node "red")^M;(set-Man-overstribe-face 'info-node)^M;(set-Man-underline-face 'info-xref)^M(set-face-foreground 'font-lock-comment-face "orangeRed")^M^M;(setq font-lock-support-mode 'fast-lock-mode)^M;(setq font-lock-support-mode 'jit-lock-debug-mode)^M(setq font-lock-maximum-size 512)^M;; font is OK ! ^M;(set-default-font "-B&H-LucidaTypewriter-normal-normal-normal-Sans-14-*-*-*-m-90-iso10646-1")^M(set-default-font "-unknown-DejaVu Sans Mono-normal-normal-normal-*-14-*-*-*-m-0-iso10646-1")^M;(set-default-font "-unknown-Liberation Mono-normal-normal-normal-*-14-*-*-*-m-0-iso10646-1")^M^M(cua-mode '(t nil(cua-base)))^M(show-paren-mode t)^M;(transient-paren-mode t)^M;(mouse-avoidance-mode 'animate)^M^M;; Key others^M;; Mouse operation^M(global-set-key [mouse-3] 'mouse-buffer-menu)^M^M;; Make the C-% key jump to the matching {}[]() if on another, like VI^M(global-set-key "\C-e" 'goto-match-paren)^M(defun goto-match-paren (arg)^M  "Go to the matching parenthesis if on parenthesis otherwise insert %."^M  (interactive "p")^M  (cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))^M        ((looking-at "\\s\)") (forward-char 1) (backward-list 1))^M        (t (self-insert-command (or arg 1)))))^M^M(global-set-key "\C-a" 'mark-whole-buffer)^M^M(global-set-key [?\M-1] 'bookmark-jump-default1)^M(defun bookmark-jump-default1 (pos) ^M  "jump to the default bookmark1 default-bookmark1"^M  (interactive "d")^M  (bookmark-jump "BookMark-1")^M  (bookmark-set "BookMark-1")^M  (message " Jumped BookMark-1.") )^M^M(global-set-key [?\C-1] 'bookmark-set-default1)^M(defun bookmark-set-default1 (pos) ^M  "set a default bookmark1 default-bookmark1 at current position"^M  (interactive "d")^M  (bookmark-set "BookMark-1")^M  (message "Set BookMark-1 , press <Alt + 1> jump back .") )^M^M(global-set-key [?\M-2] 'bookmark-jump-default2)^M(defun bookmark-jump-default2 (pos) ^M  "jump to the default bookmark1 default-bookmark2"^M  (interactive "d")^M  (bookmark-jump "BookMark-2")^M  (bookmark-set "BookMark-2")^M  (message " Jumped BookMark-2.") )^M^M(global-set-key [?\C-2] 'bookmark-set-default2)^M(defun bookmark-set-default2 (pos) ^M  "set a default bookmark2 default-bookmark2 at current position"^M  (interactive "d")^M  (bookmark-set "BookMark-2")^M  (message "Set BookMark-2 , press <alt + 2> jump back .") )^M^M(global-set-key [?\C-3] 'bookmark-set)^M(global-set-key [?\M-3] 'helm-bookmarks)^M;(global-set-key [?\c-3] 'helm-show-kill-ring)^M;(global-set-key "\M-i" 'helm-show-kill-ring)^M(global-set-key "\M-g" 'helm-imenu)^M^M;(global-set-key "\m-s" 'find-name-dired)^M(global-set-key "\M-s" 'helm-etags-select)^M;(global-set-key "\M-s" 'gpicker-find-file)^M^M(defun xah-search-current-word ()^M  "Call `isearch' on current word or text selection.^M“word” here is A to Z, a to z, and hyphen 「-」 and underline 「_」, independent of syntax table.^MURL `http://ergoemacs.org/emacs/modernization_isearch.html'^MVersion 2015-04-09"^M  (interactive)^M  (let ( ξp1 ξp2 )^M    (if (use-region-p)^M        (progn^M          (setq ξp1 (region-beginning))^M          (setq ξp2 (region-end)))^M      (save-excursion^M        (skip-chars-backward "-_A-Za-z0-9")^M        (setq ξp1 (point))^M        (right-char)^M        (skip-chars-forward "-_A-Za-z0-9")^M        (setq ξp2 (point))))^M    (setq mark-active nil)^M    (when (< ξp1 (point))^M      (goto-char ξp1))^M    (isearch-mode t)^M    (isearch-yank-string (buffer-substring-no-properties ξp1 ξp2))))^M^M(setq speedbar-show-unknown-files t)^M^M^M(global-set-key [f1] 'switch-to-buffer)^M(global-set-key [M-f1] 'kill-this-buffer)^M^M(global-set-key [f2] 'helm-buffers-list) ;ibuffer   helm-mini^M^M(global-set-key [f3] 'isearch-forward)^M(define-key isearch-mode-map [f3] 'isearch-repeat-forward)^M^M;(global-set-key [S-f3] 'isearch-forward-regexp) ;conflict with Citrix^M(global-set-key [f4] 'isearch-backward)^M(define-key isearch-mode-map [f4] 'isearch-repeat-backward)^M^M(global-set-key [S-C-f3] 'isearch-backward-regexp)^M^M(global-set-key [C-f4] 'kill-this-buffer)^M;(global-set-key [M-f4] 'save-buffer-kill-emacs);; this is already kill emacs !!!!^M^M(global-set-key [f5] 'goto-line)^M(global-set-key [C-f5] 'linum-mode)^M(global-set-key [S-f5] 'hl-line-mode)^M^M(global-set-key [f6] 'other-window) ;ace-window^M(global-set-key [C-f6] 'helm-imenu) ;ace-window^M^M(global-set-key "\C-w" 'other-window) ;ace-window^M^M^M(global-set-key [f7] 'hl-highlight-thingatpt-local); repeat will cancle highlight! 'hl-unhighlight-all-local^M(global-set-key [C-f7] 'hl-find-next-thing)^M(global-set-key [S-f7] 'hl-find-prev-thing)^M^M^M(global-set-key [f8] 'fiplr-find-file) ^M(global-set-key [C-f8] 'speedbar)^M(global-set-key [S-f8] 'auto-complete-mode)^M^M(setq fiplr-ignored-globs '((directories ("pre_sim" ".*"))^M                            (files ("*novas*" "*.rc" "TAGS" ".tags" "#*" ".*"))^M                            ))^M^M(global-set-key [f9] 'query-replace)^M(global-set-key [C-f9] 'replace-string)^M^M^M(global-set-key [C-f10] 'helm-swoop-without-pre-input);ace-isearch-helm-swoop-from-isearch^M(global-set-key [f10] 'helm-swoop)^M^M^M(global-set-key [f11] 'delete-other-windows)^M(global-set-key [S-f11] 'delete-window)^M(global-set-key [M-f12] 'split-window-vertically)^M(global-set-key [f12] 'split-window-horizontally)^M^M;; Key others^M;; Mouse operation^M(global-set-key [mouse-3] 'mouse-buffer-menu)^M^M^M^M;(global-set-key "\M-p"  'previous-buffer) ^M;(global-set-key "\M-n" 'next-buffer) ^M^M(global-set-key "\M-]"  'scroll-up-line) ^M(global-set-key "\M-[" 'scroll-down-line) ^M^M^M;; Common MSWIN like keys^M(global-set-key "\C-o" 'find-file)^M(global-set-key "\C-b" 'ido-mode)^M(global-set-key "\C-s" 'save-buffer)^M;(global-set-key "\C-m" 'helm-projectile-find-file)^M^M(global-set-key [C-backspace] 'backward-kill-word)^M(global-set-key [C-delete] 'kill-word)^M(global-set-key "\C-j" 'ffap)^M^M(define-key isearch-mode-map [escape] 'isearch-abort)^M; Using one "ESC" replace of "ESC ESC ESC"^M(global-set-key (kbd "<escape>") 'keyboard-escape-quit)^M^M(global-set-key [?\C-'] 'revert-buffer)^M^M(global-set-key [?\C-.] 'ffap-copy-string-as-kill)^M^M(global-set-key [?\C-/] 'xah-search-current-word)^M^M(global-set-key [?\M-\\] 'shell-command-on-region)^M^M^M(ffap-bindings)^M^M^M(defun xah-cut-line-or-region ()^M  "Cut current line, or text selection.^MWhen `universal-argument' is called first, cut whole buffer (but respect `narrow-to-region')."^M  (interactive)^M  (let (p1 p2)^M    (if (null current-prefix-arg)^M        (progn (if (use-region-p)^M                   (progn (setq p1 (region-beginning))^M                          (setq p2 (region-end)))^M                 (progn (setq p1 (line-beginning-position))^M                        (setq p2 (line-beginning-position 2)))))^M      (progn (setq p1 (point-min))^M             (setq p2 (point-max))))^M    (kill-region p1 p2))^M  (message "Cut a line to Ring"))^M^M^M^M(defun int-to-binary-string (i)^M  "convert an integer into it's binary representation in string fomrat"^M  (let ((res ""))^M    (while (not (= i 0))^M      (setq res (concat (if (=1 (logand i 1)) "1" "0") res ))^M      (setq i (lsh i -1)))^M    (if (string= res "")^M        (setq res "0"))^M    res))^M^M(defun xah-copy-file-path (&optional @dir-path-only-p)^M  "Copy the current buffer's file path or dired path to `kill-ring'.^MResult is full path.^MIf `universal-argument' is called first, copy only the dir path.^M^MIf in dired, copy the file/dir cursor is on, or marked files.^M^MIf a buffer is not file and not dired, copy value of `default-directory' (which is usually the “current” dir when that buffer was created)^M^MURL `http://ergoemacs.org/emacs/emacs_copy_file_path.html'^MVersion 2017-09-01"^M  (interactive "P")^M  (let (($fpath^M         (if (string-equal major-mode 'dired-mode)^M             (progn^M               (let (($result (mapconcat 'identity (dired-get-marked-files) "\n")))^M                 (if (equal (length $result) 0)^M                     (progn default-directory )^M                   (progn $result))))^M           (if (buffer-file-name)^M               (buffer-file-name)^M             (expand-file-name default-directory)))))^M    (kill-new^M     (if @dir-path-only-p^M         (progn^M           (message "Directory path copied: %s" (file-name-directory $fpath))^M           (file-name-directory $fpath))^M       (progn^M         (message "File path copied: %s" $fpath)^M         $fpath )))))^M^M(global-set-key "\C-d" 'xah-cut-line-or-region) ; cut ; why is only can be used in text mode ?^M^M;(global-set-key "\C-y" 'yank) ; paste^M(global-set-key "\C-f" 'ace-isearch-helm-swoop-from-isearch)^M;(global-set-key "\C-f" 'helm-swoop-without-pre-input)^M;; personal like^M;(global-linum-mode t)^M^M(setq c-basic-offset 4)^M(setq indent-tabs-mode nil)^M(setq default-tab-width 4)^M(setq tab-width 4)^M(setq lazy-highlight-cleanup nil)^M^M;(windmove-default-keybindings)^M(defadvice keyboard-escape-quit^M    (around keyboard-escape-quit-dont-close-windows activate)^M  (let ((buffer-quit-function (lambda () () )))^M    ad-do-it))^M^M^M(icomplete-mode)^M;(gpicker-visit-project "~/emacs_cfg")^M^M(defun build-ctags ()^M  (interactive)^M  (message "building project tags")^M  (shell-command (concat "ctags -e -R --languages=SystemVerilog --langmap=SystemVerilog:+.v --exclude=pre_sim "))^M  (message "tags built successfully"))^M^M(defun shell-procfs-dirtrack (str)^M  (prog1 str^M    (when (string-match comint-prompt-regexp str)^M      (let ((directory (file-symlink-p^M                        (format "/proc/%s/cwd"^M                                (process-id^M                                 (get-buffer-process^M                                  (current-buffer)))))))^M        (when (file-directory-p directory)^M          (cd directory))))))^M^M(define-minor-mode shell-procfs-dirtrack-mode^M  "Track shell directory by inspecting procfs."^M  nil nil nil^M  (cond (shell-procfs-dirtrack-mode^M         (when (bound-and-true-p shell-dirtrack-mode)^M           (shell-dirtrack-mode 0))^M         (when (bound-and-true-p dirtrack-mode)^M           (dirtrack-mode 0))^M         (add-hook 'comint-preoutput-filter-functions^M                   'shell-procfs-dirtrack nil t))^M        (t^M         (remove-hook 'comint-preoutput-filter-functions^M                      'shell-procfs-dirtrack t))))^M^M(defun track-shell-directory/procfs ()^M  (shell-dirtrack-mode 0)^M  (add-hook 'comint-preoutput-filter-functions^M            (lambda (str)^M              (prog1 str^M                (when (string-match comint-prompt-regexp str)^M                  (cd (file-symlink-p^M                       (format "/proc/%s/cwd" (process-id^M                                               (get-buffer-process^M                                                (current-buffer)))))))))^M            nil t))^M(add-hook 'shell-mode-hook 'track-shell-directory/procfs)^M^M^M(shell "aa")^M;(rename-buffer "aa")^M(shell "z")^M;(rename-buffer "z")^M(put 'erase-buffer 'disable nil)^M(delete-other-windows)^M
