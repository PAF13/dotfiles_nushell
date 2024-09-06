def PROJEKTVERWALTUNG [] {}

def --env "PROJEKTVERWALTUNG search" [] {
	let list = (open 'C:\Users\administrator.ME0\home\siteca\projekte\projekteClean.json')
	let choice = ($list | columns | to text |  fzf -e)
	if ($choice in $list) {	$list | get $choice | cd $in.pfad}
}

def --env "PROJEKTVERWALTUNG newprojekt" [] {
	print "Kunde:"
	input
	print "Projektnummer:"
	input
	print "Projektname:"
	input
	print "Jahr:"
	input
}
def --env "PROJEKTVERWALTUNG init" [] {
	(if ('blame' | path exists) {print "init file exist. Would you like to continue?";print ("(y)es (n)o"); input -s --numchar 1 | if ($in == 'y') {PROJEKTVERWALTUNG createprojektinfo}} else {PROJEKTVERWALTUNG createprojektinfo})
}

def --env "PROJEKTVERWALTUNG tocsv" [] {
	let projektnummer = (open 'blame\projektinfo.json' | $in.nummer)
	let file = (ls 'blame\stromkreise\' | where type == file | get name.0 | open $in)
	$file | columns | to text | fzf --multi | split column "\n" | get $.0 | values | each {|e| 
		$file | get $e | to csv --separator ';' | save --force $'blame\stromkreise\verbindungslisten\($projektnummer)_($e)_WIR.txt';
		mv $'blame\stromkreise\verbindungslisten\($projektnummer)_($e)_WIR.txt' $'blame\stromkreise\verbindungslisten\($projektnummer)_($e)_WIR.csv'}
 	
}

def --env "PROJEKTVERWALTUNG initprojektprodukte" [] {
	(if ('blame\projektinfo.json' | path exists) {
		let produktlist = (ls 'blame\stromkreise' | sort-by -r modified | get name.0 | open $in | get verbindungen | columns)

		#$produkte | to text | fzf --multi | split column "\n" | transpose -i -r
	} else {PROJEKTVERWALTUNG search; PROJEKTVERWALTUNG load; return})
	#PROJEKTVERWALTUNG tocsv

}

def --env "PROJEKTVERWALTUNG createprojektinfo" [] {
	let baseFolder = "blame"
	let stromkreise = ($baseFolder | path join "stromkreise")
	let verbindungslisten = ($stromkreise | path join "verbindungslisten")

	let artikel = ($baseFolder | path join "artikel")
	
	[$baseFolder $stromkreise $verbindungslisten $artikel] | each {|e| mkdir $e}
	attrib +h $baseFolder

	let projektFolder = (ls -f -D | get name.0 | path parse | get stem | split column "_")
	
	mut projektnummer = $projektFolder.column1?.0?
	mut projektname = $projektFolder.column2?.0?
	mut projektbeschreibung = $projektFolder.column3?.0?
	
	print $"input project number \(($projektnummer)\)"
	input | if ($in == "") {$projektnummer} else {$in} | $projektnummer = $in
	print $"input project name \(($projektname)\)"
	input | if ($in == "") {$projektname} else {$in} | $projektname = $in
	print $"input project beschreibung \(($projektbeschreibung)\)"
	input | if ($in == "") {$projektbeschreibung} else {$in} | $projektbeschreibung = $in

	{header: {type: "projekt info" version: "0.0.0.1" date: (date now)} nummer: $projektnummer name: $projektname beschreibung: $projektbeschreibung produkte: {}} | to json | save --force ($baseFolder | path join "projektinfo.json")
	print (open ($baseFolder | path join "projektinfo.json"))




}


def --env "PROJEKTVERWALTUNG load" [] {
	(if ('blame\projektinfo.json' | path exists) {
	
		let fileRaw = (EPLAN_XML_PARSING $env.EPLAN_VERBINDUNG_RAW)
		let projektnummer = $fileRaw.header.'0 / Projektnummer'
		let size = ($fileRaw.line | length)
		mut verbindung = null
		mut verbindungen = []
		mut anschluss = {}
		mut bauteil = {}
		mut schrankverbindungslisten = {}
		mut x = 0; while $x < $size {
			$verbindung = ($fileRaw.line | get $x); 
			$anschluss = (PROJEKTVERWALTUNG doppelader $verbindung $anschluss);
			$verbindungen = ($verbindungen | append (PROJEKTVERWALTUNG cleanliste $verbindung $anschluss));
			$schrankverbindungslisten = (PROJEKTVERWALTUNG schrankverbindungsliste ($verbindungen | get $x) $schrankverbindungslisten);
			$bauteil = (PROJEKTVERWALTUNG bauteil $verbindung $bauteil);
			$x += 1
		}
		let date = (date now | date to-table)
		{projektnummer: $projektnummer doppelader: $anschluss verbindungenRaw: $verbindungen verbindungen: $schrankverbindungslisten bauteile: $bauteil} | to json | save --force $'blame\stromkreise\verbindungen_($date.year.0)($date.month.0)($date.day.0)($date.hour.0)($date.minute.0)($date.second.0).json'

		cd 'blame\stromkreise'
	} else {PROJEKTVERWALTUNG search; PROJEKTVERWALTUNG load; return})
	#PROJEKTVERWALTUNG tocsv

}

def "PROJEKTVERWALTUNG schrankverbindungsliste" [verbindung schrankverbindungslisten1] {
	mut schrankverbindungslisten = $schrankverbindungslisten1
	mut list = []
	mut platzierung = ($verbindung | get "Betriebsmittel (Quelle) / Alle Platzierungen [1]" | to text | split column '/' | get column1.0 | split column '&' | get column1.0);
	(if ($platzierung not-in $schrankverbindungslisten) {$schrankverbindungslisten = ($schrankverbindungslisten | insert $platzierung [$verbindung])} 
	else {$list = ($schrankverbindungslisten | get $platzierung | append $verbindung); $schrankverbindungslisten = ($schrankverbindungslisten | update $platzierung $list)})

	return $schrankverbindungslisten

}

def "PROJEKTVERWALTUNG bauteil" [verbindung bauteil] {
	mut bauteilliste = $bauteil

	mut platzierung = ''
	mut x = 1; while $x < 11 {
		$platzierung = ($verbindung | get $"Betriebsmittel \(Quelle) / Alle Platzierungen [($x)]");
		$bauteilliste = (PROJEKTVERWALTUNG bauteilUpdatequelle $platzierung $bauteilliste $verbindung);
		$platzierung = ($verbindung | get $"Betriebsmittel \(Ziel) / Alle Platzierungen [($x)]");
		$bauteilliste = (PROJEKTVERWALTUNG bauteilUpdateziel $platzierung $bauteilliste $verbindung);

		$x += 1}

	return $bauteilliste

}

def "PROJEKTVERWALTUNG bauteilUpdatequelle" [ort bauteil verbindung] {
	mut bauteilliste = $bauteil
	mut platzierung = $ort
	
	let quelle = ($verbindung.'Betriebsmittel (Quelle) / Name des Zielanschlusses (vollständig)' | split column ':' | get column1.0)
	let quelleSchrank = ($verbindung.'Betriebsmittel (Quelle) / Name des Zielanschlusses (vollständig)' | split column '-' | get column1.0)

	if ($platzierung == null) {$platzierung = ''};

	if ($quelleSchrank not-in $bauteilliste) {$bauteilliste = ($bauteilliste | insert $quelleSchrank {})}
	if (('/' not-in $platzierung) and $platzierung != '') {$bauteilliste = ($bauteilliste | upsert ([$quelleSchrank $quelle] | into cell-path) true)} else if ($quelle not-in ($bauteilliste | get $quelleSchrank)) {$bauteilliste = ($bauteilliste | insert ([$quelleSchrank $quelle] | into cell-path) false)};



	return $bauteilliste
}

def "PROJEKTVERWALTUNG bauteilUpdateziel" [ort bauteil verbindung] {
	mut bauteilliste = $bauteil
	mut platzierung = $ort
	
	let ziel = ($verbindung.'Betriebsmittel (Ziel) / Name des Zielanschlusses (vollständig)' | split column ':' | get column1.0)
	let zielSchrank = ($verbindung.'Betriebsmittel (Ziel) / Name des Zielanschlusses (vollständig)' | split column '-' | get column1.0)

	if ($platzierung == null) {$platzierung = ''};

	if ($zielSchrank not-in $bauteilliste) {$bauteilliste = ($bauteilliste | insert $zielSchrank {})}
	if (('/' not-in $platzierung) and $platzierung != '') {$bauteilliste = ($bauteilliste | upsert ([$zielSchrank $ziel] | into cell-path) true)} else if ($ziel not-in ($bauteilliste | get $zielSchrank)) {$bauteilliste = ($bauteilliste | insert ([$zielSchrank $ziel] | into cell-path) false)};

	return $bauteilliste
}
def "PROJEKTVERWALTUNG doppelader" [verbindung anschluss] {
	mut anschlussliste = $anschluss

	let quelle = ($verbindung.'Betriebsmittel (Quelle) / Name des Zielanschlusses (vollständig)')
	let ziel = ($verbindung.'Betriebsmittel (Ziel) / Name des Zielanschlusses (vollständig)')

	$anschlussliste = (if ($quelle in $anschlussliste) {$anschlussliste | update $quelle true} else {$anschlussliste | insert $quelle false})
	$anschlussliste = (if ($ziel in $anschlussliste) {$anschlussliste | update $ziel true} else {$anschlussliste | insert $ziel false})

	return $anschlussliste
}

def "PROJEKTVERWALTUNG cleanliste" [verbindung anschluss] {
	mut verbindungClean = $verbindung
	mut path = ''
	$verbindungClean = ($path = 'Verbindung / Verbindungsquerschnitt / -durchmesser'; $verbindungClean | update $path (PROJEKTVERWALTUNG stringtofloat ($verbindungClean | get $path)))
	$verbindungClean = ($path = 'Verbindung / Blockeigenschaft [10]'; $verbindungClean | update $path (PROJEKTVERWALTUNG stringtofloat ($verbindungClean | get $path)))
	$verbindungClean = ($path = 'doppeladerQuelle'; $verbindungClean | insert $path ($anschluss | get $verbindung.'Betriebsmittel (Quelle) / Name des Zielanschlusses (vollständig)'))
	$verbindungClean = ($path = 'doppeladerZiel'; $verbindungClean | insert $path ($anschluss | get $verbindung.'Betriebsmittel (Ziel) / Name des Zielanschlusses (vollständig)'))

	return $verbindungClean
	
}

def "PROJEKTVERWALTUNG stringtofloat" [str] {
	mut value = $str
	if ($value == null) {$value = 0} else {$value = ($value | str replace ',' '.' | str replace --all 'x' '')}
	$value | into float

	return $value
}

def writeCSV [data] {
	# DEST1;TA1;STOP1;DEVICE1;DEST2;TA2;STOP2;DEVICE2;CROSSSECTION;COLOUR;LENGTH;TYPE;WIREID;CAEID;DIR1;DIR2;PARENT1;PARENT2;Z1;Z2 
	let header = [DEST1 TA1 STOP1 DEVICE1 DEST2 TA2 STOP2 DEVICE2 CROSSSECTION COLOUR LENGTH TYPE WIREID CAEID DIR1 DIR2 PARENT1 PARENT2 Z1 Z2]
	let verbindungsliste = 'C:\Users\administrator.ME0\home\siteca\eplan\verbindungslisten\verbindungsliste.csv'
	let size = ($data | length)
	mut body = {}
	mut verbindung = null
	mut schrank = ''

	#mut x = 0; while $x < $size {print (makeCSVLine ($data | get $x)); $x += 1}
	mut x = 0; while $x < $size {
		$schrank = ($data | get $x | get 'Betriebsmittel (Quelle) / Alle Platzierungen [1]');
		if ($schrank == null) {$schrank = ''} else {$schrank = ($schrank | split column '/' | get column1.0 | split column '&' | get column1.0)};
		$verbindung = (makeCSVLine ($data | get $x));
		$body = ($body | upsert $schrank (if ($schrank in $body) {$body | get $schrank | append $verbindung.1} else {[$verbindung.1]}));
		$x += 1}
	#let date = (date now | date to-table)
	#$body | to json | save --force $'blame\stromkreise\verbindungsliste_($date.year.0)($date.month.0)($date.day.0)($date.hour.0)($date.minute.0)($date.second.0).json'
	$body

}

def makeCSVLine [line] {
	
	let DEST1 = $line.'Betriebsmittel (Quelle) / Name des Zielanschlusses (vollständig)'
	let TA1 = ''
	let STOP1 = ''
	let DEVICE1 = ''
	let DEST2 = $line.'Betriebsmittel (Ziel) / Name des Zielanschlusses (vollständig)'
	let TA2 = ''
	let STOP2 = ''
	let DEVICE2 = ''
	let CROSSSECTION = $line.'Verbindung / Verbindungsquerschnitt / -durchmesser'
	let COLOUR = $line.'Verbindung / Verbindungsfarbe / -nummer'
	let LENGTH = $line.'Verbindung / Blockeigenschaft [10]'
	let TYPE = ''
	let WIREID = ''
	let CAEID = ''
	let DIR1 = ''
	let DIR2 = ''
	let PARENT1 = ''
	let PARENT2 = ''
	let Z1 = ''
	let Z2 = ''

	return ["ok" {
		DEST1: $DEST1 
		TA1: $TA1 
		STOP1: $STOP1 
		DEVICE1: $DEVICE1 
		DEST2: $DEST2 
		TA2: $TA2 
		STOP2: $STOP2 
		DEVICE2: $DEVICE2 
		CROSSSECTION: $CROSSSECTION 
		COLOUR: $COLOUR 
		LENGTH: $LENGTH 
		TYPE: $TYPE 
		WIREID: $WIREID 
		CAEID: $CAEID 
		DIR1: $DIR1 
		DIR2: $DIR2 
		PARENT1: $PARENT1 
		PARENT2: $PARENT2 
		Z1: $Z1 
		Z2: $Z2
	}]

}
