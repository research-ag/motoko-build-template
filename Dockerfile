ARG IMAGE
FROM $IMAGE

WORKDIR /project

COPY mops.toml mops.lock ./
RUN mops install --no-toolchain

COPY src /project/src/
COPY did /project/did/
COPY build.sh /project

CMD ["/bin/bash"]
