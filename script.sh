
#installation des clés publiques/privées
eval `ssh-agent -s`
chmod 0600 key_rsa
ssh-add key_rsa
rm -rf key_rsa
	
#mise en place du root http	
mkdir /home/server_suivi
rm -rf /var/www/html
ln -sf /home/server_suivi/app-etudiant/dist /var/www/html

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

#service mysql start
#penser à ajouter un root@%
#penser à virer la ligne bind-adress dans la conf /etc/mysql/mysql.conf.d/mysqld.cnf
mysqladmin password root
mysql -uroot -proot < /home/server_suivi/sql/DBSuiviEtudiant.sql
mysql -uroot -proot students_db< /home/server_suivi/sql/Data.sql
