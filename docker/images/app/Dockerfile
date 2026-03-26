# LEGO docker image
# Based on Alpine Linux
FROM alpine:3.23

# Maintainer
LABEL maintainer="Eugene Frost"

# Build settings
ARG USER_UID=1001
ARG USER_GID=1001

# Create user and group
RUN addgroup -g ${USER_GID} app && adduser -D -h /home/app -s /bin/sh -u ${USER_UID} -G app app

# Install software
RUN apk update && \
    apk upgrade && \
    apk add \
    	supervisor \
    	lego

# Clean APK cache
RUN rm -rf /var/cache/apk/*

# Create and fill supervisor configs dir
RUN rm -rf /etc/supervisor && mkdir -p /etc/supervisor
ADD ./etc/supervisor /etc/supervisor
RUN chown -R app:app /etc/supervisor

# Set own rules on supervisor working dirs
RUN mkdir -p /run/supervisord && chown -R app:app /run/supervisord
RUN mkdir -p /var/lib/supervisord && chown -R app:app /var/lib/supervisord
RUN mkdir -p /var/log/supervisord && chown -R app:app /var/log/supervisord

# Add entrypoint script
ADD ./bin/docker-entrypoint.sh /bin/docker-entrypoint.sh
RUN chmod +X /bin/docker-entrypoint.sh
ENTRYPOINT [ "/bin/docker-entrypoint.sh" ]

# Add healthcheck script
ADD ./bin/healthcheck.sh /bin/healthcheck.sh
RUN chmod +X /bin/healthcheck.sh
HEALTHCHECK --interval=30s --timeout=3s CMD /bin/healthcheck.sh

# Set own rules on services working dirs
RUN mkdir -p /home/app && chown -R app:app /home/app
WORKDIR /home/app

# Declare volumes
VOLUME /home/app

# Add helper script
ADD ./bin/certctl /bin/certctl

# Activate non root user
USER app

ENTRYPOINT [ "/bin/docker-entrypoint.sh" ]
CMD [ "/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf" ]