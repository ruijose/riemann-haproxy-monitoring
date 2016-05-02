# riemann-haproxy-monitoring

Script to extract and send metrics from Haproxy load balancer stats page to a riemann server. 

Usage

````
riemann_haproxy.rb --url my.riemann.server --interval 3 --page "username:password@my.haproxy.stats:port/haproxy_stats;csv"
```

With Docker

````
$ docker build -t riemann-haproxy .
$ docker run --name rih -d -e RIEMANN_SERVER=my.riemann.server -e INTERVAL=5 -e HAPROXY_STATUS_PAGE=username:password@my.haproxy.stats:port/haproxy_stats;csv riemann-haproxy
```


