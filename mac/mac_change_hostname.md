Mac Change HostName
===================

> <https://apple.stackexchange.com/a/287775>

未深入研究各host区别

``` shell
# 1. Open a terminal.
# 2. ype the following command to change the primary hostname of your Mac:
# This is your fully qualified hostname, for example myMac.domain.com
sudo scutil --set HostName <new host name>

# 3. Type the following command to change the Bonjour hostname of your Mac:
# This is the name usable on the local network, for example myMac.local.
sudo scutil --set LocalHostName <new host name>

# 4. If you also want to change the computer name, type the following command:
# This is the user-friendly computer name you see in Finder, for example myMac.
sudo scutil --set ComputerName <new name>

# 5. Flush the DNS cache by typing:
dscacheutil -flushcache

# 6. Restart your Mac.
```
