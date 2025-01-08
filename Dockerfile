ARG IMAGE
FROM --platform=linux/amd64 ${IMAGE}

WORKDIR /project

COPY mops.toml mops.lock ./
RUN mops install --no-toolchain

COPY src /project/src/
COPY di[d] /project/did/
COPY build.sh /project

CMD ["/bin/bash"]
