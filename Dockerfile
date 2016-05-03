FROM ruby:2.2

RUN gem install riemann-client
RUN gem install trollop

WORKDIR /haproxy

ADD riemann_haproxy.rb /haproxy/riemann_haproxy.rb

CMD riemann_haproxy.rb --url ${RIEMANN_SERVER} --interval ${INTERVAL} --page ${HAPROXY_STATUS_PAGE}
