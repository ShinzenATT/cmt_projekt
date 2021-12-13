--Init
SET client_min_messages TO WARNING; -- Less talk please.
DROP SCHEMA public CASCADE;
CREATE SCHEMA public;
GRANT ALL ON SCHEMA public TO postgres;

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
                         uid INT,
                         channelName TEXT NOT NULL,
                         category   TEXT NOT NULL,

                         FOREIGN KEY (uid) REFERENCES Account(uid),
                         FOREIGN KEY (category) REFERENCES Category(category),

                         UNIQUE(channelName),
                         PRIMARY KEY (uid)
);

CREATE TABLE Online (
                        uid INT,
                        channelSubject TEXT,

                        FOREIGN KEY (uid) REFERENCES Channel(uid),
                        PRIMARY KEY (uid)
);
INSERT INTO Account VALUES('simon@gmail.com', '123', '072-123000');
INSERT INTO Account VALUES('maxper@gmail.com', '124','072-124000');
INSERT INTO Category VALUES('Sport');
INSERT INTO Category VALUES('Rock');
INSERT INTO Category VALUES('Jazz');
INSERT INTO Category VALUES('Pop');
INSERT INTO Category VALUES('Tjööt');

SELECT * FROM Account;

CREATE FUNCTION channel_update()
    RETURNS trigger AS $$
BEGIN
	IF NOT EXISTS (SELECT * FROM Channel WHERE uid = NEW.uid) THEN
	INSERT INTO Channel (uid,channelname,category) VALUES (NEW.uid,NEW.channelname,NEW.category);
END IF;
INSERT INTO Online (uid) VALUES (NEW.uid);
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