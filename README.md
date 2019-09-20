This repository contains OpenRC service `ipsec-xfrm` which loads ipsec xfrm rules
from `/var/lib/ipsec/ipsechost` file and applies them `ip xfrm` command.

The `ipsec-xfrm-update` script syncs rules from remote rsync service, merges
all synced files to `ipsechosts-update` and reloads the `ipsec-xfrm` service.
It is meant to be run by cron job hourly.

The `ipsechosts` and `ipsechosts-update` files are blank-separated-value list
with following format:

```
# ip-address        domain-name       unique-id    hex-key
2001:67c:15a1::a    aq.virusfree.cz   1            00112233445566778899aabbccddeeff00112233
```
