--Init
SET client_min_messages TO WARNING; -- Less talk please.
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
                         FOREIGN KEY (channelid) REFERENCES Account(uid),
                         FOREIGN KEY (category) REFERENCES Category(category),

    -- UNIQUE(channelName),
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
INSERT INTO Account VALUES('simon@gmail.com', '123', '072-123000','Sambach');
INSERT INTO Account VALUES('maxper@gmail.com', '124','072-124000','MaxPers');
INSERT INTO Account VALUES('eddi@gmail.com', '123', '072-125000','Medusa');
INSERT INTO Account VALUES('dan@gmail.com', '124','072-126000','Fransson');
INSERT INTO Account VALUES('alen@gmail.com', '123', '072-127000','Alen');
INSERT INTO Account VALUES('andin@gmail.com', '124','072-128000','Andin');
INSERT INTO Account VALUES('tomas@gmail.com', '123', '072-129000','Tomas');
INSERT INTO Account VALUES('henning@gmail.com', '124','072-120000','Henning');
INSERT INTO Category VALUES('Sport');
INSERT INTO Category VALUES('Rock');
INSERT INTO Category VALUES('Jazz');
INSERT INTO Category VALUES('Pop');
INSERT INTO Category VALUES('Tjööt');
--INSERT INTO Category VALUES('Disco'); Add image url in model first.

--Mockup channels only fore test purpose, they don't stream any content!
INSERT INTO Channel VALUES((SELECT uid FROM Account WHERE username='Sambach'),'DiscoDunk!','Tjööt','t');
INSERT INTO Channel VALUES((SELECT uid FROM Account WHERE username='MaxPers'),'Prat','Tjööt','t');
INSERT INTO Channel VALUES((SELECT uid FROM Account WHERE username='Medusa'),'DiscoTjo!','Tjööt','t');
INSERT INTO Channel VALUES((SELECT uid FROM Account WHERE username='Fransson'),'DiscoHej!','Tjööt','t');
INSERT INTO Channel VALUES((SELECT uid FROM Account WHERE username='Alen'),'KodSnack','Sport','t');
INSERT INTO Channel VALUES((SELECT uid FROM Account WHERE username='Andin'),'RockPodden','Rock','t');
INSERT INTO Channel VALUES((SELECT uid FROM Account WHERE username='Tomas'),'DansPodden','Jazz','t');
INSERT INTO Channel VALUES((SELECT uid FROM Account WHERE username='Henning'),'FlyttPodden','Pop','t');
--SELECT * FROM Account;

CREATE FUNCTION channel_update()
    RETURNS trigger AS $$
BEGIN
    IF NOT EXISTS (SELECT * FROM Channel WHERE channelid = NEW.channelid) THEN
        INSERT INTO Channel (channelid,channelname,category,isonline) VALUES (NEW.channelid,NEW.channelname,NEW.category,TRUE);
    ELSE
        UPDATE Channel SET isonline = true, channelname = NEW.channelname, category = NEW.category WHERE channelid = NEW.channelid;
    END IF;
    RETURN OLD;
END;
$$
    LANGUAGE 'plpgsql';

CREATE VIEW channelview AS
SELECT * FROM Channel;

CREATE TRIGGER channelTrigger
    INSTEAD OF INSERT ON channelview
    FOR EACH ROW
EXECUTE PROCEDURE channel_update();

-- INSERT INTO channelview VALUES('1','Rocka på','Rock',false);
-- SELECT * FROM Channel;
--
--INSERT INTO channelview VALUES('1','popa på','Pop',true);
-- SELECT * FROM Channel;

--INSERT INTO channelview VALUES('1','Rockaren','Rock',true);
--SELECT * FROM Channel;

--UPDATE Channel SET isonline = false WHERE channelid = '1';
