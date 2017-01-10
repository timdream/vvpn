# vvpn

This is a set of scripts allow you to this set of things:

* Create a OpenVPN server, on a VPS service of your choice, on a dynamic DNS hostname.
* Save the configuration and throw away the server after use.
* Recreate the server, with the same configuration, available on the same hostname.
  **This allow you to create the server on-demand while keeping the same client configrations usable.**
  
The server will be created by the `openvpn-install` script by @Nyr, [fork by me](https://github.com/timdream/openvpn-install) allowing the script to pick up the saved configurations, or bootstrap from a given options (and falls into unattended mode.)
