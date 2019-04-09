mysql-install-python-library:
  pkg.installed:
    - name: {{ pillar['python-mysqldb']['package-name'] }}
    - version: {{ pillar['python-mysqldb']['version'] }}
    - reload_modules: True
    - fromrepo: pnda_mirror

mysql-install-mysql-client:
  pkg.installed:
    - name: {{ pillar['mysql-client']['package-name'] }}
    - version: {{ pillar['mysql-client']['version'] }}
    - fromrepo: pnda_mirror
