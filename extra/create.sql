CREATE TABLE items (
  id       INT AUTO_INCREMENT PRIMARY KEY,
  owner    VARCHAR(50),
  name     VARCHAR(50),
  qt       NUMBER(10, 2),
  inBasket BOOLEAN,
  price    NUMBER(10, 4),
  arch     BOOLEAN,
  listId   INT
);

CREATE TABLE users (
  id       INT AUTO_INCREMENT PRIMARY KEY,
  email    VARCHAR(50),
  password VARCHAR(60),
  enabled  BOOLEAN,
  role     VARCHAR(10)
);

CREATE TABLE loginPersisted (
  series    VARCHAR(50),
  username  VARCHAR(50),
  token     VARCHAR(50),
  last_used DATETIME
);

CREATE TABLE shippingList (
  id        INT AUTO_INCREMENT PRIMARY KEY,
  userId    INT,
  name      VARCHAR(50),
  shop      VARCHAR(50),
  closeDate DATETIME,
  total     NUMBER(10, 4)
);
