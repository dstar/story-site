-- MySQL Administrator dump 1.4
--
-- ------------------------------------------------------
-- Server version	5.0.19-nt-max


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


--
-- Create schema pelestats
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ pelestats;
USE pelestats;

--
-- Table structure for table `pelestats`.`blogposts`
--

DROP TABLE IF EXISTS `blogposts`;
CREATE TABLE `blogposts` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `body` text NOT NULL,
  `posted` datetime NOT NULL default '0000-00-00 00:00:00',
  `user` varchar(45) NOT NULL default 'dstar',
  `title` varchar(45) NOT NULL default '',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `pelestats`.`blogposts`
--

/*!40000 ALTER TABLE `blogposts` DISABLE KEYS */;
INSERT INTO `blogposts` (`id`,`body`,`posted`,`user`,`title`) VALUES 
 (1,'Testing blog...entry 1.','2006-04-26 22:21:47','dstar','Entry 1'),
 (2,'Testing blog...entry 2.','2006-04-26 22:21:51','dstar','Entry 2'),
 (3,'Testing blog...entry 3.','2006-04-26 22:21:52','dstar','Entry 3'),
 (4,'Testing blog...entry 4.','2006-04-26 22:31:15','dstar','Entry 4'),
 (5,'Testing blog...entry 5.','2006-04-26 22:31:23','dstar','Entry 5'),
 (6,'Testing blog...entry 6.','2006-04-26 22:31:34','dstar','Entry 6'),
 (7,'Testing blog...entry 7.','2006-04-26 22:31:36','dstar','Entry 7'),
 (8,'Testing blog...entry 8.','2006-04-26 22:31:38','dstar','Entry 8'),
 (9,'Testing blog...entry 9.','2006-04-26 22:31:39','dstar','Entry 9'),
 (10,'Testing blog...entry 10.','2006-04-26 22:31:41','dstar','Entry 10'),
 (11,'Testing blog...entry 11.','2006-04-26 22:31:43','dstar','Entry 11'),
 (12,'Testing blog...entry 12.','2006-04-26 22:31:45','dstar','Entry 12'),
 (13,'Testing blog...entry 13.','2006-04-26 22:31:46','dstar','Entry 13'),
 (14,'Testing blog...entry 14.','2006-04-26 22:31:48','dstar','Entry 14');
INSERT INTO `blogposts` (`id`,`body`,`posted`,`user`,`title`) VALUES 
 (15,'Testing blog...entry 15.','2006-04-26 22:31:49','dstar','Entry 15');
/*!40000 ALTER TABLE `blogposts` ENABLE KEYS */;


--
-- Table structure for table `pelestats`.`chapters`
--

DROP TABLE IF EXISTS `chapters`;
CREATE TABLE `chapters` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `story_id` int(10) unsigned NOT NULL default '0',
  `number` int(10) unsigned NOT NULL default '0',
  `words` int(10) unsigned NOT NULL default '0',
  `date` date NOT NULL default '0000-00-00',
  `file` varchar(45) NOT NULL default '',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `chap_uniq` (`story_id`,`number`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `pelestats`.`chapters`
--

/*!40000 ALTER TABLE `chapters` DISABLE KEYS */;
INSERT INTO `chapters` (`id`,`story_id`,`number`,`words`,`date`,`file`) VALUES 
 (1,7,3,1982,'2006-01-14','jaknis3.html'),
 (2,7,4,2079,'2006-01-29','jaknis4.html'),
 (3,7,5,2052,'2006-01-29','jaknis5.html'),
 (4,7,1,1553,'2005-12-29','jaknis1.html'),
 (5,7,2,2519,'2006-01-01','jaknis2.html'),
 (6,11,1,1957,'2006-03-16','kitty1.html'),
 (7,6,1,2122,'2006-01-04','nad1.html'),
 (8,6,2,2014,'2006-01-08','nad2.html'),
 (9,6,3,3712,'2006-01-20','nad3.html'),
 (10,6,4,2129,'2006-01-27','nad4.html'),
 (11,3,1,2415,'2005-12-22','sonuachara1.html'),
 (12,3,2,1575,'2006-01-04','sonuachara2.html'),
 (13,3,3,2066,'2006-01-10','sonuachara3.html'),
 (14,3,4,2085,'2006-01-14','sonuachara4.html'),
 (15,3,5,1924,'2006-01-19','sonuachara5.html'),
 (16,3,6,2508,'2006-01-31','sonuachara6.html'),
 (17,8,1,5858,'2006-04-06','oops1.html'),
 (18,8,2,6166,'2006-04-06','oops2.html'),
 (19,8,3,7579,'2006-04-06','oops3.html'),
 (20,8,4,10256,'2006-04-06','oops4.html'),
 (21,7,6,2299,'2006-04-08','jaknis6.html'),
 (22,10,1,4291,'2005-12-14','pandoras_box1.html');
INSERT INTO `chapters` (`id`,`story_id`,`number`,`words`,`date`,`file`) VALUES 
 (23,10,2,3521,'2005-12-16','pandoras_box2.html'),
 (24,10,3,2821,'2005-12-26','pandoras_box3.html'),
 (25,10,4,4008,'2005-12-29','pandoras_box4.html'),
 (26,10,5,2193,'2006-01-14','pandoras_box5.html'),
 (27,10,6,3398,'2006-01-25','pandoras_box6.html'),
 (28,10,7,2351,'2006-01-25','pandoras_box7.html'),
 (29,10,8,4077,'2006-01-25','pandoras_box8.html'),
 (30,10,9,3264,'2006-02-03','pandoras_box9.html'),
 (31,10,10,2470,'2006-02-15','pandoras_box10.html'),
 (32,10,11,3429,'2006-02-15','pandoras_box11.html'),
 (33,10,12,1839,'2006-02-28','pandoras_box12.html'),
 (34,10,13,2109,'2006-03-07','pandoras_box13.html'),
 (35,10,14,3411,'2006-03-15','pandoras_box14.html'),
 (36,10,15,2984,'2006-03-23','pandoras_box15.html'),
 (37,10,16,3940,'2006-04-01','pandoras_box16.html'),
 (38,1,1,9364,'2002-11-10','prudence1.html'),
 (39,1,2,11245,'2002-11-10','prudence2.html'),
 (40,1,3,5002,'2003-01-26','prudence3.html'),
 (41,1,4,5438,'2003-01-26','prudence4.html'),
 (42,1,5,2798,'2003-01-26','prudence5.html');
INSERT INTO `chapters` (`id`,`story_id`,`number`,`words`,`date`,`file`) VALUES 
 (43,1,6,5309,'2003-10-17','prudence6.html'),
 (44,1,7,6203,'2003-11-21','prudence7.html'),
 (45,1,8,3345,'2004-02-04','prudence8.html'),
 (46,1,9,4707,'2004-02-04','prudence9.html'),
 (47,1,10,2074,'2004-02-05','prudence10.html'),
 (48,1,11,2461,'2004-05-30','prudence11.html'),
 (49,1,12,4510,'2004-06-02','prudence12.html'),
 (50,1,13,7012,'2004-07-30','prudence13.html'),
 (51,1,14,3347,'2004-12-22','prudence14.html'),
 (52,1,15,4013,'2005-01-17','prudence15.html'),
 (53,1,16,2223,'2005-12-13','prudence16.html'),
 (54,1,17,1988,'2005-12-19','prudence17.html'),
 (55,1,18,4415,'2005-12-22','prudence18.html'),
 (56,1,19,3154,'2006-01-01','prudence19.html'),
 (57,1,20,3929,'2006-01-06','prudence20.html'),
 (58,1,21,2043,'2006-01-13','prudence21.html'),
 (59,1,22,2057,'2006-01-13','prudence22.html'),
 (60,1,23,2390,'2006-01-25','prudence23.html'),
 (61,1,24,1648,'2006-01-25','prudence24.html'),
 (62,1,25,2136,'2006-01-27','prudence25.html'),
 (63,1,26,3415,'2006-01-30','prudence26.html');
INSERT INTO `chapters` (`id`,`story_id`,`number`,`words`,`date`,`file`) VALUES 
 (64,1,27,1301,'2006-02-06','prudence27.html'),
 (65,1,28,3218,'2006-02-07','prudence28.html'),
 (66,1,29,2544,'2006-02-15','prudence29.html'),
 (67,1,30,3672,'2006-02-20','prudence30.html'),
 (68,1,31,3571,'2006-03-01','prudence31.html'),
 (69,1,32,2758,'2006-03-09','prudence32.html'),
 (70,1,33,4520,'2006-03-10','prudence33.html'),
 (71,1,34,2039,'2006-03-16','prudence34.html'),
 (72,1,35,1820,'2006-03-17','prudence35.html'),
 (73,1,36,1633,'2006-03-26','prudence36.html'),
 (74,1,37,2865,'2006-04-06','prudence37.html'),
 (75,1,38,987,'2006-04-08','prudence38.html'),
 (76,1,39,2923,'2006-04-09','prudence39.html'),
 (77,8,5,7422,'2006-04-10','oops5.html'),
 (78,8,6,9592,'2006-04-10','oops6.html'),
 (79,8,7,7840,'2006-04-11','oops7.html'),
 (80,8,8,7648,'2006-04-12','oops8.html'),
 (81,8,9,5474,'2006-04-14','oops9.html'),
 (82,8,10,4077,'2006-04-14','oops10.html'),
 (83,7,7,1990,'2006-04-18','jaknis7.html'),
 (84,7,8,2096,'2006-04-08','jaknis8.html');
INSERT INTO `chapters` (`id`,`story_id`,`number`,`words`,`date`,`file`) VALUES 
 (85,1,40,2155,'2006-04-18','prudence40.html');
/*!40000 ALTER TABLE `chapters` ENABLE KEYS */;


--
-- Table structure for table `pelestats`.`paragraphs`
--

DROP TABLE IF EXISTS `paragraphs`;
CREATE TABLE `paragraphs` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `chapter_id` int(10) unsigned NOT NULL default '0',
  `body` text NOT NULL,
  `order` int(10) unsigned NOT NULL default '1',
  `flag` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `pelestats`.`paragraphs`
--

/*!40000 ALTER TABLE `paragraphs` DISABLE KEYS */;
INSERT INTO `paragraphs` (`id`,`chapter_id`,`body`,`order`,`flag`) VALUES 
 (1,17,'Brynna was frustrated. And confused.',1,0),
 (2,17,'Since starting on the Pill a couple of weeks ago, it had gotten harder and harder for her to come. She\'d masturbated for as long as she could remember, usually two or even three times a night unless she was sick, but it had gotten harder and harder to actually _come_ over the last two weeks. There was no problem getting turned on, or even getting herself close to orgasm, but it was taking longer and longer to get the rest of the way over the edge. And for the last three nights, she hadn\'t managed it at all, leaving her a walking mass of vibrating, frustrated nerves. The night before, she\'d spent three hours rubbing herself, only to finally give up,sobbing, when she heard her mother coming in from work after midnight. ',2,0),
 (3,17,'That was why she was frustrated.',3,0),
 (4,17,'The confusion stemmed from a different source entirely. She thought. She wasn\'t entirely sure. Maybe it was just that she was hornier and more frustrated than she\'d ever been in her life. ',4,0),
 (5,17,'She wasn\'t gay, but she\'d always been able to enjoy looking at girls on an aesthetic level, all smooth curves and soft skin. Nothing sexual, just...nice to look at. But something had happened that afternoon after school that she hadn\'t been able to get out of her head. ',5,0);
INSERT INTO `paragraphs` (`id`,`chapter_id`,`body`,`order`,`flag`) VALUES 
 (6,17,'She\'d been in the girls\' bathroom when one of the other girls in her class was changing. She wasn\'t entirely sure why the girl had been changing-- from a dress to a faded t-shirt and jeans.',6,0),
 (7,17,'For a moment, they were alone in the bathroom, the girl-- Anne was her name, she thought-- standing there in nothing but her white lace panties and bra as she folded the dress neatly. She found herself staring at the girl, dark black curls framing big green eyes set in a delicate face, flawless white skin, breasts which were, truthfully, not much more than swellings on her chest, long, slender legs ending in delicate feet. ',7,0),
 (8,17,'The bra was more decoration than support for the tiny breasts, and as the girl bent over to tuck the dress away in her bag, it fell away slightly, revealing a momentary glimpse of tiny, perfect pink nipples before the girl straightened. She caught Brynna\'s gaze and froze for a moment before flushing and turning away, dressing hurriedly. ',8,0),
 (9,17,'Brynna wasn\'t sure if the girl realized she\'d been staring, and part of her wasn\'t sure what it wanted the answer to be. The only thing she was sure of was the fact that she hadn\'t been able to get the image out of her mind all afternoon. ',9,0);
INSERT INTO `paragraphs` (`id`,`chapter_id`,`body`,`order`,`flag`) VALUES 
 (10,17,'Even when she was fixing dinner for her younger sister, she caught herself remembering it, the tiny delicate nipples, the way the girl\'s skin had turned bright pink, the soft white skin of the girl\'s ass... ',10,0),
 (11,17,'Now she was in bed, and frustrated. Again. She couldn\'t find any of the stories she liked to read, the kind that got her off quickly -- girls being captured by pirates, or Nazis, or mad scientists, forced to do humiliating things while being used as a plaything. It was the same problem she\'d had for the last three nights, but worse, because the image of the almost-naked girl kept distracting her. ',11,0),
 (12,17,'Finally, so frustrated she wanted to scream, she gave in. She never fantasized about real people, ever; it made her feel... creepy, afterward. But she was so desperate that she didn\'t care anymore. If she ended up not coming again she\'d... she\'d... she didn\'t know what she\'d do, but she couldn\'t take it. ',12,0),
 (13,17,'She was careful, at first. She imagined what the girl would look like without the bra, and raised one hand to her chest, two fingers of the other hand rubbing her clit in little circles. She stiffened when she cupped one of her breasts, pretending it was Anne\'s breast she was touching, imagining what it would feel like to touch the puffy little mounds, the tiny little nipple, and it felt like a bolt of lightning shot from her nipple to her clit as she did. ',13,0);
INSERT INTO `paragraphs` (`id`,`chapter_id`,`body`,`order`,`flag`) VALUES 
 (14,17,'She bit her lip, imagining the girl\'s eyes closing in pleasure as she brushed her thumb across her nipple, arching her hips as another jolt shot through her. Her face was flushed, and her fingers wet and sticky. ',14,0),
 (15,17,'She sucked in a sudden breath as she remembered what the girl\'s panties had looked like, lacy and smooth against her skin. ',15,0),
 (16,17,'Smooth. ',16,0),
 (17,17,'Either the girl didn\'t have any hair down there, or she shaved it. The sudden image of the girl shaving, drawing a razor across the slick, wet skin, made her shiver, and she could feel herself getting even wetter than she already was. ',17,0),
 (18,17,'She was closer to coming than she\'d gotten at any point the night before, much closer, but not quite there. Not enough closer. So she let herself wonder what it would feel like to be touched by the other girl, how it would feel to have those tiny, delicate hands cupping her breasts -- and she cupped one of hers, lightly, letting just the fingertips touch, pretending it was Anne touching her, breathing harder, trailing her fingers over the breast, one brushing her nipple. ',18,0),
 (19,17,'Not enough. ',19,0);
INSERT INTO `paragraphs` (`id`,`chapter_id`,`body`,`order`,`flag`) VALUES 
 (20,17,'She licked her suddenly dry lips, and the feel of her tongue brought another image to her mind. Anne, on the bed between her legs. ',20,0),
 (21,17,'Licking her. ',21,0),
 (22,17,'She slipped a finger down between her cunt lips, wetting it, then drew it up and over her clit in short, rhythmic motions, like what she imagined a tongue would feel like, like what she imagined _Anne\'s_ tongue would feel like, and her nipples tingled as she came closer to orgasm. ',22,0),
 (23,17,'But not close enough. Her clit was sore from the night before, and the pain was just enough to distract her, to keep her from coming, and she let herself slide deeper into the fantasy, adding in things she\'d read that never failed to turn her on. ',23,0),
 (24,17,'Anne was on her knees in front of her, arms cuffed behind her back, pulled painfully close together. Brynna\'s hands were dug into the brunette\'s hair as the brunette licked her frantically, her hair wet and matted from the standing girl\'s juices, plastered to her head. ',24,0),
 (25,17,'\"That\'s right, little slut. Lick me. Lick my clit. You know you like it, don\'t you, slut? You like it when I let you lick my cunt, don\'t you?\" She waited a moment, then pulled Anne\'s head away. \"Don\'t you?\" ',25,0);
INSERT INTO `paragraphs` (`id`,`chapter_id`,`body`,`order`,`flag`) VALUES 
 (26,17,'The smaller girl looked miserable, and her chin quivered, but she nodded, and Brynna smiled. \"Then show me what a good cunt licker you are.\" ',26,0),
 (27,17,'Anne practically dove back into Brynna\'s cunt, lapping at her clit, leaving no doubt that she desperately needed to be doing what she was doing, and Brynna caressed the back of her head. \"That\'s right, my little slut. You need to lick my cunt. You _want_ to be my little slut, my little cunt-licking whore, and you know it, don\'t you? Mmm, oh yeah, just like that...\" ',27,0),
 (28,17,'Not enough. So close, but not there. Her legs were tensed, but she couldn\'t quite come. ',28,0),
 (29,17,'She stood in front of Anne with a whip in her hand. \"I\'m going to hurt you, little slut. And do you know why I\'m going to hurt you?\" ',29,0),
 (30,17,'The brunette shook her head, eyes wide and frightened. \"N-no. Please, don\'t -- aaaah!\" She screamed as the whip wrapped around her side, leaving a raised welt. ',30,0),
 (31,17,'\"Uh-uh-uh,\" Brynna said. \"You don\'t talk unless I tell you you can, understand, my slut?\" ',31,0);
INSERT INTO `paragraphs` (`id`,`chapter_id`,`body`,`order`,`flag`) VALUES 
 (32,17,'Anne opened her mouth to answer, but snapped it shut when Brynna raised the whip threateningly, instead nodding frantically. ',32,0),
 (33,17,'\"Better, slut. When I ask you a question, you nod or shake your head unless I tell you to talk, understand?\" Anne nodded frantically again, and Brynna smiled. \"Good. Now, do you understand why I\'m going to hurt you?\" ',33,0),
 (34,17,'Anne shook her head slowly, never looking away from Brynna. ',34,0),
 (35,17,'\"Because I _can_. Because you are _mine_. You\'re my slut, my little fuck toy, and I can do whatever I want with you.\" Brynna smiled again. \"_Anything_ I want. And I want to hurt you. You can scream, if you want.\" ',35,0),
 (36,17,'Anne\'s eyes widened even further as Brynna drew back the whip, and she did scream. Over and over, as the whip lashed into her body, leaving her perfect skin welted and raised, breaking the skin and letting blood trickle down. She screamed, and then she begged, pushed beyond endurance, unable _not_ to beg, and Brynna smiled. \"You\'re my little slut, aren\'t you? My little fuck-toy. You know it, don\'t you? Tell me!\" ',36,0),
 (37,17,'\"YES!\" Anne screamed. \"I am! Please, it hurts, stop, please, I\'ll do whatever you want!\" ',37,0);
INSERT INTO `paragraphs` (`id`,`chapter_id`,`body`,`order`,`flag`) VALUES 
 (38,17,'\"I know you will.\" Brynna uncuffed the girl\'s arms from the wall, letting her fall onto the floor in front of her in a bleeding, sobbing heap. \"Lick me, fuck-toy.\" ',38,0),
 (39,17,'Anne threw her arms around Brynna\'s legs, pulling herself up so that she could lick desperately at Brynna\'s cunt, clumsily, obviously having never done this before. Knowing that this was the first time she\'d ever done this almost made Brynna come. ',39,0),
 (40,17,'Almost. ',40,0),
 (41,17,'She sobbed, frustrated, her clit sore, her legs aching from having been tensed for over an hour now. So close. So _close_. But not quite there. ',41,0),
 (42,17,'Anne hung on the wall, where Brynna hang chained her several hours before. She was whimpering and squirming in pain, and Brynna smiled coldly. \"You\'re _mine_, whore. Just admit it. Just admit that your body belongs to me, that your mind belongs to me...\" She stepped forward, catching Anne\'s chin in her hand and holding her head while she kissed her, roughly, forcing her tongue into the girl\'s mouth. \"That your heart belongs to me. You\'re mine, and you know it. Stop fighting it.\" ',42,0),
 (43,17,'\"Please, don\'t... don\'t make me... please...\" Anne squirmed, trying to pull her legs together, but the chains weren\'t quite long enough. \"I can\'t.\" ',43,0);
INSERT INTO `paragraphs` (`id`,`chapter_id`,`body`,`order`,`flag`) VALUES 
 (44,17,'\"You can, and you will. You don\'t have a choice. I want you to, and you\'re going to. You are _mine_. Admit it, and stop fighting it, and I\'ll give you what you want.\" ',44,0),
 (45,17,'\"I _can\'t_!\" Anne pleaded. \"Please, Mistress, please, I can\'t...\" ',45,0),
 (46,17,'Brynna smiled, stepping closer. \"Mistress. I like that. I like that a _lot_. You\'re going to call me Mistress from now on, understand, toy?\" ',46,0),
 (47,17,'Anne nodded rapidly. \"Yes, Mistress. Please, I can\'t... I _can\'t_...\" ',47,0),
 (48,17,'\"I think you deserve a reward for being such a good slut,\" Brynna said, stepping closer again. \"I\'m going to make you come.\" ',48,0),
 (49,17,'Anne\'s eyes somehow managed to widen further. \"I _can\'t_, Mistress! It hurts too bad!\" ',49,0),
 (50,17,'Brynna chuckled. \"You don\'t have a choice in this, either.\" She grabbed the back of the smaller girls neck, pulling her head back, as her other hand slipped between the girl\'s legs. \"You\'re mine,\" she whispered, her mouth a fraction of an inch away from the other girl\'s ear. \"You come when I tell you to. And I\'m telling you... to... come...\" Her lips trailed down, little butterfly kisses, until she came to the join of the girl\'s shoulder and neck, and then she bit down, hard. ',50,0),
 (51,17,'Hard enough to break the skin, and Anne screamed, loudly, and then louder still as the fingers on her clit joined the sudden pain to send her over the edge, writhing. When she finally came down, Brynna kissed her, hard, her blood still on her lips. ',51,0);
INSERT INTO `paragraphs` (`id`,`chapter_id`,`body`,`order`,`flag`) VALUES 
 (52,17,'Anne whimpered, eyes glazed. \"Please... please... it hurts... I can\'t take it.\" ',52,0),
 (53,17,'\"Then do it,\" Brynna whispered. \"Right here, right now, while I play with your clit. You\'re _mine_. You hurt when I tell you to. You come when I tell you to. And if I tell you to piss yourself, you do that. You know you\'re mine. Admit it, and stop fighting me.\" ',53,0),
 (54,17,'Anne sobbed, a broken sound. \"I _can\'t_!\" She broke into choking sobs. \"I can\'t, Mistress, I\'m sorry, I just can\'t!\" ',54,0),
 (55,17,'Brynna sighed. \"Maybe you need a little bit more proof that you belong to me, then.\" ',55,0),
 (56,17,'Anne looked at her, fear and need and cautious hope warring in her eyes. \"M-mistress?\" ',56,0),
 (57,17,'Brynna reached over, picking up a small box from the table beside her. \"Ever since I saw these for the first time,\" she said, brushing a thumb over Anne\'s tiny nipples, \"I\'ve wanted to see what they\'d look like if they were... properly adorned. I think they\'ll be so beautiful.\" ',57,0),
 (58,17,'\"M-mistress?\" Anne asked again. ',58,0);
INSERT INTO `paragraphs` (`id`,`chapter_id`,`body`,`order`,`flag`) VALUES 
 (59,17,'\"So I\'m going to give you the jewelry they\'re practically crying out for,\" Brynna said. \"When two people get married, they exchange rings. But when a Mistress claims her slave beyond any release, she uses _these_.\" ',59,0),
 (60,17,'Anne\'s eyes widened in fear as Brynna opened the box, revealing two captive-bead rings and two needles. \"M-mistress, p-please don\'t... n-needles... I-I c-can\'t --\" Her face went dead pale, and she began to shiver. \"P-please!\" ',60,0),
 (61,17,'\"Mine,\" Brynna said firmly. \"I can do whatever I want with you. And I\'m going to.\" She picked up a clamp and squeezed Anne\'s right nipple in it. \"Right now.\" ',61,0),
 (62,17,'\"M-mistress!\" Anne begged, terrified. \"Please!\" ',62,0),
 (63,17,'Brynna picked up the needle, barely touching it to the nipple. Looking Anne directly in the eye, she said, \"Mine,\" and pushed the needle through in one motion. ',63,0),
 (64,17,'Anne screamed, loud, the sound echoing in the chamber, and lost control of her bladder, the piss running down her legs and spattering on the floor. She pulled against the chains hard, trying to get loose, but Brynna didn\'t let go of the needle, and the pain from pulling against it made her scream again and slump. ',64,0),
 (65,17,'\"I told you,\" Brynna said, looking her in the eye. \"You\'re mine. You\'ll do as I say, and you do it when I tell you to. Do you understand now?\" ',65,0);
INSERT INTO `paragraphs` (`id`,`chapter_id`,`body`,`order`,`flag`) VALUES 
 (66,17,'Anne looked up at her, and something was different. Something had changed. She wasn\'t broken, but she knew. She knew that she belonged to Brynna. She knew that she was Brynna\'s to do with as she wanted. She knew that she was Brynna\'s slave. ',66,0),
 (67,17,'Brynna could see it in her eyes. ',67,0),
 (68,17,'She held up the other needle. \"You do, don\'t you,\" she said softly, and Anne nodded, slowly, never looking away. ',68,0),
 (69,17,'\"I\'m going to pierce your other nipple. And you\'re going to hold perfectly still, and you\'re not going to scream. And then you\'re going to thank me for your new jewelry. Understand?\" ',69,0),
 (70,17,'Anne nodded again, shivering. \"Y-yes, Mistress.\" ',70,0),
 (71,17,'\"Good girl.\" ',71,0),
 (72,17,'Brynna clamped the other nipple, and Anne\'s fingers clenched the chains attached to her cuffs, holding on so tightly that her knuckles where white, eyes wide and breathing fast, but the only sound she made as the needle slid through her tender nipple was a faint, high-pitched keening. ',72,0),
 (73,17,'\"Good girl,\" Brynna said again. \"Now for your jewelry.\" She held up the rings. \"Ready?\" ',73,0);
INSERT INTO `paragraphs` (`id`,`chapter_id`,`body`,`order`,`flag`) VALUES 
 (74,17,'Anne nodded jerkily. \"Y-yes, Mistress.\" ',74,0),
 (75,17,'It took only moments to replace the needles with the rings, and Brynna gazed at Anne expectantly. ',75,0),
 (76,17,'\"Oh!\" Anne said after a moment, remembering. \"T-thank you, Mistress, for my new jewelry. And...\" she hesitated, as if unsure, then rushed on. \"Thank you for showing me that I belong to you.\" ',76,0),
 (77,17,'Brynna smiled. \"Good girl. Now I\'m going to let you down, because my cunt is so wet, and you\'re going to lick me. Ready?\" ',77,0),
 (78,17,'Anne nodded eagerly. \"Yes, Mistress.\" ',78,0),
 (79,17,'Brynna unfastened one wrist, then the other. For a moment it seemed as if Anne was able to stand on her own, but then her legs buckled, and she fell to her knees in the puddle of piss. ',79,0),
 (80,17,'\"Slut!\" Brynna said. \"You splashed me!\" ',80,0),
 (81,17,'\"Sorry, Mistress!\" Anne said. \"I didn\'t mean to!\" ',81,0),
 (82,17,'Brynna ran a hand over Anne\'s head. \"I know you didn\'t. But you did. And it\'s a good way for me to prove to you even more that you\'re mine.\" ',82,0);
INSERT INTO `paragraphs` (`id`,`chapter_id`,`body`,`order`,`flag`) VALUES 
 (83,17,'\"Mistress?\" ',83,0),
 (84,17,'Brynna pushed on Anne\'s shoulder, forcing her down, until the smaller girl squealed in pain as her freshly pierced nipples were pressed into the puddle and against the rough floor, the +warm+ liquid stinging painfully. ',84,0),
 (85,17,'\"Clean it up.\" Brynna slid her foot forward, two drops of piss clinging to it. ',85,0),
 (86,17,'\"M-mistress? Anne bent her head painfully to look up at her. \"I don\'t understand.\" ',86,0),
 (87,17,'\"Lick it clean, slut. You made the mess, you clean it up.\" ',87,0),
 (88,17,'Anne stared at her for a moment, and then, without looking away, began to lick. ',88,0),
 (89,17,'And Brynna came, hard, biting the back of her hand as she screamed, coming harder than she\'d ever come in her life, the orgasm rushing over her and past her, harder and faster than ever before. It lasted an eternity, and when she finally came down, she could taste blood from where her teeth had broken the skin. ',89,0),
 (90,17,'Brynna lay there, very still, trying to control her panting, listening to make sure she wasn\'t heard. ',90,0);
INSERT INTO `paragraphs` (`id`,`chapter_id`,`body`,`order`,`flag`) VALUES 
 (91,17,'There was no sound, though, no indication that anyone had been listening at the door, or through a wall, and gradually she relaxed. Then she got up, went into the bathroom, washed up, and spent a long while staring into the mirror, wondering just what sort of person she was turning into. Real people had no place in fantasy. Hell, she\'d never put _herself_ in her fantasies before, much less anyone she knew. And then, to break that \'rule\' in such an extreme way, with so much violence and cruelty... She felt vaguely ill. And still turned on as hell by the images. ',91,0),
 (92,17,'Brynna sighed, then opened the cabinet, pulling out a bandage to hide the bite mark on her hand. She went back to bed more confused than she\'d started out. ',92,0),
 (93,17,'<hr/>',93,0),
 (94,17,'Guilty conscience or simply increased awareness? Brynna didn\'t know, but by midday she\'d seen Anne more than she recalled seeing her all year. She seemed to be everywhere, and Brynna was going crazy trying to avoid looking at her. She felt flushed and ill from guilt, and was strongly considering going home sick. ',94,0),
 (95,17,'It was a long, long night. She kept seeing bits of the fantasy every time she started to drift off and jerking awake. Morning necessitated a long shower. A long, _cold_ shower, just in case it would help. It didn\'t. It just woke her up enough that she felt good enough to get really turned on. So she wasn\'t in the best of moods when she made it to school, and finding Anne lurking near her locker when she knew for a fact that hers was on the other side of the building was just about too damned much. She practically yanked open her locker and leaned inside it, eyes closed and jaw clenched. ',95,0);
INSERT INTO `paragraphs` (`id`,`chapter_id`,`body`,`order`,`flag`) VALUES 
 (96,17,'When she finally turned back around, Anne was gone, as if she\'d never been there. ',96,0),
 (97,17,'Twice more during the day, Brynna ran into her in places she was pretty sure she shouldn\'t even _be_. Or was that just the guilt again? After all, she didn\'t really know anything about the girl, certainly not enough to be certain of her schedule. But... it still seemed odd. And, for some reason, naggingly familiar. ',97,0),
 (98,17,'She didn\'t masturbate that night, either. Nor did she sleep, to speak of. What dreams she had were erotic, visions of Anne\'s skin under her hands, under her tongue, the taste of Anne\'s cunt... ',98,0),
 (99,17,'Brynna woke with a groan, slammed her fist violently into the alarm clock, rolled over and tried to go back to sleep. Screw it. She wasn\'t going to torture herself again today. Obviously, she was over-stressed and it was fucking with her head. A day off was just what she needed. ',99,0),
 (100,17,'Half an hour later, her mother banged on the door. \"Brynna! Hurry up, you\'re going to be late!\" ',100,0);
INSERT INTO `paragraphs` (`id`,`chapter_id`,`body`,`order`,`flag`) VALUES 
 (101,17,'Brynna growled into her pillows, then yelled back, \"I\'m _sick_, Mom!\" ',101,0),
 (102,17,'The door swung open. \"You can\'t just be skipping school anytime you don\'t feel good! You need to get good grades so you can get a scholarship. I can\'t afford to send you to college, you know that. Now, c\'mon. Up!\" ',102,0),
 (103,17,'Brynna didn\'t budge. \"I don\'t skip school. I _never_ skip school. You know that. I told you, I\'m _sick_. It\'s probably those stupid pills. The damned things are messing me up!\" ',103,0),
 (104,17,'Her mother walked over, pressing her hand on Brynna\'s forehead. \"You don\'t feel like you have a fever.\" ',104,0),
 (105,17,'\"I don\'t have a fever,\" Brynna admitted grudgingly. \"But my head is killing me, and I can\'t sleep, and I think it\'s turning me into a raving psycho-bitch.\" ',105,0),
 (106,17,'Her mother sighed. \"Why do you say that? Your sister hasn\'t said anything...\" ',106,0),
 (107,17,'\"That\'s because I\'m extra careful around her, and she stays in her room, mostly, anyway. But at school I\'m _totally_ on edge,\" she said. \"I\'m afraid I might hurt someone.\" ',107,0);
INSERT INTO `paragraphs` (`id`,`chapter_id`,`body`,`order`,`flag`) VALUES 
 (108,17,'\"Well, I doubt you\'d do that. Honey, school is _important_. I want you to have a better life that this. That\'s why I got you on the pills, and that\'s why you\'re going to college. You don\'t want to be like me, all broken down by the time you\'re thirty,\" her mother said. ',108,0),
 (109,17,'Brynna sighed. \"You\'re not broken down. You\'re exhausted. And that\'s what I\'m headed for _now_ if I can\'t get some rest. And I told you before I\'m not _interested_ in even having a boyfriend right now, much less sex.\" She hesitated, aware of the not exactly truthful nature of that statement, then added to make it better, \"I\'ve never met a guy that I found even _vaguely_ interesting in that way, much less worth the effort and risk and time. Trust me on this.\" ',109,0),
 (110,17,'Her mother sighed. \"At least try. Go on to school, but if it gets too bad you can come home, okay?\" ',110,0),
 (111,17,'Brynna groaned. An honest, heartfelt compromise. She\'d be a total bitch to argue. \"All right.\" ',111,0),
 (112,17,'\"Great.\" Her mother smiled. \"If you hurry, I can drop you off at school so that you don\'t have to walk.\" ',112,0);
INSERT INTO `paragraphs` (`id`,`chapter_id`,`body`,`order`,`flag`) VALUES 
 (113,17,'\"Sure.\" Brynna forced a weak smile. \"That\'d be nice.\" ',113,0),
 (114,17,'Constantly running into the girl was bad enough. But the sad puppy eyes, when Brynna finally identified them, was just too much. For the first time, she did skip a class. She spent fifth period in the nurse\'s office, laying down with an ice-pack over her eyes, thinking. She couldn\'t think of any logical explanation. Except... maybe it was the incident that started the whole vicious cycle? The girl was gay and closeted, perhaps, and thought since Brynna\'d spent that surprised instant staring that... but wouldn\'t she say something, if that were the case? Oh _fuck_, what if that _were_ the case, and she was just that shy. That would be... bad. Very bad. ',114,0),
 (115,17,'She went home early. She just couldn\'t take it. Not facing the girl between every class, seeing the sad, kicked puppy-dog eyes... she couldn\'t take it. So she went home early and collapsed in bed. Maybe she should talk to her. Would it really be all that bad to... Whoa. Yes. Yes it would. Because her fantasies were too extreme to get what she wanted. If the girl weren\'t so shy, were a bit stronger-willed, were a bit _bigger_ for godsake! Then... maybe. But as is, she\'d probably kill her and end up locked away with the other violent sociopaths. So. Not good. No matter how pretty the sad eyes were. How soft her skin looked. How lovely the little breasts.... ',115,0),
 (116,17,'Brynna groaned and rolled over, burying her face in the pillow. ',116,0);
INSERT INTO `paragraphs` (`id`,`chapter_id`,`body`,`order`,`flag`) VALUES 
 (117,17,'Finally, after hours of worrying about it, after her sister got home, she made them dinner, and was once again in bed, she managed to convince herself that the real problem was that the fantasy was new. New fantasies always had a strong hold on her until they got old and dull. And this one, she hadn\'t indulged at all, so _of course_ it was approaching obsessive proportions. What she needed to do was just... use it up. Explore it completely, every little nook and cranny, over and over again, until it lost its hold on her. Then she could smile at the girl, and be an understanding friend to come out to if she needed one, without all of the... tension. ',117,0),
 (118,17,'She went to it enthusiastically, with more than a bit of relief, reliving every little bit of the fantasy, lingering over her favorite parts, mentally exploring every inch of soft white skin, doing things that she would never do in real life, or even admit to wanting to do. Over and over again. ',118,0),
 (119,17,'She finally passed out, sore and aching, after half a dozen orgasms. ',119,0);
INSERT INTO `paragraphs` (`id`,`chapter_id`,`body`,`order`,`flag`) VALUES 
 (120,17,'Brynna sighed, turning away from Anna\'s sad gaze at school the next day. If anything, it was worse. Both the fixation, and the puppy-dog eyes... though she _knew_ she hadn\'t done anything to encourage the latter. It was just _there_. And Anna moved like she was hurting, too, like her headache was as bad as Brynna\'s, or like... someone had hit her? Could that be the reason behind the sorrowful gaze -- she was looking not for a girlfriend but a rescuer? Well hell, Bryn could do _that_! She straightened, flooded with relief, and started to turn and ask, just blurt it out, but she froze, confused again as she remembered the _real_ skin that she\'d seen had been totally unmarked. Not a bruise, or a cut, or even a visible scar. So it seemed unlikely, suddenly, that her father, or brother, or boyfriend was beating her. ',120,0),
 (121,17,'Brynna\'s shoulders drooped, and she sighed again, confusion filling her once more. ',121,0),
 (122,17,'The rest of the day went the same way, and after school, by some quirk of fate, she found herself alone with Anne in that same bathroom as the first day. The smaller girl looked like a deer trapped in the headlights, visibly shaking. ',122,0);
INSERT INTO `paragraphs` (`id`,`chapter_id`,`body`,`order`,`flag`) VALUES 
 (123,17,'Brynna\'s eyes widened in horrified realization. \"You\'re afraid of me!\" She didn\'t mean to actually say it, it just slipped out. \"Why?\" ',123,0),
 (124,17,'Anne shivered, then took a deep breath. \"What did I do, Mistress? Have I made you angry? I...\" Her hands fumbled at her shirt, lifting it up. \"I know you have to give me the rings, but I wanted to show you that I know I belong to you...\" She pulled her shirt off over her head. ',124,0),
 (125,17,'Vertically, through each nipple, was a large safety pin. ',125,0),
 (126,17,'The pins were _huge_. Diaper-pin-sized, not harmless little things meant to hold a strap in place. Brynna stared, horrified, and took a panicked step backwards, coming up against the sinks. \"What the _hell_?\" ',126,0),
 (127,17,'\"M-mistress?\" Anne said, trembling. \"I... I thought you w-wanted them p-pierced. You s-said you\'d b-been w-wondering how they\'d l-look...\" Her chin quivered, and a tear slipped down her cheek as she dropped to her knees. \"Don\'t you w-want me any m-more?\" ',127,0),
 (128,17,'\"Oh god,\" Brynna whispered, then closed her eyes. The possibilities ran desperately through her mind. Hallucinating? Maybe, no way to tell. Joke? No. Those pin were no fucking joke. Unless the nipples had already been pierced, and she just replaced normal jewelry? But how would she know what to say? No matter _what_, how would she know what to say? Her sister listening at doors and carrying tales, maybe? But that felt wrong, even if it was possible, which she was almost certain it wasn\'t. One little squeak, yeah... a running commentary? No way she would have done that out loud. So _what_ then? Some kind of weird telepathic connection? Or a hallucination. Had to be one or the other. ',128,0);
INSERT INTO `paragraphs` (`id`,`chapter_id`,`body`,`order`,`flag`) VALUES 
 (129,17,'\"M-mistress?\" Anne was still holding her shirt up over her head. \"P-please, just t-tell me what I did. I\'ll be g-good, I promise! I\'ll do whatever you want! If you want me to lick up the whole puddle next time, I will, I promise! Just don\'t be mad at me, please!\" ',129,0),
 (130,17,'Brynna couldn\'t prove it was a hallucination. She was familiar with that old exercise... you can\'t prove _anything_ is real, ever. She was also familiar with the standard bit of correlational advice: since you can\'t prove the reality of anything you observe, you must therefore deal with reality _as_ it is observed. But in this case... she sure as hell didn\'t want to! If she looked at it as real, though... then Anne had been hurt. Badly. By her. Intentional or not, she owed her. Brynna took a deep breath and reached out, gently tugging the girl\'s shirts from her hands, then urging her to her feet. \"C\'mon,\" she said softly. \"Get up now.\" ',130,0),
 (131,17,'Anne stood, obediently. \"Yes, Mistress.\" ',131,0);
INSERT INTO `paragraphs` (`id`,`chapter_id`,`body`,`order`,`flag`) VALUES 
 (132,17,'Brynna flinched. \"Don\'t. You don\'t have to do that. I... I don\'t know what happened. But I\'m going to fix it. I\'ll make it right. I promise.\" ',132,0),
 (133,17,'Anne looked at her. \"I... I don\'t understand, Mistress. Fix what?\" ',133,0),
 (134,17,'Brynna shuddered. \"Everything,\" she said fervently. \"But you\'ve gotta tell me... tell me what happened. What you think happened,\" she corrected. \"What you experience was.\" ',134,0),
 (135,17,'\"Oh.\" Anne\'s eyes widened. \"Oh! I think I understand.\" She looked at Brynna for a moment. \"Would you prefer it if I called you Brynna instead of Mistress?\" ',135,0),
 (136,17,'\"God yes!\" ',136,0),
 (137,17,'Anne smiled, turning her face from beautiful to... something more. \"Okay, Brynna. I think I understand the problem. You weren\'t mad at me at all, were you?\" ',137,0),
 (138,17,'\"_Mad_ at you?\" Brynna stared down at her, aghast. \"Of course I\'m not mad at you! Why the hell--\" She broke off, rubbing her forehead and closing her eyes. \"Look, honey,\" she said more gently, \"you\'re the victim here. One hundred percent. I didn\'t _mean_ to hurt you, and I don\'t have the slightest _clue_ how I did, but I did. Period. So I\'m going to fix it. And if I seem angry, it\'s sure a hell not at you!\" ',138,0),
 (139,17,'Anne nodded, somehow seeming far more composed than just moments before. \"I thought that\'s why you wouldn\'t talk to me, that I\'d somehow done something to make you angry. And of course I couldn\'t say anything to you.\" ',139,0);
INSERT INTO `paragraphs` (`id`,`chapter_id`,`body`,`order`,`flag`) VALUES 
 (140,17,'\"Why the hell not?\" Brynna demanded. ',140,0),
 (141,17,'Anne blinked. \"Because I\'m not allowed to talk to you unless you tell me to.\" ',141,0),
 (142,17,'\"WHAT?\" Brynna slapped a hand over her mouth, wanting to take back the angry explosion, then covered her eyes with it, groaning. \"Look. Just... forget that, okay? Or, um, try to. I know it\'s going to be hard, and I... I\'ll help as best I can. Maybe... maybe get you a therapist or something, I don\'t know yet, I just don\'t, but whatever it takes.\" She swallowed hard, her throat tightening up. \"Just please believe that I never meant to hurt you. And I\'m going to fix it. Whatever it takes.\" ',142,0),
 (143,17,'Anne looked at her for a moment before sighing. \"Brynna... _Mistress_... could we talk about this somewhere else? Please? I don\'t think you\'ve hurt me, but... this isn\'t really the place. I was willing, when I thought I was losing you, but...\" ',143,0),
 (144,17,'Brynna rubbed her forehead tiredly. \"Don\'t call me that. That can be your first step. You can\'t possibly regain your self-worth if you\'re deferring to your abuser,\" she said. \"And yes. We can go somewhere else. Where would you feel safe?\" ',144,0);
INSERT INTO `paragraphs` (`id`,`chapter_id`,`body`,`order`,`flag`) VALUES 
 (145,17,'\"Your house,\" she said promptly. \"And you aren\'t my abuser, you\'re my Mistress. My owner.\" ',145,0),
 (146,17,'\"_No_,\" Brynna said firmly. \"I know what went into making you feel that, but it\'s _not_ true. And I\'m going to make sure you recover from it. Whatever it takes, for however long it takes. It\'s all I can do.\" She sighed unhappily. \"But you\'re going to have to tell me what you know. So come on, let\'s get out of this place.\" ',146,0),
 (147,17,'\"Okay.\" She hesitated. \"Can I have my shirt back? I mean, I don\'t have to have it, but it\'d be kind of a... problem. I\'d probably get expelled.\" ',147,0),
 (148,17,'\"What do you mean you don\'t have to h--\" Brynna began, then snapped her mouth closed, breathing harshly, trying to get control of herself. \"Yes, I mean,\" she said, trying for calm but coming closer to tight. \"Of course you can have it. It\'s yours. Wearing it or not is your choice. No one else\'s. I\'m sorry. I should have given it back right away.\" ',148,0),
 (149,17,'Anne smiled again, taking the shirt. \"It\'s _okay_, Brynna. Look, I didn\'t understand it myself Monday night, but I think I\'ve got something of a grip on it by now.\" She pulled the shirt over her head, carefully. \"I... Brynna? Even if you aren\'t ready to give me the rings right now, could we stop by the mall so I could buy a pair of barbells? That\'d be a _lot_ more comfortable.\" ',149,0);
INSERT INTO `paragraphs` (`id`,`chapter_id`,`body`,`order`,`flag`) VALUES 
 (150,17,'Brynna gritted her teeth. \"How about we stop by the drugstore and get some antibiotic ointment and bandaids instead, and you can just take them out?\" ',150,0),
 (151,17,'\"Uh...\" Anne hesitated. \"If that\'s what you want. But... it\'d be _really_ hard to do them a third time. I almost couldn\'t do them last night. It was actually worse than the first time, because I knew what was coming. You\'d probably have to tie me down extremely well, because, well...\" She took a deep breath. \"I\'ve got a full fledged phobia of needles. I was really hoping that it would be better, but when I sat down to do them last night...\" She shook her head. \"So... I\'ll do what you want, of course, but I\'d prefer the barbells. Those can always be taken out later, if needed.\" ',151,0),
 (152,17,'Brynna leaned against the wall, her face pale and greenish tinted. \"Jesus...\" She closed her eyes, shuddering. \"Oh god. What did I do?\" she whispered. \"Honey... it\'s your body. _Yours_, got that. You can do or undo or not do whatever you want to it. Don\'t do _anything_ because of my sick little mind game. Only do what _you_ want.\" ',152,0),
 (153,17,'Anne rested one small hand on her cheek. \"It doesn\'t work that way. But I think you\'re making assumptions, okay? There\'s a whole lot you don\'t know. I don\'t think that what you\'re assuming is right.\" ',153,0);
INSERT INTO `paragraphs` (`id`,`chapter_id`,`body`,`order`,`flag`) VALUES 
 (154,17,'Brynna trembled, and carefully reached up and removed the little hand. \"Yes. It does. If you want to keep them, keep them. If you don\'t, don\'t. It doesn\'t matter what you think I want, because I would never even ask you to do something like that, ever again, much less force you to do it. Understand?\" she asked. \"I will not hurt you again.\" ',154,0),
 (155,17,'Anne looked her in the eye. \"Mistress, there is nothing I want more in the world right now than to have you replace these pins with rings, and claim me as your own forever.\" ',155,0),
 (156,17,'Brynna moaned, covering her face with her hands. \"This cannot be happening. There\'s no way. It\'s just a dream caused by guilt and stress. I just have to deal with it, follow it through, but I\'ll wake up eventually,\" she murmured, desperately, then straightened up, her eyes a touch wild. \"It\'s going to be okay. I\'m going to find out how to help you, and you\'re going to be fine. Until then, if you\'re more comfortable with bars in, then we can do that. It\'s not a problem. It\'s your choice.\" ',156,0),
 (157,18,'\"No,\" Anne said, a small smile on her face, \"it\'s not. It\'s your choice. But if your choice is to allow me to choose, then I will.\" ',1,0);
INSERT INTO `paragraphs` (`id`,`chapter_id`,`body`,`order`,`flag`) VALUES 
 (158,18,'Brynna groaned. \"Okay. As long as you\'re doing the choosing, that\'s what\'s important right now.\" ',2,0),
 (159,18,'\"Okay. Um. Are you old enough to drive?\" ',3,0),
 (160,18,'She shook her head. \"No. But we can catch the bus wherever we need to go.\" ',4,0),
 (161,18,'Anne hesitated. \"I guess we could, but... well, I\'d rather not waste that much time. I... we really need to talk. I think you need it more than _I_ do, and I need it pretty badly.\" She reached over and picked up her purse, pulling out a cell-phone, then stopped. \"Oh. Right. Can\'t use my phone on school property. We need to go across the street, I guess.\" ',5,0),
 (162,18,'Brynna still seemed pretty dazed. \"All right, that\'s fine. Whatever.\" ',6,0),
 (163,18,'Anne reached over and took her hand, the froze. \"Um... I\'m sorry. I didn\'t mean to be presumptuous. I just...\" ',7,0),
 (164,18,'Brynna squeezed her hand gently, then released it. \"If I can, I\'m not going to let you do anything that might hurt you until you\'re... better. Come on.\" ',8,0),
 (165,18,'\"Yes ma\'am,\" Anne whispered. ',9,0);
INSERT INTO `paragraphs` (`id`,`chapter_id`,`body`,`order`,`flag`) VALUES 
 (166,18,'Outside, across the street, Anne pulled out her phone and dialed. \"Angela Thurston. Outside Parker High School. To the mall,\" she said. \"Five minutes? Great!\" ',10,0),
 (167,18,'\"What was that?\" Brynna asked, once she\'d hung up. ',11,0),
 (168,18,'\"Getting us a ride, so that we don\'t have to change buses three times to get to the mall. And... I just realized I have no idea where you live. Will we need a ride from the mall, or is it within walking distance?\" Anne asked. ',12,0),
 (169,18,'Brynna shook her head. \"Not really. Getting a ride how?\" ',13,0),
 (170,18,'Anne smiled and waved one arm in the air as a cab turned the corner. \"Like that.\" ',14,0),
 (171,18,'Brynna frowned, mentally calculating the distance and the cash she\'d have left after paying for a set of barbells out of this month\'s lunch money. \"All right,\" she said reluctantly. \"This time.\" She opened the door of the cab and motioned Anne inside. ',15,0),
 (172,18,'The cab drive didn\'t take long -- it was much faster than taking the bus -- and when they pulled up to the mall, Anne pulled out a credit card and handed it to the driver before Brynna had a chance to react. ',16,0);
INSERT INTO `paragraphs` (`id`,`chapter_id`,`body`,`order`,`flag`) VALUES 
 (173,18,'\"I\'ll need to see ID, miss,\" the cabdriver said, apologetically. \"And... I\'m afraid I can\'t take it if it\'s your mother\'s card, or something like that.\" ',17,0),
 (174,18,'Brynna gritted her teeth. \"That\'s okay. I\'ve got cash, Anne.\" ',18,0),
 (175,18,'\"Oh, no, it\'s mine,\" Anne said. \"Mom got me one to use so that I wouldn\'t have to carry cash. Here.\" She dug around in her purse and handed him what looked like a drivers license with one hand waving the other at Brynna. \"Don\'t worry about it, Brynna. I never spend any of my allowance anyway.\" ',19,0),
 (176,18,'Brynna clenched her jaw and waited. Patience wasn\'t something she was good at. ',20,0),
 (177,18,'It only took the driver a minute to run the card, and then he handed it back to her. She signed the slip and gave it to him. \"We\'re probably going to be here half an hour or so, and we\'ll need a ride when we\'re done, if you\'re still in the area.\" ',21,0),
 (178,18,'The driver smiled at her. \"Actually, miss, I was about to take my dinner break. I was just going to hit McDonald\'s anyway, so why don\'t I eat in the food court, and you can find me when you\'re ready to leave? That way, I know I\'ve got a fare when I\'m done.\" ',22,0);
INSERT INTO `paragraphs` (`id`,`chapter_id`,`body`,`order`,`flag`) VALUES 
 (179,18,'Brynna\'s cheek twitched as she ground her teeth more, but she waited until they were out of the car to say anything. \"I told you,\" she said quietly, \"that I was going to take care of things. That means taking care of you, too, until I can make it right.\" ',23,0),
 (180,18,'Anne looked at her. \"I meant it,\" she said. \"I never spend any of my allowance. Well, on books, but that\'s not that much, and my parents pay for anything expensive, like a calculus book. Look, this is one of the things we need to talk about, okay? Just... don\'t worry about it right now. It was my idea to take the cab instead of the bus, so I\'m the one who should pay for it. And....\" She hesitated. \"And I want to pay for my own barbells. When you buy me jewelry, I want... I don\'t want you to do it because you feel guilty.\" ',24,0),
 (181,18,'Brynna\'s right eye ticked from the tension in her face. \"I did the damage. It\'s my responsibility to fix it, or at least minimize it.\" ',25,0),
 (182,18,'Anne stopped, turning to look at her. \"Brynna... please? I want... I want any jewelry I get from you to be... special.\" ',26,0);
INSERT INTO `paragraphs` (`id`,`chapter_id`,`body`,`order`,`flag`) VALUES 
 (183,18,'She sighed. \"All right. If it makes you feel better.\" ',27,0),
 (184,18,'Anne smiled at her, the expression once again transforming her from merely pretty to something more. \"Thank you.\" ',28,0),
 (185,18,'Brynna closed her eyes, blocking out the sight. \"Come on,\" she said quietly. \"Let\'s get this taken care of.\" ',29,0),
 (186,18,'Inside the mall, it took Anne only a few minutes to find all the stores that carried body jewelry. Her next step was a flying visit to each, to find out what they stocked, before returning to the two with the best selection, ruling out the ones that only carried stainless steel and not niobium. Finally, she\'d narrowed the selection down to four choices at one store, and looked at Brynna. \"Which ones do you think would look best on me?\" ',30,0),
 (187,18,'Brynna blinked, looking at the selection. Her eyes lingered for just a second on the set of gold colored bars with sparkling emerald green crystals as the end pieces, imagining how it would look. Then she flushed and looked guiltily away. \"Whatever you like. It\'s your choice. It\'s even your money.\" ',31,0),
 (188,18,'\"Yes, but you\'re the one who\'s going to be looking at them,\" Anne said. \"So I want the ones you think would look best.\" ',32,0);
INSERT INTO `paragraphs` (`id`,`chapter_id`,`body`,`order`,`flag`) VALUES 
 (189,18,'\"No. I\'m not. I told you I won\'t hurt you again. No one is going to see them except you... and anyone you want to, later, of course.\" ',33,0),
 (190,18,'Anne smiled. \"Like I said. You.\" ',34,0),
 (191,18,'Brynna clenched her jaw again. \"We\'ll talk about that later. But for now, it\'s just you.\" ',35,0),
 (192,18,'\"But which ones to you think would look best on me?\" ',36,0),
 (193,18,'Brynna wondered briefly if praying would do any good, but decided that she was probably not in God\'s favor at the moment, what with the whole torturous rape and brainwashing thing, so she didn\'t bother. \"Don\'t you have a favorite?\" ',37,0),
 (194,18,'\"I can\'t decide. I mean, I like all of these, but... I\'m not very good with makeup, or stuff like that, so I can\'t really tell what looks best,\" Anne said. \"The whole... what-colors-go-with-what-colors-thing... I don\'t get it.\" ',38,0),
 (195,18,'Thinking back, Brynna realized that the girl\'s wardrobe had always been rather monochrome, and simple. And she didn\'t wear make-up. She was too damned pretty even without it. She decided that a brief prayer wouldn\'t hurt, after all. The worst that would happen would be she\'d attract a lightning bolt, and that would really be an easy way out of this mess. \"They\'re all pretty,\" she said patiently. \"Nothing wrong with any of them, and your coloring goes will with anything except possibly white. So why don\'t you just pick your favorite?\" ',39,0),
 (196,18,'Anne blushed. ',40,0);
INSERT INTO `paragraphs` (`id`,`chapter_id`,`body`,`order`,`flag`) VALUES 
 (197,18,'The prayer? The prayer was for patience and willpower. There was no immediate effect, but no lightning bolt, either. \"All right,\" Brynna said, finally, when Anne seemed determined to make no response. \"The gold and green ones.\" ',41,0),
 (198,18,'Anne nodded, and handed them to the clerk. \"Thank you,\" she said softly, while the clerk rang them up. ',42,0),
 (199,18,'Brynna waited, then asked, \"Now, will you tell me why the question bothered you?\" ',43,0),
 (200,18,'Anne\'s blush intensified. \"I... um.\" She lowered her voice. \"Because... because I want to know you like them when I... you know.\" ',44,0),
 (201,18,'The image of Anne laying on a bed, naked, bars glinting in her little nipples as she touched herself and moaned invaded Brynna\'s mind and refused to leave. She closed her eyes and groaned, fighting with herself. \"Look, honey, you... I... you can\'t keep... _Fuck_.\" She rubbed her forehead with a trembling hand. ',45,0),
 (202,18,'Anne dropped her voice further, quiet enough that Brynna had to strain to hear it, face bright red, glancing at the clerk nervously. \"I\'ve... I\'ve done it every night this week, thinking about... about serving you. About being on my knees in front of you, with your hands in my hair....\" ',46,0);
INSERT INTO `paragraphs` (`id`,`chapter_id`,`body`,`order`,`flag`) VALUES 
 (203,18,'Sweat broke out on Brynna\'s brow, and she swallowed hard. \"God help me,\" she whispered. \"Seriously. _Please_.\" Then, out loud, \"Honey, stop. Please. You\'re killing me here, okay? I\'m going to do what\'s right, but I\'m only human.\" ',47,0),
 (204,18,'Anne looked up at Brynna, the blush fading, a look of... something, not trust, exactly, not awe, not worship, but combining all of those things. \"I know you will,\" she said, softly. \"And I\'m looking forward to being on my knees in front of you for the first time for real.\" She held Brynna\'s gaze for a moment longer, then turned to sign the credit card slip. ',48,0),
 (205,18,'Brynna leaned against the wall, eyes clenched shut, wondering if chemical castration worked for female rapists, and if so, how hard it would be to get ahold of the drugs. ',49,0),
 (206,18,'They easily found the cab driver in the food court, and fifteen minutes later walked in Brynna\'s front door, to be greeted by her little sister. ',50,0),
 (207,18,'\"Where\'ve you been? I got here and you weren\'t home!\" Siobhan said, then stopped, looking at Anne. \"Anne? I thought you moved.\" ',51,0);
INSERT INTO `paragraphs` (`id`,`chapter_id`,`body`,`order`,`flag`) VALUES 
 (208,18,'\"Uh, no,\" Anne said, blushing. ',52,0),
 (209,18,'Brynna muttered, \"_Shit_.\" She sighed. \"Sorry kiddo. I should have left you a message. I got... distracted.\" She smiled weakly. \"So you two know each other?\" ',53,0),
 (210,18,'\"Um, yeah,\" Siobhan said. \"She was in my class for the last couple of months last year. But I haven\'t seen her this year, so I thought she\'d moved away or something.\" ',54,0),
 (211,18,'Brynna went deathly pale. \"Oh _fuck_ no you\'ve gotta be kidding me!\" ',55,0),
 (212,18,'Anne gave her a weak smile, and sighed. \"That\'s... one of the things I needed to talk to you about. Look. Can we sit down, and I\'ll explain?\" ',56,0),
 (213,18,'\"Explain what?\" Siobhan asked. ',57,0),
 (214,18,'\"Nothing!\" Brynna snapped. \"I mean... don\'t you have homework?\" ',58,0),
 (215,18,'\"It\'s Friday. I can do it tomorrow,\" Siobhan said, her gaze swinging from Brynna to Anne and back again. \"What\'s going on here?\" ',59,0),
 (216,18,'\"I can explain,\" Anne said, in a very small voice. \"At least part of it.\" ',60,0);
INSERT INTO `paragraphs` (`id`,`chapter_id`,`body`,`order`,`flag`) VALUES 
 (217,18,'\"Nothing that\'s any of your business,\" Brynna said firmly. \"And nothing that\'s... not going to be taken care of. One way or another. Tell you what... how about I give you $10 and you run down to the Starbucks, read, and have a couple of mocha\'s? We\'ll talk later, okay? I\'ve got a serious headache and shit I _need_ to get done, like, _right now_.\" ',61,0),
 (218,18,'Anne looked up at Brynna. \"It\'s okay, Mistress,\" she said. \"I don\'t mind her knowing.\" ',62,0),
 (219,18,'Brynna clenched her jaw and said through gritted teeth, as Siobhan stared at them in slack-jawed shock, \"Well, gee, that\'s great, but maybe I do, huh?\" ',63,0),
 (220,18,'Anne\'s face went dead white. \"Oh god,\" she said in a strangled whisper. \"I\'m sorry, oh god. I didn\'t think... I\'m sorry, please don\'t be mad at me, please, I\'ll be good...\" ',64,0),
 (221,18,'\"Oh god,\" Brynna whispered, her face ashen with horror as she reached for the girl, instinctively pulling her close. \"God. Don\'t be afraid, honey, please don\'t,\" she said, her voice choked. \"I\'m not going to hurt you, I promise, I swear it. I won\'t hurt you ever again, you don\'t have to be afraid.\" ',65,0),
 (222,18,'\"What\'s going _on_ here?\" Siobhan asked, as Anne clung to Brynna desperately. \"What do you mean you aren\'t going to hurt her again? And why did she call you \'Mistress\'?\" ',66,0);
INSERT INTO `paragraphs` (`id`,`chapter_id`,`body`,`order`,`flag`) VALUES 
 (223,18,'\"Something... happened,\" Brynna choked out. \"Something horrible. I don\'t know how, I don\'t understand any of it, yet. But she was hurt bad, and it\'s my fault, and I\'m going to fix it. But right now, I need some privacy so that I can try to figure out _what_ happened, okay?',67,0),
 (224,18,'Anne pulled back. \"No,\" she said firmly. \"It _wasn\'t_ horrible. That\'s what you don\'t understand.\" ',68,0),
 (225,18,'\"Shhhh...\" Brynna pulled her back, unconsciously stroking her hair. \"You\'re not in a position to understand that right now. Not after... everything. You couldn\'t be, no one could. That\'s why I\'m going to take care of you. It\'s going to be okay.\" ',69,0),
 (226,18,'Anne pulled back again, looking up into Brynna\'s eyes. \"It already _is_ okay. That\'s what I\'m telling you. But you don\'t understand, because I haven\'t had a chance to explain yet.\" ',70,0),
 (227,18,'\"Um... Anne?\" Siobhan said hesitantly. \"Um... you\'re... um... bleeding. On your shirt.\" ',71,0),
 (228,18,'\"FUCK!\" Brynna pushed her back, looking down at her, horrified. \"Shit shit shit... how bad are you hurt?\" ',72,0);
INSERT INTO `paragraphs` (`id`,`chapter_id`,`body`,`order`,`flag`) VALUES 
 (229,18,'Anne looked down at the quarter-sized splotches of red on her white shirt and winced. \"Ow! Um. Not bad, I don\'t think. I didn\'t notice it till I looked at it, any way.\" She looked back up at Brynna apologetically. \"I must have twisted the pins when I grabbed on to you or something. I\'m sorry.\" ',73,0),
 (230,18,'\"Um... pins?\" Siobhan asked. ',74,0),
 (231,18,'\"_You\'re_ sorry?\" Brynna shook her head, her eyes glassy with tears. \"God... honey, go... go on to the bathroom and... and take care of yourself. I\'ll find you something to wear. Just be careful. Don\'t hurt yourself more.\" ',75,0),
 (232,18,'Anne bit her lip, looking up at her. ',76,0),
 (233,18,'\"What\'s wrong?\" Brynna asked. \"It\'s going to be okay, honey. You\'re going to be fine.\" Her voice held an edge of desperation. ',77,0),
 (234,18,'\"I....\" Her voice was small. \"I was kind of hoping maybe... maybe I could get you to do it?\" ',78,0),
 (235,18,'\"_What_?\" Brynna stared at her. \"Why the hell would you want that?\" ',79,0);
INSERT INTO `paragraphs` (`id`,`chapter_id`,`body`,`order`,`flag`) VALUES 
 (236,18,'\"Because I\'m yours,\" she said softly. ',80,0),
 (237,18,'Brynna moaned and shook her head in mute denial. \"_No_. You\'re not _property_. I\'m not going to hurt you more. I\'m not going to _touch_ you. You\'re not in any state to consent to anything right now... if at _all_, I mean, how old are you, anyway?\" ',81,0),
 (238,18,'Anne looked up at her. \"I\'m twelve. _Please_, Mistress?\" ',82,0),
 (239,18,'\"Oh god. Oh _fuck_ me. Shit shit shit...\" Brynna leaned back against the wall. \"I... can\'t deal with this. I shouldn\'t be dealing with this. I don\'t know _how_ to. It\'s just going to make things worse. I... need to call the police. Vahna, get the phone.\" ',83,0),
 (240,18,'\"The police?\" Siobhan asked, as Anne crumpled to the floor, crying. \"Why do you need to call the police? What\'s going _on_?\" ',84,0),
 (241,18,'Brynna says, \"_Fuck_.\" Brynna knelt down and gathered the girl up in her arms. \"Shh... shhh, honey. I\'m sorry. God, I\'m so sorry. But I can\'t do this, I can\'t give you the help you need, and... and I\'m dangerous. I need to turn myself in. You\'re not safe with me running loose.\"\" ',85,0),
 (242,18,'Anne wrapped her arms around Brynna\'s neck. \"No! No! You don\'t understand!\" ',86,0);
INSERT INTO `paragraphs` (`id`,`chapter_id`,`body`,`order`,`flag`) VALUES 
 (243,18,'\"Yes, I do,\" she said calmly. \"You\'re just saying what I... what I _programmed_ you to say. You\'ve been hurt too much to say anything else. I know you think these feelings are real, but it\'s brainwashing, pure and simple, and you can... can recover from it. But not with me loose. You\'ll never feel safe with me loose. God, you\'re so young...\" ',87,0),
 (244,18,'Anne grabbed ahold of Brynna\'s head with both hands and kissed her, hard, forcing her tongue into her mouth. ',88,0),
 (245,18,'Siobhan stared. \"What the _hell_?\" ',89,0),
 (246,18,'Brynna pulled carefully away, gently prying Anne\'s hands off of her. \"You\'ve been hurt,\" she repeated, firmly. \"You need help. Not more abuse. Vahna, the phone, please.\" ',90,0),
 (247,18,'\"No,\" Anne said, taking a deep breath. \"Not until you let me _explain_. Please.\" ',91,0),
 (248,18,'Brynna closed her eyes and sighed. \"You can explain, if it makes you feel better. But you\'re not going to change my mind. I\'m going to turn myself in, and confess everything, and then they\'ll know what sort of help you need and can find it for you.\" ',92,0),
 (249,18,'\"Explain what? That you\'re either a telepath or a witch? They won\'t believe you,\" Anne said. \"Look. I\'ve had a _lot_ of time to think about this, okay? Would you please talk to me before you decide you\'re a horrible person?\" ',93,0);
INSERT INTO `paragraphs` (`id`,`chapter_id`,`body`,`order`,`flag`) VALUES 
 (250,18,'Siobhan was standing motionless in the middle of the room. \"I don\'t understand _any_ of this,\" she said plaintively. ',94,0),
 (251,18,'\"I\'ll just tell them what, subjectively happened, without telling them how. It doesn\'t _matter_ how it happened,\" Brynna said. \"It just did. They\'ll still arrest me. They\'ll still take care of you. They don\'t have to look for evidence when I\'m _confessing_ to the crime.\" ',95,0),
 (252,18,'\"I\'ll tell them you _didn\'t_ do it. That I was just trying to attract your attention.\" ',96,0),
 (253,18,'\"They won\'t believe you after I tell them about the conditioning. They\'ll understand why you\'d think you had to protect me,\" Brynna said. \"So if you do, then that\'ll just serve to really convince them of how much you need help.\" ',97,0),
 (254,18,'Anne smiled at her. \"When would you have had a chance to condition me? I can prove we\'ve never been together for more than a little bit at a time before now.\" ',98,0),
 (255,18,'\"Damn it!\" Brynna grabbed her shoulders, giving her a little shake. \"This is for _your_ good, don\'t you get it? Stop fighting me!\" ',99,0);
INSERT INTO `paragraphs` (`id`,`chapter_id`,`body`,`order`,`flag`) VALUES 
 (256,18,'Anne slumped. \"Yes, Mistress. But I believe you\'re wrong.\" ',100,0),
 (257,18,'\"I\'m _not_ wrong. I\'ve studied these things. I don\'t know how it happened, but I _do_ know the sorts of problems it can cause, and you\'re exhibiting them _all_, textbook perfect.\" ',101,0),
 (258,18,'\"Mistress, would you let me explain?\" Anne asked. \"Would you please, please listen with an open mind, and actually think about it?\" ',102,0),
 (259,18,'\"I said you can explain. But I can\'t conceive of anything that would change my mind,\" Brynna said. ',103,0),
 (260,18,'\"Can we... Can we sit down? And... please. Especially if you don\'t think you\'re going to change your mind could you... could you do them? So that at least I have that to remember?\" ',104,0),
 (261,18,'\"Honey... Once you\'re well, you won\'t _want_ to remember anything to do with me,\" Brynna said gently. ',105,0),
 (262,18,'Anne looked at her steadily. \"Yes. I will.\" ',106,0),
 (263,18,'Brynna groaned. \"All right. But only because I know about piercings and can maybe do it without hurting you. And then you can say what you need to say before I call the police.\" ',107,0);
INSERT INTO `paragraphs` (`id`,`chapter_id`,`body`,`order`,`flag`) VALUES 
 (264,18,'Siobhan just watched them, looking from one face to the other uncertainly. ',108,0),
 (265,18,'\"Okay.\" Anne stood, moving away from Brynna slightly, and pulled her shirt off over her head without hesitating. \"They\'re in the bag over there.\" ',109,0),
 (266,18,'Siobhan gasped, turning pale, and crossed her arms over her chest. \"Oh my god!\" ',110,0),
 (267,18,'Brynna winced. \"Sis... I need you to go down to the bookstore or something until it\'s time for Mom to get home. I don\'t want you to be here when the police get here, and Anne and I need to talk. A lot. Go ahead and take all the money from my bag and get whatever you want... I won\'t be needing it. Please trust me, and do this for me.\" ',111,0),
 (268,18,'Siobhan looked at Anne\'s nipples, and at Brynna, and at Anne, and then straightened and walked over to her sister. \"No,\" she said, taking one of Brynna\'s hands between her own. \"I\'m not running out on you. You\'re my _sister_. I don\'t understand what\'s going on here, but I\'m not running out on you.\" ',112,0),
 (269,18,'Brynna squeezed her hand. \"It\'s not running out on me. It\'s taking steps to be here when Mom gets home so it\'s not explained to her by a cold, rude call from some bored cop. Or... in the paper,\" she added grimly. \"Don\'t worry about me. I\'m going to be fine. They\'ll probably lock me up with the crazies, not in the normal max security setup.\" ',113,0);
INSERT INTO `paragraphs` (`id`,`chapter_id`,`body`,`order`,`flag`) VALUES 
 (270,18,'Siobhan shook her head. \"No. Not till I know what\'s going on.\" ',114,0),
 (271,18,'\"Once I know, I\'ll tell you, okay? But I don\'t know yet, and... I can\'t talk about it with you here. I know that\'s not fair, but it\'s true.\" ',115,0),
 (272,18,'Siobhan set her jaw. \"No. It\'s about sex, isn\'t it?\" ',116,0),
 (273,18,'\"No!\" Brynna snapped. \"It\'s about _rape_, which isn\'t even vaguely the same thing. Now _get_.\" ',117,0),
 (274,18,'\"No, it _isn\'t_,\" Anne said. \"You just _think_ it\'s about rape because you haven\'t _listened_ to me yet!\" ',118,0),
 (275,18,'Brynna ground her teeth together. \"You\'re _twelve_. It\'s rape.\" ',119,0),
 (276,18,'\"No, it isn\'t,\" Anne said calmly. \"You\'ve never even _touched_ me sexually.\" ',120,0),
 (277,18,'\"As is frequently pointed out, rape isn\'t a crime of sex, it\'s a crime of violence, and it\'s 99% mental, anyway. Physical brutality is just the icing on the cake.\" ',121,0),
 (278,18,'Anne rolled her eyes. \"Well, you\'ve never touched me like _that_, either. Look.\" She sat down on the couch. \"Why don\'t I explain, okay?\" ',122,0);
INSERT INTO `paragraphs` (`id`,`chapter_id`,`body`,`order`,`flag`) VALUES 
 (279,18,'\"Not until you\'re taken care of and dressed again, and we\'re alone,\" Brynna said. ',123,0),
 (280,18,'\"No,\" Siobhan said. \"You aren\'t shutting me out again. I\'m not going anywhere.\" ',124,0),
 (281,18,'Brynna growled, clenching her fists. \"_Look_. Could both of you please stop arguing with me? Please? This has definitely been the worst week of my life, and I\'m trying to take care of things, and I just need you to work with me here! Please!\" Her voice rose a bit with each word, and by the end she was practically yelling. ',125,0),
 (282,18,'Anne dropped her eyes to the floor, but Siobhan remained defiant. \"No! You already did it once, you aren\'t doing it again!\" ',126,0),
 (283,18,'\"What? What the hell are you talking about? Look honey, you _know_ I trust you,\" Brynna said. \"If there were anything you could do, I\'d let you help, but there isn\'t. And this is not only private, it\'s something that I am deeply ashamed of, and I flat out can\'t discuss it with an audience. Period. So I need you to help me by giving me some privacy, and by being there for Mom, because this is going to be hard enough on her, and if she got here and not only was I locked up but they\'d taken _you_ into protective custody... I don\'t even know what she\'d do, understand? It\'d be too much for her. I need you to take care of her, okay?\" ',127,0),
 (284,18,'\"After the bath last year! You wouldn\'t hardly _talk_ to me for a month, and you keep acting like I have the plague or something if I\'m not dressed up like a nun!\" ',128,0);
INSERT INTO `paragraphs` (`id`,`chapter_id`,`body`,`order`,`flag`) VALUES 
 (285,18,'Brynna groaned, burying her face in her hands. \"Sweetheart, I... that shouldn\'t have happened. And it was my fault, not yours. And I\'m sorry, but I need you to not talk about it, because if they find out, they\'ll take you away from her because she \'allowed\' it to happen. But what I did to Anne was much worse, and I promise they\'ll lock me away even without your charges. They won\'t need them, but Mom _will_ need you when it comes out that I\'m a pervert and a pedophile.\" ',129,0),
 (286,18,'Siobhan stared at her for a moment, puzzled. \"Charges? What are you talking about? What do you mean it was your fault?\" ',130,0),
 (287,18,'\"It was obviously a... a sign. I should have paid more attention, maybe seen a psychiatrist, something, then none of this would have happened,\" Brynna said miserably. \"I\'m so sorry. There\'s obviously something _wrong_ with me. Sick. Broken. Disgusting. I\'m not safe to be around little girls.\" ',131,0),
 (288,18,'\"Wait,\" Siobhan said slowly. \"You think... you think you did something wrong? Took advantage of me?\" ',132,0);
INSERT INTO `paragraphs` (`id`,`chapter_id`,`body`,`order`,`flag`) VALUES 
 (289,18,'\"Of course,\" Brynna said. \"Look, honey... I\'m sorry. If it wasn\'t for Mom, I\'d say go ahead and tell anyone you want, but... it\'s got worse, and I _have_ to go away, and she needs you. I\'ll find some way to make it up to you, someday, just do this one thing for me now, please.\" ',133,0),
 (290,18,'Siobhan pulled back her arm without warning, her face expressionless, and slapped Brynna as hard as she could. Brynna didn\'t move, just nodded. \"That\'s fine. I deserved that. But it doesn\'t change anything. I need you to be _here_, not in protective custody. And I need time alone to fix what I messed up.\" ',134,0),
 (291,18,'\"How dare you!\" Siobhan said, glaring at her. \"What? Do you think I\'m _stupid_? Do you think I don\'t know what sexual abuse is? Of course I fucking do! If I\'d objected, I\'d have broken your fucking _fingers_! I _liked_ it! God _damn_ you, you fucking _bitch_! I\'ve spent the last fucking _year_ wondering what the hell I did, if maybe I acted like to much of a fucking _slut_, and it\'s all because you think I\'m some sort of fucking _baby_ who can\'t fucking say no? Fuck YOU!\" ',135,0),
 (292,18,'Brynna gritted her teeth again. \"I know you didn\'t object. That doesn\'t make it okay, and I knew that, but the fact that it was at least _consensual_ was a great comfort until this week. I thought maybe it was just a... a normal developmental phase. Nothing to be upset about. I didn\'t recognize it as part of a dangerous pattern, and that was a big fucking mistake.\" ',136,0);
INSERT INTO `paragraphs` (`id`,`chapter_id`,`body`,`order`,`flag`) VALUES 
 (293,18,'Siobhan set her hands on her hips. \"God _damn_ you! Who the fuck gave you the right to ignore what I _wanted_, huh? Damn you, you made me come better than I\'ve _ever_ managed on my own, and I wanted to do it _again_! I still do! If you don\'t want to, fine, but if you\'re going to get up on some fucking holier-than-thou you-didn\'t-have-a-right-to-say-yes fucking martyrdom fucking _hobby horse_ I\'m gonna fucking kick your _ass_!\" ',137,0),
 (294,18,'\"Vahna. Shut _up_, will you? You have a right to say whatever you want. _I_ was in a position of authority and so had _no_ right to take you up on it, no matter what. In fact, I had a responsibility _not_ to, and I blew it. But it wouldn\'t be... well, it\'d still be _wrong_, but it wouldn\'t be that big of a wrong, I thought, since you weren\'t hurt, but because I thought that, now someone else _has_ been hurt. Badly hurt. So much so that I\'m scared to death that they won\'t be _able_ to help her. Do you understand?\" ',138,0),
 (295,18,'\"No. I don\'t. Because it _wasn\'t_ wrong, okay? And if you\'re wrong about what we did being wrong, then maybe you\'re wrong about what you did with _her_ being wrong too, because you haven\'t even fucking let her _explain_, you just keep telling her it\'s wrong for her to feel that way, and FUCK YOU!\" Siobhan\'s voice increased in volume with every word, and by the time she finished she was yelling at the top of her lungs. ',139,0);
INSERT INTO `paragraphs` (`id`,`chapter_id`,`body`,`order`,`flag`) VALUES 
 (296,18,'Anne said, her voice just loud enough to be heard, \"I was diagnosed with leukemia when I was four.\" ',140,0),
 (297,18,'Brynna turned to stare at her, stunned. \"W-what?\" ',141,0),
 (298,18,'Siobhan froze, looking at Anne, as the topless girl repeated, \"I was diagnosed with leukemia when I was four. It\'s been gone for three years now, but I\'m not considered \'cured\' until it\'s been five years. Right now I\'m just in remission.\" She looked up at Brynna. \"Will you sit down and let me explain now?\" ',142,0),
 (299,18,'Brynna collapsed where she stood, folding down into the floor and then hunching over her crossed ankles, moaning. \"Oh god. Go... go ahead.\" ',143,0),
 (300,18,'Siobhan sat down next to her sister, instinctively groping for her hand, grasping it tightly. \"P-- Please,\" she said, stumbling. ',144,0),
 (301,18,'\"I was diagnosed when I was four. I\'d been sick constantly for a couple of months, so the doctor did a test, and... that\'s what came back. I was in and out of the hospital for five years. I spent two years straight in the hospital when I was seven and eight. I...\" Anne swallowed. \"I almost didn\'t come out. Several times. There were... lots of tests. Blood samples, tissue samples, bone marrow samples...\" She shuddered. \"Do you know how they take bone marrow samples?\" ',145,0),
 (302,18,'\"Yes,\" Brynna said tightly. ',146,0);
INSERT INTO `paragraphs` (`id`,`chapter_id`,`body`,`order`,`flag`) VALUES 
 (303,18,'\"They use a needle,\" Anne continued, as if she hadn\'t heard. \"A big one. Several inches long, and about this thick.\" She held up her fingers, a quarter inch apart. \"I was on lots of pain drugs. Even with those, it hurt.\" She swallowed. \"That\'s why... that\'s why I\'m so afraid of needles.\" ',147,0),
 (304,18,'Siobhan\'s eyes were riveted on Anne\'s breasts. \"Oh my god,\" she whispered. ',148,0),
 (305,18,'Brynna closed her eyes. ',149,0),
 (306,18,'Anne nodded absently. \"When I was nine, they said the leukemia was gone. But there was a problem. My immune system was... messed up. And there were other problems, things they\'d noticed when I was in the hospital that last year. Did either of you watch Firefly when it was on?\" ',150,0),
 (307,18,'Brynna shook her head. \"We don\'t really watch television,\" she whispered, apologetically. ',151,0),
 (308,18,'\"In the pilot episode, there\'s this doctor. He\'s explaining to the crew of the ship about his sister. He tells them,\" She closed her eyes, as if remembering, \"\'I am very smart. I went to the best Medical Centre in Osirus - top 3% of my class. I finished my internship in eight months. _Gifted_ is the term. So when I tell you that my sister makes me look like an idiot child, I want you to understand my full meaning. River was more than gifted........ she was a gift.\'\" She opened her eyes, looking at Brynna. \"I\'m River, only without the weird experiments driving me crazy. My IQ is well over two hundred. They don\'t honestly know what it is; it\'s too high for them to measure. I read calculus books for fun. I can calculate tensor equations in my head. I don\'t sleep. An hour or two a night, maybe, if I\'m bored. I haven\'t for years. According to the doctors, I should have been both dead and incurably insane years ago. And my leukemia could come back at any time.\" ',152,0),
 (309,18,'\"Okay,\" Brynna said carefully. \"I understand that that could make you more mature than any normal 12 year old. If my _only_ problem were your age, I would have to rethink things. But it\'s also pretty certain to have made you way, way more vulnerable, emotionally and psychologically. Just as they suggested.\" ',153,0);
INSERT INTO `paragraphs` (`id`,`chapter_id`,`body`,`order`,`flag`) VALUES 
 (310,18,'Anne doesn\'t look away from Brynna. \"I could live to be eighty or ninety. Or I could be dead six months from now.\" She bit her lip. \"I\'ve had a laptop for several years. I could take it into the hospital a lot easier than a bunch of books. So I\'ve done a lot of reading.\" She ducked her head, then raised it back, though the effort it took was visible. \"I learned about masturbating when I was eight.\" ',154,0),
 (311,18,'Brynna nodded. \"That\'s understandable. You were stuck in bed.\" ',155,0),
 (312,18,'\"Do you know when I had my first orgasm?\" ',156,0),
 (313,18,'\"That\'s not any of our business,\" Brynna said. ',157,0),
 (314,18,'\"Monday night. When you made me come.\" ',158,0),
 (315,18,'Siobhan gasped, then frowned. \"Wait. She was _home_ Monday night.\" ',159,0),
 (316,18,'Brynna closed her eyes. \"I\'m sorry. That\'s not the way anyone\'s first time should ever be. I didn\'t _know_. I never would have let myself think those things if I\'d know you were... were feeling it, that it was real to you.\" ',160,0),
 (317,18,'\"Then thank god you didn\'t,\" Anne said simply. ',161,0);
INSERT INTO `paragraphs` (`id`,`chapter_id`,`body`,`order`,`flag`) VALUES 
 (318,18,'\"_No_.\" Brynna shook her head. \"You don\'t understand. That should not have happened. It was supposed to be a fantasy, not _real_. I never wanted to _really_ hurt you, really force you and break you. The idea of anyone doing that, for real is... is sickening. It\'s just so damned wrong. People who do it deserve no mercy. None.\" ',162,0),
 (319,18,'\"_Brynna_,\" Anne said, leaning forward. \"I had _never_ come. In four years of trying. I kept getting close, enough to know that it would be really good, but I. Never. Came. Until Monday. If that hadn\'t happened, it\'s completely possible that I would _never_ have come. Because I might be dead six months from now.\" ',163,0),
 (320,18,'\"No! You\'ve already beat the odds. It\'s in remission. And... and it doesn\'t matter. The _orgasm_ isn\'t the problem. It\'s the rest of it that\'s... totally unacceptable. Sick. Depraved. You should have had the chance to find someone who would treat you _right_ for your first time. Someone who would have been gentle, and caring, not... not...\" Brynna\'s voice choked off, and she just shook her head. ',164,0),
 (321,18,'\"Someone who would have just made me come instead of possessing _all_ of me, body, mind, and soul? Someone who wouldn\'t have touched every part of me? Someone who wouldn\'t have made me _understand_ what I wanted, what I needed, deep down inside, so that there would have still been a part of me unfulfilled, instead of someone who gave me what I _needed_, someone who left me completely fulfilled?\" ',165,0);
INSERT INTO `paragraphs` (`id`,`chapter_id`,`body`,`order`,`flag`) VALUES 
 (322,18,'Brynna drew her knees up to her chest and hid her face against them. \"No. That\'s what you were _made_ to think. Torture will break anyone. You didn\'t deserve that. You didn\'t deserve to be forced. Abused. Tortured. And now you feel like you need it, and that\'s _my fault_ and I don\'t know how to fix it and after you\'ve been through so much it\'s just fucking not fair!\" ',166,0),
 (323,18,'Anne sighed, standing up. \"I think there\'s something I need to show you.\" ',167,0),
 (324,18,'Brynna shook her head mutely. ',168,0),
 (325,18,'Anne nodded. \"Where\'s your bathroom?\" ',169,0),
 (326,18,'Brynna sighed, and pointed the way. ',170,0),
 (327,18,'Anne took several steps, then stopped, turning back. \"Come on, I need to show you.\" ',171,0),
 (328,18,'Brynna stared at her for a few seconds more, then nodded reluctantly and climbed to her feet to follow. ',172,0),
 (329,18,'Anne walked into the bathroom, then turned to face Brynna. \"It wasn\'t ever _easy_ for me. I tried it the first time out of curiosity, and if I hadn\'t been so bored and stubborn, that probably would have been it.\" She unzipped her skirt, letting it fall to the floor, revealing the fact that she hadn\'t worn panties. She was nude, except for her socks and shoes. \"But the story made it sound like there was something great, and I got close enough that I could tell that there was something, something I couldn\'t quite reach.\" ',173,0),
 (330,18,'Her stripping brought Brynna out of her daze. \"Honey, stop. What are you doing?\" ',174,0);
INSERT INTO `paragraphs` (`id`,`chapter_id`,`body`,`order`,`flag`) VALUES 
 (331,18,'\"Showing you something.\" She kicked off her shoes and bent over, pulling her socks off. \"I never got very... you know. Wet. Not easily.\" ',175,0),
 (332,18,'Brynna groaned. \"Anna, please stop. You don\'t need to show me anything.\" ',176,0),
 (333,18,'\"I do. Please, Mistress.\" ',177,0),
 (334,18,'Brynna flinched. \"All right,\" she whispered. ',178,0),
 (335,18,'Anne turned around and bent at the waist, revealing her nearly-bare cunt, before stepping into the tub and turning back to face Brynna. \"You made me do things I never thought I\'d do. Things I didn\'t even know _existed_.\" ',179,0),
 (336,18,'Brynna groaned again. \"Oh god, please... H-honey, you _shouldn\'t_ have know they existed. They\'re not... not normal things. Not things that... Most people aren\'t like me. Most people wouldn\'t have hurt you.\" She shuddered. \"Normal people don\'t get off on pretty little girls crying,\" she said hoarsely. ',180,0),
 (337,18,'Anne took a deep breath, and then began pissing in the tub, never looking away from Brynna. \"I _liked_ them. No. That\'s not right. I _didn\'t_ like them. But I liked being made to do them. I liked knowing I was pleasing you. Do you know when I had my _second_ orgasm?\" ',181,0);
INSERT INTO `paragraphs` (`id`,`chapter_id`,`body`,`order`,`flag`) VALUES 
 (338,18,'Brynna fell to her knees, wrapping her arms tight around her chest and rocking back and forth, shaking. \"Please...\" ',182,0),
 (339,18,'\"The... dream, or vision, or whatever it was ended with me licking a couple of drops of piss off of your foot. then I woke up.\" Anne leaned forward, grabbing the toilet paper, and wiped. \"And then I shoved my hand between my legs, and, for the first time in my life, I made myself come. And I\'ve done it every night since.\" She threw away the paper and took some more, wiping and then holding it out. \"See? Dry.\" ',183,0),
 (340,18,'\"Anne...\" Brynna\'s voice was thick, husky. Pleading, almost, but with an edge of warning, too. \"Don\'t do this.\" ',184,0),
 (341,18,'Anne looked at her. \"Please. You won\'t understand until I show you.\" ',185,0),
 (342,18,'\"You don\'t understand. You don\'t know what you\'re doing to me. This is dangerous.\" ',186,0),
 (343,18,'\"I understand.\" Anne didn\'t look away. \"But you don\'t. Not yet. Let me show you? Please?\" ',187,0),
 (344,18,'\"Show me what?\" Brynna asked, forcing the words through her tight throat. ',188,0);
INSERT INTO `paragraphs` (`id`,`chapter_id`,`body`,`order`,`flag`) VALUES 
 (345,18,'Anne knelt, gracefully, leaning forward. \"This.\" She began to lap at the piss in the bottom of the tub. ',189,0),
 (346,18,'Brynna groaned, a heartfelt, tortured sound, and slid forward. She reached into the tub and wrapped her hand in the girl\'s hair, dragging her head up. She stared down at her, hand twisting unconsciously, wrapping the soft hair around her fingers. \"You have to stop this,\" she whispered shakily. \"You\'re going to get hurt.\" ',190,0),
 (347,18,'Anne slipped two fingers between her legs, then brought them up, shining and wet. \"I\'m soaking. I\'m soaking wet, just from this.\" ',191,0);
/*!40000 ALTER TABLE `paragraphs` ENABLE KEYS */;


--
-- Table structure for table `pelestats`.`pcomments`
--

DROP TABLE IF EXISTS `pcomments`;
CREATE TABLE `pcomments` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `paragraph_id` int(10) unsigned NOT NULL default '0',
  `body` text NOT NULL,
  `posted` datetime NOT NULL default '0000-00-00 00:00:00',
  `username` varchar(45) NOT NULL default 'no user',
  `flag` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `pelestats`.`pcomments`
--

/*!40000 ALTER TABLE `pcomments` DISABLE KEYS */;
INSERT INTO `pcomments` (`id`,`paragraph_id`,`body`,`posted`,`username`,`flag`) VALUES 
 (1,4,'Short sentences are fun.','2006-04-17 21:39:00','Victor',0),
 (2,2,'When masturbation doesn\'t work, you have serious problems.','2006-04-17 21:29:00','Nonny',0),
 (3,4,'You really like short, uninformative comments, don\'t you?','2006-04-17 21:43:00','Velvet',0),
 (4,7,'Anne is _hot_!','2006-04-17 21:50:00','Victor',0),
 (5,7,'Yes, yes she is.','2006-04-17 21:55:00','Nonny',0),
 (6,147,'ooh, topless Anne!','2006-04-17 21:57:00','Victor',1),
 (7,84,'the +warm+ liquid stinging painfully.','2006-04-17 22:50:00','Victor',0),
 (8,5,'testing testing testing','2006-04-19 13:21:00','dstar',0);
/*!40000 ALTER TABLE `pcomments` ENABLE KEYS */;


--
-- Table structure for table `pelestats`.`sessions`
--

DROP TABLE IF EXISTS `sessions`;
CREATE TABLE `sessions` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `sessid` varchar(255) default NULL,
  `data` text,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `session_index` (`sessid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `pelestats`.`sessions`
--

/*!40000 ALTER TABLE `sessions` DISABLE KEYS */;
/*!40000 ALTER TABLE `sessions` ENABLE KEYS */;


--
-- Table structure for table `pelestats`.`stories`
--

DROP TABLE IF EXISTS `stories`;
CREATE TABLE `stories` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `title` varchar(255) NOT NULL default '',
  `description` text NOT NULL,
  `flag` int(10) unsigned NOT NULL default '0',
  `universe_id` int(10) unsigned NOT NULL default '0',
  `short_title` varchar(45) NOT NULL default '',
  `order` int(10) unsigned NOT NULL default '0',
  `file_prefix` varchar(45) NOT NULL default '',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `pelestats`.`stories`
--

/*!40000 ALTER TABLE `stories` DISABLE KEYS */;
INSERT INTO `stories` (`id`,`title`,`description`,`flag`,`universe_id`,`short_title`,`order`,`file_prefix`) VALUES 
 (1,'Prudence, TX Population 1276','Prudence is the second story we wrote in the world of Demon\'s Dream, and the first to be released. It chronicles the story of a new teacher in a small town who discovers that life in a small town is very different from the world he knew. When he falls in love with one of his students, his life begins to change in ways he never expected, and he learns that, just like Horatio, there\'s more under heaven and earth than dreamt of in his philosophy.\r\n\r\nWe\'\'ve released around 76,000 words on this, so far, and we\'re committed to getting at least 2,000 a month out in the future. We\'ve got approximately 100,000 words ready for editing on this one; unfortunately, it\'s the old style, and editing is a pain.',0,1,'prudence',1,'prudence'),
 (2,'Furry','Adam and Anya are twins, the children of a Tiger/Sable cross. Their father took them to Venus with him when he split from their mother, and all they\'ve ever known was a primitive life. When he dies, their only choice is to run, or they\'ll be separated. And as they run, they grow even closer.',0,3,'furry',13,'furry'),
 (3,'Sonuachara','Trina MacCeallich wasn\'t one of the \'in\' crowd; she _was_ the \'in\' crowd. Zoe was an outcast who\'d bounced from foster home to foster home, counting the days until she was eighteen and could live on her own...and adopt her foster sister.\r\n\r\nSo Zoe was surprised and suspicious when Trina went out of her way to befriend her. Why would someone like Trina want to be friends with her?\r\n\r\nThe answer lies in the distant past, in the roots of Trina\'s family tree, and Zoe could never have guessed...',0,3,'sonuachara',4,'sonuachara');
INSERT INTO `stories` (`id`,`title`,`description`,`flag`,`universe_id`,`short_title`,`order`,`file_prefix`) VALUES 
 (4,'Camp','DJ liked girls, and he liked sex. He _didn\'t_ do relationships. Leah didn\'t do sex, but she found herself responding to him in ways that unnerved and frightened her.\r\n\r\nSo he offered her a deal...',0,3,'camp',14,'camp'),
 (5,'Castle','Jeffrey Vaser has just inherited a castle in Romania from a relative he never knew he had. And he doesn\'t even _own_ a tuxedo!',0,3,'castle',15,'castle'),
 (6,'New Age Dawning','The gods are dead, and magic has begun to go astray. When Adara rescues Rhishandri from the mage who attempted to sacrifice her, she begins to get a hint as to the reasons why.',0,3,'nad',5,'nad'),
 (7,'Jason and Kylie, Naked in School','Jason\'s the Big Man on Campus, the quarterback of the school football team _despite_ being the coach\'s son. He sees the Naked in School program as an excuse for more sex. But there\'s something wrong with his Program partner...',0,2,'jaknis',3,'jaknis'),
 (8,'Oops','This one\'s experimental, and I\'m not sure how to describe it yet. All I can say is READ THE DISCLAIMER, because it\'s a lot more extreme than anything else we\'ve put up so far. This one\'s not part of the donation schedule, and I make no promises that we\'ll complete it; read the disclaimer.',0,3,'oops',16,'oops');
INSERT INTO `stories` (`id`,`title`,`description`,`flag`,`universe_id`,`short_title`,`order`,`file_prefix`) VALUES 
 (9,'Steve and Deanna, Naked in School','Steve initially worries that his program partner has the same problems that Kylie had. He soon discovers, however, that this is a completely different situation...',0,2,'sadnis',12,'sadnis'),
 (10,'Pandora\'s Box','Pandora\'s Box is our most recent work. Gabriel is barely hanging on after his almost-ex-wife killed herself to protect him from her angry parents. He survives -- it can\'t really be called _living_ -- only because not doing so would be a waste of her sacrifice. Then, on his thirtieth birthday, a teenage girl shows up on his doorstep and turns his life upside down.\r\n\r\nAnd then he discovers that he\'s not even human.',0,1,'pandora',2,'pandoras_box'),
 (11,'Here, Kitty Kitty','When Nikki Morgan bought the small country practice from the former doctor, she thought she\'d enjoy rural life. Unfortunately, she found that she missed the city. And then Kirsa showed up with the strangest symptoms she\'d ever seen. \r\n\r\nIf she didn\'t know better, she\'d say she wasn\'t even human... ',0,1,'kitty',6,'kitty'),
 (12,'Ascent Into Shadow','Ashlyn didn\'t understand why she was so attracted to Lenore. All she knew was that she had to protect her. At first, she thought Lenore was being abused.\r\n\r\nThen she discovered that the truth was far worse. Lenore wasn\'t being abused...Lenore was _dinner._',0,1,'ais',7,'ais');
INSERT INTO `stories` (`id`,`title`,`description`,`flag`,`universe_id`,`short_title`,`order`,`file_prefix`) VALUES 
 (13,'Artform','Traci\'s father sent her to live with her uncle to keep her out of trouble. Hard work on a farm would be good for her.\r\n\r\nThen she met Reina...',0,1,'artform',8,'artform'),
 (14,'Mistaken Assumptions','Jason was new in town, and everyone \'knew\' he was a bad boy. He smoked, he wore a leather jacket, he drove a motorcycle, and he wore a pendant with a \'satanic\' symbol on it.\r\n\r\nSo he was surprised to see the note asking him to meet someone privately. But her proposal was most intriguing indeed...',0,1,'mistaken',9,'mistaken'),
 (15,'Demonic','Miriel had been the Demon Princess of Lust for centuries. She was good at what she did, and she enjoyed the work.\r\n\r\nNow Lucifer has changed, and the rules have changed with him. He\'s returned to what he once was, and with him, the demon lords have been freed. And Lucifer has given her a specific assignment...',0,1,'demonic',10,'demonic'),
 (16,'Country Chaos','Lee\'s mother had divorced her werewolf father and moved far away to \'protect\' her from the metaphysical. But Lee had been training under the Pack\'s shaman for a decade, and didn\'t want to be protected. Or human, for that matter, but genetics didn\'t ask her what she wanted. So when she discovers the rot lurking beneath the surface of the quiet country town they\'ve moved to, she can\'t not get involved.\r\n\r\nEven though it may cost her everything she\'s ever wanted.',0,1,'chaos',11,'chaos');
/*!40000 ALTER TABLE `stories` ENABLE KEYS */;


--
-- Table structure for table `pelestats`.`targets`
--

DROP TABLE IF EXISTS `targets`;
CREATE TABLE `targets` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `story_id` int(10) unsigned NOT NULL default '0',
  `month` int(10) unsigned NOT NULL default '0',
  `year` int(10) unsigned NOT NULL default '0',
  `weekly_words` int(10) unsigned NOT NULL default '2000',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `pelestats`.`targets`
--

/*!40000 ALTER TABLE `targets` DISABLE KEYS */;
INSERT INTO `targets` (`id`,`story_id`,`month`,`year`,`weekly_words`) VALUES 
 (1,1,1,2006,4000),
 (2,7,1,2006,2000),
 (3,10,1,2006,2000),
 (4,3,1,2006,2000),
 (5,6,1,2006,2000),
 (6,1,2,2006,4000),
 (7,10,2,2006,2000),
 (8,1,3,2006,4000),
 (9,10,3,2006,2000),
 (10,1,4,2006,2000),
 (11,7,4,2006,2000);
/*!40000 ALTER TABLE `targets` ENABLE KEYS */;


--
-- Table structure for table `pelestats`.`universes`
--

DROP TABLE IF EXISTS `universes`;
CREATE TABLE `universes` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `universe` varchar(45) NOT NULL default '',
  `description` text NOT NULL,
  `flag` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `pelestats`.`universes`
--

/*!40000 ALTER TABLE `universes` DISABLE KEYS */;
INSERT INTO `universes` (`id`,`universe`,`description`,`flag`) VALUES 
 (1,'Demon\'s Dream','Imagine a world much like ours on the surface. Beneath, however, lies a very different truth. Elves, were-creatures, and demons walk the earth with us...as do other, more dangerous creatures. Humans, did they but know it, are both the weakest creatures and the most important, for without their belief, the gods themselves would fail.\r\n\r\nSome of the novels in this world will be submitted for professional publication; others, however are not suitable due to their subject matter. Therefore, they will be released for free on the net. We don\'t write for money; we write because we need to.\r\n\r\nNot that we _object_ to money, you understand.',0),
 (2,'Naked in School','This is our variant of the Naked in School world. Think of it as set in a very near parallel to the other NiS worlds.',0),
 (3,'Miscellaneous','These stories are all set in their own worlds, unconnected to any other stories. Should we write a sequel or related story, they\'ll get their own section.',0);
/*!40000 ALTER TABLE `universes` ENABLE KEYS */;


--
-- View structure for view `pelestats`.`monthlybystory`
--

DROP VIEW IF EXISTS `monthlybystory`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `pelestats`.`monthlybystory` AS select sql_no_cache `s`.`id` AS `story_id`,`s`.`order` AS `ord`,`s`.`title` AS `title`,`s`.`universe_id` AS `universe_id`,ifnull(month(`c`.`date`),`t`.`month_id`) AS `month`,ifnull(year(`c`.`date`),`t`.`year`) AS `year`,cast(ifnull(if(isnull(`t`.`year`),NULL,((`t`.`weekly_words` * `pelestats`.`days`(cast(concat_ws(_utf8'-',`t`.`year`,`t`.`month_id`,_utf8'1') as date))) / 7)),0) as signed) AS `target_words`,sum(`c`.`words`) AS `wordcount`,(sum(`c`.`words`) - cast(ifnull(if(isnull(`t`.`year`),NULL,((`t`.`weekly_words` * `pelestats`.`days`(cast(concat_ws(_utf8'-',`t`.`year`,`t`.`month_id`,_utf8'1') as date))) / 7)),0) as signed)) AS `overage` from ((`pelestats`.`stories` `s` left join `pelestats`.`chapters` `c` on((`s`.`id` = `c`.`story_id`))) left join `pelestats`.`targets` `t` on(((`s`.`id` = `t`.`story_id`) and (`t`.`year` = year(`c`.`date`)) and (`t`.`month_id` = month(`c`.`date`))))) where (`c`.`words` is not null) group by `s`.`id`,ifnull(month(`c`.`date`),`t`.`month_id`),`t`.`year` order by ifnull(year(`c`.`date`),`t`.`year`),ifnull(month(`c`.`date`),`t`.`month_id`);


--
-- Function `pelestats`.`days`
--

DROP FUNCTION IF EXISTS `days`;
DELIMITER $$

CREATE FUNCTION `days`(_date date) RETURNS int(11)
return if(last_day(_date) > now(), day(now()), day(last_day(_date))) $$

DELIMITER ;

--
-- Function `pelestats`.`matcoltitle`
--

DROP FUNCTION IF EXISTS `matcoltitle`;
DELIMITER $$

CREATE FUNCTION `matcoltitle`(year int, month int) RETURNS varchar(15)
return date_format(concat_ws('-',year,month,'1'),'%M %Y') $$

DELIMITER ;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
