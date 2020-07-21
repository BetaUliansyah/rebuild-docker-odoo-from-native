# menghapus
POSTGRES_DOCKER_ID=`docker ps -a | grep postgres: | awk '{print $1}'`
docker exec -it $POSTGRES_DOCKER_ID dropdb -U odoo bukukoe -W
docker-compose stop
docker-compose rm

# menyiapkan docker baru
docker-compose up -d
ODOO_DOCKER_ID=`docker ps -a | grep odoo: | awk '{print $1}'`
POSTGRES_DOCKER_ID=`docker ps -a | grep postgres: | awk '{print $1}'`
docker exec -u root -it $ODOO_DOCKER_ID /bin/mkdir -p /var/lib/odoo/filestore
docker cp -a ~/.local/share/Odoo/filestore/bukukoe/ $ODOO_DOCKER_ID:/var/lib/odoo/filestore
docker exec -u root -it $ODOO_DOCKER_ID /bin/chown odoo.odoo /var/lib/odoo/filestore -R
docker exec -u root -it $ODOO_DOCKER_ID /usr/bin/pip3 install simplejson
docker exec -u root -it $ODOO_DOCKER_ID /usr/bin/pip3 install pysftp
rm -rf bukukoe.dump
pg_dump -E UTF-8 -F p -b -f bukukoe.dump bukukoe
docker exec -i $POSTGRES_DOCKER_ID createdb -U odoo bukukoe -W
cat bukukoe.dump | docker exec -i $POSTGRES_DOCKER_ID psql -U odoo bukukoe -W
docker-compose restart
