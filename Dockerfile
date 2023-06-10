FROM debian:bullseye-slim as builder

RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates gcc git libssl-dev make wget zlib1g-dev && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/arjunsatarkar/cgit.git
WORKDIR /cgit
RUN git submodule init
RUN git submodule update
RUN make
RUN make install

RUN wget -O pandoc.tar.gz https://github.com/jgm/pandoc/releases/download/3.1.3/pandoc-3.1.3-linux-amd64.tar.gz
RUN tar xvzf pandoc.tar.gz --strip-components 1 -C /usr/local

FROM nginx:1-bullseye

RUN apt-get update && apt-get install -y --no-install-recommends asciidoctor fcgiwrap libssl-dev python3 python3-pygments zlib1g-dev && rm -rf /var/lib/apt/lists/*

COPY --from=builder /var/www/htdocs/cgit /var/www/htdocs/cgit
COPY --from=builder /usr/local/lib/cgit /usr/local/lib/cgit
COPY --from=builder /usr/local/bin/pandoc /usr/local/bin/pandoc

COPY nginx.conf /etc/nginx/nginx.conf
COPY cgitrc /etc/cgitrc
COPY head.html /head.html
COPY logo.svg /var/www/htdocs/cgit/logo.svg
COPY about_filter.py /about_filter.py
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT /entrypoint.sh
