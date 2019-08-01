FROM alpine:3.10

ENV BITLBEE_VERSION 3.6
ENV SIPE_VERSION upstream/1.23.3
ENV ROCKETCHAT_VERSION 826990b

RUN addgroup -g 101 -S bitlbee \
 && adduser -u 101 -D -S -G bitlbee bitlbee \
 && apk add --no-cache --update tzdata \
 	libpurple \
	libpurple-xmpp \
        libsasl \
        cyrus-sasl-plain \
	libpurple-oscar \
	libpurple-bonjour \
	json-glib \
	libgcrypt \
	libssl1.1 \
	libcrypto1.1 \
	gettext \
	libwebp \
	glib \
	protobuf-c \
	discount-libs \
	libpng \
	bash \
 && apk add --no-cache --update --virtual .build-dependencies \
	git \
	make \
	autoconf \
	automake \
	libtool \
	gcc \
	g++ \
	json-glib-dev \
	libgcrypt-dev \
	openssl-dev \
	pidgin-dev \
	libwebp-dev \
	glib-dev \
	protobuf-c-dev \
	mercurial \
	libxml2-dev \
	discount-dev \
	libpng-dev \
 && cd /tmp \
 && git clone https://github.com/bitlbee/bitlbee.git \
 && cd bitlbee \
 && git checkout ${BITLBEE_VERSION} \
 && ./configure --build=x86_64-alpine-linux-musl --host=x86_64-alpine-linux-musl --purple=1 --ssl=openssl --prefix=/usr --etcdir=/etc/bitlbee \
 && make \
 && make install \
 && make install-dev \
 && cd /tmp \
 && git clone https://github.com/jgeboski/bitlbee-facebook.git \
 && cd bitlbee-facebook \
 && ./autogen.sh \
 && make \
 && make install \
 && strip /usr/lib/bitlbee/facebook.so \
 && cd /tmp \
 && git clone https://github.com/jgeboski/bitlbee-steam.git \
 && cd bitlbee-steam \
 && ./autogen.sh --build=x86_64-alpine-linux-musl --host=x86_64-alpine-linux-musl \
 && make \
 && make install \
 && strip /usr/lib/bitlbee/steam.so \
 && cd /tmp \
 && git clone git://github.com/EionRobb/skype4pidgin.git \
 && cd skype4pidgin/skypeweb \
 && make \
 && make install \
 && strip /usr/lib/purple-2/libskypeweb.so \
 && cd /tmp \
 && git clone --recursive https://github.com/majn/telegram-purple \
 && cd telegram-purple \
 && ./configure --build=x86_64-alpine-linux-musl --host=x86_64-alpine-linux-musl \
 && make \
 && make install \
 && strip /usr/lib/purple-2/telegram-purple.so \
 && cd /tmp \
 && hg clone https://bitbucket.org/EionRobb/purple-hangouts \
 && cd purple-hangouts \
 && make \
 && make install \
 && strip /usr/lib/purple-2/libhangouts.so \
 && cd /tmp \
 && git clone https://github.com/dylex/slack-libpurple.git \
 && cd slack-libpurple \
 && make \
 && make install \
 && strip /usr/lib/purple-2/libslack.so \
 && cd /tmp \
 && git clone https://github.com/tieto/sipe.git \
 && cd sipe \
 && git checkout ${SIPE_VERSION} \
 && ./autogen.sh \
 && ./configure --build=x86_64-alpine-linux-musl --host=x86_64-alpine-linux-musl --prefix=/usr \
 && make \
 && make install \
 && strip /usr/lib/purple-2/libsipe.so \
 && cd /tmp \
 && git clone https://github.com/sm00th/bitlbee-discord.git \
 && cd bitlbee-discord \
 && ./autogen.sh \
 && ./configure --build=x86_64-alpine-linux-musl --host=x86_64-alpine-linux-musl --prefix=/usr \
 && make \
 && make install \
 && strip /usr/lib/bitlbee/discord.so \
 && cd /tmp \
 && hg clone https://bitbucket.org/EionRobb/purple-rocketchat -r ${ROCKETCHAT_VERSION} \
 && cd purple-rocketchat \
 && make \
 && make install \
 && strip /usr/lib/purple-2/librocketchat.so \
 && rm -rf /tmp/* \
 && rm -rf /usr/include/bitlbee \
 && rm -f /usr/lib/pkgconfig/bitlbee.pc \
 && apk del .build-dependencies

EXPOSE 6667

USER bitlbee

CMD [ "/usr/sbin/bitlbee", "-F", "-n" ]
