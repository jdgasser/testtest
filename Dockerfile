FROM ubuntu:16.04
MAINTAINER Jean-Daniel Gasser <jean-daniel.gasser@altran.com>

# Setup environment
#ENV DEBIAN_FRONTEND noninteractive

# Update sources
RUN apt-get update -y

# install http
RUN apt-get install -y apache2 vim bash-completion unzip
RUN mkdir -p /var/lock/apache2 /var/run/apache2

# install mysql
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-client mysql-server
#RUN echo "NETWORKING=yes" > /etc/sysconfig/network
# start mysqld to create initial tables
#RUN service mysqld start

# install MongoDB
RUN apt-get install -y mongodb mongodb-server mongodb-clients

# install php
#RUN apt-get install -y php7 php7-mysql php7-dev php7-gd php7-memcache php7-pspell php7-xmlrpc libapache2-mod-php7 php7-cli
RUN apt-get install -y php7.0 php7.0-mysql libapache2-mod-php7.0 
#RUN yum install -y php php-mysql php-devel php-gd php-pecl-memcache php-pspell php-snmp php-xmlrpc php-xml

#Install curl
RUN apt-get install -y curl

#install sudo
RUN apt-get install -y sudo

# install nodejs 8.9.4 (dernière stable en 8.x)

RUN curl -sL https://deb.nodesource.com/setup_8.x | sudo bash -
RUN apt-get install -y nodejs
RUN npm install angular2-collapsible
RUN npm install -g @angular/cli --unsafe

# install git
RUN apt-get install -y git

# install sshd
RUN apt-get install -y openssh-server openssh-client passwd
RUN mkdir -p /var/run/sshd
RUN sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config

#RUN ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key && ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key 
#RUN sed -ri 's/PermitRootLogin without-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
RUN echo 'root:root' | chpasswd

# Put your own public key at id_rsa.pub for key-based login.
#RUN mkdir -p /root/.ssh && touch /root/.ssh/authorized_keys && chmod 700 /root/.ssh
#ADD id_rsa.pub /root/.ssh/authorized_keys


#ADD phpinfo.php /var/www/html/
#ADD supervisord.conf /etc/
ADD test.txt /root/
EXPOSE 22 80 

CMD ["supervisord", "-n"]
#CMD ["/bin/bash"]
#CMD  ["/usr/sbin/sshd", "-D"]
#CMD service mysql start && service apache2 start && service mongodb start && /usr/sbin/sshd -D