FROM bitnami/minideb:stretch
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV OS_ARCH="amd64" \
    OS_FLAVOUR="debian-9" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl iproute2 ldap-utils libaio1 libaudit1 libc6 libcap-ng0 libgcc1 libjemalloc1 libncurses5 libnss-ldapd libpam-ldapd libpam0g libssl1.0.2 libstdc++6 libtinfo5 lsof nslcd procps rsync socat unzip zlib1g
RUN . ./libcomponent.sh && component_unpack "mariadb-galera" "10.3.20-1" --checksum 9951cec43d09edff277c5adadbbdcd12ea763b1939ffc656cfff89f48c7b66d3
RUN curl --silent -L https://github.com/tianon/gosu/releases/download/1.11/gosu-amd64 > /usr/local/bin/gosu && echo 0b843df6d86e270c5b0f5cbd3c326a04e18f4b7f9b8457fa497b0454c4b138d7 /usr/local/bin/gosu | sha256sum --check && chmod u+x /usr/local/bin/gosu && mkdir -p /opt/bitnami/licenses && curl --silent -L https://raw.githubusercontent.com/tianon/gosu/master/LICENSE > /opt/bitnami/licenses/gosu-1.11.txt
RUN mkdir /docker-entrypoint-initdb.d

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="mariadb-galera" \
    BITNAMI_IMAGE_VERSION="10.3.20-debian-9-r14" \
    PATH="/opt/bitnami/mariadb/bin:/opt/bitnami/mariadb/sbin:$PATH"

EXPOSE 3306 4444 4567 4568

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
