# Network tips

## set DNS permanently

```shell
# Change /etc/resolvconf/resolv.conf.d/head
# Then
sudo resolvconf --enable-updates
sudo resolvconf -u
```

## tcpdump

1.By Method

```shell
# GET
tcpdump -s 0 -A -vv 'tcp[((tcp[12:1] & 0xf0) >> 2):4] = 0x47455420'

# POST
tcpdump -s 0 -A -vv 'tcp[((tcp[12:1] & 0xf0) >> 2):4] = 0x504f5354'
```

2.DNS

```shell
tcpdump -i any -s0 port 53
```
