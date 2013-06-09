CREATE TABLE USER_SETTINGS (
	ckey VARCHAR(255) NOT NULL,
	description VARCHAR(2000),
	interests VARCHAR(2000),
	age TINYINT,
	location VARCHAR(255),
	gender ENUM('Male', 'Female', 'Neuter', 'Plural'),
	namecolour VARCHAR(6),
	textcolour VARCHAR(6),
	backgroundcolour VARCHAR(6),
	fadecolours VARCHAR(255),
	showcolours TINYINT,
	showsmilies TINYINT,
	showimages TINYINT,
	onjoin VARCHAR(255),
	onleave VARCHAR(255),
	cimsounds TINYINT,
	volume ENUM('Low', 'Medium', 'High'),
	showtitle TINYINT,
	showwelcome TINYINT,
	showmotd TINYINT,
	clearonreboot TINYINT,
	lines SMALLINT,
	highlightcode TINYINT,
	windowwidth SMALLINT,
	windowheight SMALLINT,
	timeformat ENUM('12', '24'),
	timeoffset TINYINT,
	inactivitytimer SMALLINT,
	autoafkmessage VARCHAR(255),
	password VARCHAR(64),
	CONSTRAINT PRIMARY KEY USING HASH (ckey)
);

CREATE TABLE USER_AUTH (
	ckey VARCHAR(255) NOT NULL,
	login VARCHAR(255) NOT NULL,
	type ENUM('DreamSeeker', 'Web', 'Android'),
	CONSTRAINT UNIQUE (login),
	INDEX (login, type),
	CONSTRAINT PRIMARY KEY USING HASH (ckey),
	CONSTRAINT FOREIGN KEY (ckey) REFERENCES USER_SETTINGS (ckey) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE USER_IP_ADDRESS (
	ckey VARCHAR(255) NOT NULL,
	ipaddress VARCHAR(40) NOT NULL,
	INDEX (ckey),
	INDEX (ipaddress),
	CONSTRAINT PRIMARY KEY USING HASH (ckey, ipaddress),
	CONSTRAINT FOREIGN KEY (ckey) REFERENCES USER_SETTINGS (ckey) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE USER_COMPUTER_ID (
	ckey VARCHAR(255) NOT NULL,
	computerid VARCHAR(40) NOT NULL,
	INDEX (ckey),
	INDEX (computerid),
	CONSTRAINT PRIMARY KEY USING HASH (ckey, computerid),
	CONSTRAINT FOREIGN KEY (ckey) REFERENCES USER_SETTINGS (ckey) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE SCHEMA_VERSION (
	major TINYINT,
	minor TINYINT,
	patch TINYINT
);

INSERT INTO SCHEMA_VERSION VALUES (1, 0, 0);