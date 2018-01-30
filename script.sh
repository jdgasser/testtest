
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

cd app-etudiant
npm install rxjs 
npm install zone.js
npm install -g @angular/core --unsafe
npm install angular2-collapsible
npm install -g @angular/cli --unsafe
npm install
ng build --target=production --environment=prod

#service mysql start
mysqladmin password root
mysql -uroot -proot < sql/DBSuiviEtudiant.sql
mysql -uroot -proot students_db< sql/Data.sql