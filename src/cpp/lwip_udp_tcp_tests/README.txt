#######################################################################################
LwIP UDP Perf Client
--------------------

The LwIP UDP Perf client application creates UDP client using LwIP stack.
This client connects to UDP server (running on Linux Host machine using
Iperf 2.0.5) with IP address (default 192.168.1.100) provided in application.
The UDP server should be running on host machine to serve this client.
Once client connects with server, then application will start data
transfer and performance will be measured.
Connection details and data transfer statistics will be displayed by client
on serial console.

Following UDP client options can be changed in file udp_perf_client.h,
1) INTERIM_REPORT_INTERVAL: time interval (in secs) for intermediate report
display interval. (default 5 secs)
2) UDP_CONN_PORT: Port to be used for UDP connection. (default 5001)
3) UDP_TIME_INTERVAL: time interval (in secs) for which UDP client will run.
(default 300 secs)
4) UDP_SERVER_IP_ADDRESS: Server IP address to which client will be connected.
(default 192.168.1.100)
5) UDP_SEND_BUFSIZE: UDP buffer length for datagrams (default 1400)

If LWIP_DHCP enabled then board should get IP address from DHCP server.
If DHCP timeout happens or LWIP_DHCP is disabled then, the program assigns the
following IP settings to the board:
IP Address: 192.168.1.10
Netmask   : 255.255.255.0
Gateway   : 192.168.1.1
MAC address:  00:0a:35:00:01:02

These settings can be changed in the file main.c.

The UDP client connection and statistics logic is present in the file
udp_perf_client.c

Running the LwIP UDP client example
-----------------------------------

First run Iperf server on host machine using below command
$ iperf -s -i 5 -u

Now, download and run the UDP client application on the board.



#######################################################################################
LwIP UDP Perf Server
--------------------

The LwIP UDP Perf Server application creates UDP server for providing
connections to UDP client (Iperf 2.0.5) running on host machine.
Once remote client connects with this server, UDP server will start receiving
data from client.
Connection details and data transfer statistics will be displayed by server
on serial console.

Following UDP server options can be changed in file udp_perf_server.h,
1) INTERIM_REPORT_INTERVAL: time interval (in secs) for intermediate report
display interval. (default 5 secs)
2) UDP_CONN_PORT - Port on which server will listen for client connection.

If LWIP_DHCP enabled then board should get IP address from DHCP server.
If DHCP timeout happens or LWIP_DHCP is disabled then, the program assigns the
following IP settings to the board:
IP Address: 192.168.1.10
Netmask   : 255.255.255.0
Gateway   : 192.168.1.1
MAC address:  00:0a:35:00:01:02

These settings can be changed in the file main.c.

The UDP server connection and statistics logic is present in the file
udp_perf_server.c

Running the LwIP UDP server example
-----------------------------------

To connect and test the UDP server, download and run the application on
the board, and then issue the following command from your host machine:

$ iperf -c <Board IP address> -i 5 -t 300 -u -b <bandwidth>



#######################################################################################
LwIP TCP Perf Client
--------------------

The LwIP TCP Perf client application creates TCP client using LwIP stack.
This client connects to TCP server (running on Linux Host machine using
Iperf 2.0.5) with IP address (default 192.168.1.100) provided in application.
The TCP server should be running on host machine to serve this client.
Once client connects with server, then application will start data
transfer and performance will be measured.
Connection details and data transfer statistics will be displayed by client
on serial console.

Following TCP client options can be changed in file tcp_perf_client.h,
1) INTERIM_REPORT_INTERVAL: time interval (in secs) for intermediate report
display interval. (default 5 secs)
2) TCP_CONN_PORT: Port to be used for TCP connection. (default 5001)
3) TCP_TIME_INTERVAL: time interval (in secs) for which TCP client will run.
(default 300 secs)

For IPv4,
4) TCP_SERVER_IP_ADDRESS: Server IPV4 address to which client will be connected.
(default 192.168.1.100)
For IPv6,
4) TCP_SERVER_IPV6_ADDRESS: Server IPV6 address to which client will be connected.
(default fe80::6600:6aff:fe71:fde6)

If LWIP_DHCP enabled then board should get IP address from DHCP server.
If DHCP timeout happens or LWIP_DHCP is disabled then, the program assigns the
following IP settings to the board:
IP Address: 192.168.1.10
Netmask   : 255.255.255.0
Gateway   : 192.168.1.1
MAC address:  00:0a:35:00:01:02

Procedure to enable IPv6
------------------------
A) From SDK GUI.
1. Create lwip_tcp_perf application from XSDK
2. Go to BSP Settings from XSDK
   --> Overview
      --> standalone
        --> lwip202
           --> ipv6_enable
               - Select "true" from value tab.
3. Build complete project.

B) From mss file.
1. Before creating project update below parameter.
   - FILE: lwip_tcp_perf_client.mss
     - PARAMETER ipv6_enable = true

If LWIP_IPV6 enabled then board should configured with IPv6 link local address.
following IPv6 settings to the board:
link local IPv6 Address: FE80:0:0:0:20A:35FF:FE00:102

These settings can be changed in the file main.c.

The TCP client connection and statistics logic is present in the file
tcp_perf_client.c

Running the LwIP TCP client example
-----------------------------------

First run Iperf server on host machine using below command

For IPv4
$ iperf -s -i 5 -w 2M

For IPv6
$ iperf -V s -i 5 -w 2M

Now, download and run the TCP client application on the board.



#######################################################################################
LwIP TCP Perf Server
--------------------

The LwIP TCP Perf Server application creates TCP server for providing
connections to TCP client (Iperf 2.0.5) running on host machine.
Once remote client connects with this server, TCP server will start receiving
data from client.
Connection details and data transfer statistics will be displayed by server
on serial console.

Following TCP server options can be changed in file tcp_perf_server.h,
1) INTERIM_REPORT_INTERVAL: time interval (in secs) for intermediate report
display interval. (default 5 secs)
2) TCP_CONN_PORT - Port on which server will listen for client connection.

If LWIP_DHCP enabled then board should get IP address from DHCP server.
If DHCP timeout happens or LWIP_DHCP is disabled then, the program assigns the
following IP settings to the board:
IP Address: 192.168.1.10
Netmask   : 255.255.255.0
Gateway   : 192.168.1.1
MAC address:  00:0a:35:00:01:02

Procedure to enable IPv6
------------------------
A) From SDK GUI.
1. Create lwip_tcp_perf application from XSDK
2. Go to BSP Settings from XSDK
   --> Overview
      --> standalone
        --> lwip202
           --> ipv6_enable
               - Select "true" from value tab.
3. Build complete project.

B) From mss file.
1. Before creating project update below parameter.
   - FILE: lwip_tcp_perf_server.mss
     - PARAMETER ipv6_enable = true

If LWIP_IPV6 enabled then board should configured with IPv6 link local address.
following IPv6 settings to the board:
link local IPv6 Address: FE80:0:0:0:20A:35FF:FE00:102

These settings can be changed in the file main.c.

The TCP server connection and statistics logic is present in the file
tcp_perf_server.c

Running the LwIP TCP server example
-----------------------------------

To connect and test the TCP server, download and run the application on
the board, and then issue the following command from your host machine:

For IPv4,
$ iperf -c <Board IP address> -i 5 -t 300 -w 2M

For IPv6,
$ iperf -V -c <Board IP address>%<interface> -i 5 -t 300 -w 2M

[Note: For Link local IPv6 address, we need to specify interface in iperf to
define the scope where the link local address is valid]
