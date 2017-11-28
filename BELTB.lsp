;;  BELTB.lsp
;;  = change all Block Entities of definitions of a selected block and all
;;    nested block definitions within it to the Layer of the Top-level Block
;;  Kent Cooper, 18 November 2014

(vl-load-com)
(defun C:BELTB (/ *error* doc nametolist blkss inc blk lay blknames ent edata)

  (defun *error* (errmsg)
    (if (not (wcmatch errmsg "Function cancelled,quit / exit abort,console break"))
      (princ (strcat "\nError: " errmsg))
    ); if
    (vla-endundomark doc)
    (princ)
  ); defun - *error*

  (defun nametolist (blk / blkobj blkname); get Block name and put it into list of names
    (if (= (logand (cdr (assoc 70 (entget blk))) 4) 0) ; not an Xref
      (progn
        (setq
          blkobj (vlax-ename->vla-object blk)
          blkname
            (vlax-get-property blkobj
              (if (vlax-property-available-p blkobj 'EffectiveName) 'EffectiveName 'Name)
                ; to work with older versions that don't have dynamic Blocks
            ); ...get-property & blkname
        ); setq
        (if
          (not (member blkname blknames)); name not already in list
          (setq blknames (append blknames (list blkname))); then -- add to end of list
        ); if
      ); progn
    ); if
  ); defun -- nametolist

  (setq doc (vla-get-activedocument (vlax-get-acad-object)))
  (vla-startundomark doc); = Undo Begin

  (if (setq blkss (ssget "_+.:S" '((0 . "INSERT")))); User selection of a Block/Minsert/Xref
    (progn ; then
      (setq
        blk (ssname blkss 0); top-level Block insertion
        lay (cdr (assoc 8 (entget blk))); Layer it's inserted on
      ); setq
      (nametolist blk); put it in blknames list
      (while (setq blk (car blknames)); as long as there's another Block name in list
        ;; done this way instead of via (repeat) or (foreach), so it can add nested Blocks' names to list
        (setq ent (tblobjname "block" blk)); Block definition as entity
        (while (setq ent (entnext ent)); then -- proceed through sub-entities in definition
          (setq edata (entget ent)); entity data list
          (if (member '(0 . "INSERT") edata) (nametolist ent)); if nested Block, add name to end of list
          (entmod (subst (cons 8 lay) (assoc 8 edata) edata)); change to top-level Block's Layer
        ); while -- sub-entities
        (setq blknames (cdr blknames)); take first one off
      ); while
      (command "_.regen")
    ); progn
    (prompt "\nNo Block(s) selected.")
  ); if [user selection]

  (vla-endundomark doc); = Undo End
  (princ)
); defun