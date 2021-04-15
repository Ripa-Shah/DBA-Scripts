CREATE TABLE current_timestamp_demos
(
    id         INT IDENTITY, 
    msg        VARCHAR(255) NOT NULL, 
    created_at DATETIME NOT NULL
                DEFAULT CURRENT_TIMESTAMP, 
    PRIMARY KEY(id)
);

INSERT INTO current_timestamp_demos(msg)
VALUES('This is the first message.');

INSERT INTO current_timestamp_demos(msg)
VALUES('current_timestamp demo');

SELECT 
    id, 
    msg, 
    created_at
FROM 
    current_timestamp_demos;