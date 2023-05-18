# wsl2-network
自定义wsl2 固定IP脚本

wsl2 是Windows 平台的子系统，在硬件比较好的情况下，开发体验还不错，但是wsl2 没有一个固定的IP地址，从外部也无法直接访问wsl2 的服务，所以做了这个么一个脚本，实现固定 IP 以及端口转发,
可以将
.bat 文件加入到windows 计划任务中，登录时以管理员模式启动。
.sh 文件是子系统的启动文件，需要复制到子系统中，并配置登录执行
配置文件 `/etc/wsl.conf`
``` bash
[boot]
# 此处为你的脚本路径
command = ~/_initial.sh
```
