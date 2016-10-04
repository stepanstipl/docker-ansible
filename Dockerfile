FROM alpine:3.4

# This should replace develop git clone
# ENV ANSIBLE_VERSION 2.1.1.0
ENV ANSIBLE_LINT 3.3.3

RUN apk add --no-cache bash \
                     python-dev \
                     python \
                     py-jinja2 \
                     py-yaml \
                     py-pip \
                     py-paramiko \
                     py-markupsafe \
                     py-setuptools \
                     openssl \
                     tzdata \
                     git \
      && git clone https://github.com/ansible/ansible --recursive /ansible \
      && cd /ansible \
      && python setup.py install --prefix=/usr \
      && mkdir -p /etc/ansible \
      && echo localhost >> /etc/ansible/hosts \
      && pip install ansible-lint==${ANSIBLE_LINT} \
      && cp /usr/share/zoneinfo/Europe/London /etc/localtime \
      && echo "Europe/London" >  /etc/timezone \
      && apk del tzdata python-dev \
      && rm -rf /ansible
