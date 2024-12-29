ARG REMOTE
ARG LOCAL
FROM ${REMOTE:-${LOCAL}}

WORKDIR /project

COPY mops.toml mops.lock ./
RUN mops install --no-toolchain

COPY src /project/src/
COPY did /project/did/
COPY build.sh /project

CMD ["/bin/bash"]
