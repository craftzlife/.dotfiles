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

# Set working directory
WORKDIR /home/tester

# Copy the dotfiles into the container
COPY --chown=tester:tester install.sh .

# Switch to the test user
USER tester

# Make the script executable
RUN chmod +x install.sh

# Run the installation script and then drop into zsh (JSON format recommended)
CMD ["/bin/zsh", "-c", "./install.sh && exec zsh"]
