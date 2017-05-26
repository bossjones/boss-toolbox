FROM fedora:latest
MAINTAINER Malcolm Jones <bossjones@theblacktonystark.com>

RUN dnf update -y; \
    dnf group install "C Development Tools and Libraries" -y; \
    dnf install -y wget curl vim \
                  glibc-langpack-en.x86_64 \
                  redhat-rpm-config htop perf \
                  tcpdump nmap lsof strace dstat \
                  ngrep iotop socat sysstat procps-ng \
                  net-tools file atop ltrace bridge-utils \
                  ca-certificates iftop iperf iproute bash \
                  bash-completion gettext ncurses hdparm psmisc \
                  tree speedtest-cli pv sslscan nmon collectl \
                  sos iputils net-tools iperf3 qperf iproute tcpdump \
                  tar file python-devel git mysql \
                  && curl -Lo /usr/local/bin/xsos bit.ly/xsos-direct && chmod +x /usr/local/bin/xsos && \
                  pip install zeroconf netifaces pymdstat influxdb elasticsearch potsdb statsd pystache docker-py \
                  pysnmp pika py-cpuinfo bernhard scandir; \
    cd /usr/local/bin/; \
    wget https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/memcache-top/memcache-top-v0.6; \
    mv memcache-top-v0.6 memcache-top; \
    chmod +x memcache-top; \
    yum install -y perl perl-Time-HiRes perl-Getopt-Long.noarch; \
    cd /usr/local/src/; \
    curl -s -q -L 'https://bootstrap.pypa.io/ez_setup.py' > ez_setup.py; \
    curl -s -q -L 'https://bootstrap.pypa.io/get-pip.py' > get-pip.py; \
    python ez_setup.py; \
    python get-pip.py; \
    pip install -I path.py==7.7.1; \
    pip install memcache-cli; \
    dnf install python3-devel -y; \
    cd /usr/local/src/; \
    python3 ez_setup.py; \
    python3 get-pip.py; \
    pip3 install -I path.py==7.7.1; \
    cd /root; \
    git clone https://github.com/brendangregg/perf-tools.git; \
    git clone https://github.com/iovisor/bcc; \
    pip install cheat

COPY ./ngrep /usr/lib/python3.5/site-packages/cheat/cheatsheets/ngrep
COPY ./sysdig /usr/lib/python3.5/site-packages/cheat/cheatsheets/sysdig

ENTRYPOINT ["/bin/bash"]
CMD true