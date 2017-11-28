orientation : dialog 
{
	: spacer {}

	: text
	{
		label = "Escolha a orientação das pranchas:";
	}

	: spacer {}	

	: row
	{
		: button
		{
		key = "landscape";
		label = "Retrato";
		is_default = true;
		}
	
		: button
		{
		key = "portrait";
		label = "Retrato";
		}
	} //_row		

	: spacer {}

} //_orientation_dialog

// ***********************************************************************************************************************************

interface : dialog 
{
 
label = "Yoprint 2017";

: spacer {height=1;}

: text
{
	label = "Menu de Plugins";
	alignment = centered;
}

: spacer {}

//IMPRESSÕES
: boxed_column
{
	label = "Modo de Impressão";

	: spacer{}
	: text
	{
	label = "Imprime em PDF as plantas A4 selecionadas:";
	}

	: button
	{
	key = "printalltopdf";
	label = "Imprimir Detalhamento";
	width = 30;
	alignment = centered;
	}

	: spacer{}
	: text
	{
	label = "Imprime em PDF todas as Plantas Gerais encontradas:";
	}

	: button
	{
	key = "printalla3";
	label = "Imprimir Plantas Gerais";
	width = 30;
	alignment = centered;
	}

	: spacer{}
	: text
	{
	label = "Imprime direto na impressora todas e quaisquer pranchas selecionadas:";
	}

	: button
	{
	key = "printsinglesheet";
	label = "Impressão Direta";
	width = 30;
	alignment = centered;
	}
}				

: spacer {height = 1;}

//MOSTRAR
:boxed_column
{
	label = "Modos de Exibição";

: row
{
	: column
	{
		: button	
		{
		key = "layout";
		label = "Exibir Layout";
		width = 30;
		alignment = centered;
		}

		: button	
		{
		key = "hidraulico";
		label = "Exibir Hidráulico";
		width = 30;
		alignment = centered;
		}

		: button	
		{
		key = "eletrico";
		label = "Exibir Elétrico";
		width = 30;
		alignment = centered;
		}

		: button	
		{
		key = "luminotecnico";
		label = "Exibir Luminotécnico";
		width = 30;
		alignment = centered;
		}

		: button	
		{
		key = "secoes";
		label = "Exibir Seções";
		width = 30;
		alignment = centered;
		}
	}

	: column
	{
		: button	
		{
		key = "forro";
		label = "Exibir Forro";
		width = 30;
		alignment = centered;
		}

		: button	
		{
		key = "piso";
		label = "Exibir Piso";
		width = 30;
		alignment = centered;
		}

		: button	
		{
		key = "arcondicionado";
		label = "Exibir Ar-Condicionado";
		width = 30;
		alignment = centered;
		}

		: button	
		{
		key = "reexibir";
		label = "REEXIBIR TUDO";
		width = 30;
		alignment = centered;
		}
	}
}

: spacer {}
	
} //boxed column

: spacer {height=1;}

: boxed_column
{
	label = "Utilidades";

	: spacer {}

: row 
{
	: column
	{
		width = 20;
		
		: text
		{
		label = "Correção de cotas editadas.";
		}

		: button	
		{
		key = "fixallcotas";
		label = "Corrigir Todas as Cotas";
		alignment = centered;
		}

		: button	
		{
		key = "fixsomecotas";
		label = "Corrigir Cotas Selecionadas";
		alignment = centered;
		}

		: spacer {}

	} //_column

	: column
	{
		width = 20;

		: text
		{
		label = "Alteração de cor do Layout (Cinza/Colorido).";
		}

		: button	
		{
		key = "changelayercolor";
		label = "Acinzentar Layout";
		alignment = centered;
		}

		: button	
		{
		key = "changelayercolorback";
		label = "Resetar Cores";
		alignment = centered;
		}

		: spacer {}

	} //_column

	: column
	{
		width = 20;

		: text
		{
		label = "Listagems";
		}

//		: button	// Dedicado à rotina de fazer a listagem completa do bloco do ambiente
//		{
//		key = "listagemambiente";
//		label = "(Em construção)";
//		alignment = centered;
//		}

		: button	
		{
		key = "listagemindividual";
		label = "Selecionar Blocos";
		alignment = centered;
		}

		: spacer {}

	} //_column
} //_row
}

: spacer {}

: row
{

	: text
	{
		label = "Criado por Leandro José de Oliveira Júnior";
		alignment = left;
	}

	: button	
	{
	key = "cancel";
	label = "Fechar";
	is_default = true;
	fixed_width = true;
	alignment = right;
	}
} //_row

} //_interface_dialog