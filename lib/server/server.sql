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

--CREATE TABLE Online (
--                        uid INT,
--                        channelSubject TEXT,
--
--                        FOREIGN KEY (uid) REFERENCES Channel(uid),
--                        PRIMARY KEY (uid)
--);
INSERT INTO Account VALUES('simon@gmail.com', '123', '072-123000','Sambach');
INSERT INTO Account VALUES('maxper@gmail.com', '124','072-124000','MaxPers');
INSERT INTO Category VALUES('Sport');
INSERT INTO Category VALUES('Rock');
INSERT INTO Category VALUES('Jazz');
INSERT INTO Category VALUES('Pop');
INSERT INTO Category VALUES('Tjööt');

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
