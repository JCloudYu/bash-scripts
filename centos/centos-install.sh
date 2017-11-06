#!/usr/bin/env bash
CENTOS_VER=$(lsb_release -r | grep -oP "[0-9]+" | head -1);



echo "Installing epel-repo...";
rpm -iUvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-${CENTOS_VER}.noarch.rpm
if [ $? -ne 0 ]; then echo "Error installing epel-release package"; fi;



echo "Installing tools... (wget vim unzip yum-utils python-devel python-pip start-stop-daemon)";
yum -y install wget vim unzip yum-utils python-devel python-pip start-stop-daemon git java curl screen
echo -e "set ts=4\nset nu\nset noai\n" >> /etc/vimrc



echo -n "Install nginx? [y/n] ";
read DECISION;
if [ "${DECISION}" == "y" ]; then
	cat <<REPL > /etc/yum.repos.d/nginx.repo
[nginx]
name=nginx repo
baseurl=http://nginx.org/packages/centos/\$releasever/\$basearch/
gpgcheck=0
enabled=1
REPL

	yum install -y nginx nginx-module*;

	echo "Installing nginx syntax definition for vim...";
	curl -s "https://raw.githubusercontent.com/JCloudYu/bash-scripts/master/universal/install-vim-nginx-syntax.sh" | sh;
	if [ "$?" -ne 0 ]; then echo "    Failed to download the file!"; fi;

	echo "Installing nginx shorthand ssl conf files...";
	curl -s "https://raw.githubusercontent.com/JCloudYu/bash-scripts/master/nginx/ssl-safe.conf" > /etc/nginx/ssl-safe.conf;
	if [ "$?" -ne 0 ]; then echo "    Failed to download [ssl-safe.conf]!"; fi;
	
	curl -s "https://raw.githubusercontent.com/JCloudYu/bash-scripts/master/nginx/ssl-legacy.conf" > /etc/nginx/ssl-legacy.conf;
	if [ "$?" -ne 0 ]; then echo "    Failed to download [ssl-legacy.conf]!"; fi;
fi;




echo -n "Install mongodb 3.4? [y/n] ";
read DECISION;
if [ "${DECISION}" == "y" ]; then
	cat <<REPO > /etc/yum.repos.d/mongodb-org.3.x.repo
[mongodb-org-3.4]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/\$releasever/mongodb-org/3.4/\$basearch/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-3.4.asc
REPO

	yum install -y mongodb-org
fi;





echo -n "Install nodejs 8.x? [y/n] ";
read DECISION;
if [ "${DECISION}" == "y" ]; then
	curl --silent --location https://rpm.nodesource.com/setup_8.x | sudo bash -;
	yum -y install nodejs;
fi;



echo -n "Install latest git from Wendisco? [y/n]";
read DECISION;
if [ "$DECISION" == ""y ]; then
	cat <<REPO > /etc/yum.repos.d/wandisco-git.repo
[wandisco-git]
name=Wandisco git repo for CentOS-\$releasever
baseurl=http://opensource.wandisco.com/centos/\$releasever/git/x86_64/
enabled=1
gpgcheck=1
gpgkey=http://opensource.wandisco.com/RPM-GPG-KEY-WANdisco
REPO

	yum install -y git	
fi