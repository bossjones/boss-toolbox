FROM fedora:24
MAINTAINER Malcolm Jones <bossjones@theblacktonystark.com>

# source: https://hub.docker.com/_/fedora/
# source: https://github.com/fedora-cloud/Fedora-Dockerfiles/blob/master/tools/Dockerfile
ENV container docker
ENV GOSS_VERSION=v0.3.4
ENV GOPATH='/usr/share/golang'
ENV PATH=${PATH}:${GOPATH}/bin


LABEL RUN="docker run -it --name NAME --privileged --ipc=host --net=host --pid=host -e HOST=/host -e NAME=NAME -e IMAGE=IMAGE -v /run:/run -v /var/log:/var/log -v /etc/localtime:/etc/localtime -v /:/host IMAGE"

RUN echo "fastestmirror=True" >> /etc/dnf/dnf.conf
RUN [ -e /etc/yum.conf ] && sed -i '/tsflags=nodocs/d' /etc/yum.conf || true

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
    git clone https://github.com/iovisor/ply.git; \
    git clone https://github.com/opendtrace/toolkit.git dtrace-toolkit; \
    git clone https://github.com/opendtrace/scripts.git dtrace-scripts; \
    git clone https://github.com/brendangregg/FlameGraph; \
    git clone https://github.com/agentzh/perl-systemtap-toolkit.git; \
    git clone https://github.com/openresty/openresty-systemtap-toolkit.git; \
    git clone https://github.com/derekparker/delve.git; \
    git clone https://github.com/brendangregg/Misc.git perf-misc-info; \
    git clone https://github.com/jvm-profiling-tools/perf-map-agent.git jvm-profiling-tools-perf-map-agent; \
    pip install cheat && \

    dnf update -y && \
    dnf install -y clang file findutils gcc cmake git llvm redhat-rpm-config tar \
    {clang,zlib}-devel \
    findutils git java java-devel golang scala make npm python-virtualenv ruby-devel rubygem-bundler tar which && \
    go get -u github.com/kardianos/govendor && \
    dnf groupinstall -y  "Development Tools" && \
    # Add goss for local, serverspec-like testing
    curl -L https://github.com/aelsabbahy/goss/releases/download/${GOSS_VERSION}/goss-linux-amd64 -o /usr/local/bin/goss && \
    chmod +x /usr/local/bin/goss && \
    if [ "${SKIP_DEBUG_PACKAGES}" == "" ]; then dnf debuginfo-install -y cmake scala nginx clang java coreutils glibc-debuginfo kernel-debuginfo perl-debuginfo python-debuginfo; fi && \
    dnf install -y 'graphviz*' && \

    mkdir -p ${GOPATH} \
    && (go get -u -v sourcegraph.com/sourcegraph/srclib/cmd/srclib \
    && cd /usr/bin/ && go build sourcegraph.com/sourcegraph/srclib/cmd/srclib) \
    # && srclib toolchain install go ruby javascript python \
    # && src toolchain install-std \
    && go get github.com/uber/go-torch \
    && curl -L https://raw.githubusercontent.com/nicolargo/glancesautoinstall/master/install.sh | /bin/bash \
    && wget https://github.com/bcicen/ctop/releases/download/v0.6.0/ctop-0.6.0-linux-amd64 -O /usr/local/bin/ctop \
    && chmod +x /usr/local/bin/ctop \
    && dnf clean all \
    && rm -rf /var/cache/dnf

ENV JAVA_HOME /usr/lib/jvm/java-openjdk

# EXPOSE PORT (For XMLRPC) - glances
EXPOSE 61209

# EXPOSE PORT (For Web UI) - glances
EXPOSE 61208

COPY ./ngrep /usr/lib/python3.5/site-packages/cheat/cheatsheets/ngrep
COPY ./sysdig /usr/lib/python3.5/site-packages/cheat/cheatsheets/sysdig
COPY ./sysdig /usr/lib/python3.5/site-packages/cheat/cheatsheets/perf

# Set default command
CMD ["/usr/bin/bash"]
