# ipsec-xfrm

This repository contains OpenRC and systemd services for `ipsec-xfrm` which
loads ipsec xfrm rules from `/var/lib/ipsec/ipsechost` file and applies them
with `ip xfrm` command. By default, `ipsec-xfrm` bypasses IPsec policies for
port 22 (SSH). This can be customized or disabled by setting the `BYPASS_PORTS`
variable in [`/etc/ipsec-xfrm.conf`](ipsec-xfrm.conf).

The `ipsec-xfrm-update` script syncs rules from remote service over ssh with
[`lftp`](https://lftp.tech/) program, merges all synced files to
`ipsechosts-update` and reloads the `ipsec-xfrm` service.  It is meant to be
run by cron job hourly. `ipsec-xfrm-update` searches for optional configuration
in `/etc/ipsec-xfrm.conf` file which is regular shell script inherited to the
`ipsec-xfrm-update` script. See default [`ipsec-xfrm.conf`](ipsec-xfrm.conf)

The `ipsechosts` and `ipsechosts-update` files are blank-separated-value list
with following format:

```
# ip-address        domain-name       unique-hex-id    hex-key
2001:67c:15a1::a1   ax.virusfree.cz   1                00112233445566778899aabbccddeeff00112233
2001:67c:15a1::b1   bx.virusfree.cz   2                aabbccddeeff00112233445566778899aabbccdd
```

* `ip-address` - IPv4 or IPv6 address (IPv6 address is expected in compressed
  form. It is compared with address returned by `ip a` command as is.),
* `domain-name` - user identifier, it is not used by code,
* `unique-hex-id` - up to 16 bits long hexadecimal number [0-ffff]. There is
no need to have leading 0 in the number.
* `hex-key` - the key

## OpenRC users

Install `ipsec-xfrm` to OpenRC `init.d` directory.

## systemd users

Use `ipsec.service` if you wish to use this on systemd powered system. It
currently expects to have `ipsec` and `ipsec-xfrm` scripts located in
`/usr/local/bin` directory.
~~The `ipsec-xfrm-update` cron job needs to be modified appropriately.~~
