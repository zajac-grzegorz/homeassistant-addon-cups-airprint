ARG BUILD_FROM
FROM $BUILD_FROM

LABEL io.hass.version="1.5" io.hass.type="addon" io.hass.arch="aarch64|amd64"

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt update \
    && apt install -y --no-install-recommends \
        sudo \
        locales \
        cups \
        cups-filters \
        avahi-daemon \
        libnss-mdns \
        dbus \
        colord \
        printer-driver-all-enforce \
        printer-driver-all \
        printer-driver-splix \
        printer-driver-brlaser \
        printer-driver-gutenprint \
        openprinting-ppds \
        hpijs-ppds \
        hp-ppd  \
        hplip \
        printer-driver-foo2zjs \
        printer-driver-hpcups \
        printer-driver-escpr \
        cups-pdf \
        gnupg2 \
        lsb-release \
        nano \
        samba \
        bash-completion \
        procps \
        whois \
    && apt clean -y \
    && rm -rf /var/lib/apt/lists/*

# Add Canon cnijfilter2 driver
RUN cd /tmp \
  && if [ "$(arch)" = 'x86_64' ]; then ARCH="amd64"; else ARCH="arm64"; fi \
  && curl https://gdlp01.c-wss.com/gds/0/0100012300/02/cnijfilter2-6.80-1-deb.tar.gz -o cnijfilter2.tar.gz \
  && tar -xvf ./cnijfilter2.tar.gz cnijfilter2-6.80-1-deb/packages/cnijfilter2_6.80-1_${ARCH}.deb \
  && mv cnijfilter2-6.80-1-deb/packages/cnijfilter2_6.80-1_${ARCH}.deb cnijfilter2_6.80-1.deb \
  && apt install ./cnijfilter2_6.80-1.deb

# Add Canon UFR II/UFRII LT Printer Driver
RUN cd /tmp \
  && if [ "$(arch)" = 'x86_64' ]; then ARCH="amd64"; else ARCH="arm64"; fi \
  && curl https://gdlp01.c-wss.com/gds/0/0100009240/37/linux-UFRII-drv-v610-m17n-01.tar.gz -o linux-UFRII-drv-v610-m17n-01.tar.gz \
  && tar -xvf ./linux-UFRII-drv-v610-m17n-01.tar.gz \
  && ls -la \
  && apt update \
  && apt install -y --no-install-recommends \
     cups-bsd \
     ghostscript \
     libatk1.0-0 \
     libcups2 \
     libcupsimage2 \
     libgcrypt20 \
     libgdk-pixbuf2.0-0 \
     libgtk-3-0 \
     libjbig0 \
     libjpeg62-turbo \
     libpango-1.0-0 \
     libpangocairo-1.0-0 \
     lsb-release \
     zlib1g \
  && ls -la \
  && cd linux-UFRII-drv-v610-m17n 2>/dev/null || cd linux-UFRII-drv-v* \
  && ls -la \
  && if [ "$(arch)" = 'x86_64' ]; then \
       find . -path "*x64/Debian/*.deb" -exec dpkg -i --force-overwrite {} \; || true; \
     else \
       find . -path "*ARM64/Debian/*.deb" -exec dpkg -i --force-overwrite {} \; || true; \
     fi \
  && apt-get -f install -y \
  && cd .. \
  && rm -rf ./linux-UFRII-drv-v* ./linux-UFRII-drv-v*.tar.gz \
  && apt clean -y

COPY rootfs /

# Add user and disable sudo password checking
RUN useradd \
  --groups=sudo,lp,lpadmin \
  --create-home \
  --home-dir=/home/print \
  --shell=/bin/bash \
  --password=$(mkpasswd print) \
  print \
&& sed -i '/%sudo[[:space:]]/ s/ALL[[:space:]]*$/NOPASSWD:ALL/' /etc/sudoers

EXPOSE 631

RUN chmod a+x /run.sh

CMD ["/run.sh"]
