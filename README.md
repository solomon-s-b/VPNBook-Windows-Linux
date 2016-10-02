# VPNBook
Auto connect VPN Client (Linux\Windows) service with www.vpnbook.com

### Linux:
The bash script was originally forked from:
[ironbugs/VPNBook](https://github.com/ironbugs/VPNBook)

1. 10 seconds timeout, before running auto connect.
2. Use only grep in perl mode to extract the usename and password.
3. Check if "OpenVPN" is installed.
4. In case no selection made, select a random server and port number.
5. Check if User have sudo rights.
6. Option to select server port number.

### Windows:
1. 10 seconds timeout, before running auto connect.
2. Use only findstr to extract the usename and password.
3. Check if "OpenVPN" is installed.
4. In case no selection made, select a random server and port number.
5. Check if User have administrator rights.
6. Option to select server port number.
