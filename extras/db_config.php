<?php
    $db_type = 'sqlite';
    $git_sqlite_trunk = dirname(dirname(__FILE__));
    $db_name = "$git_sqlite_trunk/net.db";
    $id_mode = 'id_only';
    $fields_to_make_selects = array(
        'entity_id',
        'tag_id',
    );
    $minimal_fields_by_table = array(
        'tag2entity' => array(
            'id',
            'time_added',
            'tag_id',
            'entity_id',
        ),
    );
