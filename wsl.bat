if "%1"=="hide" goto CmdBegin
  start mshta vbscript:createobject("wscript.shell").run("""%~0"" hide",0)(window.close)&&exit
:CmdBegin

@echo off
setlocal enabledelayedexpansion

wsl --shutdown ubuntu

::config
set wsl_ip=192.168.12.18
set broadcast=192.168.12.0
set win_ip=192.168.12.10
set ports=3000 8080 8888 8889 80 3306 3001 11373 8001 8002 8081

::set network
if !errorlevel! equ 0 (
  wsl -u root ip addr | findstr %wsl_ip% > nul
  if !errorlevel! equ 0 (
    echo wsl ip has set
  ) else (
    wsl -u root ip addr add %wsl_ip%/24 broadcast %broadcast% dev eth0 label eth0:custom
    echo wsl ip set success
  )

  ipconfig | findstr %win_ip% > nul
  if !errorlevel! equ 0 (
    echo windows ip has set
  ) else (
    netsh interface ip add address "vEthernet (WSL)" %win_ip% 255.255.255.0
    echo windows ip set success
  )
)

::set portproxy
echo start set proxy, %date% >E:\code\bat\_log.txt
netsh interface portproxy reset

(for %%i in (%ports%) do (
  echo port %%i >>E:\code\bat\_log.txt
  netsh interface portproxy add v4tov4 listenaddress=0.0.0.0 listenport=%%i connectaddress=%wsl_ip% connectport=%%i
))

::pause