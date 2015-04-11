class blackfire (
    $server_id = '',
    $server_token = '',
) {
    class { '::blackfire::agent':
       server_id => $server_id,
       server_token => $server_token
    } ~> class { '::blackfire::php': }
}
