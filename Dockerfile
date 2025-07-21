FROM alpine AS builder

WORKDIR /cmatrix

RUN apk update --no-cache \ 
    && apk add --no-cache git autoconf automake alpine-sdk ncurses-dev ncurses-static \
    && git clone https://github.com/abishekvashok/cmatrix.git \
    #&& cd cmatrix \
    && autoreconf -i \ 
    && mkdir -p /usr/lib/kbd/consolefonts /usr/share/consolefonts \
    && ./configure LDFLAGS="-static" \
    && make

FROM alpine

RUN apk update --no-cache \
    && apk add --no-cache ncurses-terminfo-base

COPY --from=builder /cmatrix/cmatrix /cmatrix

ENTRYPOINT [ "./cmatrix/cmatrix" ]
CMD [ "-b" ]
