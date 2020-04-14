FROM ubuntu:18.04
MAINTAINER Cuda Chen <clh960524@gmail.com>

# Supress warnings about missing front-end. As recommended at:
# http://stackoverflow.com/questions/22466255/is-it-possibe-to-answer-dialog-questions-when-installing-under-docker
ARG DEBIAN_FRONTEND=noninteractive

# Essentials: developer tools, build tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    apt-utils vim git gfortran \
    build-essential \
    ca-certificates

# FFTW Required Packages when building from scratch
RUN apt-get install -y --no-install-recommends \
    ocaml ocamlbuild autoconf automake indent libtool \
# additional required packages when building under Ubuntu
    ocaml-findlib fig2dev texinfo

# Ocaml Num library
# Currently build from source because Ubuntu has this
# package until version 20.04.
RUN git clone https://github.com/ocaml/num.git /usr/local/src/ocaml_num && \
    cd /usr/local/src/ocaml_num && \
    make all && \
    make test && \
    make install && \
    make clean

# Get FFTW source code from GitHub
# and compile FFTW from scratch.
RUN git clone https://github.com/FFTW/fftw3.git /usr/local/src/fftw3 && \
    cd /usr/local/src/fftw3 && \
    sh bootstrap.sh && \
    make -j`nproc` && \
    make install && \
    make clean
