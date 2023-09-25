FROM debian:bookworm-slim as builder

RUN	apt-get update && \
	apt-get install -y --no-install-recommends ca-certificates gcc git libssl-dev make python3-pygments zlib1g-dev && \
	rm -rf /var/lib/apt/lists/*

RUN	git clone https://github.com/arjunsatarkar/cgit.git && \
	cd cgit && \
	git submodule init && \
	git submodule update && \
	make && \
	make install && \
	cd .. && \
	rm -rf cgit

WORKDIR /var/www/htdocs/cgit
RUN mkdir _static
RUN mv cgit.css cgit.js _static/
RUN rm cgit.png favicon.ico
COPY robots.txt .
COPY logo.svg _static/
COPY Source_Code_Pro/SourceCodePro*VariableFont_wght.ttf _static/Source_Code_Pro/
COPY additional.css /tmp/
RUN	{ \
		cat /tmp/additional.css && \
		pygmentize -S monokai -f html -O nobackground -a .highlight; \
	} >> _static/cgit.css

FROM nginx:1-bookworm as final

RUN	apt-get update && \
	apt-get install -y --no-install-recommends asciidoctor fcgiwrap openssl pandoc python3 python3-pygments zlib1g && \
	rm -rf /var/lib/apt/lists/*

COPY --from=builder /var/www/htdocs/cgit /var/www/htdocs/cgit

COPY cgitrc /etc/
COPY nginx.conf /etc/nginx/
COPY about_filter.py entrypoint.sh head.html source_filter.py /

ENTRYPOINT ["/entrypoint.sh"]
