
# 🚀 Xray-Core Server Optimizer

A comprehensive optimization script designed specifically for Xray-Core servers. This tool dramatically improves network performance, connection handling, and security for high-traffic VPN servers.

## 🔥 Key Features

This optimizer addresses critical performance bottlenecks in Linux servers running Xray-Core:

### File System Optimization

- **Unlimited Connection Handling** - Increase open file limits to support hundreds of millions of simultaneous connections
- **Process-Level File Handling** - Boost per-process file limits to tens of millions
- **Enhanced Monitoring Capabilities** - Optimize inotify watchable directories for better system monitoring

### Network Core Enhancements

- **Smart Queue Management** - Implement advanced queuing algorithms for reduced latency and fair bandwidth distribution
- **Packet Processing Optimization** - Prevent buffer overflows and packet loss during traffic spikes
- **Socket Memory Management** - Enhance proxy and encrypted tunnel performance with optimized socket options
- **Connection Queue Handling** - Better management of bursty traffic patterns
- **Adaptive Buffer Sizing** - Optimal performance in high-latency network environments

### TCP Performance Tuning

<details>
<summary>Click to expand TCP optimizations</summary>

- **Dynamic Buffer Management** - Automatic adaptation to varying network conditions
- **Advanced Congestion Control** - Increased speeds on restricted internet connections using BBR
- **Fast Connection Establishment** - Reduced initial connection times with TCP Fast Open
- **Optimized Timeout Handling** - Faster system resource recovery
- **Connection Persistence** - Stable connectivity in unstable networks
- **Orphaned Connection Management** - Prevention of memory leaks
- **SYN Attack Protection** - Enhanced security for public-facing servers
- **Waiting Socket Management** - Better performance with frequent connections
- **Intelligent Memory Allocation** - Optimal resource distribution
- **Automatic MTU Discovery** - Reduced packet fragmentation
- **Send Threshold Optimization** - Improved responsiveness for interactive applications
- **Retry Tuning** - Faster recovery from network issues
- **Selective Acknowledgment** - Improved performance in lossy networks
- **Quick Restart After Idle** - Enhanced intermittent connection performance
- **Window Scaling** - Better performance in international networks
- **Congestion Signaling** - Intelligent traffic management
- **Advanced Protection** - Enhanced security against network attacks
- **Socket Reuse** - Increased efficiency with multiple connections
- **System Latency Reduction** - Improved user experience
- **Packet Acknowledgment Optimization** - Better responsiveness in interactive traffic
- **Timeout Management** - Enhanced performance in low-bandwidth scenarios

</details>

### UDP Optimization

- **Advanced Memory Management** - Critical for QUIC protocols in Xray

### Virtual Memory Optimization

- **Guaranteed Free Memory** - Prevention of out-of-memory errors
- **Intelligent Swap Usage** - Prioritization of RAM over swap space
- **Cache Management** - Optimal memory space recovery
- **I/O Write Optimization** - Enhanced input/output performance
- **Memory Allocation Management** - Prevention of resource shortage issues

### Network Security & Routing

> Security is not just a feature, it's a foundation. Our optimizations protect while they perform.

- **Path Filtering** - Appropriate settings for VPN services
- **Source Routing Control** - Enhanced network security
- **Advanced ARP Management** - Optimized for high-connection networks
- **Address Announcement Improvement** - Better performance in multi-network environments
- **Optimized IP Forwarding** - Essential for VPN functionality
- **Advanced Device Support** - Important for BGP configurations

### Kernel Optimization

- **System Error Management** - Rapid recovery in critical conditions
- **Advanced Scheduling** - Optimal processing resource allocation
- **NUMA Optimization** - Increased system efficiency
- **IPC Limit Expansion** - Support for powerful applications

## 📋 Installation

```bash
sudo bash <(curl -s https://raw.githubusercontent.com/FReak4L/xray-tuning/refs/heads/main/tune.sh)
```

## ⚙️ What It Does

This script automatically:

1. Installs the XanMod kernel for improved network performance
2. Configures sysctl parameters for optimal Xray-Core operation
3. Sets up proper file descriptor limits
4. Optimizes SSH for better connection handling
5. Configures firewall rules for common VPN ports
6. Creates an optimized swap file

## 🔍 Before & After

| Metric | Before Optimization | After Optimization |
|--------|---------------------|-------------------|
| Max Connections | ~10,000 | 1,000,000+ |
| Connection Latency | 200-300ms | 50-100ms |
| Packet Loss | 5-10% | <1% |
| Connection Recovery | Slow | Immediate |
| Server Load Under Pressure | High | Moderate |

## 🌟 Who Should Use This

- Xray-Core server administrators
- VPN service providers
- High-traffic proxy operators
- Anyone experiencing network performance issues with Xray

## 📱 Connect With Us

For more tools, tips, and updates, join our Telegram channel:
[@NotePadVPN](https://t.me/NotePadVPN)

## 🙏 Acknowledgements

Original code source: [Linux-Optimizer](https://github.com/hawshemi/Linux-Optimizer)

---

<p align="center">
  <b>Supercharge your Xray-Core server today!</b><br>
  <a href="https://t.me/NotePadVPN">@NotePadVPN</a>
</p>
