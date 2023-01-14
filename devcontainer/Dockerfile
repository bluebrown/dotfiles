ARG baseimage=debian
FROM ${baseimage}

RUN apt-get -y update && apt-get -y install sudo curl git

ARG uid="1000"
ARG gid="$uid"

RUN echo "dev ALL=(ALL) NOPASSWD: ALL" >>/etc/sudoers
RUN groupadd --gid "$gid" dev
RUN useradd --uid "$uid" --gid "$gid" -m -s /bin/bash dev

USER "$uid"

WORKDIR /usr/home/dev
CMD ["/bin/bash", "-l"]

RUN git clone https://github.com/bluebrown/dotfiles.git
RUN cd dotfiles \
  && bash scripts/tools_base.sh \
  && bash scripts/configure.sh \
  && bash scripts/tools_dev.sh

ENV PATH="$PATH:/usr/local/sbin"
