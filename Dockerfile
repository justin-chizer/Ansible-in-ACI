FROM ubuntu:18.04

RUN apt-get update && apt-get install -y \
    curl \
    python \
    python-yaml \
    python-jinja2 \
    python-httplib2 \
    python-keyczar \
    python-paramiko \
    python-setuptools \
    python-pkg-resources \
    git \
    python-pip \
    sshpass \
    openssh-client \
    bash \
    tar 

RUN pip install --upgrade pip
RUN apt install -y software-properties-common && \
    apt-add-repository --yes --update ppa:ansible/ansible && \
    apt install -y ansible

RUN echo "[workers]" >> /etc/ansible/hosts && \
    echo "10.1.1.4 ansible_user=azureuser ansible_ssh_pass=Password123!" >> /etc/ansible/hosts

# Copy playbook to workdir
COPY playbook.yml .
# Makes the playbooks directory the working directory

# Sets environment variables
ENV ANSIBLE_GATHERING smart
ENV ANSIBLE_HOST_KEY_CHECKING False
ENV ANSIBLE_RETRY_FILES_ENABLED False
ENV ANSIBLE_ROLES_PATH /ansible/playbooks/roles
ENV ANSIBLE_SSH_PIPELINING True
ENV PATH /ansible/bin:$PATH
ENV PYTHONPATH /ansible/lib

# Sets entry point (same as running ansible-playbook)
ENTRYPOINT ["ansible-playbook", "playbook.yml"]
# Can also use ["ansible"] if wanting it to be an ad-hoc command version
#ENTRYPOINT ["ansible"]