# The base image is the latest 8.x node (LTS)
FROM node:8.9.4-wheezy

RUN npm install -g pm2

ENV NODEBB_VERSION=v1.7.x \
    NODEBB_UPLOADS_CONTENT=/var/lib/nodebb/public/uploads \
    # NODEBB_CONFIG=/var/lib/nodebb/config.json \
    daemon=false \
    silent=false

RUN git clone -b "$NODEBB_VERSION" https://github.com/NodeBB/NodeBB.git /var/lib/nodebb

WORKDIR /var/lib/nodebb

VOLUME $NODEBB_UPLOADS_CONTENT

# VOLUME $NODEBB_CONFIG

COPY config.json /var/lib/nodebb

RUN cp /var/lib/nodebb/install/package.json /var/lib/nodebb

RUN npm install && npm cache clean --force

RUN ./nodebb build

RUN ./nodebb upgrade

# may need to execute after running container to get admin user/pwd
# RUN ./nodebb setup

CMD ./nodebb start

EXPOSE 4567
