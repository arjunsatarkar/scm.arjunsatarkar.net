FROM nginx:1-bullseye

RUN apt-get update && apt-get install -y asciidoctor fcgiwrap gcc git libssl-dev make pandoc python3 python3-pygments zlib1g-dev

RUN git clone https://git.zx2c4.com/cgit
WORKDIR /cgit
RUN git checkout 00ecfaadea2c40cc62b7a43e246384329e6ddb98
RUN git submodule init
RUN git submodule update

RUN make
RUN make install

COPY nginx.conf /etc/nginx/nginx.conf
COPY cgitrc /etc/cgitrc
COPY header.html /header.html
COPY about_filter.py /about_filter.py
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT /entrypoint.sh
