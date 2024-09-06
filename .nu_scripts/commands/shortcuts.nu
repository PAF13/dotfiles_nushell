# myscript.nu

def conf [] {
}
 
def --env "conf nvim" [] {
	cd '~\AppData\Local\nvim\lua\plugins'
	let choice = (fzf  --preview='less {}')
	if ($choice != '') {nvim $choice}
}

def --env "conf nu" [] {
	cd '~\home\.config\nushell\.nu_scripts'
	let choice = (fzf  --preview='less {}')
	print $choice
	if ($choice != '') {nvim $choice}
}


def "conf yazi" [] {
	nvim 'C:\Users\administrator.ME0\AppData\Roaming\yazi'

}

def --env notes [] {
	cd '~\home\notes\siteca_wiki' 
	let choice = (fzf  --preview='less {}')
	if ($choice != '') {nvim $choice}
}

def startwiki [] {
	start http://192.168.20.148:8080
}


def pue [] {
	start 'https://athgroup.sharepoint.com/:x:/r/sites/SITECA/_layouts/15/Doc2.aspx?action=edit&sourcedoc=%7Bb9c55db7-d4e6-4c29-bbcc-ac76c1038904%7D&wdOrigin=TEAMS-MAGLEV.teamsSdk_ns.rwc&wdExp=TEAMS-TREATMENT&wdhostclicktime=1723042175222&web=1'
}

def startwm [] {
	komorebic start --whkd
}

def stopwm [] {
	komorebic stop
}
