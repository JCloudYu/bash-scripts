#!/usr/bin/env bash
which lsb_release > /dev/null  2>&1;
if [ $? -ne 0 ]; then
	CENTOS_VER=$(cat /etc/centos-release | awk '{print $3}' | sed 's/\./\ /g' | awk '{print $1}');
else
	CENTOS_VER=$(lsb_release -r | grep -oP "[0-9]+" | head -1);
fi;



echo "Installing epel-repo...";
rpm -iUvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-${CENTOS_VER}.noarch.rpm
if [ $? -ne 0 ]; then echo "Error installing epel-release package"; fi;



echo "Installing tools... (wget vim unzip yum-utils python-devel python-pip start-stop-daemon java curl screen)";
yum -y install wget vim unzip yum-utils python-devel python-pip start-stop-daemon java curl screen
echo -e "set ts=4\nset nu\nset noai\n" >> /etc/vimrc



echo -n "Install git from Wendisco? [y/n] ";
read DECISION;
if [ "$DECISION" == "y" ]; then
	wget https://raw.githubusercontent.com/JCloudYu/bash-scripts/master/centos/repos/wandisco-git.repo -O /etc/yum.repos.d/wandisco-git.repo
	yum install -y git	
fi



echo -n "Install nginx? [y/n] ";
read DECISION;
if [ "${DECISION}" == "y" ]; then
	wget https://raw.githubusercontent.com/JCloudYu/bash-scripts/master/centos/repos/nginx.repo -O /etc/yum.repos.d/nginx.repo
	yum install -y nginx nginx-module*;

	echo "Installing nginx syntax definition for vim...";
	curl -s "https://raw.githubusercontent.com/JCloudYu/bash-scripts/master/universal/install-vim-nginx-syntax.sh" | sh;
	if [ "$?" -ne 0 ]; then echo "    Failed to download the file!"; fi;

	echo "Installing nginx shorthand ssl conf files...";
	curl -s "https://raw.githubusercontent.com/JCloudYu/bash-scripts/master/nginx/ssl-safe.conf" > /etc/nginx/ssl-safe.conf;
	if [ "$?" -ne 0 ]; then echo "    Failed to download [ssl-safe.conf]!"; fi;
	
	curl -s "https://raw.githubusercontent.com/JCloudYu/bash-scripts/master/nginx/ssl-legacy.conf" > /etc/nginx/ssl-legacy.conf;
	if [ "$?" -ne 0 ]; then echo "    Failed to download [ssl-legacy.conf]!"; fi;

	echo "Installing nginx shorthand proxy_pass conf files...";
	curl -s "https://raw.githubusercontent.com/JCloudYu/bash-scripts/master/nginx/proxy_pass_params.conf" > /etc/nginx/proxy_pass_params.conf;
	if [ "$?" -ne 0 ]; then echo "    Failed to download [proxy_pass_params.conf]!"; fi;
fi;



echo -n "Install mongodb? [y/n] ";
read DECISION;
if [ "${DECISION}" == "y" ]; then
	wget https://raw.githubusercontent.com/JCloudYu/bash-scripts/master/centos/repos/mongodb-org.repo -O /etc/yum.repos.d/mongodb-org.repo
	yum install -y mongodb-org
fi;



echo -n "Install nodejs? [y/n] ";
read DECISION;
if [ "${DECISION}" == "y" ]; then
	echo -n "Install nodejs 9.x? [y/n] ";
	read DECISION;
	if [ "${DECISION}" == "y" ]; then
		curl --silent --location https://rpm.nodesource.com/setup_9.x | sudo bash -;
	else
		curl --silent --location https://rpm.nodesource.com/setup_8.x | sudo bash -
	fi;

	yum -y install nodejs;
fi;



if [ "${CENTOS_VER}" -le 6 ]; then
	echo -n "Install devtool? [y/n] ";
	read DECISION;
	if [ "${DECISION}" == "y" ]; then
		wget http://people.centos.org/tru/devtools-2/devtools-2.repo -O /etc/yum.repos.d/devtools-2.repo
		yum upgrade -y
		yum install -y devtoolset-2-gcc devtoolset-2-binutils devtoolset-2-gcc-c++
		scl enable devtoolset-2 bash
	fi;
fi;