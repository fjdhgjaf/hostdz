<?php
//ini_set('error_reporting', E_ALL);
//ini_set('display_errors', '1');
if ($_GET){
?>
<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML 2.0//EN">
<html><head>
<title>404 Not Found</title>
</head><body>
<h1>Not Found</h1>
<p>The requested URL /sboxapi was not found on this server.</p>
</body></html>
<?php
}elseif ($_POST["mit"] == "install"){
	if($_POST["c"] == "deluge"){
		$shell = shell_exec("bash /etc/bbox/installDeluge {$_POST["u"]} {$_POST["pw"]}");
	}elseif($_POST["c"] == "transmission"){
		$shell = shell_exec("bash /etc/bbox/InstallTransmission {$_POST["u"]} {$_POST["pw"]}");
	}elseif($_POST["c"] == "utorrent"){
		$shell = shell_exec("bash /etc/bbox/InstallUtorrent {$_POST["u"]} {$_POST["pw"]}");
	}elseif($_POST["c"] == "vpn"){
		$shell = shell_exec("bash /etc/bbox/InstallOpenVPN {$_POST["u"]} {$_POST["pw"]}");
	}elseif($_POST["c"] == "vnc"){
		$shell = shell_exec("bash /etc/bbox/InstallVNC {$_POST["u"]} {$_POST["pw"]}");
	}elseif($_POST["c"] == "bitorrentsync"){
		$shell = shell_exec("bash /etc/bbox/InstallBitorrentsync {$_POST["u"]} {$_POST["pw"]}");
	}elseif($_POST["c"] == "nzbget"){
		$shell = shell_exec("bash /etc/bbox/InstallNZBGet {$_POST["u"]} {$_POST["pw"]}");
	}elseif($_POST["c"] == "subsonic"){
		$shell = shell_exec("bash /etc/bbox/InstallSubsonic {$_POST["u"]} {$_POST["pw"]}");
	}elseif($_POST["c"] == "sabnzbd"){
		$shell = shell_exec("bash /etc/bbox/installSABnzbd {$_POST["u"]} {$_POST["pw"]}");
	}elseif($_POST["c"] == "rapidleech"){
		$shell = shell_exec("bash /etc/bbox/installRapidleech {$_POST["u"]} {$_POST["pw"]}");
	}elseif($_POST["c"] == "plex"){
		$shell = shell_exec("bash /etc/bbox/InstallPlex {$_POST["u"]} {$_POST["pw"]}");
	}
}elseif ($_POST["mit"] == "delete"){
	if($_POST["c"] == "deluge"){
		$shell = shell_exec("bash rm -rf /home/{$_POST["u"]}/.config/deluge {$_POST["u"]}");
	}elseif($_POST["c"] == "transmission"){
		$shell = shell_exec("bash sudo apt-get --purge remove transmission-cli transmission-common transmission-daemon");
	}elseif($_POST["c"] == "utorrent"){
		$shell = shell_exec("bash rm -rf /usr/bin/utserver | rm -rf /home/{$_POST["u"]}/.utserver | killall -u {$_POST["u"]} utserver");
	}elseif($_POST["c"] == "vpn"){
		$shell = shell_exec("bash clear");
	}
}elseif ($_POST["mit"] == "restart"){
	if($_POST["c"] == "rtorrent"){
		$shell = shell_exec("bash rm -rf /home/{$_POST["u"]}/downloads/.session/rtorrent.lock");
//		$shell = shell_exec('sudo su --login --command "kill -9 -1" '.$_POST["u"].' ');
		$shell = shell_exec("sudo su --login --command \"killall screen\" {$_POST["u"]}");
		$shell = shell_exec("sudo su --login --command \"screen -d -m -S rtorrent rtorrent\" {$_POST["u"]}");
		//$shell = shell_exec("sudo reboot_bbuser {$_POST["u"]}");
		//$shell = shell_exec("sudo su --login --command \"screen -wipe\" {$_POST["u"]}");
		//$shell = shell_exec('sudo su --login --command "kill -9 -1" '.$_POST["u"].' ');
		//$shell = shell_exec('sudo su --login --command "screen -d -m -S rtorrent rtorrent" '.$_POST["u"].'');
	}elseif($_POST["c"] == "deluge"){
		$shell = shell_exec("sudo su --login --command 'killall deluged' {$_POST["u"]}");
		$shell = shell_exec("sudo su --login --command 'killall deluge-web' {$_POST["u"]}");
		$shell = shell_exec("rm -rf /home/{$_POST["u"]}/.config/deluge/deluged.pid");
		$shell = shell_exec("sudo su --login --command 'deluged' {$_POST["u"]}");
		$shell = shell_exec("sudo su --login --command 'screen -d -m -S deluge-web deluge-web' {$_POST["u"]}");
	}elseif($_POST["c"] == "transmission"){
		$shell = shell_exec("sudo su --login --command '/etc/init.d/transmission-daemon restart' {$_POST["u"]}");
	}elseif($_POST["c"] == "utorrent"){
		$shell = shell_exec("sudo su --login --command 'killall utserver' {$_POST["u"]}");
		$shell = shell_exec("sudo su --login --command 'utserver -settingspath /home/{$_POST["u"]}/.utserver/ -configfile /home/{$_POST["u"]}/.utserver/utserver.conf -logfile /home/{$_POST["u"]}/.utserver/utserver.log -pidfile /home/{$_POST["u"]}/.utserver/utserver.pid -daemon' {$_POST["u"]}");
	}elseif($_POST["c"] == "vpn"){
		$shell = shell_exec("bash clear");
	}
}elseif ($_POST["server_data"] == "yes"){
	function addUnitss($bytes) {
		$units = array('B','kB','MB','GB','TB','PB','EB');
		for($i = 0; $bytes >= 1024 && $i < count($units) - 1; $i++ ) {
			$bytes /= 1024;
		}
		return round($bytes, 1).' '.$units[$i];
	}

	if ($_POST["fhnev"]){
		function myGetDirs($username, $homeUser, $homeBase) {
			$passwd = file('/etc/passwd');
			$path = false;
			foreach ($passwd as $line) {
				if (strstr($line, $username) !== false) {
					$parts = explode(':', $line);
					$path = $parts[5];
					break;
				}
			}

			$ret = TRUE;
			$U = realpath($path); /// expand
			$B = realpath($path."/.."); /// home is the previous path

			if (isset($U) and !Empty($U) and is_dir($U)) {
				$homeUser = $U;
			}else{
				$ret = FALSE;
			}
			if (isset($B) and !Empty($B) and is_dir($B)) {
				$homeBase = $B;
			}else{
				$ret = FALSE;
			}

			return $ret;
		}

		if(!isset($quotaUser)) {
			$quotaUser = '';
		}

		$topDirectory = "/home";
		$quotaUser = $_POST["fhnev"];
		$homeUser = $topDirectory.'/'.$quotaUser;
		$homeBase = $topDirectory;
		$quotaEnabled = true;

		//if (isset($quotaUser) and !Empty($quotaUser) and file_exists($homeBase.'/aquota.user')) {
		//	$quotaEnabled = myGetDirs($quotaUser, &$homeUser, &$homeBase); /// get the real home dir
		//}

		if ($quotaEnabled) {
			$TeljesMeret = shell_exec("/usr/bin/sudo /usr/sbin/repquota -u -a | grep ^".$quotaUser." | awk '{print \$4}'") * 1024;
			$used = shell_exec("/usr/bin/sudo /usr/sbin/repquota -u -a | grep ^".$quotaUser." | awk '{print \$3}'") * 1024;

			if ($TeljesMeret == 0) {
				$TeljesMeret = disk_total_space($topDirectory);
			}

			$SzabadTerulet = ($TeljesMeret - $used);
			$FelhasznaltTerulet = $used;
		}else{
			$TeljesMeret = disk_total_space($topDirectory);
			$SzabadTerulet = disk_free_space($topDirectory);
			$FelhasznaltTerulet = $TeljesMeret - $SzabadTerulet;
		}

		if(!isset($quotaUser)) {
			$quotaUser = '';
		}

		$homeUser= $topDirectory.'/'.$quotaUser;
		$homeBase= $topDirectory;
		$quotaEnabled = FALSE;

		//if (isset($quotaUser) and !Empty($quotaUser) and file_exists($homeBase.'/aquota.user')) {
		//	$quotaEnabled = myGetDirs($quotaUser, &$homeUser, &$homeBase); /// get the real home dir
		//}
		
		$TorrentekSzama = shell_exec("ls /home/{$quotaUser}/downloads/.session/*.torrent|wc -l");
		if ($_POST["mit"] == "teljeshdd")
			echo addUnitss($TeljesMeret)."=|=".addUnitss($SzabadTerulet)."=|=".
					round((100 - ($SzabadTerulet / $TeljesMeret) * 100), 1)."=|=".
					addUnitss($FelhasznaltTerulet)."=|=".
					$TorrentekSzama;
	}elseif ($_POST["mit"] == "gepadat"){
                $TeljesMeret = disk_total_space("/home/");
                $SzabadTerulet = disk_free_space("/home/");
                $FelhasznaltTerulet = $TeljesMeret - $SzabadTerulet;

                $TeljesMeret2 = disk_total_space("/");
                $SzabadTerulet2 = disk_free_space("/");
                $FelhasznaltTerulet2 = $TeljesMeret2 - $SzabadTerulet2;

		######Ujjitas

//linux system detects
//linux system detects

    // CPU
    if (false === ($str = @file("/proc/cpuinfo"))) return false;
    $str = implode("", $str);
    @preg_match_all("/model\s+name\s{0,}\:+\s{0,}([\w\s\)\(\@.-]+)([\r\n]+)/s", $str, $model);
    @preg_match_all("/cpu\s+MHz\s{0,}\:+\s{0,}([\d\.]+)[\r\n]+/", $str, $mhz);
    @preg_match_all("/cache\s+size\s{0,}\:+\s{0,}([\d\.]+\s{0,}[A-Z]+[\r\n]+)/", $str, $cache);
    if (false !== is_array($model[1]))
  {
        $res['cpu']['num'] = sizeof($model[1]);

    if($res['cpu']['num']==1)
      $x1 = '';
    else
      $x1 = $res['cpu']['num'];
	$CPUInfo = $model[1][0]."=|=".round($mhz[1][0],1)." MHz=|=".$cache[1][0]."=|=".$x1;
  }

    // MEMORY
    if (false === ($str = @file("/proc/meminfo"))) return false;
    $str = implode("", $str);
    preg_match_all("/MemTotal\s{0,}\:+\s{0,}([\d\.]+).+?MemFree\s{0,}\:+\s{0,}([\d\.]+).+?Cached\s{0,}\:+\s{0,}([\d\.]+).+?SwapTotal\s{0,}\:+\s{0,}([\d\.]+).+?SwapFree\s{0,}\:+\s{0,}([\d\.]+)/s", $str, $buf);
  preg_match_all("/Buffers\s{0,}\:+\s{0,}([\d\.]+)/s", $str, $buffers);

    $res['memTotal'] = round($buf[1][0]/1024, 2);
    $res['memFree'] = round($buf[2][0]/1024, 2);
    $res['memBuffers'] = round($buffers[1][0]/1024, 2);
  $res['memCached'] = round($buf[3][0]/1024, 2);
    $res['memUsed'] = $res['memTotal']-$res['memFree'];
    $res['memPercent'] = (floatval($res['memTotal'])!=0)?round($res['memUsed']/$res['memTotal']*100,2):0;

    $res['memRealUsed'] = $res['memTotal'] - $res['memFree'] - $res['memCached'] - $res['memBuffers']; //Real memory usage
  $res['memRealFree'] = $res['memTotal'] - $res['memRealUsed']; //Real idle
    $res['memRealPercent'] = (floatval($res['memTotal'])!=0)?round($res['memRealUsed']/$res['memTotal']*100,2):0; //Real memory usage

  $res['memCachedPercent'] = (floatval($res['memCached'])!=0)?round($res['memCached']/$res['memTotal']*100,2):0; //Cached memory usage

    $res['swapTotal'] = round($buf[4][0]/1024, 2);
    $res['swapFree'] = round($buf[5][0]/1024, 2);
    $res['swapUsed'] = round($res['swapTotal']-$res['swapFree'], 2);
    $res['swapPercent'] = (floatval($res['swapTotal'])!=0)?round($res['swapUsed']/$res['swapTotal']*100,2):0;

	$sysInfo = $res;

//Determine if memory is less than 1GB, will be displayed MB, otherwise display GB Unit

  $MemTotal = round($sysInfo['memTotal']/1024,1)." GB";
  $Hasznalt = round($sysInfo['memUsed']/1024,1)." GB";
  $SzabadMem = round($sysInfo['memFree']/1024,1)." GB";

  $memCached = round($sysInfo['memCached']/1024,1)." GB";
  $memBuffers = round($sysInfo['memBuffers']/1024,1)." GB";
 
  $SwapTotal = round($sysInfo['swapTotal']/1024,1)." GB";
  $SwapHasznalt = round($sysInfo['swapUsed']/1024,1)." GB";
  $SwapFree = round($sysInfo['swapFree']/1024,1)." GB";
  $swapPercent = $sysInfo['swapPercent'];
 
  $Hasznalt = round($sysInfo['memRealUsed']/1024,1)." GB"; //Real memory usage
  $SzabadMem = round($sysInfo['memRealFree']/1024,1)." GB"; //Real memory free
  $memPercent = $sysInfo['memRealPercent']; //Real memory usage ratio
  //$memPercent = $sysInfo['memPercent']; //Total Memory Usage
  $memCachedPercent = $sysInfo['memCachedPercent']; //cache memory usage

$loads = sys_getloadavg();
$core_nums = trim(shell_exec("grep -P '^processor' /proc/cpuinfo|wc -l"));
$load = round($loads[0]/($core_nums + 1)*100, 2);

	
	$FelhasznalokSzama = number_format(shell_exec("ls /var/www/rutorrent/conf/users/|wc -l"));
	$FhLista = explode("\n",shell_exec("ls -1 /var/www/rutorrent/conf/users/"));
	$TorrentekSzama = 0;
	for ($i = 0; $i <= $FelhasznalokSzama; $i++) {
		$TorrentekSzama += shell_exec("ls /home/".$FhLista[$i]."/downloads/.session/*.torrent|wc -l");
	}
		echo addUnitss($TeljesMeret)."=|=".addUnitss($SzabadTerulet)."=|=".
		round((100 - ($SzabadTerulet / $TeljesMeret) * 100), 1)."=|=".
		addUnitss($FelhasznaltTerulet)."=|=".
		addUnitss($TeljesMeret2)."=|=".addUnitss($SzabadTerulet2)."=|=".
        round((100 - ($SzabadTerulet2 / $TeljesMeret2) * 100), 1)."=|=".
		addUnitss($FelhasznaltTerulet2)."=|=".
		$load."=|=".
		$MemTotal."=|=".
		$Hasznalt."=|=".
		$SzabadMem."=|=".
		$memPercent."=|=".
		$SwapTotal."=|=".
		$SwapHasznalt."=|=".
		$SwapFree."=|=".
		$swapPercent."=|=".
		$memCached."=|=".
		$memBuffers."=|=".
		$memCachedPercent."=|=".
		$CPUInfo."=|=".
		$TorrentekSzama;
	}elseif ($_POST["mit"] == "update"){
		echo shell_exec("cd /home && sudo wget -N https://raw.githubusercontent.com/fjdhgjaf/bbox/v2/egyeb/update && bash update >> /dev/null 2>&1");
		echo "Frissítés sikeres.";
	}elseif ($_POST["mit"] == "memecachetisztit"){
		echo shell_exec("bash clean_bbmem >> /dev/null 2>&1");
		echo "Frissítés sikeres.";
	}
}
?>
