<?php
require('../../include/session.inc.php');

/*
   This file is part of CoDev-Timetracking.

   CoDev-Timetracking is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   CoDev-Timetracking is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with CoDev-Timetracking.  If not, see <http://www.gnu.org/licenses/>.
*/
require('../../path.inc.php');

// Note: i18n is included by the Controler class, but Ajax dos not use it...
require_once('i18n/i18n.inc.php');

if(Tools::isConnectedUser() && filter_input(INPUT_POST, 'action')) {

   $logger = Logger::getLogger("TimetrackList_ajax");
   $teamid = isset($_SESSION['teamid']) ? $_SESSION['teamid'] : 0;
   $session_user = $_SESSION['userid'];

   $action = Tools::getSecurePOSTStringValue('action', 'none');
   
   if(isset($action)) {
      $smartyHelper = new SmartyHelper();
      $team = TeamCache::getInstance()->getTeam($teamid);
      
      // ================================================================
      if('getEditTimetrackData' == $action) {

         $timetrackId = Tools::getSecurePOSTStringValue('timetrackId');
         try {
            $tt = TimeTrackCache::getInstance()->getTimeTrack($timetrackId);
            $issue = IssueCache::getInstance()->getIssue($tt->getIssueId());

            // return data
            $data = array(
               'statusMsg' => 'SUCCESS',
               'note' => $tt->getNote(),
               'issueSummary' => $issue->getSummary(),
               'noteIsMandatory' => $team->getGeneralPreference('isTrackNoteMandatory')
            );
         } catch (Exception $e) {
            $data = array(
               'statusMsg' => 'Could not get timetrack data',
            );
         }
         $jsonData = json_encode($data);
         // return data
         echo $jsonData;

      } else if('setEditTimetrackData' == $action) {

            //////////////// UPDATE //////////////////
            $timetrackId = Tools::getSecurePOSTIntValue('timetrackId');
            $team = TeamCache::getInstance()->getTeam($teamid);
            $tt = TimeTrackCache::getInstance()->getTimeTrack($timetrackId);

            // Info: no need to sql_real_escape_string, it is applied in the setNote method...
            $note = filter_input(INPUT_POST, 'note'); // filter_input to handle escaped chars (quotes, \n, ...)

            $updateDone = $tt->update($tt->getDate(), $tt->getDuration(), $tt->getJobId(), $note);

            $statusMsg = ($updateDone) ? "SUCCESS" : "timetrack update failed.";

            $data = array(
               'statusMsg' => $statusMsg,
               'note' => nl2br(htmlspecialchars($tt->getNote())),
            );
            $jsonData = json_encode($data);

            // return data
            echo $jsonData;

      } else {
         Tools::sendNotFoundAccess();
      }
   } else {
      Tools::sendUnauthorizedAccess();
   }
}


