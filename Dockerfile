FROM nvidia/cuda:8.0-runtime-ubuntu16.04

# Work from /tmp
WORKDIR /tmp

# Variables
ENV LIBRARY_PATH /usr/local/cuda/lib64/stubs:${LIBRARY_PATH}
ARG DEBIAN_FRONTEND=noninteractive
ARG boost_version=1.62.0
ARG boost_dir=boost_1_62_0
ARG boost_sha256_sum=440a59f8bc4023dbe6285c9998b0f7fa288468b889746b1ef00e8b36c559dce1
ENV boost_version ${boost_version}
ARG boost_libs=" \
  --with-atomic \
  --with-chrono \
  --with-date_time \
  --with-filesystem \
  --with-log \
  --with-regex \
  --with-system \
  --with-thread"

# Install Required Packages
RUN apt-get update \
  && apt-get install -y ca-certificates wget git-all iputils-ping build-essential gcc tcc g++ python-dev autotools-dev libicu-dev libbz2-dev libssl-dev cuda-core-8-0 cuda-misc-headers-8-0 cuda-command-line-tools-8-0 cuda-driver-dev-8-0 \
  && rm -rf /var/lib/apt/lists/* \
  && apt-get clean -y

# Install Boost 1.62
RUN wget http://downloads.sourceforge.net/project/boost/boost/${boost_version}/${boost_dir}.tar.gz
RUN echo "${boost_sha256_sum}  ${boost_dir}.tar.gz" | sha256sum -c \
  && tar xfz ${boost_dir}.tar.gz \
  && rm ${boost_dir}.tar.gz
RUN cd ${boost_dir} && ./bootstrap.sh --prefix=/usr \
  && ./b2 -j 4 stage $boost_libs \
  && ./b2 -j 4 install $boost_libs \
  && cd .. \
  && rm -rf ${boost_dir} \
  && ldconfig

# Install cmake 3.7.2
RUN wget \
  https://cmake.org/files/v3.7/cmake-3.7.2.tar.gz \
  https://cmake.org/files/v3.7/cmake-3.7.2-SHA-256.txt \
  https://cmake.org/files/v3.7/cmake-3.7.2-SHA-256.txt.asc \
  && grep cmake-3.7.2.tar.gz cmake-3.7.2-SHA-256.txt | sha256sum --check \
  && tar xzvf cmake-3.7.2.tar.gz \
  && cd cmake-3.7.2/ \
  && ./bootstrap \
  && make -j4 \
  && make install \
  && cd ../

# Install nheqminer
RUN git clone https://github.com/nicehash/nheqminer.git \
  && chmod +x nheqminer/cpu_xenoncat/asm_linux/* \
  && cd nheqminer/cpu_xenoncat/asm_linux \
  && sh assemble.sh \
  && cd /tmp \
  && mkdir build/ \
  && cd build/ \
  && cmake ../nheqminer \
  && make -j $(nproc) \
  && cp ./nheqminer /usr/local/bin/nheqminer \
  && chmod +x /usr/local/bin/nheqminer

RUN rm -rf /tmp/*
RUN useradd -ms /bin/bash nheqminer
USER nheqminer
WORKDIR /home/nheqminer
ENTRYPOINT ["/usr/local/bin/nheqminer"]
CMD ["-h"]
