# riemann-haproxy-monitoring

Script to extract and send metrics from Haproxy load balancer stats page to a riemann server. 

Usage

````
riemann_haproxy.rb --url my.riemann.server --interval 3 --page "username:password@my.haproxy.stats:port/haproxy_stats;csv"
```


