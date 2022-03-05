<!--
SPDX-FileCopyrightText: 2022 Wilfred Nicoll <xyzroller@rollyourown.xyz>
SPDX-License-Identifier: CC-BY-SA-4.0
-->

# Deploy key-value pairs to consul KV store for providing coturn domain configuration

This module deploys key-value pairs to consul KV store for configuring the domain for the coturn service. Configuration is specified by one input variable:

## turn_domain (string)

A string representing the domain (or subdomain) under which the TURN server is to be reachable.
