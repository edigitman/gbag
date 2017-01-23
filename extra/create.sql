CREATE TABLE items (
  id         INT           AUTO_INCREMENT PRIMARY KEY,
  owner      INT,                         -- user id
  name       VARCHAR(50),                 -- name of the item
  qt         NUMBER(10, 2),               -- quantity, initially set
  inBasket   BOOLEAN       DEFAULT FALSE, -- item is in basket, but not yet bought, you are in the store buying things
  price      NUMBER(10, 4) DEFAULT 0,     -- the price of the item (total)
  arch       BOOLEAN       DEFAULT FALSE, -- the item is postponed, to be revised later
  bought     BOOLEAN       DEFAULT FALSE, -- item is bought, you already payed for it
  listId     INT,                         -- bought items are linked to a closed list, this is the id
  createDate TIMESTAMP     DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE users (
  id         INT       AUTO_INCREMENT PRIMARY KEY,
  email      VARCHAR(50),
  password   VARCHAR(60),
  enabled    BOOLEAN,
  role       VARCHAR(10),
  createDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE loginPersisted (
  series    VARCHAR(50),
  username  VARCHAR(50),
  token     VARCHAR(50),
  last_used DATETIME
);

CREATE TABLE closedlist (
  id         INT       AUTO_INCREMENT PRIMARY KEY,
  owner      INT,
  shop       VARCHAR(50),
  price      NUMBER(10, 4),
  createDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);