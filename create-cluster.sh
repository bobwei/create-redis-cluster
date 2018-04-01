export $(cat .env | xargs)

for index in `seq 1 $NUMBER_OF_NODES`; do \
  node_addresses="$(docker inspect -f \
  "{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}" \
  "${PROJECT_NAME}_${SERVICE_NAME}_$index"):6379 $node_addresses"
done

echo "$node_addresses \n"

cmd=$(echo "\
  gem install redis \
  && wget http://download.redis.io/redis-stable/src/redis-trib.rb \
  && ruby redis-trib.rb create --replicas 1 ${node_addresses} \
")

docker run -i --rm --net $NETWORK_NAME ruby sh -c "$cmd"
