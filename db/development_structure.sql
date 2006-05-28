CREATE TABLE `blogposts` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `body` text NOT NULL,
  `posted` datetime NOT NULL default '0000-00-00 00:00:00',
  `user` varchar(45) NOT NULL default 'dstar',
  `title` varchar(45) NOT NULL default '',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `chapters` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `story_id` int(10) unsigned NOT NULL default '0',
  `number` int(10) unsigned NOT NULL default '0',
  `words` int(10) unsigned NOT NULL default '0',
  `date` date NOT NULL default '0000-00-00',
  `file` varchar(45) NOT NULL default '',
  `status` varchar(255) default 'draft',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `chap_uniq` (`story_id`,`number`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `credits` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) NOT NULL,
  `story_id` int(11) NOT NULL,
  `credit_type` varchar(255) NOT NULL default 'Author',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `paragraphs` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `chapter_id` int(10) unsigned NOT NULL default '0',
  `body` text NOT NULL,
  `order` int(10) unsigned NOT NULL default '1',
  `flag` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `pcomments` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `paragraph_id` int(10) unsigned NOT NULL default '0',
  `body` text NOT NULL,
  `created_at` datetime default NULL,
  `username` varchar(45) NOT NULL default 'no user',
  `flag` int(10) unsigned NOT NULL default '0',
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
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `site_permissions` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) default NULL,
  `permission` varchar(255) default NULL,
  `permission_holder_id` int(11) default NULL,
  `permission_holder_type` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

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
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `story_permissions` (
  `id` int(11) NOT NULL auto_increment,
  `permission_holder_id` int(11) default NULL,
  `permission_holder_type` varchar(255) default NULL,
  `story_id` int(11) default NULL,
  `permission` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `styles` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `element` text NOT NULL,
  `definition` text NOT NULL,
  `theme` text NOT NULL,
  `user` mediumint(8) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `targets` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `story_id` int(10) unsigned NOT NULL default '0',
  `month` int(10) unsigned NOT NULL default '0',
  `year` int(10) unsigned NOT NULL default '0',
  `weekly_words` int(10) unsigned NOT NULL default '2000',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `universe_permissions` (
  `id` int(11) NOT NULL auto_increment,
  `permission_holder_id` int(11) default NULL,
  `permission_holder_type` varchar(255) default NULL,
  `universe_id` int(11) default NULL,
  `permission` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `universes` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `name` varchar(45) NOT NULL default '',
  `description` text NOT NULL,
  `flag` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO schema_info (version) VALUES (12)