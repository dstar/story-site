CREATE TABLE `blogposts` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `body` text NOT NULL,
  `created_on` datetime default NULL,
  `user` varchar(45) NOT NULL default 'dstar',
  `title` text,
  `updated_on` datetime default NULL,
  `body_raw` text,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=401 DEFAULT CHARSET=latin1;

CREATE TABLE `chapters` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `story_id` int(10) unsigned NOT NULL default '0',
  `number` int(10) unsigned NOT NULL default '0',
  `words` int(10) unsigned NOT NULL default '0',
  `date_uploaded` date default NULL,
  `file` varchar(45) NOT NULL default '',
  `status` varchar(255) default 'draft',
  `last_state` varchar(255) default NULL,
  `last_status` varchar(255) default NULL,
  `released` varchar(255) default NULL,
  `date_released` date default '0000-00-00',
  `release_on` datetime default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `chap_uniq` (`story_id`,`number`)
) ENGINE=InnoDB AUTO_INCREMENT=217 DEFAULT CHARSET=latin1;

CREATE TABLE `commitments` (
  `id` int(11) NOT NULL auto_increment,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `credits` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) NOT NULL,
  `story_id` int(11) NOT NULL,
  `credit_type` varchar(255) NOT NULL default 'Author',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=91 DEFAULT CHARSET=latin1;

CREATE TABLE `donations` (
  `id` int(11) NOT NULL auto_increment,
  `email` varchar(255) default NULL,
  `amount` float default NULL,
  `txn_id` varchar(255) default NULL,
  `donation_date` date default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `paragraphs` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `chapter_id` int(10) unsigned NOT NULL default '0',
  `body` text NOT NULL,
  `position` int(10) unsigned NOT NULL default '1',
  `flag` int(10) unsigned NOT NULL default '0',
  `body_raw` text,
  PRIMARY KEY  (`id`),
  KEY `chapter_index` (`chapter_id`)
) ENGINE=InnoDB AUTO_INCREMENT=27464 DEFAULT CHARSET=latin1;

CREATE TABLE `pcomments` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `paragraph_id` int(10) unsigned NOT NULL default '0',
  `body` text NOT NULL,
  `created_at` datetime default NULL,
  `username` varchar(45) NOT NULL default 'no user',
  `flag` int(10) unsigned NOT NULL default '0',
  `read_by` text,
  `acknowledged` varchar(255) default NULL,
  `body_raw` text,
  PRIMARY KEY  (`id`),
  KEY `pcomments_paragraph_id_index` (`paragraph_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1531 DEFAULT CHARSET=latin1;

CREATE TABLE `pcomments_read_by` (
  `pcomment_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  KEY `index_pcomments_read_by_on_pcomment_id` (`pcomment_id`),
  KEY `index_pcomments_read_by_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `required_permissions` (
  `id` int(11) NOT NULL auto_increment,
  `permissionable_id` int(11) default NULL,
  `permissionable_type` varchar(255) default NULL,
  `status` varchar(255) default NULL,
  `action` varchar(255) default NULL,
  `permission` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `schema_info` (
  `version` int(11) default NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE TABLE `sessions` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `sessid` varchar(255) default NULL,
  `data` text,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `session_index` (`sessid`)
) ENGINE=InnoDB AUTO_INCREMENT=1214 DEFAULT CHARSET=latin1;

CREATE TABLE `site_permissions` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) default NULL,
  `permission` varchar(255) default NULL,
  `permission_holder_id` int(11) default NULL,
  `permission_holder_type` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

CREATE TABLE `sites` (
  `id` int(11) NOT NULL auto_increment,
  `required_permissions` varchar(255) default NULL,
  `available_permissions` varchar(255) default NULL,
  `available_actions` varchar(255) default NULL,
  `available_story_states` varchar(255) default NULL,
  `default_permit` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

CREATE TABLE `stories` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `title` varchar(255) NOT NULL default '',
  `description` text NOT NULL,
  `flag` int(10) unsigned NOT NULL default '0',
  `universe_id` int(10) unsigned NOT NULL default '0',
  `short_title` varchar(45) NOT NULL default '',
  `order` int(10) unsigned NOT NULL default '0',
  `file_prefix` varchar(45) NOT NULL default '',
  `status` varchar(255) default 'draft',
  `keywords` varchar(255) default NULL,
  `on_release` varchar(255) default NULL,
  `required_chapter_permissions` varchar(255) default NULL,
  `required_permission` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=latin1;

CREATE TABLE `story_permissions` (
  `id` int(11) NOT NULL auto_increment,
  `permission_holder_id` int(11) default NULL,
  `permission_holder_type` varchar(255) default NULL,
  `story_id` int(11) default NULL,
  `permission` varchar(255) default NULL,
  PRIMARY KEY  (`id`),
  KEY `story_permissions_story_id_index` (`story_id`),
  KEY `story_permissions_permission_holder_id_index` (`permission_holder_id`)
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=latin1;

CREATE TABLE `styles` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `element` text NOT NULL,
  `definition` text NOT NULL,
  `theme` text NOT NULL,
  `user` mediumint(8) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=223 DEFAULT CHARSET=latin1;

CREATE TABLE `targets` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `story_id` int(10) unsigned NOT NULL default '0',
  `month` int(10) unsigned NOT NULL default '0',
  `year` int(10) unsigned NOT NULL default '0',
  `weekly_words` int(10) unsigned NOT NULL default '2000',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=latin1;

CREATE TABLE `universe_permissions` (
  `id` int(11) NOT NULL auto_increment,
  `permission_holder_id` int(11) default NULL,
  `permission_holder_type` varchar(255) default NULL,
  `universe_id` int(11) default NULL,
  `permission` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

CREATE TABLE `universes` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `name` varchar(45) NOT NULL default '',
  `description` text NOT NULL,
  `flag` int(10) unsigned NOT NULL default '0',
  `status` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

INSERT INTO `schema_info` (version) VALUES (41)