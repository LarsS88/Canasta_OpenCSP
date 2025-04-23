#!/bin/bash
if ! grep -q -F "# OPENCSP Scripts" "/run-all.sh" && [ -e $MW_VOLUME/config/LocalSettings.php ]; then
  echo "FOUND";
  sed -i "/# Symlink all extensions/i \
  CSP_SETUP=0\n\
CSP_INITIAL_INSTALL=0\n\
if ! grep -q -F \"require_once('./settings/CSPSettings.php');\" \"\$MW_HOME/LocalSettings.php\"; then\n\
  CSP_SETUP=1\n\
  echo \"SETUP OPENCSP\";\n\
  # OPENCSP Scripts\n\
  /install_open_csp.sh \$MW_HOME/ --unattended --run=copy-files;\n\
  /install_open_csp.sh \$MW_HOME/ --unattended --run=composer;\n\
  if [ ! -e \$MW_VOLUME/config/CSPSettings.php ]; then\n\
    CSP_INITIAL_INSTALL=1\n\
  else\n\
    ln -sf \$MW_VOLUME/config/CSPSettings.php \$MW_HOME/settings/CSPSettings.php\n\
  fi\n\
  sed -i 's,localhost:9200,elasticsearch:9200,' \$MW_HOME/settings/CSPSettings.php\n\
fi\n" /run-all.sh

  sed -i "/check_mount_points[\s]*$/a \
  if [ x\$CSP_SETUP == x1 ]; then\n\
  # OPENCSP Scripts\n\
  /install_open_csp.sh \$MW_HOME/ --unattended --run=setup-localsettings;\n\
  /install_open_csp.sh \$MW_HOME/ --unattended --run=maintenance-scripts;\n\
  sed -i \"/<?php/a \\\\\\\\ \\
if (time() < \$(date -d '+5 minutes' +%s)) \\\\\{\\\\\\\ \n\
  exit('Skipping ' . basename(__FILE__) . \\\\\"...\\\\\\\\\\\n\\\\\");\\\\\\\ \n\
\\\\\}\\\n\"\\\ \n\
    \$MW_HOME/maintenance/update.php\\\ \n\
    \$MW_HOME/extensions/SemanticMediaWiki/maintenance/rebuildElasticIndex.php\n\
  if [ x\$CSP_INITIAL_INSTALL == x1 ]; then\n\
    sed -i 's,src=\",src=\"$(echo $MW_HOME|cut -c $(expr `printf $WWW_ROOT|wc -c` \+ 1)-),'\\\ \n\
      \$MW_HOME/wsps/export/274_logo_slot_main.wiki\n\
    /install_open_csp.sh \$MW_HOME/ --unattended --run=pagesync;\n\
  fi\n\
  /install_open_csp.sh \$MW_HOME/ --unattended --run=rebuild-data;\n\
  sed -i \"/<?php/a \\\\\\\\ \\
if (time() < \$(date -d '+5 minutes' +%s)) \\\\\{\\\\\\\ \n\
  exit('Skipping ' . basename(__FILE__) . \\\\\"...\\\\\\\\\\\n\\\\\");\\\\\\\ \n\
\\\\\}\\\n\"\\\ \n\
    \$MW_HOME/extensions/SemanticMediaWiki/maintenance/rebuildData.php\n\
  chmod 777 \$MW_HOME/extensions/Widgets/compiled_templates\n\
  chmod 777 \$MW_HOME/extensions/PageSync/Temp\n\
  chmod 777 \$MW_HOME/extensions/FlexForm/uploads\n\
  if [ x\$CSP_INITIAL_INSTALL == x1 ]; then\n\
    cp \$MW_HOME/settings/CSPSettings.php \$MW_VOLUME/config/CSPSettings.php\n\
    CSP_INITIAL_INSTALL=0\n\
  fi\n\
fi\n"\
  /run-all.sh && \
    sed -i "s/ $//"\
      /run-all.sh
fi
dd if=/dev/zero of=/dev/null
sed -i \
  -e 's,ln -sf ,ln -sfn ,' \
  -e 's,^\(for .*/user-.*-type d\)),\1 -or -type l),' \
  /create-symlinks.sh

/run-all.sh