ARG NODE_VERSION
FROM node:${NODE_VERSION}

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        locales && \
    localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 && \
    rm -rf /var/lib/apt/lists/*

ENV LANG en_US.utf8

ARG NODE_USER_NAME
ARG NODE_USER_ID
ARG NODE_GROUP_NAME
ARG NODE_GROUP_ID

# FIXME: this works, but is not very elegant :/
RUN id -un ${NODE_USER_ID} && userdel $(id -un ${NODE_USER_ID}) || true
RUN id -gn ${NODE_GROUP_ID} && groupdel $(id -gn ${NODE_GROUP_ID}) || true
RUN test -d /home/${NODE_USER_NAME} && rm -rf /home/${NODE_USER_NAME} || true
RUN groupadd \
        --gid ${NODE_GROUP_ID} \
        ${NODE_GROUP_NAME} && \
    useradd \
        --create-home \
        --home-dir /home/${NODE_USER_NAME} \
        --uid ${NODE_USER_ID} \
        --gid ${NODE_GROUP_ID} \
        ${NODE_USER_NAME}

# RUN chown -R ${NODE_USER_ID}.${NODE_GROUP_ID} /usr/local/lib/node_modules
# RUN chown -R ${NODE_USER_ID}.${NODE_GROUP_ID} /usr/local/bin

USER ${NODE_USER_NAME}

CMD ["/bin/bash"]
