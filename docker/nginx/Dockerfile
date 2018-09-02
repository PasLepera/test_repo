FROM nginx:latest

WORKDIR /etc/nginx
RUN mkdir -p /etc/nginx/sites-enabled

COPY ./confd /etc/confd
COPY ./nginx.sh /nginx.sh
RUN chmod +x /nginx.sh

RUN rm /var/log/nginx/access.log /var/log/nginx/error.log

# Install dumb-init for entrypoint
ENV DUMBINIT_VERSION=1.2.1

ADD https://github.com/Yelp/dumb-init/releases/download/v${DUMBINIT_VERSION}/dumb-init_${DUMBINIT_VERSION}_amd64 /usr/local/bin/dumb-init
RUN chmod +x /usr/local/bin/dumb-init

# Install CONFD daemon tobe able to deploy nginx config templates
ENV CONFD_VERSION=0.15.0

ADD https://github.com/kelseyhightower/confd/releases/download/v${CONFD_VERSION}/confd-${CONFD_VERSION}-linux-amd64 /usr/local/bin/confd
RUN chmod +x /usr/local/bin/confd && \
    ln -sf /dev/stderr /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log

CMD ["/nginx.sh"]

EXPOSE 80
