# vvpn

This is a set of scripts allow you to this set of things:

* Create a OpenVPN server, on a VPS service of your choice, on a dynamic DNS hostname.
* Save the configuration and throw away the server after use.
* Recreate the server, with the same configuration, available on the same hostname.
  **This allow you to create the server on-demand while keeping the same client configrations usable.**
  
The server will be created by the `openvpn-install` script by @Nyr, [fork by me](https://github.com/timdream/openvpn-install) allowing the script to pick up the saved configurations, or bootstrap the server from a given options.

## Usage

1. Download this repo either by `git clone` or [download the zip](https://github.com/timdream/vvpn/archive/master.zip).
2. Copy [`vvpn_config.sample`](./vvpn_config.sample) and rename it to `vvpn_config`.
3. Fill in the necessary variables.
4. Run `./vvpn start` to start the server for the first time.
5. The server and client configurations will be pulled back to the local machine once the bootstrap completes.
   Install the client configuration to your clients and connect to the server with it.
6. Once you've are done with the connection, destroy the server with `./vvpn stop`.
   No snapshots or images will be stored on the VPS provider, so you shouldn't be charged afterward.
7. Any subsequent `./vvpn start` starts the server with the same configurations.

### Security consideration of this script

Only run this script on a trusted machine.
Once the server configuration is created Safeguard the generated client `ovpn` configurations and the `config` directory.
Destroy and re-create server credential if necessary.

## Rationale

Often, VPN (virtual private networks) market as a privacy and security product with readily available solutions often cheaper than VPS (virtual private server) solutions.
There are even free VPN solutions.
However, everything comes with a price.
By routing all your network connection through VPN, the VPN providers can extract even more information about you than any individual website.
The only way to workaround that would be to build your own VPN services, hence the script here.

### How secure are the VPS providers then?

Even with this script, you would still have to trust your VPS provider to build a server on it.
In theory, unencrypted data are always inspectable in the memory of the virtual machine.
The intention of this script is to prevent attacks by bad actors who run cheap or free VPN services.

### VPN common sense

VPN is by no mean a tool for stay anonymous online.
Your connection through a proxy might be detected.
It is still necessary to validate HTTPS connections.

## Supported dynamic DNS providers

You may consider supporting me by using the referral links below.

* [Namecheap](https://www.namecheap.com/?aff=109009)

## Supported VPS providers

* [DigitalOcean](https://m.do.co/c/12c24b0bd63f)
