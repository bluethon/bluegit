Jenkins Note
============

Scripts
-------

### 导出插件列表(plugins.txt)

> <http://host/script>

``` groovy
Jenkins.instance.pluginManager.plugins.each{
  plugin ->
    println ("${plugin.getShortName()}:${plugin.getVersion()}")
}
```

### Gitlab API token(https)

> <https://github.com/jenkinsci/gitlab-plugin/wiki/Setup-Example>

    Ignore SSL Certificate Errors=true
