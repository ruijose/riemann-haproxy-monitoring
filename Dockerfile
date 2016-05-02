FROM ruby:2.2

RUN gem install riemann-client
RUN gem install trollop

CMD riemann_haproxy.rb --url ${RIEMANN_SERVER} --interval ${INTERVAL} --page ${HAPROXY_STATUS_PAGE}
