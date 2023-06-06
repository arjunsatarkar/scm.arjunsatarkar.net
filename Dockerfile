FROM debian:bullseye-slim as builder

RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates gcc git libssl-dev make wget zlib1g-dev && rm -rf /var/lib/apt/lists/*

RUN git clone https://git.zx2c4.com/cgit
WORKDIR /cgit
RUN git checkout 00ecfaadea2c40cc62b7a43e246384329e6ddb98
RUN git submodule init
RUN git submodule update
RUN make
RUN make install

RUN wget -O pandoc.tar.gz https://github.com/jgm/pandoc/releases/download/3.1.2/pandoc-3.1.2-linux-amd64.tar.gz
RUN tar xvzf pandoc.tar.gz --strip-components 1 -C /usr/local

FROM nginx:1-bullseye

RUN apt-get update && apt-get install -y --no-install-recommends asciidoctor fcgiwrap libssl-dev python3 python3-pygments zlib1g-dev && rm -rf /var/lib/apt/lists/*

COPY --from=builder /var/www/htdocs/cgit /var/www/htdocs/cgit
COPY --from=builder /usr/local/lib/cgit /usr/local/lib/cgit
COPY --from=builder /usr/local/bin/pandoc /usr/local/bin/pandoc

COPY nginx.conf /etc/nginx/nginx.conf
COPY cgitrc /etc/cgitrc
COPY header.html /header.html
COPY about_filter.py /about_filter.py
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT /entrypoint.sh
