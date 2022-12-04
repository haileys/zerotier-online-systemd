# zerotier-online-systemd

Provides the systemd template `zerotier-online@.target` asserting that a particular [ZeroTier](https://zerotier.com/) network has come online.

The instance name of the template can be either a ZeroTier network id or network name, for example:

* `zerotier-online@b3ccb0264b417d78.target`

* `zerotier-online@cool-network.target`

## Why is this useful?

My laptop mounts some CIFS shares on boot, connecting to the file server over ZeroTier.

The mount units must wait for the ZeroTier network to come online before they are started, otherwise they will fail to start during boot and must manually be restarted once logged in.

Setting a dependency on `network-online.target` is not enough: `network-online.target` is reached when the wireless network comes online, but this is a prerequisite for ZeroTier connecting. It is also not desirable to make `network-online.target` wait for the ZeroTier network to come online as this would unnecessarily delay other units from starting, so it's necessary to split the ZeroTier dependency out into its own target unit.

And so we've arrived at the purpose of this package. Setting a dependency on the `zerotier-online@.target` target will wait for the ZeroTier daemon to start and connect to the network we need.

Here's an example [mount unit](https://www.freedesktop.org/software/systemd/man/systemd.mount.html) that waits for the ZeroTier network named `cool-network` to come online before attempting to mount the `//fileserver/data` share:

```systemd
[Unit]
Description=fileservers:/volume/data
After=zerotier-online@cool-network.target
BindsTo=zerotier-online@cool-network.target

[Mount]
What=//fileserver/data
Where=/volumes/data
Type=cifs

[Install]
WantedBy=multi-user.target
```

## License

GPL
