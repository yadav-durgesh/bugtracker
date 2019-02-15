<?php
# Copyright (C) 2008	Victor Boctor
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

require_once( config_get( 'plugin_path' ) . 'EventLog/core/request_api.php' );
require_once( config_get( 'plugin_path' ) . 'EventLog/core/event_api.php' );

access_ensure_global_level( plugin_config_get( 'view_threshold' ) ); 

event_clear_all();
request_clear_all();

$t_redirect_url = plugin_page( 'index', /* redirect */ true );

layout_page_header( plugin_lang_get( 'title' ) );
layout_page_begin( $t_redirect_url );

echo '<br /><div align="center">';
echo lang_get( 'operation_successful' ).'<br />';
print_form_button( $t_redirect_url, lang_get( 'proceed' ) );
echo '</div>';

layout_page_end();

