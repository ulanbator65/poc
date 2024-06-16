FROM --platform=linux/amd64 nvidia/cuda:12.0.1-devel-ubuntu20.04

ARG DEBIAN_FRONTEND=noninteractive
ENV DEBIAN_FRONTEND=noninteractive
ARG account=0x7c8d21F88291B70c1A05AE1F0Bc6B53E52c4f28a
ENV ACCOUNT=$account

RUN apt-get update
RUN apt-get install -y sudo git tzdata build-essential openssh-server
RUN mkdir -p /run/sshd

WORKDIR /root

COPY onstart.sh onstart.sh
RUN chmod 700 onstart.sh

WORKDIR /root/poc

COPY . .

RUN chmod -R 700 scripts

RUN DEBIAN_FRONTEND=noninteractive && \
    CUDA_ARCH_SM=sm_86 && \
    scripts/install.sh

RUN rm account.txt

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
