
#installation des clés publiques/privées
eval `ssh-agent -s`
chmod 0600 key_rsa
ssh-add key_rsa
rm -rf key_rsa
	
#mise en place du root http	
mkdir /home/server_suivi
rm -rf /var/www/html
ln -sf /home/server_suivi/app-etudiant/dist /var/www/html
ln -sf /etc/apache2/sites-available/vhost_backend.conf /etc/apache2/sites-enabled/vhost_backend.conf
service apache2 restart

#Git en master
cd /home/server_suivi
git init
git pull ssh://git@10.1.152.219:10022/InformationSystemNetworkandCloud/Network-system/Suivi_etudiant/suivi_etudiant.git


# pour passer en dev :
#git branch DEV
#git checkout DEV
#modif config du site
sed -i "s/$password = \"\"/$password = \"root\"/g" studentApi/config/database.php
cd app-etudiant
sed -i "s/localhost\:8080/10.1.152.211\:15808/g" src/environments/environment.ts
sed -i "s/localhost\:8080/10.1.152.211\:15808/g" src/environments/environment.prod.ts
npm install rxjs 
npm install zone.js
npm install -g @angular/core --unsafe
npm install angular2-collapsible
npm install -g @angular/cli --unsafe
npm install
ng build --target=production --environment=prod

#parametrage mysql et chargement des données
mysqladmin password root
mysql -uroot -proot < /home/server_suivi/sql/DBSuiviEtudiant.sql
mysql -uroot -proot students_db< /home/server_suivi/sql/Data.sql
sed -i "s/bind-address/\#bind-address/g" /etc/mysql/mysql.conf.d/mysqld.cnf
service mysql restart

#installation silencieuse de phpmyadmin
APP_PASS="root"
ROOT_PASS="root"
APP_DB_PASS="root"
echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" | debconf-set-selections
echo "phpmyadmin phpmyadmin/app-password-confirm password $APP_PASS" | debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/admin-pass password $ROOT_PASS" | debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/app-pass password $APP_DB_PASS" | debconf-set-selections
echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2" | debconf-set-selections
apt-get install -y phpmyadmin
service apache2 restart

#rm -rf script.sh