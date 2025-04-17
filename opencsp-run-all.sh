#!/bin/bash
if ! grep -q -F "# OPENCSP Scripts" "/run-all.sh"; then
  echo "FOUND";
  sed -i "/check_mount_points/i \
  if ! grep -q -F \"require_once('./settings/CSPSettings.php');\" \"/var/www/mediawiki/w/LocalSettings.php\"; then" /run-all.sh;
  sed -i "/check_mount_points/i \
    echo \"SETUP OPENCSP\";" /run-all.sh
  sed -i "/check_mount_points/i \
    # OPENCSP Scripts" /run-all.sh
  sed -i "/check_mount_points/i \
    /install_open_csp.sh /var/www/mediawiki/w/ --unattended --run=copy-files;" /run-all.sh
  sed -i "/check_mount_points/i \
    /install_open_csp.sh /var/www/mediawiki/w/ --unattended --run=setup-localsettings;" /run-all.sh
  sed -i "/check_mount_points/i \
    /install_open_csp.sh /var/www/mediawiki/w/ --unattended --run=composer;" /run-all.sh
  sed -i "/check_mount_points/i \
      sed -i 's,localhost:9200,elasticsearch:9200,' /var/www/mediawiki/w/settings/CSPSettings.php" /run-all.sh

  sed -i "/check_mount_points/i \
    /install_open_csp.sh /var/www/mediawiki/w/ --unattended --run=maintenance-scripts;" /run-all.sh
  sed -i "/check_mount_points/i \
    /install_open_csp.sh /var/www/mediawiki/w/ --unattended --run=pagesync;" /run-all.sh
  sed -i "/check_mount_points/i \
    /install_open_csp.sh /var/www/mediawiki/w/ --unattended --run=rebuild-data;" /run-all.sh
  sed -i "/check_mount_points/i \
    chown -R www-data:www-data /var/www/mediawiki/w/extensions/Widgets/compiled_templates" /run-all.sh
  sed -i "/check_mount_points/i \
  fi" /run-all.sh;
fi
/run-all.sh
