execute "create database and user" do
  command <<-EOC
  DB="#{node[:base][:name]}"
  USER="#{node[:base][:name]}"
  PASS="vagrant"

  echo "user: $USER, db: $DB, pass: $PASS"

  echo "create database $DB; grant all on $DB.* to $USER@'%' identified by '$PASS'; grant create view on $DB.* to $USER@'%' identified by '$PASS'; grant show view on $DB.* to $USER@'%' identified by '$PASS'" | mysql --defaults-file=/root/.my.cnf mysql
  echo "server: localhost"
  echo "database: $DB"
  echo "db user:  $USER"
  echo "db pass:  $PASS"
  echo ""
  echo ""
  EOC
  not_if "mysql -e \"select * from mysql.user\" | grep % | grep vagrant"
end

execute "allow remote access for mysql root user" do
  command <<-EOC
  echo "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'vagrant' WITH GRANT OPTION;"  | mysql --defaults-file=/root/.my.cnf mysql
  echo "FLUSH PRIVILEGES;"  | mysql --defaults-file=/root/.my.cnf mysql
  EOC
  not_if "mysql -e \"select * from mysql.user\" | grep % | grep root"
end
