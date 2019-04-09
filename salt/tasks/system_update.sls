tasks-update the system:
  cmd.run:
    - name: yum --quiet --skip-broken -y upgrade     
#  pkg.uptodate:
#    - refresh: True
