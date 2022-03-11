<!--
SPDX-FileCopyrightText: 2022 Wilfred Nicoll <xyzroller@rollyourown.xyz>
SPDX-License-Identifier: CC-BY-SA-4.0
-->

# Roll Your Own STUN/TURN Server

This is a [rollyourown.xyz module](https://rollyourown.xyz/rollyourown/project_modules/) to deploy a [STUN](https://en.wikipedia.org/wiki/STUN)/[TURN](https://en.wikipedia.org/wiki/Traversal_Using_Relays_around_NAT) server using Ansible, Packer and Terraform.

## Module Summary

This module uses [Ansible](https://www.ansible.com/), [Packer](https://www.packer.io/) and [Terraform](https://www.terraform.io/) to deploy a [coturn](https://github.com/coturn/coturn) server as a module for other [rollyourown.xyz projects](https://rollyourown.xyz/rollyourown/projects/).

## How to Use

A [rollyourown.xyz](https://rollyourown.xyz/) module contains automation code to configure, build, deploy, maintain, back up and restore a module for use by other rollyourown.xyz projects.

In itself, a module doesn’t provide a full end-to-end service, but rather provides a reusable building block that is used in a full rollyourown.xyz project as part of the end-to-end solution for that project.

A detailed description for project developers of how to use this module in a project can be found in the [module's documentation](https://rollyourown.xyz/rollyourown/project_modules/ryo-coturn/).

## How to Collaborate

We would be delighted if you would like to contribute to [rollyourown.xyz](https://rollyourown.xyz) and there are a number of ways you can collaborate on this module:

- [Raising security-related issues](https://rollyourown.xyz/collaborate/security_vulnerabilities/)
- [Contributing bug reports, feature requests and ideas](https://rollyourown.xyz/collaborate/bug_reports_feature_requests_ideas/)
- [Improving the module](https://rollyourown.xyz/collaborate/existing_projects_and_modules/) - e.g. to provide fixes or enhancements

You may also like to contribute to the wider [rollyourown.xyz](https://rollyourown.xyz/) project by, for example:

- [Contributing a new project or module](https://rollyourown.xyz/collaborate/new_projects_and_modules/)
- [Contributing to the rollyourown.xyz website content](https://rollyourown.xyz/collaborate/website_content/) or [design](https://rollyourown.xyz/collaborate/website_design/)
- [Maintaining a rollyourown.xyz repository](https://rollyourown.xyz/collaborate/working_with_git/what_is_git/#project-maintainer)

Issues for this project can be submitted on [Codeberg](https://codeberg.org/) (_preferred_) or [GitHub](https://github.com/):

- Issues on Codeberg: [here](https://codeberg.org/rollyourown-xyz/ryo-coturn/issues)
- Issues on GitHub: [here](https://github.com/rollyourown-xyz/ryo-coturn/issues)

## Security Vulnerabilities

If you have found a security vulnerability in any [rollyourown.xyz](https://rollyourown.xyz/) service or any of the [rollyourown.xyz](https://rollyourown.xyz/) projects, modules or other repositories, please read our [security disclosure policy](https://rollyourown.xyz/collaborate/security_vulnerabilities/) and report this via our [security vulnerability report form](https://forms.rollyourown.xyz/security-vulnerability).

## Repository Links

For public contributions, we maintain mirror repositories of this project on [Codeberg](https://codeberg.org) and [GitHub](https://github.com):

- [https://codeberg.org/rollyourown-xyz/ryo-coturn](https://codeberg.org/rollyourown-xyz/ryo-coturn)
- [https://github.com/rollyourown-xyz/ryo-coturn](https://github.com/rollyourown-xyz/ryo-coturn)

Our preferred collaboration space is Codeberg:

<a href="https://codeberg.org/rollyourown-xyz/ryo-coturn"><img alt="Get it on Codeberg" src="https://get-it-on.codeberg.org/get-it-on-blue-on-white.png" height="60"></a>

The primary repository for this project is hosted on our own Git repository server at:

- [https://git.rollyourown.xyz/ryo-projects/ryo-coturn](https://git.rollyourown.xyz/ryo-projects/ryo-coturn)

**Repositories on our own Git server are accessible only to members of our organisation**.

## Copyright, Licences and Trademarks

For information on copyright, licences and trademarks, see [https://rollyourown.xyz/about/copyright_licenses_trademarks/](https://rollyourown.xyz/about/copyright_licenses_trademarks/).
