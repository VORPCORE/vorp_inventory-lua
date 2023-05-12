CREATE TABLE IF NOT EXISTS `items_crafted` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`character_id` INT(11) NOT NULL,
	`item_id` INT(11) NOT NULL,
	`updated_at` TIMESTAMP NOT NULL DEFAULT current_timestamp(),
	`metadata` LONGTEXT NOT NULL COLLATE 'utf8mb4_bin',
	PRIMARY KEY (`id`) USING BTREE,
	UNIQUE INDEX `ID` (`id`) USING BTREE,
	INDEX `crafted_item_idx` (`character_id`) USING BTREE,
	CONSTRAINT `metadata` CHECK (json_valid(`metadata`))
)
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB
;

CREATE TABLE IF NOT EXISTS `character_inventories` (
	`character_id` INT(11) NULL DEFAULT NULL,
	`inventory_type` VARCHAR(100) NOT NULL DEFAULT 'default' COLLATE 'utf8mb4_general_ci',
	`item_crafted_id` INT(11) NOT NULL,
	`amount` INT(11) NULL DEFAULT NULL,
	`created_at` TIMESTAMP NULL DEFAULT current_timestamp(),
	INDEX `character_inventory_idx` (`character_id`, `inventory_type`) USING BTREE
)
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB
;

-- If you want to convert the old inventory format to the new one, run this part of the file.
-- It will keep the old inventory in the characters table, but all data will be copied and parsed into the new tables.

-- Convert Json items into separate rows and insert them in items_crafted
INSERT INTO items_crafted (
      character_id,
      item_id,
      metadata)
WITH
  i AS (SELECT id, item FROM items),
  c AS (SELECT charidentifier, inventory FROM characters )
SELECT c.charidentifier, i.id, '{}' as metadata FROM i JOIN c
    WHERE JSON_CONTAINS(JSON_KEYS(c.inventory), JSON_QUOTE(i.item), '$');

-- Assign amount to newly created items and Assign character and inventory type
INSERT INTO character_inventories (
                                   character_id,
                                   inventory_type,
                                   item_crafted_id,
                                   amount
                                   )
WITH
  i AS (SELECT id, item FROM items),
  c AS (SELECT charidentifier, inventory FROM characters),
  ic AS (SELECT id, character_id, item_id FROM items_crafted)
SELECT c.charidentifier, 'default', ic.id, JSON_EXTRACT(c.inventory, CONCAT('$.', i.item)) as amount FROM i JOIN c JOIN ic
    WHERE JSON_CONTAINS(JSON_KEYS(c.inventory), JSON_QUOTE(i.item), '$')
      AND ic.item_id = i.id AND ic.character_id = c.charidentifier
GROUP BY c.charidentifier, ic.id, c.inventory;