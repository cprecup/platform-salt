hdp-httpfs_server_pkg_install:
  pkg.installed:
     - name: hadoop-httpfs-server
     - version: {{ pillar['hadoop-httpfs-server']['package-version'] }}
     - ignore_epoch: True
     - fromrepo: HDP-2.6-repo-1

hdp-httpfs_pkg_install:
  pkg.installed:
     - name: hadoop-httpfs
     - version: {{ pillar['hadoop-httpfs']['package-version'] }}
     - ignore_epoch: True
     - fromrepo: HDP-2.6-repo-1

hdp-httpfs_pnda_log_directory:
  file.directory:
    - name: /var/log/pnda/httpfs
    - makedirs: True
    - user: httpfs
    - group: hadoop
    - mode: 755

hdp-httpfs_webapp_link:
  file.symlink:
    - name: /etc/hadoop-httpfs/tomcat-deployment/webapps
    - target: /usr/hdp/current/hadoop-httpfs/webapps
    - user: httpfs
    - group: hadoop

hdp-httpfs_service_unit:
  file.managed:
    - name: /usr/lib/systemd/system/hadoop-httpfs.service
    - source: salt://hdp/templates/hadoop-httpfs.service.tpl
    - mode: 644
    - template: jinja

hdp-httpfs_service_started:
  service.running:
    - name: hadoop-httpfs
    - enable: True
    - reload: True
