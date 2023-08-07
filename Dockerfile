FROM ubuntu
LABEL maintainer="Julio Gutierrez julio.guti+nordvpn@pm.me"

ARG NORDVPN_VERSION=3.14.1
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y && \
    apt-get install -y deluged deluge-web deluge-console && \
    apt-get install -y curl iputils-ping libc6 wireguard && \
    curl https://repo.nordvpn.com/deb/nordvpn/debian/pool/main/nordvpn-release_1.0.0_all.deb --output /tmp/nordrepo.deb && \
    apt-get install -y /tmp/nordrepo.deb && \
    apt-get update -y && \
    apt-get install -y nordvpn  && \
    apt-get remove -y nordvpn-release && \
    apt-get autoremove -y && \
    apt-get autoclean -y && \
    rm -rf \
		/tmp/* \
		/var/cache/apt/archives/* \
		/var/lib/apt/lists/* \
		/var/tmp/*

EXPOSE 8112 58846 58946 58946/udp
VOLUME /home/user/.config/deluge /downloads /watch

COPY /rootfs /
ENV S6_CMD_WAIT_FOR_SERVICES=1
CMD deluged && deluge-web && nord_login && nord_config && nord_connect && nord_migrate && nord_watch
