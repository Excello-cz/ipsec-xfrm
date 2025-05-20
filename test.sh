#! /usr/bin/sh

export PATH="test-utils:${PATH}"

function ebegin() {
	:
}

function eend() {
	return $1
}

function testcheck() {
	local name="${@}"
	local expected="$(cat)"
	local actual="$("${@}")"
	if test "${actual}" = "${expected}"
	then
		echo "[PASS] $name"
	else
		echo "[FAIL] $name"
		echo "${expected}" > expected~
		echo "${actual}" > actual~
		diff -u -L expected -L got expected~ actual~
		rm -f expected~ actual~
		return 1
	fi
}

source "./ipsec-xfrm"

testcheck load ./test-hosts <<EOF
ip xfrm policy add dir in src ::/0 dst ::/0 proto ipv6-icmp priority 2147483548
ip xfrm policy add dir in src ::/0 dst ::/0 dport 22 priority 2147483548
ip xfrm policy add dir in src ::/0 dst ::/0 sport 22 priority 2147483548
ip xfrm policy add dir in src 0.0.0.0/0 dst 0.0.0.0/0 proto icmp priority 2147483548
ip xfrm policy add dir in src 0.0.0.0/0 dst 0.0.0.0/0 dport 22 priority 2147483548
ip xfrm policy add dir in src 0.0.0.0/0 dst 0.0.0.0/0 sport 22 priority 2147483548
ip xfrm policy add dir out src ::/0 dst ::/0 proto ipv6-icmp priority 2147483548
ip xfrm policy add dir out src ::/0 dst ::/0 dport 22 priority 2147483548
ip xfrm policy add dir out src ::/0 dst ::/0 sport 22 priority 2147483548
ip xfrm policy add dir out src 0.0.0.0/0 dst 0.0.0.0/0 proto icmp priority 2147483548
ip xfrm policy add dir out src 0.0.0.0/0 dst 0.0.0.0/0 dport 22 priority 2147483548
ip xfrm policy add dir out src 0.0.0.0/0 dst 0.0.0.0/0 sport 22 priority 2147483548
ip xfrm state add src 192.168.0.2 dst 192.168.0.1 proto esp spi 0x00020001 aead rfc4106(gcm(aes)) 0xaabbccddee 96 mode transport extra-flag 0x2
ip xfrm state add src 192.168.0.1 dst 192.168.0.2 proto esp spi 0x00010002 aead rfc4106(gcm(aes)) 0x0011223344 96 mode transport extra-flag 0x2
ip xfrm policy add dir out src 192.168.0.2 dst 192.168.0.1 priority 2147483648 tmpl proto esp mode transport
ip xfrm policy add dir in src 192.168.0.1 dst 192.168.0.2 priority 2147483648 tmpl proto esp mode transport
ip xfrm state add src 192.168.0.2 dst 192.168.0.3 proto esp spi 0x00020003 aead rfc4106(gcm(aes)) 0x5566778899 96 mode transport extra-flag 0x2
ip xfrm state add src 192.168.0.3 dst 192.168.0.2 proto esp spi 0x00030002 aead rfc4106(gcm(aes)) 0x0011223344 96 mode transport extra-flag 0x2
ip xfrm policy add dir out src 192.168.0.2 dst 192.168.0.3 priority 2147483648 tmpl proto esp mode transport
ip xfrm policy add dir in src 192.168.0.3 dst 192.168.0.2 priority 2147483648 tmpl proto esp mode transport
ip xfrm state add src 3000::2 dst 3000::1 proto esp spi 0x00050004 aead rfc4106(gcm(aes)) 0x0030000001 96 mode transport extra-flag 0x2
ip xfrm state add src 3000::1 dst 3000::2 proto esp spi 0x00040005 aead rfc4106(gcm(aes)) 0x0030000002 96 mode transport extra-flag 0x2
ip xfrm policy add dir out src 3000::2 dst 3000::1 priority 2147483648 tmpl proto esp mode transport
ip xfrm policy add dir in src 3000::1 dst 3000::2 priority 2147483648 tmpl proto esp mode transport
EOF

testcheck flush <<EOF
ip xfrm state flush
ip xfrm policy flush
EOF
