CREATE KEYSPACE IF NOT EXISTS voting_system WITH REPLICATION = {'class':'SimpleStrategy', 'replication_factor':'1'};

DESCRIBE KEYSPACES;


CREATE TABLE IF NOT EXISTS voting_system.voters (
	voterid UUID,
	voterstime TIMESTAMP,
	name TEXT,
	city TEXT,
	state TEXT,
	supporting TEXT,
	PRIMARY KEY((voterid), name));



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


select * from voting_system.voters;

CREATE SEARCH INDEX ON voting_system.voters;

CREATE SEARCH INDEX ON voting_system.voters WITH COLUMNS column1, column2, column3, ...;
-- DROP KEYSPACES;