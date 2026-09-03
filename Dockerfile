FROM ubuntu:24.04

# Nama user SSH di dalam container
ARG SSH_USER=ramalana_k

# Install OpenSSH Server
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends openssh-server && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /run/sshd && \
    useradd --create-home --shell /bin/bash "$SSH_USER"

# Salin public key
COPY ramalana_docker_key.pub /tmp/user_key.pub

# public key authorized_keys user
RUN install -d -m 700 -o "$SSH_USER" -g "$SSH_USER" "/home/$SSH_USER/.ssh" && \
    install -m 600 -o "$SSH_USER" -g "$SSH_USER" \
    /tmp/user_key.pub "/home/$SSH_USER/.ssh/authorized_keys" && \
    rm /tmp/user_key.pub

# Mengubah konfigurasi SSH perintah sed
RUN sed -Ei \
    's/^[#[:space:]]*PermitRootLogin[[:space:]]+.*/PermitRootLogin no/' \
    /etc/ssh/sshd_config && \
    sed -Ei \
    's/^[#[:space:]]*PasswordAuthentication[[:space:]]+.*/PasswordAuthentication no/' \
    /etc/ssh/sshd_config && \
    sed -Ei \
    's/^[#[:space:]]*KbdInteractiveAuthentication[[:space:]]+.*/KbdInteractiveAuthentication no/' \
    /etc/ssh/sshd_config && \
    sed -Ei \
    's/^[#[:space:]]*PubkeyAuthentication[[:space:]]+.*/PubkeyAuthentication yes/' \
    /etc/ssh/sshd_config

# konfigurasi keamanan aktif dan tidak ditimpa
RUN printf '%s\n' \
    'PermitRootLogin no' \
    'PasswordAuthentication no' \
    'KbdInteractiveAuthentication no' \
    'PubkeyAuthentication yes' \
    'PermitEmptyPasswords no' \
    'AuthenticationMethods publickey' \
    > /etc/ssh/sshd_config.d/00-key-only.conf

# Port SSH
EXPOSE 22

# run SSH Server
CMD ["/usr/sbin/sshd", "-D", "-e"]