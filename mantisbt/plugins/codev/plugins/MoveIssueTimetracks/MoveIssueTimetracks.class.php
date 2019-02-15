
<?php

/*
  This file is part of CodevTT

  CodevTT is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  CodevTT is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with CodevTT.  If not, see <http://www.gnu.org/licenses/>.
 */

/**
 * Description of MoveIssueTimetracks
 *
 * @author lob
 */
class MoveIssueTimetracks extends IndicatorPluginAbstract {


    private static $logger;
    private static $domains;
    private static $categories;
    // params from PluginDataProvider

    private $teamid;
    private $domain;
    private $sessionUserId;
    // internal
    protected $execData;

    /**
     * Initialize static variables
     * @static
     */
    public static function staticInit() {
        self::$logger = Logger::getLogger(__CLASS__);

        // A plugin can be displayed in multiple domains
        self::$domains = array(
            self::DOMAIN_ADMIN,
            self::DOMAIN_TEAM_ADMIN,
            #self::DOMAIN_USER, // warn, needs to check which timetrack the user is allowed to move
        );
        // A plugin should have only one category
        self::$categories = array(
            self::CATEGORY_ADMIN
        );
    }

    public static function getName() {
        return T_('Move Issue Timetracks');
    }

    public static function getDesc($isShortDesc = true) {
        return T_('Move timetracks from one issue to another');
    }

    public static function getAuthor() {
        return 'CodevTT (GPL v3)';
    }

    public static function getVersion() {
        return '1.0.0';
    }

    public static function getDomains() {
        return self::$domains;
    }

    public static function getCategories() {
        return self::$categories;
    }

    public static function isDomain($domain) {
        return in_array($domain, self::$domains);
    }

    public static function isCategory($category) {
        return in_array($category, self::$categories);
    }

    public static function getCssFiles() {
        return array(
        );
    }

    public static function getJsFiles() {
        return array(
            'js_min/datepicker.min.js',
            'js_min/datatable.min.js',
            'lib/select2/select2.min.js'
        );
    }

    /**
     *
     * @param \PluginDataProviderInterface $pluginMgr
     * @throws Exception
     */
    public function initialize(PluginDataProviderInterface $pluginDataProv) {


        if (NULL != $pluginDataProv->getParam(PluginDataProviderInterface::PARAM_SESSION_USER_ID)) {
            $this->sessionUserId = $pluginDataProv->getParam(PluginDataProviderInterface::PARAM_SESSION_USER_ID);
        } else {
            throw new Exception("Missing parameter: " . PluginDataProviderInterface::PARAM_SESSION_USER_ID);
        }
      if (NULL != $pluginDataProv->getParam(PluginDataProviderInterface::PARAM_TEAM_ID)) {
         $this->teamid = $pluginDataProv->getParam(PluginDataProviderInterface::PARAM_TEAM_ID);
      } else {
         throw new Exception("Missing parameter: ".PluginDataProviderInterface::PARAM_TEAM_ID);
      }
      if (NULL != $pluginDataProv->getParam(PluginDataProviderInterface::PARAM_DOMAIN)) {
         $this->domain = $pluginDataProv->getParam(PluginDataProviderInterface::PARAM_DOMAIN);
      } else {
         $this->domain = 'unknown';
      }

        // set default pluginSettings
    }

    /**
     * User preferences are saved by the Dashboard
     *
     * @param type $pluginSettings
     */
    public function setPluginSettings($pluginSettings) {

        if (NULL != $pluginSettings) {
            
        }
    }
    
    /**
     * Get timetracks corresponding to filters
     * @param integer[] $users
     * @param timestamp $beginDate
     * @param timestamp $endDate
     * @param integer $task
     * @return timetraks
     */
    public function getTimetracks($users, $beginDate, $endDate, $task)
    {
        if ($users != null && $beginDate != null && $endDate != null && $task != null) {
            $formatedUsers = implode( ', ', $users);

            $sql = AdodbWrapper::getInstance();
            $query = "SELECT * FROM codev_timetracking_table " .
                    " WHERE date >= ".$sql->db_param().
                    " AND date <= ".$sql->db_param() .
                    " AND userid IN (".$formatedUsers.")" .
                    " AND bugid =  ".$sql->db_param() .
                    " ORDER BY date";
            
            $result = $sql->sql_query($query, array($beginDate, $endDate, $task));

            $jobs = new Jobs();
            while ($row = $sql->fetchObject($result)) {
                $tt = TimeTrackCache::getInstance()->getTimeTrack($row->id, $row);

                $user = UserCache::getInstance()->getUser($tt->getUserId());
                $issue = IssueCache::getInstance()->getIssue($tt->getIssueId());

                if (!is_null($tt->getCommitterId())) {
                    $committer = UserCache::getInstance()->getUser($tt->getCommitterId());
                    $committer_name = $committer->getName();
                    $commit_date = date('Y-m-d H:i:s', $tt->getCommitDate());
                } else {
                    $committer_name = ''; // this info does not exist before v1.0.4
                    $commit_date = '';
                }

                $timeTracks[$row->id] = array(
                    'id' => $row->id,
                    'user' => $user->getName(),
                    'date' => date('Y-m-d', $tt->getDate()),
                    'job' => $jobs->getJobName($tt->getJobId()),
                    'duration' => $tt->getDuration(),
                    'timetrackNote' => nl2br(htmlspecialchars($tt->getNote())),
                    'committer' => $committer_name,
                    'commit_date' => $commit_date,
                    'task_id' => $issue->getId(),
                    'task_extRef' => $issue->getTcId(),
                    'task_summary' => $issue->getSummary(),
                );
            }
        }
        return $timeTracks;
    }
    
    /**
     * Move all selected timetracks to destination task
     * @param integer[] $timetracksIds
     * @param integer[] $destBugId
     */
    public function moveTimetracks($timetracksIds, $destBugId)
    {
        if($timetracksIds != null && $destBugId != null && $destBugId != 0)
        {
            $sql = AdodbWrapper::getInstance();
            $formatedTimetracksIds = implode( ', ', $timetracksIds);
            $destinationTask = new Issue($destBugId);
            
            // Move destination Task Creation date to older timetrack date
            $destTaskDateSubmission = $destinationTask->getDateSubmission();
            foreach($timetracksIds as $timetrackId)
            {
                $timetrack = new TimeTrack($timetrackId);
                if($timetrack->getDate() < $destTaskDateSubmission)
                {
                   $destTaskDateSubmission = $timetrack->getDate();
                }
            }
            if (NULL !== $destTaskDateSubmission) {
               $destinationTask->setDateSubmission($destTaskDateSubmission);
            }
            
            // Move all selected timetracks to destination task
            $query = "UPDATE codev_timetracking_table SET bugid= ".$sql->db_param() .
                    " WHERE id IN (".$formatedTimetracksIds.") ";
            
            $sql->sql_query($query, array($destBugId));

            // move timetrack notes
            $query2 = "UPDATE {bugnote} SET bug_id=".$sql->db_param().
                      " WHERE id in (SELECT noteid FROM codev_timetrack_note_table ".
                      "              WHERE timetrackid in (".$formatedTimetracksIds."))";
            $sql->sql_query($query2, array($destBugId));

        }
    }

    /**
     *
     * 
     */
    public function execute() {

         $team = TeamCache::getInstance()->getTeam($this->teamid);
         $session_user = UserCache::getInstance()->getUser($this->sessionUserId);
         $isAdmin = $session_user->isTeamMember(Config::getInstance()->getValue(Config::id_adminTeamId));

         if ($isAdmin && (IndicatorPluginInterface::DOMAIN_TEAM_ADMIN !== $this->domain)) {
           // Administrators can manage all teams
           $teamList = Team::getTeams(true);
           $teamMembers = $team->getMembers();
         } else {
            // others can only manage their own team
            $teamList = array($this->teamid => $team->getName());

            if (($session_user->isTeamLeader($this->teamid)) ||
                ($session_user->isTeamManager($this->teamid)) || $isAdmin) {
               // teamLeader & managers can manage all team members
               $teamMembers = $team->getMembers();
            } else {
               // others can only move their own timetracks
               $teamMembers = array($session_user->getId() => $session_user->getName());
            }
         }

        $this->execData = array(
            'teamList' => $teamList,
            'teamMembers' => $teamMembers
        );
        return $this->execData;
    }

    /**
     *
     * @param boolean $isAjaxCall
     * @return array
     */
    public function getSmartyVariables($isAjaxCall = false) {

        $availableTeams = SmartyTools::getSmartyArray($this->execData['teamList'], $this->teamid);
        $teamMembers = SmartyTools::getSmartyArray($this->execData['teamMembers'], NULL);

        $smartyVariables = array(
            'moveIssueTimetracks_availableTeams' => $availableTeams,
            'moveIssueTimetracks_teamUserList' => $teamMembers,
        );

        if (false == $isAjaxCall) {
            $smartyVariables['moveIssueTimetracks_ajaxFile'] = self::getSmartySubFilename();
            $smartyVariables['moveIssueTimetracks_ajaxPhpURL'] = self::getAjaxPhpURL();
        }
        return $smartyVariables;
    }

    public function getSmartyVariablesForAjax() {
        return $this->getSmartyVariables(true);
    }

}

// Initialize static variables
MoveIssueTimetracks::staticInit();
