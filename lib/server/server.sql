

--Init
\set QUIET true
SET client_min_messages TO WARNING; -- Less talk please.
DROP SCHEMA public CASCADE;
CREATE SCHEMA public;
GRANT ALL ON SCHEMA public TO postgres;
\set QUIET false  

--Tables:
CREATE TABLE users (
	email varchar(255) NOT NULL,
	password TEXT NOT NULL,
	phone char(10) NOT NULL CHECK(char_length(phone) = 10),
	uid SERIAL,
	UNIQUE(phone),
	UNIQUE(email),
	PRIMARY KEY(uid)
);

CREATE TABLE categories (
    category TEXT,
    PRIMARY KEY (category)
);

CREATE TABLE favorites (
     users INT,
     category TEXT,

     FOREIGN KEY (users) REFERENCES users(uid),
     FOREIGN KEY (category) REFERENCES categories(category),
     PRIMARY KEY (users,category)
);

CREATE TABLE channels (
    channelName TEXT NOT NULL,
    channelOwner INT,
    categories   TEXT NOT NULL,

    FOREIGN KEY (channelOwner) REFERENCES users(uid),
    FOREIGN KEY (categories) REFERENCES categories(category),

    UNIQUE(channelName),
    PRIMARY KEY channelOwner
);

CREATE TABLE online (
    channelID TEXT,
    channelSubject TEXT,

    FOREIGN KEY (channelID) REFERENCES channels(channelOwner),
    PRIMARY KEY channelID
);

--Inserts:
INSERT INTO users VALUES('simon@gmail.com', '123', '072-123000');
INSERT INTO users VALUES('maxper@gmail.com', '124','072-124000');

--Views:
CREATE VIEW userviews AS
SELECT * FROM users;


SELECT * FROM users;