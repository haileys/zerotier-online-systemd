# Maintainer: Hailey Somerville <zerotier-online-systemd@hails.org>
pkgname="zerotier-online-systemd"
pkgver="0.9"
pkgrel=1
pkgdesc="Provides a systemd target that waits for a zerotier network to come online"

arch=("any")
url="https://github.com/haileys/zerotier-online-systemd"
license=("GPL")

depends=("zerotier-one" "jq")
source=(
    "zerotier-online@.target"
    "zerotier-wait-online@.service"
    "zerotier-wait-online.sh"
)
sha256sums=("SKIP" "SKIP" "SKIP")

package() {
    install -d "$pkgdir/usr/lib/systemd/system"
    install -m0644 "$srcdir/zerotier-online@.target" "$pkgdir/usr/lib/systemd/system/"
    install -m0644 "$srcdir/zerotier-wait-online@.service" "$pkgdir/usr/lib/systemd/system/"

    install -d "$pkgdir/usr/lib/zerotier-online-systemd"
    install -m0755 "$srcdir/zerotier-wait-online.sh" "$pkgdir/usr/lib/zerotier-online-systemd/"
}
