FROM ubuntu:18.04 AS builder

RUN apt-get update && \
    apt-get install -y \
      build-essential \
      zlib1g-dev \
      cmake

WORKDIR /tmp
ADD https://github.com/h2o/h2o/archive/v2.2.6.tar.gz ./
RUN tar xzf v2.2.6.tar.gz

WORKDIR /tmp/h2o-2.2.6
RUN cmake . && \
    make && \
    make install

FROM ubuntu:18.04
RUN mkdir -p /var/log/h2o && \
    mkdir -p /etc/h2o
EXPOSE 80
COPY h2o.conf /etc/h2o/h2o.conf
COPY --from=builder /usr/local/bin/h2o /usr/local/bin/h2o
COPY --from=builder /usr/local/share/h2o/ca-bundle.crt /usr/local/share/h2o/ca-bundle.crt
CMD ["h2o", "-c", "/etc/h2o/h2o.conf"]

