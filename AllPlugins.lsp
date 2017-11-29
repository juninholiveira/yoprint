(vl-load-com)

(setvar "BACKGROUNDPLOT" 2)	                                                    ;Aqui eu seto a vari�vel do sistema pra PLOT em foreground e PUBLISH em background (N�mero 2)

;Aui eu reseto os
(SETQ ORIGPATH (STRCAT (GETENV "ACAD")";"))
(SETQ ONEPATH (STRCAT "R:\\INTERIORES\\1.Padr�o\\Padr�o PB - AutoCad\\Plugins\\PluginsToLoad;R:\\INTERIORES\\1.Padr�o\\Padr�o PB - AutoCad\\Hachuras"));ADD PATHS HERE, NOT TO MANY OR IT GETS CUT OFF
(SETQ MYENV (STRCAT ORIGPATH ONEPATH))
(SETENV "ACAD" MYENV)
(strlen (getenv "ACAD"));DON'T GO OVER 800 OR BAD THINGS HAPPEN


(defun C:yoprint ()

    (if (> (substr (rtos (getvar 'cdate) 2 0) 3) "180101")                      ;Avalia��o de data para ver se o programa expirou

        (progn                                                                  ;Se o programa tiver expirado
          (princ "Error 404 - Not Found")                                       ;Mensagem que exibe
          (princ "\n")
          (exit)                                                                ;Cancela toda a rotina

        ); progn

        (progn                                                                  ;Se o programa N�O tiver expirado
          (setq dcl_id (load_dialog "interface.dcl"))
          (if (not (new_dialog "interface" dcl_id))
            (exit )
          );if
        ); progn

    );if



;CANCEL
(action_tile "cancel" "(done_dialog)(exit)(princ)")

(action_tile "printalltopdf" "(done_dialog 0)")
(action_tile "printalla3" "(done_dialog 1)")
(action_tile "printsinglesheet" "(done_dialog 2)")

(action_tile "layout" "(done_dialog 3)")
(action_tile "hidraulico" "(done_dialog 4)")
(action_tile "eletrico" "(done_dialog 5)")
(action_tile "luminotecnico" "(done_dialog 6)")
(action_tile "secoes" "(done_dialog 15)")
(action_tile "forro" "(done_dialog 7)")
(action_tile "piso" "(done_dialog 8)")
(action_tile "arcondicionado" "(done_dialog 9)")
(action_tile "reexibir" "(done_dialog 10)")

(action_tile "fixallcotas" "(done_dialog 11)")
(action_tile "fixsomecotas" "(done_dialog 12)")

(action_tile "changelayercolor" "(done_dialog 13)")
(action_tile "changelayercolorback" "(done_dialog 14)")

(action_tile "beltb" "(done_dialog 17)")
(action_tile "listagemindividual" "(done_dialog 16)")

(setq main_flag (start_dialog))

(cond
   ((= main_flag 0) (printalltopdf))
   ((= main_flag 1) (printalla3))
   ((= main_flag 2) (printsinglesheet))

   ((= main_flag 3) (layout))
   ((= main_flag 4) (hidraulico))
   ((= main_flag 5) (eletrico))
   ((= main_flag 6) (luminotecnico))
   ((= main_flag 15) (secoes))
   ((= main_flag 7) (forro))
   ((= main_flag 8) (piso))
   ((= main_flag 9) (arcondicionado))
   ((= main_flag 10) (reexibir))

   ((= main_flag 11) (fixallcotas))
   ((= main_flag 12) (fixsomecotas))

   ((= main_flag 13) (changecolorstogrey))
   ((= main_flag 14) (changecolorsback))

   ((= main_flag 17) (beltb))
   ((= main_flag 16) (listagemindividual))
)


;Start and unload the DCL
(start_dialog)
(unload_dialog dcl_id)

(princ)

);defun

; ****************************************************************************************************************************

;PRINTALLTOPDF ***************************************************************************************************************
(defun printalltopdf (/ dwg file hnd i len llpt lst mn mx ss tab urpt subfolder cpath newpath currententity scale)

  (setq p1 (getpoint "\nFa�a a sele��o das pranchas � serem impressas:"))
  (setq p2 (getcorner p1))

  (setq nomeescolhido(getstring "\nDigite um nome para as pranchas:"))

    (if (setq ss (ssget "_C" p1 p2 '((0 . "INSERT") (2 . "A4-25,A4-50,A4-75,A4-100,A4-125"))))
        (progn
            (repeat (setq i (sslength ss))
                (setq hnd (ssname ss (setq i (1- i)))
                      tab (cdr (assoc 410 (entget hnd)))
                      lst (cons (cons tab hnd) lst)
                )
            )
            (setq lst (vl-sort lst '(lambda (x y) (> (car x) (car y)))))
            (setq i 0)

            (foreach x lst
              ;Pego o nome do bloco (A4025, A4-50, etc)
              (setq entityname (vla-get-effectivename (vlax-ename->vla-object (cdr x))))

              (if
                (= entityname "A4-25")
                (setq escala "1=2.5")
              )
              (if
                (= entityname "A4-50")
                (setq escala "1=5")
              )
              (if
                (= entityname "A4-75")
                (setq escala "1=7.5")
              )
              (if
                (= entityname "A4-100")
                (setq escala "1=10")
              )
              (if
                (= entityname "A4-125")
                (setq escala "1=12.5")
              )

;Fa�o a sele��o da �rea da prancha
(vla-getboundingbox (vlax-ename->vla-object (cdr x)) 'mn 'mx)
                (setq llpt (vlax-safearray->list mn)
                      urpt (vlax-safearray->list mx)
                      len  (distance llpt (list (car urpt) (cadr llpt)))
                )

; Aqui embaixo eu crio uma Subpasta, onde ser� salvo o Output
; Var "SUBFOLDER" indica o nome da pasta a ser criada
		(setq subfolder "PDFs")
		(setq cpath (getvar "dwgprefix"))
		(Setq newpath (strcat cpath subfolder))
		(if (not (findfile newpath))
			(vl-mkdir newpath)
		)

                (setq file (strcat newpath
				   "\\"
           nomeescolhido
           " "
				   (substr (setq ptx (rtos (cadr urpt) 2 0)) 1 5)
				   " - "
				   (substr (setq ptx (rtos (car urpt) 2 0)) 1 5)
                                   ".pdf"
                           )
                )

                ;Deleto arquivos antigos
                (if (findfile file)
                    (vl-file-delete file)
                )


                (command "-plot"
                         "yes"
                         (car x)
                         "DWG TO PDF.PC3"
                         "ISO FULL BLEED A4 (297.00 x 210.00 MM)"
                         "Millimeters"
                         "Landscape"
                         "No"
                         "Window"
                         llpt
                         urpt
                         escala
                         "Center"
                         "yes"
                         "ctb - paula e bruna.ctb"
                         "yes"
                         ""
                )

                (if (/= (car x) "Model")
                    (command "No" "No" file "no" "Yes")
                    (command
                        file
                        "no"
                        "Yes"
                    )
                )
            );foreach
            (setq lst nil)
        );progn
    );if
    (princ)
);defun
;PRINTALLTOPDF ***************************************************************************************************************

;PRINTALLA3 ***************************************************************************************************************
(defun printalla3 (/ dwg file hnd i len llpt mn mx  tab urpt subfolder cpath newpath currententity scale
		       lst2
		       ss2
		    )


;Aqui eu pe�o pro usu�rio qual orienta��o ele quer imprimir
(initget "Landscape Portrait")
(setq orientation (cond ( (getkword "\nChoose [Landscape/Portrait] <Landscape>: ") ) ( "Landscape" )))

(initget "A4-50 A4-75 A4-100 A4-125 A3-50 A3-75 A3-100 A3-125 A2-50 A2-75 A2-100 A2-125")
(setq blocksize (cond ( (getkword "\nChoose [A4-50/A4-75/A4-100/A4-125/A3-50/A3-75/A3-100/A3-125/A2-50/A2-75/A2-100/A2-125] <A3-100>: ") ) ( "A3-100" )))




(if (setq ss2 (ssget "_X" (list '(0 . "INSERT") (cons 2 blocksize))))
        (progn
            (repeat (setq i (sslength ss2))
                (setq hnd (ssname ss2 (setq i (1- i)))
                      tab (cdr (assoc 410 (entget hnd)))
                      lst2 (cons (cons tab hnd) lst2)
                )
            )
            (setq lst2 (vl-sort lst2 '(lambda (x y) (> (car x) (car y)))))
            (setq i 0)

	    ;Crio uma vari�vel para armazenar um numero que ser� usado dentro do FOREACH, e zerado quando sair
	    ;(setq plantanumber 1)

			(setq count 0)

			(repeat 8


				( progn


				(if (= count 0) (setq none(layout)))
				(if (= count 1) (setq none(hidraulico)))
				(if (= count 2) (setq none(eletrico)))
				(if (= count 3) (setq none(luminotecnico)))
				(if (= count 4) (setq none(secoes)))
				(if (= count 5) (setq none(forro)))
				(if (= count 6) (setq none(piso)))
				(if (= count 7) (setq none(arcondicionado)))

				(if (= count 0) (setq none(changecolorsback)))
				(if (= count 1) (setq none(changecolorstogrey)))
				(if (= count 2) (setq none(changecolorstogrey)))
				(if (= count 3) (setq none(changecolorstogrey)))
				(if (= count 4) (setq none(changecolorsback)))
				(if (= count 5) (setq none(changecolorsback)))
				(if (= count 6) (setq none(changecolorsback)))
				(if (= count 7) (setq none(changecolorstogrey)))

				(setq nomedaplanta "error")
				(if (= count 0) (setq nomedaplanta "Layout"))
				(if (= count 1) (setq nomedaplanta "Hidr�ulico"))
				(if (= count 2) (setq nomedaplanta "El�trico"))
				(if (= count 3) (setq nomedaplanta "Luminot�cnico"))
				(if (= count 4) (setq nomedaplanta "Se��es"))
				(if (= count 5) (setq nomedaplanta "Forro"))
				(if (= count 6) (setq nomedaplanta "Piso"))
				(if (= count 7) (setq nomedaplanta "Ar Condicionado"))

				(setq escala "Fit")
				(if (= blocksize "A4-50") (setq escala "1=5"))
				(if (= blocksize "A4-75") (setq escala "1=7.5"))
				(if (= blocksize "A4-100") (setq escala "1=10"))
				(if (= blocksize "A4-125") (setq escala "1=12.5"))

				(if (= blocksize "A3-50") (setq escala "1=5"))
				(if (= blocksize "A3-75") (setq escala "1=7.5"))
				(if (= blocksize "A3-100") (setq escala "1=10"))
				(if (= blocksize "A3-125") (setq escala "1=12.5"))

				(if (= blocksize "A2-50") (setq escala "1=5"))
				(if (= blocksize "A2-75") (setq escala "1=7.5"))
				(if (= blocksize "A2-100") (setq escala "1=10"))
				(if (= blocksize "A2-125") (setq escala "1=12.5"))

				(setq papersize "Fit")
				(if (= blocksize "A4-75") (setq papersize "ISO FULL BLEED A4 (297.00 x 210.00 MM)"))
				(if (= blocksize "A4-100") (setq papersize "ISO FULL BLEED A4 (297.00 x 210.00 MM)"))
				(if (= blocksize "A4-125") (setq papersize "ISO FULL BLEED A4 (297.00 x 210.00 MM)"))
				(if (= blocksize "A3-75") (setq papersize "ISO FULL BLEED A3 (420.00 x 297.00 MM)"))
				(if (= blocksize "A3-100") (setq papersize "ISO FULL BLEED A3 (420.00 x 297.00 MM)"))
				(if (= blocksize "A3-125") (setq papersize "ISO FULL BLEED A3 (420.00 x 297.00 MM)"))
				(if (= blocksize "A2-75") (setq papersize "ISO FULL BLEED A2 (594.00 x 420.00 MM)"))
				(if (= blocksize "A2-100") (setq papersize "ISO FULL BLEED A2 (594.00 x 420.00 MM)"))
				(if (= blocksize "A2-125") (setq papersize "ISO FULL BLEED A2 (594.00 x 420.00 MM)"))


            (foreach x lst2

; ---------------
;Fa�o a sele��o da �rea da prancha

(vla-getboundingbox (vlax-ename->vla-object (cdr x)) 'mn 'mx)
                (setq llpt (vlax-safearray->list mn)
                      urpt (vlax-safearray->list mx)
                      len  (distance llpt (list (car urpt) (cadr llpt)))
                )
; ----------------
; Aqui embaixo eu crio uma Subpasta, onde ser� salvo o Output
; Var "SUBFOLDER" indica o nome da pasta a ser criada

		(setq subfolder "Plantas Gerais")
		(setq cpath (getvar "dwgprefix"))
		(Setq newpath (strcat cpath subfolder))
		(if (not (findfile newpath))
			(vl-mkdir newpath)
		)



                (setq file (strcat newpath
				   "\\"
				   nomedaplanta
				   " - "
				   (substr (setq ptx (rtos (car urpt) 2 0)) 1 5)
				   ;(itoa plantanumber)
                                   ".pdf"
                           )
                )

		;(setq plantanumber (+ plantanumber 1))

; ---------------
;Deleto arquivos antigos
                (if (findfile file)
                    (vl-file-delete file)
                )

; ---------------
                (command "-plot"
                         "yes"
                         (car x)
                         "DWG TO PDF.PC3"
                         papersize
                         "Millimeters"
                         orientation
                         "No"
                         "Window"
                         llpt
                         urpt
                         escala
                         "Center"
                         "yes"
                         "ctb - paula e bruna.ctb"
                         "yes"
                         ""
                )

                (if (/= (car x) "Model")
                    (command "No" "No" file "no" "Yes")
                    (command
                        file
                        "no"
                        "Yes"
                    )
                )

            ) ;foreach
						) ;progn

						;;Adiciono mais um na var COUNT pra l�gica funcionar l� em cima
						(setq count (1+ count))
					) ;repeat
          (setq lst2 nil)
        ) ;progn
    ) ;if

(command "_laythw")     ;EXIBE TODAS AS LAYERS NOVAMENTE
(setq none(changecolorsback))

) ;end defun
;PRINTALLA3 ***************************************************************************************************************

;PRINTSINGLESHEET ***************************************************************************************************************
(defun printsinglesheet()


(setq a3plotter "\\\\Pauladesk\\EPSON L1300 Series")

;Pede a prancha para imprimir
(initget "Landscape Portrait")
(setq orientation (cond ( (getkword "\nChoose [Landscape/Portrait] <Landscape>: ") ) ( "Landscape" )))

;Seleciona todas as pranchas
(setq p1 (getpoint "\nFa�a a sele��o das pranchas � serem impressas:"))
(setq p2 (getcorner p1))

(if (setq ss (ssget "_C" p1 p2 '((0 . "INSERT") (2 . "A4-25,A4-50,A4-75,A4-100,A4-125,A3-25,A3-50,A3-75,A3-100,A3-125,A2-25,A2-50,A2-75,A2-100,A2-125"))))
    (progn
        (repeat (setq i (sslength ss))
            (setq hnd (ssname ss (setq i (1- i)))
                  tab (cdr (assoc 410 (entget hnd)))
                  lst (cons (cons tab hnd) lst)
            )
        )
        (setq lst (vl-sort lst '(lambda (x y) (> (car x) (car y)))))
        (setq i 0)

        (foreach x lst

        (setq entityname (vla-get-effectivename (vlax-ename->vla-object (cdr x))))

          (if
            (= entityname "A4-25")
            (progn
              (setq papersize "A4")
              (setq escala "1=2.5")
              (setq plotter "Brother DCP-7065DN Printer")
            )
          )
          (if
            (= entityname "A4-50")
            (progn
              (setq papersize "A4")
              (setq escala "1=5")
              (setq plotter "Brother DCP-7065DN Printer")
            )
          )
          (if
            (= entityname "A4-75")
            (progn
              (setq papersize "A4")
              (setq escala "1=7.5")
              (setq plotter "Brother DCP-7065DN Printer")
            )
          )
          (if
            (= entityname "A4-100")
            (progn
              (setq papersize "A4")
              (setq escala "1=10")
              (setq plotter "Brother DCP-7065DN Printer")
            )
          )
          (if
            (= entityname "A4-125")
            (progn
              (setq papersize "A4")
              (setq escala "1=12.5")
              (setq plotter "Brother DCP-7065DN Printer")
            )
          )

          ;A3
          (if
            (= entityname "A3-25")
            (progn
              (setq papersize "A3 (297 x 420 mm)")
              (setq escala "1=2.5")
              (setq plotter a3plotter)
            )
          )
          (if
            (= entityname "A3-50")
            (progn
              (setq papersize "A3 (297 x 420 mm)")
              (setq escala "1=5")
              (setq plotter a3plotter)
            )
          )
          (if
            (= entityname "A3-75")
            (progn
              (setq papersize "A3 (297 x 420 mm)")
              (setq escala "1=7.5")
              (setq plotter a3plotter)
            )
          )
          (if
            (= entityname "A3-100")
            (progn
              (setq papersize "A3 (297 x 420 mm)")
              (setq escala "1=10")
              (setq plotter a3plotter)
            )
          )
          (if
            (= entityname "A3-125")
            (progn
              (setq papersize "A3 (297 x 420 mm)")
              (setq escala "1=12.5")
              (setq plotter a3plotter)
            )
          )

          ;A2 com FitToPaper para sair na A3
          (if
            (= entityname "A2-25")
            (progn
              (setq papersize "A3 (297 x 420 mm)")
              (setq escala "Fit")
              ;(setq plotter "\\\\Pauladesk\\EPSON L1300 Series")
              (setq plotter a3plotter)
            )
          )
          (if
            (= entityname "A2-50")
            (progn
              (setq papersize "A3 (297 x 420 mm)")
              (setq escala "Fit")
              (setq plotter a3plotter)
            )
          )
          (if
            (= entityname "A2-75")
            (progn
              (setq papersize "A3 (297 x 420 mm)")
              (setq escala "Fit")
              (setq plotter a3plotter)
            )
          )
          (if
            (= entityname "A2-100")
            (progn
              (setq papersize "A3 (297 x 420 mm)")
              (setq escala "Fit")
              (setq plotter a3plotter)
            )
          )
          (if
            (= entityname "A2-125")
            (progn
              (setq papersize "A3 (297 x 420 mm)")
              (setq escala "Fit")
              (setq plotter a3plotter)
            )
          )
          ; ******************************************************************************
                      (vla-getboundingbox (vlax-ename->vla-object (cdr x)) 'mn 'mx)
                            (setq llpt (vlax-safearray->list mn)
                                  urpt (vlax-safearray->list mx)
                                  len  (distance llpt (list (car urpt) (cadr llpt)))
                            )


          ; ---------------
                          (command "-plot"
                                   "yes"
                                   (car x)
                                   plotter
                                   papersize
                                   "Millimeters"
                                   orientation
                                   "No"
                                   "Window"
                                   llpt
                                   urpt
                                   escala
                                   "Center"
                                   "yes"
                                   "ctb - paula e bruna.ctb"
                                   "yes"
                                   ""
                          )

;                          (setq currentItemInList (+ currentItemInList 1))
;                          (if
;                            (= currentItemInList lstLength)
;                            (command "No" "No" "Yes")
;                            (command "No" "No" "Yes")
;                          )
                          (command "No" "No" "Yes")



                          ;(if (/= (car x) "Model")
                          ;    (command "No" "No" "Yes")
                          ;)

        );foreach
        (setq lst nil)
    );progn

);if
);defun
;PRINTSINGLESHEET ***************************************************************************************************************

;FUN��ES DE SUPORTE ***************************************************************************************************************

;COMANDOS QUE CHAMAM OS M�TODOS DE TROCA
;(defun c:ChangeLayerColor () (setq none (changecolorstogrey)))
;(defun c:ChangeLayerColorBack () (setq none (changecolorsback)))

;M�TODO PARA TROCAR COR DOS LAYOUTS PARA CINZA
(defun changecolorstogrey()
	(command "_.layer" "_thaw" "1 Layout 01,1 Layout 02,1 Layout 03" "")
	(command "_.layer" "_color" 252 "1 Layout 01,1 Layout 02,1 Layout 03" "")
)

;M�TODO PARA TROCAR COR DOS LAYOUTS DE VOLTA PARA VERMELHO E AMARELO
(defun changecolorsback()
	(command "_.layer" "_color" 1 "1 Layout 01" "")
	(command "_.layer" "_color" 2 "1 Layout 02" "")
	(command "_.layer" "_color" 3 "1 Layout 03" "")
)

; MOSTRAR LAYOUT (Only shows Layout)

;(defun c:mostrar_layout ()
;(setq none (layout))
;) ;end defun

(defun layout ()
	(command "setvar" "clayer" "0")
	(command "_laythw")
	(command "_.layer" "_freeze" "2 Hidr�ulica,2 Hidr�ulica Cotas,3 El�trico,3 El�trico Cotas,4 Luminot�cnico,4 Luminot�cnico Cotas,4 Luminot�cnico Se��es,5 Forro,5 Forro Contorno,5 Forro Cotas,6 Piso,6 Piso Cotas,7 Ar Condicionado,7 Ar Condicionado Cotas" "")
)



; MOSTRAR HIDRAULICO (Apenas hidr�ulico e layout)
;(defun c:mostrar_hidraulico ()
;(setq none (hidraulico))
;) ;end defun
(defun hidraulico ()

	;Here I Thaw all layers before i Freeze each one in the List (separated by COMMA).
	(command "setvar" "clayer" "0")
	(command "_laythw")
	(command "_.layer" "_freeze" "1 Layout Cotas,1 Layout Texto,3 El�trico,3 El�trico Cotas,4 Luminot�cnico,4 Luminot�cnico Cotas,4 Luminot�cnico Se��es,5 Forro,5 Forro Contorno,5 Forro Cotas,6 Piso,6 Piso Cotas,7 Ar Condicionado,7 Ar Condicionado Cotas" "")

) ;end defun



; MOSTRAR EL�TRICO (Apenas planta el�trica)
;(defun c:mostrar_eletrico ()
;(setq none (eletrico))
;) ;end defun
(defun eletrico ()

	;Here I Thaw all layers before i Freeze each one in the List (separated by COMMA).
	(command "setvar" "clayer" "0")
	(command "_laythw")
	(command "_.layer" "_freeze" "1 Layout 01,1 Layout 02,1 Layout 03,1 Layout Cotas,1 Layout Texto,2 Hidr�ulica,2 Hidr�ulica Cotas,4 Luminot�cnico,4 Luminot�cnico Cotas,4 Luminot�cnico Se��es,5 Forro,5 Forro Contorno,5 Forro Cotas,6 Piso,6 Piso Cotas,7 Ar Condicionado,7 Ar Condicionado Cotas" "")

) ;end defun



; MOSTRAR LUMINOT�CNICO (Apenas planta luminotecnica (com se��es) e Forro Contorno)
;(defun c:mostrar_luminotecnico ()
;(setq none (luminotecnico))
;) ;end defun
(defun luminotecnico ()

	;Here I Thaw all layers before i Freeze each one in the List (separated by COMMA).
	(command "setvar" "clayer" "0")
	(command "_laythw")
	(command "_.layer" "_freeze" "1 Layout 01,1 Layout 02,1 Layout 03,1 Layout Cotas,1 Layout Texto,2 Hidr�ulica,2 Hidr�ulica Cotas,3 El�trico,3 El�trico Cotas,4 Luminot�cnico Se��es,5 Forro,5 Forro Cotas,6 Piso,6 Piso Cotas,7 Ar Condicionado,7 Ar Condicionado Cotas" "")

) ;end defun



; MOSTRAR SE��ES (Apenas planta se��es e Forro Contorno)
;(defun c:mostrar_secoes ()
;(setq none (secoes))
;) ;end defun
(defun secoes ()

	;Here I Thaw all layers before i Freeze each one in the List (separated by COMMA).
	(command "setvar" "clayer" "0")
	(command "_laythw")
	(command "_.layer" "_freeze" "1 Layout 01,1 Layout 02,1 Layout 03,1 Layout Cotas,1 Layout Texto,2 Hidr�ulica,2 Hidr�ulica Cotas,3 El�trico,3 El�trico Cotas,4 Luminot�cnico Cotas,5 Forro,5 Forro Cotas,6 Piso,6 Piso Cotas,7 Ar Condicionado,7 Ar Condicionado Cotas" "")

) ;end defun



; MOSTRAR FORRO (Apenas planta de forro)
;(defun c:mostrar_forro ()
;(setq none (forro))
;) ;end defun
(defun forro ()

	;Here I Thaw all layers before i Freeze each one in the List (separated by COMMA).
	(command "setvar" "clayer" "0")
	(command "_laythw")
	(command "_.layer" "_freeze" "1 Layout 01,1 Layout 02,1 Layout 03,1 Layout Cotas,1 Layout Texto,2 Hidr�ulica,2 Hidr�ulica Cotas,3 El�trico,3 El�trico Cotas,4 Luminot�cnico,4 Luminot�cnico Cotas,4 Luminot�cnico Se��es,6 Piso,6 Piso Cotas,7 Ar Condicionado,7 Ar Condicionado Cotas" "")

) ;end defun



; MOSTRAR PISO (Apenas planta de piso)
;(defun c:mostrar_piso ()
;	(setq none (piso))
;) ;end defun
(defun piso ()

	;Here I Thaw all layers before i Freeze each one in the List (separated by COMMA).
	(command "setvar" "clayer" "0")
	(command "_laythw")
	(command "_.layer" "_freeze" "1 Layout 01,1 Layout 02,1 Layout 03,1 Layout Cotas,1 Layout Texto,2 Hidr�ulica,2 Hidr�ulica Cotas,3 El�trico,3 El�trico Cotas,4 Luminot�cnico,4 Luminot�cnico Cotas,4 Luminot�cnico Se��es,5 Forro,5 Forro Contorno,5 Forro Cotas,7 Ar Condicionado,7 Ar Condicionado Cotas" "")

) ;end defun



; MOSTRAR ARCONDICIONADO (Apenas planta de ar condicionado)
;(defun c:mostrar_arcondicionado ()
;(setq none (arcondicionado))
;) ;end defun
(defun arcondicionado ()

	;Here I Thaw all layers before i Freeze each one in the List (separated by COMMA).
	(command "setvar" "clayer" "0")
	(command "_laythw")
	(command "_.layer" "_freeze" "1 Layout 01,1 Layout 02,1 Layout 03,1 Layout Cotas,1 Layout Texto,2 Hidr�ulica,2 Hidr�ulica Cotas,3 El�trico,3 El�trico Cotas,4 Luminot�cnico,4 Luminot�cnico Cotas,4 Luminot�cnico Se��es,5 Forro,5 Forro Contorno,5 Forro Cotas,6 Piso,6 Piso Cotas" "")

) ;end defun

(defun reexibir ()
  (command "setvar" "clayer" "0")
  (command "_laythw")
)

(defun c:FixAllCotas () (fixallcotas))
(defun c:FixSomeCotas () (fixSomeCotas))

; -------------------------------------------------
; DEFUN PARA CORRIGIR SOMENTE AS COTAS SELECIONADAS
(defun fixsomecotas ( / ss textString)

(if
	;PREDICATE
	(and
		(setq ss (ssget '((0 . "DIMENSION"))))
		(setq textString "")
	)

	;THEN
	(progn

		(vla-startundomark
			(cond
				(*activeDoc*)
				(
					(setq *activeDoc* (vla-get-activedocument (vlax-get-acad-object)))
				)
			)
		)
		(vlax-for oDim
			(setq ss (vla-get-activeselectionset *activeDoc*))
			(vla-put-textoverride oDim textString)
		)
		(vla-delete ss)
		(vla-endundomark *activeDoc*)
	);_progn

	;ELSE
	(prompt "\n** Nothing selected ** ")
);_if

(princ)

);_defun

; -------------------------------------------------
; DEFUN PARA CORRIGIR TODAS AS COTAS
(defun fixallcotas ( / ss textString)

(if
	;PREDICATE
	(and
		(setq ss (ssget "x" '((0 . "DIMENSION"))))
		(setq textString "")
	)

	;THEN
	(progn

		(vla-startundomark
			(cond
				(*activeDoc*)
				(
					(setq *activeDoc* (vla-get-activedocument (vlax-get-acad-object)))
				)
			)
		)
		(vlax-for oDim
			(setq ss (vla-get-activeselectionset *activeDoc*))
			(vla-put-textoverride oDim textString)
		)
		(vla-delete ss)
		(vla-endundomark *activeDoc*)
	);_progn

	;ELSE
	(prompt "\n** Nothing selected ** ")
);_if

(princ)

);_defun

; ***********************************************************************************************************************************************
; LISTAGEM INDIVIDUAL
; ***********************************************************************************************************************************************
(defun listagemindividual (/ blk_id blk_len blk_name blks ent h header_lsp height i j Total
                 len0 lst_blk msp pt row ss str tblobj width width1 width2 x y)

 (vl-load-com)

 (defun TxtWidth (val h msp / txt minp maxp)
   (setq  txt (vla-AddText msp val (vlax-3d-point '(0 0 0)) h))
   (vla-getBoundingBox txt 'minp 'maxp)
   (vla-Erase txt)
   (-(car(vlax-safearray->list maxp))(car(vlax-safearray->list minp))))

 (defun GetOrCreateTableStyle (tbl_name / name namelst objtblsty objtblstydic tablst txtsty)
   (setq objTblStyDic (vla-item (vla-get-dictionaries *adoc) "ACAD_TABLESTYLE"))
   (foreach itm (vlax-for itm objTblStyDic
                 (setq tabLst (append tabLst (list itm))))
     (if (not
          (vl-catch-all-error-p
             (setq name (vl-catch-all-apply 'vla-get-Name (list itm)))))
       (setq nameLst (append nameLst (list name)))))
   (if (not (vl-position tbl_name nameLst))
     (vla-addobject objTblStyDic tbl_name "AcDbTableStyle"))
   (setq objTblSty (vla-item objTblStyDic tbl_name)
    TxtSty (variant-value (vla-getvariable *adoc "TextStyle")))
   (mapcar '(lambda (x)(vla-settextstyle objTblSty x TxtSty))
        (list acTitleRow acHeaderRow acDataRow))
   (vla-setvariable *adoc "CTableStyle" tbl_name))


 (defun GetObjectID (obj)
   (if (vl-string-search "64" (getenv "PROCESSOR_ARCHITECTURE"))
     (vlax-invoke-method *util 'GetObjectIdString obj :vlax-false)
     (vla-get-Objectid obj)))


;PROGRAMA COME�A AQUI
 (if (setq ss (ssget (list (cons 0 "INSERT"))))                                 ;(SSGET pra fazer a sele��o de blocos)
   (progn
     (vl-load-com)
     (setq i -1 len0 8)
     (while (setq ent (ssname ss (setq i (1+ i))))                              ;(SSNAME retorna o nome do bloco, da lista SS, na posi��o i)
        (setq blk_name (cdr (assoc 2 (entget ent))))                            ;(Isso aqui deve pegar a string do nome certinho)
        (if (> (setq blk_len (strlen blk_name)) len0)
         (setq str blk_name len0 blk_len))
         (if (not (assoc blk_name lst_blk))
         (setq lst_blk (cons (cons blk_name 1) lst_blk))
         (setq lst_blk (subst (cons blk_name (1+ (cdr (assoc blk_name lst_blk))))
                        (assoc blk_name lst_blk) lst_blk)))
     );while
     (setq lst_blk (vl-sort lst_blk '(lambda (x y) (< (car x) (car y)))))

     (setq Total 0)                                                             ;Cria a vari�vel que armazenar� a quantidade total de blocos
     (foreach I lst_blk (setq Total (+ Total (cdr I))))                         ;Acha a quantidade de blocos

     (or *h* (setq *h* (* (getvar "dimtxt")(getvar "dimscale"))))
     (initget 6)

     (setq AmbienteName (GetString T "Digite o nome do ambiente:"))             ;Aqui eu pe�o o nome do ambiente

    ;(setq h (getreal (strcat "\nText Height <" (rtos *h*) "> :")))             ;BACKUP do Input para altura do texto
     (setq h 10)                                                                ;Altura fixa do texto armazenada na var h

     (if h (setq *h* h) (setq h *h*))
     (or *adoc (setq *adoc (vla-get-ActiveDocument (vlax-get-acad-object))))
     (setq msp (vla-get-modelspace *adoc)
      *util (vla-get-Utility *adoc)
      blks (vla-get-blocks *adoc))
     (setq width1 (* 4 (TxtWidth "    " h msp))
      width (* 2 (TxtWidth "Text Height" h msp))
      height (* 2 h))
     (if str
      (setq width2 (* 1.5 (TxtWidth (strcase str) h msp)))
      (setq width2 width))
     (if (> h 3)
      (setq width   (* (fix (/ width  8))8)
             width1 (* (fix (/ width1 8))8)
             width2 (* (fix (/ width2 8))8)
             height (* (fix (/ height 5))5)))
     (GetOrCreateTableStyle "CadEng")
     (setq pt
       (getpoint "\nPlace Table :")                                             ;Pede o ponto onde a tabela vai ser inserida
       TblObj (vla-addtable
                msp                     ;ModelSpace
                (vlax-3d-point pt)      ;Passa o PT 2d pra 3d
                (+ (length lst_blk) 2)  ;Pega a quantidade de blocos na lista e adiciona 3
                2                       ;N�mero de colunas
                height                  ;RowHeight
                width                   ;ColWidth
              ) ;addtable
     );setq pt
     (vla-put-regeneratetablesuppressed TblObj :vlax-true)                      ;Desativa regenera��o da tabela
     (vla-SetColumnWidth TblObj 0 width1)                                       ;Altera o width da coluna 0

     (setq width2 400)

     (vla-SetColumnWidth TblObj 1 width2)                                       ;Altera o width da coluna 1
     (vla-put-vertcellmargin TblObj (* 0.75 h))
     (vla-put-horzcellmargin TblObj (* 0.75 h))
     (mapcar '(lambda (x)(vla-setTextHeight TblObj x h))
       (list acTitleRow acHeaderRow acDataRow))
     (mapcar '(lambda (x)(vla-setAlignment TblObj x 8))
       (list acTitleRow acHeaderRow acDataRow))
     (vla-MergeCells TblObj 0 0 0 1)                                            ;Faz o Merge da c�lula do t�tulo (OBS.: o ultimo numero tem que bater com o numero de colunas -1)
     (vla-setText TblObj 0 0 AmbienteName)                                      ;Coloca o nome do ambiente na c�lula 0,0
     (setq j -1 header_lsp (list "Qtd." "Item"))                                ;Defino uma lista de strings para o cabe��lio; A var J � definida como -1 para o "Repeat" de baixo setar o J com +1 j� no primeiro loop (resultando em um loop come�ando no 0 {coluna 0 = primeira coluna})
     (repeat (length header_lsp)                                                ;Repeat que pega a quantidade de strings como quantidade de de voltas
      (vla-setText TblObj 1 (setq j (1+ j)) (nth j header_lsp)))                ;Seta o texto da Row 1, Coluna J {J = -1, j� no prieiro loop vira 0}, com a string da var "header_lsp" na posi��o J

     (setq row 2 i 1)                                                           ;Aqui define a numera��o de ordem, come�ando na linha "2" pelo n�mero "1"
     (foreach pt lst_blk
      (setq blk_name (car pt) j -1)
      (mapcar '(lambda (x) (vla-setText TblObj row (setq j (1+ j)) x))          ;uso um Mapcar para aplicar as strings nas c�lulas
          (list (cdr pt) blk_name))                                             ;Aqui eu defino a ordem, primeiro o n�mero de quantidade (cdr pt) e depois o nome do bloco
         ;(list i blk_name  (cdr pt)))                                          ;BACKUP => N�mero ordinal, Nome do Bloco, Quantidade

      (vla-SetCellAlignment TblObj row 0 2)                                     ;Alinhamento do texto
      (vla-SetCellAlignment TblObj row 1 1)
      (setq row (1+ row) i (1+ i))

      );foreach

      (setq row (- 1 row))                                                      ;Retiro 1 da var "row" para n�o criar uma linha sobrando na tabela

    (vla-put-regeneratetablesuppressed TblObj :vlax-false)                      ;Reativa a regenera��o da tabela
    (vlax-release-object TblObj)
    );progn
    );if
 (princ))

 ; ************************************************************************************************************************************************
 ; END LISTAGEM INDIVIDUAL
 ; ************************************************************************************************************************************************
 (defun beltb (/ *error* doc nametolist blkss inc blk lay blknames ent edata)

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
 ); DEFUN

 ; ********************************************************************************************************************************************
 ; END beltb
 ; ********************************************************************************************************************************************