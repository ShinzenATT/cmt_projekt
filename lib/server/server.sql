--Init
\set QUIET true
SET client_min_messages TO WARNING; -- Less talk please.
DROP SCHEMA public CASCADE;
CREATE SCHEMA public;
GRANT ALL ON SCHEMA public TO postgres;
\set QUIET false  

--Tables:
CREATE TABLE Account (
	email varchar(255) NOT NULL,
	password TEXT NOT NULL,
	phone char(10) NOT NULL CHECK(char_length(phone) = 10),
	uid SERIAL,
	UNIQUE(phone),
	UNIQUE(email),
	PRIMARY KEY(uid)
);

CREATE TABLE Category (
    category TEXT,
    PRIMARY KEY (category)
);

CREATE TABLE Favorite (
     users INT,
     category TEXT,

     FOREIGN KEY (users) REFERENCES Account(uid),
     FOREIGN KEY (category) REFERENCES Category(category),
     PRIMARY KEY (users,category)
);

CREATE TABLE Channel (
    channelName TEXT NOT NULL,
    channelOwner INT,
    categories   TEXT NOT NULL,

    FOREIGN KEY (channelOwner) REFERENCES Account(uid),
    FOREIGN KEY (categories) REFERENCES Category(category),

    UNIQUE(channelName),
    PRIMARY KEY (channelOwner)
);

CREATE TABLE Online (
    channelID INT,
    channelSubject TEXT,

    FOREIGN KEY (channelID) REFERENCES Channel(channelOwner),
    PRIMARY KEY (channelID)
);

--Inserts:
INSERT INTO Account VALUES('simon@gmail.com', '123', '072-123000');
INSERT INTO Account VALUES('maxper@gmail.com', '124','072-124000');
INSERT INTO Category VALUES('Sport');
INSERT INTO Category VALUES('Rock');
INSERT INTO Category VALUES('Jazz');
INSERT INTO Category VALUES('Pop');
INSERT INTO Category VALUES('Tjööt');
INSERT INTO Channel VALUES('Prata strunt','1','Tjööt');
INSERT INTO Online VALUES('1');
DELETE FROM Online WHERE channelid = '1';
--Views:
CREATE VIEW userviews AS
SELECT * FROM Account;

SELECT * FROM userviews;
