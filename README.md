# Yoprint
Plugin de impressão em pranchas no Model e outras utilidades para AutoCad. Este plugin foi um experimento de uma solução in-house feito para atender as demandas do escritório de arquitetura em que eu trabalhava. Possui os seguintes recursos:

- Impressão de múltiplas pranchas PDF no Model do AutoCAD
- Corrigir cotas editadas
- ~~Impressão de Plantas Gerais no Model~~
- ~~Impressão direta para a impressora com configuração automática~~
- ~~Mudança de template de layers no AutoCAD~~
- ~~Colorir e Descolorir layer de Layout~~
- ~~Interface Visual~~

Observação: os recursos riscados na lista acima estavam presentes durante o período de desenvolvimento ativo do plugin e ápice do seu uso. No entanto, como são extremamente *hard-coded* (estamos falando de LISP, uma linguagem de programação arcaica, meu Deus...) e super específicas para os padrões daquele escritório, decidi removê-las para deixá-lo mais genérico e usável.

## Comandos:

- `PRINTALLTOPDF` - Imprime todas as pranchas selecionadas *que possuam um bloco configurado*
- `COTAS_CORRIGIRSELECIONADAS` - Reseta as cotas editas que você selecionar para o valor correto
- `COTAS_CORRIGIRTODAS` - Reseta TODAS as cotas do arquivo para o valor correto. **CUIDADO**

## Instalar o Plugin

Em cada computador que for usar o plugin, siga as seguintes instruções:

- Digite o comando no AutoCAD: "APPLOAD"
- Navegue para a pasta onde está o localizado o arquivo do plugin "yoprint.lsp"
- Selecione o arquivo
- Clique em "Load"
- Se aparecer uma grande mesangem e 3 botões, clique em "Always Load"

**ATENÇÃO**: É necessário estar presente um arquivo CTB com o exato nome: "ctb - yoprint.ctb" na pasta padrão do AutoCAD para esses arquivos. Pegue seu arquivo de CTB que você já usa com o padrão do seu escritório e renomeie ele com o nome mencionado, depois coloque na pasta do AutoCAD para CTBs. Dica: Digite o comando `STYLESMANAGER` que o AutoCAD vai abrir automaticamente essa pasta. Basta jogar seu arquivo ctb lá dentro (com o nome certo).

## Configurar para sempre carregar o plugin ao abrir o AutoCAD


É possível configurar para que o AutoCAD sempre carregue o plugin durante a inicialização (embora esse comportamento seja instável e nem sempre funcione, especialmente se o arquivo estiver na rede, não custa tentar). Siga as intruções:

- Digite o comando no AutoCAD: "APPLOAD"
- No canto inferior direito, no campo "Startup Suite", clique no botão "Contents..."
- Clique no botão "Add..."
- Navegue para a pasta onde está o arquivo do plugin "yoprint.lsp"
- Selecione o arquivo
- Clique em "Abrir"
- Clique em "Close"

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

## Como o comando PRINTALLTOPDF funciona?

Como o comando de impressão das plantas PDF consegue detectar as pranchas, e imprimi-las na escala correta, embora possam haver múltiplas pranchas de tamanhos diferentes?

🪄 Será que é mágica?

Claro que não. Cada prancha deve ter um bloco do AutoCAD ao seu redor, no tamanho correto, e com o nome correto, seguindo um padrão bem rígido:

**{Tamanho do Papel}-{Escala}**

Exemplos: "A4-25", "A3-100", "A4-50", etc.

O plugin reconhece os tamanhos de papel de A4 até A2, e as escalas de 1/20 até 1/125. Ou seja, você consegue ir dos tamanhos A4-20 até A2-125.

Mas não se preocupe com isso, isso já vai estar (ou deveria estar) já configurado no seu arquivo de template. Basta você usar as pranchas do seu template que já possuam esse bloco. E caso alguma prancha não esteja imprimindo, verifique se ela possui esse bloco no entorno.

