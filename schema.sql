BEGIN TRANSACTION;
CREATE TABLE IF NOT EXISTS `account` (
  `name` TEXT UNIQUE
);
CREATE TABLE IF NOT EXISTS `unit` (
  `name`   TEXT PRIMARY KEY,
  `symbol` TEXT NOT NULL UNIQUE
);
CREATE TABLE IF NOT EXISTS `transfer` (
  `from_id`        INTEGER,
  `to_id`          INTEGER,
  `valuable_id`    INTEGER NOT NULL,
  `amount`         INTEGER NOT NULL,
  `transaction_id` INTEGER NOT NULL
);
CREATE TABLE IF NOT EXISTS `transaction` (
  `comment`  TEXT,
  `datetime` TEXT
);
CREATE TABLE IF NOT EXISTS `valuable` (
  `name`       TEXT    NOT NULL UNIQUE,
  `unit_name`  INTEGER NOT NULL,
  `price`      INTEGER NOT NULL,
  `image_path` TEXT,
  `product`    INTEGER NOT NULL DEFAULT 1
);
CREATE TABLE IF NOT EXISTS `user` (
  `name`               TEXT    NOT NULL UNIQUE,
  `account_id`         INTEGER NOT NULL UNIQUE,
  `mail`               TEXT,
  `image_path`         TEXT,
  `browsable`          INTEGER NOT NULL DEFAULT 1,
  `direct_payment`     INTEGER NOT NULL DEFAULT 0,
  `allow_edit_profile` INTEGER NOT NULL DEFAULT 1,
  `active`             INTEGER NOT NULL DEFAULT 1
);

CREATE VIEW IF NOT EXISTS `account_valuable_balance` AS
  SELECT
    account.name       AS account_name,
    account.rowid      AS account_id,
    valuable.name      AS valuable_name,
    valuable.rowid     AS valuable_id,
    ifnull((SELECT
    sum(ifnull(amount, 0))
            FROM transfer
            WHERE to_id = account.rowid AND valuable_id = valuable.rowid), 0) -
    ifnull((SELECT
    sum(ifnull(amount, 0))
            FROM transfer
            WHERE from_id = account.rowid AND valuable_id = valuable.rowid),
           0)          AS balance,
    valuable.unit_name AS unit_name
  FROM account, valuable;

INSERT INTO `account` (`rowid`, `name`) VALUES (1, 'Getränkekasse');
INSERT INTO `account` (`rowid`, `name`) VALUES (4, 'Lager/Kühlschrank');
INSERT INTO `account` (`rowid`, `name`) VALUES (5, 'Gäste');
INSERT INTO `account` (`rowid`, `name`) VALUES (6, 'BTC');
INSERT INTO `account` (`rowid`, `name`) VALUES (7, 'Doge');

INSERT INTO `user` (`name`, `account_id`, `browsable`, `direct_payment`,
                    `allow_edit_profile`, image_path)
VALUES ("Gäste", 5, 0, 1, 0, "");
INSERT INTO `user` (`name`, `account_id`, `browsable`, `direct_payment`,
                    `allow_edit_profile`, image_path)
VALUES("BTC", 6, 1, 0, 0, "users/btc_logo.png");
INSERT INTO `user` (`name`, `account_id`, `browsable`, `direct_payment`,
                    `allow_edit_profile`, image_path)
VALUES("Doge", 7, 1, 0, 0, "users/doge_logo.png");

INSERT INTO `unit` (`name`, `symbol`) VALUES ('Cent', 'ct');
INSERT INTO `unit` (`name`, `symbol`) VALUES ('Flasche', 'Fl.');
INSERT INTO `unit` (`name`, `symbol`) VALUES ('Stück', 'St.');

INSERT INTO `valuable` (`name`, `unit_name`, `price`, `image_path`, `product`)
VALUES ('Euro', 'Cent', 1, NULL, 0);
INSERT INTO `valuable` (`name`, `unit_name`, `price`, `image_path`)
VALUES ('$GETRÄNK', 'Flasche', 100, 'products/placeholder.png');

COMMIT;

