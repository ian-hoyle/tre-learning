#FROM mozilla/sbt as builder
#COPY . /lambda/src/
#WORKDIR /lambda/src/
#RUN sbt assembly
#
#FROM public.ecr.aws/lambda/java:11
#COPY --from=builder /lambda/src/target/function.jar ${LAMBDA_TASK_ROOT}/lib/
#CMD ["com.example.LambdaHandler::handleRequest"]

# This Dockerfile has two required ARGs to determine which base image
# to use for the JDK and which sbt version to install.

ARG OPENJDK_TAG=11.0.13
FROM openjdk:${OPENJDK_TAG} as builder
COPY . /lambda/src/
WORKDIR /lambda/src/

#RUN sbt assembly


ARG SBT_VERSION=1.6.2


# Install sbt
RUN \
  mkdir /working/ && \
  cd /working/ && \
  curl -L -o sbt-$SBT_VERSION.deb https://repo.scala-sbt.org/scalasbt/debian/sbt-$SBT_VERSION.deb && \
  dpkg -i sbt-$SBT_VERSION.deb && \
  rm sbt-$SBT_VERSION.deb && \
  apt-get update && \
  apt-get install sbt && \
  cd && \
  rm -r /working/ && \
  sbt sbtVersion

RUN sbt assembly

COPY --from=builder /lambda/src/target/function.jar ${LAMBDA_TASK_ROOT}/lib/
CMD ["com.example.LambdaHandler::handleRequest"]
