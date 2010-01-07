<?php

/**
 * Copyright (C) 2008, 2009 Michael Nowak
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
 * http://www.gnu.org/copyleft/gpl.html
**/

require_once( dirname(__FILE__) .'/LBFactory_No.php' );
require_once( "$IP/LocalSettings.php" );

class ParserStandAlone extends Parser
{
  # Override the template-fetching-function of the Parser
  function fetchTemplateAndTitle( $title ) {
    #echo "\n--- Trying to find offline template: $title ---\n";

    global $wgTemplateDB, $wgTemplateFileID;
    $finalTitle    = $title;
    $template_text = null;

    # $$$ need to fix later for all languages
    # We pad the title with '~' to force the database to import strings
    $title_orig  = '~' . $wgTemplateFileID . '~' . strtolower($title);
    $db = new PDO('sqlite:' . $wgTemplateDB);
    $tl = $db->quote($title_orig);

    #echo "\n--- ($title_orig) --- \n";

    $result = $db->query("SELECT body FROM templates WHERE title = {$tl} LIMIT 1");
    $data = $result->fetchAll();
    $max_loop_count = 25;
    while ($max_loop_count && sizeof($data) == 0) {
      $result = $db->query("SELECT redirect FROM redirects WHERE title = {$tl} LIMIT 1");
      $data = $result->fetchAll();
      if (sizeof($data) == 0) {
        break;
      }
      $redirect = $db->quote($data[0]['redirect']);
      $result = $db->query("SELECT body FROM templates WHERE title = {$redirect} LIMIT 1");
      $data = $result->fetchAll();
      --$max_loop_count;
    }

    if (sizeof($data) > 0) {
      $template_text = substr($data[0]['body'], 1);
      #echo "\n--- TT:($template_text):TT --- \n";
    } else {
      $template_text = '';
    }

    $ret = array( $template_text, $finalTitle );
    return $ret;
  }

  static public function disableSpecialPages( &$mList ) {
    $mList = array();
    return true;
  }
}
