#!/usr/bin/env bash
CENTOS_VER=$(lsb_release -r | grep -oP "[0-9]+" | head -1);

echo -n "Install php from remi repo? [y/n] ";
read DECISION;
if [ "${DECISION}" == "y" ]; then
	echo -n "Please specify PHP version: ";
	read BASE_REPO;
	if ( "${VER}" == "" ); then BASE_REPO="php71"; fi;

	rpm -iUvh http://rpms.famillecollet.com/enterprise/remi-release-${CENTOS_VER}.rpm;
	yum -y --enablerepo=remi --enablerepo="remi-${BASE_REPO}" install php php-fpm php-mbstring php-openssl php-pear php-mongodb php-pdo php-process php-mysql php-xml
else
	yum -y install php php-fpm php-mbstring php-openssl php-pear php-mongodb php-pdo php-process php-mysql php-xml
fi;