FROM ghcr.io/canastawiki/canasta:latest

COPY ./install_open_csp.sh /install_open_csp.sh
COPY ./opencsp-run-all.sh /opencsp-run-all.sh
COPY ./fix_localSettings.sh /fix_localSettings.sh
COPY ./fixes /var/www/mediawiki/w/fixes
RUN set -x && \
    apt-get update && \
    apt-get install --force-yes -y uglifyjs
RUN set -x && \
    bash /var/www/mediawiki/w/fixes/urlfixer.sh
RUN set -x &&  \
    chmod u+x /install_open_csp.sh && \
    chmod u+x /opencsp-run-all.sh && \
    chmod u+x /fix_localSettings.sh && \
    chmod u+x /var/www/mediawiki/w/fixes/urlfixer.sh
RUN set -x && \
    cd /var/www/mediawiki/w/ && \
    mkdir fixes/urlfixer && \
    git -C fixes/urlfixer/ clone https://gerrit.wikimedia.org/r/mediawiki/extensions/HeadScript

CMD ["/opencsp-run-all.sh"]
