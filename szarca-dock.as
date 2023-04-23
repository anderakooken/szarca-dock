/* @anderakooken */

import flash.filesystem.*;
import flash.events.MouseEvent;
import flash.net.FileReference;
import com.hurlant.crypto.symmetric.ICipher;
import com.hurlant.crypto.symmetric.IVMode;
import com.hurlant.crypto.symmetric.IMode;
import com.hurlant.crypto.symmetric.NullPad;
import com.hurlant.crypto.symmetric.PKCS5;
import com.hurlant.crypto.symmetric.IPad;
import com.hurlant.crypto.prng.Random;
import com.hurlant.crypto.hash.HMAC;
import com.hurlant.util.Base64;
import com.hurlant.util.Hex;
import com.hurlant.crypto.Crypto;
import com.hurlant.crypto.hash.IHash;
import flash.desktop.DockIcon;
import flash.desktop.NativeApplication;
import flash.display.Loader;
import flash.display.NativeMenu;
import flash.display.NativeMenuItem;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.TimerEvent;
import flash.net.URLRequest;
import flash.utils.Timer;
import flash.globalization.DateTimeFormatter;

var dir:File = File.applicationDirectory; 
var dir1 = (String(dir.nativePath).split('\\').join('"\\\\"'));
var diretorioInstalacao = dir1.split(':"\\').join(':\\')+'"';

var xmlArq;

var dirUser:File = File.applicationStorageDirectory; 
var dirUser1 = (String(dirUser.nativePath).split('\\').join('"\\\\"'));
var diretorioUsuario = dirUser1.split(':"\\').join(':\\')+'"';

var fileRef:FileReference;
var senhaLembrada;

function pegaDataAtual(){
	var d:Date = new Date();
	var dtf:DateTimeFormatter = new DateTimeFormatter("en-US");
	dtf.setDateTimePattern("yyyyMMdd");
	return dtf.format(d); 
}

//RETIRA A ESCALA DO SWF
stage.align = StageAlign.RIGHT;
stage.scaleMode = StageScaleMode.NO_SCALE;
NativeWindowType.LIGHTWEIGHT;

var array_index_ConnSSH:Array = new Array();
var array_titulo_ConnSSH:Array = new Array();
var array_key_ConnSSH:Array = new Array();
var array_vetor_ConnSSH:Array = new Array();
var array_crypt_ConnSSH:Array = new Array();
var array_servidor_ConnSSH:Array = new Array();
var array_porta_ConnSSH:Array = new Array();
var array_usuario_ConnSSH:Array = new Array();
var array_senha_ConnSSH:Array = new Array();
var array_tunel_ConnSSH:Array = new Array();


var obj_MnQuadro:Array = new Array();
	obj_MnQuadro["quadro"] = FRAME_MAIN;
	obj_MnQuadro["quadro_notas"] = FRAME_NOTAS;

var		criptoKey = "#szarcaDock@67b207db5a296e80";
var 	criptoKeyBuilder = "#szarcaDockBuilder@67b207db5a296e80";
var		versao = "1.7.5";

var		titulo = "";
var 	servidor;
var 	tempo_atualizacao;
var 	audio;
var 	offLineObj = 0;
var 	key;
var 	key_seguranca;
var 	cor_online;
var 	cor_offline;
var 	cor_obj_titulo;
var 	app_lar;
var 	app_alt;
var		log;
var		arq = "log.txt";
var 	escalaXY;
var		iniciar_visivel;
var 	autorizaFuncionamento = 0;

var 	ssh;
var 	ssh_iniciar_auto;
var 	ssh_id_conn_auto;
var		ssh_servidor;
var 	ssh_porta;
var		ssh_senha;
var 	ssh_usuario;
var 	tuneis = "";
var 	ssh_status;
var		ssh_sts_conectado = 0;

var 	systemTrayIcon;
var		executar_background;
var		executar_objetos;

var 	qtdSSHConn = 0;
var 	connSelecionada;

offLineObjs.visible = false;
ALERTA.visible = false;
LOGS.visible = false;
SSH_SAIDA.visible = false;
MAIN.visible = false;

var ATL:Timer;

SSH_SAIDA.BT.addEventListener(MouseEvent.CLICK,
	function():void{
		SSH_SAIDA.visible = false;
	});
ALERTA.BT.addEventListener(MouseEvent.CLICK,
	function():void{
		ALERTA.visible = false;
	});

MAIN.logo.addEventListener(
			MouseEvent.RIGHT_CLICK,
					function(e:MouseEvent):void{
						LOGS.visible = true;
						lLog();
					}
			);


function reportKeyDown(event:KeyboardEvent):void 
{ 

	if(event.charCode == 64){
		
		cmdSSH(
			 "iniciar",
			ssh_servidor, 
			ssh_porta,
			ssh_usuario, 
			ssh_senha, 
			tuneis
		);
		
		SSH_SAIDA.visible = true;
	}
	if(event.charCode == 32){ //space - mostra os objects
		if(obj_MnQuadro["quadro"].visible == false){
			obj_MnQuadro["quadro"].visible = true;
		} else {
			obj_MnQuadro["quadro"].visible = false;
		}
	}
	
    if(event.charCode == 33){ //! - abre o log SSH
		if(SSH_SAIDA.visible == false){
			SSH_SAIDA.visible = true;
		} else {
			SSH_SAIDA.visible = false;
		}
	}
} 
stage.addEventListener(KeyboardEvent.KEY_DOWN, reportKeyDown);

LOGS.BT_LIMPAR.addEventListener(MouseEvent.CLICK,
	function():void{
		rLog();
	});
	
LOGS.BT.addEventListener(MouseEvent.CLICK,
	function():void{
		LOGS.visible = false;
	});
		
MAIN.logo.addEventListener(MouseEvent.MOUSE_DOWN,ARRASTA);
			
function ARRASTA(EVENTO:MouseEvent):void{
	stage.nativeWindow.startMove();
}
  
/* HORA */
var tempo:Timer = new Timer(1000);
tempo.start();
tempo.addEventListener(TimerEvent.TIMER,mostra);

function mostra(evento:TimerEvent):void {
 data_hora();

}

function alertarMsg(msg){
	ALERTA.visible = true;
	ALERTA.texto.text = msg;
}
function data_hora(){
	var valores:Date = new Date();
var ano:String=String(valores.getFullYear());
var mes:String=String(valores.getMonth()+1);
var dia:String=String(valores.getDate());


var hora:String=String(valores.getHours());
var minuto:String=String(valores.getMinutes());
var segundo:String=String(valores.getSeconds());

//Condições para acrescentar '0' (zero)
if(hora.length==1){
hora = "0" + hora;
}

if(minuto.length==1){
minuto = "0" + minuto;
}

if(segundo.length==1){
segundo = "0" + segundo;
}

if(mes.length==1){
mes = "0" + mes;
}

var data_formatada:String=dia + "/" + mes + "/" + ano;

var horario:String= data_formatada+" "+hora + ":" + minuto + ":" + segundo;
MAIN.HR.text=horario;
}

function BIBLIOTECA(id:String):MovieClip{
	var OBJ:Object = null;
	OBJ = getDefinitionByName(id.toString());
	return (new OBJ()) as MovieClip;
}

function INSERT(obj, titulo, id, md, ip, o_x, o_y, num, nivel, nivel_2, nivel_3, alerta){
	
	//INSERIR DA LIBRARY
	var A:MovieClip = BIBLIOTECA(obj);
		A.name = id;
		
		obj_MnQuadro["quadro"].addChild(A);
		var OBJ_INSD = obj_MnQuadro["quadro"].getChildByName(A.name);
		
		OBJ_INSD.tp_obj = obj;
		OBJ_INSD.alerta = alerta;
		OBJ_INSD.nivel = nivel;
		OBJ_INSD.nivel_2 = nivel_2;
		OBJ_INSD.nivel_3 = nivel_3;
		OBJ_INSD.ip = ip;
		OBJ_INSD.num = num;
		
		OBJ_INSD.x = o_x;
		OBJ_INSD.y = o_y;
		OBJ_INSD.INFORMACAO.visible = false;
		
		levelObj("nivel",  A.name, 0);
		levelObj("nivel_2",  A.name, 0);
		levelObj("nivel_3",  A.name, 0);
		
		
		if(OBJ_INSD.NUMERICO){
			if(num == 'true'){	OBJ_INSD.NUMERICO.visible = true; }
			if(num == 'false'){	OBJ_INSD.NUMERICO.visible = false; }
		}
		
		OBJ_INSD.TITULO.text = titulo;
		OBJ_INSD.IP = ip;
		OBJ_INSD.id_interno = String(obj);
		
		if(cor_obj_titulo != ""){
			var my_color:ColorTransform = new ColorTransform();
				my_color.color = uint("0x"+cor_obj_titulo);
				OBJ_INSD.TITULO.transform.colorTransform = my_color;
		}
			
		
		OBJ_INSD.INFORMACAO.OBJ_ID.text = id;
		OBJ_INSD.INFORMACAO.OBJ_TITULO.text = titulo;
		OBJ_INSD.INFORMACAO.OBJ_CMD.text = md+" - "+ip;
		OBJ_INSD.INFORMACAO.OBJ_POS.text =  o_x+"x , "+o_y+"y"
		
		if(escalaXY != "0"){
			
			OBJ_INSD.scaleX += Number("0."+escalaXY);
			OBJ_INSD.scaleY += Number("0."+escalaXY);
			
		}
		
		OBJ_INSD.addEventListener(
			MouseEvent.CLICK,
					function(e:MouseEvent):void{
						
						if(OBJ_INSD.INFORMACAO.visible == true){
							OBJ_INSD.INFORMACAO.visible = false;
						} else {
							OBJ_INSD.INFORMACAO.visible = true;
						}
					}
				);
				
		
		if(md == "PERSONAL"){
			//FUNÇÕES PERSONALIZADAS
			PERSONAL(md,id);
			//pingTimer(md, ip, id);
		} else {
			//PING e TELNET
			PING(md,id);
			
		}
		
		pingTimer(md,id);

}

function pingTimer(md,id){
	ATL.start();
	ATL.addEventListener(TimerEvent.TIMER,
		function():void{
			if(md == "PERSONAL"){
				PERSONAL(md,id);
			} else {
				PING(md,id);
			}
		}
	);
}
var audAl:Timer = new Timer(5000);
function audioAlerta(){
	audAl.start();
	audAl.addEventListener(TimerEvent.TIMER,
		function():void{
		
			if(offLineObjs.text != "0"){
				
				if(audio == "true"){
					var req:URLRequest = new URLRequest("notify.mp3");
					var s:Sound = new Sound(req); 
					s.play(0,1);
				}
				
				offLineObjs.text = "0";
			}
		}
	);
}

function rLog(){
	
	var CONF_file:File = 
			File.applicationStorageDirectory.resolvePath(arq);
					
			if(CONF_file.exists){

				var CONF_fileStream:FileStream = new FileStream();
					CONF_fileStream.open(CONF_file, FileMode.WRITE);
						
				CONF_fileStream.writeUTFBytes('');
					
					CONF_fileStream.close();
					
					alertarMsg("Logs removidos!");
			}
					
}
function lLog(){
	var CONF_file:File = 
			File.applicationStorageDirectory.resolvePath(arq);
					
			if(CONF_file.exists){
				
				var CONF_arquivo:File = 
				File.applicationStorageDirectory.resolvePath(arq);
				var CONF_stream_arquivo:FileStream = new FileStream();
					CONF_stream_arquivo.open(CONF_arquivo, FileMode.READ);
		
					var conteudo = 
						String(CONF_stream_arquivo.readUTFBytes(
								CONF_stream_arquivo.bytesAvailable)
							);
				CONF_stream_arquivo.close();
			
			LOGS.logs.text = String(conteudo).replace(/\n/g, "");
			}
	
}
function xLog(id, md, ip, sts){
	
	try
	{
		if(log == "true"){
			var CONF_file:File = 
			File.applicationStorageDirectory.resolvePath(arq);
					
			if(CONF_file.exists){
				
				var CONF_arquivo:File = 
				File.applicationStorageDirectory.resolvePath(arq);
				var CONF_stream_arquivo:FileStream = new FileStream();
					CONF_stream_arquivo.open(CONF_arquivo, FileMode.READ);
		
					var conteudo = 
						String(CONF_stream_arquivo.readUTFBytes(
								CONF_stream_arquivo.bytesAvailable)
							);
				CONF_stream_arquivo.close();
				
				
				var CONF_fileStream:FileStream = new FileStream();
					CONF_fileStream.open(CONF_file, FileMode.WRITE);
						
				CONF_fileStream.writeUTFBytes(
					conteudo+''+
					'<obj '+
						'id="'+	id +'" '+
						'ip="'+ ip +'" '+
						'md="'+ md +'" '+
						'sts="'+ sts +'" '+
						'dt="'+ String(MAIN.HR.text) +'" '+
						'>'+
					'</obj>\r\n');
					
					CONF_fileStream.close();
			}
		}
	}catch(e:Error){
		
	}
}

function objLv(cmd, id_obj, seq, sw){
	if(cmd == "nivel"){
		obj_MnQuadro["quadro"].getChildByName(id_obj).LEVEL_SERVER.getChildByName("LV_"+seq).visible = sw;
	}
	if(cmd == "nivel_2"){
		obj_MnQuadro["quadro"].getChildByName(id_obj).LEVEL_SERVER.LV_AUX.getChildByName("LV_"+seq).visible = sw;
	}
	if(cmd == "nivel_3"){
		obj_MnQuadro["quadro"].getChildByName(id_obj).LEVEL_SERVER.LV_AUX_2.getChildByName("LV_"+seq).visible = sw;
	}
}
function levelObj(cmd, id_obj, nivel){
	
	try{
		if(nivel == 0){
			objLv(cmd, id_obj, 1, false); 	
			objLv(cmd, id_obj, 2, false);	
			objLv(cmd, id_obj, 3, false);
			objLv(cmd, id_obj, 4, false);	
			objLv(cmd, id_obj, 5, false);
		}
		if(nivel == 1){
			objLv(cmd, id_obj, 1, true); 	
			objLv(cmd, id_obj, 2, false);	
			objLv(cmd, id_obj, 3, false);
			objLv(cmd, id_obj, 4, false);	
			objLv(cmd, id_obj, 5, false);
		}
		if(nivel == 2){
			objLv(cmd, id_obj, 1, true); 	
			objLv(cmd, id_obj, 2, true);	
			objLv(cmd, id_obj, 3, false);
			objLv(cmd, id_obj, 4, false);	
			objLv(cmd, id_obj, 5, false);
		}
		if(nivel == 3){
			objLv(cmd, id_obj, 1, true); 	
			objLv(cmd, id_obj, 2, true);	
			objLv(cmd, id_obj, 3, true);
			objLv(cmd, id_obj, 4, false);	
			objLv(cmd, id_obj, 5, false);
		}
		if(nivel == 4){
			objLv(cmd, id_obj, 1, true); 	
			objLv(cmd, id_obj, 2, true);	
			objLv(cmd, id_obj, 3, true);
			objLv(cmd, id_obj, 4, true);	
			objLv(cmd, id_obj, 5, false);
		}
		if(nivel == 5 || nivel > 5){
			objLv(cmd, id_obj, 1, true); 	
			objLv(cmd, id_obj, 2, true);	
			objLv(cmd, id_obj, 3, true);
			objLv(cmd, id_obj, 4, true);	
			objLv(cmd, id_obj, 5, true);
		}
	}catch(e:Error){
		//trace(e);
	}
}
function PING(md:String, id_obj:String){

	var my_color:ColorTransform = new ColorTransform();

	if(ip != "" && id_obj != "" && md != ""){

		var optAlertar 	= obj_MnQuadro["quadro"].getChildByName(id_obj).alerta;
		var num 		= obj_MnQuadro["quadro"].getChildByName(id_obj).num;
		var nivel 		= obj_MnQuadro["quadro"].getChildByName(id_obj).nivel;
		var nivel_2		= obj_MnQuadro["quadro"].getChildByName(id_obj).nivel_2;
		var nivel_3		= obj_MnQuadro["quadro"].getChildByName(id_obj).nivel_3;
		var ip 			= obj_MnQuadro["quadro"].getChildByName(id_obj).ip;
		
		var _URL:String = servidor;
		var XHP:URLRequest = new URLRequest(_URL);
		
		var pVars:URLVariables = new URLVariables();
			pVars["function"] = md;
			pVars["tp_obj"] = obj_MnQuadro["quadro"].getChildByName(id_obj).tp_obj;
			pVars["id_obj"] = id_obj;
			pVars["nivel"] = nivel;
			pVars["nivel_2"] = nivel_2;
			pVars["nivel_3"] = nivel_3;
			pVars["ip"] = ip;
			pVars["key"] = key;
			pVars["key_seguranca"] = key_seguranca;
			XHP.data = pVars; 
			XHP.method = URLRequestMethod.POST;
		
		var CRG:URLLoader = new URLLoader();
			CRG.load(XHP);
			
		var EnviaCMD = Function;
			CRG.addEventListener(Event.COMPLETE,
				EnviaCMD = function(evento:Event):void{
					var cliente:XML = new XML(CRG.data);
					
					//trace(CRG.data);
					if(CRG.data != ""){
						if(cliente.@retorno == "off"){
							
							xLog(
								 id_obj, 
								 md, 
								 ip, 
								 cliente.@retorno
							);
							
							if(nivel == "true")		{levelObj("nivel",id_obj, 0);}
							if(nivel_2 == "true")	{levelObj("nivel_2",id_obj, 0);}
							if(nivel_3 == "true")	{levelObj("nivel_3",id_obj, 0);}
							
							if(optAlertar == "true"){
								
								offLineObjs.text = "1";
							}
							my_color.color = uint("0x"+cor_offline);
							obj_MnQuadro["quadro"].getChildByName(id_obj).ICON.transform.colorTransform = my_color;

							obj_MnQuadro["quadro"].getChildByName(id_obj).NUMERICO.text = "";

						} else {
							
							if(nivel == "true")		{levelObj("nivel",id_obj, cliente.@nivel);}
							if(nivel_2 == "true")	{levelObj("nivel_2",id_obj, cliente.@nivel_2);}
							if(nivel_3 == "true")	{levelObj("nivel_3",id_obj, cliente.@nivel_3);}
							
							my_color.color = uint("0x"+cor_online);
							obj_MnQuadro["quadro"].getChildByName(id_obj).ICON.transform.colorTransform = my_color;
							
							if(num == 'true'){
								obj_MnQuadro["quadro"].getChildByName(id_obj).NUMERICO.text = String(cliente.@msg);
							}
						}
					} else {
						
						if(nivel == "true")		{levelObj("nivel",id_obj, 0);}
						if(nivel_2 == "true")	{levelObj("nivel_2",id_obj, 0);}
						if(nivel_3 == "true")	{levelObj("nivel_3",id_obj, 0);}
						
						my_color.color = uint("0x"+cor_offline);
							obj_MnQuadro["quadro"].getChildByName(id_obj).ICON.transform.colorTransform = my_color;
							
						obj_MnQuadro["quadro"].getChildByName(id_obj).NUMERICO.text = "";
						
					}
					
					CRG.removeEventListener(Event.COMPLETE,EnviaCMD);
				}
			);
			
		
		var ErroCMD = Function;
			CRG.addEventListener(IOErrorEvent.IO_ERROR, 
				ErroCMD = function(evento:Event):void{
					
					if(nivel == "true")		{levelObj("nivel",id_obj, 0);}
					if(nivel_2 == "true")	{levelObj("nivel_2",id_obj, 0);}
					if(nivel_3 == "true")	{levelObj("nivel_3",id_obj, 0);}
					
					if(optAlertar == "true"){
						offLineObjs.text = "1";
					}
					my_color.color = uint("0xFF9933");
					obj_MnQuadro["quadro"].getChildByName(id_obj).ICON.transform.colorTransform = my_color;
					
					obj_MnQuadro["quadro"].getChildByName(id_obj).NUMERICO.text = "";
					
					CRG.removeEventListener(IOErrorEvent.IO_ERROR, ErroCMD);
				} 
			);
	} else {
		
		if(optAlertar == "true"){
			offLineObjs.text = "1";
		}
		my_color.color = uint("0x"+cor_offline);
		obj_MnQuadro["quadro"].getChildByName(id_obj).ICON.transform.colorTransform = my_color;
		
	}
	
}

function PERSONAL(md:String, id_obj:String){

	var my_color:ColorTransform = new ColorTransform();
	
	if(ip != "" && id_obj != "" && md != ""){

		var num 		= obj_MnQuadro["quadro"].getChildByName(id_obj).num;
		var nivel 		= obj_MnQuadro["quadro"].getChildByName(id_obj).nivel;
		var nivel_2		= obj_MnQuadro["quadro"].getChildByName(id_obj).nivel_2;
		var nivel_3		= obj_MnQuadro["quadro"].getChildByName(id_obj).nivel_3;
		var ip 			= obj_MnQuadro["quadro"].getChildByName(id_obj).ip;
		
		var _URL:String = servidor;
		var XHP:URLRequest = new URLRequest(_URL);
		
		var pVars:URLVariables = new URLVariables();
			pVars["function"] = md;
			pVars["tp_obj"] = obj_MnQuadro["quadro"].getChildByName(id_obj).tp_obj;
			pVars["id_obj"] = id_obj;
			pVars["nivel"] = nivel;
			pVars["nivel_2"] = nivel_2;
			pVars["nivel_3"] = nivel_3;
			pVars["ip"] = ip;
			pVars["key"] = key;
			pVars["key_seguranca"] = key_seguranca;
			XHP.data = pVars; 
			XHP.method = URLRequestMethod.POST;
		
		var CRG:URLLoader = new URLLoader();
			CRG.load(XHP);

		var EnviaCMD = Function;
			CRG.addEventListener(Event.COMPLETE,
				EnviaCMD = function(evento:Event):void{
					var cliente:XML = new XML(CRG.data);

					if(CRG.data != ""){
		
						if(nivel == "true")		{levelObj("nivel",id_obj, cliente.@nivel);}
						if(nivel_2 == "true")	{levelObj("nivel_2",id_obj, cliente.@nivel_2);}
						if(nivel_3 == "true")	{levelObj("nivel_3",id_obj, cliente.@nivel_3);}
							
						if(num == 'true'){
							obj_MnQuadro["quadro"].getChildByName(id_obj).NUMERICO.text = String(cliente.@retorno);
						}
						
						my_color.color = uint("0x"+cor_online);
						obj_MnQuadro["quadro"].getChildByName(id_obj).ICON.transform.colorTransform = my_color;
						
					} else {
						
						if(nivel == "true")		{levelObj("nivel",id_obj, 0);}
						if(nivel_2 == "true")	{levelObj("nivel_2",id_obj, 0);}
						if(nivel_3 == "true")	{levelObj("nivel_3",id_obj, 0);}
						
						if(num == 'true'){
							obj_MnQuadro["quadro"].getChildByName(id_obj).NUMERICO.text = "";
						}
						my_color.color = uint("0x"+cor_offline);
							obj_MnQuadro["quadro"].getChildByName(id_obj).ICON.transform.colorTransform = my_color;
					}
					CRG.removeEventListener(Event.COMPLETE,EnviaCMD);
				}
			);

		var ErroCMD = Function;
			CRG.addEventListener(IOErrorEvent.IO_ERROR, 
				ErroCMD = function(evento:Event):void{
					
					if(nivel == "true")		{levelObj("nivel",id_obj, 0);}
					if(nivel_2 == "true")	{levelObj("nivel_2",id_obj, 0);}
					if(nivel_3 == "true")	{levelObj("nivel_3",id_obj, 0);}
						
					if(num == 'true'){
							obj_MnQuadro["quadro"].getChildByName(id_obj).NUMERICO.text = "";
						}
						
					offLineObjs.text = "1";
					my_color.color = uint("0xFF9933");
					obj_MnQuadro["quadro"].getChildByName(id_obj).ICON.transform.colorTransform = my_color;
						
					CRG.removeEventListener(IOErrorEvent.IO_ERROR, ErroCMD);
				} 
			);
	} else {
		
		if(nivel == "true")		{levelObj("nivel",id_obj, 0);}
		if(nivel_2 == "true")	{levelObj("nivel_2",id_obj, 0);}
		if(nivel_3 == "true")	{levelObj("nivel_3",id_obj, 0);}
						
		offLineObjs.text = "1";
		my_color.color = uint("0x"+cor_offline);
		obj_MnQuadro["quadro"].getChildByName(id_obj).ICON.transform.colorTransform = my_color;
		
	}
	
}

function iniciaNotas(){
	
	var CONF_str:String = 
			'<?xml version="1.0" encoding="utf-8" ?>';
		CONF_str += '<notas>';
		CONF_str += '</notas>';
		
		var CONF_file:File = 
				File.applicationStorageDirectory.resolvePath("notas.xml");
		
		if(!CONF_file.exists){
			var CONF_fileStream:FileStream = new FileStream();
			CONF_fileStream.open(CONF_file, FileMode.WRITE);
			CONF_fileStream.writeUTFBytes(CONF_str);
			CONF_fileStream.close();
			
			helpCmd();
		}

		//VERIFICA SE EXISTE UM ARQUIVO OBJETO
		var OBJ_file:File = 
				File.applicationStorageDirectory.resolvePath("notas.xml");
		
		if(!OBJ_file.exists){
			cmdWindows('copy '+diretorioInstalacao+'\\notas.xml '+diretorioUsuario+'');
		}

		var CONF_arquivo:File = File.applicationStorageDirectory.resolvePath("notas.xml");
		var CONF_stream_arquivo:FileStream = new FileStream();
		CONF_stream_arquivo.open(CONF_arquivo, FileMode.READ);

		var notas:XML = new XML(CONF_stream_arquivo.readUTFBytes(CONF_stream_arquivo.bytesAvailable));

		var qtd = notas.nota.length();
			
				for (var i:Number = 0; i < qtd; i++){
		
					INSERIR_NOTAS(
						"NOTA", 
						notas.nota[i], 
						"sznota_"+notas.nota[i].@id,
						notas.nota[i].@o_x, 
						notas.nota[i].@o_y
					);
				}
		
}

function INSERIR_NOTAS(obj, texto, id, o_x, o_y){
	
	//INSERIR DA LIBRARY
	var A:MovieClip = BIBLIOTECA(obj);
		A.name = id;
		
		obj_MnQuadro["quadro_notas"].addChild(A);
		var OBJ_INSD = obj_MnQuadro["quadro_notas"].getChildByName(A.name);
		
		OBJ_INSD.tp_obj = obj;
		OBJ_INSD.x = o_x;
		OBJ_INSD.y = o_y;
		
		OBJ_INSD.texto.text = texto;
		OBJ_INSD.id_interno = String(obj);

}

function iniciaConfInicial(){
	
	var CONF_str:String = 
			'<?xml version="1.0" encoding="ISO-8859-1" ?>';
		CONF_str += '<configuracoes ';
		CONF_str += 'cliente="szarca-dock" ';
		CONF_str += 'id_sistema="'+Math.random()+'" ';
		CONF_str += 'chave="P@dR4O" ';
		CONF_str += '></configuracoes>';
		
		var CONF_file:File = 
				File.applicationStorageDirectory.resolvePath("config.xml");
		
		if(!CONF_file.exists){
			var CONF_fileStream:FileStream = new FileStream();
			CONF_fileStream.open(CONF_file, FileMode.WRITE);
			CONF_fileStream.writeUTFBytes(CONF_str);
			CONF_fileStream.close();
			
			helpCmd();
		}

		var CONF_arquivo:File = File.applicationStorageDirectory.resolvePath("config.xml");
		var CONF_stream_arquivo:FileStream = new FileStream();
		CONF_stream_arquivo.open(CONF_arquivo, FileMode.READ);

		var configuracoes:XML = new XML(CONF_stream_arquivo.readUTFBytes(CONF_stream_arquivo.bytesAvailable));
		
		permissaoUso(configuracoes.@id_sistema, configuracoes.@chave);
		
		
}
iniciaConfInicial();
function permissaoUso(id_sistema, chave){
	LoadProjeto(false);
}

var senhaDigitada = 0;
FRM_SENHA_PROJETO.visible = false;
FRM_SENHA_PROJETO.FORM.OK.addEventListener(
	MouseEvent.CLICK,
		function():void{
			if(FRM_SENHA_PROJETO.FORM.id.text != ""){
				senhaDigitada = 1;
				LoadProjeto(xmlArq);
			} else {
				alertarMsg("Por favor, digite a senha.");
			}
		}
	);
	

function LoadProjeto(strXml){

	var liberarSistema = 0;
	var stsJan = 2;
	var sshDockMsg = "Desconectado";
	var iconeDockSTS = "off";

	
	
	try{
		
	 data_hora();
		 
		var dispositivos:XML;
		 
		if(strXml == false){
			
			/*try{
				var CONF_arquivo:File = 
						File.applicationStorageDirectory.resolvePath("objetos.xml");
				
				var CONF_stream_arquivo:FileStream = new FileStream();
					CONF_stream_arquivo.open(CONF_arquivo, FileMode.READ);
				
				var Drptd = String(CONF_stream_arquivo.readUTFBytes(CONF_stream_arquivo.bytesAvailable));
				
				var arqProj:XML = 
					new XML(Drptd);

					xmlArq = decrypt(arqProj.proj[0].@id, criptoKeyBuilder,arqProj.proj[0]);
					dispositivos = new XML(xmlArq);
						
					
					var arqProj:XML = 
						new XML(Drptd);
						
					
					
			}catch(e:Error){
				
				systemTrayIcon = "true";
				liberarSistema = 0;
			}*/
			janela(false);
			systemTrayIcon = "true";
			liberarSistema = 0;
			
		} else {
			
			var arqProj:XML = 
					new XML(strXml);
			
			var xmlArqDec;
			xmlArqDec = decrypt(arqProj.proj[0].@id, criptoKeyBuilder,arqProj.proj[0]);
			dispositivos = new XML(xmlArqDec);
			
			if(arqProj.proj[0] != "" && arqProj.proj[0].@id != ""){
						
				senhaLembrada = arqProj.proj[0].@senha_lembrar;
				
				if(pegaDataAtual() > dispositivos.@data_limite && 
				   dispositivos.@data_limite != ""){
					
					liberarSistema = 0; //VERIFICA A VALIDADE DO PROJETO
					alertarMsg(
						"A data limite de uso do projeto expirou."
					);
			
				} else{
						if(dispositivos.@senha_protecao_exec != ""){
									
							if(senhaLembrada != dispositivos.@senha_protecao_exec){
								if(FRM_SENHA_PROJETO.FORM.id.text != dispositivos.@senha_protecao_exec){
									
									liberarSistema = 0;
									FRM_SENHA_PROJETO.visible = true;
									janela(true);
									if(senhaDigitada == 1){
										alertarMsg("Senha Invalida.");
									}
													
								} else {
									liberarSistema = 1;
									FRM_SENHA_PROJETO.visible = false;
								}
							} else {
								liberarSistema = 1;
								alertarMsg(
										"A senha lembrada nao corresponde."
									);
							}
						} else {
							liberarSistema = 1;
						}
				}
	
			} else {
				alertarMsg(
					"O arquivo selecionado esta "+
					"corrompido ou requer outra versão do software."
				);
			}
			
		}
		
		if(liberarSistema == 1){
			
			MAIN.visible = true;
			
			titulo 				= dispositivos.@titulo;
			servidor 			= dispositivos.@servidor;
			tempo_atualizacao 	= dispositivos.@tempo_atualizacao;
			audio 				= dispositivos.@audio_alertar;
			key 				= dispositivos.@key;
			key_seguranca 		= dispositivos.@key_seguranca;
			cor_online			= dispositivos.@cor_online;
			cor_offline			= dispositivos.@cor_offline;
			cor_obj_titulo		= dispositivos.@cor_obj_titulo;
			log					= dispositivos.@log;
			escalaXY			= dispositivos.@escalaXY;
			iniciar_visivel		= dispositivos.@iniciar_visivel;
			
			systemTrayIcon		= dispositivos.@systemTrayIcon;
			executar_background	= dispositivos.@executar_background;
			executar_objetos	= dispositivos.@executar_objetos;
			
			//USO DE SSH?
			ssh 				= dispositivos.@ssh;
			ssh_iniciar_auto	= dispositivos.@ssh_iniciar_auto;
			ssh_id_conn_auto	= dispositivos.@ssh_id_conn_auto;
			ssh_status 			= dispositivos.@ssh_status;

			if(iniciar_visivel == "false"){
				obj_MnQuadro["quadro"].visible = false;
			}
			
			if(log == "true"){
				
				var CONF_file:File = 
				File.applicationStorageDirectory.resolvePath("log.txt");
				
				if(!CONF_file.exists){
					var CONF_fileStream:FileStream = new FileStream();
					CONF_fileStream.open(CONF_file, FileMode.WRITE);
					
					CONF_fileStream.writeUTFBytes(
					"SZARCA-DOCK - Log Ativado\r\n"+
					"Data: "+MAIN.HR.text+"\r\n \r\n");
					CONF_fileStream.close();
				}
			}
			
			//EXECUTAR OBJS?
			if(executar_objetos == "true"){
				
				ATL = new Timer(int(tempo_atualizacao));
				audioAlerta();
				
				var qtd = dispositivos.obJ.length();
			
				for (var i:Number = 0; i < qtd; i++){
		
					INSERT(
						dispositivos.obJ[i].@tp, 
						dispositivos.obJ[i].@titulo, 
						dispositivos.obJ[i].@id,
						dispositivos.obJ[i].@md,
						dispositivos.obJ[i].@ip, 
						dispositivos.obJ[i].@o_x, 
						dispositivos.obJ[i].@o_y,
						dispositivos.obJ[i].@num,
						dispositivos.obJ[i].@nivel,
						dispositivos.obJ[i].@nivel_2,
						dispositivos.obJ[i].@nivel_3,
						dispositivos.obJ[i].@alerta
					);
				}
			}
			
			
			sshDockMsg = "Desconectado";
			iconeDockSTS = "off";
			
			if(ssh_iniciar_auto == "true"){
				iconeDockSTS = "on";
			}
			
			//ocultar janela inicial
			stsJan = 2;
			if(executar_background == "true"){
				stsJan = 1;
				janela(false);
			}
			
			//TUNEIS SSH?
			if(ssh == "true"){
				
				var sshAuto_servidor;
				var sshAuto_porta;
				var sshAuto_usuario;
				var sshAuto_senha;
				var sshAuto_tuneis = "";
				
				qtdSSHConn = dispositivos.ssh.length();

				for (var a:Number = 0; a < qtdSSHConn; a++){

					array_index_ConnSSH[a] = dispositivos.ssh[a].@id;
					
					array_titulo_ConnSSH[dispositivos.ssh[a].@id] = dispositivos.ssh[a].@titulo;
					array_key_ConnSSH[dispositivos.ssh[a].@id] = dispositivos.ssh[a].@key;
					array_vetor_ConnSSH[dispositivos.ssh[a].@id] = dispositivos.ssh[a].@vetor;
					array_crypt_ConnSSH[dispositivos.ssh[a].@id] = dispositivos.ssh[a];
					
					
					var sshConn:XML = 
						new XML(
							decrypt(
								array_vetor_ConnSSH[dispositivos.ssh[a].@id], 
								array_key_ConnSSH[dispositivos.ssh[a].@id], 
								array_crypt_ConnSSH[dispositivos.ssh[a].@id]
							)
						);
	
					array_servidor_ConnSSH[dispositivos.ssh[a].@id] = sshConn.@ssh_servidor;
					array_porta_ConnSSH[dispositivos.ssh[a].@id] 	= sshConn.@ssh_porta;
					array_senha_ConnSSH[dispositivos.ssh[a].@id] 	= sshConn.@ssh_senha;
					array_usuario_ConnSSH[dispositivos.ssh[a].@id]	= sshConn.@ssh_usuario;
	
					var qtdSSHTun = sshConn.ssh_tn.length();
					
					array_tunel_ConnSSH[dispositivos.ssh[a].@id] = "";
					
					for (var e:Number = 0; e < qtdSSHTun; e++){
						array_tunel_ConnSSH[dispositivos.ssh[a].@id] = 
						array_tunel_ConnSSH[dispositivos.ssh[a].@id] + " " +sshTunnel(
							sshConn.ssh_tn[e].@pLocal,
							sshConn.ssh_tn[e].@pRemoto,
							sshConn.ssh_tn[e].@id
						);
						
						
						if(ssh_iniciar_auto == "true"){
							if(ssh_id_conn_auto == dispositivos.ssh[a].@id){
								//SE TIVER AUTO, GUARDA OS TUNEIS
								sshAuto_tuneis = sshAuto_tuneis + " " +sshTunnel(
									sshConn.ssh_tn[e].@pLocal,
									sshConn.ssh_tn[e].@pRemoto,
									sshConn.ssh_tn[e].@id
								);
							}
						}
					}
					
					//SE TIVER AUTO SSH, GUARDA OS DADOS DA CONN
					if(ssh_iniciar_auto == "true"){
						if(ssh_id_conn_auto == dispositivos.ssh[a].@id){
							
							sshAuto_servidor 	= sshConn.@ssh_servidor;
							sshAuto_porta 		= sshConn.@ssh_porta;
							sshAuto_usuario		= sshConn.@ssh_usuario;
							sshAuto_senha		= sshConn.@ssh_senha;
							
						}
					}
					
					
				}
				if(ssh_iniciar_auto == "true"){
					
					cmdSSH(
						  "iniciar",
							sshAuto_servidor, 
							sshAuto_porta,
							sshAuto_usuario, 
							sshAuto_senha, 
							sshAuto_tuneis
					);
					
				}
			
			}
			
		}
			//ICONE SYSTRAY?
			if(systemTrayIcon == "true"){
				iniciarDock(sshDockMsg, stsJan, iconeDockSTS);
			}
		
		
	}catch(e:Error){
		alertarMsg("Arquivo nao encontrado. \n "+
		"C:\\Users\\[usuario da maquina]\\AppData\\Roaming\\szarca-dock\\Local Store\\objetos.xml");

	}
}

function janela(e){
	stage.nativeWindow.visible = e;
}

function sshTunnel(pLocal,pRemoto,id){
	return "-L "+pLocal+":"+pRemoto+"";
}
var process;
function cmdSSH(
			cmdTP,
			ssh_servidor, 
			ssh_porta,
			ssh_usuario, 
			ssh_senha, 
			tunnel
		){

	if(cmdTP == "iniciar"){
		ssh_sts_conectado = 1;
		tooltipDock("Conectado");
		iconeDock("on");
	}
	if(cmdTP == "encerrar"){
		ssh_sts_conectado = 0;
		tooltipDock("Desconectado");
		iconeDock("off");
	}
	
	var nativeProcessStartupInfo:NativeProcessStartupInfo = new NativeProcessStartupInfo(); 
	var file:File = File.applicationDirectory.resolvePath("C:\\Windows\\System32\\cmd.exe"); 
	nativeProcessStartupInfo.executable = file; 
	var processArgs:Vector.<String> = new Vector.<String>(); 
	
	var msgSSH = "";
	if(ssh_status == "true"){
		msgSSH = " -v ";
	}

	if(cmdTP == "iniciar"){
		processArgs.push('/c echo y | '+diretorioInstalacao+'\\ssh.exe '+msgSSH+' -N -x -a -T -C -noagent -ssh '+tunnel+' '+ssh_usuario+'@'+ssh_servidor+' -P '+ssh_porta+' -pw '+ssh_senha+'');
	}
	if(cmdTP == "encerrar"){
		processArgs.push("/c taskkill /f /IM ssh.exe");
	}
	
	
	nativeProcessStartupInfo.arguments = processArgs; 
	process = new NativeProcess(); 
	process.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, onStandardOutputData); 
	process.addEventListener(ProgressEvent.STANDARD_ERROR_DATA, onError);  
	process.start(nativeProcessStartupInfo);
	process.standardInput.writeUTFBytes(processArgs + "\n");
	
	
	
}

  function onStandardOutputData(event:ProgressEvent):void  
               {  
                    var process:NativeProcess = event.target as NativeProcess;  
                    var data:String = process.standardOutput.readUTFBytes(process.standardOutput.bytesAvailable);  
                  SSH_SAIDA.logs.text += (data);
               } 
function onError(event:ProgressEvent):void {  
                      
                    var process:NativeProcess = event.target as NativeProcess;  
                    var data:String = process.standardError.readUTFBytes(process.standardError.bytesAvailable);  
                    SSH_SAIDA.logs.text += (data);                  
                      
               }  


var currentInput:ByteArray;
var currentResult:ByteArray;
          
		 function  decrypt(vetorEtd, keyEtd, txtEtd) {
         
				if(keyEtd == ""){
					keyEtd = criptoKey;
				}
				
                var k:String = keyEtd;
                var kdata:ByteArray;
                var kformat:String = "text";
                switch (kformat) {
                    case "hex": kdata = Hex.toArray(k); break;
                    case "b64": kdata = Base64.decodeToByteArray(k); break;
                    default:
                        kdata = Hex.toArray(Hex.fromString(k));
                }
                // 3: get an output
                var txt:String = trim(txtEtd);
                var data:ByteArray;
                var format:String = "b64";
                switch (format) {
                    case "hex": data = Hex.toArray(txt); break;
                    case "b64": data = Base64.decodeToByteArray(txt); break;
                    default:
                        data = Hex.toArray(Hex.fromString(txt));
                }
                // 1: get an algorithm..
                var name:String = "aes-cbc";
                
                
                var pad:IPad = new PKCS5;
                var mode:ICipher = Crypto.getCipher(name, kdata, pad);
                pad.setBlockSize(mode.getBlockSize());
                // if an IV is there, set it.
                if (mode is IVMode) {
                    var ivmode:IVMode = mode as IVMode;
                    ivmode.IV = Hex.toArray(vetorEtd);
                }
                mode.decrypt(data);
                currentInput = data;
              
			  	return currentInput;
                
            }


function trim(s:String):String {
		return s ? s.replace(/^\s+|\s+$/gs, '') : "";
}


function importarArqExt(){ 

	fileRef = new FileReference(); 
	fileRef.addEventListener(Event.SELECT, onFileSelected); 
	
	fileRef.addEventListener(
		IOErrorEvent.IO_ERROR, 
			function ():void{
			alertarMsg("Erro de entrada.");
		}
	); 
	fileRef.addEventListener(
		SecurityErrorEvent.SECURITY_ERROR,
		function ():void{
			alertarMsg("Arquivo Inacessivel.");
		}
	);
	
	var textTypeFilter:FileFilter = new FileFilter("Projeto Dock (*.szd)", "*.szd;"); 
		fileRef.browse([textTypeFilter]); 
		
		fileRef.cancel();
} 
function onFileSelected(evt:Event):void{ 

	fileRef.addEventListener(
		Event.COMPLETE, 
			function (e:Event):void{
				
				var arqProj:XML = 
					new XML(fileRef.data);

					if(arqProj.proj[0] != "" && arqProj.proj[0].@id != ""){
						
						//senhaLembrada = arqProj.proj[0].@senha_lembrar;
						xmlArq = fileRef.data;
						
						LoadProjeto(xmlArq);
						
					} else {
						alertarMsg(
							"O arquivo selecionado esta "+
							"corrompido ou requer outra versão do software."
						);
					}
				
			}
		); 
	fileRef.load(); 
} 

function menuDock(btExbJan){

    var iconMenu = new NativeMenu(); 
	var menuMultiSSH:Array = new Array();
	
	//SUBMENU DAS CONEXOES
	var menu_child:NativeMenu = new NativeMenu();
	var abrirCommand 	= iconMenu.addItem(new NativeMenuItem("Abrir SzarcaDock"));

	if(stage.nativeWindow.visible == false){
		
			abrirCommand.checked = false; 
		 	abrirCommand.addEventListener(Event.SELECT,function(event){ 
           		janela(true);
				menuDock(2);
    		}); 
	}
	if(stage.nativeWindow.visible == true){
		
			abrirCommand.checked = true; 
			abrirCommand.addEventListener(Event.SELECT,function(event){ 
           		janela(false);
				menuDock(1);
    		}); 
	}
	
	var space0 = iconMenu.addItem(new NativeMenuItem("",true));
	
	var sshAbrirCom = iconMenu.addItem(new NativeMenuItem("Conectar (SSH)"));

	if(ssh == "true"){
		
		sshAbrirCom.enabled = true;

		
			
			for (var a:Number = 0; a < qtdSSHConn; a++){
	
				menuMultiSSH[a] = menu_child.addItem(new NativeMenuItem(array_titulo_ConnSSH[array_index_ConnSSH[a]]));
				menuMultiSSH[a].checked = false; 
				menuMultiSSH[a].name = a; 
				menuMultiSSH[a].addEventListener(Event.SELECT,function(e:Event){  
						
						connSelecionada = e.target.name;
						menuDock(1);
						
					});
					
			}
	//adiciona o submenu
	iconMenu.addSubmenu(menu_child, "Conexões Disponíveis (SSH)");
		
		if(ssh_sts_conectado == 1){
			
			//se estiver conectado, marca o checkbox e libera desconexao
			sshAbrirCom.checked = true; 
			sshAbrirCom.addEventListener(Event.SELECT,function(event){ 
										 
				cmdSSH("encerrar", false, false, false, false, false);
				menuDock(1);
				
			});
		
		} else {
			
			//se não estiver conectado, libera a conexao
			
			if(connSelecionada != undefined){
				sshAbrirCom.enabled = true; 
				menuMultiSSH[connSelecionada].checked = true; 
			} else {
				sshAbrirCom.enabled = false; 
			}
			
			
				sshAbrirCom.checked = false; 
				sshAbrirCom.addEventListener(Event.SELECT,function(event){  
					
					cmdSSH(
						 "iniciar",
						array_servidor_ConnSSH[array_index_ConnSSH[connSelecionada]], 
						array_porta_ConnSSH[array_index_ConnSSH[connSelecionada]],
						array_usuario_ConnSSH[array_index_ConnSSH[connSelecionada]], 
						array_senha_ConnSSH[array_index_ConnSSH[connSelecionada]], 
						array_tunel_ConnSSH[array_index_ConnSSH[connSelecionada]]
					);
					
					menuDock(1);
				}); 
			}
			
		
	} else {
		sshAbrirCom.enabled = false;
	}

	var spaceII = iconMenu.addItem(new NativeMenuItem("",true));
	
	var objCommand;
	
		if(titulo != ""){
			objCommand 	= iconMenu.addItem(new NativeMenuItem("Projeto <"+titulo+">"));
			objCommand.enabled = false;
		} else {
			objCommand 	= iconMenu.addItem(new NativeMenuItem("Carregar um Projeto no Repositorio..."));
			objCommand.addEventListener(Event.SELECT,function(event){ 
				janela(true);
			   importarArqExt();
			});
		}
	
	var spaceV = iconMenu.addItem(new NativeMenuItem("",true));
	
	var pastaCommand 	= iconMenu.addItem(new NativeMenuItem("Diretorio de Instalação"));
		pastaCommand.addEventListener(Event.SELECT,function(event){ 
           	cmdWindows('explorer C:\\Users\\%username%\\AppData\\Roaming\\szarca-dock\\Local Store"');
			
    	});
	
	
		
	var consoleCommand 	= iconMenu.addItem(new NativeMenuItem("Console"));
		consoleCommand.addEventListener(Event.SELECT,function(event){ 
           	janela(true);
			SSH_SAIDA.visible = true;
			LOGS.visible = false;
    	});
	
	var logCommand 	= iconMenu.addItem(new NativeMenuItem("Logs"));
		logCommand.addEventListener(Event.SELECT,function(event){ 
           	janela(true);
			SSH_SAIDA.visible = false;
			LOGS.visible = true;
			lLog();
    	});
	
	

	var spaceIII = iconMenu.addItem(new NativeMenuItem("",true));
	
	var ajudaCommand 	= iconMenu.addItem(new NativeMenuItem("Ajuda...")); 
   		ajudaCommand.addEventListener(Event.SELECT,function(event){ 
          	helpCmd();
   		});
		
	var sobreCommand 	= iconMenu.addItem(new NativeMenuItem("Sobre...")); 
   		sobreCommand.addEventListener(Event.SELECT,function(event){ 
           
		    var openPage:URLRequest=new URLRequest("http://anderakooken.com/?fn=about&id=szarca-dock&vs="+versao)
   				navigateToURL(openPage,"_blank");
	
   		});

	
	var spaceIV = iconMenu.addItem(new NativeMenuItem("",true));
	var exitCommand 	= iconMenu.addItem(new NativeMenuItem("Fechar")); 
   		exitCommand.addEventListener(Event.SELECT,function(event){ 
           encerrarSistema();
   		}); 

		 
	var dockMenu:SystemTrayIcon = NativeApplication.nativeApplication.icon as SystemTrayIcon;
		dockMenu.menu = iconMenu;
		dockMenu.addEventListener(ScreenMouseEvent.CLICK, function(event){ 
           		if(stage.nativeWindow.visible == false){
           			janela(true);
				} else {
					janela(false);
				}
    		});

	
}

function helpCmd(){
	var openPage:URLRequest=new URLRequest("http://anderakooken.com/?fn=help&id=szarca-dock&vs="+versao)
   		navigateToURL(openPage,"_blank");
}

function encerrarSistema(){
	cmdSSH("encerrar", false, false, false, false, false);
	NativeApplication.nativeApplication.exit(); 
}
function tooltipDock(sts){
	SystemTrayIcon(NativeApplication.nativeApplication.icon).tooltip = "SzarcaDock\r\nSSH Status: "+sts+"\r\nVersão: "+versao; 
}

function iniciarDock(stsToolTipIcon, stsJan, icone){
	
    NativeApplication.nativeApplication.autoExit = false; 

    if (NativeApplication.supportsSystemTrayIcon) { 
	
        NativeApplication.nativeApplication.autoExit = false;
		
		iconeDock(icone);
		menuDock(stsJan);
		tooltipDock(stsToolTipIcon);

    } 
}

function iconeDock(icone){
	
	var iconePng = "";
	if(icone == "off"){ iconePng = "logo16x16.png"; }
	if(icone == "on"){ iconePng = "logoDock16x16_ssh.png"; }
		  
	var iconLoadComplete = function(event){ 
       NativeApplication.nativeApplication.icon.bitmaps = [event.target.content.bitmapData]; 
    } 
    
	var iconLoad = new Loader(); 
     	iconLoad.contentLoaderInfo.addEventListener(Event.COMPLETE,iconLoadComplete); 
     	iconLoad.load(new URLRequest(iconePng)); 
}



var process_windows;
function cmdWindows(cmdTxt){

	var nativeProcessStartupInfo:NativeProcessStartupInfo = new NativeProcessStartupInfo(); 
	var file:File = File.applicationDirectory.resolvePath("C:\\Windows\\System32\\cmd.exe"); 
	nativeProcessStartupInfo.executable = file; 
	var processArgs:Vector.<String> = new Vector.<String>(); 
	
	
	processArgs.push('/c '+cmdTxt);
	
	
	nativeProcessStartupInfo.arguments = processArgs; 
	process_windows = new NativeProcess(); 
	process_windows.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, onStandardOutputDataCMD); 
	process_windows.addEventListener(ProgressEvent.STANDARD_ERROR_DATA, onErrorCMD);  
	process_windows.start(nativeProcessStartupInfo);
	process_windows.standardInput.writeUTFBytes(processArgs + "\n");

}
 
	

  function onStandardOutputDataCMD(event:ProgressEvent):void  
               {  
                    var process_windows:NativeProcess = event.target as NativeProcess;  
                    var data:String = process_windows.standardOutput.readUTFBytes(process_windows.standardOutput.bytesAvailable);  
                  trace(data);
               } 
function onErrorCMD(event:ProgressEvent):void {  
                      
                    var process_windows:NativeProcess = event.target as NativeProcess;  
                    var data:String = process_windows.standardError.readUTFBytes(process_windows.standardError.bytesAvailable);  
                   trace(data);                  
                      
               }