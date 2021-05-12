# Docker: create layers for AWS lambda

## Description

You need some Python libraries for you code to execute correctly on AWS Lambda. You have tried to compile the libraries on your MacOS or Windows and to your greatest disappointment, your lambda function isn't able to recognise the modul. You google for a bit just to find out, that the libraries needs to be compiled in a Linux environment... Docker to the rescue! 🐳

This is a super simple Dockerfile which just needs to be built with two arguments: `VERSION` and `PACKAGES`. After that, we utilise the `docker create` command to get the zipped and completely ready layers out.

## Build phase

The `VERSION` argument is the Python version you wish to use as runtime on your AWS Lambda function. If not stated, the version defaults to `3.9`. The `PACKAGES`argument is... Well, the packages.

```sh
docker build \
    --build-arg VERSION="3.9" \
    --build-arg PACKAGES="praise pandas scipy" \
    --tag aws-lambda-layers .
```

## Create phase

After the image has been built we need to `create` a container. This is actually a preliminary step to `run` a container. Read more about `docker create` in the [official documentation](https://docs.docker.com/engine/reference/commandline/create/).

```sh
docker create \
    --interactive \
    --tty \
    --name dummy aws-lambda-layers bash
```

With the container created we are able to copy the `lambda_layer.zip` file from the `/data` directory inside the container.

```sh
docker cp dummy:/data/lambda_layer.zip .
```

Finally, we do some housekeeping.

```sh
docker rm --force dummy
```
