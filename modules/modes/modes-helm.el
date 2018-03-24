;;; modes-helm.el --- Tiqsi helm configuration

;;; Commentary:
;; 


;---{Fuzzy Search}--;

(helm-flx-mode 1)
(setq helm-flx-for-helm-find-files t ;; t by default
      helm-flx-for-helm-locate t) ;; nil by default



;-{Patch Helpful.el};

;; (defun helm-describe-function (func)
;;   "FUNC is symbol or string."
;;   (cl-letf (((symbol-function 'message) #'ignore))
;; 	(helpful-function (helm-symbolify func))
;;      ))


;; (defun helm-describe-function (func)
;;   "FUNC is symbol or string."
;;   (cl-letf (((symbol-function 'message) #'ignore))
;;     (condition-case err
;; 	(progn
;; 	  (helpful-function (helm-symbolify func)))
;;       (argument-error
;;        (progn
;; 	 (describe-function (helm-symbolify func)))))
;;     nil
;; ))


;------{Resize}-----;

(helm-autoresize-mode 1)
(setq helm-autoresize-max-height 30)
(setq helm-autoresize-min-height 10)



;---{Performance}---;

(setq helm-idle-delay 0.0 ; update fast sources immediately (doesn't).
      helm-input-idle-delay 0.01  ; this actually updates things
					; reeeelatively quickly.
      helm-quick-update t
      helm-M-x-requires-pattern nil
      helm-ff-skip-boring-files t)


;-------{M-x}-------;

(setq helm-M-x-fuzzy-match t) ;; optional fuzzy matching for helm-M-x


(setq helm-buffers-fuzzy-matching t
      helm-recentf-fuzzy-match t)

;------{Google}-----;
;TODO helm-youtube support                                                                          ;

(when (executable-find "curl")
  (setq helm-net-prefer-curl t))



;----{Horizontal}---;

(setq helm-split-window-in-side-p           t ; open helm buffer inside current window, not occupy whole other window
      helm-move-to-line-cycle-in-source     t ; move to end or beginning of source when reaching top or bottom of source.
      helm-ff-search-library-in-sexp        t ; search for library in `require' and `declare-function' sexp.
      helm-scroll-amount                    8 ; scroll 8 lines other window using M-<next>/M-<prior>
      helm-ff-file-name-history-use-recentf t
      helm-echo-input-in-header-line t)

(setq helm-split-window-default-side 'below)


;--{Semantic Imenu}-;

(setq helm-semantic-fuzzy-match t
      helm-imenu-fuzzy-match    t)


(setq helm-lisp-fuzzy-completion t)

;-{Locate Any File}-;

;(shell-command "choco install; everything")
(setq helm-locate-fuzzy-match t)


(setq helm-apropos-fuzzy-match t)


;--{Eshell History}-;

(add-hook 'eshell-mode-hook
          #'(lambda ()
              (define-key eshell-mode-map (kbd "C-c C-l")  'helm-eshell-history)))


;------{Python}-----;

;; (with-eval-after-load "python"
;;   (define-key python-mode-map (kbd "C-c hd") 'helm-pydoc))


(setq helm-dash-docsets-path (format "%s/.emacs.d/docsets" (getenv "HOME")))
;; (setq helm-dash-common-docsets '(("NumPy") ("Redis") ("Pandas")))
(setq helm-dash-browser-func 'browse-url-generic)


(defun py-doc ()
  (interactive)
  (setq-local helm-dash-docsets '(("NumPy") ("Pandas"))))

(add-hook 'py-mode-hook 'py-doc)


;---{Buffer Funcs}--;

(defun amitp/buffer-file-names ()
  "A list of filenames for the current buffers"
  (loop for filename in (mapcar 'buffer-file-name (buffer-list))
        when filename
        collect filename))

(defun amitp/helm-for-files ()
  "Global filename match, over all files I typically open"
  (interactive)
  (let ((helm-ff-transformer-show-only-basename nil)
        (recentf-list
         (mapcar 'abbreviate-file-name
                 (append (amitp/buffer-file-names)
                         (helm-skip-boring-files (directory-files default-directory t))
                         recentf-list
                         ;amitp/global-file-list
			 ))))
    (helm
     :sources '(helm-source-recentf)
     :buffer "*helm for files*")))


(defun amitp/helm-locate (candidate)
  "Fallback when helm-recentf doesn't find what I want"
  (interactive)
  (helm :sources '(helm-source-locate helm-source-find-files)
        :buffer "*helm locate*"
        :input helm-input
        :resume 'noresume))

(defun amitp/helm-for-files-fallback ()
  (interactive)
  (helm-quit-and-execute-action 'amitp/helm-locate))


;--{Prog Headlines}-;

(defun helm-objc-headlines ()
  (interactive)
  (helm :sources '(((name . "Objective-C Headlines")
                    (volatile)
                    (headline  "^[-+@]\\|^#pragma mark")))))

(defun helm-clojure-headlines ()
  "Display headlines for the current Clojure file."
  (interactive)
  (helm-mode t)
  (helm :sources '(((name . "Clojure Headlines")
                    (volatile)
                    (headline "^[;(]")))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; PACKAGE: helm-descbinds                      ;;
;;                                              ;;
;; GROUP: Convenience -> Helm -> Helm Descbinds ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(helm-descbinds-mode)


;----{Swoop Edit}---;

;; If this value is t, split window inside the current window
(setq helm-swoop-split-with-multiple-windows nil)

;; Split direcion. 'split-window-vertically or 'split-window-horizontally
(setq helm-swoop-split-direction 'split-window-vertically)

;; If nil, you can slightly boost invoke speed in exchange for text color
(setq helm-swoop-speed-or-color t)

;; Optional face for line numbers
;; Face name is `helm-swoop-line-number-face`
(setq helm-swoop-use-line-number-face t)

;; If you prefer fuzzy matching
(setq helm-swoop-use-fuzzy-match t)

;; If there is no symbol at the cursor, use the last used words instead.
(setq helm-swoop-pre-input-function
      (lambda ()
        (let (($pre-input (thing-at-point 'symbol)))
          (if (eq (length $pre-input) 0)
              helm-swoop-pattern ;; this variable keeps the last used words
            $pre-input))))

;----{Multi term}---;

;; (package-install 'helm-mt)
;; (try-require 'helm-mt)
;; (when casey-linux
;;   (helm-mt/reroute-terminal-functions t))

;; (define-key global-map (kbd "C-c ho") 'helm-occur)

;---{TODO re add}---;

;; (global-set-key "\C-chr"
;;                 (lambda () (interactive)
;;                   (imenu--menubar-select imenu--rescan-item)))


;-----{HYDRAS!}-----;

(defhydra hydra-window-stuff (:hint nil)
    "
          Split: _v_ert  _s_:horz
         Delete: _c_lose  _o_nly
  Switch Window: _h_:left  _j_:down  _k_:up  _l_:right
        Buffers: _p_revious  _n_ext  _b_:select  _f_ind-file  _F_projectile
         Winner: _u_ndo  _r_edo
         Resize: _H_:splitter left  _J_:splitter down  _K_:splitter up  _L_:splitter right
           Move: _a_:up  _z_:down  _i_menu"


    ("z" scroll-up-line)
    ("a" scroll-down-line)
    ("i" idomenu)

    ("u" winner-undo)
    ("r" winner-redo)

    ("h" windmove-left)
    ("j" windmove-down)
    ("k" windmove-up)
    ("l" windmove-right)

    ("p" previous-buffer)
    ("n" next-buffer)
    ("b" ido-switch-buffer) 
    ("f" ido-find-file)
    ("F" projectile-find-file)

    ("s" split-window-below)
    ("v" split-window-right)

    ("c" delete-window)
    ("o" delete-other-windows)

    ("H" hydra-move-splitter-left)
    ("J" hydra-move-splitter-down)
    ("K" hydra-move-splitter-up)
    ("L" hydra-move-splitter-right)

    ("q" nil))

;; Hydra for in Helm
(defhydra helm-like-unite ()
  "vim movement"
  ("?" helm-help "help")
  ("q" nil "exit")
  ("<SPC>" helm-toggle-visible-mark "mark")
  ("d" helm-buffer-run-kill-persistent "Delete selection")
  ("a" helm-toggle-all-marks "(un)mark all")
  ;; not sure if there's a better way to this
  ("/" (lambda ()
	 (interactive)
	 (execute-kbd-macro [?\C-s]))
   "search")
  ("v" helm-execute-persistent-action)
  ("g" helm-beginning-of-buffer "top")
  ("h" helm-previous-source)
  ("l" helm-next-source)
  ("G" helm-end-of-buffer "bottom")
  ("j" helm-next-line "down")
  ("k" helm-previous-line "up")
  ("i" nil "cancel"))

;; (define-key helm-map "jk" 'helm-like-unite/body)  

					;-------------{Keybindings}------------;
;; (defhydra hydra-helm-bookmarks (:color pink
;;                              :hint nil)
;;   "
;; ^^             ^Movement^           ^Search^          ^Misc
;; ^^^^^^^^-----------------------------------------------------------------
;; _i_: Imenu-Semantic          _b_: Check buffers        _o_: Occurrences       _k_: Show Kill Ring
;; _e_: Etags          _U_: unmark up     _h_: Apropos          _SPC_: Show Mark Ring
;; _d_: delete        ^ ^                _i_: Imenu-Semantic       _O_: multi-occur
;; _d_: delete        ^ ^                _i_: Imenu-Semantic       _O_: multi-occur
;; _d_: delete        ^ ^                _i_: Imenu-Semantic       _O_: multi-occur

;; _D_: delete up     ^ ^                _T_: files only: % -28`Buffer-menu-files-only
;; _j_: jedi:related-names
;; "
;;   ("m" Buffer-menu-mark)
;; )

;; TODO Mode specific hydras send to something else
(defhydra hydra-helm-menu (:color pink
                             :hint nil)
  "
^Code^                ^Movement^           ^Search^               ^Misc
^^^^^^^^---------------------------------------------------------------------------------
_i_: Imenu-Semantic    _f_: Filesystem     _o_: Occurrences       _k_: Show Kill Ring
_e_: Etags             ^ ^                 _h_: Apropos           _SPC_: Show Mark Ring
_r_: Regexp            ^ ^                 _g_: google suggest    _bc_: Chrome bookmarks
_le_: Lisp Eval        ^ ^                 _i_: Imenu-Semantic    _x_: helm-register
_sws_: Swoop           ^ ^                 _a_: Imenu-anywhere    _cp_: Colour picker
_swm_: Swoop multi     ^ ^                 _m_: man woman pages   _ca_: Calculator
_swa_: Swoop all       ^ ^                 _lf_: Locate Files     ^ ^
_swi_: Swoop from Is   ^ ^                 _ss_: Ag search        ^ ^
_pd_: Python Doc       ^ ^                 _sp_: Ag Project-root  ^ ^
_j_: jedi:related-names
"
  ;; ("w" hydra-window-stuff :color blue)
  ;{references using jedi};
  ("j" helm-jedi-related-names :color blue)
  ;----{Ocurrences}---;
  ("o" helm-occur :color blue)
  ;----{helm etags}---;
  ("e" helm-etags-plus-select :color blue)
  ;{semantic or imenu};
  ("i" helm-semantic-or-imenu :color blue)
  ;-----{Apropos}-----;
  ("h" helm-apropos :color blue)
  ;-{browse kill ring};
  ("k" helm-show-kill-ring :color blue)
  ;-{browse mark ring};
  ("SPC" helm-mark-ring :color blue)
  ;--{google suggest}-;
  ("g" helm-google-suggest :color blue)
  ;----{bookmarks}----;
  ("bb" helm-bookmarks :color blue)
  ;-{chrome bookmarks};
  ("bc" helm-chrome-bookmarks :color blue)
  ;--{anywhere Imenu}-;
  ("a" helm-imenu-anywhere :color blue)
  ;-----{Regexp }-----;
  ("r" helm-regexp :color blue)
  ;----{Registers}----;
  ("x" helm-register :color blue)
  ;---{Colour picker}--;
  ("cp" helm-colors :color blue)
  ;----{Calculator}---;
  ("ca" helm-calcul-expression :color blue)
  ;----{man-pages}----;
  ("m" helm-man-woman :color blue)
  ;----{Find files}---;
  ("f" helm-find-files :color blue)
  ;---{Locate Files}--;
  ("lf" helm-locate :color blue)
  ;----{Eval elisp}---;
  ("le" helm-eval-expression-with-eldoc :color blue)
  ;------{Swoop}------;
  ("sws" helm-swoop :color blue)
  ("swm" helm-multi-swoop :color blue)
  ("swa" helm-multi-swoop-all :color blue)
  ("swi" helm-swoop-from-isearch :color blue)
  ;{Python documentation};
  ("pd" helm-pydoc :color blue)
  ;--{Search with Ag}-;
  ("ss" helm-ag :color blue)
  ;-{Ag project root}-;
  ("sp" helm-ag-project-root :color blue)
  ("c" nil "cancel")
  ("q" quit-window "quit" :color blue))

(define-key global-map (kbd "C-c h") 'hydra-helm-menu/body)



;{TODO move this to a hydra specific...;

(defhydra hydra-buffer (:color blue :columns 3)
  "
                Buffers :
  "
  ("n" next-buffer "next" :color red)
  ("b" ivy-switch-buffer "switch")
  ("B" ibuffer "ibuffer")
  ("p" previous-buffer "prev" :color red)
  ("C-b" buffer-menu "buffer menu")
  ("N" evil-buffer-new "new")
  ("d" kill-this-buffer "delete" :color red)
  ;; don't come back to previous buffer after delete
  ("D" (progn (kill-this-buffer) (next-buffer)) "Delete" :color red)
  ("s" save-buffer "save" :color red))



;---{Keybindings}---;

(global-set-key (kbd "M-x") 'helm-smex)
(global-set-key (kbd "M-X") 'helm-smex-major-mode-commands)
;(global-set-key ( kbd "C-c h") 'helm-command-prefix)
(global-unset-key (kbd "C-x c"))


(define-key minibuffer-local-map (kbd "C-c C-l") 'helm-minibuffer-history) ;; For Minibuffer
(define-key shell-mode-map (kbd "C-c C-l") 'helm-comint-input-ring) ;; For Shell
(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebind tab to run persistent action
(define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB work in terminal
(define-key helm-map (kbd "C-z")  'helm-select-action) ; list actions using C-z
(define-key global-map (kbd "C-c b") 'helm-mini) ;; Browse Open Buffers
(global-set-key (kbd "C-<return>") 'ac-complete-with-helm)

(define-key global-map (kbd "M-i") 'helm-swoop-back-to-last-point)
;; (define-key global-map (kbd "C-c ss") 'helm-swoop)
;; (define-key global-map (kbd "C-c sm") 'helm-multi-swoop)
;; (define-key global-map (kbd "C-c sa") 'helm-multi-swoop-all)


;; (define-key isearch-mode-map (kbd "M-i") 'helm-swoop-from-isearch)
;(define-key helm-swoop-map (kbd "M-i") 'helm-multi-swoop-all-from-helm-swoop)
;; (define-key global-map (kbd "C-c hbb") 'helm-bookmarks) ;; Bookmarks support
;; (define-key global-map (kbd "C-c hbc") 'helm-chrome-bookmarks) ;; Chrome Bookmarks
;; (define-key global-map (kbd "C-c hg") 'helm-google-suggest) ;; Google Support
;; (define-key global-map (kbd "C-c ha") 'helm-imenu-anywhere) ;; Search Anywhere
;; (define-key global-map (kbd "C-c hr") 'helm-regexp) ;; Helm Regex Search
;; (define-key global-map (kbd "C-c hx") 'helm-register) ;; Register inspection
;; (define-key global-map (kbd "C-c hcp") 'helm-colors) ;; Colour Picker
;; (define-key global-map (kbd "C-c hcc") 'helm-calcul-expression) ;; Calculator helm interface
;; (define-key global-map (kbd "C-c hm") 'helm-man-woman) ;; Manpages inspect
;; (define-key global-map (kbd "C-c hf") 'helm-find-files) ;; Helm find files
;; (define-key global-map (kbd "C-c f") 'helm-locate) ;; Helm Locate Files
;; (global-set-key (kbd "C-c h M-:") 'helm-eval-expression-with-eldoc) ;; Eval Elisp
;;(global-set-key (kbd "C-M-]") (lambda () (interactive) (org-cycle t))) ;; Cycle through














;-{TODO re include}-;

;; (when casey-win32
;;   (global-set-key (kbd "C-c hwl") 'helm-w32-launcher)
;;   (global-set-key (kbd "C-c hwe") 'helm-w32-launcher-elevated)
;;   (global-set-key (kbd "C-c hwd") 'helm-w32-launcher-open-shortcut-directory)
;;   ;; (global-set-key (kbd "C-c hwp") 'helm-w32-launcher-open-shortcut-properties)
;;   (global-set-key (kbd "C-c hwr") 'helm-w32-launcher-flush-cache)
;;   )
;; (when casey-win32 

;-{TODO re include}-;

;; (when casey-linux
;;   (define-key global-map (kbd "C-c ht") (helm-mt "multi-term")))

;----{imenu tags}---;

;; (define-key global-map (kbd "C-c ht") 'helm-imenu)

;----{helm etags}---;

;; (define-key global-map (kbd "C-c he") 'helm-etags-plus-select)

;; ;{semantic or imenu};

;; (define-key global-map (kbd "C-c hi") 'helm-semantic-or-imenu)

;-----{Apropos}-----;

;; (define-key global-map (kbd "C-c hh") 'helm-apropos)

;-{browse kill ring};

;; (define-key global-map (kbd "C-c hk") 'helm-show-kill-ring)

;-{browse mark ring};

;; (define-key global-map (kbd "C-c h SPC") 'helm-mark-ring)
;;   (define-key global-map (kbd "C-c ht") (helm-mt "shell")))



(provide 'modes-helm)

;;; modes-helm.el ends here