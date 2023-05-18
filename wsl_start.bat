if "%1"=="hide" goto CmdBegin
  start mshta vbscript:createobject("wscript.shell").run("""%~0"" hide",0)(window.close)&&exit
:CmdBegin

@echo off
setlocal enabledelayedexpansion

::config
set wsl_ip=192.168.12.18
set win_ip=192.168.12.10
set broadcast=192.168.12.0

set ports=3000 3001 80 8080 8888 8889 8000 8001 8002 8081 3306 3305 1935 11372 11373 11374 11375 11376 11379 11253 1420
set log_file=E:\code\scripts\_log.txt

echo --%date% %time% >%log_file%

wsl --shutdown ubuntu

::set network
if !errorlevel! equ 0 (
  wsl -u root ip addr | findstr %wsl_ip% > nul
  if !errorlevel! equ 0 (
    echo wsl ip has set >>%log_file%
  ) else (
    wsl -u root ip addr add %wsl_ip%/24 broadcast %broadcast% dev eth0 label eth0:custom
    echo wsl ip set success >>%log_file%
  )

  ipconfig | findstr %win_ip% > nul
  if !errorlevel! equ 0 (
    echo windows ip has set >>%log_file%
  ) else (
    netsh interface ip add address "vEthernet (WSL)" %win_ip% 255.255.255.0 >>%log_file%
    echo windows ip set success >>%log_file%
  )
)

::set portproxy
echo start set wsl proxy >>%log_file%
netsh interface portproxy reset

(for %%i in (%ports%) do (
  netsh interface portproxy add v4tov4 listenaddress=0.0.0.0 listenport=%%i connectaddress=%wsl_ip% connectport=%%i
))

netsh interface portproxy show v4tov4 >>%log_file%

wsl --shutdown ubuntu

::pause