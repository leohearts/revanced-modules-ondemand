#!/usr/bin/env bash
# Starts a Cloudflare WARP socks5 proxy on 127.0.0.1:40000 (userspace, no root).
# Used so apkmirror does not see the GitHub runner's datacenter IP.
set -euo pipefail

dir=$(mktemp -d)
cd "$dir"
curl -fsSLo wgcf https://github.com/ViRb3/wgcf/releases/download/v2.3.1/wgcf_2.3.1_linux_amd64
curl -fsSL https://github.com/windtf/wireproxy/releases/download/v1.1.3/wireproxy_linux_amd64.tar.gz | tar xz wireproxy
chmod +x wgcf wireproxy

timeout 60 ./wgcf register --accept-tos >/dev/null
timeout 60 ./wgcf generate >/dev/null
printf '\n[Socks5]\nBindAddress = 127.0.0.1:40000\n' >>wgcf-profile.conf

# UDP to the default endpoint is sometimes dropped on runners; try other WARP ingress IPs/ports.
for ep in engage.cloudflareclient.com:2408 162.159.192.1:2408 162.159.193.10:500 162.159.192.1:1701 162.159.193.10:4500; do
	sed -i "s/^Endpoint = .*/Endpoint = $ep/" wgcf-profile.conf
	./wireproxy -c wgcf-profile.conf >wireproxy.log 2>&1 &
	pid=$!
	for _ in $(seq 10); do
		if curl -fs -m 3 --socks5-hostname 127.0.0.1:40000 https://www.cloudflare.com/cdn-cgi/trace | grep -qx 'warp=on'; then
			echo "WARP proxy ready via $ep"
			exit 0
		fi
	done
	echo "no handshake via $ep"
	kill "$pid"
	wait "$pid" 2>/dev/null || :
done
echo "WARP proxy failed to start" >&2
exit 1
