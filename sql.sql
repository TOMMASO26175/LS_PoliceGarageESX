CREATE TABLE police_car(
    carname VARCHAR(40) not NULL,    
    society TEXT not NULL,
    stored TINYINT(1) DEFAULT '0',
    plate VARCHAR(12) NOT NULL,
    mods LONGTEXT,

    PRIMARY KEY (plate)
)