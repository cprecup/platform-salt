{
  "name": "default",
  "description": "default quick links configuration",
  "configuration": {
    "protocol":
    {
      "type":"https",
      "checks":[
        {
          "property":"mapreduce.jobhistory.http.policy",
          "desired":"HTTPS_ONLY",
          "site":"mapred-site"
        }
      ]
    },

    "links": [
      {
        "name": "jobhistory_ui",
        "label": "JobHistory UI",
        "requires_user_name": "false",
        "url": "{{ service_proxy_url }}",
        "port":{
          "http_property": "mapreduce.jobhistory.webapp.address",
          "http_default_port": "19888",
          "https_property": "mapreduce.jobhistory.webapp.https.address",
          "https_default_port": "8090",
          "regex": "\\w*:(\\d+)",
          "site": "mapred-site"
        }
      },
      {
        "name": "jobhistory_logs",
        "label": "JobHistory logs",
        "requires_user_name": "false",
        "url": "{{ service_proxy_url }}/logs",
        "port":{
          "http_property": "mapreduce.jobhistory.webapp.address",
          "http_default_port": "19888",
          "https_property": "mapreduce.jobhistory.webapp.https.address",
          "https_default_port": "8090",
          "regex": "\\w*:(\\d+)",
          "site": "mapred-site"
        }
      },
      {
        "name":"jobhistory_jmx",
        "label":"JobHistory JMX",
        "requires_user_name":"false",
        "url":"{{ service_proxy_url }}/jmx",
        "port":{
          "http_property": "mapreduce.jobhistory.webapp.address",
          "http_default_port": "19888",
          "https_property": "mapreduce.jobhistory.webapp.https.address",
          "https_default_port": "8090",
          "regex": "\\w*:(\\d+)",
          "site": "mapred-site"
        }
      },
      {
        "name":"thread_stacks",
        "label":"Thread Stacks",
        "requires_user_name": "false",
        "url":"{{ service_proxy_url }}/stacks",
        "port":{
          "http_property": "mapreduce.jobhistory.webapp.address",
          "http_default_port": "19888",
          "https_property": "mapreduce.jobhistory.webapp.https.address",
          "https_default_port": "8090",
          "regex": "\\w*:(\\d+)",
          "site": "mapred-site"
        }
      }
    ]
  }
}