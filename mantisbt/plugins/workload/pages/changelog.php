<?php
	require_once('api.php');
	
	require_once('core.php');

 	/**
	 * Print issue begin
	 *
	 * @return void
	 * @author rcasteran
	 */
	function print_issue_begin() {
		global $g_time_est, $g_time_done;

		$g_time_est = PLUGIN_WORKLOAD_PRINT_ISSUE_WORKLOAD_DEFAULT;
		$g_time_done = PLUGIN_WORKLOAD_PRINT_ISSUE_WORKLOAD_DEFAULT;
		
		echo '<table class="width100" cellspacing="1">';
		echo '<tbody>';
		echo '<tr>';
		echo '<td class="category" width="15%">', lang_get('email_project'), '</td>';
		echo '<td class="category" width="15%">', lang_get('product_version'), '</td>';
		echo '<td class="category" width="10%">', lang_get('id'), '</td>';
		echo '<td class="category" width="30%">', lang_get('summary'), '</td>';
		echo '<td class="category" width="10%">', lang_get('assigned_to'), '</td>';
		echo '<td class="category" width="10%">', lang_get('status'), '</td>';		
		echo '<td class="category" width="10%">', lang_get('plugin_workload_menu'), '</td>';
		echo '</tr>';
	} /* End of print_issue_begin() */
	
 	/**
	 * Print issue and increment workload/overload if needed
	 *
	 * @return void
	 * @author rcasteran
	 */
	function print_issue( $p_version_row, $p_issue_id, $p_issue_level = 0 ) {
		global $g_time_est, $g_time_done;
		
		$t_project_id   = $p_version_row['project_id'];
		$t_version_id   = $p_version_row['id'];
		$t_version_name = $p_version_row['version'];
		$t_project_name = project_get_field( $t_project_id, 'name' );
		
		#Check custom field table
		$t_time_est_id = 0;
		$t_time_done_id = 0;
		
		$t_types = array(CUSTOM_FIELD_TYPE_NUMERIC);		
		$t_custom_fields = get_custom_fied_ids($t_types);
		if(count($t_custom_fields) > 0) {		
			foreach ($t_custom_fields as $t_field_id) {
				if($t_field_id == plugin_config_get('workload_est_var_idx')) {
					$t_time_est_id = $t_field_id;
				} else if($t_field_id == plugin_config_get('workload_done_var_idx')) {
					$t_time_done_id = $t_field_id;
				}
				/* Else do nothing */				
			}	
		}
		/* Else do nothing */

		#Check custom field value if necessary
		$t_time_est = PLUGIN_WORKLOAD_PRINT_ISSUE_TIME_DEFAULT;
		$t_time_done = PLUGIN_WORKLOAD_PRINT_ISSUE_TIME_DEFAULT;
		 		
		if($t_time_est_id > 0 && $t_time_done_id > 0)
		{
			$t_custom_field_string_table = db_get_table('mantis_custom_field_string_table');
			$query = "SELECT $t_custom_field_string_table.field_id, $t_custom_field_string_table.value 
			FROM $t_custom_field_string_table 
			WHERE $t_custom_field_string_table.bug_id=$p_issue_id";
			$t_result = db_query_bound( $query );		
			while ( $t_row = db_fetch_array( $t_result ) ) {
				if($t_row['field_id'] == $t_time_est_id) {
					$t_time_est=$t_row['value'];
				}
				else if($t_row['field_id'] == $t_time_done_id) {
					$t_time_done=$t_row['value'];
				}
			}
			
			if($t_time_est != PLUGIN_WORKLOAD_PRINT_ISSUE_TIME_DEFAULT) {
				$t_delta = $t_time_est - $t_time_done;
				
				if($g_time_done == PLUGIN_WORKLOAD_PRINT_ISSUE_WORKLOAD_DEFAULT) {
					$g_time_done = $t_time_done;
					$g_time_est = $t_time_est;						
				} else {
					$g_time_done += $t_time_done;
					$g_time_est += $t_time_est;												
				}
			} else {
				$t_delta = lang_get('plugin_workload_not_available');
			}
		}
		else 
		{
			$t_delta = lang_get('plugin_workload_not_found');
		}
		
		#Retrieve bug properties
		$t_bug = bug_get( $p_issue_id );
	
		if( !isset( $t_status[$t_bug->status] ) ) {
			$t_status[$t_bug->status] = get_enum_element( 'status', $t_bug->status, auth_get_current_user_id(), $t_bug->project_id );
		}
		
		#Display bug properties
		echo '<tr ', helper_alternate_class(), '>';
		echo '<td>', '<a href="'.plugin_page('changelog', false).'&project_id='.$t_project_id.'">'.string_display_line($t_project_name).'</a>', '</td>';
		echo '<td>', '<a href="'.plugin_page('changelog', false).'&version_id='.$t_version_id.'">'.string_display_line($t_version_name).'</a>', '</td>';
		echo '<td>', string_get_bug_view_link( $p_issue_id ), '</td>';
		echo '<td>', string_display_line_links( $t_bug->summary ), '</td>';
		
		if( $t_bug->handler_id != 0 ) {
			echo '<td>', '<a href="'.plugin_page('changelog', false).'&handler_id='.$t_bug->handler_id.'">'.string_display_line(user_get_name($t_bug->handler_id)).'</a>', '</td>';
		} else {
			echo '<td/>';
		}
			
		echo '<td bgcolor="', get_status_color( $t_bug->status ), '">', $t_status[$t_bug->status], '</td>';
		if(is_numeric($t_delta)) {
			if($t_delta > 0) {		
				echo '<td>', $t_time_done, ' (-', $t_delta, ')</td>';
			} else {
				echo '<td>', $t_time_done, ' (+',  abs($t_delta), ')</td>';
			}
		} else {
			echo '<td>', $t_delta, '</td>';
		}
		echo '</tr>';
	} /* End of print_issue() */
	
 	/**
	 * Print issue end
	 *
	 * @return void
	 * @author rcasteran
	 */
	function print_issue_end() {
		global $g_time_est, $g_time_done;
		
		$t_workload = PLUGIN_WORKLOAD_PRINT_ISSUE_WORKLOAD_DEFAULT;
		
		echo '<tr ', helper_alternate_class(), '>';
		echo '<td class="category" colspan="6">'.lang_get('plugin_workload_overall').'</td>';
		if($g_time_est == PLUGIN_WORKLOAD_PRINT_ISSUE_WORKLOAD_DEFAULT) {
			log_workload_event('Changelog - overall workload not available');			
			
			echo '<td>'.lang_get('plugin_workload_not_available').'</td>';
		} else if(is_numeric($g_time_est) && ($g_time_est > 0)) {
			$t_workload = $g_time_est - $g_time_done;
			
			if($t_workload > 0) {		
				echo '<td>', $g_time_done, ' (-', $t_workload, ')</td>';
			} else {
				echo '<td>', $g_time_done, ' (+', abs($t_workload), ')</td>';
			}
			
			log_workload_event('Changelog - overall workload: '.$g_time_done);			
		} else {
			log_workload_event('Changelog - no computed overall workload');			

			echo '<td>'.lang_get('plugin_workload_none').'</td>';
		}
		
		echo '</tbody>';
		echo '</table>';
	} /* End of print_issue_end() */	

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
	}
	log_workload_event('Changelog - project identifier: '.$t_project_id);
	log_workload_event('Changelog - project version: '.$f_version_id);
	
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
	log_workload_event('Changelog - project identifiers count: '.count($t_project_ids));

	html_page_top( lang_get( 'plugin_workload_menu' ) );

	# $f_project_id references to current project filter
	print_workload_menu('changelog.php', $f_project_id, $f_version_id, $f_handler_id);

	$t_project_index = 0;
	echo '<br/>';

	version_cache_array_rows( $t_project_ids );
	category_cache_array_rows_by_project( $t_project_ids );

	print_issue_begin();
	
	foreach( $t_project_ids as $t_project_id ) {
		$t_project_name = project_get_field( $t_project_id, 'name' );
		$t_can_view_private = access_has_project_level( config_get( 'private_bug_threshold' ), $t_project_id );

		$t_limit_reporters = config_get( 'limit_reporters' );
		$t_user_access_level_is_reporter = ( REPORTER == access_get_project_level( $t_project_id ) );

		$t_resolved = config_get( 'bug_resolved_status_threshold' );
		$t_bug_table	= db_get_table( 'mantis_bug_table' );
		$t_relation_table = db_get_table( 'mantis_bug_relationship_table' );

		$t_version_rows = array_reverse( version_get_all_rows( $t_project_id ) );

		# cache category info, but ignore the results for now
		category_get_all_rows( $t_project_id );

		foreach( $t_version_rows as $t_version_row ) {
			if ( $t_version_row['released'] == 0 ) {
				continue;
			}

			# Skip all versions except the specified one (if any).
			if ( $f_version_id != -1 && $f_version_id != $t_version_row['id'] ) {
				continue;
			}

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
				for ( $j = 0; $j < $t_count_ids; $j++ ) {
					$t_issue_set_id = $t_issue_set_ids[$j];
					$t_issue_set_level = $t_issue_set_levels[$j];
	
					print_issue( $t_version_row, $t_issue_set_id, $t_issue_set_level );
				}
			}		
		}
		$t_project_index++;
	}

	print_issue_end();

	html_page_bottom();
?>