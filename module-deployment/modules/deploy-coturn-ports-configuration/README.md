<!--
SPDX-FileCopyrightText: 2022 Wilfred Nicoll <xyzroller@rollyourown.xyz>
SPDX-License-Identifier: CC-BY-SA-4.0
-->

# Deploy key-value pairs to consul KV store for providing coturn ports configuration

This module deploys key-value pairs to consul KV store for configuring the coturn services ports. Configuration is specified by input variables:

## listening_port (number)

The TURN listener port for UDP and TCP. The default is port 3478.

## tls_listening_port (number)

The TURN listener port for TLS and DTLS. The default is port 5349.

## ip_addr_host_part (number)

The host part of the IP address of the coturn container. E.g. if the IP address is 10.10.10.20, then the host part is "20"

## min_port (number)

The lower bound of the coturn TURN server UDP relay endpoints. The default is 50000.

## max_port (number)

The upper bound of the coturn TURN server UDP relay endpoints. The default is 51000.
