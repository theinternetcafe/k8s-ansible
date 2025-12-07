FROM python:3.13-alpine

# Set environment variables
ENV ANSIBLE_HOST_KEY_CHECKING=False
ENV ANSIBLE_ROLES_PATH=/runner/roles

# Install system dependencies
RUN apk add --no-cache \
    openssh-client \
    git \
    curl \
    gcc \
    musl-dev \
    libffi-dev \
    openssl-dev \
    python3-dev

# Install latest Python dependencies
RUN pip3 install --upgrade pip && \
    pip3 install --no-cache-dir \
    ansible-core==2.20.0 \
    cffi==1.17.1 \
    cryptography==44.0.0 \
    Jinja2==3.1.5 \
    MarkupSafe==3.0.2 \
    packaging==24.2 \
    pycparser==2.22 \
    PyYAML==6.0.2 \
    resolvelib==1.0.1

# Install Ansible collections
RUN ansible-galaxy collection install \
    ansible.posix \
    community.general \
    kubernetes.core

# Create runner user
RUN adduser -D -u 1000 runner

# Copy project files
WORKDIR /runner
COPY . /runner/

# Set proper permissions
RUN chmod +x /runner/run.sh && \
    chown -R runner:runner /runner

# Switch to runner user for security
USER runner

# Default command runs ansible-playbook
ENTRYPOINT ["ansible-playbook"]
