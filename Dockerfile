# Use a base image with build tools
FROM ubuntu:22.04

# Install necessary dependencies for building LAMMPS, including Python3 and its development headers
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    g++ \
    libopenmpi-dev \
    openmpi-bin \
    libjpeg-dev \
    libpng-dev \
    python3 \
    python3-dev

# Set the working directory inside the container
WORKDIR /usr/src/lammps

# Copy the source code into the container
COPY . .

# Create a build directory and run CMake
RUN mkdir build
WORKDIR /usr/src/lammps/build
RUN cmake ../cmake

# Compile the LAMMPS executable with multiple threads
RUN make -j$(nproc)

# Set the final command to run when the container starts
ENV PATH="/usr/src/lammps/build/bin:${PATH}"
CMD ["tail", "-f", "/dev/null"]
