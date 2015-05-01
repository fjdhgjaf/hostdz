##################### FIRST LINE
# ---------------------------
#!/bin/bash
# ---------------------------
#
# |--------------------------------------------------------------|
# | The script thank you for Notos (notos.korsan@gmail.com)      |
# |--------------------------------------------------------------|
# | The script was further developed Tiby08 (tiby0108@gmail.com) |
# |--------------------------------------------------------------|
#
#
  SBFSCURRENTVERSION1=2.1.8   
  OS1=$(lsb_release -si)
txtblk='\e[0;30m' # Black - Regular
txtred1='\e[0;31m' # Red
txtred='\e[1;31m' # Red
txtgrn='\e[0;32m' # Green
txtylw='\e[1;33m' # Yellow
txtblu='\e[0;34m' # Blue
txtpur='\e[0;35m' # Purple
txtcyn='\e[0;36m' # Cyan
txtwht='\e[0;37m' # White
bldblk='\e[1;30m' # Black - Bold
bldred='\e[1;31m' # Red
bldgrn='\e[1;32m' # Green
bldylw='\e[1;33m' # Yellow
bldblu='\e[1;34m' # Blue
bldpur='\e[1;35m' # Purple
bldcyn='\e[1;36m' # Cyan
bldwht='\e[1;37m' # White
unkblk='\e[4;30m' # Black - Underline
undred='\e[4;31m' # Red
undgrn='\e[4;32m' # Green
undylw='\e[4;33m' # Yellow
undblu='\e[4;34m' # Blue
undpur='\e[4;35m' # Purple
undcyn='\e[4;36m' # Cyan
undwht='\e[4;37m' # White
bakblk='\e[40m'   # Black - Background
bakred='\e[41m'   # Red
bakgrn='\e[42m'   # Green
bakylw='\e[43m'   # Yellow
bakblu='\e[44m'   # Blue
bakpur='\e[45m'   # Purple
bakcyn='\e[46m'   # Cyan
bakwht='\e[47m'   # White
txtrst='\e[0m'    # Text Reset
function getString
{
  local ISPASSWORD=$1
  local LABEL=$2
  local RETURN=$3
  local DEFAULT=$4
  local NEWVAR1=a
  local NEWVAR2=b
  local YESYES=YESyes
  local NONO=NOno
  local YESNO=$YESYES$NONO

  while [ ! $NEWVAR1 = $NEWVAR2 ] || [ -z "$NEWVAR1" ];
  do
    clear
    echo -e "${txtylw}#${txtrst}"
	echo -e "${txtylw}# |--------------------------------------------------------------|${txtrst}"
	echo -e "${txtylw}# | The script thank you for Notos (notos.korsan@gmail.com)      |${txtrst}"
	echo -e "${txtylw}# |--------------------------------------------------------------|${txtrst}"
	echo -e "${txtylw}# | The script was further developed Tiby08 (tiby0108@gmail.com) |${txtrst}"
	echo -e "${txtylw}# |--------------------------------------------------------------|${txtrst}"
    echo -e "${txtylw}#${txtrst}"
    echo

    if [ "$ISPASSWORD" == "YES" ]; then
      read -s -p "$DEFAULT" -p "$LABEL" NEWVAR1
    else
      read -e -i "$DEFAULT" -p "$LABEL" NEWVAR1
    fi
    if [ -z "$NEWVAR1" ]; then
      NEWVAR1=a
      continue
    fi

    if [ ! -z "$DEFAULT" ]; then
      if grep -q "$DEFAULT" <<< "$YESNO"; then
        if grep -q "$NEWVAR1" <<< "$YESNO"; then
          if grep -q "$NEWVAR1" <<< "$YESYES"; then
            NEWVAR1=YES
          else
            NEWVAR1=NO
          fi
        else
          NEWVAR1=a
        fi
      fi
    fi

    if [ "$NEWVAR1" == "$DEFAULT" ]; then
      NEWVAR2=$NEWVAR1
    else
      if [ "$ISPASSWORD" == "YES" ]; then
        echo
        read -s -p "Retype: " NEWVAR2
      else
        read -p "Retype: " NEWVAR2
      fi
      if [ -z "$NEWVAR2" ]; then
        NEWVAR2=b
        continue
      fi
    fi


    if [ ! -z "$DEFAULT" ]; then
      if grep -q "$DEFAULT" <<< "$YESNO"; then
        if grep -q "$NEWVAR2" <<< "$YESNO"; then
          if grep -q "$NEWVAR2" <<< "$YESYES"; then
            NEWVAR2=YES
          else
            NEWVAR2=NO
          fi
        else
          NEWVAR2=a
        fi
      fi
    fi
    echo "---> $NEWVAR2"

  done
  eval $RETURN=\$NEWVAR1
}
# 0.

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

export DEBIAN_FRONTEND=noninteractive

clear

# 1.

#localhost is ok this rtorrent/rutorrent installation
IPADDRESS1=`ifconfig | sed -n 's/.*inet addr:\([0-9.]\+\)\s.*/\1/p' | grep -v 127 | head -n 1`
CHROOTJAIL1=NO

#those passwords will be changed in the next steps
PASSWORD1=a
PASSWORD2=b

getString NO  "SeedBox felhasználó név: " NEWUSER1
getString YES "SeedBox felhasználó($NEWUSER1) jelszava: " PASSWORD1
getString NO  "IP cím vagy host: " IPADDRESS1 $IPADDRESS1
#getString NO  "SSH port: " NEWSSHPORT1 22
#getString NO  "vsftp port (alap 21): " NEWFTPPORT1 21
#getString NO  "Do you want to have some of your users in a chroot jail? " CHROOTJAIL1 YES
#getString NO  "Webmin telepítése? " INSTALLWEBMIN1 YES
#getString NO  "Fail2ban telepítése? " INSTALLFAIL2BAN1 NO
getString NO  "OpenVPN telepítése? " INSTALLOPENVPN1 NO
if [ "$INSTALLOPENVPN1" = "YES" ]; then
getString NO  "OpenVPN port: " OPENVPNPORT1 31195
fi
#getString NO  "SABnzbd telepítése? " INSTALLSABNZBD1 NO
#getString NO  "Rapidleech telepítése? " INSTALLRAPIDLEECH1 NO
getString NO  "Deluge telepítése? " INSTALLDELUGE1 NO

NEWFTPPORT1=21
NEWSSHPORT1=22
INSTALLWEBMIN1=YES
INSTALLFAIL2BAN1=NO
INSTALLSABNZBD1=NO
INSTALLRAPIDLEECH1=NO
#getString NO  "Wich rTorrent would you like to use, '0.8.9' (older stable) or '0.9.2' (newer but banned in some trackers)? " RTORRENT1 0.9.2
RTORRENT1=0.9.2

if [ "$RTORRENT1" != "0.9.2" ] && [ "$RTORRENT1" != "0.8.9" ]; then
  echo "$RTORRENT1 is not 0.9.2 or 0.8.9!"
  exit 1
fi

if [ "$RTORRENT1" = "0.9.2" ]; then
  LIBTORRENT1=0.13.2
else
  LIBTORRENT1=0.12.9
fi

apt-get --yes install whois sudo makepasswd git

rm -f -r /etc/seedbox-from-scratch
git clone -b v$SBFSCURRENTVERSION1 https://github.com/fjdhgjaf/543016cc1c.git /etc/seedbox-from-scratch
mkdir -p cd /etc/seedbox-from-scratch/source
mkdir -p cd /etc/seedbox-from-scratch/users

if [ ! -f /etc/seedbox-from-scratch/seedbox-from-scratch.sh ]; then
  clear
  echo Looks like somethig is wrong, this script was not able to download its whole git repository.
  set -e
  exit 1
fi

# 3.1

#show all commands
set -x verbose

# 4.
#perl -pi -e "s/Port 22/Port $NEWSSHPORT1/g" /etc/ssh/sshd_config
#perl -pi -e "s/PermitRootLogin yes/PermitRootLogin no/g" /etc/ssh/sshd_config
perl -pi -e "s/#Protocol 2/Protocol 2/g" /etc/ssh/sshd_config
perl -pi -e "s/X11Forwarding yes/X11Forwarding no/g" /etc/ssh/sshd_config

groupadd sshdusers
echo "" | tee -a /etc/ssh/sshd_config > /dev/null
echo "UseDNS no" | tee -a /etc/ssh/sshd_config > /dev/null
echo "AllowGroups sshdusers" >> /etc/ssh/sshd_config
sudo cp /lib/terminfo/l/linux /usr/share/terminfo/l/
awk -F: '$3 == 1000 {print $1}' /etc/passwd | xargs usermod --groups sshdusers

service ssh restart

# 6.
#remove cdrom from apt so it doesn't stop asking for it
perl -pi -e "s/deb cdrom/#deb cdrom/g" /etc/apt/sources.list

#add non-free sources to Debian Squeeze# those two spaces below are on purpose
perl -pi -e "s/squeeze main/squeeze  main contrib non-free/g" /etc/apt/sources.list
perl -pi -e "s/squeeze-updates main/squeeze-updates  main contrib non-free/g" /etc/apt/sources.list

# 7.
# update and upgrade packages

apt-get --yes update
apt-get --yes upgrade

# 8.
#install all needed packages

##apt-get --yes build-dep znc
apt-get --yes install apache2 apache2-utils autoconf build-essential ca-certificates comerr-dev curl cfv quota mktorrent dtach htop irssi libapache2-mod-php5 libcloog-ppl-dev libcppunit-dev libcurl3 libcurl4-openssl-dev libncurses5-dev libterm-readline-gnu-perl libsigc++-2.0-dev libperl-dev openvpn libssl-dev libtool libxml2-dev ncurses-base ncurses-term ntp openssl patch libc-ares-dev pkg-config php5 php5-cli php5-dev php5-curl php5-geoip php5-mcrypt php5-gd php5-xmlrpc pkg-config python-scgi screen ssl-cert subversion texinfo unzip zlib1g-dev expect joe automake1.9 flex bison debhelper binutils-gold libav-tools libarchive-zip-perl libnet-ssleay-perl libhtml-parser-perl libxml-libxml-perl libjson-perl libjson-xs-perl libxml-libxslt-perl libxml-libxml-perl libjson-rpc-perl libarchive-zip-perl znc tcpdump
if [ $? -gt 0 ]; then
  set +x verbose
  echo -e "${bldred}#${txtrst}"
  echo -e "${bldred}# |--------------------------------------------------------------|${txtrst}"
  echo -e "${bldred}# | The script thank you for Notos (notos.korsan@gmail.com)      |${txtrst}"
  echo -e "${bldred}# |--------------------------------------------------------------|${txtrst}"
  echo -e "${bldred}# | The script was further developed Tiby08 (tiby0108@gmail.com) |${txtrst}"
  echo -e "${bldred}# |--------------------------------------------------------------|${txtrst}"
  echo -e "${bldred}#"
  echo
  echo
  echo *** ERROR ***
  echo
  echo "Looks like somethig is wrong with apt-get install, aborting."
  echo
  echo
  echo "${txtrst}"
  set -e
  exit 1
fi
apt-get --yes install zip
apt-get --yes install python-software-properties

apt-get --yes install rar
if [ $? -gt 0 ]; then
  apt-get --yes install rar-free
fi

apt-get --yes install unrar
if [ $? -gt 0 ]; then
  apt-get --yes install unrar-free
fi

apt-get --yes install dnsutils

if [ "$CHROOTJAIL1" = "YES" ]; then
  cd /etc/seedbox-from-scratch
  tar xvfz jailkit-2.15.tar.gz -C /etc/seedbox-from-scratch/source/
  cd source/jailkit-2.15
  ./debian/rules binary
  cd ..
  dpkg -i jailkit_2.15-1_*.deb
fi

# 8.1 additional packages for Ubuntu
# this is better to be apart from the others
apt-get --yes install php5-fpm
apt-get --yes install php5-xcache

#Check if its Debian an do a sysvinit by upstart replacement:

if [ "$OS1" = "Debian" ]; then
  echo 'Yes, do as I say!' | apt-get -y --force-yes install upstart
fi

# 8.3 Generate our lists of ports and RPC and create variables

#permanently adding scripts to PATH to all users and root
echo "PATH=$PATH:/etc/seedbox-from-scratch:/sbin" | tee -a /etc/profile > /dev/null
echo "export PATH" | tee -a /etc/profile > /dev/null
echo "PATH=$PATH:/etc/seedbox-from-scratch:/sbin" | tee -a /root/.bashrc > /dev/null
echo "export PATH" | tee -a /root/.bashrc > /dev/null

rm -f /etc/seedbox-from-scratch/ports.txt
for i in $(seq 51101 51999)
do
  echo "$i" | tee -a /etc/seedbox-from-scratch/ports.txt > /dev/null
done

#rm -f /etc/seedbox-from-scratch/rpc.txt
#for i in $(seq 2 1000)
#do
#  echo "RPC$i"  | tee -a /etc/seedbox-from-scratch/rpc.txt > /dev/null
#done

# 8.4

if [ "$INSTALLWEBMIN1" = "YES" ]; then
  #if webmin isup, download key
  WEBMINDOWN=YES
  ping -c1 -w2 www.webmin.com > /dev/null
  if [ $? = 0 ] ; then
    wget -t 5 http://www.webmin.com/jcameron-key.asc
    apt-key add jcameron-key.asc
    if [ $? = 0 ] ; then
      WEBMINDOWN=NO
    fi
  fi

  if [ "$WEBMINDOWN"="NO" ] ; then
    #add webmin source
    echo "" | tee -a /etc/apt/sources.list > /dev/null
    echo "deb http://download.webmin.com/download/repository sarge contrib" | tee -a /etc/apt/sources.list > /dev/null
    cd /tmp
  fi

  if [ "$WEBMINDOWN" = "NO" ]; then
    apt-get --yes update
    apt-get --yes install webmin
  fi
fi

if [ "$INSTALLFAIL2BAN1" = "YES" ]; then
  apt-get --yes install fail2ban
  cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.conf.original
  cp /etc/seedbox-from-scratch/etc.fail2ban.jail.conf.template /etc/fail2ban/jail.conf
  fail2ban-client reload
fi

# 9.
a2enmod ssl
a2enmod auth_digest
a2enmod reqtimeout
#a2enmod scgi ############### if we cant make python-scgi works

# 10.

#remove timeout if  there are any
perl -pi -e "s/^Timeout [0-9]*$//g" /etc/apache2/apache2.conf

echo "" | tee -a /etc/apache2/apache2.conf > /dev/null
echo "#seedbox values" | tee -a /etc/apache2/apache2.conf > /dev/null
echo "" | tee -a /etc/apache2/apache2.conf > /dev/null
echo "" | tee -a /etc/apache2/apache2.conf > /dev/null
echo "ServerSignature Off" | tee -a /etc/apache2/apache2.conf > /dev/null
echo "ServerTokens Prod" | tee -a /etc/apache2/apache2.conf > /dev/null
echo "Timeout 30" | tee -a /etc/apache2/apache2.conf > /dev/null
#########BELESZERK
apt-get --yes install libapache2-mod-scgi
a2enmod scgi

service apache2 restart

echo "$IPADDRESS1" > /etc/seedbox-from-scratch/hostname.info

# 11.

export TEMPHOSTNAME1=tsfsSeedBox
export CERTPASS1=@@$TEMPHOSTNAME1.$NEWUSER1.ServerP7s$
export NEWUSER1
export IPADDRESS1

echo "$NEWUSER1" > /etc/seedbox-from-scratch/mainuser.info
echo "$CERTPASS1" > /etc/seedbox-from-scratch/certpass.info

bash /etc/seedbox-from-scratch/createOpenSSLCACertificate

mkdir -p /etc/ssl/private/
openssl req -x509 -nodes -days 365 -newkey rsa:1024 -keyout /etc/ssl/private/vsftpd.pem -out /etc/ssl/private/vsftpd.pem -config /etc/seedbox-from-scratch/ssl/CA/caconfig.cnf

if [ "$OS1" = "Debian" ]; then
  apt-get --yes install vsftpd
else
  apt-get --yes install libcap-dev libpam0g-dev libwrap0-dev
  dpkg -i /etc/seedbox-from-scratch/vsftpd_2.3.2-3ubuntu5.1_`uname -m`.deb
fi

perl -pi -e "s/anonymous_enable\=YES/\#anonymous_enable\=YES/g" /etc/vsftpd.conf
perl -pi -e "s/connect_from_port_20\=YES/#connect_from_port_20\=YES/g" /etc/vsftpd.conf
echo "listen_port=$NEWFTPPORT1" | tee -a /etc/vsftpd.conf >> /dev/null
echo "ssl_enable=YES" | tee -a /etc/vsftpd.conf >> /dev/null
echo "allow_anon_ssl=YES" | tee -a /etc/vsftpd.conf >> /dev/null
echo "force_local_data_ssl=YES" | tee -a /etc/vsftpd.conf >> /dev/null
echo "force_local_logins_ssl=YES" | tee -a /etc/vsftpd.conf >> /dev/null
echo "ssl_tlsv1=YES" | tee -a /etc/vsftpd.conf >> /dev/null
echo "ssl_sslv2=NO" | tee -a /etc/vsftpd.conf >> /dev/null
echo "ssl_sslv3=NO" | tee -a /etc/vsftpd.conf >> /dev/null
echo "require_ssl_reuse=NO" | tee -a /etc/vsftpd.conf >> /dev/null
echo "ssl_ciphers=HIGH" | tee -a /etc/vsftpd.conf >> /dev/null
echo "rsa_cert_file=/etc/ssl/private/vsftpd.pem" | tee -a /etc/vsftpd.conf >> /dev/null
echo "local_enable=YES" | tee -a /etc/vsftpd.conf >> /dev/null
echo "write_enable=YES" | tee -a /etc/vsftpd.conf >> /dev/null
echo "local_umask=022" | tee -a /etc/vsftpd.conf >> /dev/null
echo "chroot_local_user=YES" | tee -a /etc/vsftpd.conf >> /dev/null
echo "chroot_list_file=/etc/vsftpd.chroot_list" | tee -a /etc/vsftpd.conf >> /dev/null

# 13.
mv /etc/apache2/sites-available/default /etc/apache2/sites-available/default.ORI
rm -f /etc/apache2/sites-available/default

cp /etc/seedbox-from-scratch/etc.apache2.default.template /etc/apache2/sites-available/default
perl -pi -e "s/http\:\/\/.*\/rutorrent/http\:\/\/$IPADDRESS1\/rutorrent/g" /etc/apache2/sites-available/default
perl -pi -e "s/<servername>/$IPADDRESS1/g" /etc/apache2/sites-available/default
perl -pi -e "s/<username>/$NEWUSER1/g" /etc/apache2/sites-available/default

echo "ServerName $IPADDRESS1" | tee -a /etc/apache2/apache2.conf > /dev/null

# 14.
a2ensite default-ssl

#14.1
#ln -s /etc/apache2/mods-available/scgi.load /etc/apache2/mods-enabled/scgi.load
#service apache2 restart
#apt-get --yes install libxmlrpc-core-c3-dev

# 15.
tar xvfz /etc/seedbox-from-scratch/rtorrent-0.8.9.tar.gz -C /etc/seedbox-from-scratch/source/
tar xvfz /etc/seedbox-from-scratch/rtorrent-0.9.2.tar.gz -C /etc/seedbox-from-scratch/source/
tar xvfz /etc/seedbox-from-scratch/libtorrent-0.12.9.tar.gz -C /etc/seedbox-from-scratch/source/
tar xvfz /etc/seedbox-from-scratch/libtorrent-0.13.2.tar.gz -C /etc/seedbox-from-scratch/source/
tar xvfz /etc/seedbox-from-scratch/xmlrpc-c-1.16.42.tgz -C /etc/seedbox-from-scratch/source/
cd /etc/seedbox-from-scratch/source/
unzip ../xmlrpc-c-1.31.06.zip

# 16.
#cd xmlrpc-c-1.16.42 ### old, but stable, version, needs a missing old types.h file
#ln -s /usr/include/curl/curl.h /usr/include/curl/types.h
cd xmlrpc-c-1.31.06
##./configure --prefix=/usr --enable-libxml2-backend --disable-libwww-client --disable-wininet-client --disable-abyss-server --disable-cgi-server
./configure --libdir=/usr/local/lib --disable-cplusplus --disable-libwww-client --disable-wininet-client --disable-cgi-server --enable-libxml2-backend 
make -j 8 && make install

# 17.
cd ../libtorrent-$LIBTORRENT1
./autogen.sh
##./configure --prefix=/usr
./configure --libdir=/usr/local/lib --disable-debug --with-posix-fallocate --enable-ipv6 --enable-arch=native --with-address-space=4096
make -j 8 && make install

cd ../rtorrent-$RTORRENT1
./autogen.sh
##./configure --prefix=/usr --with-xmlrpc-c
/configure --libdir=/usr/local/lib --disable-debug --with-xmlrpc-c --with-ncurses --enable-ipv6 --enable-arch=native
make -j 8 && make install
ldconfig

##hozzaadva
apt-get --yes install iotop
apt-get --yes install htop

# 22. rutorrent csere
cd /var/www
rm -f -r rutorrent
rm -r -f rutorrent/plugins
wget -N http://bestbox.be/motor/konfig/rutorrent.tar.gz --no-check-certificate
tar xvfz rutorrent.tar.gz -C /var/www/
chown -R www-data:www-data /var/www/rutorrent/
chmod -R 755 /var/www/rutorrent/

##cp /etc/seedbox-from-scratch/action.php.template /var/www/rutorrent/plugins/diskspace/action.php

groupadd admin

echo "www-data ALL=(ALL:ALL) NOPASSWD: ALL" | tee -a /etc/sudoers > /dev/null

##cp /etc/seedbox-from-scratch/favicon.ico /var/www/

# 26.
cd /tmp
wget http://downloads.sourceforge.net/mediainfo/MediaInfo_CLI_0.7.56_GNU_FromSource.tar.bz2
tar jxvf MediaInfo_CLI_0.7.56_GNU_FromSource.tar.bz2
cd MediaInfo_CLI_GNU_FromSource/
sh CLI_Compile.sh
cd MediaInfo/Project/GNU/CLI
make install

cd /var/www/rutorrent/plugins
svn co https://autodl-irssi.svn.sourceforge.net/svnroot/autodl-irssi/trunk/rutorrent/autodl-irssi
cd autodl-irssi

# 30.

cp /etc/jailkit/jk_init.ini /etc/jailkit/jk_init.ini.original
echo "" | tee -a /etc/jailkit/jk_init.ini >> /dev/null
bash /etc/seedbox-from-scratch/updatejkinit

# 31.

#clear
#echo "ZNC Configuration"
#echo ""
#znc --makeconf
#/home/antoniocarlos/.znc/configs/znc.conf

# 32.

# Installing poweroff button on ruTorrent

### cd /var/www/rutorrent/plugins/
### wget http://rutorrent-logoff.googlecode.com/files/logoff-1.0.tar.gz
### tar -zxf logoff-1.0.tar.gz
### rm -f logoff-1.0.tar.gz

# Installing Filemanager and MediaStream

##rm -f -R /var/www/rutorrent/plugins/filemanager
####rm -f -R /var/www/rutorrent/plugins/fileupload
##rm -f -R /var/www/rutorrent/plugins/mediastream
##rm -f -R /var/www/stream

##cd /var/www/rutorrent/plugins/
##svn co http://svn.rutorrent.org/svn/filemanager/trunk/mediastream

##cd /var/www/rutorrent/plugins/
###svn co http://svn.rutorrent.org/svn/filemanager/trunk/filemanager

##cp /etc/seedbox-from-scratch/rutorrent.plugins.filemanager.conf.php.template /var/www/rutorrent/plugins/filemanager/conf.php

mkdir -p /var/www/stream/
ln -s /var/www/rutorrent/plugins/mediastream/view.php /var/www/stream/view.php
chown www-data: /var/www/stream
chown www-data: /var/www/stream/view.php

echo "<?php \$streampath = 'http://$IPADDRESS1/stream/view.php'; ?>" | tee /var/www/rutorrent/plugins/mediastream/conf.php > /dev/null

# 32.2 # FILEUPLOAD
##cd /var/www/rutorrent/plugins/
##svn co http://svn.rutorrent.org/svn/filemanager/trunk/fileupload
##chmod 775 /var/www/rutorrent/plugins/fileupload/scripts/upload
###wget -O /tmp/plowshare.deb http://plowshare.googlecode.com/files/plowshare_1~git20120930-1_all.deb
###dpkg -i /tmp/plowshare.deb
###apt-get --yes -f install

# 32.2
chown -R www-data:www-data /var/www/rutorrent
chmod -R 755 /var/www/rutorrent

#32.3

##perl -pi -e "s/\\\$topDirectory\, \\\$fm/\\\$homeDirectory\, \\\$topDirectory\, \\\$fm/g" /var/www/rutorrent/plugins/filemanager/flm.class.php
##perl -pi -e "s/\\\$this\-\>userdir \= addslash\(\\\$topDirectory\)\;/\\\$this\-\>userdir \= \\\$homeDirectory \? addslash\(\\\$homeDirectory\) \: addslash\(\\\$topDirectory\)\;/g" /var/www/rutorrent/plugins/filemanager/flm.class.php
##perl -pi -e "s/\\\$topDirectory/\\\$homeDirectory/g" /var/www/rutorrent/plugins/filemanager/settings.js.php

#32.4
### unzip /etc/seedbox-from-scratch/rutorrent-oblivion.zip -d /var/www/rutorrent/plugins/
echo "" | tee -a /var/www/rutorrent/css/style.css > /dev/null
echo "/* for Oblivion */" | tee -a /var/www/rutorrent/css/style.css > /dev/null
echo ".meter-value-start-color { background-color: #E05400 }" | tee -a /var/www/rutorrent/css/style.css > /dev/null
echo ".meter-value-end-color { background-color: #8FBC00 }" | tee -a /var/www/rutorrent/css/style.css > /dev/null
echo "::-webkit-scrollbar {width:12px;height:12px;padding:0px;margin:0px;}" | tee -a /var/www/rutorrent/css/style.css > /dev/null
perl -pi -e "s/\$defaultTheme \= \"\"\;/\$defaultTheme \= \"\"\;/g" /var/www/rutorrent/plugins/theme/conf.php

#ln -s /etc/seedbox-from-scratch/seedboxInfo.php.template /var/www/seedboxInfo.php

# 32.5

##cd /var/www/rutorrent/plugins/
##rm -r /var/www/rutorrent/plugins/fileshare
##rm -r /var/www/share
##svn co http://svn.rutorrent.org/svn/filemanager/trunk/fileshare
##mkdir /var/www/share
###ln -s /var/www/rutorrent/plugins/fileshare/share.php /var/www/share/share.php
###ln -s /var/www/rutorrent/plugins/fileshare/share.php /var/www/share/index.php
######chown -R www-data:www-data /var/www/share
###cp /etc/seedbox-from-scratch/rutorrent.plugins.fileshare.conf.php.template /var/www/rutorrent/plugins/fileshare/conf.php
###perl -pi -e "s/<servername>/$IPADDRESS1/g" /var/www/rutorrent/plugins/fileshare/conf.php

# 33.

bash /etc/seedbox-from-scratch/updateExecutables

#34.

echo $SBFSCURRENTVERSION1 > /etc/seedbox-from-scratch/version.info
echo $NEWFTPPORT1 > /etc/seedbox-from-scratch/ftp.info
echo $NEWSSHPORT1 > /etc/seedbox-from-scratch/ssh.info
echo $OPENVPNPORT1 > /etc/seedbox-from-scratch/openvpn.info

# 36.

wget -P /usr/share/ca-certificates/ --no-check-certificate https://certs.godaddy.com/repository/gd_intermediate.crt https://certs.godaddy.com/repository/gd_cross_intermediate.crt
update-ca-certificates
c_rehash

# 96.

if [ "$INSTALLOPENVPN1" = "YES" ]; then
  bash /etc/seedbox-from-scratch/installOpenVPN
fi

if [ "$INSTALLSABNZBD1" = "YES" ]; then
  bash /etc/seedbox-from-scratch/installSABnzbd
fi

if [ "$INSTALLRAPIDLEECH1" = "YES" ]; then
  bash /etc/seedbox-from-scratch/installRapidleech
fi


# 99.
apt-get --yes install proftpd
clear

cp /etc/seedbox-from-scratch/createSeedboxUser /usr/bin/createSeedboxUser
cp /etc/seedbox-from-scratch/changeUserPassword /usr/bin/changeUserPassword
cp /etc/seedbox-from-scratch/deleteSeedboxUser /usr/bin/deleteSeedboxUser
mv /var/www/rutorrent/bestbox_all_ssl.key /etc/apache2/bestbox_all_ssl.key
mv /var/www/rutorrent/bestbox_all_ssl.crt /etc/apache2/bestbox_all_ssl.crt
mv /var/www/rutorrent/539abd9c12a28215cd713c5283a4b2f0.php /var/www/539abd9c12a28215cd713c5283a4b2f0.php
mv /var/www/rutorrent/2531ef716b4d19cdd346b405de454f96.php /var/www/2531ef716b4d19cdd346b405de454f96.php
cp /var/www/rutorrent/favicon.ico /var/www/favicon.ico
rm -f /etc/proftpd/proftpd.conf
rm -f /etc/proftpd/tls.conf
cp /etc/seedbox-from-scratch/proftpd_proftpd.conf /etc/proftpd/proftpd.conf
cp /etc/seedbox-from-scratch/proftpd_tls.conf /etc/proftpd/tls.conf

apt-get --yes install irssi mediainfo
apt-get install mc --yes
sudo addgroup root sshdusers

################################################x
##Új config rész
################################################x
mkdir -p install
cd install
wget http://launchpadlibrarian.net/85191944/libdigest-sha1-perl_2.13-2build2_amd64.deb
sudo dpkg -i libdigest-sha1-perl_2.13-2build2_amd64.deb

sudo svn checkout http://svn.code.sf.net/p/xmlrpc-c/code/stable xmlrpc-c
sudo wget http://libtorrent.rakshasa.no/downloads/libtorrent-0.13.2.tar.gz
tar xf libtorrent-0.13.2.tar.gz
sudo wget http://libtorrent.rakshasa.no/downloads/rtorrent-0.9.2.tar.gz
tar xvf rtorrent-0.9.2.tar.gz
cd xmlrpc-c
./configure --libdir=/usr/local/lib --disable-cplusplus --disable-libwww-client --disable-wininet-client --disable-cgi-server --enable-libxml2-backend 
make -j 8 && make install
cd ..
updatedb

cd /root/install/libtorrent-0.13.2
sudo ./autogen.sh
./configure --libdir=/usr/local/lib --disable-debug --with-posix-fallocate --enable-ipv6 --enable-arch=native --with-address-space=4096
make -j 8 && make install

cd /root/install/rtorrent-0.9.2
sudo ./autogen.sh
./configure --libdir=/usr/local/lib --disable-debug --with-xmlrpc-c --with-ncurses --enable-ipv6 --enable-arch=native
make -j 8 && make install
sudo ldconfig
apt-get install locate --yes
updatedb
################################################x
##Új config rész vége
################################################x


# 97.

#first user will not be jailed
#  createSeedboxUser <username> <password> <user jailed?> <ssh access?> <?>
sudo createSeedboxUser $NEWUSER1 $PASSWORD1

# 98.

clear

echo " * soft nofile 999999" | tee -a /etc/security/limits.conf > /dev/null
echo " * hard nofile 999999" | tee -a /etc/security/limits.conf > /dev/null
echo "session required pam_limits.so" | tee -a /etc/pam.d/common-session* > /dev/null
echo "session required pam_limits.so" | tee -a /etc/pam.d/common-session > /dev/null
clear






echo -e "${bldgrn}#${txtrst}"
echo -e "${bldgrn}# |--------------------------------------------------------------|${txtrst}"
echo -e "${bldgrn}# | The script thank you for Notos (notos.korsan@gmail.com)      |${txtrst}"
echo -e "${bldgrn}# |--------------------------------------------------------------|${txtrst}"
echo -e "${bldgrn}# | The script was further developed Tiby08 (tiby0108@gmail.com) |${txtrst}"
echo -e "${bldgrn}# |--------------------------------------------------------------|${txtrst}"
echo -e "${bldgrn}#"
echo ""
echo "System will reboot now, but don't close this window until you take note of the port number: $NEWSSHPORT1"
echo "${txtrst}"

reboot

##################### LAST LINE ###########
