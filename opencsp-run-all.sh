#!/bin/bash

if ! grep -q -F "# OPENCSP Scripts" "/run-all.sh" && [ -e /mediawiki/config/LocalSettings.php ]; then
  echo "FOUND";
  sed -i "/# Symlink all extensions/i \
  CSP_SETUP=0\n\
if ! grep -q -F \"require_once('./settings/CSPSettings.php');\" \"\$MW_HOME/LocalSettings.php\"; then\n\
  CSP_SETUP=1\n\
  echo \"SETUP OPENCSP\";\n\
  # OPENCSP Scripts\n\
  /install_open_csp.sh \$MW_HOME/ --unattended --run=copy-files;\n\
  sed -i s/-sf/-sfn/ /create-symlinks.sh\n\
  /install_open_csp.sh \$MW_HOME/ --unattended --run=composer;\n\
  sed -i 's,localhost:9200,elasticsearch:9200,' \$MW_HOME/settings/CSPSettings.php\n\
else" /run-all.sh
  sed -i "/^\/create-symlinks\.sh/a \
    fi\n" /run-all.sh

  sed -i "/check_mount_points/i \
  if [ x\$CSP_SETUP == x1 ]; then\n\
  /install_open_csp.sh \$MW_HOME/ --unattended --run=setup-localsettings;\n\
  /install_open_csp.sh \$MW_HOME/ --unattended --run=maintenance-scripts;\n\
  /install_open_csp.sh \$MW_HOME/ --unattended --run=pagesync;\n\
  /install_open_csp.sh \$MW_HOME/ --unattended --run=rebuild-data;\n\
  chmod 777 \$MW_HOME/extensions/Widgets/compiled_templates\n\
  chmod 777 \$MW_HOME/extensions/PageSync/Temp\n\
  chmod 777 \$MW_HOME/extensions/FlexForm/uploads\n\
fi\n" /run-all.sh;
fi

/run-all.sh