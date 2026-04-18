# Use Ubuntu as the base image
FROM ubuntu:latest

# Avoid prompts from apt
ENV DEBIAN_FRONTEND=noninteractive

# Install sudo and zsh (prerequisites for the script)
RUN apt-get update && \
    apt-get install -y sudo zsh && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create a test user so we're not running as root (better for testing stow/sudo)
RUN useradd -m tester && \
    echo "tester ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Set working directory for mounted workspace scripts
WORKDIR /workspace

# Switch to the test user
USER tester

# Run the runtime install script from the mounted workspace, then drop into zsh
CMD ["/bin/zsh", "-c", "chmod +x /workspace/scripts/install.sh /workspace/scripts/update.sh 2>/dev/null || true && cd /workspace && if [ \"$MODE\" = \"update\" ]; then ./scripts/update.sh; else ./scripts/install.sh; fi && exec zsh"]
