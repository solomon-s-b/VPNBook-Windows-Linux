# VPNBook
Auto connect VPN Client (Linux\Windows) service with www.vpnbook.com

### Linux:
The bash script was originally forked from:
[ironbugs/VPNBook](https://github.com/ironbugs/VPNBook)

1. Added: 10 seconds timeout.
2. Use only grep in perl mode to extract the usename and password.
3. Added: check if "OpenVPN" NOT exist.
4. In case no selection made, select a random server and login.
5. Added: check if User have sudo rights.
6. Added: option to select server port number.

### Windows:

1. 10 seconds timeout.
2. Use only findstr to extract the usename and password.
3. Check if "OpenVPN" NOT exist.
4. In case no selection made, select a random server and login.
5. Check if User have sudo rights.
6. Option to select server port number.
