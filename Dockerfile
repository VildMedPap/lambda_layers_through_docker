# Stage: initial
ARG VERSION=3.9
FROM python:${VERSION}-slim AS build

# apt install zip manager
RUN apt-get update && apt-get -y install zip

# site-packages path (as used in lambda layers)
ARG VERSION=3.9
ENV AWS_PATH "python/lib/python${VERSION}/site-packages"

# volume
RUN mkdir "/data"

# pip install and zip
ARG PACKAGES
RUN pip install ${PACKAGES} --target ${AWS_PATH}
RUN zip -r /data/lambda_layer.zip ${AWS_PATH}/*

# Stage: smaaaaaall
FROM alpine:3.7
COPY --from=build /data /data
VOLUME [ "/data" ]
