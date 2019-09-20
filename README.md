This repository contains OpenRC service `ipsec-xfrm` which loads ipsec xfrm rules
from `/var/lib/ipsec/ipsechost` file and applies them `ip xfrm` command.

The `ipsec-xfrm-update` script syncs rules from remote rsync service, merges
all synced files to `ipsechosts-update` and reloads the `ipsec-xfrm` service.
It is meant to be run by cron job hourly.
