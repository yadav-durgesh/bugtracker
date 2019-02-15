<?php
	require_once('api.php');
	
	require_once('core.php');
	require_once('bug_api.php');

 	/**
	 * Print issue begin
	 *
	 * @return void
	 * @author rcasteran
	 */
	function print_issue_begin() {
		echo '<table class="width100" cellspacing="1">';
		echo '<tbody>';
		echo '<tr>';
		echo '<td class="category" width="15%">', lang_get('id'), '</td>';
		echo '<td class="category" width="45%">', lang_get( 'summary' ), '</td>';
		echo '<td class="category" width="15%">', lang_get( 'assigned_to' ), '</td>';
		echo '<td class="category" width="15%">', lang_get( 'status' ), '</td>';
		echo '</tr>';
		echo '</tr>';
	} /* End of print_issue_begin() */

 	/**
	 * Print issue end
	 *
	 * @return void
	 * @author rcasteran
	 */
	function print_issue_end() {
		echo '</tbody>';
		echo '</table>';
	} /* End of print_issue_end() */	
	
 	/**
	 * Build issue list to be printed
	 *
	 * @return void
	 * @author rcasteran
	 */
	function build_issue_list( $p_version_row, $p_issue_id, $p_issue_level = 0 ) {
		global $g_issue_overload, $g_issue_workload, $g_issue_progress;
		global $g_nb_issue_overload, $g_nb_issue_workload, $g_nb_issue_progress;
		
		$t_project_id   = $p_version_row['project_id'];
		$t_version_id   = $p_version_row['id'];
		$t_version_name = $p_version_row['version'];
		$t_project_name = project_get_field( $t_project_id, 'name' );
		
		#Check custom field table
		$t_workload_est = PLUGIN_WORKLOAD_VAR_IDX_NONE;
		$t_workload_done = PLUGIN_WORKLOAD_VAR_IDX_NONE;
		$t_progress = PLUGIN_WORKLOAD_VAR_IDX_NONE;

		$t_workload_est_value = PLUGIN_WORKLOAD_VAR_DEFAULT;		
		$t_workload_done_value = PLUGIN_WORKLOAD_VAR_DEFAULT;
		$t_progress_value = PLUGIN_WORKLOAD_VAR_DEFAULT;
			
		$t_types = array(CUSTOM_FIELD_TYPE_NUMERIC);
		$t_custom_fields = get_custom_fied_ids($t_types);
		if(count($t_custom_fields) > 0) {		
			foreach ($t_custom_fields as $t_field_id) {
				if($t_field_id == plugin_config_get('workload_est_var_idx')) {
					$t_workload_est = $t_field_id;
				} else if($t_field_id == plugin_config_get('workload_done_var_idx')) {
					$t_workload_done = $t_field_id;
				} else if($t_field_id == plugin_config_get('progress_var_idx')) {
					$t_progress = $t_field_id;
				}
				/* Else do nothing */
			}
		}
		/* Else do nothing */

		if((($t_workload_est > PLUGIN_WORKLOAD_VAR_IDX_NONE) &&
			($t_workload_done > PLUGIN_WORKLOAD_VAR_IDX_NONE)) ||
			($t_progress > PLUGIN_WORKLOAD_VAR_IDX_NONE))
		{
			$t_custom_field_string_table = db_get_table('mantis_custom_field_string_table');
			$query = "SELECT $t_custom_field_string_table.field_id, $t_custom_field_string_table.value 
			FROM $t_custom_field_string_table 
			WHERE $t_custom_field_string_table.bug_id=$p_issue_id";
			$t_result = db_query_bound( $query );		
			while ( $t_row = db_fetch_array( $t_result ) ) {
				if(strlen($t_row['value']) > 0) {
					if($t_row['field_id'] == $t_workload_est) {					
						$t_workload_est_value = $t_row['value'];
					} else if($t_row['field_id'] == $t_workload_done) {
						$t_workload_done_value = $t_row['value'];
					} else if($t_row['field_id'] == $t_progress) {
						$t_progress_value = $t_row['value'];
					}
					/* Else do nothing */					
				}
				/* Else do nothing */
			}
		}
		/* Else do nothing */
		
		#Retrieve bug properties
		$t_bug = bug_get( $p_issue_id );
		
		if(($t_workload_est_value != PLUGIN_WORKLOAD_VAR_DEFAULT) && 
			($t_workload_done_value != PLUGIN_WORKLOAD_VAR_DEFAULT))
		{
			$t_remaining = 0;
			if($t_workload_est_value > 0) { 
				if ($t_workload_done_value < $t_workload_est_value) {
					$t_remaining = round((($t_workload_est_value - $t_workload_done_value) / $t_workload_est_value) * 100, 2);
				} else {
					$t_remaining = 100;
				}
			}
			/* Else do nothing */
			
			log_workload_event('Configuration - remaining workload: '.$t_remaining);	
			if($t_bug->status >= plugin_config_get('workload_status_threshold') && 
				$t_remaining > plugin_config_get( 'workload_status_level' ))
			{
				if( !isset( $t_status[$t_bug->status] ) ) {
					$t_status[$t_bug->status] = get_enum_element( 'status', $t_bug->status, auth_get_current_user_id(), $t_bug->project_id );
				}
				
				#Display bug properties
				if($t_remaining < 100) {
					$g_issue_workload = $g_issue_workload.'<tr '.helper_alternate_class().'>';
					$g_issue_workload = $g_issue_workload.
						'<td>'.string_get_bug_view_link( $p_issue_id ).'</td>'.
						'<td>'.string_display_line_links( $t_bug->summary ).'</td>';
					
					if( $t_bug->handler_id != 0 ) {
						$g_issue_workload = $g_issue_workload.'<td><a href="'.plugin_page('main', false).'&handler_id='.$t_bug->handler_id.'">'.string_display_line(user_get_name($t_bug->handler_id)).'</a></td>';
					} else {
						$g_issue_workload = $g_issue_workload.'<td/>';
					}
						
					$g_issue_workload = $g_issue_workload.'<td bgcolor="'.get_status_color( $t_bug->status ).'">'.$t_status[$t_bug->status].'</td>';
					$g_issue_workload = $g_issue_workload.'</tr>';
					$g_nb_issue_workload++;
				} else {
					$g_issue_overload = $g_issue_overload.'<tr '.helper_alternate_class().'>';
					$g_issue_overload = $g_issue_overload.
						'<td>'.string_get_bug_view_link( $p_issue_id ).'</td>'.
						'<td>'.string_display_line_links( $t_bug->summary ).'</td>';
					
					if( $t_bug->handler_id != 0 ) {
						$g_issue_overload = $g_issue_overload.'<td><a href="'.plugin_page('main', false).'&handler_id='.$t_bug->handler_id.'">'.string_display_line(user_get_name($t_bug->handler_id)).'</a></td>';
					} else {
						$g_issue_overload = $g_issue_overload.'<td/>';
					}
						
					$g_issue_overload = $g_issue_overload.'<td bgcolor="'.get_status_color( $t_bug->status ).'">'.$t_status[$t_bug->status].'</td>';
					$g_issue_overload = $g_issue_overload.'</tr>';
					$g_nb_issue_overload++;
				}
			}
			/* Else do nothing */
		}
		/* Else do nothing */
		
		if($t_progress_value != PLUGIN_WORKLOAD_VAR_DEFAULT)
		{
			if($t_bug->status >= plugin_config_get('progress_status_threshold') && 
				$t_progress_value < plugin_config_get( 'progress_status_level' ))
			{
				if( !isset( $t_status[$t_bug->status] ) ) {
					$t_status[$t_bug->status] = get_enum_element( 'status', $t_bug->status, auth_get_current_user_id(), $t_bug->project_id );
				}
				
				#Display bug properties
				$g_issue_progress = $g_issue_progress.'<tr '.helper_alternate_class().'>';
				$g_issue_progress = $g_issue_progress.
					'<td>'.string_get_bug_view_link( $p_issue_id ).'</td>'.
					'<td>'.string_display_line_links( $t_bug->summary ).'</td>';
				
				if( $t_bug->handler_id != 0 ) {
					$g_issue_progress = $g_issue_progress.'<td><a href="'.plugin_page('main', false).'&handler_id='.$t_bug->handler_id.'">'.string_display_line(user_get_name($t_bug->handler_id)).'</a></td>';
				} else {
					$g_issue_progress = $g_issue_progress.'<td/>';
				}
					
				$g_issue_progress = $g_issue_progress.'<td bgcolor="'.get_status_color( $t_bug->status ).'">'.$t_status[$t_bug->status].'</td>';
				$g_issue_progress = $g_issue_progress.'</tr>';
				$g_nb_issue_progress++;
			}
			/* Else do nothing */
		}
		/* Else do nothing */					
	} /* End of build_issue_list() */
	
	/**
	 * Print header for the specified project version
	 *
	 * @return void
	 * @author rcasteran
	 */
	function print_version_header( $p_version_row ) {
		$t_project_id   = $p_version_row['project_id'];
		$t_version_id   = $p_version_row['id'];
		$t_version_name = $p_version_row['version'];
		$t_project_name = project_get_field( $t_project_id, 'name' );

		$t_release_title = '<a href="'.plugin_page('main', false).'&project_id=' . $t_project_id . '">' . string_display_line( $t_project_name ) . '</a> - <a href="'.plugin_page('main', false).'&version_id=' . $t_version_id . '">' . string_display_line( $t_version_name ) . '</a>';

		if ( config_get( 'show_roadmap_dates' ) ) {
			$t_version_timestamp = $p_version_row['date_order'];

			$t_scheduled_release_date = ' (' . lang_get( 'scheduled_release' ) . ' ' . string_display_line( date( config_get( 'short_date_format' ), $t_version_timestamp ) ) . ')';
		} else {
			$t_scheduled_release_date = '';
		}

		echo '<tt>';
		echo '<br />', $t_release_title, $t_scheduled_release_date, lang_get( 'word_separator' ), '<br />';

		$t_release_title_without_hyperlinks = $t_project_name . ' - ' . $t_version_name . $t_scheduled_release_date;
		echo utf8_str_pad( '', utf8_strlen( $t_release_title_without_hyperlinks ), '=' ), '<br />';
	} /* End of print_version_header() */

	/**
	 * Print project header
	 *
	 * @return void
	 * @author rcasteran
	 */
	function print_project_header_roadmap( $p_project_name ) {
		echo '<br /><span class="pagetitle">', string_display( $p_project_name ), ' - ', lang_get( 'roadmap' ), '</span><br />';
	} /* End of print_project_header_roadmap() */

	# Retrieve current user identifier
	$t_user_id = auth_get_current_user_id();

	# Retrieve project identifier	
	$f_project = gpc_get_string( 'project', '' );
	if ( is_blank( $f_project ) ) {
		$f_project_id = gpc_get_int( 'project_id', -1 );
	} else {
		$f_project_id = project_get_id_by_name( $f_project );

		if ( $f_project_id === 0 ) {
			trigger_error( ERROR_PROJECT_NOT_FOUND, ERROR );
		}
		/* Else do nothing */
	}

	# Retrieve project version identifier
	$f_version = gpc_get_string( 'version', '' );
	if ( is_blank( $f_version ) ) {
		$f_version_id = gpc_get_int( 'version_id', -1 );

		# If both version_id and project_id parameters are supplied, then version_id take precedence.
		if ( $f_version_id == -1 ) {
			if ( $f_project_id == -1 ) {
				$t_project_id = helper_get_current_project();
			} else {
				$t_project_id = $f_project_id;
			}
		} else {
			$t_project_id = version_get_field( $f_version_id, 'project_id' );
		}
	} else {
		if ( $f_project_id == -1 ) {
			$t_project_id = helper_get_current_project();
		} else {
			$t_project_id = $f_project_id;
		}

		$f_version_id = version_get_id( $f_version, $t_project_id );

		if ( $f_version_id === false ) {
			error_parameters( $f_version );
			trigger_error( ERROR_VERSION_NOT_FOUND, ERROR );
		}
		/* Else do nothing */
	}
	log_traceability_event('Main - project identifier: '.$f_project_id);
	log_traceability_event('Main - project version: '.$f_version);
	
	# Retrieve issue handler identifier
	$f_handler_id = gpc_get_int( 'handler_id', -1 );

	# Check user access to project	
	if ( ALL_PROJECTS == $t_project_id ) {
		$t_topprojects = $t_project_ids = user_get_accessible_projects( $t_user_id );
		foreach ( $t_topprojects as $t_project ) {
			$t_project_ids = array_merge( $t_project_ids, user_get_all_accessible_subprojects( $t_user_id, $t_project ) );
		}

		$t_project_ids_to_check = array_unique( $t_project_ids );
		$t_project_ids = array();

		foreach ( $t_project_ids_to_check as $t_project_id ) {
			$t_roadmap_view_access_level = config_get( 'roadmap_view_threshold', null, null, $t_project_id );
			if ( access_has_project_level( $t_roadmap_view_access_level, $t_project_id ) ) {
				$t_project_ids[] = $t_project_id;
			}
		}
	} else {
		access_ensure_project_level( config_get( 'roadmap_view_threshold' ), $t_project_id );
		$t_project_ids = user_get_all_accessible_subprojects( $t_user_id, $t_project_id );
		array_unshift( $t_project_ids, $t_project_id );
	}
	log_traceability_event('Main - project identifiers count: '.count($t_project_ids));

	html_page_top( lang_get( 'plugin_workload_menu' ) );

	print_workload_menu('main.php', $f_project_id, $f_version_id, $f_handler_id);
	
	$t_project_index = 0;
	$t_nb_project_header_printed = 0;

	version_cache_array_rows( $t_project_ids );
	category_cache_array_rows_by_project( $t_project_ids );
	
	foreach( $t_project_ids as $t_project_id ) {
		$t_project_name = project_get_field( $t_project_id, 'name' );
		log_traceability_event('Main - project name: '.$t_project_name);
		
		$t_can_view_private = access_has_project_level( config_get( 'private_bug_threshold' ), $t_project_id );

		$t_limit_reporters = config_get( 'limit_reporters' );
		$t_user_access_level_is_reporter = ( REPORTER == access_get_project_level( $t_project_id ) );

		$t_resolved = config_get( 'bug_resolved_status_threshold' );
		$t_bug_table	= db_get_table( 'mantis_bug_table' );
		$t_relation_table = db_get_table( 'mantis_bug_relationship_table' );

		$t_version_rows = array_reverse( version_get_all_rows( $t_project_id ) );
		log_traceability_event('Main - project versions count: '.count($t_version_rows));

		# cache category info, but ignore the results for now
		category_get_all_rows( $t_project_id );

		$t_project_header_printed = false;

		foreach( $t_version_rows as $t_version_row ) {
			if ( $t_version_row['released'] == 1 ) {
				continue;
			}

			# Skip all versions except the specified one (if any).
			if ( $f_version_id != -1 && $f_version_id != $t_version_row['id'] ) {
				continue;
			}

			$t_issues_planned = 0;
			$t_issues_resolved = 0;
			$t_issues_counted = array();

			$t_version_header_printed = false;

			$t_version = $t_version_row['version'];

			$query = "SELECT sbt.*, $t_relation_table.source_bug_id, dbt.target_version as parent_version FROM $t_bug_table AS sbt
						LEFT JOIN $t_relation_table ON sbt.id=$t_relation_table.destination_bug_id AND $t_relation_table.relationship_type=2
						LEFT JOIN $t_bug_table AS dbt ON dbt.id=$t_relation_table.source_bug_id
						WHERE sbt.project_id=" . db_param() . " AND sbt.target_version=" . db_param() . " ORDER BY sbt.status ASC, sbt.last_updated DESC";

			$t_description = $t_version_row['description'];

			$t_first_entry = true;

			$t_result = db_query_bound( $query, Array( $t_project_id, $t_version ) );

			$t_issue_ids = array();
			$t_issue_parents = array();
			$t_issue_handlers = array();

			while ( $t_row = db_fetch_array( $t_result ) ) {
				# hide private bugs if user doesn't have access to view them.
				if ( !$t_can_view_private && ( $t_row['view_state'] == VS_PRIVATE ) ) {
					continue;
				}

				bug_cache_database_result( $t_row );

				# Skip all handler_ids except the specified one (if any).
				if($f_handler_id != -1 && $t_row['handler_id'] != $f_handler_id) {
					continue;
				}
				
				# check limit_Reporter (Issue #4770)
				# reporters can view just issues they reported
				if ( ON === $t_limit_reporters && $t_user_access_level_is_reporter &&
					 !bug_is_user_reporter( $t_row['id'], $t_user_id )) {
					continue;
				}

				$t_issue_id = $t_row['id'];
				$t_issue_parent = $t_row['source_bug_id'];
				$t_parent_version = $t_row['parent_version'];

				if ( !helper_call_custom_function( 'roadmap_include_issue', array( $t_issue_id ) ) ) {
					continue;
				}

				if ( !isset( $t_issues_counted[$t_issue_id] ) ) {
					$t_issues_planned++;

					if ( bug_is_resolved( $t_issue_id ) ) {
						$t_issues_resolved++;
					}

					$t_issues_counted[$t_issue_id] = true;
				}

				if ( 0 === strcasecmp( $t_parent_version, $t_version ) ) {
					$t_issue_ids[] = $t_issue_id;
					$t_issue_parents[] = $t_issue_parent;
				} else if ( !in_array( $t_issue_id, $t_issue_ids ) ) {
					$t_issue_ids[] = $t_issue_id;
					$t_issue_parents[] = null;
				}

				$t_issue_handlers[] = $t_row['handler_id'];
			}

			user_cache_array_rows( array_unique( $t_issue_handlers ) );

			if ( $t_issues_planned > 0 ) {
 				if ( !$t_project_header_printed ) {
					print_project_header_roadmap( $t_project_name );
					$t_project_header_printed = true;
					$t_nb_project_header_printed++;
				}

				if ( !$t_version_header_printed ) {
					print_version_header( $t_version_row );
					$t_version_header_printed = true;
				}
			}

			$t_issue_set_ids = array();
			$t_issue_set_levels = array();
			$k = 0;

			$t_cycle = false;
			$t_cycle_ids = array();

			while ( 0 < count( $t_issue_ids ) ) {
				$t_issue_id = $t_issue_ids[$k];
				$t_issue_parent = $t_issue_parents[$k];

				if ( in_array( $t_issue_id, $t_cycle_ids ) && in_array( $t_issue_parent, $t_cycle_ids ) ) {
					$t_cycle = true;
				} else {
					$t_cycle = false;
					$t_cycle_ids[] = $t_issue_id;
				}

				if ( $t_cycle || !in_array( $t_issue_parent, $t_issue_ids ) ) {
					$l = array_search( $t_issue_parent, $t_issue_set_ids );
					if ( $l !== false ) {
						for ( $m = $l+1; $m < count( $t_issue_set_ids ) && $t_issue_set_levels[$m] > $t_issue_set_levels[$l]; $m++ ) {
							#do nothing
						}
						$t_issue_set_ids_end = array_splice( $t_issue_set_ids, $m );
						$t_issue_set_levels_end = array_splice( $t_issue_set_levels, $m );
						$t_issue_set_ids[] = $t_issue_id;
						$t_issue_set_levels[] = $t_issue_set_levels[$l] + 1;
						$t_issue_set_ids = array_merge( $t_issue_set_ids, $t_issue_set_ids_end );
						$t_issue_set_levels = array_merge( $t_issue_set_levels, $t_issue_set_levels_end );
					} else {
						$t_issue_set_ids[] = $t_issue_id;
						$t_issue_set_levels[] = 0;
					}
					array_splice( $t_issue_ids, $k, 1 );
					array_splice( $t_issue_parents, $k, 1 );

					$t_cycle_ids = array();
				} else {
					$k++;
				}
				if ( count( $t_issue_ids ) <= $k ) {
					$k = 0;
				}
			}

			$t_count_ids = count( $t_issue_set_ids );			
			if($t_count_ids > 0)
			{
				$g_issue_overload = '';
				$g_nb_issue_overload = 0;
				$g_issue_workload = '';
				$g_nb_issue_workload = 0;
				$g_issue_progress = '';
				$g_nb_issue_progress = 0;
				
				for ( $j = 0; $j < $t_count_ids; $j++ ) {
					$t_issue_set_id = $t_issue_set_ids[$j];
					$t_issue_set_level = $t_issue_set_levels[$j];
	
					build_issue_list( $t_version_row, $t_issue_set_id, $t_issue_set_level );
				}

				if($g_nb_issue_overload > 0)
				{
					echo '<div>'.lang_get('plugin_workload_warning').': '.$g_nb_issue_overload.' '.lang_get('plugin_workload_warning_overload').':</br>';
					print_issue_begin();
					echo $g_issue_overload;
					print_issue_end();
					echo '</div>';
				}
				/* Else do nothing */
				
				if($g_nb_issue_workload > 0)
				{
					echo '<div>'.lang_get('plugin_workload_warning').': '.$g_nb_issue_workload.' '.lang_get('plugin_workload_warning_workload').':</br>';
					print_issue_begin();
					echo $g_issue_workload;
					print_issue_end();
					echo '</div>';
				}
				/* Else do nothing */
				
				if($g_nb_issue_progress > 0)
				{
					echo '<div>'.lang_get('plugin_workload_warning').': '.$g_nb_issue_progress.' '.lang_get('plugin_workload_warning_progress').':</br>';
					print_issue_begin();
					echo $g_issue_progress;
					print_issue_end();
					echo '</div>';
				}
				/* Else do nothing */
				
				if(($g_nb_issue_overload == 0) && ($g_nb_issue_workload == 0) && ($g_nb_issue_progress == 0))
				{
					echo '<div>'.lang_get('plugin_workload_warning_none').'</div>';
				}
				/* Else do nothing */
			}		

			if ( $t_project_header_printed || $t_version_header_printed) {
				echo '</tt>';
			}
		}
		$t_project_index++;
	}
	
	# At least warn user that no project roadmap is available
	if($t_nb_project_header_printed == 0) {
		log_traceability_event('Main - no project roadmap available');

		echo '<div>'.lang_get('plugin_workload_warning_roadmap').'</div>';		
	}
	/* Else do nothing */
	
	html_page_bottom();
?>