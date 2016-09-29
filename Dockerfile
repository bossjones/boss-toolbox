FROM fedora:latest
MAINTAINER Malcolm Jones <bossjones@theblacktonystark.com>

RUN yum update -y && dnf install -y htop perf tcpdump nmap lsof strace \
      dstat ngrep iotop socat sysstat procps-ng \
      net-tools file atop ltrace bridge-utils \
      ca-certificates iftop iperf iproute \
      bash bash-completion gettext \
      ncurses hdparm psmisc tree \
      speedtest-cli pv sslscan \
      nmon collectl

RUN curl -Lo /usr/local/bin/xsos bit.ly/xsos-direct && chmod +x /usr/local/bin/xsos
