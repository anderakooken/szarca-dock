<?php

#------------------------------------------#
# @anderakooken
# -----------------------------------------#


class conexao_bd {
	
	var $SISTEMA_OPER = "Linux"; #Windows
	var $KEY = "zyc405";
	
	function PERSONAL(){
		
		$cmd = $_REQUEST["ip"];
		
		if($cmd == "TESTE"){
			print'<?xml version="1.0" encoding="ISO-8859-1" ?>';
			print'<cliente ip="'.$ip.'" retorno="teste"></cliente>';
		}

	}
	
	function TELNET(){
		
		$ip = $_POST["ip"];
		$nivel = $_POST["nivel"];
		
		$saida;
		
		if($nivel == false)	{$nivel = "0";}
		if($nivel == "true"){$nivel = "4";}
		
		if($this->SISTEMA_OPER == "Linux"){
			exec('telnet '.$ip.'', $saida, $retorno);
		}
		if($this->SISTEMA_OPER == "Windows"){
			exec('telnet '.$ip.'', $saida, $retorno);
		}

		if($this->SISTEMA_OPER == "Windows"){
		}
			if($this->SISTEMA_OPER == "Linux"){
					if(strstr($saida[1], "Connected")){
						$mqn = "on";
					} else {
						$mqn = "off";
					}
			}
			print'<?xml version="1.0" encoding="ISO-8859-1" ?>';
			print'<cliente ip="'.$ip.'" retorno="'.$mqn.'"  nivel="'.$nivel.'"></cliente>';

	}

	function PING(){
		
		$ip = $_POST["ip"];
		$nivel = $_POST["nivel"];
		
		$saida;
		
		if($nivel == false)	{$nivel = "0";}
		if($nivel == "true"){$nivel = "4";}
		
		if($this->SISTEMA_OPER == "Linux"){
			exec('ping -c 1 '.$ip.'', $saida, $retorno);
		}
		if($this->SISTEMA_OPER == "Windows"){
			exec('ping '.$ip.' -n 1', $saida, $retorno);
		}
		
			if($this->SISTEMA_OPER == "Windows"){
				if(strstr($saida[3], "Esgotado") || 
						strstr($saida[3], "Host de destino") || 
						strstr($saida[3], "Falha na") || 
						strstr($saida[3], "Destina") ||
						strstr($saida[3], "timed out") ||
						strstr($saida[3], "unreachable") || 
						strstr($saida[2], "Esgotado") || 
						strstr($saida[2], "Host de destino") || 
						strstr($saida[2], "Falha na") || 
						strstr($saida[2], "Destina") ||
						strstr($saida[2], "timed out") ||
						strstr($saida[2], "unreachable")){
							$mqn = "off";
					} else {
						$mqn = "on";
					}
			}

			if($this->SISTEMA_OPER == "Linux"){
			
				if(strstr($saida[1], "0 received") || 
				strstr($saida[2], "0 received") || 
				strstr($saida[3], "0 received") || 
				strstr($saida[4], "0 received") ||
				strstr($saida[5], "0 received")){
					$mqn = "off";
				} else {
					$mqn = "on";
				}
			
			}
			print'<?xml version="1.0" encoding="ISO-8859-1" ?>';
			print'<cliente ip="'.$ip.'" retorno="'.$mqn.'"  nivel="'.$nivel.'"></cliente>';
	}
	
	#INSTANCIA DAS FUNCOES
	function HEADER(){
		
		if($_POST["key"] == $this->KEY){
			if($_POST["function"] == "PING"){$this->PING();}
			if($_POST["function"] == "TELNET"){$this->TELNET();}
			if($_POST["function"] == "PERSONAL"){$this->PERSONAL();}
		}

	}
	
	
}
#CLASSE
$OUT = new conexao_bd;
$OUT ->HEADER();

?>