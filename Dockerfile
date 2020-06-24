FROM alpine:latest as builder
ARG REDIS_MASTER_PASSWORD
ARG REDIS_VERSION
ENV REDIS_VERSION=${REDIS_VERSION}
RUN apk update \
    && apk add musl gcc g++ make linux-headers
RUN wget -q http://download.redis.io/releases/redis-${REDIS_VERSION}.tar.gz \
    && tar xvzf redis-${REDIS_VERSION}.tar.gz \
    && rm -rf redis-${REDIS_VERSION}.tar.gz
RUN cd /redis-${REDIS_VERSION} \
    && make \
    && make install
EXPOSE 6379
# Enable connection for outside container
RUN sed -i "s/bind 127.0.0.1/bind 0.0.0.0/" /redis-${REDIS_VERSION}/redis.conf \
    && sed -i "s/# requirepass foobared/requirepass "${REDIS_MASTER_PASSWORD}"/" /redis-${REDIS_VERSION}/redis.conf

FROM alpine:latest as release
ARG REDIS_VERSION
ENV REDIS_VERSION=${REDIS_VERSION}
COPY --from=builder /usr/local/bin/* /usr/local/bin/
COPY --from=builder /redis-${REDIS_VERSION}/redis.conf /redis-${REDIS_VERSION}/redis.conf
CMD [ "sh", "-c", "/usr/local/bin/redis-server /redis-${REDIS_VERSION}/redis.conf" ]