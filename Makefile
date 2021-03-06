IMG=assignment4-img
NETWORK=mynet

.PHONY: all init restart
all: destroy network build
init: network build
putall: put1 put2 put3 put4 put5 put6
restart: kill build2 

###############################################################################
############################ CONTAINER OPERATIONS #############################
###############################################################################

build: network
	docker build -t $(IMG) .

network:
	docker network create --subnet=10.10.0.0/16 $(NETWORK)

kill:
	docker kill $$(docker ps -q)
	
# This removes and kills ALL docker images on the system
# not just for this assignment.
destroy: # If failing you can try to run with the -i flag   
	docker kill $$(docker ps -q)
	docker rm $$(docker ps -a -q)
	docker rmi $$(docker images -q)
	docker network rm $(NETWORK)

# Stops all running containers and removes them
stop:
	docker stop $$(docker ps -a -q)

remove:
	docker container rm $$(docker container ls -aq)

stop_remove:
	docker stop $$(docker ps -a -q)
	docker container rm $$(docker container ls -aq)

build2: 
	docker build -t $(IMG) .

test:
	python3 test_assignment4.py

###############################################################################
################################## REPLICAS ###################################
###############################################################################
replica1:
	docker run --rm -p 8082:8085 --net=$(NETWORK) --ip=10.10.0.2 --name="node1" \
	-e SOCKET_ADDRESS="10.10.0.2:8085" -e VIEW="10.10.0.2:8085,10.10.0.3:8085,10.10.0.4:8085,10.10.0.5:8085,10.10.0.6:8085,10.10.0.7:8085" \
	-e SHARD_COUNT="2" $(IMG)

replica2:
	docker run --rm -p 8083:8085 --net=$(NETWORK) --ip=10.10.0.3 --name="node2" \
	-e SOCKET_ADDRESS="10.10.0.3:8085" -e VIEW="10.10.0.2:8085,10.10.0.3:8085,10.10.0.4:8085,10.10.0.5:8085,10.10.0.6:8085,10.10.0.7:8085" \
	-e SHARD_COUNT="2" $(IMG)

replica3:
	docker run --rm -p 8084:8085 --net=mynet --ip=10.10.0.4 --name="node3" \
	-e SOCKET_ADDRESS="10.10.0.4:8085" -e VIEW="10.10.0.2:8085,10.10.0.3:8085,10.10.0.4:8085,10.10.0.5:8085,10.10.0.6:8085,10.10.0.7:8085" \
	-e SHARD_COUNT="2" $(IMG)

replica4: 
	docker run --rm -p 8086:8085 --net=mynet --ip=10.10.0.5 --name="node4" \
        -e SOCKET_ADDRESS="10.10.0.5:8085" -e VIEW="10.10.0.2:8085,10.10.0.3:8085,10.10.0.4:8085,10.10.0.5:8085,10.10.0.6:8085,10.10.0.7:8085" \
        -e SHARD_COUNT="2" $(IMG)

replica5: 
	docker run --rm -p 8087:8085 --net=mynet --ip=10.10.0.6 --name="node5" \
        -e SOCKET_ADDRESS="10.10.0.6:8085" -e VIEW="10.10.0.2:8085,10.10.0.3:8085,10.10.0.4:8085,10.10.0.5:8085,10.10.0.6:8085,10.10.0.7:8085" \
        -e SHARD_COUNT="2" $(IMG)

replica6:
	docker run --rm -p 8088:8085 --net=mynet --ip=10.10.0.7 --name="node6" \
        -e SOCKET_ADDRESS="10.10.0.7:8085" -e VIEW="10.10.0.2:8085,10.10.0.3:8085,10.10.0.4:8085,10.10.0.5:8085,10.10.0.6:8085,10.10.0.7:8085" \
	-e SHARD_COUNT="2" $(IMG)

replica7:
	docker run --rm -p 8089:8085 --net=mynet --ip=10.10.0.8 --name="node7" \
        -e SOCKET_ADDRESS="10.10.0.8:8085" -e VIEW="10.10.0.2:8085,10.10.0.3:8085,10.10.0.4:8085,10.10.0.5:8085,10.10.0.6:8085,10.10.0.7:8085,10.10.0.8:8085" $(IMG)

###############################################################################
################################# CONNECTIONS #################################
###############################################################################	

connect1:
	docker network connect mynet replica1

connect2:
	docker network connect mynet replica2

connect3:
	docker network connect mynet replica3

connect4:
	docker network connect mynet replica4

connect5:
	docker network connect mynet replica5

connect6:
	docker network connect mynet replica6

connect7:
	docker network connect mynet replica7

###############################################################################
################################ DISCONNECTIONS ###############################
###############################################################################	

disconnect1:
	docker network disconnect mynet replica1

disconnect2:
	docker network disconnect mynet replica2

disconnect3:
	docker network disconnect mynet replica3

disconnect4:
	docker network disconnect mynet replica4

disconnect5:
	docker network disconnect mynet replica5

disconnect6:
	docker network disconnect mynet replica6

disconnect7:
	docker network disconnect mynet replica7

###############################################################################
##################################### PUT #####################################
###############################################################################

put1:
	curl --request PUT --header "Content-Type: application/json" --write-out "\n%{http_code}\n" --data '{"value":"value0", "causal-metadata": ""}' http://localhost:8082/key-value-store/key0

put2:
	curl --request PUT --header "Content-Type: application/json" --write-out "\n%{http_code}\n" --data '{"value":"value1", "causal-metadata": ""}' http://localhost:8083/key-value-store/key1

put3:
	curl --request PUT --header "Content-Type: application/json" --write-out "\n%{http_code}\n" --data '{"value":"value2", "causal-metadata": ""}' http://localhost:8084/key-value-store/key2

put4:
	curl --request PUT --header "Content-Type: application/json" --write-out "\n%{http_code}\n" --data '{"value":"value3", "causal-metadata": ""}' http://localhost:8086/key-value-store/key3

put5:
	curl --request PUT --header "Content-Type: application/json" --write-out "\n%{http_code}\n" --data '{"value":"value4", "causal-metadata": ""}' http://localhost:8087/key-value-store/key4

put6:
	curl --request PUT --header "Content-Type: application/json" --write-out "\n%{http_code}\n" --data '{"value":"value5", "causal-metadata": ""}' http://localhost:8088/key-value-store/key5

put7:
	curl --request PUT --header "Content-Type: application/json" --write-out "\n%{http_code}\n" --data '{"value":"value6", "causal-metadata": ""}' http://localhost:8089/key-value-store/key6


###############################################################################
################################### GET #######################################
###############################################################################

get1:
	curl --request GET --header "Content-Type: application/json" --write-out "\n%{http_code}\n" http://localhost:8082/key-value-store/key2

get2:
	curl --request GET --header "Content-Type: application/json" --write-out "\n%{http_code}\n" http://localhost:8083/key-value-store/key0

get3:
	curl --request GET --header "Content-Type: application/json" --write-out "\n%{http_code}\n" http://localhost:8084/key-value-store/key1

get4:
	curl --request GET --header "Content-Type: application/json" --write-out "\n%{http_code}\n" http://localhost:8086/key-value-store/key2

get5:
	curl --request GET --header "Content-Type: application/json" --write-out "\n%{http_code}\n" http://localhost:8087/key-value-store/key2

get6:
	curl --request GET --header "Content-Type: application/json" --write-out "\n%{http_code}\n" http://localhost:8088/key-value-store/key2

get7:
	curl --request GET --header "Content-Type: application/json" --write-out "\n%{http_code}\n" http://localhost:8089/key-value-store/x

###############################################################################
################################## UPDATE #####################################
###############################################################################

update1: 
	curl --request PUT --header "Content-Type: application/json" --write-out "\n%{http_code}\n" --data '{"value":2, "causal-metadata": ""}' http://localhost:8082/key-value-store/x

update2:
	curl --request PUT --header "Content-Type: application/json" --write-out "\n%{http_code}\n" --data '{"value":10, "causal-metadata": ""}' http://localhost:8083/key-value-store/x

update3:
	curl --request PUT --header "Content-Type: application/json" --write-out "\n%{http_code}\n" --data '{"value":10, "causal-metadata": ""}' http://localhost:8084/key-value-store/x

update4:
	curl --request PUT --header "Content-Type: application/json" --write-out "\n%{http_code}\n" --data '{"value":10, "causal-metadata": ""}' http://localhost:8086/key-value-store/x

update5:
	curl --request PUT --header "Content-Type: application/json" --write-out "\n%{http_code}\n" --data '{"value":10, "causal-metadata": ""}' http://localhost:8087/key-value-store/x

update6:
	curl --request PUT --header "Content-Type: application/json" --write-out "\n%{http_code}\n" --data '{"value":10, "causal-metadata": ""}' http://localhost:8088/key-value-store/x

update7:
	curl --request PUT --header "Content-Type: application/json" --write-out "\n%{http_code}\n" --data '{"value":10, "causal-metadata": ""}' http://localhost:8089/key-value-store/x

###############################################################################
################################## DELETIONS ##################################
###############################################################################

delete1:
	curl --request DELETE --header "Content-Type: application/json" --write-out "\n%{http_code}\n" --data '{"causal-metadata": ""}' http://localhost:8082/key-value-store/x

delete2:
	curl --request DELETE --header "Content-Type: application/json" --write-out "\n%{http_code}\n" --data '{"causal-metadata": ""}' http://localhost:8083/key-value-store/x

delete3:
	curl --request DELETE --header "Content-Type: application/json" --write-out "\n%{http_code}\n" --data '{"causal-metadata": ""}' http://localhost:8084/key-value-store/x

delete4:
	curl --request DELETE --header "Content-Type: application/json" --write-out "\n%{http_code}\n" --data '{"causal-metadata": ""}' http://localhost:8086/key-value-store/x

delete5:
	curl --request DELETE --header "Content-Type: application/json" --write-out "\n%{http_code}\n" --data '{"causal-metadata": ""}' http://localhost:8087/key-value-store/x

delete6:
	curl --request DELETE --header "Content-Type: application/json" --write-out "\n%{http_code}\n" --data '{"causal-metadata": ""}' http://localhost:8088/key-value-store/x

delete7:
	curl --request DELETE --header "Content-Type: application/json" --write-out "\n%{http_code}\n" --data '{"causal-metadata": ""}' http://localhost:8089/key-value-store/x

###############################################################################
################################### VIEWS #####################################
###############################################################################

view1:
	curl --request GET --header "Content-Type: application/json" --write-out "\n%{http_code}\n" http://localhost:8082/key-value-store-view

view2:
	curl --request GET --header "Content-Type: application/json" --write-out "\n%{http_code}\n" http://localhost:8083/key-value-store-view

view3:
	curl --request GET --header "Content-Type: application/json" --write-out "\n%{http_code}\n" http://localhost:8084/key-value-store-view

view4:
	curl --request GET --header "Content-Type: application/json" --write-out "\n%{http_code}\n" http://localhost:8086/key-value-store-view

view5:
	curl --request GET --header "Content-Type: application/json" --write-out "\n%{http_code}\n" http://localhost:8087/key-value-store-view

view6:
	curl --request GET --header "Content-Type: application/json" --write-out "\n%{http_code}\n" http://localhost:8088/key-value-store-view

view7:
	curl --request GET --header "Content-Type: application/json" --write-out "\n%{http_code}\n" http://localhost:8089/key-value-store-view

###############################################################################
############################## GET LOCAL CLOCK ################################
###############################################################################

getclock1:
	curl --request GET --header "Content-Type: application/json" --write-out "\n%{http_code}\n" http://localhost:8082/get-local-clock

getclock2:
	curl --request GET --header "Content-Type: application/json" --write-out "\n%{http_code}\n" http://localhost:8083/get-local-clock

getclock3:
	curl --request GET --header "Content-Type: application/json" --write-out "\n%{http_code}\n" http://localhost:8084/get-local-clock

getclock4:
	curl --request GET --header "Content-Type: application/json" --write-out "\n%{http_code}\n" http://localhost:8086/get-local-clock

getclock5:
	curl --request GET --header "Content-Type: application/json" --write-out "\n%{http_code}\n" http://localhost:8087/get-local-clock

getclock6:
	curl --request GET --header "Content-Type: application/json" --write-out "\n%{http_code}\n" http://localhost:8088/get-local-clock

getclock7:
	curl --request GET --header "Content-Type: application/json" --write-out "\n%{http_code}\n" http://localhost:8089/get-local-clock

###############################################################################
################################ SHARD MEMBERS ################################
###############################################################################

shardmembers1:
	curl --request GET --header "Content-Type: application/json" --write-out "\n%{http_code}\n" http://localhost:8082/key-value-store-shard/shard-id-members/0

shardmembers2:
	curl --request GET --header "Content-Type: application/json" --write-out "\n%{http_code}\n" http://localhost:8083/key-value-store-shard/shard-id-members/0

shardmembers3:
	curl --request GET --header "Content-Type: application/json" --write-out "\n%{http_code}\n" http://localhost:8084/key-value-store-shard/shard-id-members/0

shardmembers4:
	curl --request GET --header "Content-Type: application/json" --write-out "\n%{http_code}\n" http://localhost:8086/key-value-store-shard/shard-id-members/1

shardmembers5:
	curl --request GET --header "Content-Type: application/json" --write-out "\n%{http_code}\n" http://localhost:8087/key-value-store-shard/shard-id-members/1

shardmembers6:
	curl --request GET --header "Content-Type: application/json" --write-out "\n%{http_code}\n" http://localhost:8088/key-value-store-shard/shard-id-members/1

shardmembers7:
	curl --request GET --header "Content-Type: application/json" --write-out "\n%{http_code}\n" http://localhost:8089/key-value-store-shard/shard-id-members/1

###############################################################################
################################## ADD MEMBER #################################
###############################################################################

addmember7:
	curl --request PUT --header "Content-Type: application/json" --write-out "\n%{http_code}\n" --data '{"socket-address":"10.10.0.8:8085"}' http://localhost:8082/key-value-store-shard/add-member/2

###############################################################################
############################### GET SHARD LIST ################################
###############################################################################

shardlist1:
	curl --request GET --header "Content-Type: application/json" --write-out "\n%{http_code}\n" http://localhost:8082/key-value-store-shard/get-shard-list

shardlist2:
	curl --request GET --header "Content-Type: application/json" --write-out "\n%{http_code}\n" http://localhost:8083/key-value-store-shard/get-shard-list

shardlist3:
	curl --request GET --header "Content-Type: application/json" --write-out "\n%{http_code}\n" http://localhost:8084/key-value-store-shard/get-shard-list

shardlist4:
	curl --request GET --header "Content-Type: application/json" --write-out "\n%{http_code}\n" http://localhost:8086/key-value-store-shard/get-shard-list

shardlist5:
	curl --request GET --header "Content-Type: application/json" --write-out "\n%{http_code}\n" http://localhost:8087/key-value-store-shard/get-shard-list

shardlist6:
	curl --request GET --header "Content-Type: application/json" --write-out "\n%{http_code}\n" http://localhost:8088/key-value-store-shard/get-shard-list

shardlist7:
	curl --request GET --header "Content-Type: application/json" --write-out "\n%{http_code}\n" http://localhost:8089/key-value-store-shard/get-shard-list

###############################################################################
############################### GET SHARD COUNT ###############################
###############################################################################

shardcount1:
	curl --request GET --header "Content-Type: application/json" --write-out "\n%{http_code}\n" http://localhost:8082/key-value-store-shard/get-shard-count

shardcount2:
	curl --request GET --header "Content-Type: application/json" --write-out "\n%{http_code}\n" http://localhost:8083/key-value-store-shard/get-shard-count

shardcount3:
	curl --request GET --header "Content-Type: application/json" --write-out "\n%{http_code}\n" http://localhost:8084/key-value-store-shard/get-shard-count

shardcount4:
	curl --request GET --header "Content-Type: application/json" --write-out "\n%{http_code}\n" http://localhost:8086/key-value-store-shard/get-shard-count

shardcount5:
	curl --request GET --header "Content-Type: application/json" --write-out "\n%{http_code}\n" http://localhost:8087/key-value-store-shard/get-shard-count

shardcount6:
	curl --request GET --header "Content-Type: application/json" --write-out "\n%{http_code}\n" http://localhost:8088/key-value-store-shard/get-shard-count

shardcount7:
	curl --request GET --header "Content-Type: application/json" --write-out "\n%{http_code}\n" http://localhost:8089/key-value-store-shard/get-shard-count

###############################################################################
################################### ADD NODE ##################################
###############################################################################

addnode1:
	curl --request PUT --header "Content-Type: application/json" --write-out "\n%{http_code}\n" --data '{"socket-address":"10.10.0.8:8085", "shardID":1}' http://localhost:8082/key-value-store/add-node

addnode2:
	curl --request PUT --header "Content-Type: application/json" --write-out "\n%{http_code}\n" --data '{"socket-address":"10.10.0.8:8085", "shardID":1}' http://localhost:8083/key-value-store/add-node

addnode3:
	curl --request PUT --header "Content-Type: application/json" --write-out "\n%{http_code}\n" --data '{"socket-address":"10.10.0.8:8085", "shardID":1}' http://localhost:8084/key-value-store/add-node

addnode4:
	curl --request PUT --header "Content-Type: application/json" --write-out "\n%{http_code}\n" --data '{"socket-address":"10.10.0.8:8085", "shardID":1}' http://localhost:8086/key-value-store/add-node

addnode5:
	curl --request PUT --header "Content-Type: application/json" --write-out "\n%{http_code}\n" --data '{"socket-address":"10.10.0.8:8085", "shardID":1}' http://localhost:8087/key-value-store/add-node

addnode6:
	curl --request PUT --header "Content-Type: application/json" --write-out "\n%{http_code}\n" --data '{"socket-address":"10.10.0.8:8085", "shardID":1}' http://localhost:8088/key-value-store/add-node
	
addnode7:
	curl --request PUT --header "Content-Type: application/json" --write-out "\n%{http_code}\n" --data '{"socket-address":"10.10.0.8:8085", "shardID":1}' http://localhost:8089/key-value-store/add-node

###############################################################################
##################################### KVS #####################################
###############################################################################

kvs1:
	curl --request GET --header "Content-Type: application/json" --write-out "\n%{http_code}\n" http://localhost:8082/get-kvs

kvs2:
	curl --request GET --header "Content-Type: application/json" --write-out "\n%{http_code}\n" http://localhost:8083/get-kvs

kvs3:
	curl --request GET --header "Content-Type: application/json" --write-out "\n%{http_code}\n" http://localhost:8084/get-kvs

kvs4:
	curl --request GET --header "Content-Type: application/json" --write-out "\n%{http_code}\n" http://localhost:8086/get-kvs

kvs5:
	curl --request GET --header "Content-Type: application/json" --write-out "\n%{http_code}\n" http://localhost:8087/get-kvs

kvs6:
	curl --request GET --header "Content-Type: application/json" --write-out "\n%{http_code}\n" http://localhost:8088/get-kvs

###############################################################################
################################## RESHARD ####################################
###############################################################################

reshard1:
	curl  --request PUT --header "Content-Type: application/json" --write-out "\n%{http_code}\n" --data '{"shard-count":3}' http://localhost:8082/key-value-store-shard/reshard




