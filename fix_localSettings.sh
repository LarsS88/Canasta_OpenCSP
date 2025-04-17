#!/bin/bash
if ! grep -q -F "smwgElasticsearchEndpoints" "/var/www/mediawiki/w/LocalSettings.php"; then
sed -i "/require_once('.\/settings\/CSPSettings.php');/i \
\$GLOBALS['smwgElasticsearchEndpoints'] = [['host' => 'elasticsearch','port' => 9200,'scheme' => 'http',]]; \
" /var/www/mediawiki/w/LocalSettings.php
fi
