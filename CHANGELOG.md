## Unreleased
- Manufacturer lookups use fresh IEEE data. Texas Instruments never matched, and OUIs with leading zeros (e.g. Microsoft 00:22:48) were missing.
- MAC addresses must match the whole string; a multi-line string no longer matches.
- `MMM.MMM.SSS.SSS` is no longer a MAC address (it matched IPv4 strings); Cisco `MMMM.MMSS.SSSS` is. Use colons or dashes with `.from` and `.for`.
- 64-bit MAC addresses accept dashes.
- MAC failure messages show `nil` as `nil`, and read "to be a MAC address".
- CIDR ranges like `10.0.0.0/8` are no longer IP addresses.
- IP failure messages show `nil` as `nil`.

###  0.1.0  (2024-08-31)
- ip address
- mac addresses
- manufacturers

###  0.0.1  (2024-08-30)
init
