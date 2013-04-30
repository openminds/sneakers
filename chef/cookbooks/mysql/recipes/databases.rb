execute "create database and user" do
  command <<-EOC
  DB="#{node[:base][:name]}"
  USER="#{node[:base][:name]}"
  PASS="vagrant"

  echo "user: $USER, db: $DB, pass: $PASS"

  echo "create database $DB; grant all on $DB.* to $USER@localhost identified by '$PASS'; grant create view on $DB.* to $USER@localhost identified by '$PASS'; grant show view on $DB.* to $USER@localhost identified by '$PASS'" | mysql --defaults-file=/root/.my.cnf mysql
  echo "server: localhost"
  echo "database: $DB"
  echo "db user:  $USER"
  echo "db pass:  $PASS"
  echo ""
  echo ""
  EOC
  not_if "mysql -e \"show databases\" | grep vagrant"
end
