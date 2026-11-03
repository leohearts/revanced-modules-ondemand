#!/usr/bin/env bash
# Starts a Cloudflare WARP socks5 proxy on 127.0.0.1:40000 (userspace, no root).
# Used so apkmirror does not see the GitHub runner's datacenter IP.
set -euo pipefail

dir=$(mktemp -d)
cd "$dir"
curl -fsSLo wgcf https://github.com/ViRb3/wgcf/releases/download/v2.3.1/wgcf_2.3.1_linux_amd64
curl -fsSL https://github.com/windtf/wireproxy/releases/download/v1.1.3/wireproxy_linux_amd64.tar.gz | tar xz wireproxy
chmod +x wgcf wireproxy

./wgcf register --accept-tos >/dev/null
./wgcf generate >/dev/null
printf '\n[Socks5]\nBindAddress = 127.0.0.1:40000\n' >>wgcf-profile.conf

nohup ./wireproxy -s -c wgcf-profile.conf >wireproxy.log 2>&1 &
for _ in $(seq 30); do
	if curl -fs --socks5-hostname 127.0.0.1:40000 https://www.cloudflare.com/cdn-cgi/trace | grep -qx 'warp=on'; then
		echo "WARP proxy ready"
		exit 0
	fi
	sleep 1
done
echo "WARP proxy failed to start" >&2
cat wireproxy.log >&2
exit 1
