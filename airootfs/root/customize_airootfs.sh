# 中文
sed -i 's/#zh_CN.UTF-8/zh_CN.UTF-8/' /etc/locale.gen
locale-gen

fc-cache -fv

## 创建输入法配置文件
mkdir -p /etc/xdg/autostart
cat > /etc/xdg/autostart/fcitx5.desktop <<EOF
[Desktop Entry]
Type=Application
Name=FCITX5
Exec=fcitx5 -d
EOF

## 设置全局环境变量
echo "GTK_IM_MODULE=fcitx
QT_IM_MODULE=fcitx
XMODIFIERS=@im=fcitx
SDL_IM_MODULE=fcitx
GLFW_IM_MODULE=ibus" >> /etc/environment

## 用户级配置
USER_HOME=/etc/skel
mkdir -p ${USER_HOME}/.config/fcitx5/conf
cat > ${USER_HOME}/.config/fcitx5/profile <<EOF
[Profile]
IMName=fcitx5
IMDisplayName=FCITX5
DefaultIM=pinyin
EOF

cat > ${USER_HOME}/.config/fcitx5/conf/pinyin.conf <<EOF
[Pinyin]
InitialPromptTimeout=500
PageSize=7
ShowPrediction=True
EOF

cat > ${USER_HOME}/.config/fcitx5/conf/classicui.conf <<EOF
# 字体
Font="Noto Sans CJK SC 12"
# 菜单字体
MenuFont="Noto Sans CJK SC 12"
# 托盘字体
TrayFont="Noto Sans CJK SC 12"
EOF

cat > ${USER_HOME}/.config/kdeglobals <<EOF
[General]
fixed=JetBrains Mono,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1
font=Noto Sans CJK SC,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1
menuFont=Noto Sans CJK SC,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1
smallestReadableFont=Noto Sans CJK SC,8,-1,5,400,0,0,0,0,0,0,0,0,0,0,1
toolBarFont=Noto Sans CJK SC,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1

[WM]
activeFont=Noto Sans CJK SC,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1
EOF

# sddm
mkdir -p /etc/sddm.conf.d
echo "[Autologin]
User=samuel
Session=plasma" > /etc/sddm.conf.d/autologin.conf

echo "[Theme]
Current=breeze" > /etc/sddm.conf.d/breeze.conf

# 桌面环境
mkdir -p /etc/skel/Desktop
cat > /etc/skel/Desktop/install.desktop << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=安装 Samuel OS
Exec=sudo calamares
Icon=system-installer
Categories=System;
Comment=将 Samuel OS 安装到您的计算机
EOF

# 设置文件权限
chmod +x /etc/skel/Desktop/install.desktop

# 默认用户
useradd -m -G wheel -s /usr/bin/zsh samuel
echo "samuel:samuel" | chpasswd
echo "samuel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# 服务自启
mkdir -p /etc/systemd/system/getty@tty1.service.d
echo "[Service]
ExecStart=
ExecStart=-/usr/bin/agetty --autologin samuel --noclear %I \$TERM" > /etc/systemd/system/getty@tty1.service.d/autologin.conf

systemctl enable sddm
systemctl enable NetworkManager
systemctl enable bluetooth
