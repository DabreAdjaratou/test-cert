--ilahir 13-APR-2016
ALTER TABLE  `spi_form_v_3` ADD  `status` VARCHAR( 100 ) NULL DEFAULT  'pending';


--ilahir 23-Apr-2016

CREATE TABLE IF NOT EXISTS `spi_rt_3_facilities` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `facility_id` varchar(255) DEFAULT NULL,
  `facility_name` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `contact_person` varchar(255) DEFAULT NULL,
  `district` varchar(255) DEFAULT NULL,
  `province` varchar(255) DEFAULT NULL,
  `latitude` varchar(255) DEFAULT NULL,
  `longitude` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1;

--ilahir 26-Apr-2016


CREATE TABLE IF NOT EXISTS `categories` (
  `category_id` int(11) NOT NULL AUTO_INCREMENT,
  `category_name` varchar(255) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`category_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`category_id`, `category_name`, `status`) VALUES
(1, 'SPI Form', 'active');


CREATE TABLE IF NOT EXISTS `roles` (
  `role_id` int(11) NOT NULL AUTO_INCREMENT,
  `category_id` int(11) NOT NULL,
  `role_code` varchar(255) DEFAULT NULL,
  `role_name` varchar(255) DEFAULT NULL,
  `description` mediumtext,
  `status` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`role_id`),
  KEY `category_id` (`category_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1;


ALTER TABLE  `users` ADD  `first_name` VARCHAR( 255 ) NULL DEFAULT NULL AFTER  `id` ;
ALTER TABLE  `users` ADD  `last_name` VARCHAR( 255 ) NULL DEFAULT NULL AFTER  `first_name` ;
ALTER TABLE  `users` ADD  `status` VARCHAR( 255 ) NULL DEFAULT NULL ;
ALTER TABLE  `users` ADD  `created_on` DATETIME NULL DEFAULT NULL ;
ALTER TABLE  `users` ADD  `email` VARCHAR( 255 ) NULL DEFAULT NULL AFTER  `password` ;


CREATE TABLE IF NOT EXISTS `user_role_map` (
  `map_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `role_id` int(11) NOT NULL,
  PRIMARY KEY (`map_id`),
  KEY `role_id` (`role_id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1;

--
-- Constraints for table `user_role_map`
--
ALTER TABLE `user_role_map`
  ADD CONSTRAINT `user_role_map_ibfk_3` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `user_role_map_ibfk_2` FOREIGN KEY (`role_id`) REFERENCES `roles` (`role_id`);

--saravanna 03-may-2016
CREATE TABLE IF NOT EXISTS  `global_config` (
 `config_id` INT( 11 ) NOT NULL AUTO_INCREMENT ,
 `display_name` VARCHAR( 255 ) NOT NULL ,
 `global_name` VARCHAR( 255 ) DEFAULT NULL ,
 `global_value` VARCHAR( 255 ) DEFAULT NULL ,
PRIMARY KEY (  `config_id` )
) ENGINE = MYISAM DEFAULT CHARSET = latin1 AUTO_INCREMENT =1;

INSERT INTO `global_config` (`config_id`, `display_name`, `global_name`, `global_value`) VALUES (NULL, 'Auto Approve Status', 'approve_status', 'yes');



--ilahir 04-May-2016
CREATE TABLE IF NOT EXISTS `event_log` (
  `event_id` int(11) NOT NULL AUTO_INCREMENT,
  `actor` int(11) NOT NULL,
  `subject` varchar(255) DEFAULT NULL,
  `event_type` varchar(255) DEFAULT NULL,
  `action` varchar(255) DEFAULT NULL,
  `resource_name` varchar(255) DEFAULT NULL,
  `date_time` datetime DEFAULT NULL,
  PRIMARY KEY (`event_id`),
  KEY `actor` (`actor`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1;

ALTER TABLE `event_log`
  ADD CONSTRAINT `event_log_ibfk_1` FOREIGN KEY (`actor`) REFERENCES `users` (`id`);
  
--ilahir 10-MAY-2016

CREATE TABLE IF NOT EXISTS `resources` (
  `resource_id` varchar(255) NOT NULL,
  `display_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`resource_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE IF NOT EXISTS `privileges` (
  `resource_id` varchar(255) NOT NULL DEFAULT '',
  `privilege_name` varchar(255) NOT NULL DEFAULT '',
  `display_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`resource_id`,`privilege_name`),
  UNIQUE KEY `resource_id_2` (`resource_id`,`privilege_name`),
  KEY `resource_id` (`resource_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


INSERT INTO `resources` (`resource_id`, `display_name`) VALUES
('Application\\Controller\\Config', 'Global Config'),
('Application\\Controller\\Facility', 'Manage Facility'),
('Application\\Controller\\Index', 'Dashboard'),
('Application\\Controller\\Roles', 'Manage Roles'),
('Application\\Controller\\SpiV3', 'Manage SpiV3 Form'),
('Application\\Controller\\Users', 'Manage Users');


INSERT INTO `privileges` (`resource_id`, `privilege_name`, `display_name`) VALUES
('Application\\Controller\\Config', 'edit-global', 'Edit'),
('Application\\Controller\\Config', 'index', 'Access'),
('Application\\Controller\\Facility', 'add', 'Add'),
('Application\\Controller\\Facility', 'edit', 'Edit'),
('Application\\Controller\\Facility', 'get-facility-name', 'Merge Facilities'),
('Application\\Controller\\Facility', 'index', 'Access'),
('Application\\Controller\\Index', 'index', 'Access'),
('Application\\Controller\\Roles', 'add', 'Add'),
('Application\\Controller\\Roles', 'edit', 'Edit'),
('Application\\Controller\\Roles', 'index', 'Access'),
('Application\\Controller\\SpiV3', 'approve-status', 'Approved Status'),
('Application\\Controller\\SpiV3', 'download-pdf', 'Download pdf'),
('Application\\Controller\\SpiV3', 'edit', 'Edit'),
('Application\\Controller\\SpiV3', 'index', 'Access'),
('Application\\Controller\\SpiV3', 'manage-facility', 'Access to edit SPI Form'),
('Application\\Controller\\Users', 'add', 'Add'),
('Application\\Controller\\Users', 'edit', 'Edit'),
('Application\\Controller\\Users', 'index', 'Access');

--Pal 12-MAY-2016
INSERT INTO `resources` (`resource_id`, `display_name`) VALUES ('Application\\Controller\\Email', 'Manage Email');

INSERT INTO `privileges` (`resource_id`, `privilege_name`, `display_name`) VALUES ('Application\\Controller\\Email', 'index', 'Access');


INSERT INTO `privileges` (`resource_id`, `privilege_name`, `display_name`) VALUES ('Application\\Controller\\SpiV3', 'corrective-action-pdf', 'Download corrective action pdf');

--Pal 13-MAY-2016
CREATE TABLE IF NOT EXISTS `temp_mail` (
  `temp_id` int(11) NOT NULL AUTO_INCREMENT,
  `from_full_name` varchar(255) DEFAULT NULL,
  `from_mail` varchar(255) DEFAULT NULL,
  `to_email` varchar(255) NOT NULL,
  `cc` varchar(500) DEFAULT NULL,
  `bcc` varchar(500) DEFAULT NULL,
  `subject` mediumtext,
  `message` mediumtext,
  `status` varchar(255) NOT NULL DEFAULT 'pending',
  PRIMARY KEY (`temp_id`)
)

--Pal 17-MAY-2016
INSERT INTO `privileges` (`resource_id`, `privilege_name`, `display_name`) VALUES ('Application\\Controller\\SpiV3', 'delete', 'Delete');


--Amit 17-MAY-2016
ALTER TABLE `spi_form_v_3` CHANGE `avgMonthTesting` `avgMonthTesting` INT NULL DEFAULT '0';


--Pal 17-MAY-2016
ALTER TABLE `spi_rt_3_facilities` ADD `status` VARCHAR(255) NOT NULL DEFAULT 'active' AFTER `longitude`;

--Pal 24th-Aug-2016
CREATE TABLE `user_token_map` (
  `user_id` int(11) NOT NULL,
  `token` varchar(45) NOT NULL
)

CREATE TABLE `audit_mails` (
  `mail_id` int(11) NOT NULL,
  `from_full_name` varchar(255) DEFAULT NULL,
  `from_mail` varchar(255) DEFAULT NULL,
  `to_email` varchar(255) NOT NULL,
  `cc` varchar(500) DEFAULT NULL,
  `bcc` varchar(500) DEFAULT NULL,
  `subject` mediumtext,
  `message` mediumtext,
  `status` varchar(255) NOT NULL DEFAULT 'pending'
)

ALTER TABLE `audit_mails`
  ADD PRIMARY KEY (`mail_id`);
  
ALTER TABLE `audit_mails`
  MODIFY `mail_id` int(11) NOT NULL AUTO_INCREMENT;
  
--Pal 25th-Aug-2016
INSERT INTO `global_config` (`config_id`, `display_name`, `global_name`, `global_value`) VALUES (NULL, 'Header', 'header', NULL), (NULL, 'Logo', 'logo', NULL);


--ilahir 16-NOV-2016
INSERT INTO `odkdash`.`global_config` (`config_id`, `display_name`, `global_name`, `global_value`) VALUES (NULL, 'Language', 'language', 'English');





INSERT INTO `resources` (`resource_id`, `display_name`) VALUES ('Application\\Controller\\Dashboard', 'Manage Dashboard');
INSERT INTO `privileges` (`resource_id`, `privilege_name`, `display_name`) VALUES ('Application\\Controller\\Dashboard', 'index', 'Access'), ('Application\\Controller\\Dashboard', 'audi-details', 'Manage Audit details');
UPDATE `resources` SET `display_name` = 'Home' WHERE `resources`.`resource_id` = 'Application\\Controller\\Index';

ALTER TABLE `roles` ADD PRIMARY KEY(`role_id`);
ALTER TABLE `roles` ADD UNIQUE(`role_id`);
ALTER TABLE `roles` CHANGE `role_id` `role_id` INT(11) NOT NULL AUTO_INCREMENT;