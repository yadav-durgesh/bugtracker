-- phpMyAdmin SQL Dump
-- version 4.7.6
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Feb 15, 2019 at 10:37 AM
-- Server version: 10.1.29-MariaDB
-- PHP Version: 7.0.26

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `bugtracker`
--

-- --------------------------------------------------------

--
-- Table structure for table `mantis_api_token_table`
--

CREATE TABLE `mantis_api_token_table` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `name` varchar(128) NOT NULL,
  `hash` varchar(128) NOT NULL,
  `date_created` int(10) UNSIGNED NOT NULL DEFAULT '1',
  `date_used` int(10) UNSIGNED NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `mantis_bugnote_table`
--

CREATE TABLE `mantis_bugnote_table` (
  `id` int(10) UNSIGNED NOT NULL,
  `bug_id` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `reporter_id` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `bugnote_text_id` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `view_state` smallint(6) NOT NULL DEFAULT '10',
  `note_type` int(11) DEFAULT '0',
  `note_attr` varchar(250) DEFAULT '',
  `time_tracking` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `last_modified` int(10) UNSIGNED NOT NULL DEFAULT '1',
  `date_submitted` int(10) UNSIGNED NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `mantis_bugnote_table`
--

INSERT INTO `mantis_bugnote_table` (`id`, `bug_id`, `reporter_id`, `bugnote_text_id`, `view_state`, `note_type`, `note_attr`, `time_tracking`, `last_modified`, `date_submitted`) VALUES
(1, 1, 2, 1, 50, 2, '', 600, 1549892338, 1549891962),
(2, 1, 4, 2, 50, 2, '', 730, 1549892425, 1549892425);

-- --------------------------------------------------------

--
-- Table structure for table `mantis_bugnote_text_table`
--

CREATE TABLE `mantis_bugnote_text_table` (
  `id` int(10) UNSIGNED NOT NULL,
  `note` longtext NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `mantis_bugnote_text_table`
--

INSERT INTO `mantis_bugnote_text_table` (`id`, `note`) VALUES
(1, 'wewe\n\n'),
(2, 'qwqw');

-- --------------------------------------------------------

--
-- Table structure for table `mantis_bug_file_table`
--

CREATE TABLE `mantis_bug_file_table` (
  `id` int(10) UNSIGNED NOT NULL,
  `bug_id` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `title` varchar(250) NOT NULL DEFAULT '',
  `description` varchar(250) NOT NULL DEFAULT '',
  `diskfile` varchar(250) NOT NULL DEFAULT '',
  `filename` varchar(250) NOT NULL DEFAULT '',
  `folder` varchar(250) NOT NULL DEFAULT '',
  `filesize` int(11) NOT NULL DEFAULT '0',
  `file_type` varchar(250) NOT NULL DEFAULT '',
  `content` longblob,
  `date_added` int(10) UNSIGNED NOT NULL DEFAULT '1',
  `user_id` int(10) UNSIGNED NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `mantis_bug_history_table`
--

CREATE TABLE `mantis_bug_history_table` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `bug_id` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `field_name` varchar(64) NOT NULL,
  `old_value` varchar(255) NOT NULL,
  `new_value` varchar(255) NOT NULL,
  `type` smallint(6) NOT NULL DEFAULT '0',
  `date_modified` int(10) UNSIGNED NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `mantis_bug_history_table`
--

INSERT INTO `mantis_bug_history_table` (`id`, `user_id`, `bug_id`, `field_name`, `old_value`, `new_value`, `type`, `date_modified`) VALUES
(1, 2, 1, '', '', '', 1, 1549887777),
(2, 2, 1, 'Calendar_Calendar Event', '', 'Added to the event: test', 100, 1549888117),
(3, 2, 1, 'handler_id', '0', '2', 0, 1549888213),
(4, 2, 1, 'status', '10', '30', 0, 1549888213),
(5, 2, 1, '', '2', '', 12, 1549891107),
(6, 2, 1, '', '0000001', '', 2, 1549891963),
(7, 4, 1, '', '0000001', '2', 3, 1549892338),
(8, 4, 1, '', '50', '0000001', 11, 1549892411),
(9, 4, 1, '', '0000002', '', 2, 1549892426),
(10, 4, 1, 'Calendar_Calendar Event', '', 'Added to the event: Program', 100, 1549892514),
(11, 2, 1, 'Calendar_Calendar Event', '', 'Added to the event: Test', 100, 1549892626);

-- --------------------------------------------------------

--
-- Table structure for table `mantis_bug_monitor_table`
--

CREATE TABLE `mantis_bug_monitor_table` (
  `user_id` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `bug_id` int(10) UNSIGNED NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `mantis_bug_monitor_table`
--

INSERT INTO `mantis_bug_monitor_table` (`user_id`, `bug_id`) VALUES
(2, 1);

-- --------------------------------------------------------

--
-- Table structure for table `mantis_bug_relationship_table`
--

CREATE TABLE `mantis_bug_relationship_table` (
  `id` int(10) UNSIGNED NOT NULL,
  `source_bug_id` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `destination_bug_id` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `relationship_type` smallint(6) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `mantis_bug_revision_table`
--

CREATE TABLE `mantis_bug_revision_table` (
  `id` int(10) UNSIGNED NOT NULL,
  `bug_id` int(10) UNSIGNED NOT NULL,
  `bugnote_id` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `user_id` int(10) UNSIGNED NOT NULL,
  `type` int(10) UNSIGNED NOT NULL,
  `value` longtext NOT NULL,
  `timestamp` int(10) UNSIGNED NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `mantis_bug_revision_table`
--

INSERT INTO `mantis_bug_revision_table` (`id`, `bug_id`, `bugnote_id`, `user_id`, `type`, `value`, `timestamp`) VALUES
(1, 1, 1, 2, 4, 'wewe', 1549891962),
(2, 1, 1, 4, 4, 'wewe\n\n', 1549892338);

-- --------------------------------------------------------

--
-- Table structure for table `mantis_bug_table`
--

CREATE TABLE `mantis_bug_table` (
  `id` int(10) UNSIGNED NOT NULL,
  `project_id` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `reporter_id` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `handler_id` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `duplicate_id` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `priority` smallint(6) NOT NULL DEFAULT '30',
  `severity` smallint(6) NOT NULL DEFAULT '50',
  `reproducibility` smallint(6) NOT NULL DEFAULT '10',
  `status` smallint(6) NOT NULL DEFAULT '10',
  `resolution` smallint(6) NOT NULL DEFAULT '10',
  `projection` smallint(6) NOT NULL DEFAULT '10',
  `eta` smallint(6) NOT NULL DEFAULT '10',
  `bug_text_id` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `os` varchar(32) NOT NULL DEFAULT '',
  `os_build` varchar(32) NOT NULL DEFAULT '',
  `platform` varchar(32) NOT NULL DEFAULT '',
  `version` varchar(64) NOT NULL DEFAULT '',
  `fixed_in_version` varchar(64) NOT NULL DEFAULT '',
  `build` varchar(32) NOT NULL DEFAULT '',
  `profile_id` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `view_state` smallint(6) NOT NULL DEFAULT '10',
  `summary` varchar(128) NOT NULL DEFAULT '',
  `sponsorship_total` int(11) NOT NULL DEFAULT '0',
  `sticky` tinyint(4) NOT NULL DEFAULT '0',
  `target_version` varchar(64) NOT NULL DEFAULT '',
  `category_id` int(10) UNSIGNED NOT NULL DEFAULT '1',
  `date_submitted` int(10) UNSIGNED NOT NULL DEFAULT '1',
  `due_date` int(10) UNSIGNED NOT NULL DEFAULT '1',
  `last_updated` int(10) UNSIGNED NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `mantis_bug_table`
--

INSERT INTO `mantis_bug_table` (`id`, `project_id`, `reporter_id`, `handler_id`, `duplicate_id`, `priority`, `severity`, `reproducibility`, `status`, `resolution`, `projection`, `eta`, `bug_text_id`, `os`, `os_build`, `platform`, `version`, `fixed_in_version`, `build`, `profile_id`, `view_state`, `summary`, `sponsorship_total`, `sticky`, `target_version`, `category_id`, `date_submitted`, `due_date`, `last_updated`) VALUES
(1, 1, 2, 2, 0, 30, 10, 10, 30, 10, 10, 10, 1, '', '', '', '', '', '', 0, 10, 'test', 0, 0, '', 2, 1549887776, 1, 1549892426);

-- --------------------------------------------------------

--
-- Table structure for table `mantis_bug_tag_table`
--

CREATE TABLE `mantis_bug_tag_table` (
  `bug_id` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `tag_id` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `user_id` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `date_attached` int(10) UNSIGNED NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `mantis_bug_text_table`
--

CREATE TABLE `mantis_bug_text_table` (
  `id` int(10) UNSIGNED NOT NULL,
  `description` longtext NOT NULL,
  `steps_to_reproduce` longtext NOT NULL,
  `additional_information` longtext NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `mantis_bug_text_table`
--

INSERT INTO `mantis_bug_text_table` (`id`, `description`, `steps_to_reproduce`, `additional_information`) VALUES
(1, 'test', 'test', 'test');

-- --------------------------------------------------------

--
-- Table structure for table `mantis_category_table`
--

CREATE TABLE `mantis_category_table` (
  `id` int(10) UNSIGNED NOT NULL,
  `project_id` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `user_id` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `name` varchar(128) NOT NULL DEFAULT '',
  `status` int(10) UNSIGNED NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `mantis_category_table`
--

INSERT INTO `mantis_category_table` (`id`, `project_id`, `user_id`, `name`, `status`) VALUES
(1, 0, 0, 'General', 0),
(2, 0, 0, 'All Local', 0);

-- --------------------------------------------------------

--
-- Table structure for table `mantis_config_table`
--

CREATE TABLE `mantis_config_table` (
  `config_id` varchar(64) NOT NULL,
  `project_id` int(11) NOT NULL DEFAULT '0',
  `user_id` int(11) NOT NULL DEFAULT '0',
  `access_reqd` int(11) DEFAULT '0',
  `type` int(11) DEFAULT '90',
  `value` longtext NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `mantis_config_table`
--

INSERT INTO `mantis_config_table` (`config_id`, `project_id`, `user_id`, `access_reqd`, `type`, `value`) VALUES
('database_version', 0, 0, 90, 1, '209'),
('plugin_Calendar_arWeekdaysName', 0, 2, 90, 3, '{\"Mon\":1,\"Tue\":1,\"Wed\":1,\"Thu\":1,\"Fri\":1,\"Sat\":0,\"Sun\":0}'),
('plugin_Calendar_google_calendar_sync_id', 0, 2, 90, 2, ''),
('plugin_Calendar_schema', 0, 0, 90, 1, '13'),
('plugin_Calendar_time_day_finish', 0, 2, 90, 1, '84600'),
('plugin_EmailReporting_config_version', 0, 0, 90, 1, '17'),
('plugin_EmailReporting_mailboxes', 0, 0, 90, 3, '[]'),
('plugin_EmailReporting_mail_mantisbt_url_fix', 0, 0, 90, 2, 'http://mantisbt.net/'),
('plugin_EmailReporting_mail_reporter_id', 0, 0, 90, 1, '3'),
('plugin_EmailReporting_reset_schema', 0, 0, 90, 1, '1'),
('plugin_EmailReporting_schema', 0, 0, 90, 1, '1'),
('plugin_EventLog_schema', 0, 0, 90, 1, '7'),
('plugin_GaugeSupport_schema', 0, 0, 90, 1, '0'),
('plugin_Gravatar_schema', 0, 0, 90, 1, '-1'),
('plugin_MantisGraph_schema', 0, 0, 90, 1, '-1'),
('plugin_Slack_schema', 0, 0, 90, 1, '-1'),
('plugin_XmlImportExport_schema', 0, 0, 90, 1, '-1');

-- --------------------------------------------------------

--
-- Table structure for table `mantis_custom_field_project_table`
--

CREATE TABLE `mantis_custom_field_project_table` (
  `field_id` int(11) NOT NULL DEFAULT '0',
  `project_id` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `sequence` smallint(6) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `mantis_custom_field_string_table`
--

CREATE TABLE `mantis_custom_field_string_table` (
  `field_id` int(11) NOT NULL DEFAULT '0',
  `bug_id` int(11) NOT NULL DEFAULT '0',
  `value` varchar(255) NOT NULL DEFAULT '',
  `text` longtext
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `mantis_custom_field_table`
--

CREATE TABLE `mantis_custom_field_table` (
  `id` int(11) NOT NULL,
  `name` varchar(64) NOT NULL DEFAULT '',
  `type` smallint(6) NOT NULL DEFAULT '0',
  `possible_values` text,
  `default_value` varchar(255) NOT NULL DEFAULT '',
  `valid_regexp` varchar(255) NOT NULL DEFAULT '',
  `access_level_r` smallint(6) NOT NULL DEFAULT '0',
  `access_level_rw` smallint(6) NOT NULL DEFAULT '0',
  `length_min` int(11) NOT NULL DEFAULT '0',
  `length_max` int(11) NOT NULL DEFAULT '0',
  `require_report` tinyint(4) NOT NULL DEFAULT '0',
  `require_update` tinyint(4) NOT NULL DEFAULT '0',
  `display_report` tinyint(4) NOT NULL DEFAULT '0',
  `display_update` tinyint(4) NOT NULL DEFAULT '1',
  `require_resolved` tinyint(4) NOT NULL DEFAULT '0',
  `display_resolved` tinyint(4) NOT NULL DEFAULT '0',
  `display_closed` tinyint(4) NOT NULL DEFAULT '0',
  `require_closed` tinyint(4) NOT NULL DEFAULT '0',
  `filter_by` tinyint(4) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `mantis_custom_field_table`
--

INSERT INTO `mantis_custom_field_table` (`id`, `name`, `type`, `possible_values`, `default_value`, `valid_regexp`, `access_level_r`, `access_level_rw`, `length_min`, `length_max`, `require_report`, `require_update`, `display_report`, `display_update`, `require_resolved`, `display_resolved`, `display_closed`, `require_closed`, `filter_by`) VALUES
(1, 'custom field', 1, '1|2|3', '1', '', 10, 90, 1, 10, 0, 0, 0, 1, 0, 0, 0, 0, 1);

-- --------------------------------------------------------

--
-- Table structure for table `mantis_email_table`
--

CREATE TABLE `mantis_email_table` (
  `email_id` int(10) UNSIGNED NOT NULL,
  `email` varchar(64) NOT NULL DEFAULT '',
  `subject` varchar(250) NOT NULL DEFAULT '',
  `metadata` longtext NOT NULL,
  `body` longtext NOT NULL,
  `submitted` int(10) UNSIGNED NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `mantis_email_table`
--

INSERT INTO `mantis_email_table` (`email_id`, `email`, `subject`, `metadata`, `body`, `submitted`) VALUES
(1, 'durgesh.yadav@tacto.in', '[MantisBT] Account registration', 'a:3:{s:7:\"headers\";a:0:{}s:7:\"charset\";s:5:\"utf-8\";s:8:\"hostname\";s:12:\"mantisbt.net\";}', 'Thank you for registering. You have an account with username \"admin\". In order to complete your registration, visit the following URL (make sure it is entered as the single line) and set your own access password:\n\nhttp://mantisbt.net/verify.php?id=2&confirm_hash=x4Gkl6H03MFxnAj315CFkyVQr2HY9W7MWNxtVWEmiQCcicAMZq6Nd5nD7YjOiJ6Tjne6-9tCBpFJ_Dq8npBF\n\nIf you did not request any registration, ignore this message and nothing will happen.\n\nDo not reply to this message', 1549883120),
(2, 'root@localhost', '[MantisBT] Account registration', 'a:3:{s:7:\"headers\";a:0:{}s:7:\"charset\";s:5:\"utf-8\";s:8:\"hostname\";s:12:\"mantisbt.net\";}', 'The following account has been created:\n\nUsername: admin\nE-mail: durgesh.yadav@tacto.in\nRemote IP address: 127.0.0.1\nhttp://mantisbt.net/\n\nDo not reply to this message', 1549883120),
(3, 'durgesh.yadav@tacto.in', '[MantisBT] Password Reset', 'a:3:{s:7:\"headers\";a:0:{}s:7:\"charset\";s:5:\"utf-8\";s:8:\"hostname\";s:12:\"mantisbt.net\";}', 'Someone (presumably you) requested a password change through e-mail verification. If this was not you, ignore this message and nothing will happen.\n\nIf you requested this verification, visit the following URL to change your password: \n\nhttp://mantisbt.net/verify.php?id=2&confirm_hash=x4Gkl6H03MFxnAj315CFkyVQr2HY9W7MWNxtVWEmiQCcicAMZq6Nd5nD7YjOiJ6Tjne6-9tCBpFJ_Dq8npBF \n\nUsername: admin \nRemote IP address: 127.0.0.1 \n\nDo not reply to this message', 1549883225),
(4, 'ravinder.rampelli@tacto.in', '[MantisBT] Account registration', 'a:3:{s:7:\"headers\";a:0:{}s:7:\"charset\";s:5:\"utf-8\";s:8:\"hostname\";s:12:\"mantisbt.net\";}', 'The user admin has created an account for you with username \"dee\". In order to complete your registration, visit the following URL (make sure it is entered as the single line) and set your own access password:\n\nhttp://mantisbt.net/verify.php?id=4&confirm_hash=oiByQ27RjUB1xV6OA48-cZLCcvW-GzHOawuOQpZyobHbf8I_PMow5izHJOc8dri-NmsGM9X7Cn8jAh7t8c1x\n\nIf you did not request any registration, ignore this message and nothing will happen.\n\nDo not reply to this message', 1549892134),
(5, 'durgesh.yadav@tacto.in', '[Bhatia 0000001]: test', 'a:3:{s:7:\"headers\";a:0:{}s:7:\"charset\";s:5:\"utf-8\";s:8:\"hostname\";s:12:\"mantisbt.net\";}', 'A NOTE has been added to this issue.\n\n---------------------------------------------------------------------- \n (0000002) dee (developer) - 2019-02-11 19:10 (private)\n Time tracking 12:10\n http://mantisbt.net/view.php?id=1#c2 \n---------------------------------------------------------------------- \nqwqw\n----------------------------------------------------------------------', 1549892426);

-- --------------------------------------------------------

--
-- Table structure for table `mantis_filters_table`
--

CREATE TABLE `mantis_filters_table` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `project_id` int(11) NOT NULL DEFAULT '0',
  `is_public` tinyint(4) DEFAULT NULL,
  `name` varchar(64) NOT NULL DEFAULT '',
  `filter_string` longtext NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `mantis_filters_table`
--

INSERT INTO `mantis_filters_table` (`id`, `user_id`, `project_id`, `is_public`, `name`, `filter_string`) VALUES
(1, 2, -1, 0, '', 'v9#{\"_version\":\"v9\",\"_view_type\":\"advanced\",\"category_id\":[\"0\"],\"severity\":[0],\"status\":[10,20,30,40,50,80],\"per_page\":50,\"highlight_changed\":6,\"reporter_id\":[0],\"handler_id\":[0],\"project_id\":[-3],\"sort\":\"last_updated\",\"dir\":\"DESC\",\"filter_by_date\":false,\"start_month\":2,\"start_day\":1,\"start_year\":2019,\"end_month\":2,\"end_day\":11,\"end_year\":2019,\"filter_by_last_updated_date\":false,\"last_updated_start_month\":2,\"last_updated_start_day\":1,\"last_updated_start_year\":2019,\"last_updated_end_month\":2,\"last_updated_end_day\":11,\"last_updated_end_year\":2019,\"search\":\"\",\"hide_status\":[-2],\"resolution\":[0],\"build\":[\"0\"],\"version\":[\"0\"],\"fixed_in_version\":[\"0\"],\"target_version\":[\"0\"],\"priority\":[0],\"monitor_user_id\":[0],\"view_state\":0,\"custom_fields\":{\"1\":[\"0\"]},\"sticky\":true,\"relationship_type\":-1,\"relationship_bug\":0,\"profile_id\":[0],\"platform\":[\"0\"],\"os\":[\"0\"],\"os_build\":[\"0\"],\"tag_string\":\"\",\"tag_select\":0,\"note_user_id\":[0],\"match_type\":0,\"_source_query_id\":2}'),
(2, 2, 0, 1, 'local', 'v9#{\"_version\":\"v9\",\"_view_type\":\"advanced\",\"category_id\":[\"0\"],\"severity\":[0],\"status\":[10,20,30,40,50,80],\"per_page\":50,\"highlight_changed\":6,\"reporter_id\":[0],\"handler_id\":[0],\"project_id\":[-3],\"sort\":\"last_updated\",\"dir\":\"DESC\",\"filter_by_date\":false,\"start_month\":2,\"start_day\":1,\"start_year\":2019,\"end_month\":2,\"end_day\":11,\"end_year\":2019,\"filter_by_last_updated_date\":false,\"last_updated_start_month\":2,\"last_updated_start_day\":1,\"last_updated_start_year\":2019,\"last_updated_end_month\":2,\"last_updated_end_day\":11,\"last_updated_end_year\":2019,\"search\":\"\",\"hide_status\":[-2],\"resolution\":[0],\"build\":[\"0\"],\"version\":[\"0\"],\"fixed_in_version\":[\"0\"],\"target_version\":[\"0\"],\"priority\":[0],\"monitor_user_id\":[0],\"view_state\":0,\"custom_fields\":{\"1\":[\"0\"]},\"sticky\":true,\"relationship_type\":-1,\"relationship_bug\":0,\"profile_id\":[0],\"platform\":[\"0\"],\"os\":[\"0\"],\"os_build\":[\"0\"],\"tag_string\":\"\",\"tag_select\":0,\"note_user_id\":[0],\"match_type\":0}');

-- --------------------------------------------------------

--
-- Table structure for table `mantis_news_table`
--

CREATE TABLE `mantis_news_table` (
  `id` int(10) UNSIGNED NOT NULL,
  `project_id` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `poster_id` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `view_state` smallint(6) NOT NULL DEFAULT '10',
  `announcement` tinyint(4) NOT NULL DEFAULT '0',
  `headline` varchar(64) NOT NULL DEFAULT '',
  `body` longtext NOT NULL,
  `last_modified` int(10) UNSIGNED NOT NULL DEFAULT '1',
  `date_posted` int(10) UNSIGNED NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `mantis_plugin_Calendar_events_table`
--

CREATE TABLE `mantis_plugin_Calendar_events_table` (
  `id` int(10) NOT NULL,
  `project_id` int(10) NOT NULL,
  `name` varchar(255) NOT NULL,
  `activity` char(1) NOT NULL,
  `author_id` int(10) DEFAULT NULL,
  `date_changed` int(2) DEFAULT NULL,
  `changed_user_id` int(10) DEFAULT NULL,
  `date_from` int(10) UNSIGNED NOT NULL DEFAULT '1',
  `date_to` int(10) UNSIGNED NOT NULL DEFAULT '1',
  `duration` int(10) UNSIGNED NOT NULL,
  `recurrence_pattern` mediumtext,
  `parent_id` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `mantis_plugin_Calendar_events_table`
--

INSERT INTO `mantis_plugin_Calendar_events_table` (`id`, `project_id`, `name`, `activity`, `author_id`, `date_changed`, `changed_user_id`, `date_from`, `date_to`, `duration`, `recurrence_pattern`, `parent_id`) VALUES
(2, 1, 'Program', 'Y', 4, 1549892572, 0, 1549882800, 1549888200, 5400, NULL, 0),
(3, 1, 'Test', 'Y', 2, 1549892627, 0, 1549872000, 1549906200, 34200, NULL, 0);

-- --------------------------------------------------------

--
-- Table structure for table `mantis_plugin_Calendar_event_member_table`
--

CREATE TABLE `mantis_plugin_Calendar_event_member_table` (
  `user_id` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `event_id` int(10) UNSIGNED NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `mantis_plugin_Calendar_event_member_table`
--

INSERT INTO `mantis_plugin_Calendar_event_member_table` (`user_id`, `event_id`) VALUES
(2, 3),
(3, 2),
(4, 2),
(4, 3);

-- --------------------------------------------------------

--
-- Table structure for table `mantis_plugin_Calendar_google_sync_table`
--

CREATE TABLE `mantis_plugin_Calendar_google_sync_table` (
  `event_id` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `google_id` varchar(255) NOT NULL,
  `last_sync` int(10) UNSIGNED NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `mantis_plugin_Calendar_relationship_table`
--

CREATE TABLE `mantis_plugin_Calendar_relationship_table` (
  `event_id` int(10) NOT NULL,
  `bug_id` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `mantis_plugin_Calendar_relationship_table`
--

INSERT INTO `mantis_plugin_Calendar_relationship_table` (`event_id`, `bug_id`) VALUES
(2, 1),
(3, 1);

-- --------------------------------------------------------

--
-- Table structure for table `mantis_plugin_EmailReporting_msgids_table`
--

CREATE TABLE `mantis_plugin_EmailReporting_msgids_table` (
  `id` int(10) UNSIGNED NOT NULL,
  `issue_id` int(10) UNSIGNED NOT NULL,
  `msg_id` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `mantis_plugin_EventLog_events_table`
--

CREATE TABLE `mantis_plugin_EventLog_events_table` (
  `id` int(10) UNSIGNED NOT NULL,
  `request_id` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `timestamp` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `event` varchar(250) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `mantis_plugin_EventLog_requests_table`
--

CREATE TABLE `mantis_plugin_EventLog_requests_table` (
  `id` int(10) UNSIGNED NOT NULL,
  `timestamp` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `user_id` int(10) UNSIGNED NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `mantis_plugin_GaugeSupport_support_data_table`
--

CREATE TABLE `mantis_plugin_GaugeSupport_support_data_table` (
  `bugid` int(10) UNSIGNED NOT NULL,
  `userid` int(10) UNSIGNED NOT NULL,
  `rating` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `mantis_plugin_table`
--

CREATE TABLE `mantis_plugin_table` (
  `basename` varchar(40) NOT NULL,
  `enabled` tinyint(4) NOT NULL DEFAULT '0',
  `protected` tinyint(4) NOT NULL DEFAULT '0',
  `priority` int(10) UNSIGNED NOT NULL DEFAULT '3'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `mantis_plugin_table`
--

INSERT INTO `mantis_plugin_table` (`basename`, `enabled`, `protected`, `priority`) VALUES
('Calendar', 1, 0, 5),
('EmailReporting', 1, 0, 3),
('EventLog', 1, 0, 3),
('GaugeSupport', 1, 0, 3),
('Gravatar', 1, 0, 5),
('MantisCoreFormatting', 1, 0, 4),
('MantisGraph', 1, 0, 3),
('Slack', 1, 0, 3),
('XmlImportExport', 1, 0, 1);

-- --------------------------------------------------------

--
-- Table structure for table `mantis_project_file_table`
--

CREATE TABLE `mantis_project_file_table` (
  `id` int(10) UNSIGNED NOT NULL,
  `project_id` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `title` varchar(250) NOT NULL DEFAULT '',
  `description` varchar(250) NOT NULL DEFAULT '',
  `diskfile` varchar(250) NOT NULL DEFAULT '',
  `filename` varchar(250) NOT NULL DEFAULT '',
  `folder` varchar(250) NOT NULL DEFAULT '',
  `filesize` int(11) NOT NULL DEFAULT '0',
  `file_type` varchar(250) NOT NULL DEFAULT '',
  `content` longblob,
  `date_added` int(10) UNSIGNED NOT NULL DEFAULT '1',
  `user_id` int(10) UNSIGNED NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `mantis_project_hierarchy_table`
--

CREATE TABLE `mantis_project_hierarchy_table` (
  `child_id` int(10) UNSIGNED NOT NULL,
  `parent_id` int(10) UNSIGNED NOT NULL,
  `inherit_parent` tinyint(4) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `mantis_project_table`
--

CREATE TABLE `mantis_project_table` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(128) NOT NULL DEFAULT '',
  `status` smallint(6) NOT NULL DEFAULT '10',
  `enabled` tinyint(4) NOT NULL DEFAULT '1',
  `view_state` smallint(6) NOT NULL DEFAULT '10',
  `access_min` smallint(6) NOT NULL DEFAULT '10',
  `file_path` varchar(250) NOT NULL DEFAULT '',
  `description` longtext NOT NULL,
  `category_id` int(10) UNSIGNED NOT NULL DEFAULT '1',
  `inherit_global` tinyint(4) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `mantis_project_table`
--

INSERT INTO `mantis_project_table` (`id`, `name`, `status`, `enabled`, `view_state`, `access_min`, `file_path`, `description`, `category_id`, `inherit_global`) VALUES
(1, 'Bhatia', 10, 1, 10, 10, '', 'Demo project', 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `mantis_project_user_list_table`
--

CREATE TABLE `mantis_project_user_list_table` (
  `project_id` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `user_id` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `access_level` smallint(6) NOT NULL DEFAULT '10'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `mantis_project_version_table`
--

CREATE TABLE `mantis_project_version_table` (
  `id` int(11) NOT NULL,
  `project_id` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `version` varchar(64) NOT NULL DEFAULT '',
  `description` longtext NOT NULL,
  `released` tinyint(4) NOT NULL DEFAULT '1',
  `obsolete` tinyint(4) NOT NULL DEFAULT '0',
  `date_order` int(10) UNSIGNED NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `mantis_sponsorship_table`
--

CREATE TABLE `mantis_sponsorship_table` (
  `id` int(11) NOT NULL,
  `bug_id` int(11) NOT NULL DEFAULT '0',
  `user_id` int(11) NOT NULL DEFAULT '0',
  `amount` int(11) NOT NULL DEFAULT '0',
  `logo` varchar(128) NOT NULL DEFAULT '',
  `url` varchar(128) NOT NULL DEFAULT '',
  `paid` tinyint(4) NOT NULL DEFAULT '0',
  `date_submitted` int(10) UNSIGNED NOT NULL DEFAULT '1',
  `last_updated` int(10) UNSIGNED NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `mantis_tag_table`
--

CREATE TABLE `mantis_tag_table` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `name` varchar(100) NOT NULL DEFAULT '',
  `description` longtext NOT NULL,
  `date_created` int(10) UNSIGNED NOT NULL DEFAULT '1',
  `date_updated` int(10) UNSIGNED NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `mantis_tag_table`
--

INSERT INTO `mantis_tag_table` (`id`, `user_id`, `name`, `description`, `date_created`, `date_updated`) VALUES
(1, 2, 'tag1', 'all tag for project', 1549887490, 1549887490),
(2, 2, 'tag2', 'all tag for project', 1549887490, 1549887490),
(3, 2, 'tag3', 'all tag for project', 1549887490, 1549887490);

-- --------------------------------------------------------

--
-- Table structure for table `mantis_tokens_table`
--

CREATE TABLE `mantis_tokens_table` (
  `id` int(11) NOT NULL,
  `owner` int(11) NOT NULL,
  `type` int(11) NOT NULL,
  `value` longtext NOT NULL,
  `timestamp` int(10) UNSIGNED NOT NULL DEFAULT '1',
  `expiry` int(10) UNSIGNED NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `mantis_tokens_table`
--

INSERT INTO `mantis_tokens_table` (`id`, `owner`, `type`, `value`, `timestamp`, `expiry`) VALUES
(1, 2, 7, 'x4Gkl6H03MFxnAj315CFkyVQr2HY9W7MWNxtVWEmiQCcicAMZq6Nd5nD7YjOiJ6Tjne6-9tCBpFJ_Dq8npBF', 1549883120, 1550488024),
(3, 2, 5, '{\"filter\":true,\"sidebar\":false,\"profile\":false}', 1549885865, 1581428074),
(6, 2, 3, '1', 1549887777, 1549978831),
(12, 4, 7, 'oiByQ27RjUB1xV6OA48-cZLCcvW-GzHOawuOQpZyobHbf8I_PMow5izHJOc8dri-NmsGM9X7Cn8jAh7t8c1x', 1549892134, 1550496934),
(14, 4, 3, '1', 1549892308, 1549978826);

-- --------------------------------------------------------

--
-- Table structure for table `mantis_user_pref_table`
--

CREATE TABLE `mantis_user_pref_table` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `project_id` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `default_profile` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `default_project` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `refresh_delay` int(11) NOT NULL DEFAULT '0',
  `redirect_delay` int(11) NOT NULL DEFAULT '0',
  `bugnote_order` varchar(4) NOT NULL DEFAULT 'ASC',
  `email_on_new` tinyint(4) NOT NULL DEFAULT '0',
  `email_on_assigned` tinyint(4) NOT NULL DEFAULT '0',
  `email_on_feedback` tinyint(4) NOT NULL DEFAULT '0',
  `email_on_resolved` tinyint(4) NOT NULL DEFAULT '0',
  `email_on_closed` tinyint(4) NOT NULL DEFAULT '0',
  `email_on_reopened` tinyint(4) NOT NULL DEFAULT '0',
  `email_on_bugnote` tinyint(4) NOT NULL DEFAULT '0',
  `email_on_status` tinyint(4) NOT NULL DEFAULT '0',
  `email_on_priority` tinyint(4) NOT NULL DEFAULT '0',
  `email_on_priority_min_severity` smallint(6) NOT NULL DEFAULT '10',
  `email_on_status_min_severity` smallint(6) NOT NULL DEFAULT '10',
  `email_on_bugnote_min_severity` smallint(6) NOT NULL DEFAULT '10',
  `email_on_reopened_min_severity` smallint(6) NOT NULL DEFAULT '10',
  `email_on_closed_min_severity` smallint(6) NOT NULL DEFAULT '10',
  `email_on_resolved_min_severity` smallint(6) NOT NULL DEFAULT '10',
  `email_on_feedback_min_severity` smallint(6) NOT NULL DEFAULT '10',
  `email_on_assigned_min_severity` smallint(6) NOT NULL DEFAULT '10',
  `email_on_new_min_severity` smallint(6) NOT NULL DEFAULT '10',
  `email_bugnote_limit` smallint(6) NOT NULL DEFAULT '0',
  `language` varchar(32) NOT NULL DEFAULT 'english',
  `timezone` varchar(32) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `mantis_user_pref_table`
--

INSERT INTO `mantis_user_pref_table` (`id`, `user_id`, `project_id`, `default_profile`, `default_project`, `refresh_delay`, `redirect_delay`, `bugnote_order`, `email_on_new`, `email_on_assigned`, `email_on_feedback`, `email_on_resolved`, `email_on_closed`, `email_on_reopened`, `email_on_bugnote`, `email_on_status`, `email_on_priority`, `email_on_priority_min_severity`, `email_on_status_min_severity`, `email_on_bugnote_min_severity`, `email_on_reopened_min_severity`, `email_on_closed_min_severity`, `email_on_resolved_min_severity`, `email_on_feedback_min_severity`, `email_on_assigned_min_severity`, `email_on_new_min_severity`, `email_bugnote_limit`, `language`, `timezone`) VALUES
(1, 2, 0, 0, 1, 30, 2, 'DESC', 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'auto', 'Asia/Kolkata');

-- --------------------------------------------------------

--
-- Table structure for table `mantis_user_print_pref_table`
--

CREATE TABLE `mantis_user_print_pref_table` (
  `user_id` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `print_pref` varchar(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `mantis_user_profile_table`
--

CREATE TABLE `mantis_user_profile_table` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `platform` varchar(32) NOT NULL DEFAULT '',
  `os` varchar(32) NOT NULL DEFAULT '',
  `os_build` varchar(32) NOT NULL DEFAULT '',
  `description` longtext NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `mantis_user_table`
--

CREATE TABLE `mantis_user_table` (
  `id` int(10) UNSIGNED NOT NULL,
  `username` varchar(191) NOT NULL DEFAULT '',
  `realname` varchar(191) NOT NULL DEFAULT '',
  `email` varchar(191) NOT NULL DEFAULT '',
  `password` varchar(64) NOT NULL DEFAULT '',
  `enabled` tinyint(4) NOT NULL DEFAULT '1',
  `protected` tinyint(4) NOT NULL DEFAULT '0',
  `access_level` smallint(6) NOT NULL DEFAULT '10',
  `login_count` int(11) NOT NULL DEFAULT '0',
  `lost_password_request_count` smallint(6) NOT NULL DEFAULT '0',
  `failed_login_count` smallint(6) NOT NULL DEFAULT '0',
  `cookie_string` varchar(64) NOT NULL DEFAULT '',
  `last_visit` int(10) UNSIGNED NOT NULL DEFAULT '1',
  `date_created` int(10) UNSIGNED NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `mantis_user_table`
--

INSERT INTO `mantis_user_table` (`id`, `username`, `realname`, `email`, `password`, `enabled`, `protected`, `access_level`, `login_count`, `lost_password_request_count`, `failed_login_count`, `cookie_string`, `last_visit`, `date_created`) VALUES
(1, 'administrator', '', 'root@localhost', '63a9f0ea7bb98050796b649e85481845', 0, 0, 90, 3, 0, 0, '04be066f56c364fc8a66bb406ecb1e3f6542ffe2855caf41fa33105573f11638', 1549882354, 1549882354),
(2, 'admin', '', 'durgesh.yadav@tacto.in', '5f4dcc3b5aa765d61d8327deb882cf99', 1, 0, 90, 9, 0, 0, 'gpe6sGff0DCNeT5_sDv8qA0TaahIddb6aq5xvQ4ouTSvQQAUWTpbgP7sgcxMfEyu', 1549892740, 1549883119),
(3, 'Mail66631', 'Mail Reporter', '', '8ebd4cddb01ec3f6df8fa1a451bc519c', 1, 0, 25, 0, 0, 0, 'jjURPhvndOGIyt1AvXHs0S05OO4oubl4Q93pfYIJx94KFr3EzMdbJ8E-u3YOo34Q', 1549886805, 1549886805),
(4, 'dee', 'dee', 'ravinder.rampelli@tacto.in', '5f4dcc3b5aa765d61d8327deb882cf99', 1, 0, 55, 1, 0, 0, 'n6JHE2xMHMAL1DJD7_mtsI819akyGuyXn3QUjvkPWgrtKzPgEA76CRsoK3Baahgr', 1549892649, 1549892133);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `mantis_api_token_table`
--
ALTER TABLE `mantis_api_token_table`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `idx_user_id_name` (`user_id`,`name`);

--
-- Indexes for table `mantis_bugnote_table`
--
ALTER TABLE `mantis_bugnote_table`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_bug` (`bug_id`),
  ADD KEY `idx_last_mod` (`last_modified`);

--
-- Indexes for table `mantis_bugnote_text_table`
--
ALTER TABLE `mantis_bugnote_text_table`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `mantis_bug_file_table`
--
ALTER TABLE `mantis_bug_file_table`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_bug_file_bug_id` (`bug_id`),
  ADD KEY `idx_diskfile` (`diskfile`);

--
-- Indexes for table `mantis_bug_history_table`
--
ALTER TABLE `mantis_bug_history_table`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_bug_history_bug_id` (`bug_id`),
  ADD KEY `idx_history_user_id` (`user_id`),
  ADD KEY `idx_bug_history_date_modified` (`date_modified`);

--
-- Indexes for table `mantis_bug_monitor_table`
--
ALTER TABLE `mantis_bug_monitor_table`
  ADD PRIMARY KEY (`user_id`,`bug_id`),
  ADD KEY `idx_bug_id` (`bug_id`);

--
-- Indexes for table `mantis_bug_relationship_table`
--
ALTER TABLE `mantis_bug_relationship_table`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_relationship_source` (`source_bug_id`),
  ADD KEY `idx_relationship_destination` (`destination_bug_id`);

--
-- Indexes for table `mantis_bug_revision_table`
--
ALTER TABLE `mantis_bug_revision_table`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_bug_rev_type` (`type`),
  ADD KEY `idx_bug_rev_id_time` (`bug_id`,`timestamp`);

--
-- Indexes for table `mantis_bug_table`
--
ALTER TABLE `mantis_bug_table`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_bug_sponsorship_total` (`sponsorship_total`),
  ADD KEY `idx_bug_fixed_in_version` (`fixed_in_version`),
  ADD KEY `idx_bug_status` (`status`),
  ADD KEY `idx_project` (`project_id`);

--
-- Indexes for table `mantis_bug_tag_table`
--
ALTER TABLE `mantis_bug_tag_table`
  ADD PRIMARY KEY (`bug_id`,`tag_id`),
  ADD KEY `idx_bug_tag_tag_id` (`tag_id`);

--
-- Indexes for table `mantis_bug_text_table`
--
ALTER TABLE `mantis_bug_text_table`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `mantis_category_table`
--
ALTER TABLE `mantis_category_table`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `idx_category_project_name` (`project_id`,`name`);

--
-- Indexes for table `mantis_config_table`
--
ALTER TABLE `mantis_config_table`
  ADD PRIMARY KEY (`config_id`,`project_id`,`user_id`);

--
-- Indexes for table `mantis_custom_field_project_table`
--
ALTER TABLE `mantis_custom_field_project_table`
  ADD PRIMARY KEY (`field_id`,`project_id`);

--
-- Indexes for table `mantis_custom_field_string_table`
--
ALTER TABLE `mantis_custom_field_string_table`
  ADD PRIMARY KEY (`field_id`,`bug_id`),
  ADD KEY `idx_custom_field_bug` (`bug_id`);

--
-- Indexes for table `mantis_custom_field_table`
--
ALTER TABLE `mantis_custom_field_table`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_custom_field_name` (`name`);

--
-- Indexes for table `mantis_email_table`
--
ALTER TABLE `mantis_email_table`
  ADD PRIMARY KEY (`email_id`);

--
-- Indexes for table `mantis_filters_table`
--
ALTER TABLE `mantis_filters_table`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `mantis_news_table`
--
ALTER TABLE `mantis_news_table`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `mantis_plugin_Calendar_events_table`
--
ALTER TABLE `mantis_plugin_Calendar_events_table`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `mantis_plugin_Calendar_event_member_table`
--
ALTER TABLE `mantis_plugin_Calendar_event_member_table`
  ADD PRIMARY KEY (`user_id`,`event_id`),
  ADD KEY `idx_event_id` (`event_id`);

--
-- Indexes for table `mantis_plugin_Calendar_google_sync_table`
--
ALTER TABLE `mantis_plugin_Calendar_google_sync_table`
  ADD PRIMARY KEY (`event_id`),
  ADD KEY `idx_event_id` (`event_id`);

--
-- Indexes for table `mantis_plugin_EmailReporting_msgids_table`
--
ALTER TABLE `mantis_plugin_EmailReporting_msgids_table`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `idx_erp_msgids_msgid` (`msg_id`);

--
-- Indexes for table `mantis_plugin_EventLog_events_table`
--
ALTER TABLE `mantis_plugin_EventLog_events_table`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_request_id` (`request_id`);

--
-- Indexes for table `mantis_plugin_EventLog_requests_table`
--
ALTER TABLE `mantis_plugin_EventLog_requests_table`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_timestamp` (`timestamp`);

--
-- Indexes for table `mantis_plugin_GaugeSupport_support_data_table`
--
ALTER TABLE `mantis_plugin_GaugeSupport_support_data_table`
  ADD PRIMARY KEY (`bugid`,`userid`);

--
-- Indexes for table `mantis_plugin_table`
--
ALTER TABLE `mantis_plugin_table`
  ADD PRIMARY KEY (`basename`);

--
-- Indexes for table `mantis_project_file_table`
--
ALTER TABLE `mantis_project_file_table`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `mantis_project_hierarchy_table`
--
ALTER TABLE `mantis_project_hierarchy_table`
  ADD UNIQUE KEY `idx_project_hierarchy` (`child_id`,`parent_id`),
  ADD KEY `idx_project_hierarchy_child_id` (`child_id`),
  ADD KEY `idx_project_hierarchy_parent_id` (`parent_id`);

--
-- Indexes for table `mantis_project_table`
--
ALTER TABLE `mantis_project_table`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `idx_project_name` (`name`),
  ADD KEY `idx_project_view` (`view_state`);

--
-- Indexes for table `mantis_project_user_list_table`
--
ALTER TABLE `mantis_project_user_list_table`
  ADD PRIMARY KEY (`project_id`,`user_id`),
  ADD KEY `idx_project_user` (`user_id`);

--
-- Indexes for table `mantis_project_version_table`
--
ALTER TABLE `mantis_project_version_table`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `idx_project_version` (`project_id`,`version`);

--
-- Indexes for table `mantis_sponsorship_table`
--
ALTER TABLE `mantis_sponsorship_table`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_sponsorship_bug_id` (`bug_id`),
  ADD KEY `idx_sponsorship_user_id` (`user_id`);

--
-- Indexes for table `mantis_tag_table`
--
ALTER TABLE `mantis_tag_table`
  ADD PRIMARY KEY (`id`,`name`),
  ADD KEY `idx_tag_name` (`name`);

--
-- Indexes for table `mantis_tokens_table`
--
ALTER TABLE `mantis_tokens_table`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_typeowner` (`type`,`owner`);

--
-- Indexes for table `mantis_user_pref_table`
--
ALTER TABLE `mantis_user_pref_table`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `mantis_user_print_pref_table`
--
ALTER TABLE `mantis_user_print_pref_table`
  ADD PRIMARY KEY (`user_id`);

--
-- Indexes for table `mantis_user_profile_table`
--
ALTER TABLE `mantis_user_profile_table`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `mantis_user_table`
--
ALTER TABLE `mantis_user_table`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `idx_user_cookie_string` (`cookie_string`),
  ADD UNIQUE KEY `idx_user_username` (`username`),
  ADD KEY `idx_enable` (`enabled`),
  ADD KEY `idx_access` (`access_level`),
  ADD KEY `idx_email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `mantis_api_token_table`
--
ALTER TABLE `mantis_api_token_table`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `mantis_bugnote_table`
--
ALTER TABLE `mantis_bugnote_table`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `mantis_bugnote_text_table`
--
ALTER TABLE `mantis_bugnote_text_table`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `mantis_bug_file_table`
--
ALTER TABLE `mantis_bug_file_table`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `mantis_bug_history_table`
--
ALTER TABLE `mantis_bug_history_table`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `mantis_bug_relationship_table`
--
ALTER TABLE `mantis_bug_relationship_table`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `mantis_bug_revision_table`
--
ALTER TABLE `mantis_bug_revision_table`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `mantis_bug_table`
--
ALTER TABLE `mantis_bug_table`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `mantis_bug_text_table`
--
ALTER TABLE `mantis_bug_text_table`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `mantis_category_table`
--
ALTER TABLE `mantis_category_table`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `mantis_custom_field_table`
--
ALTER TABLE `mantis_custom_field_table`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `mantis_email_table`
--
ALTER TABLE `mantis_email_table`
  MODIFY `email_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `mantis_filters_table`
--
ALTER TABLE `mantis_filters_table`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `mantis_news_table`
--
ALTER TABLE `mantis_news_table`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `mantis_plugin_Calendar_events_table`
--
ALTER TABLE `mantis_plugin_Calendar_events_table`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `mantis_plugin_EmailReporting_msgids_table`
--
ALTER TABLE `mantis_plugin_EmailReporting_msgids_table`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `mantis_plugin_EventLog_events_table`
--
ALTER TABLE `mantis_plugin_EventLog_events_table`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `mantis_plugin_EventLog_requests_table`
--
ALTER TABLE `mantis_plugin_EventLog_requests_table`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `mantis_project_file_table`
--
ALTER TABLE `mantis_project_file_table`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `mantis_project_table`
--
ALTER TABLE `mantis_project_table`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `mantis_project_version_table`
--
ALTER TABLE `mantis_project_version_table`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `mantis_sponsorship_table`
--
ALTER TABLE `mantis_sponsorship_table`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `mantis_tag_table`
--
ALTER TABLE `mantis_tag_table`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `mantis_tokens_table`
--
ALTER TABLE `mantis_tokens_table`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `mantis_user_pref_table`
--
ALTER TABLE `mantis_user_pref_table`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `mantis_user_profile_table`
--
ALTER TABLE `mantis_user_profile_table`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `mantis_user_table`
--
ALTER TABLE `mantis_user_table`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
