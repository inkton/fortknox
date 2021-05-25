# ansible-role-phabricator

![GitHub](https://img.shields.io/github/license/jam82/ansible-role-phabricator) [![Build Status](https://travis-ci.org/jam82/ansible-role-phabricator.svg?branch=main)](https://travis-ci.org/jam82/ansible-role-phabricator)

**Ansible role for setting up phabricator.**

## Supported Platforms

- Alpine
- Archlinux
- CentOS
- Debian
- Fedora
- OpenSuse Leap, Tumbleweed
- OracleLinux
- Ubuntu

## Requirements

Ansible 2.9 or higher.

## Variables

Variables and defaults for this role.

### defaults/main.yml

```yaml
phabricator_role_enabled: false
```

## Dependencies

None.

## Example Playbook

```yaml
---
# role: ansible-role-phabricator
# file: site.yml

- hosts: all
  become: true
  gather_facts: true
  vars:
    phabricator_role_enabled: true
  roles:
    - role: ansible-role-phabricator
```

## License and Author

- Author:: [jam82](https://github.com/jam82/)
- Copyright:: 2021, [jam82](https://github.com/jam82/)

Licensed under [MIT License](https://opensource.org/licenses/MIT).
See [LICENSE](https://github.com/jam82/ansible-role-phabricator/blob/master/LICENSE) file in repository.

## References

- [ArchWiki](https://wiki.archlinux.org/)
