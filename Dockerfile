# 1) Build stage:
#
# All build tools required to build the project need to be installed
# here.
FROM debian:buster-slim as builder

# Install Essentials
RUN apt-get update && \
    apt-get install -y \
    build-essential \
    g++ \
    git \
    openssl \
    openssh-client \
    ca-certificates \
    curl \
    libcurl4-openssl-dev \
    zlib1g-dev \
    libssl-dev

# Get the current dial-reference repo
WORKDIR /home/workdir
COPY . /home/workdir
RUN make

# 2) Target stage:
#
# The binary is copied over from the build stage into this image. This is
# done to reduce the size of the image uploaded to Mayhem.
FROM debian:buster-slim

# Install libc debug package for valgrind support
RUN apt update \
    && apt install -y libc6-dbg

WORKDIR /dial-reference
COPY --from=builder /home/workdir /dial-reference
COPY mayhem/in/http.dict /http.dict
