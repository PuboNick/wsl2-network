@echo off
setlocal enabledelayedexpansion

:: 关闭子系统
wsl --shutdown ubuntu

:: WSL 子系统 IP
set wsl_ip=192.168.12.18
:: 网段
set broadcast=192.168.12.0
:: Windows 主机IP
set win_ip=192.168.12.10

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
pause
