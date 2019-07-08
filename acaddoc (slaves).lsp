(vl-load-com)

;loads all needed subroutines
(if (findfile "I:\\INTERIORES\\1.PADRÃO\\Padrão PB - AutoCad\\Plugins\\PluginsToLoad")
  (mapcar '(lambda (x)
             (if (wcmatch (strcase x) "*.LSP,*.VLX")
               (load
                 (strcat (findfile "I:\\INTERIORES\\1.PADRÃO\\Padrão PB - AutoCad\\Plugins\\PluginsToLoad") "\\" x)
               ) ;_ load
             ) ;_ if
           ) ;_ lambda
          (vl-directory-files
            (findfile "I:\\INTERIORES\\1.PADRÃO\\Padrão PB - AutoCad\\Plugins\\PluginsToLoad")
          ) ;_ vl-directory-files
  ) ;_ mapcar
) ;_ if