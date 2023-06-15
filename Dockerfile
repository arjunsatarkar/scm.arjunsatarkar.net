FROM debian:bookworm-slim as builder

RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates gcc git libssl-dev make python3-pygments wget zlib1g-dev && rm -rf /var/lib/apt/lists/*

RUN	git clone https://github.com/arjunsatarkar/cgit.git && \
	cd /cgit && \
	git submodule init && \
	git submodule update && \
	make && \
	make install && \
	cd .. && \
	rm -rf /cgit

WORKDIR /var/www/htdocs/cgit
RUN mkdir _static
RUN mv cgit.css cgit.js _static/
RUN rm cgit.png favicon.ico
COPY logo.svg /var/www/htdocs/cgit/_static/logo.svg
COPY Source_Code_Pro /var/www/htdocs/cgit/_static/Source_Code_Pro

WORKDIR /
COPY additional.css /additional.css
RUN	cat additional.css >> /var/www/htdocs/cgit/_static/cgit.css && \
	pygmentize -S monokai -f html -O nobackground -a .highlight >> /var/www/htdocs/cgit/_static/cgit.css

RUN	wget -O pandoc.tar.gz https://github.com/jgm/pandoc/releases/download/3.1.3/pandoc-3.1.3-linux-amd64.tar.gz && \
	tar xvzf pandoc.tar.gz --strip-components 1 -C /usr/local && \
	rm -rf pandoc.tar.gz

FROM nginx:1-bookworm

RUN apt-get update && apt-get install -y --no-install-recommends asciidoctor fcgiwrap openssl python3 python3-pygments zlib1g && rm -rf /var/lib/apt/lists/*

COPY --from=builder /var/www/htdocs/cgit /var/www/htdocs/cgit
COPY --from=builder /usr/local/lib/cgit /usr/local/lib/cgit
COPY --from=builder /usr/local/bin/pandoc /usr/local/bin/pandoc

COPY nginx.conf /etc/nginx/nginx.conf
COPY cgitrc /etc/cgitrc
COPY about_filter.py /about_filter.py
COPY source_filter.py /source_filter.py
COPY head.html /head.html
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT /entrypoint.sh
