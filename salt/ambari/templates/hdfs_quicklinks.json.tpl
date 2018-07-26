{
  "name": "default",
  "description": "default quick links configuration",
  "configuration": {
    "protocol":
    {
      "type":"https",
      "checks":[
        {
          "property":"dfs.http.policy",
          "desired":"HTTPS_ONLY",
          "site":"hdfs-site"
        }
      ]
    },

    "links": [
      {
        "name": "namenode_ui",
        "label": "NameNode UI",
        "url":"{{ service_proxy_url }}/",
        "requires_user_name": "false",
        "port":{
          "http_property": "dfs.namenode.http-address",
          "http_default_port": "50070",
          "https_property": "dfs.namenode.https-address",
          "https_default_port": "50470",
          "regex": "\\w*:(\\d+)",
          "site": "hdfs-site"
        }
      },
      {
        "name": "namenode_logs",
        "label": "NameNode Logs",
        "url":"{{ service_proxy_url }}/logs",
        "requires_user_name": "false",
        "port":{
          "http_property": "dfs.namenode.http-address",
          "http_default_port": "50070",
          "https_property": "dfs.namenode.https-address",
          "https_default_port": "50470",
          "regex": "\\w*:(\\d+)",
          "site": "hdfs-site"
        }
      },
      {
        "name": "namenode_jmx",
        "label": "NameNode JMX",
        "url":"{{ service_proxy_url }}/jmx",
        "requires_user_name": "false",
        "port":{
          "http_property": "dfs.namenode.http-address",
          "http_default_port": "50070",
          "https_property": "dfs.namenode.https-address",
          "https_default_port": "50470",
          "regex": "\\w*:(\\d+)",
          "site": "hdfs-site"
        }
      },
      {
        "name": "Thread Stacks",
        "label": "Thread Stacks",
        "url":"{{ service_proxy_url }}/stacks",
        "requires_user_name": "false",
        "port":{
          "http_property": "dfs.namenode.http-address",
          "http_default_port": "50070",
          "https_property": "dfs.namenode.https-address",
          "https_default_port": "50470",
          "regex": "\\w*:(\\d+)",
          "site": "hdfs-site"
        }
      }
    ]
  }
}