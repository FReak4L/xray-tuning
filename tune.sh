#!/bin/bash

# Color Messages
green_msg() {
  tput setaf 2
  echo "[*] ----- $1"
  tput sgr0
}

yellow_msg() {
  tput setaf 3
  echo "[*] ----- $1"
  tput sgr0
}

red_msg() {
  tput setaf 1
  echo "[*] ----- $1"
  tput sgr0
}

blue_msg() {
  tput setaf 4
  echo "[*] ----- $1"
  tput sgr0
}

purple_msg() {
  tput setaf 5
  echo "[*] ----- $1"
  tput sgr0
}

cyan_msg() {
  tput setaf 6
  echo "[*] ----- $1"
  tput sgr0
}

SYS_PATH="/etc/sysctl.conf"
PROF_PATH="/etc/profile"
SSH_PATH="/etc/ssh/sshd_config"
SWAP_PATH="/swapfile"
SWAP_SIZE=4G

if [[ "$EUID" -ne '0' ]]; then
  echo
  red_msg 'Error: You must run this script as root!'
  echo
  exit 1
fi

clear
echo
green_msg '================================================================='
green_msg 'Advanced Xray-Core & VPN Server Optimizer'
yellow_msg 'Optimized for maximum performance and connection handling'
blue_msg 'Visit @NotePadVPN on Telegram for more tools'
green_msg '================================================================='
echo
sleep 1

yellow_msg 'Updating system...'
apt -q update
apt -y upgrade
apt -y full-upgrade
apt -y autoremove
apt -y -q autoclean
apt -y clean
apt -q update
apt -y upgrade
apt -y full-upgrade
apt -y autoremove --purge
green_msg 'System updated successfully'

yellow_msg 'Disabling terminal ads...'
sed -i 's/ENABLED=1/ENABLED=0/g' /etc/default/motd-news
if command -v pro >/dev/null 2>&1; then
  pro config set apt_news=false
fi
green_msg 'Terminal ads disabled'

yellow_msg 'Installing XanMod kernel...'
if uname -r | grep -q 'xanmod'; then
  green_msg 'XanMod kernel is already installed'
else
  apt update -q
  apt upgrade -y
  apt install wget curl gpg -y
  
  cpu_level=$(awk -f <(cat - <<'EOF'
/^flags/ {
  if (/avx2/) level=4;
  else if (/avx/) level=3;
  else if (/sse4_2/) level=2;
  else level=1;
  print level;
  exit level + 1;
}
EOF
) /proc/cpuinfo)
  
  if [ "$cpu_level" -ge 1 ] && [ "$cpu_level" -le 4 ]; then
    yellow_msg "CPU Level: v$cpu_level"
    tmp_keyring="/tmp/xanmod-archive-keyring.gpg"
    wget -qO $tmp_keyring https://dl.xanmod.org/archive.key || wget -qO $tmp_keyring https://gitlab.com/afrd.gpg
    
    gpg --dearmor -o /usr/share/keyrings/xanmod-archive-keyring.gpg $tmp_keyring
    rm -f $tmp_keyring
    
    echo 'deb [signed-by=/usr/share/keyrings/xanmod-archive-keyring.gpg] http://deb.xanmod.org releases main' | tee /etc/apt/sources.list.d/xanmod-release.list
    
    apt update -q
    apt install "linux-xanmod-x64v$cpu_level" -y
    apt update -q
    apt autoremove --purge -y
    green_msg "XanMod Kernel installed successfully - @NotePadVPN"
  else
    red_msg "Unsupported CPU. Visit @NotePadVPN for alternative solutions."
  fi
fi

yellow_msg 'Installing essential packages for Xray-Core performance...'
apt -y install apt-transport-https apt-utils bash-completion busybox ca-certificates cron curl gnupg2 locales lsb-release nano preload screen software-properties-common ufw unzip vim wget xxd zip autoconf automake bash-completion build-essential git libtool make pkg-config python3 python3-pip bc binutils binutils-common binutils-x86-64-linux-gnu ubuntu-keyring haveged jq libsodium-dev libsqlite3-dev libssl-dev packagekit qrencode socat dialog htop net-tools mtr nload iftop
green_msg 'Essential packages installed successfully'

yellow_msg 'Enabling services at boot...'
systemctl enable cron haveged preload
green_msg 'Services enabled successfully'

yellow_msg 'Creating optimized SWAP space...'
fallocate -l $SWAP_SIZE $SWAP_PATH
chmod 600 $SWAP_PATH
mkswap $SWAP_PATH
swapon $SWAP_PATH
echo "$SWAP_PATH none swap sw 0 0" >> /etc/fstab
green_msg 'SWAP created successfully'

yellow_msg 'Optimizing system for Xray-Core & VPN performance...'
cp $SYS_PATH /etc/sysctl.conf.bak
yellow_msg 'Backup saved to /etc/sysctl.conf.bak'

sed -i -e '/fs.file-max/d' \
  -e '/fs.nr_open/d' \
  -e '/fs.inotify.max_user_watches/d' \
  -e '/fs.inotify.max_user_instances/d' \
  -e '/net.core.default_qdisc/d' \
  -e '/net.core.netdev_max_backlog/d' \
  -e '/net.core.optmem_max/d' \
  -e '/net.core.somaxconn/d' \
  -e '/net.core.rmem_max/d' \
  -e '/net.core.wmem_max/d' \
  -e '/net.core.rmem_default/d' \
  -e '/net.core.wmem_default/d' \
  -e '/net.ipv4.tcp_rmem/d' \
  -e '/net.ipv4.tcp_wmem/d' \
  -e '/net.ipv4.tcp_congestion_control/d' \
  -e '/net.ipv4.tcp_fastopen/d' \
  -e '/net.ipv4.tcp_fin_timeout/d' \
  -e '/net.ipv4.tcp_keepalive_time/d' \
  -e '/net.ipv4.tcp_keepalive_probes/d' \
  -e '/net.ipv4.tcp_keepalive_intvl/d' \
  -e '/net.ipv4.tcp_max_orphans/d' \
  -e '/net.ipv4.tcp_max_syn_backlog/d' \
  -e '/net.ipv4.tcp_max_tw_buckets/d' \
  -e '/net.ipv4.tcp_mem/d' \
  -e '/net.ipv4.tcp_mtu_probing/d' \
  -e '/net.ipv4.tcp_notsent_lowat/d' \
  -e '/net.ipv4.tcp_retries2/d' \
  -e '/net.ipv4.tcp_sack/d' \
  -e '/net.ipv4.tcp_dsack/d' \
  -e '/net.ipv4.tcp_slow_start_after_idle/d' \
  -e '/net.ipv4.tcp_window_scaling/d' \
  -e '/net.ipv4.tcp_adv_win_scale/d' \
  -e '/net.ipv4.tcp_ecn/d' \
  -e '/net.ipv4.tcp_ecn_fallback/d' \
  -e '/net.ipv4.tcp_syncookies/d' \
  -e '/net.ipv4.udp_mem/d' \
  -e '/net.ipv6.conf.all.disable_ipv6/d' \
  -e '/net.ipv6.conf.default.disable_ipv6/d' \
  -e '/net.ipv6.conf.lo.disable_ipv6/d' \
  -e '/net.unix.max_dgram_qlen/d' \
  -e '/vm.min_free_kbytes/d' \
  -e '/vm.swappiness/d' \
  -e '/vm.vfs_cache_pressure/d' \
  -e '/net.ipv4.conf.default.rp_filter/d' \
  -e '/net.ipv4.conf.all.rp_filter/d' \
  -e '/net.ipv4.conf.all.accept_source_route/d' \
  -e '/net.ipv4.conf.default.accept_source_route/d' \
  -e '/net.ipv4.neigh.default.gc_thresh1/d' \
  -e '/net.ipv4.neigh.default.gc_thresh2/d' \
  -e '/net.ipv4.neigh.default.gc_thresh3/d' \
  -e '/net.ipv4.neigh.default.gc_stale_time/d' \
  -e '/net.ipv4.conf.default.arp_announce/d' \
  -e '/net.ipv4.conf.lo.arp_announce/d' \
  -e '/net.ipv4.conf.all.arp_announce/d' \
  -e '/kernel.panic/d' \
  -e '/vm.dirty_ratio/d' \
  -e '/vm.overcommit_memory/d' \
  -e '/vm.overcommit_ratio/d' \
  -e '/net.ipv4.tcp_autocorking/d' \
  -e '/net.ipv4.tcp_defer_accept/d' \
  -e '/net.ipv4.tcp_timestamps/d' \
  -e '/net.ipv4.tcp_notsent_lowat/d' \
  -e '/net.ipv4.tcp_frto/d' \
  -e '/net.ipv4.ip_local_port_range/d' \
  -e '/net.ipv4.tcp_rfc1337/d' \
  -e '/net.ipv4.tcp_tw_reuse/d' \
  -e '/net.ipv4.tcp_low_latency/d' \
  -e '/net.ipv4.tcp_delack_min/d' \
  -e '/net.ipv4.tcp_thin_linear_timeouts/d' \
  -e '/net.ipv4.ip_forward/d' \
  -e '/net.ipv4.udp_l3mdev_accept/d' \
  -e '/net.ipv4.tcp_l3mdev_accept/d' \
  -e '/kernel.shmmax/d' \
  -e '/kernel.shmall/d' \
  -e '/kernel.shmmni/d' \
  -e '/kernel.sem/d' \
  -e '/kernel.msgmni/d' \
  -e '/kernel.msgmax/d' \
  -e '/kernel.msgmnb/d' \
  -e '/net.ipv4.tcp_mtu_probing/d' \
  -e '/net.ipv4.tcp_base_mss/d' \
  -e '/net.ipv4.tcp_probe_interval/d' \
  -e '/net.ipv4.tcp_probe_threshold/d' \
  -e '/net.ipv4.tcp_synack_retries/d' \
  -e '/net.ipv4.tcp_syn_retries/d' \
  -e '/vm.dirty_background_ratio/d' \
  -e '/vm.dirty_expire_centisecs/d' \
  -e '/vm.dirty_writeback_centisecs/d' \
  -e '/kernel.numa_balancing/d' \
  -e '/kernel.sched_min_granularity_ns/d' \
  -e '/kernel.sched_wakeup_granularity_ns/d' \
  -e '/kernel.sched_migration_cost_ns/d' \
  -e '/kernel.sched_autogroup_enabled/d' \
  -e '/^#/d' \
  -e '/^$/d' \
  "$SYS_PATH"
  
cat << 'EOF' > "$SYS_PATH"
################################################################
#          Advanced Network Optimization for Xray-Core          #
#               Visit @NotePadVPN for more tools                #
################################################################

# File system limits - Critical for high concurrent connections
fs.file-max = 268435456
fs.nr_open = 134217728
fs.inotify.max_user_watches = 1048576
fs.inotify.max_user_instances = 16384

# Network core optimization
net.core.default_qdisc = fq_codel
net.core.netdev_max_backlog = 262144
net.core.optmem_max = 4194304
net.core.somaxconn = 131072
net.core.rmem_max = 134217728
net.core.wmem_max = 134217728
net.core.rmem_default = 4194304
net.core.wmem_default = 4194304

# TCP optimization for Xray-Core and VPN services
net.ipv4.tcp_rmem = 32768 4194304 134217728
net.ipv4.tcp_wmem = 32768 4194304 134217728
net.ipv4.tcp_congestion_control = bbr
net.ipv4.tcp_fastopen = 3
net.ipv4.tcp_fin_timeout = 10
net.ipv4.tcp_keepalive_time = 120
net.ipv4.tcp_keepalive_probes = 15
net.ipv4.tcp_keepalive_intvl = 10
net.ipv4.tcp_max_orphans = 4194304
net.ipv4.tcp_max_syn_backlog = 65536
net.ipv4.tcp_max_tw_buckets = 16777216
net.ipv4.tcp_mem = 786432 4194304 33554432
net.ipv4.tcp_mtu_probing = 1
net.ipv4.tcp_notsent_lowat = 4096
net.ipv4.tcp_retries2 = 5
net.ipv4.tcp_sack = 1
net.ipv4.tcp_dsack = 1
net.ipv4.tcp_slow_start_after_idle = 0
net.ipv4.tcp_window_scaling = 1
net.ipv4.tcp_adv_win_scale = -2
net.ipv4.tcp_ecn = 1
net.ipv4.tcp_ecn_fallback = 1
net.ipv4.tcp_syncookies = 1
net.ipv4.ip_local_port_range = 1024 65535
net.ipv4.tcp_rfc1337 = 1
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_low_latency = 1
net.ipv4.tcp_delack_min = 5
net.ipv4.tcp_thin_linear_timeouts = 1
net.ipv4.tcp_defer_accept = 5
net.ipv4.tcp_timestamps = 0
net.ipv4.tcp_autocorking = 0
net.ipv4.tcp_frto = 1
net.ipv4.tcp_synack_retries = 2
net.ipv4.tcp_syn_retries = 2
net.ipv4.tcp_base_mss = 1024

# UDP optimization - essential for QUIC and UDP-based protocols in Xray
net.ipv4.udp_mem = 786432 4194304 33554432

# IPv6 settings
net.ipv6.conf.all.disable_ipv6 = 0
net.ipv6.conf.default.disable_ipv6 = 0
net.ipv6.conf.lo.disable_ipv6 = 0
net.ipv6.conf.all.forwarding = 1

# Unix socket optimization
net.unix.max_dgram_qlen = 1024

# Virtual memory optimization
vm.min_free_kbytes = 524288
vm.swappiness = 5
vm.vfs_cache_pressure = 150
vm.dirty_ratio = 10
vm.dirty_background_ratio = 3
vm.dirty_expire_centisecs = 1000
vm.dirty_writeback_centisecs = 300
vm.overcommit_memory = 0
vm.overcommit_ratio = 50

# Network security and routing settings
net.ipv4.conf.default.rp_filter = 2
net.ipv4.conf.all.rp_filter = 2
net.ipv4.conf.all.accept_source_route = 0
net.ipv4.conf.default.accept_source_route = 0
net.ipv4.neigh.default.gc_thresh1 = 8192
net.ipv4.neigh.default.gc_thresh2 = 16384
net.ipv4.neigh.default.gc_thresh3 = 32768
net.ipv4.neigh.default.gc_stale_time = 60
net.ipv4.conf.default.arp_announce = 2
net.ipv4.conf.lo.arp_announce = 2
net.ipv4.conf.all.arp_announce = 2
net.ipv4.ip_forward = 1
net.ipv4.udp_l3mdev_accept = 1
net.ipv4.tcp_l3mdev_accept = 1

# Kernel optimization
kernel.panic = 5
kernel.sched_min_granularity_ns = 10000000
kernel.sched_wakeup_granularity_ns = 15000000
kernel.sched_migration_cost_ns = 5000000
kernel.sched_autogroup_enabled = 0
kernel.numa_balancing = 0
kernel.shmmax = 137438953472
kernel.shmall = 8589934592
kernel.shmmni = 32768
kernel.sem = 500 64000 200 2048
kernel.msgmni = 65536
kernel.msgmax = 131072
kernel.msgmnb = 131072
EOF

sysctl -p
purple_msg 'Network optimization complete - Xray-Core ready for high performance'

yellow_msg 'Optimizing SSH...'
cp $SSH_PATH /etc/ssh/sshd_config.bak
yellow_msg 'SSH config backup saved to /etc/ssh/sshd_config.bak'

sed -i -e 's/#UseDNS yes/UseDNS no/' \
  -e 's/#Compression no/Compression yes/' \
  -e 's/Ciphers .*/Ciphers aes256-ctr,chacha20-poly1305@openssh.com/' \
  -e '/MaxAuthTries/d' \
  -e '/MaxSessions/d' \
  -e '/TCPKeepAlive/d' \
  -e '/ClientAliveInterval/d' \
  -e '/ClientAliveCountMax/d' \
  -e '/AllowAgentForwarding/d' \
  -e '/AllowTcpForwarding/d' \
  -e '/GatewayPorts/d' \
  -e '/PermitTunnel/d' \
  -e '/X11Forwarding/d' "$SSH_PATH"

echo "MaxAuthTries 10" | tee -a "$SSH_PATH"
echo "MaxSessions 100" | tee -a "$SSH_PATH"
echo "TCPKeepAlive yes" | tee -a "$SSH_PATH"
echo "ClientAliveInterval 3000" | tee -a "$SSH_PATH"
echo "ClientAliveCountMax 100" | tee -a "$SSH_PATH"
echo "AllowAgentForwarding yes" | tee -a "$SSH_PATH"
echo "AllowTcpForwarding yes" | tee -a "$SSH_PATH"
echo "GatewayPorts yes" | tee -a "$SSH_PATH"
echo "PermitTunnel yes" | tee -a "$SSH_PATH"
echo "X11Forwarding yes" | tee -a "$SSH_PATH"

systemctl restart ssh
green_msg 'SSH optimized for better connections'

yellow_msg 'Optimizing system limits for Xray-Core high concurrent connections...'
sed -i '/ulimit -c/d' $PROF_PATH
sed -i '/ulimit -d/d' $PROF_PATH
sed -i '/ulimit -f/d' $PROF_PATH
sed -i '/ulimit -i/d' $PROF_PATH
sed -i '/ulimit -l/d' $PROF_PATH
sed -i '/ulimit -m/d' $PROF_PATH
sed -i '/ulimit -n/d' $PROF_PATH
sed -i '/ulimit -q/d' $PROF_PATH
sed -i '/ulimit -s/d' $PROF_PATH
sed -i '/ulimit -t/d' $PROF_PATH
sed -i '/ulimit -u/d' $PROF_PATH
sed -i '/ulimit -v/d' $PROF_PATH
sed -i '/ulimit -x/d' $PROF_PATH

echo "ulimit -c unlimited" | tee -a $PROF_PATH
echo "ulimit -d unlimited" | tee -a $PROF_PATH
echo "ulimit -f unlimited" | tee -a $PROF_PATH
echo "ulimit -i unlimited" | tee -a $PROF_PATH
echo "ulimit -l unlimited" | tee -a $PROF_PATH
echo "ulimit -m unlimited" | tee -a $PROF_PATH
echo "ulimit -n 1048576" | tee -a $PROF_PATH
echo "ulimit -q unlimited" | tee -a $PROF_PATH
echo "ulimit -s -H 65536" | tee -a $PROF_PATH
echo "ulimit -s 32768" | tee -a $PROF_PATH
echo "ulimit -t unlimited" | tee -a $PROF_PATH
echo "ulimit -u unlimited" | tee -a $PROF_PATH
echo "ulimit -v unlimited" | tee -a $PROF_PATH
echo "ulimit -x unlimited" | tee -a $PROF_PATH
cyan_msg 'System limits optimized for maximum connections'

yellow_msg 'Setting up firewall...'
apt -y purge firewalld
apt update -q
apt install -y ufw
ufw disable

SSH_PORT=$(grep -oP '^Port\s+\K\d+' "$SSH_PATH" 2>/dev/null)
if [ -z "$SSH_PORT" ]; then
  SSH_PORT=22
fi

ufw allow $SSH_PORT
ufw allow 80/tcp
ufw allow 80/udp
ufw allow 443/tcp
ufw allow 443/udp

sed -i 's+/etc/ufw/sysctl.conf+/etc/sysctl.conf+gI' /etc/default/ufw
echo "y" | ufw enable
ufw reload
green_msg 'Firewall configured for common VPN ports'

echo
green_msg '================================================================='
green_msg 'Server optimization complete!'
yellow_msg '- Maximum concurrent connections'
yellow_msg '- Optimized network stack for VPN services'
blue_msg '@NotePadVPN - Visit our Telegram channel for more tools and tips!'
purple_msg 'Rebooting is recommended to apply all changes properly'
green_msg '================================================================='
echo

yellow_msg 'Would you like to reboot now? (Recommended) (y/n)'
read choice
if [[ "$choice" == 'y' || "$choice" == 'Y' ]]; then
  reboot
fi
