FROM ruby3-systemd

COPY app/ /usr/local/app-puma4/
COPY app/ /usr/local/app-puma5/
COPY app/ /usr/local/app-puma4-fix/
COPY app/ /usr/local/app-puma5-fix/

# server-starter (Go version)
RUN curl -L https://github.com/lestrrat-go/server-starter/releases/download/0.0.2/start_server_linux_amd64.tar.gz -o /start_server_linux_amd64.tar.gz
RUN tar xf /start_server_linux_amd64.tar.gz && mv /start_server_linux_amd64/start_server /start_server

# Puma4
WORKDIR /usr/local/app-puma4
RUN bundle config set path ./vendor/bundle
RUN bundle install
COPY systemd/app.service /etc/systemd/system/app@puma4.service
COPY systemd/socat.service /etc/systemd/system/socat@puma4.service
RUN sed -i -e 's/PORT/10080/' /etc/systemd/system/socat@puma4.service
RUN systemctl enable app@puma4.service
RUN systemctl enable socat@puma4.service

# Puma5
WORKDIR /usr/local/app-puma5
RUN mv Gemfile.puma5 Gemfile
RUN bundle config set path ./vendor/bundle
RUN bundle install
COPY systemd/app.service /etc/systemd/system/app@puma5.service
COPY systemd/socat.service /etc/systemd/system/socat@puma5.service
RUN sed -i -e 's/PORT/10081/' /etc/systemd/system/socat@puma5.service
RUN systemctl enable app@puma5.service
RUN systemctl enable socat@puma5.service

# Puma4 with fix
WORKDIR /usr/local/app-puma4-fix
RUN bundle config set path ./vendor/bundle
RUN bundle install
COPY systemd/app.service /etc/systemd/system/app@puma4-fix.service
COPY systemd/socat.service /etc/systemd/system/socat@puma4-fix.service
COPY puma_listener_fix.rb vendor/bundle/ruby/3.0.0/gems/server-starter-0.3.1/lib/server/starter/puma_listener.rb
RUN sed -i -e 's/PORT/10082/' /etc/systemd/system/socat@puma4-fix.service
RUN systemctl enable app@puma4-fix.service
RUN systemctl enable socat@puma4-fix.service

# Puma5 with fix
WORKDIR /usr/local/app-puma5-fix
RUN mv Gemfile.puma5 Gemfile
RUN bundle config set path ./vendor/bundle
RUN bundle install
COPY systemd/app.service /etc/systemd/system/app@puma5-fix.service
COPY systemd/socat.service /etc/systemd/system/socat@puma5-fix.service
RUN sed -i -e 's/PORT/10083/' /etc/systemd/system/socat@puma5-fix.service
COPY puma_listener_fix.rb vendor/bundle/ruby/3.0.0/gems/server-starter-0.3.1/lib/server/starter/puma_listener.rb
RUN systemctl enable app@puma5-fix.service
RUN systemctl enable socat@puma5-fix.service

EXPOSE 10080 10081 10082 10083
