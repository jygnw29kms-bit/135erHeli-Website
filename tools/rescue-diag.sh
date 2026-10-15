#!/usr/bin/env bash
set -u

echo '=== 135erHeli Rescue Diagnose ==='
date || true
echo

echo '--- ID / HOST / OS ---'
id || true
hostname || true
cat /etc/os-release 2>/dev/null || true
ps -p 1 -o pid,comm,args 2>/dev/null || true
echo

echo '--- ROOT / DISKS ---'
findmnt / 2>/dev/null || true
lsblk -f 2>/dev/null || true
blkid 2>/dev/null || true
echo

echo '--- NETWORK ---'
ip a 2>/dev/null || true
ip route 2>/dev/null || true
ss -lntup 2>/dev/null | sed -n '1,80p' || true
echo

echo '--- SSH ---'
systemctl status ssh --no-pager -l 2>/dev/null || systemctl status sshd --no-pager -l 2>/dev/null || true
systemctl is-enabled ssh 2>/dev/null || systemctl is-enabled sshd 2>/dev/null || true
echo

echo '--- NGINX ---'
systemctl status nginx --no-pager -l 2>/dev/null || true
nginx -t 2>&1 || true
echo

echo '--- PLESK ---'
systemctl status sw-cp-server --no-pager -l 2>/dev/null || true
plesk version 2>/dev/null || true
plesk bin site --info 135erheli.de 2>/dev/null || true
echo

echo '--- FIREWALL ---'
command -v nft >/dev/null && nft list ruleset 2>/dev/null | sed -n '1,220p' || true
command -v iptables >/dev/null && iptables -S 2>/dev/null | sed -n '1,160p' || true
command -v ufw >/dev/null && ufw status verbose 2>/dev/null || true
echo

echo '--- WEBROOT ---'
ls -ld /var/www/vhosts/135erheli.de 2>/dev/null || true
ls -la /var/www/vhosts/135erheli.de/httpdocs 2>/dev/null | sed -n '1,40p' || true
echo

echo '=== ENDE ==='
