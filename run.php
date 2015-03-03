<?php
$config = array();
include('config.php');

//first install mysql
//first seed the debconf database to enter mysql password automatically
$cmd = "debconf-set-selections <<< 'mysql-server mysql-server/root_password password {$config['mysql-password']}'";
shell_exec($cmd);

$cmd = "debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password {$config['mysql-password']}'";
shell_exec($cmd);
return

$cmd = "apt-get install -y mysql-server";

