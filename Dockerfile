FROM amazonlinux:2023

# Install dependencies, allowing replacement of conflicting packages
RUN dnf update -y && \
    dnf install -y --allowerasing curl awscli iptables conntrack-tools systemd && \
    dnf clean all

# Copy fck-nat service files
COPY service/fck-nat.sh /usr/local/bin/fck-nat.sh
COPY service/fck-nat.service /etc/systemd/system/fck-nat.service
COPY service/post-install.sh /usr/local/bin/post-install.sh

# Make scripts executable
RUN chmod +x /usr/local/bin/fck-nat.sh /usr/local/bin/post-install.sh

# Create systemd service
RUN systemctl enable fck-nat.service

# Set up environment for LocalStack
ENV AWS_ENDPOINT_URL=http://localstack:4566
ENV AWS_ACCESS_KEY_ID=test
ENV AWS_SECRET_ACCESS_KEY=test
ENV AWS_DEFAULT_REGION=us-east-1

# Expose port for health checks
EXPOSE 8080

# Start the service
CMD ["/usr/local/bin/fck-nat.sh"]