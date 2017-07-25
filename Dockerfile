FROM fedora:24
MAINTAINER Malcolm Jones <bossjones@theblacktonystark.com>

# Try adding:
# fastestmirror=true
# To your /etc/dnf/dnf.conf. Made a big difference here.

# source: https://hub.docker.com/_/fedora/
# source: https://github.com/fedora-cloud/Fedora-Dockerfiles/blob/master/tools/Dockerfile
ENV container docker
ENV GOSS_VERSION=v0.3.4
ENV GOPATH='/usr/share/golang'

# ENV GOPATH=$HOME/go
ENV PATH=$PATH:$GOPATH/bin
# sudo go get -u github.com/kardianos/govendor

LABEL RUN="docker run -it --name NAME --privileged --ipc=host --net=host --pid=host -e HOST=/host -e NAME=NAME -e IMAGE=IMAGE -v /run:/run -v /var/log:/var/log -v /etc/localtime:/etc/localtime -v /:/host IMAGE"

RUN echo "fastestmirror=True" >> /etc/dnf/dnf.conf

RUN [ -e /etc/yum.conf ] && sed -i '/tsflags=nodocs/d' /etc/yum.conf || true

# Reinstall all packages to get man pages for them
# RUN dnf -y update && dnf -y reinstall "*" && dnf clean all

# Install all useful packages
RUN set -x; \
    dnf -y update && \
    # Reinstall all packages to get man pages for them
    dnf -y reinstall "*" \
    dnf -y remove vim-minimal && \
    dnf -y install \
           abrt \
           bash-completion \
           bc \
           blktrace \
           btrfs-progs \
           crash \
           dnf-plugins-core \
           docker \
           docker-selinux \
           e2fsprogs \
           ethtool \
           file \
           findutils \
           fpaste \
           gcc \
           gdb \
           gdb-gdbserver \
           git \
           glibc-common \
           glibc-utils \
           hwloc \
           iotop \
           iproute \
           iputils \
           kernel \
        #    kubernetes-client \
        #    kubernetes-devel \
        #    kubernetes-master \
        #    kubernetes-node \
           less \
           ltrace \
           mailx \
           man-db \
           nc \
           netsniff-ng \
           net-tools \
           numactl \
           numactl-devel \
           ostree \
           passwd \
           pciutils \
           pcp \
           perf \
           procps-ng \
           psmisc \
           python-dnf-plugins-extras* \
           python-docker-py \
           python-rhsm \
           rootfiles \
           rpm-ostree \
           screen \
           sos \
           strace \
           subscription-manager \
           sysstat \
           systemtap \
           systemtap-client \
           tar \
           tcpdump \
           vim-enhanced \
           which \
           xauth && \

    dnf update -y; \
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
    pip3 install virtualenv virtualenvwrapper ipython; \
    cd /root; \
    git clone https://github.com/brendangregg/perf-tools.git; \
    git clone https://github.com/iovisor/bcc; \
    pip install cheat && \

    dnf update -y && \
    dnf install -y clang file findutils gcc git llvm redhat-rpm-config tar \
    {clang,zlib}-devel \
    findutils git golang make npm python-virtualenv ruby-devel rubygem-bundler tar which && \
    go get -u github.com/kardianos/govendor && \
    dnf groupinstall -y  "Development Tools" && \
    # Add goss for local, serverspec-like testing
    curl -L https://github.com/aelsabbahy/goss/releases/download/${GOSS_VERSION}/goss-linux-amd64 -o /usr/local/bin/goss && \
    chmod +x /usr/local/bin/goss && \

    mkdir -p ${GOPATH} \
    && (go get -u -v sourcegraph.com/sourcegraph/srclib/cmd/srclib \
    && cd /usr/bin/ && go build sourcegraph.com/sourcegraph/srclib/cmd/srclib) \
    && srclib toolchain install go ruby javascript python \
    && curl -L https://raw.githubusercontent.com/nicolargo/glancesautoinstall/master/install.sh | /bin/bash \
    && dnf clean all \
    && rm -rf /var/cache/dnf


        #    && dnf clean all

# RUN dnf update -y; \
#     dnf group install "C Development Tools and Libraries" -y; \
#     dnf install -y wget curl vim \
#                   glibc-langpack-en.x86_64 \
#                   redhat-rpm-config htop perf \
#                   tcpdump nmap lsof strace dstat \
#                   ngrep iotop socat sysstat procps-ng \
#                   net-tools file atop ltrace bridge-utils \
#                   ca-certificates iftop iperf iproute bash \
#                   bash-completion gettext ncurses hdparm psmisc \
#                   tree speedtest-cli pv sslscan nmon collectl \
#                   sos iputils net-tools iperf3 qperf iproute tcpdump \
#                   tar file python-devel git mysql \
#                   && curl -Lo /usr/local/bin/xsos bit.ly/xsos-direct && chmod +x /usr/local/bin/xsos && \
#                   pip install zeroconf netifaces pymdstat influxdb elasticsearch potsdb statsd pystache docker-py \
#                   pysnmp pika py-cpuinfo bernhard scandir; \
#     cd /usr/local/bin/; \
#     wget https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/memcache-top/memcache-top-v0.6; \
#     mv memcache-top-v0.6 memcache-top; \
#     chmod +x memcache-top; \
#     yum install -y perl perl-Time-HiRes perl-Getopt-Long.noarch; \
#     cd /usr/local/src/; \
#     curl -s -q -L 'https://bootstrap.pypa.io/ez_setup.py' > ez_setup.py; \
#     curl -s -q -L 'https://bootstrap.pypa.io/get-pip.py' > get-pip.py; \
#     python ez_setup.py; \
#     python get-pip.py; \
#     pip install -I path.py==7.7.1; \
#     pip install memcache-cli; \
#     dnf install python3-devel -y; \
#     cd /usr/local/src/; \
#     python3 ez_setup.py; \
#     python3 get-pip.py; \
#     pip3 install -I path.py==7.7.1; \
#     cd /root; \
#     git clone https://github.com/brendangregg/perf-tools.git; \
#     git clone https://github.com/iovisor/bcc; \
#     pip install cheat

# RUN set -x; \
#     dnf update -y && \
#     dnf install -y dnf install -y clang file findutils gcc git llvm redhat-rpm-config tar \
#     {clang,zlib}-devel \
#     findutils git golang make npm python-virtualenv ruby-devel rubygem-bundler tar which && \
#     dnf groupinstall -y  "Development Tools" \
#     # Add goss for local, serverspec-like testing
#     curl -L https://github.com/aelsabbahy/goss/releases/download/${GOSS_VERSION}/goss-linux-amd64 -o /usr/local/bin/goss && \
#     chmod +x /usr/local/bin/goss \
#     && dnf clean all \
#     && rm -rf /var/cache/dnf

# ENV GOPATH='/usr/share/golang'

# RUN mkdir -p ${GOPATH}\
#  && (go get -u -v sourcegraph.com/sourcegraph/srclib/cmd/srclib\
#   && cd /usr/bin/ && go build sourcegraph.com/sourcegraph/srclib/cmd/srclib)\
#  && srclib toolchain install go ruby javascript python \
#  && rm -rf /var/cache/dnf

# Glances
# RUN curl -L https://raw.githubusercontent.com/nicolargo/glancesautoinstall/master/install.sh | /bin/bash

# EXPOSE PORT (For XMLRPC)
EXPOSE 61209

# EXPOSE PORT (For Web UI)
EXPOSE 61208

# Define default command.
# CMD python -m glances -C /glances/conf/glances.conf $GLANCES_OPT

COPY ./ngrep /usr/lib/python3.5/site-packages/cheat/cheatsheets/ngrep
COPY ./sysdig /usr/lib/python3.5/site-packages/cheat/cheatsheets/sysdig

# Set default command
CMD ["/usr/bin/bash"]
