--Init
\set QUIET true
SET client_min_messages TO WARNING; -- Less talk please.
DROP SCHEMA public CASCADE;
CREATE SCHEMA public;
GRANT ALL ON SCHEMA public TO postgres;
\set QUIET false  

--Tables:
CREATE TABLE User (
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

     FOREIGN KEY (users) REFERENCES User(uid),
     FOREIGN KEY (category) REFERENCES Category(category),
     PRIMARY KEY (users,category)
);

CREATE TABLE Channel (
    channelName TEXT NOT NULL,
    channelOwner INT,
    categories   TEXT NOT NULL,

    FOREIGN KEY (channelOwner) REFERENCES User(uid),
    FOREIGN KEY (categories) REFERENCES Category(category),

    UNIQUE(channelName),
    PRIMARY KEY channelOwner
);

CREATE TABLE Online (
    channelID TEXT,
    channelSubject TEXT,

    FOREIGN KEY (channelID) REFERENCES Channel(channelOwner),
    PRIMARY KEY channelID
);

--Inserts:
INSERT INTO User VALUES('simon@gmail.com', '123', '072-123000');
INSERT INTO User VALUES('maxper@gmail.com', '124','072-124000');

--Views:
CREATE VIEW userviews AS
SELECT * FROM User;


SELECT * FROM User;
