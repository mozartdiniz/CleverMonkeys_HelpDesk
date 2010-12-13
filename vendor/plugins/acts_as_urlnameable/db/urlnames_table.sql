CREATE TABLE `urlnames` (
  `id`            int(11) NOT NULL auto_increment,
  `nameable_type` varchar(255) default NULL,
  `nameable_id`   int(11) default NULL,
  `name`          varchar(255) default NULL,
  PRIMARY KEY     (`id`)
)