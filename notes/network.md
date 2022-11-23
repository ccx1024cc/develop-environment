# Network tips

## set DNS permanently

```shell
# Change /etc/resolvconf/resolv.conf.d/head
# Then
sudo resolvconf --enable-updates
sudo resolvconf -u
```
