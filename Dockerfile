FROM ghcr.io/canastawiki/canasta:latest

ARG MW_HOME
RUN MW_HOME=$(find /var/www/* -maxdepth 2 -name CanastaUtils.php -printf "%h" -quit)

COPY ./install_open_csp.sh /install_open_csp.sh
COPY ./opencsp-run-all.sh /opencsp-run-all.sh
COPY ./fix_localSettings.sh /fix_localSettings.sh
COPY ./fixes $MW_HOME/fixes

RUN set -x && \
    apt-get update && \
    apt-get install --force-yes -y uglifyjs
RUN set -x && \
    bash $MW_HOME/fixes/urlfixer.sh
RUN set -x &&  \
    chmod u+x /install_open_csp.sh && \
    chmod u+x /opencsp-run-all.sh && \
    chmod u+x /fix_localSettings.sh && \
    chmod u+x $MW_HOME/fixes/urlfixer.sh
RUN set -x && \
    cd $MW_HOME/ && \
    mkdir fixes/urlfixer && \
    git -C fixes/urlfixer/ clone https://gerrit.wikimedia.org/r/mediawiki/extensions/HeadScript

CMD ["/opencsp-run-all.sh"]