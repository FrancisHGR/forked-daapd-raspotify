from debian:buster-slim
MAINTAINER Francis <7rncs7@gmail.com>

RUN apt-get update && apt-get install -y \
wget \
gnupg2 \
nano \
apt-transport-https \
curl && \
wget -q -O - http://www.gyfgafguf.dk/raspbian/forked-daapd.gpg | apt-key add - && \
echo "deb http://www.gyfgafguf.dk/raspbian/forked-daapd/ buster contrib" >> /etc/apt/sources.list && \
apt update && apt install -y forked-daapd && \
wget https://dtcooper.github.io/raspotify/raspotify-latest.deb && \
dpkg -i raspotify-latest.deb && \
mkdir /srv/music && \
mkfifo /srv/music/spotify && \
sed -i '/^#.*trusted_networks = { "localhost", "192.168", "fd" }/s/^#//' /etc/forked-daapd.conf && \
sed -i 's/trusted_networks = { "localhost", "192.168", "fd" }/trusted_networks = { "localhost", "192.168", "any" }/g' /etc/forked-daapd.conf

ENTRYPOINT service dbus restart && service avahi-daemon restart && forked-daapd && /usr/bin/librespot --name Spotify-Smart-Home --username $username --password $password --device /srv/music/spotify --disable-discovery --backend pipe --initial-volume 100


