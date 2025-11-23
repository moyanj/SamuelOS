# 中文
sed -i 's/#zh_CN.UTF-8/zh_CN.UTF-8/' /etc/locale.gen
locale-gen

# 默认用户
useradd -m -G wheel -s /usr/bin/zsh samuel

echo "samuel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# sddm
mkdir -p /etc/sddm.conf.d
echo "[Autologin]
User=samuel
Session=plasma" > /etc/sddm.conf.d/autologin.conf

echo "[Theme]
Current=breeze" > /etc/sddm.conf.d/breeze.conf

# 服务自启
mkdir -p /etc/systemd/system/getty@tty1.service.d
echo "[Service]
ExecStart=
ExecStart=-/usr/bin/agetty --autologin samuel --noclear %I \$TERM" > /etc/systemd/system/getty@tty1.service.d/override.conf

systemctl enable sddm
systemctl enable NetworkManager
systemctl enable bluetooth

ln -s /usr/lib/systemd/system/sddm.service /etc/systemd/system/display-manager.service

# 桌面环境
mkdir -p /etc/skel/Desktop
cat > /etc/skel/Desktop/install.desktop << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Install Samuel OS
Exec=calamares
Icon=system-installer
Categories=System;
Comment=Install Samuel OS to your computer
EOF

# 设置文件权限
chmod +x /etc/skel/Desktop/install.desktop