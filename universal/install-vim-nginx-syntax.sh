#!/usr/bin/env bash

echo "Start installing nginx's vim syntax file...";
mkdir -p ~/.vim/syntax/
cd ~/.vim/syntax/
echo -n "    Fetching syntax file... ";
wget https://raw.githubusercontent.com/JCloudYu/centos-scripts/master/nginx/nginx.vim -O nginx.vim
if [ $? -ne 0 ]; then
	echo "Failed!" exit 1;
else
	echo "Success!";
fi;

echo "    Registering file name hook...";
cat > ~/.vim/filetype.vim <<EOF
au BufRead,BufNewFile nginx.conf,/etc/nginx/*,/usr/local/nginx/conf/* if &ft == '' | setfiletype nginx | endif
EOF
