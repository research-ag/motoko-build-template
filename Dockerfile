ARG IMAGE
FROM --platform=linux/amd64 ${IMAGE}

WORKDIR /project

COPY mops.toml ./
COPY src /project/src/

RUN mops-cli build --name tmp src/main.mo \
    && rm -r target/tmp \
    && rm ~/.mops/bin/moc \
    && ln -s /usr/local/bin/moc ~/.mops/bin/moc 

COPY di[d] /project/did/
COPY build.sh /project

CMD ["/bin/bash"]
