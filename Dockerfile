# Latest version of centos

FROM centos:7.6.1810

LABEL gooner <tongchao0923@gmail.com>

RUN yum clean all && \
    yum install -y epel-release && \
    yum install -y curl net-tools iproute && \
    rm -rf /var/cache/yum

RUN curl -L https://github.com/trojan-gfw/trojan/releases/download/v1.16.0/trojan-1.16.0-linux-amd64.tar.xz | tar -J -xv

WORKDIR /trojan
ENV PATH=$PATH:/trojan

ENTRYPOINT [ "/trojan/trojan", "-c", "/trojan/config.json"]
