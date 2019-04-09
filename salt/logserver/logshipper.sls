{% set install_dir = pillar['pnda']['homedir'] %}

{% set pnda_mirror = pillar['pnda_mirror']['base_url'] %}
{% set misc_packages_path = pillar['pnda_mirror']['misc_packages_path'] %}
{% set mirror_location = pnda_mirror + misc_packages_path %}

{% set logstash_version = pillar['logstash']['version'] %}
{% set logstash_package = 'logstash-' + logstash_version + '.tar.gz' %}
{% set logstash_url = mirror_location + logstash_package %}
{% set plugin_pack_name = 'logstash-offline-plugins-6.2.1.zip' %}
{% set plugin_pack_url = mirror_location + plugin_pack_name %}

include:
  - java

logshipper-lbc6:
  pkg.installed:
    - name: {{ pillar['glibc-devel']['package-name'] }}
    - version: {{ pillar['glibc-devel']['version'] }}
    - ignore_epoch: True

logshipper-acl:
  pkg.installed:
    - name: {{ pillar['acl']['package-name'] }}
    - version: {{ pillar['acl']['version'] }}
    - ignore_epoch: True

logshipper-dl-and-extract:
  archive.extracted:
    - name: {{ install_dir }}
    - source: {{ logstash_url }}
    - source_hash: {{ logstash_url }}.sha512
    - archive_format: tar
    - tar_options: ''
    - if_missing: {{ install_dir }}/logstash-{{ logstash_version }}

logshipper-link_release:
  file.symlink:
    - name: {{ install_dir }}/logstash
    - target: {{ install_dir }}/logstash-{{ logstash_version }}

logshipper-journald-plugin:
  cmd.run:
    - name: curl {{ plugin_pack_url }} > {{ install_dir }}/logstash/{{ plugin_pack_name }}; cd {{ install_dir }}/logstash; bin/logstash-plugin install file://{{ install_dir }}/logstash/{{ plugin_pack_name }};

logshipper-copy_configuration:
  file.managed:
    - name: {{ install_dir }}/logstash/shipper.conf
    - source: salt://logserver/logshipper_templates/shipper.conf.tpl
    - template: jinja
    - defaults:
        install_dir: {{ install_dir }}

yarn:
  group.present
kafka:
  group.present

logger:
  user.present:
    - groups:
      - yarn
      - root
      - kafka

logshipper-add_salt_permissions:
  cmd.run:
    - name: 'chmod -R 755 /var/log/salt'

logshipper-copy_permission_script:
  file.managed:
    - name: {{ install_dir }}/logstash/open_yarn_log_permissions.sh
    - source: salt://logserver/logshipper_files/open_yarn_log_permissions.sh
    - mode: 755

# Workaround for logshipper-yarnperms-add_crontab_entry:
# add a dummy cron job.
# This job prevents the logshipper-yarnperms-add_crontab_entry
# from giving an error for crontab -l (no cron jobs for root).
logshipper-add_dummy_crontab_entry:
  cmd.run:
    - name: echo "* * * * * date" | crontab -

logshipper-yarnperms-add_crontab_entry:
  cron.present:
    - identifier: YARN-PERMISSIONS
    - user: root
    - minute: '*'
    - name: {{ install_dir }}/logstash/open_yarn_log_permissions.sh

# Workaround for logshipper-yarnperms-add_crontab_entry:
# remove a dummy cron job.
# This job prevented the logshipper-yarnperms-add_crontab_entry
# from giving an error for crontab -l (no cron jobs for root).
logshipper-remove_dummy_crontab_entry:
  cmd.run:
    - name: crontab -l | sed -e "/\*\ \*\ \*\ \*\ \*\ date/d" > /tmp/crontab_rest.tmp; crontab /tmp/crontab_rest.tmp && rm -f /tmp/crontab_rest.tmp

logshipper-create_sincedb_folder:
  file.directory:
    - name: {{ install_dir }}/logstash/sincedb
    - mode: 777
    - makedirs: True

logshipper-copy_service:
  file.managed:
    - name: /usr/lib/systemd/system/logshipper.service
    - source: salt://logserver/logshipper_templates/logstash.service.tpl
    - template: jinja
    - defaults:
        install_dir: {{ install_dir }}

logshipper-systemctl_reload:
  cmd.run:
    - name: /bin/systemctl daemon-reload; /bin/systemctl enable logshipper

logshipper-start_service:
  cmd.run:
    - name: 'service logshipper stop || echo already stopped; service logshipper start'
