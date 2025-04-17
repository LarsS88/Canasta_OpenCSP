FROM ghcr.io/canastawiki/canasta:latest

COPY install_open_csp.sh /install_open_csp.sh
COPY opencsp-run-all.sh /opencsp-run-all.sh
COPY fix_localSettings.sh /fix_localSettings.sh
RUN set -x &&  \
    chmod u+x /install_open_csp.sh && \
    chmod u+x /opencsp-run-all.sh && \
    chmod u+x /fix_localSettings.sh

CMD ["/opencsp-run-all.sh"]
