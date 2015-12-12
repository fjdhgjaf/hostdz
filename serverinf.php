#!/usr/bin/php -q
<?php
ignore_user_abort(true);
set_time_limit(0);
ini_set('display_errors', '0');
error_reporting(0);
	function addUnitss($bytes) {
		$units = array('B','kB','MB','GB','TB','PB','EB');
		for($i = 0; $bytes >= 1024 && $i < count($units) - 1; $i++ ) {
			$bytes /= 1024;
		}
		return round($bytes, 1).' '.$units[$i];
	}
if ($argv[1] == "gepadat"){
                $TeljesMeret = disk_total_space("/home/");
                $SzabadTerulet = disk_free_space("/home/");
                $FelhasznaltTerulet = $TeljesMeret - $SzabadTerulet;

                $TeljesMeret2 = disk_total_space("/");
                $SzabadTerulet2 = disk_free_space("/");
                $FelhasznaltTerulet2 = $TeljesMeret2 - $SzabadTerulet2;

		class rCPU {
			public $hash = "cpu.dat";
			public $count = 1;
			static public function load()
			{
				global $processorsCount;
						if(is_null($processorsCount))
				{
					$cpu = new rCPU();
					$cpu->obtain();
				}
				else
					$cpu->count = $processorsCount;
				return($cpu);
			}
			public function obtain()
			{
				$this->count = max(intval(shell_exec('grep -c processor /proc/cpuinfo')),1);
			}
			public function get()
			{
				if(!function_exists('sys_getloadavg'))
				{
					function sys_getloadavg()
					{
						$loadavg_file = '/proc/loadavg';
						if(file_exists($loadavg_file))
							return(explode(chr(32),file_get_contents($loadavg_file)));
						else
							return(array_map("trim",explode(",",substr(strrchr(shell_exec("uptime"),":"),1))));
						return array(0,0,0);
					}
				}
				$arr = sys_getloadavg();
				return( round(min($arr[0]*100/$this->count,100)) );
			}
		}
		$cpu = rCPU::load();
		$Mem = shell_exec("cat /proc/meminfo");
		$filearray = explode("\n", $Mem);
		foreach ($filearray as $value) {
			if (preg_match('/^MemTotal:/i', $value)) {
				$MemTotal = substr($value, 10);;
				$MemTotal = (str_replace('kB', '', $MemTotal));
			}
			if (preg_match('/^MemFree:/i', $value)) {
				$MemFree = substr($value, 8);;
				$MemFree = str_replace('kB', '', $MemFree);
			}
			if (preg_match('/^Buffers:/i', $value)) {
				$Buffers = substr($value, 8);;
				$Buffers = str_replace('kB', '', $Buffers);
			}
			if (preg_match('/^MemAvailable:/i', $value)) {
				$MemAvailable = substr($value, 13);;
				$MemAvailable = str_replace('kB', '', $MemAvailable);
			}
			$Hasznalt = ($MemTotal-$MemAvailable)+($MemFree+$Buffers);
			$SzabadMem = $MemTotal-$Hasznalt;
			//Swap
			if (preg_match('/^SwapTotal:/i', $value)) {
				$SwapTotal = substr($value, 10);;
				$SwapTotal = (str_replace('kB', '', $SwapTotal));
			}
			if (preg_match('/^SwapFree:/i', $value)) {
				$SwapFree = substr($value, 9);;
				$SwapFree = (str_replace('kB', '', $SwapFree));
			}
			$SwapHasznalt = $SwapTotal-$SwapFree;
		}
		echo addUnitss($TeljesMeret)."=|=".addUnitss($SzabadTerulet)."=|=".
		round((100 - ($SzabadTerulet / $TeljesMeret) * 100), 1)."=|=".
		addUnitss($FelhasznaltTerulet)."=|=".
		addUnitss($TeljesMeret2)."=|=".addUnitss($SzabadTerulet2)."=|=".
        round((100 - ($SzabadTerulet2 / $TeljesMeret2) * 100), 1)."=|=".
		addUnitss($FelhasznaltTerulet2)."=|=".
		$cpu->get()."=|=".
		addUnitss($MemTotal*1024)."=|=".
		addUnitss($Hasznalt*1024)."=|=".
		addUnitss($SzabadMem*1024)."=|=".
		round((100 - ($SzabadMem / $MemTotal) * 100), 1)."=|=".
		addUnitss($SwapTotal*1024)."=|=".
		addUnitss($SwapHasznalt*1024)."=|=".
		addUnitss($SwapFree*1024)."=|=".
		round((100 - ($SwapFree / $SwapTotal) * 100), 1);
	}
