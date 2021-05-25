# Setup local wildcard domain resolution

## Objective

```bash
dig kind.io nginx.kind.io xxx.kind.io +short
# 172.19.255.201
# 172.19.255.201
# 172.19.255.201
```

## Steps

1. Edit `/etc/NetworkManager/NetworkManager.conf`, and add the line `dns=dnsmasq` to the `[main]` section

    ```conf
    [main]
    plugins=ifupdown,keyfile
    dns=dnsmasq
    ```

2. Let `NetworkManager` manage `/etc/resolv.conf`

    ```bash
    sudo rm /etc/resolv.conf ; sudo ln -s /var/run/NetworkManager/resolv.conf /etc/resolv.conf
    ```

3. Create `/etc/NetworkManager/dnsmasq.d/dnsmasq-kind.conf` to configure wildcard

    ```conf
    address=/.kind.io/172.19.255.201
    ```

4. Reload NetworkManager and testing

    ```bash
    sudo systemctl reload NetworkManager
    dig kind.io nginx.kind.io xxx.kind.io +short
    # 172.19.255.201
    # 172.19.255.201
    # 172.19.255.201
    ```

## Resources

- [How to set up local wildcard (127.0.0.1) domain resolution on Ubuntu](https://itectec.com/ubuntu/ubuntu-how-to-set-up-local-wildcard-127-0-0-1-domain-resolution-on-18-04/)