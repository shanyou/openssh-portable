FROM ubuntu:18.04
MAINTAINER Shan You <shanyou@htyunwang.com>
LABEL Vendor="yunlu"

# install dep
RUN mkdir /var/lib/sshd \
&& mkdir /opt/openssh \
&& chmod -R 700 /var/lib/sshd/ \
&& chown -R root:sys /var/lib/sshd/ \
&& useradd -r -U -d /var/lib/sshd/ -c "sshd privsep" -s /bin/false sshd

RUN apt update -y \
&& apt install build-essential zlib1g-dev libssl-dev autoconf libpam0g-dev -y

COPY . /opt/openssh

# compile
RUN cd /opt/openssh \
&& autoreconf \
&& ./configure --with-md5-passwords --with-pam --with-privsep-path=/var/lib/sshd/ --sysconfdir=/etc/ssh \
&& make \
&& make install

RUN cp /opt/openssh/deploy/sshd-banner /etc/ssh/sshd-banner \
&& cp /opt/openssh/deploy/sshd_config /etc/ssh/sshd_config \
&& cp /opt/openssh/deploy/ssh-start /usr/local/bin/ssh-start \
&& chmod +x /usr/local/bin/ssh-start

RUN mkdir /root/.ssh

EXPOSE 22

ENTRYPOINT ["ssh-start"]
CMD ["ssh-server"]