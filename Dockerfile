FROM ubuntu:18.04
LABEL maintainer="AutoBuilder24x7"

# Install dependencies.
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       apt-utils \
       locales python-dev \
       python-setuptools \
       python-pip \
       software-properties-common \
       rsyslog systemd systemd-cron sudo iproute2 \
    && apt-get clean

RUN apt-get install -y gcc

# Install Ansible via Pip.
RUN pip install --upgrade wheel
RUN pip install pyopenssl
RUN pip install ansible
RUN pip install ansible-lint
RUN pip install molecule

# Install Ansible inventory file.
RUN mkdir -p /etc/ansible
RUN echo "[local]\nlocalhost ansible_connection=local" > /etc/ansible/hosts

CMD ["/lib/systemd/systemd"]
