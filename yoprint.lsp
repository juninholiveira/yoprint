(vl-load-com)

; CTB
(setq ctb "ctb - yoprint.ctb")

; IMPRESSORAS
(setq pdfPlotter "DWG TO PDF.PC3")                                              ; Impressora Virtual para PDF

; PAPÉIS
(setq a4fullbleed "ISO FULL BLEED A4 (297.00 x 210.00 MM)")
(setq a3fullbleed "ISO FULL BLEED A3 (420.00 x 297.00 MM)")
(setq a2fullbleed "ISO FULL BLEED A2 (594.00 x 420.00 MM)")

; BLOCOS DE FOLHA
(setq a4-20 "A4-20")
(setq a4-25 "A4-25")
(setq a4-50 "A4-50")
(setq a4-75 "A4-75")
(setq a4-100 "A4-100")
(setq a4-125 "A4-125")

(setq a3-20 "A3-20")
(setq a3-25 "A3-25")
(setq a3-50 "A3-50")
(setq a3-75 "A3-75")
(setq a3-100 "A3-100")
(setq a3-125 "A3-125")

(setq a2-20 "A2-20")
(setq a2-25 "A2-25")
(setq a2-50 "A2-50")
(setq a2-75 "A2-75")
(setq a2-100 "A2-100")
(setq a2-125 "A2-125")

(setvar "BACKGROUNDPLOT" 2)	                                                    ;Aqui eu seto a variável do sistema pra PLOT em foreground e PUBLISH em background (Número 2)

;Aqui eu reseto os
(SETQ ORIGPATH (STRCAT (GETENV "ACAD")";"))
(SETQ ONEPATH (STRCAT "I:\\INTERIORES\\1.Padrão\\Padrão PB - AutoCad\\Plugins\\PluginsToLoad;I:\\INTERIORES\\1.Padrão\\Padrão PB - AutoCad\\Hachuras"));ADD PATHS HERE, NOT TO MANY OR IT GETS CUT OFF
(SETQ MYENV (STRCAT ORIGPATH ONEPATH))
(SETENV "ACAD" MYENV)
(strlen (getenv "ACAD"));DON'T GO OVER 800 OR BAD THINGS HAPPEN

;PRINTALLTOPDF ***************************************************************************************************************
(defun C:printalltopdf (/ dwg file hnd i len llpt lst mn mx ss tab urpt subfolder cpath newpath currententity scale)

  (setq p1 (getpoint "\nFaça a seleção das pranchas à serem impressas:"))
  (setq p2 (getcorner p1))

  (setq nomeescolhido(GetString T "\nDigite um nome para as pranchas:"))

    (if (setq ss (ssget "_C" p1 p2 '((0 . "INSERT") (2 . "A4-20,A4-25,A4-50,A4-75,A4-100,A4-125,A3-25,A3-50,A3-75,A3-100,A3-125,A2-25,A2-50,A2-75,A2-100,A2-125"))))
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

            ;Nesta parte, faço a lógica para decidir se a planta é Landscape ou Portrait,
            ;pegando o Bounding Box dela para fazer a matemática
            (vla-GetBoundingBox (vlax-ename->vla-object (cdr x)) 'minExt 'maxExt)
            (setq minExt (vlax-safearray->list minExt) maxExt (vlax-safearray->list maxExt))
            (setq orientation "Landscape")
            (if
              (<
                (- (nth 0 maxExt) (nth 0 minExt))
                (- (nth 1 maxExt) (nth 1 minExt))
              )
              (setq orientation "Portrait")
            )

              ;Pego o nome do bloco (A4025, A4-50, etc)
              (setq entityname (vla-get-effectivename (vlax-ename->vla-object (cdr x))))
              (if
                (= entityname "A4-20")
                (progn
                  (setq papersize a4fullbleed)
                  (setq escala "1=2")
                )
              )
                (if
                  (= entityname "A4-25")
                  (progn
                    (setq papersize a4fullbleed)
                    (setq escala "1=2.5")
                  )
                )
                (if
                  (= entityname "A4-50")
                  (progn
                    (setq papersize a4fullbleed)
                    (setq escala "1=5")
                  )
                )
                (if
                  (= entityname "A4-75")
                  (progn
                    (setq papersize a4fullbleed)
                    (setq escala "1=7.5")
                  )
                )
                (if
                  (= entityname "A4-100")
                  (progn
                    (setq papersize a4fullbleed)
                    (setq escala "1=10")
                  )
                )
                (if
                  (= entityname "A4-125")
                  (progn
                    (setq papersize a4fullbleed)
                    (setq escala "1=12.5")
                  )
                )

                ;A3
                (if
                  (= entityname "A3-25")
                  (progn
                    (setq papersize a3fullbleed)
                    (setq escala "1=2.5")
                  )
                )
                (if
                  (= entityname "A3-50")
                  (progn
                    (setq papersize a3fullbleed)
                    (setq escala "1=5")
                  )
                )
                (if
                  (= entityname "A3-75")
                  (progn
                    (setq papersize a3fullbleed)
                    (setq escala "1=7.5")
                  )
                )
                (if
                  (= entityname "A3-100")
                  (progn
                    (setq papersize a3fullbleed)
                    (setq escala "1=10")
                  )
                )
                (if
                  (= entityname "A3-125")
                  (progn
                    (setq papersize a3fullbleed)
                    (setq escala "1=12.5")
                  )
                )

                ;A2 com FitToPaper para sair na A3
                (if
                  (= entityname "A2-25")
                  (progn
                    (setq papersize a2fullbleed)
                    (setq escala "1=2.5")
                  )
                )
                (if
                  (= entityname "A2-50")
                  (progn
                    (setq papersize a2fullbleed)
                    (setq escala "1=5")
                  )
                )
                (if
                  (= entityname "A2-75")
                  (progn
                    (setq papersize a2fullbleed)
                    (setq escala "1=7.5")
                  )
                )
                (if
                  (= entityname "A2-100")
                  (progn
                    (setq papersize a2fullbleed)
                    (setq escala "1=10")
                  )
                )
                (if
                  (= entityname "A2-125")
                  (progn
                    (setq papersize a2fullbleed)
                    (setq escala "1=12.5")
                  )
                )

;Faço a seleção da área da prancha
(vla-getboundingbox (vlax-ename->vla-object (cdr x)) 'mn 'mx)
                (setq llpt (vlax-safearray->list mn)
                      urpt (vlax-safearray->list mx)
                      len  (distance llpt (list (car urpt) (cadr llpt)))
                )

; Aqui embaixo eu crio uma Subpasta, onde será salvo o Output
; Var "SUBFOLDER" indica o nome da pasta a ser criada
		(setq subfolder "PDFs")
		(setq cpath (getvar "dwgprefix"))
		(Setq newpath (strcat cpath subfolder))
		(if (not (findfile newpath))(vl-mkdir newpath))

                (setq file (strcat newpath "\\" nomeescolhido " " (substr (setq ptx (rtos (cadr urpt) 2 0)) 1 5) " - " (substr (setq ptx (rtos (car urpt) 2 0)) 1 5) ".pdf"))

                ;Deleto arquivos antigos
                (if (findfile file) (vl-file-delete file))

                (command "-plot"
                         "yes"
                         (car x)
                         pdfplotter
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
                         ctb
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

; DEFUN PARA CORRIGIR SOMENTE AS COTAS SELECIONADAS
(defun C:cotas_corrigirselecionadas ( / ss textString)

  (if
  	(and (setq ss (ssget '((0 . "DIMENSION")))) (setq textString ""))
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
  		(vlax-for oDim (setq ss (vla-get-activeselectionset *activeDoc*)) (vla-put-textoverride oDim textString))
  		(vla-delete ss)
  		(vla-endundomark *activeDoc*)
  	);_progn
  	;ELSE
  	(prompt "\n** Nada selecionado! ** ")
  );_if
  (princ)
);_defun

; DEFUN PARA CORRIGIR TODAS AS COTAS
(defun C:cotas_corrigirtodas ( / ss textString)

  (if
  	;PREDICATE
  	(and (setq ss (ssget "x" '((0 . "DIMENSION"))))(setq textString ""))
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
  		(vlax-for oDim(setq ss (vla-get-activeselectionset *activeDoc*))(vla-put-textoverride oDim textString))
  		(vla-delete ss)
  		(vla-endundomark *activeDoc*)
  	);_progn
  	;ELSE
  	(prompt "\n** Nada selecionado ** ")
  );_if
  (princ)
);_defun