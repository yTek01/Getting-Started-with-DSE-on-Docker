# Getting Started with DSE On Docker



*There are multiple ways to get DSE on Docker.  You can pull DSE from *[Docker Store](https://store.docker.com/images/datastax)*, use docker compose or even roll your own from our public *[Github Repo](https://github.com/datastax/docker-images).**

*Let's not waste any time and get you started on your mastery by creating some DSE, OpsCenter and Studio Containers.*

***I assumes you to have***

* *A basic understanding of Docker images and containers.*

* *Docker installed on your local system, if you haven't please see to install it [Docker Installation Instructions](https://docs.docker.com/engine/installation/).*

* *When *[building](https://github.com/datastax/docker-images#building)* custom images from the DataStax github repository, a *[DataStax Academy account](https://academy.datastax.com/).**

### **_Pull DataStax Distribution of Apache Cassandra_**
```
docker pull datastax/ddac:5.1.17
```
### **_Pull the DSE Server image from Docker hub_**
```
docker pull datastax/dse-server:6.8.16
```
### **_Pull the DSE OpsCenter image from Docker hub_**
```
docker pull datastax/dse-opscenter:6.8.15
```
### **_Pull the DataStax studio from Docker hub_**
```
docker pull datastax/dse-studio:6.8.15
```

### **_Create a DSE DDAC (DataStax Distribution of Apache Cassandra) container_**  
```
docker run -e DS_LICENSE=accept --name my-ddac -d datastax/ddac
```
### **_Create a DSE server container with Analytics (Spark), Search, Graph enabled_**

```
docker run -e DS_LICENSE=accept -p 7080:7080 -p 7081:7081 --name datastax_server -d datastax/dse-server -k -s -g
```

### **_Create a DSE OpsCenter container_**

```
docker run -e DS_LICENSE=accept -p 8888:8888 --name my-opscenter -d datastax/dse-opscenter
```

### **_Create a DataStax studio container and link the container with the DSE server_**

```
docker run -e DS_LICENSE=accept --name my-studio -p 9091:9091 -d datastax/dse-studio --link <datastax_server_container_name>
```



# **_Now you have a container running with advanced features, it’s time to use your container._**

# **_Using interactive commands_**

*If the container is running in the background (using the **-d**), use the following command to run DSE commands interactively.*

*`docker exec -it <container_name> <command_name>`*

*For example *

*`nodetool status` command:*

```
docker exec -it <container name> /bin/bash nodetool status
```

*To load data we can use a cqlsh prompt:*

```
docker exec -it my-dse cqlsh
```

*If you want to get a bash prompt where you can do anything just like having a ssh connection to an oldschool node*

*`docker exec -it <container_name> bash`*

*To exit the shell without stopping the container use* **ctl P ctl Q** 

```
docker exec -it my-dse cqlsh
```

### CQL - Create a Keyspace

```
CREATE KEYSPACE IF NOT EXISTS voting_system WITH REPLICATION = {'class':'SimpleStrategy', 'replication_factor':'1'};
```
### CQL - See all the Keyspaces in the database

```
DESCRIBE KEYSPACES;
```

### CQL - Create a table
```
CREATE TABLE IF NOT EXISTS voting_system.voters (
	voterid UUID,
	voterstime TIMESTAMP,
	name TEXT,
	city TEXT,
	state TEXT,
	supporting TEXT,
	PRIMARY KEY((voterid), name));
```
### CQL - Insert data into the table
```
INSERT INTO voting_system.voters (voterid, voterstime, name, city , state, supporting) VALUES 
	(uuid() , toTimeStamp(now()), 'Jackson', 'Los Angeles', 'California', 'A');
INSERT INTO voting_system.voters (voterid, voterstime, name, city , state, supporting) VALUES 
	(uuid() , toTimeStamp(now()), 'Bond', 'Phoenix', 'Arizona', 'B');
INSERT INTO voting_system.voters (voterid, voterstime, name, city , state, supporting) VALUES 
	(uuid() , toTimeStamp(now()), 'Edward','Miami','Florida','B');
INSERT INTO voting_system.voters (voterid, voterstime, name, city , state, supporting) VALUES 
	(uuid() , toTimeStamp(now()), 'Holland','Albany','New York','A');
INSERT INTO voting_system.voters (voterid, voterstime, name, city , state, supporting) VALUES 
	(uuid() , toTimeStamp(now()), 'Peter','Houston','Texas','A');
```
### CQL - Query table with partition and clustering column
```
SELECT * FROM voting_system.voters
WHERE voterid = <INSERT on of the voterid>;
```
### CQL - Create Search on table
```
CREATE SEARCH INDEX ON keyspace.table;
```
### CQL - Create Search on table

```
CREATE SEARCH INDEX ON voting_system.voters;
```
### CQL - Create Search on table
```
CREATE SEARCH INDEX ON voting_system.voters WITH COLUMNS column1, column2, column3, ...;
```

## Working with DSE Analytics (Spark)
Open another command line:
```
docker exec -it <container name> /bin/bash
```
### Initialise Spark shell
```
dse spark
```
### Query the Cassandra table and load data into Spark
```
val table = spark.read.format("org.apache.spark.sql.cassandra")
	.options(Map("keyspace"->"voting_system", "table" -> "voters"))
	.load() 
```

### Perform Analytics on table
```
val voters_table = table.select("voterid", "city", "state","supporting")
	.where("solr_query='supporting:A'")
	.show()
```

## Working with DSE Graph
Open another command line:
```
docker exec -it <container name> /bin/bash
```
### Initialise Spark shell
```
dse gremlin-console
```

### Check if a graph called voting_system exists in the system.
```
system.graph("voting_system").exists()
```

### Create a new graph using the below command.
```
system.graph("graph_testing").create()
```

### Get a list of graphs available in the system. 
```
system.graphs()
```

# *Now that you have mastered DSE let’s **_Create an OpsCenter container_***

*Here we will learn how to create an Opscenter container and a connected DataStax Enterprise server container on the same Docker host.*

*To create and connect the containers:*

*First create an OpsCenter container.*

```
docker run -e DS_LICENSE=accept -d -p 8888:8888 --name my-opscenter
```

*See [OpsCenter Docker run options](https://github.com/datastax/docker-images#OpsCenter-Docker-run-options) for additional options that persist data or manage configuration.*

*To Create a [DataStax Enterprise (DSE) server](https://store.docker.com/images/datastax) container that is linked to the OpsCenter container.*

```
docker run -e DS_LICENSE=accept --link my-opscenter:opscenter --name my-dse -d datastax/dse-server:6.8.15
```

*Get the DSE container IP address:*

*`docker exec -it my-dse nodetool status`*

1. *Open a browser and go to **http://DOCKER_HOST_IP:8888**.*

2. *Click **Manage existing cluster**.*

3. *In **host name**, enter the DSE IP address.*

4. *Click **Install agents manually**. Note that the agent is already installed on the DSE image; no installation is required.*

*OpsCenter is ready to use with DSE. See the [OpsCenter User Guide](http://docs.datastax.com/en/opscenter/6.1/) for detailed usage and configuration instructions.*

**_ Now dive deeper and create a Studio container_**

```
docker run -e DS_LICENSE=accept --link my-dse --name my-studio -p 9091:9091 -d datastax/dse-studio
```

1. *Open your browser and point to **http://DOCKER_HOST_IP:9091**, create the new connection using my-dse as the hostname.*

*Check *[Studio documentation](http://docs.datastax.com/en/dse/5.1/dse-dev/datastax_enterprise/studio/stdToc.html)* for further instructions.*

# **_If that was just a little too much fun for you or you don’t need any customization, you can use Docker Compose for automated provisioning_**

*Bootstrapping a multi-node cluster with OpsCenter and Studio can be automated with **[Docker Compose](https://docs.docker.com/compose/)**. To get sample **compose.yml** files visit the following links.*

* *[DSE](https://github.com/datastax/docker-images/blob/master/docker-compose.yml)*

* *[OpsCenter](https://github.com/datastax/docker-images/blob/master/docker-compose.opscenter.yml)*

* *[Studio](https://github.com/datastax/docker-images/blob/master/docker-compose.studio.yml)*