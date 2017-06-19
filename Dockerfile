FROM alpine:3.6

ENV ANSIBLE_VERSION v2.3.1.0-1
ENV ANSIBLE_LINT 3.4.13
ENV ANSIBLE_CLI 1.11.107
ENV ANSIBLE_HOME /ansible

ENV MANPATH=${ANSIBLE_HOME}/docs/man:
ENV PATH=${ANSIBLE_HOME}/bin:${PATH}
ENV PYTHONPATH=${ANSIBLE_HOME}/lib
ENV USER=ansible

RUN apk add --no-cache bash \
                     ca-certificates \
                     git \
                     openssh-client \
                     openssl \
                     py-crypto \
                     py-jinja2 \
                     py-markupsafe \
                     py-paramiko \
                     py-pip \
                     py-setuptools \
                     py-yaml \
                     python \
                     python-dev \
                     tzdata \
      && git clone https://github.com/ansible/ansible --branch "${ANSIBLE_VERSION}" --recursive --depth 1 "${ANSIBLE_HOME}" \
      && cd "${ANSIBLE_HOME}" \
      && source ./hacking/env-setup \
      && mkdir -p /etc/ansible \
      && echo localhost >> /etc/ansible/hosts \
      && pip install ansible-lint==${ANSIBLE_LINT} \
                     awscli==${ANSIBLE_CLI} \
                     boto \
                     boto3 \
                     netaddr \
                     requests \
      && cp /usr/share/zoneinfo/Europe/London /etc/localtime \
      && echo "Europe/London" >  /etc/timezone \
      && apk del tzdata python-dev \
      && mkdir -p /root/.ssh \
      && ssh-keyscan -H github.com >> /root/.ssh/known_hosts \
      && adduser -h "${ANSIBLE_HOME}" -s /sbin/nologin -u 1000 -D ansible

WORKDIR ${ANSIBLE_HOME}
