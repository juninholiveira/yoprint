(vl-load-com)

;loads all needed subroutines
(if (findfile "C:\\INTERIORES\\1.PADRÃO\\Padrão PB - AutoCad\\Plugins\\PluginsToLoad")
  (mapcar '(lambda (x)
             (if (wcmatch (strcase x) "*.LSP")
               (load
                 (strcat (findfile "C:\\INTERIORES\\1.PADRÃO\\Padrão PB - AutoCad\\Plugins\\PluginsToLoad") "\\" x)
               ) ;_ load
             ) ;_ if
           ) ;_ lambda
          (vl-directory-files
            (findfile "C:\\INTERIORES\\1.PADRÃO\\Padrão PB - AutoCad\\Plugins\\PluginsToLoad")
          ) ;_ vl-directory-files
  ) ;_ mapcar
) ;_ if