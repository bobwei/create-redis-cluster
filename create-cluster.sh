export $(cat .env | xargs)

node_addresses="$(for index in `seq 1 6`; do \
echo "$(docker inspect -f \
"{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}" \
"${PROJECT_NAME}_${SERVICE_NAME}_$index"):6379"
done)"

echo $node_addresses

docker run -i --rm --net $NETWORK_NAME ruby sh -c '\
 gem install redis \
 && wget http://download.redis.io/redis-stable/src/redis-trib.rb \
 && ruby redis-trib.rb create --replicas 1 "$node_addresses"'
