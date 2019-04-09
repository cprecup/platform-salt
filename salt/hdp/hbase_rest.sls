{% set rest_port = pillar['hbase-rest']['port'] %}
{% set info_port = pillar['hbase-rest']['info-port'] %}
{%- set default_java_home_base = '/usr/lib/jvm' %}
{%- set java_home = salt['grains.get']('java_home', salt['pillar.get']('java_home', default_java_home_base + '/java-8-oracle')) %}

/usr/lib/systemd/system/hbase-rest.service:
  file.managed:
    - source: salt://hdp/templates/hbase-daemon.service.tpl
    - mode: 644
    - template: jinja
    - context:
      daemon_service: 'rest'
      daemon_port: {{ rest_port }}
      info_port: {{ info_port }}

# Define JAVA_HOME env variable.
# This is required for hbase that would not start when Java could not be found.
hdp-add-java-home-for-hbase:
  cmd.run:
    - env:
      - JAVA_HOME: {{ java_home }}
    - name: echo "export JAVA_HOME=$JAVA_HOME" >> /etc/hbase/2.6.5.0-292/0/hbase-env.sh

hdp-load-hbase-env:
  cmd.run:
    - name: sh /etc/hbase/2.6.5.0-292/0/hbase-env.sh

hdp-systemctl_reload_hbase_rest:
  cmd.run:
    - name: /bin/systemctl daemon-reload; /bin/systemctl enable hbase-rest

hdp-start_hbase_rest:
  cmd.run:
    - name: 'service hbase-rest stop || echo already stopped; service hbase-rest start'
