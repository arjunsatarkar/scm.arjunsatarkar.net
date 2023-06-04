FROM debian:bullseye as builder

RUN apt-get update && apt-get install -y gcc git libssl-dev make zlib1g-dev && rm -rf /var/lib/apt/lists/*
RUN git clone https://git.zx2c4.com/cgit
WORKDIR /cgit
RUN git checkout 00ecfaadea2c40cc62b7a43e246384329e6ddb98
RUN git submodule init
RUN git submodule update

RUN make
RUN make install

FROM nginx:1-bullseye

RUN apt-get update && apt-get install -y asciidoctor fcgiwrap libssl-dev pandoc python3 python3-pygments zlib1g-dev && rm -rf /var/lib/apt/lists/*

COPY --from=builder /var/www/htdocs/cgit /var/www/htdocs/cgit
COPY --from=builder /usr/local/lib/cgit /usr/local/lib/cgit

COPY nginx.conf /etc/nginx/nginx.conf
COPY cgitrc /etc/cgitrc
COPY header.html /header.html
COPY about_filter.py /about_filter.py
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT /entrypoint.sh
