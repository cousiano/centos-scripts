#!/bin/bash

# load check_functions.
. ./check_functions/check_functions.bash

# check pages
check_web_function nagios "http://localhost/nagios/ --http-user=nagiosadmin --http-password=nagiosadmin"
check_web_function Centreon http://localhost/centreon/
check_web_function OCS http://localhost/ocsreports/install.php
check_web_function GLPI http://localhost/glpi/install/install.php
check_web_function ntopng http://localhost/ntopng/

# check services:
check_service httpd
check_service mariadb

check_service ndo2db
check_service nagios

check_service ntopng

# check tcp port:
check_tcp 80 #httpd
check_tcp 3306 #mariadb
