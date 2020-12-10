				; EMACS Configuration file

;; Initialize package manager and add melpa to package repositories
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; Create shortcut for common files
(set-register ?e (cons 'file "~/.emacs"))

;; Allways autoload files when changed on disc
(global-auto-revert-mode t)

;; C/C++ Code style defaults
(c-set-offset 'inlambda 0)
(setq c-default-style "stroustrup")
(setq-default indent-tabs-mode nil)

;; Don't want the menu and scrollbar to take up space
(menu-bar-mode -1)
(toggle-scroll-bar -1)
(tool-bar-mode -1)

;; Let's enable line numbers
;;(global-linum-mode nil)
(show-paren-mode 1)

;; Execute extended command with C binding
(global-set-key "\C-x\C-m" 'execute-extended-command)
(global-set-key "\C-c\C-m" 'execute-extended-command)

(when (fboundp 'winner-mode)
  (winner-mode 1))

;; Set default font to something nice
(add-to-list 'default-frame-alist
             '(font . "Fira Code-11"))

;; Do not create backupfiles in same folder as original file
(setq backup-directory-alist '(("." . "~/.emacs_saves")))

;; Use Package from here-on
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; Check for package updates every 4th day.
(use-package auto-package-update
  :ensure t
  :config
  (setq auto-package-update-delete-old-versions t
        auto-package-update-interval 4)
  (auto-package-update-maybe))

;; Better Navigation.... VIM mode
(use-package evil
  :ensure t
  :config
  (use-package undo-tree
    :ensure t
    :config
    (global-undo-tree-mode))
  (add-to-list 'evil-emacs-state-modes 'sly-mrepl-mode)
  (add-to-list 'evil-emacs-state-modes 'sly-db-mode)
  (add-to-list 'evil-emacs-state-modes 'slime-repl-mode)
  (add-to-list 'evil-emacs-state-modes 'eshell-mode)
  (evil-set-undo-system 'undo-tree)
  (evil-mode 1)
  (define-key evil-normal-state-map (kbd "M-.") nil))
  
;; Handle projects with projectile
(use-package projectile
  :ensure t
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  (setq projectile-project-search-path '("~/src"))
  (setq projectile-enable-caching t)
  :config
  (projectile-mode +1))

(use-package treemacs
  :ensure t
  :bind
  (:map global-map
	("C-c t" . treemacs))
  :init
  (setq treemacs-follow-mode t))

(use-package treemacs-evil
  :ensure t)

(use-package treemacs-projectile
  :ensure t
  :after treemacs projectile)

;; Misc Frameworks
(use-package flycheck
  :ensure t)

(use-package magit
  :ensure t)

(use-package which-key
  :ensure t
  :config
  (which-key-mode))

(use-package company
  :ensure t
  :config
  (global-company-mode)
  (use-package company-quickhelp
    :ensure t
    :config
    (company-quickhelp-mode)))

(use-package yasnippet
  :ensure t
  :config
  (yas-global-mode 1))

(use-package ivy
  :ensure t
  :config
  (define-key ivy-minibuffer-map (kbd "RET") #'ivy-alt-done)
  (define-key ivy-minibuffer-map (kbd "C-j") #'ivy-immediate-done)
  (ivy-mode 1))

(use-package ivy-xref
  :ensure t
  :init
  ;; xref initialization is different in Emacs 27 - there are two different
  ;; variables which can be set rather than just one
  (when (>= emacs-major-version 27)
    (setq xref-show-definitions-function #'ivy-xref-show-defs))
  ;; Necessary in Emacs <27. In Emacs 27 it will affect all xref-based
  ;; commands other than xref-find-definitions (e.g. project-find-regexp)
  ;; as well
  (setq xref-show-xrefs-function #'ivy-xref-show-xrefs))

(use-package counsel-projectile
  :ensure t
  :config
  (counsel-projectile-mode 1))

;; LSP
(use-package eglot
  :ensure t
  :bind
  (("C-c e r" . eglot-rename)
   ("C-c e f" . eglot-format)
   ("C-c e a" . eglot-code-actions)
   ("C-c e h" . eglot-help-at-point))
  :hook
  ((c++-mode c-mode) . eglot-ensure)
  ((python-mode) . eglot-ensure)
  :config
  (add-to-list 'eglot-server-programs
	       '((c++-mode c-mode) . ("clangd" "--header-insertion=never"
				      "--clang-tidy")))
  (add-to-list 'eglot-server-programs
               '((rust-mode) . ("rls"))))

;; Commonlisp Development

(use-package sly
  :ensure t
  :init
  (setq inferior-lisp-program "sbcl"))

(use-package slime-company
  :ensure t
  :disabled
  :defer t)

(use-package slime
  :ensure t
  :config
  :disabled
  (require 'slime-autoloads)
  :init
  (setq inferior-lisp-program "sbcl")
  (setq slime-contribs '(slime-fancy
                         slime-company
                         slime-autodoc
                         slime-asdf)))

;; C++ Programming Goodies
(use-package modern-cpp-font-lock
  :ensure t)

;; Themes

(use-package flatui-theme
  :ensure t
  :config
  (load-theme 'flatui t))

(use-package afternoon-theme
  :ensure t
  :config
  :disabled
  (load-theme 'afternoon t))

(use-package doom-themes
  :ensure t
  :config
  :disabled
  (load-theme 'doom-solarized-light t))

;; Additional modes

(use-package rust-mode
  :ensure t
  :config
  (add-hook 'rust-mode-hook
            (lambda () (setq indent-tabs-mode nil))))

(use-package beacon
  :ensure t
  :config
  (beacon-mode 1))

(use-package js2-mode
  :ensure t
  :init
  (add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode)))

(use-package vue-mode
  :ensure t)

(use-package org
  :ensure t)

(use-package cmake-mode
  :ensure t)

(use-package glsl-mode
  :ensure t)

(use-package yaml-mode
  :ensure t)

(use-package cmake-font-lock
  :ensure t)

(use-package udev-mode
  :ensure t)

(use-package protobuf-mode
  :ensure t)

(use-package dockerfile-mode
  :ensure t)

(use-package groovy-mode
  :ensure t)

(use-package golden-ratio
  :ensure t
  :disabled
  :config
  (golden-ratio-mode 1))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("57e3f215bef8784157991c4957965aa31bac935aca011b29d7d8e113a652b693" default))
 '(package-selected-packages
   '(flatui-theme magit glsl-mode golden-ratio afternoon-theme ivy-xref counsel-projectile counsel-projectile-mode auto-package-update yaml-mode yasnippet which-key vue-mode use-package udev-mode treemacs-projectile treemacs-evil rust-mode rainbow-delimiters protobuf-mode modern-cpp-font-lock js2-mode helm-projectile groovy-mode flycheck eglot doom-themes dockerfile-mode company-quickhelp cmake-font-lock beacon)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t nil))))
