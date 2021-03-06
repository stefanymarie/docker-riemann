# BUILD: sudo docker build -t acaleph/riemann .
# RUN: sudo docker run -d -v /etc/riemann:/etc/riemann -p 5555:5555 -p 5556:5556 acaleph/riemann

FROM ubuntu:trusty
MAINTAINER acaleph "admin@acale.ph"

# Ensure UTF-8
RUN locale-gen en_US.UTF-8
ENV LANG       en_US.UTF-8
ENV LC_ALL     en_US.UTF-8

# Hack for initctl not being available in Ubuntu
# RUN dpkg-divert --local --rename --add /sbin/initctl
# RUN ln -sf /bin/true /sbin/initctl

# Repo and packages
RUN echo deb http://archive.ubuntu.com/ubuntu trusty main | tee /etc/apt/sources.list
RUN echo deb http://archive.ubuntu.com/ubuntu trusty-updates main | tee -a /etc/apt/sources.list
RUN echo deb http://archive.ubuntu.com/ubuntu trusty universe | tee -a /etc/apt/sources.list
RUN echo deb http://archive.ubuntu.com/ubuntu trusty-updates universe | tee -a /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y --force-yes wget lsb-release sudo

#####

RUN apt-get install -y openjdk-7-jre-headless

RUN wget -q http://aphyr.com/riemann/riemann_0.2.4_all.deb
RUN dpkg -i riemann_0.2.4_all.deb

EXPOSE 5555 5555/udp 5556
#USER riemann
VOLUME ["/etc/riemann"]

ADD run /usr/local/bin/run
RUN chmod +x /usr/local/bin/run
CMD ["/usr/local/bin/run"]
#ENTRYPOINT ["/usr/bin/riemann"]
