CREATE TABLE IF NOT EXISTS `loadout` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`identifier` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_bin',
	`charidentifier` INT(11) NULL DEFAULT NULL,
	`name` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`ammo` VARCHAR(255) NOT NULL DEFAULT '{}' COLLATE 'utf8mb4_general_ci',
	`components` VARCHAR(255) NOT NULL DEFAULT '{}' COLLATE 'utf8mb4_general_ci',
	`dirtlevel` DOUBLE NULL DEFAULT '0',
	`mudlevel` DOUBLE NULL DEFAULT '0',
	`conditionlevel` DOUBLE NULL DEFAULT '0',
	`rustlevel` DOUBLE NULL DEFAULT '0',
	`used` TINYINT(4) NULL DEFAULT '0',
	`used2` TINYINT(4) NULL DEFAULT '0',
	`dropped` INT(11) NOT NULL DEFAULT '0',
	`comps` LONGTEXT NOT NULL DEFAULT '{}' COLLATE 'utf8mb4_general_ci',
	`label` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`curr_inv` VARCHAR(100) NOT NULL DEFAULT 'default' COLLATE 'utf8mb4_general_ci',
	PRIMARY KEY (`id`) USING BTREE,
	INDEX `id` (`id`) USING BTREE
)
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB
;

CREATE TABLE IF NOT EXISTS `items` (
	`item` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_general_ci',
	`label` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_general_ci',
	`limit` INT(11) NOT NULL DEFAULT '1',
	`can_remove` TINYINT(1) NOT NULL DEFAULT '1',
	`type` VARCHAR(50) NULL DEFAULT 'item_standard' COLLATE 'utf8mb4_general_ci',
	`usable` TINYINT(1) NULL DEFAULT NULL,
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`metadata` LONGTEXT NULL DEFAULT '{}' COLLATE 'utf8mb4_bin',
	`desc` VARCHAR(5550) NOT NULL DEFAULT 'nice item' COLLATE 'utf8mb4_general_ci',
	PRIMARY KEY (`item`) USING BTREE,
	UNIQUE INDEX `id` (`id`) USING BTREE,
	CONSTRAINT `metadata` CHECK (json_valid(`metadata`))
)
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB
ROW_FORMAT=DYNAMIC
AUTO_INCREMENT=897
;
