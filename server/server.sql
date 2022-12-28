--Init
-- SET client_min_messages TO WARNING; -- Less talk please.
DROP SCHEMA public CASCADE;
CREATE SCHEMA public;
GRANT ALL ON SCHEMA public TO postgres;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
--Tables:
CREATE TABLE Account (
                         email varchar(255) NOT NULL,
                         password TEXT NOT NULL,
                         phone char(10) NOT NULL CHECK(char_length(phone) = 10),
                         username TEXT NOT NULL,
                         uid uuid DEFAULT uuid_generate_v4(),
                         profileImageUrl TEXT,
                         UNIQUE(phone),
                         UNIQUE(email),
                         UNIQUE(username),
                         PRIMARY KEY(uid)
);

CREATE TABLE Category (
                          category TEXT,
                          PRIMARY KEY (category)
);

CREATE TABLE Favorite (
                          users uuid,
                          category TEXT,

                          FOREIGN KEY (users) REFERENCES Account(uid),
                          FOREIGN KEY (category) REFERENCES Category(category),
                          PRIMARY KEY (users,category)
);

CREATE TABLE Channel (
                         channelid uuid,
                         channelName TEXT NOT NULL,
                         category   TEXT NOT NULL,
                         isonline BOOLEAN NOT NULL,
                         description TEXT,
                         imageUrl TEXT,
                         FOREIGN KEY (channelid) REFERENCES Account(uid),
                         FOREIGN KEY (category) REFERENCES Category(category),
                         PRIMARY KEY (channelid)
);

CREATE TABLE Viewers
(
    viewer  uuid,
    channel uuid,
    PRIMARY KEY (viewer, channel)
);

CREATE TABLE Timetable
(
    channel UUID REFERENCES Channel,
    startTime TIMESTAMP,
    endTime TIMESTAMP,
    description TEXT,
    PRIMARY KEY(channel, startTime)
);

--CREATE TABLE Online (
--                        uid INT,
--                        channelSubject TEXT,
--
--                        FOREIGN KEY (uid) REFERENCES Channel(uid),
--                        PRIMARY KEY (uid)
--);
INSERT INTO Account VALUES('simon@gmail.com', '12345678', '072-123000','Sambach');
INSERT INTO Account VALUES('maxper@gmail.com', '123456789','072-124000','MaxPers');
INSERT INTO Account VALUES('eddi@gmail.com', '12345678', '072-125000','Medusa');
INSERT INTO Account VALUES('dan@gmail.com', '12345678','072-126000','Fransson');
INSERT INTO Account VALUES('alen@gmail.com', '12345678', '072-127000','Alen');
INSERT INTO Account VALUES('andin@gmail.com', '12345678','072-128000','Andin');
INSERT INTO Account VALUES('tomas@gmail.com', '12345678', '072-129000','Tomas');
INSERT INTO Account VALUES('henning@gmail.com', '12345678','072-120000','Henning');
INSERT INTO Account VALUES('livsstil@gmail.com', '12345678','070-126000','Livsstil');
INSERT INTO Account VALUES('ekonomi@gmail.com', '12345678', '070-127000','Ekonomi');
INSERT INTO Account VALUES('halsa@gmail.com', '12345678','070-128000','Halsa');
INSERT INTO Account VALUES('traning@gmail.com', '12345678', '070-129000','Traning');
INSERT INTO Account VALUES('relationer@gmail.com', '12345678','070-120000','Relationer');

INSERT INTO Category VALUES('Sport');
INSERT INTO Category VALUES('Rock');
INSERT INTO Category VALUES('Jazz');
INSERT INTO Category VALUES('Pop');
INSERT INTO Category VALUES('Tjööt');
INSERT INTO Category VALUES('Livsstil');
INSERT INTO Category VALUES('Ekonomi');
INSERT INTO Category VALUES('Hälsa');
INSERT INTO Category VALUES('Träning');
INSERT INTO Category VALUES('Relationer');


--Mockup channels only fore test purpose, they don't stream any content!
INSERT INTO Channel VALUES((SELECT uid FROM Account WHERE username='Sambach'),'DiscoDunk!','Tjööt','t');
INSERT INTO Channel VALUES((SELECT uid FROM Account WHERE username='MaxPers'),'Prat','Tjööt','t');
INSERT INTO Channel VALUES((SELECT uid FROM Account WHERE username='Medusa'),'DiscoTjo!','Tjööt','t');
INSERT INTO Channel VALUES((SELECT uid FROM Account WHERE username='Fransson'),'DiscoHej!','Tjööt','t');
INSERT INTO Channel VALUES((SELECT uid FROM Account WHERE username='Alen'),'KodSnack','Sport','t');
INSERT INTO Channel VALUES((SELECT uid FROM Account WHERE username='Andin'),'RockPodden','Rock','t');
INSERT INTO Channel VALUES((SELECT uid FROM Account WHERE username='Tomas'),'DansPodden','Jazz','t');
INSERT INTO Channel VALUES((SELECT uid FROM Account WHERE username='Henning'),'FlyttPodden','Pop','t');

INSERT INTO Channel VALUES((SELECT uid FROM Account WHERE username='Livsstil'),'Allt om yoga','Livsstil','t');
INSERT INTO Channel VALUES((SELECT uid FROM Account WHERE username='Ekonomi'),'Börssnack','Ekonomi','t');
INSERT INTO Channel VALUES((SELECT uid FROM Account WHERE username='Halsa'),'Kostpodden','Hälsa','t');
INSERT INTO Channel VALUES((SELECT uid FROM Account WHERE username='Traning'),'Allt om träning','Träning','t');
INSERT INTO Channel VALUES((SELECT uid FROM Account WHERE username='Relationer'),'Relationspodden','Relationer','t');

-- INSERT INTO channelview VALUES('1','Rocka på','Rock',false);
-- SELECT * FROM Channel;
--
--INSERT INTO channelview VALUES('1','popa på','Pop',true);
-- SELECT * FROM Channel;

--INSERT INTO channelview VALUES('1','Rockaren','Rock',true);
--SELECT * FROM Channel;

--UPDATE Channel SET isonline = false WHERE channelid = '1';
