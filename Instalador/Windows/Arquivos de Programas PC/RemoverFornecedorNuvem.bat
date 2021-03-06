cls
@echo off

REM Windows, por default, usa o charset WINDOWS-1252 (ou outra varia��o, dependendo da lingua), 
REM que � uma extens�o do ISO-8859-1. 
REM Mesmo assim, n�o se compara com UTF-8! O Linux, por default, usa o charset UTF-8. 
REM Eclipse herda o charset de Windows por default. 
REM "chcp 1252>nul" � necess�rio para evitar que DOS n�o reconhece acentos Portugueses no caminho 
REM "Integra��o Fornecedor - Portal Cronos" em alguns ou talvez at� em todos os servidores:

chcp 1252>nul

cd\
cd "Arquivos de Programas PC"

call "Integra��o Fornecedor - Portal Cronos\bin\VerificarUsuarioAdministrador.bat"


echo      =================================================
echo    ^| TELA PROVISORIA PARA EXCLUSAO DE INSTANCIA NOVA ^|
echo    ^| DO INTEGRADOR PCRONOS - APS CLOUD               ^|
echo      =================================================
echo. 
REM :PerguntaTemCerteza
REM echo.
REM echo.
REM echo Tem certeza que deseja remover a inst�ncia de um cliente?
REM echo.
REM echo IMPORTANTE: � recomend�vel primeiro fazer backup das configura�oes do cliente!
REM echo.
REM 
REM SET /P temCerteza=Digite S (=Sim) ou N (=Nao) + a tecla ^<Enter^>:  
REM IF "%temCerteza%"=="" GOTO ErroTemCerteza
REM if "%temCerteza%"=="S" (
REM     GOTO PularErroTemCerteza
REM ) else if "%temCerteza%"=="s" (
REM     GOTO PularErroTemCerteza
REM ) else (
REM REM Fechar o script chamador tamb�m: 
REM    exit
REM )
REM :ErroTemCerteza
REM echo MSGBOX "Erro: confirma��o n�o informada! Remo��o de nenhuma inst�ncia efetuada!" > %temp%\TEMPmessage.vbs
REM call %temp%\TEMPmessage.vbs
REM del %temp%\TEMPmessage.vbs /f /q
REM cls
REM goto PerguntaTemCerteza
REM :PularErroTemCerteza

REM cls

:PerguntaNmFornecedor
echo.
echo Nome fantasia da empresa cliente a ser excluida
echo (para evitar exclus�o da inst�ncia errada):
echo.
SET /P nmFornecedor=Digite o nome fantasia ou C (= Cancelar), e em seguida clique na tecla ^<Enter^>: 
IF "%nmFornecedor%"=="C" exit
IF "%nmFornecedor%"=="c" exit
IF "%nmFornecedor%"=="" GOTO ErroNmFornecedor
if not "%nmFornecedor%"=="%nmFornecedor: =%" goto ErroEspacosNmFornecedor
GOTO PularErroNmFornecedor
:ErroEspacosNmFornecedor
echo MSGBOX "Erro: n�o pode ter nenhum espa�o em branco no nome! Remo��o da inst�ncia n�o efetuada!" > %temp%\TEMPmessage.vbs
call %temp%\TEMPmessage.vbs
del %temp%\TEMPmessage.vbs /f /q
REM SET /P doesn't change the content of a variable, if the user doesn't enter text:
SET "nmFornecedor="
cls
goto PerguntaNmFornecedor
:ErroNmFornecedor
echo MSGBOX "Erro: nome n�o informado! Remo��o da inst�ncia n�o efetuada!" > %temp%\TEMPmessage.vbs
call %temp%\TEMPmessage.vbs
del %temp%\TEMPmessage.vbs /f /q
cls
goto PerguntaNmFornecedor
:PularErroNmFornecedor



REM set ClienteExiste=0
REM for /f "tokens=2 delims=\" %%x in ('SCHTASKS /QUERY /FO:LIST ^| FINDSTR "Integra��o Portal Cronos - %nmFornecedor%"') do set ClienteExiste=1
REM if %ClienteExiste% == 0 (
REM     echo.
REM     echo          Nome inv�lido!
REM     echo.
REM     
REM     echo MSGBOX "Nome inv�lido!" > %temp%\TEMPmessage.vbs
REM     call %temp%\TEMPmessage.vbs
REM     del %temp%\TEMPmessage.vbs /f /q
REM     exit
REM )


if not exist "C:/Arquivos de Programas PC/Integra��o Fornecedor - Portal Cronos/conf/Integra��o APS - Portal Cronos.%nmFornecedor%.properties" (
    echo.
    echo          Nome inv�lido!
    echo.
    
    echo MSGBOX "Nome inv�lido!" > %temp%\TEMPmessage.vbs
    call %temp%\TEMPmessage.vbs
    del %temp%\TEMPmessage.vbs /f /q
    exit
)


REM Remover as coisas na seguinte ordem:
REM  1. primeiro remover o Task Schedule,
REM  2. em seguida remover a entrada no menu de Windows,
REM  3. no final remover o arquivo de configura��o .properties: 


SCHTASKS /End /TN "Integra��o Portal Cronos - %nmFornecedor%"
SCHTASKS /Delete /TN "Integra��o Portal Cronos - %nmFornecedor%" /F



cd\
cd "Arquivos de Programas PC"
call "Integra��o Fornecedor - Portal Cronos\bin\Inicializacoes.bat"
call "Integra��o Fornecedor - Portal Cronos\bin\Versao.bat"
call "Integra��o Fornecedor - Portal Cronos\bin\CaminhoJRE.bat" RemovedorFornecedorNuvem.log RemovedorFornecedorNuvem %nmFornecedor%

set arquivoLog="RemovedorFornecedorNuvem.log"
set tamanhoArqLog=0

FOR /F "usebackq" %%A IN ('%arquivoLog%') DO set tamanhoArqLog=%%~zA

if %tamanhoArqLog% GTR 0 (
    echo.
    echo          A remo�ao da inst�ncia falhou!
    echo.
    
    echo MSGBOX "A remo��o da inst�ncia falhou!" > %temp%\TEMPmessage.vbs
    call %temp%\TEMPmessage.vbs
    del %temp%\TEMPmessage.vbs /f /q
    start notepad RemovedorFornecedorNuvem.log
) else (
  if exist RemovedorFornecedorNuvem.log del /f /q RemovedorFornecedorNuvem.log 
  cd\
  cd "Arquivos de Programas PC"
  cd "Integra��o Fornecedor - Portal Cronos"
  cd conf
  del /f /q "Integra��o APS - Portal Cronos.%nmFornecedor%.properties"

REM Esperar 2 minutos para o caso que tem um processo de java.exe rodando neste momento,
REM para evitar o seguinte erro: 
REM "Job15a15min.%nmFornecedor%.log - The process cannot access the file because it is being used by another process."

  cls
  echo.
  echo.
  echo Esperando 2 minutos para o processamento atual do Integrador terminar....... 
  echo Favor n�o fechar esta tela preta!!
  echo.
  timeout /T 120 /nobreak > NUL
  
  if exist Job15a15min.%nmFornecedor%.log del /f /q Job15a15min.%nmFornecedor%.log
)


REM /B para n�o fechar poss�veis scripts chamadores no futuro:  
exit /B 0


:FIM
