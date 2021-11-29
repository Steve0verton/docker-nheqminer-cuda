# nheqminer Docker Image
Bitcoin mining using the [NiceHash equihash mining algorithm](https://github.com/nicehash/nheqminer). Built using docker to standardize the many dependencies.

## Table of Contents

## Background

This project was built on an older System76 desktop running Ubuntu 20.04 repurposed for Bitcoin mining. This approach is definitely not the best.  Current mining technology such as [ASIC miners](https://www.investopedia.com/terms/a/asic.asp) are far more profitable and efficient.

## Prerequisites

- Operational knowledge of [Docker](https://www.docker.com/)
- Operational knowledge of the [NiceHash Equihash Miner](https://github.com/nicehash/nheqminer)
- Operational knowledge of [NiceHash stratum servers](https://www.nicehash.com/support/mining-help/mining-advanced-topics/which-stratum-servers-are-available)

### Technical Requirements

- [Docker](https://www.docker.com/) is installed and running
- NiceHash account with mining address
  - [NiceHash Account](https://www.nicehash.com/my/login)
  - [Mining Address](https://www.nicehash.com/my/mining/rigs)
- [nvidia-docker](https://github.com/NVIDIA/nvidia-docker/wiki/) installed and configured if CUDA is leveraged for GPU acceleration
  - [cpu only](./cpu) Dockerfile is provided for CPU-only operation (no GPU support)

## Build nheqminer Docker Image

The following instructions provide steps to build the Docker image.

1. **Install [Docker](https://docs.docker.com/get-docker/)** and ensure it is running during this process.

2. **Clone this project** to get necessary Dockerfile. Start from a local working directory where code is managed for development purposes such as a parent development directory `~/dev/`.

```bash
# clone this repo
git clone https://github.com/Steve0verton/docker-nheqminer-cuda

# move to the project directory
cd docker-nheqminer-cuda
```

3. **Build Docker image**. Ensure this command is run from the directory containing the appropriate Dockerfile.

Build nheqminer Docker image **with both CPU and GPU support (CUDA enabled):**
```bash
docker build -t nheqminer .
```

Build nheqminer Docker image **without GPU acceleration:**
```bash
cd cpu
docker build -t nheqminer_cpu .
```  

## Start Mining Process

The following instructions provide steps to start a docker container which automatically starts the mining process.

1. **Run Docker container** using one of the following commands. This executes the Docker container and tails the output.

**CPU-only (no GPU acceleration):**
```bash
nvidia-docker run --gpus all -ti --rm nheqminer -l equihash.usa.nicehash.com:3357 -u BTC_WALLET_ADDRESS_HERE.worker1
```

- Replace **BTC_WALLET_ADDRESS_HERE** with your [NiceHash mining address](https://www.nicehash.com/my/mining/rigs).
- Name your mining rig by replacing `worker1` with an appropriate name.

**CPU and GPU acceleration:**
```bash
nvidia-docker run --gpus all -ti --rm nheqminer -l equihash.usa.nicehash.com:3357 -u BTC_WALLET_ADDRESS_HERE.worker1 -t 6 -cd 0 1
```

- Adjust the numeric parameter after `t` to reflect the number of threads executed
- Adjust the `0 1` parameter to reflect the number of GPU cores available

See [NiceHash nheqminer README](https://github.com/nicehash/nheqminer/blob/master/README.md#run-instructions) for additional information on command parameters.

## Reference

The following links provide helpful information related to this project.

- [NVIDA CUDA on Ubuntu Server](https://powersj.io/posts/ubuntu-server-nvidia-cuda/)
- [Index of /compute/cuda/repos/ubuntu1604/x86_64](https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/)
- [How do I install NVIDIA and CUDA drivers into Ubuntu?](https://askubuntu.com/questions/1077061/how-do-i-install-nvidia-and-cuda-drivers-into-ubuntu)

## Author Contact

 - [Steve Overton](https://www.linkedin.com/in/overton/)
