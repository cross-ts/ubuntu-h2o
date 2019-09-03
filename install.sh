#!/usr/bin/env bash

H2O_VERSION=2.2.6
TAR_BALL="v${H2O_VERSION}.tar.gz"

RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
RESET="\e[m"

if [[ -e /usr/local/bin/h2o ]]; then
  echo -e "${RED}h2o is already installed.${RESET}"
  exit 1
fi

echo -e "${YELLOW}Install requirements for build h2o from apt-get.${RESET}"
sudo apt-get -qq update
sudo apt-get -qq install -y build-essential zlib1g-dev cmake curl
echo -e "${GREEN}done.${RESET}"

echo -e "${YELLOW}Download source code tarball from github.${RESET}"
cd /tmp
curl -sSL -O https://github.com/h2o/h2o/archive/${TAR_BALL}
tar xzf ${TAR_BALL}
rm ${TAR_BALL}
echo -e "${GREEN}done.${RESET}"

echo -e "${YELLOW}Build h2o.${RESET}"
cd /tmp/h2o-${H2O_VERSION}
cmake .
make
make install
cd /tmp
rm -fr /tmp/h2o-${H2O_VERSION}
echo -e "${GREEN}done.${RESET}"

echo -e "${YELLOW}Mkdir for log and configure file.${RESET}"
mkdir -p /var/log/h2o
mkdir -p /etc/h2o
echo -e "${GREEN}done.${RESET}"

echo -e "${YELLOW}Create initial configure file.${RESET}"
cat <<-CONF > /etc/h2o.conf
listen:
  port: 80
user: nobody
hosts:
  "myhost.example.com":
    paths:
      /:
        file.dir: /path/to/the/public-files
access-log: /var/log/h2o/access.log
error-log: /var/log/h2o/error.log
pid-file: /tmp/h2o.pid
CONF
echo -e "${GREEN}done.${RESET}"

echo -e "${GREEN}COMPLETE!!!!${RESET}"
