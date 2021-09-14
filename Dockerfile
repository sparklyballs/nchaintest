ARG UBUNTU_VER="focal"
FROM ubuntu:${UBUNTU_VER} as packages

# build arguments
ARG DEBIAN_FRONTEND=noninteractive

# environment variables
ENV \
	keys="generate" \
	harvester="false" \
	farmer="false" \
	plots_dir="/plots" \
	farmer_address="null" \
	farmer_port="null" \
	testnet="false" \
	full_node_port="null" \
	TZ="UTC"

# set workdir 
WORKDIR /chia-blockchain

# install dependencies
RUN \
	apt-get update \
	&& apt-get install -y \
	--no-install-recommends \
		bc \
		ca-certificates \
		curl \
		git \
		jq \
		lsb-release \
		sudo \
# cleanup
	&& rm -rf \
		/tmp/* \
		/var/lib/apt/lists/* \
		/var/tmp/*

# set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# build package
RUN \
	git clone -b net9.dev --recurse-submodules  https://gitee.com/ext9/ext9-blockchain.git \
		/chia-blockchain \		
	&& sh install.sh \
# cleanup
	&& rm -rf \
		/tmp/* \
		/var/lib/apt/lists/* \
		/var/tmp/*

# add local files
COPY ./entrypoint.sh entrypoint.sh
ENTRYPOINT ["bash", "./entrypoint.sh"]
