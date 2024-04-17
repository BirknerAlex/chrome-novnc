FROM alpine:3.19

LABEL AboutImage="Alpine_Chromium_NoVNC"

LABEL Maintainer="Alexander Birkner"

#VNC Server Password
ENV	VNC_PASS="samplepass" \
#VNC Server Title(w/o spaces)
	VNC_TITLE="Chromium" \
#VNC Resolution(720p is preferable)
	VNC_RESOLUTION="1280x720" \
#VNC Shared Mode (0=off, 1=on)
	VNC_SHARED=0 \
#Local Display Server Port
	DISPLAY=:0 \
# Chrome URL
    CHROME_URL="https://www.google.com" \
#NoVNC Port
	NOVNC_PORT=$PORT \
	PORT=8080 \
#Locale
	LANG=en_US.UTF-8 \
	LANGUAGE=en_US.UTF-8 \
	LC_ALL=C.UTF-8 \
	TZ="Asia/Kolkata"

COPY rootfs/ /

RUN apk add --no-cache --update --upgrade \
    bash \
    chromium \
    chromium-swiftshader \
    alsa-plugins-pulse \
    ttf-freefont \
    ca-certificates \
    curl \
    wget \
    supervisor \
    unzip \
    xvfb \
    x11vnc \
    websockify \
    openbox \
    openssl

SHELL ["/bin/bash", "-c"]

# noVNC
RUN openssl req -new -newkey rsa:4096 -days 36500 -nodes -x509 -subj "/C=IN/ST=Maharastra/L=Private/O=Dis/CN=www.google.com" -keyout /etc/ssl/novnc.key  -out /etc/ssl/novnc.cert
# TimeZone
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone

ENTRYPOINT ["supervisord", "-l", "/var/log/supervisord.log", "-c"]

CMD ["/config/supervisord.conf"]
