;;; file: RB_en.lsp                                                 ;;;
;;; data: 22/10/2008                                                ;;;
;;; note: Rename the selected block.                                ;;;
;;;                                                                 ;;;
;;; aggiornamento: (Versione 2) - 01/04/2009                        ;;;
;;;              - default sulla casella OK                         ;;;
;;;              - controllo esistenza nome blocco                  ;;;
;;;                                                                 ;;;
;;; aggiornamento: (Versione 3) - 02/04/2009                        ;;;
;;;              - allargata casella editazione nome blocco         ;;;
;;;                                                                 ;;;
;;; aggiornamento: (Versione 4) - 28/10/2012                        ;;;
;;;              - rinomina blocchi dinamici e blocchi anonimi      ;;;
;;;              - creazione di blocchi anonimi                     ;;;
;;;              - inglobamento DCL nel lisp                        ;;;
;;;                                                                 ;;;
;;; aggiornamento: (V. 4_en) - 20/05/2013                           ;;;
;;;              - English Version (for CADTutor)                   ;;;
;;;                                                                 ;;;
;;; autore: Gian Paolo Cattaneo                                     ;;;
 
 
(defun c:RB (/ :bb old new dcl_id)
    (prompt "\n ") (prompt "\n ") (prompt "\n ")
    (if
        (while (not :bb)
            (setvar 'errno 0)
            (setq :bb (car (entsel "\nSelect block to RENAME:")))
            (if (= 7 (getvar 'errno))
                (alert "Nothing selected.  Try again.")
            )
            (if (= 'ename (type :bb))
                (if (null (wcmatch (cdr (assoc 0 (entget :bb))) "INSERT"))
                    (progn
                        (alert "Item selected is not a block.")
                        (setq :bb nil)
                    )
                    (progn
                        (setq old (vla-get-effectivename (vlax-ename->vla-object :bb)))
                    )
                )
            )
        )
        (progn
            (RB_dcl)
            (while
                (and
                    (/= (strcase old) (strcase new))
                    (tblsearch "BLOCK" new)
                )
                (alert "A block with this name already exists")
                (RB_dcl)
            )
            (vla-put-Name
                (vla-item
                    (vla-get-blocks
                        (vla-get-activedocument
                            (vlax-get-acad-object)
                        )
                    )
                    old
                )
                new
            )
        )
    )
    (prompt "\n ") (prompt "\n ") (prompt "\n ")
    (princ)
)
 
(defun RB_dcl ( / DCLname)
    (setq DCLname (strcat (getvar 'localrootprefix) "RB_V4_en.dcl"))
    (if (not (findfile DCLname)) (crea_dcl_RB))   
    (if (= POSIZ_DCL_RB nil) (setq POSIZ_DCL_RB (list -1 -1)))   
    (setq dcl_id (load_dialog DCLname))       
    (if (not (new_dialog "RB4" dcl_id "" POSIZ_DCL_RB)) (exit))    
    (setq new old)
    (set_tile "new" new)
    (action_tile "new" "(setq new $value)")
    (start_dialog)
    (unload_dialog dcl_id)
)
 
(defun crea_dcl_RB (/ fn f)
    (setq fn  DCLname)
    (setq f (open fn "w"))
    (write-line "RB4:dialog {" f)
    (write-line "label = \"RB - Rename Block (Vers. 4_en)\";" f)
    (write-line "" f)
    (write-line "    initial_focus=\"new\";" f)
    (write-line "" f)
    (write-line "    : spacer {}" f)
    (write-line "    : spacer {}" f)
    (write-line "    : spacer {}" f)
    (write-line "" f)
    (write-line "    : text {" f)
    (write-line "    label = \"New Block Name:\";" f)
    (write-line "    alignment = centered;" f)
    (write-line "    } " f)
    (write-line "" f)
    (write-line "    : text {" f)
    (write-line "    label = \"(type:  *U  to create an Anonymous Block)\";" f)
    (write-line "    alignment = centered;" f)
    (write-line "    } " f)
    (write-line "" f)
    (write-line "    : spacer {}" f)
    (write-line "" f)    
    (write-line "    : edit_box {" f)
    (write-line "    key=\"new\";" f)
    (write-line "    allow_accept=true;" f)
    (write-line "    }" f)
    (write-line "" f)
    (write-line "    : spacer {}" f)
    (write-line "    : spacer {}" f)
    (write-line "    : spacer {}" f)
    (write-line "" f)
    (write-line "    ok_only;" f)
    (write-line "" f)
    (write-line "    : spacer {}" f)
    (write-line "    : spacer {}" f)
    (write-line "    : spacer {}" f)
    (write-line "" f)
    (write-line "    : text { " f)
    (write-line "    label = \"Copyright  ©  2012  -  Gian Paolo Cattaneo\";" f)
    (write-line "    alignment = centered;" f)
    (write-line "    }" f)
    (write-line "" f)
    (write-line "}" f)
    (close f)
    (load_dialog fn)
)
;******************************************************************************
(vl-load-com)
(prompt "\n ") (prompt "\n ") (prompt "\n ")
(princ "\nRename Block (V.4_en) - by Gian Paolo Cattaneo")
(princ "\nType  RB  to Start")
(princ)