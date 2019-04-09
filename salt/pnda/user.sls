{% set pnda_user = pillar['pnda']['user'] %}
{% set pnda_password = pillar['pnda']['password_hash'] %}
{% set pnda_group = pillar['pnda']['group'] %}
{% set pnda_home_directory = pillar['pnda']['homedir'] %}

# Noticed that on CentOS 7 (default image referenced in PNDA guide)
# the audit is already installed and is clashing with a
# dependency needed for policycoreutils-python. Therefore, uninstall it
# and let policycoreutils-python install its required dependency
{% if grains['os'] == 'CentOS' %}
pnda-install_selinux1:
  pkg.removed:
    - pkgs:
      - audit
      - version: 2.8.1-3.el7
{% endif %}

pnda-install_selinux2:
  pkg.installed:
    - name: policycoreutils-python
    - fromrepo: pnda_mirror

{% if salt['cmd.run']('getenforce')|lower != 'disabled' %}
permissive:
  selinux.mode: []
  file.replace:
    - name: '/etc/selinux/config'
    - pattern: '^SELINUX=(?!\s*permissive).*'
    - repl: 'SELINUX=permissive'
    - append_if_not_found: True
    - show_changes: True
{% endif %}

pnda-create_pnda_group:
  group.present:
    - name: {{ pnda_group }}

pnda-create_pnda_user:
  user.present:
    - name: {{ pnda_user }}
    - password: {{ pnda_password }}
    - home: {{ pnda_home_directory }}
    - createhome: True
    - groups:
      - {{ pnda_group }}

pnda-set_home_dir_perms:
  file.directory:
    - name: {{ pnda_home_directory }}
    - mode: 755
