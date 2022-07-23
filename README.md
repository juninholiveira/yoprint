# Yoprint
Plugin de impressão em pranchas no Model e outras utilidades para AutoCad. Este plugin foi feito sob medida para o escritório de arquitetura que trabalho com as seguintes features:

- Impressão de múltiplas pranchas PDF no Model do AutoCAD
- Impressão de Plantas Gerais no Model
- Impressão direta para a impressora com configuração automática
- Mudança de template de layers no AutoCAD
- Colorir e Descolorir layer de Layout
- Corrigir cotas editadas

## Instalar o Plugin

Em cada computador que for usar o plugin, siga as seguintes instruções:

- Digite o comando no AutoCAD: "APPLOAD"
- Navegue para a pasta onde está o localizado o arquivo do Plugin
- Selecione o arquivo
- Clique em "Load"
- Se aparecer uma grande mesangem e 3 botões, clique em "Always Load"

## Desativar abertura automática de PDFs no visualizador padrão

Antes de usar, desative a abertura automática dos PDFs impressos, ou então você vai se deparar com centenas de PDFs sendo abertos instantâneamente no seu visualizador padrão (navegador, Acrobat Reader ou qualquer outro). Siga os seguintes passos para desativar (faça isso em cada computador):

- Abra o menu de impressão
- Selecione o plotter de PDF (DWG To PDF.pc3)
- Clique em "Properties" (Logo a direita do nome da plotter)
- Selecione "Custom Properties" na lista que aparecer
- Abaixo, clique no botão central "Custom Properties..."
- Desmarque a caixinha "Show Results in Viewer"
- Clique em "OK", irá fechar a tela atual
- Clique em "OK" novamente na próxima tela
- Vai abrir uma tela perguntando se quer salvar essas configurações
- Clique na segunda bolinha "Save changes to the following file:"
- Clique em "OK"
- Pronto, o AutoCAD não vai mais abrir os PDFs loucamente
