FROM ubuntu:16.04
LABEL maintainer="AutoBuilder24x7"

ENV pip_packages "ansible pyopenssl"

# Install dependencies.
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       python-software-properties \
       software-properties-common \
       python-setuptools \
       wget rsyslog systemd systemd-cron sudo \
    && apt-get clean \
    && wget https://bootstrap.pypa.io/get-pip.py \
    && python get-pip.py

# Install Ansible via Pip.
RUN pip install $pip_packages

# Install Ansible inventory file.
RUN mkdir -p /etc/ansible
RUN echo "[local]\nlocalhost ansible_connection=local" > /etc/ansible/hosts

CMD ["/lib/systemd/systemd"]
