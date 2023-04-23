# Szarca Dock 

Uma aplicação que possibilita monitorar serviços (API's/Programas/Banco de dados) e infraestrutura (Servidores/Switches/Firewall) diretamente na área de trabalho, **sem janelas**. É notado que vários sistemas se utilizam múltiplas janelas e a proposta é centralizar os serviços independentemente da tecnologia usada.

Imagem do software em produção no Windows 11: [Behance](https://www.behance.net/gallery/169000549/Szarca-Dock)

O software `Szarca-Dock é apenas um runtime`, ou seja, apenas executa os arquivos de monitoramento no desktop do usuário. Para o software de criação e edição dos arquivos, consulte o  [DockBuilder](https://github.com/anderakooken/as3-dock-builder)

# Premissas

O frontend da aplicação é desenvolvido com Adobe AIR, na linguagem **AS3 (Action Script 3.0)**. O backend pode ser utilizado com qualquer linguagem de programação, contanto que as requisições sejam realizadas via **HTTP/HTTPS** e seja respeitado a estrutura do arquivo de retorno que é desenhado **XML**. No projeto consta um script para uso na linguagem **PHP**.

## Softwares necessários

Para edição do frontend, sugiro utilizar o **Adobe CS5.5** ou superior, pois essas versões são estáveis. Uma vez que o desenvolvedor instale o software sugerido, este também contem o runtime do **Adobe AIR**, que é a única obrigatoriedade para rodar a aplicação.  

## Estrutura do projeto

|  ARQUIVO              |                          |                         |
|----------------|-------------------------------|-----------------------------|
|szarca-dock.fla| Arquivo para edição do programa| Código AS3 incluso na Timeline (Camada 1) 
|class.php|Arquivo modelo para PHP            | Recebe as requisições do frontend |
|objetos.xml          |Objetos utilizados no programa            |       |
|szarca-dock.air          |`Executavél compilado na última versão`||
|szarca-dock.as|Código fonte da aplicação.| O mesmo código está incluído no szarca-dock.fla|

Outros arquivos são apenas dependências, tais como bibliotecas externas, imagens ou scripts de uso do Adobe Air.



### Class.php

Instância da função que recebe as requisições via HTTP
```php
$OUT = new conexao_bd;
$OUT ->HEADER();
```
Por padrão, foi colocado apenas verificação ICMP, TELNET e uma personalizável pelo desenvolvedor.
```php
function HEADER(){
	if($_POST["key"] == $this->KEY){
		if($_POST["function"] == "PING"){$this->PING();}
		if($_POST["function"] == "TELNET"){$this->TELNET();}
		if($_POST["function"] == "PERSONAL"){$this->PERSONAL();}
	}
}
```
Caso precise adicionar novas funções, o arquivo do frontend deverá ser alterado.

```actionscript
function  INSERT(...){
...
	if(md == "PERSONAL"){
		PERSONAL(md,id);
	} else {
		PING(md,id);
	}
}
```
