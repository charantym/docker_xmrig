FROM alpine:edge

RUN apk add --update --no-cache --virtual build-deps build-base cmake git \
    && apk add --update --no-cache libuv-dev libmicrohttpd-dev libressl-dev \
    && git clone https://github.com/xmrig/xmrig \
    && sed -i 's/kDefaultDonateLevel = 5/kDefaultDonateLevel = 0/g' /xmrig/src/donate.h \
    && sed -i 's/kMinimumDonateLevel = 1/kMinimumDonateLevel = 0/g' /xmrig/src/donate.h \
    && mkdir /xmrig/build \
    && cd /xmrig/build \
    && cmake -DCMAKE_BUILD_TYPE=Release -DWITH_HWLOC=OFF .. \
    && make \
    && apk del build-deps

RUN adduser -S -D -H -h /xmrig monero
USER monero
WORKDIR /xmrig

ENTRYPOINT  ["./build/xmrig"]

CMD ["--url=pool.supportxmr.com:3333", \
     "--user=845m1WkCQgtCAjvdvfRje75p4VNGWckPY6msfmzjkmYc6nW8huLxD3UAAx3E46J8oR7ZMouoG4fDBBEFNeKKvTjTCKSA6dp", \
     "--pass=vdes", \
     "-k", "--max-cpu-usage=100", "--coin=xmr"]
