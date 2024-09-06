
def --env writeVerbindungsliste [data verbindungsliste] {
	# DEST1;TA1;STOP1;DEVICE1;DEST2;TA2;STOP2;DEVICE2;CROSSSECTION;COLOUR;LENGTH;TYPE;WIREID;CAEID;DIR1;DIR2;PARENT1;PARENT2;Z1;Z2 
	let header = "DEST1;TA1;STOP1;DEVICE1;DEST2;TA2;STOP2;DEVICE2;CROSSSECTION;COLOUR;LENGTH;TYPE;WIREID;CAEID;DIR1;DIR2;PARENT1;PARENT2;Z1;Z2" 
	
	$header | save --force $verbindungsliste
	
	$data | par-each {|e| $e | makeCSVLine $in $verbindungsliste}

}


def makeCSVLine [line file] {
	#if ($line.'<31090> | Draht  | Länge' > 0.0) {
		let DEST1 = $line.'<20048> | Quelle | Anschluss'
		let TA1 = ''
		let STOP1 = ''
		let DEVICE1 = ''
		let DEST2 = $line.'<20048> | Ziel   | Anschluss'
		let TA2 = ''
		let STOP2 = ''
		let DEVICE2 = ''
		let CROSSSECTION = ($line.'<31002> | Draht  | Querschnitt' | to text | str replace '.' ',')
		let COLOUR = $line.'<31004> | Draht  | Farbe/Nummer'
		let LENGTH = ($line.'<31090> | Draht  | Länge' | to text | str replace '.' ',')
		let TYPE = ''
		let WIREID = ''
		let CAEID = ''
		let DIR1 = ''
		let DIR2 = ''
		let PARENT1 = ''
		let PARENT2 = ''
		let Z1 = ''
		let Z2 = ''

		$"\n($DEST1);($TA1);($STOP1);($DEVICE1);($DEST2);($TA2);($STOP2);($DEVICE2);($CROSSSECTION);($COLOUR);($LENGTH);($TYPE);($WIREID);($CAEID);($DIR1);($DIR2);($PARENT1);($PARENT2);($Z1);($Z2)" | save --append $file
	#}
}

$env.EPLAN_XML_VERBINDUNGSLISTE_KEY = {
"Betriebsmittel (Quelle) / Name des Zielanschlusses (vollständig)": ""
"Betriebsmittel (Ziel) / Name des Zielanschlusses (vollständig)": ""
"Betriebsmittel (Quelle) / Funktionsdefinition en_US": ""
"Betriebsmittel (Quelle) / Funktionsdefinition: Gruppe en_US": ""
"Betriebsmittel (Quelle) / Funktionsdefinition: Kategorie en_US": ""
"Betriebsmittel (Quelle) / Anschlussquerschnitt": ""
"Betriebsmittel (Quelle) / Anschlussquerschnitt / -durchmesser": ""
"Betriebsmittel (Quelle) / Seitenname": ""
"Betriebsmittel (Quelle) / Spaltennummer": ""
"Betriebsmittel (Quelle) / Zeilennummer": ""
"Betriebsmittel (Ziel) / Funktionsdefinition en_US": ""
"Betriebsmittel (Ziel) / Funktionsdefinition: Gruppe en_US": ""
"Betriebsmittel (Ziel) / Funktionsdefinition: Kategorie en_US": ""
"Betriebsmittel (Ziel) / Anschlussquerschnitt": ""
"Betriebsmittel (Ziel) / Anschlussquerschnitt / -durchmesser": ""
"Betriebsmittel (Ziel) / Seitenname": ""
"Betriebsmittel (Ziel) / Spaltennummer": ""
"Betriebsmittel (Ziel) / Zeilennummer": ""
"Verbindung / Verbindungsquerschnitt / -durchmesser": ""
"Verbindung / Verbindungsfarbe / -nummer": ""
"Verbindung / Blockeigenschaft [10]": ""
"Verbindung / Blockeigenschaft [11]": ""
"Verbindung / Blockeigenschaft [12]": ""
"Verbindung / Blockeigenschaft [13]": ""
"Verbindung / Blockeigenschaft [14]": ""
"Verbindung / Blockeigenschaft [15]": ""
"Verbindung / Blockeigenschaft [16]": ""
"Verbindung / Blockeigenschaft [17]": ""
"Verbindung / Blockeigenschaft [18]": ""
"Verbindung / Blockeigenschaft [19]": ""
"Verbindung / Blockeigenschaft [20]": ""
"Datensatz / Fortlaufende Nummer": ""
"Betriebsmittel (Quelle) / Alle Platzierungen [1]": ""
"Betriebsmittel (Quelle) / Alle Platzierungen [2]": ""
"Betriebsmittel (Quelle) / Alle Platzierungen [3]": ""
"Betriebsmittel (Quelle) / Alle Platzierungen [4]": ""
"Betriebsmittel (Quelle) / Alle Platzierungen [5]": ""
"Betriebsmittel (Quelle) / Alle Platzierungen [6]": ""
"Betriebsmittel (Quelle) / Alle Platzierungen [7]": ""
"Betriebsmittel (Quelle) / Alle Platzierungen [8]": ""
"Betriebsmittel (Quelle) / Alle Platzierungen [9]": ""
"Betriebsmittel (Quelle) / Alle Platzierungen [10]": ""
"Betriebsmittel (Ziel) / Alle Platzierungen [1]": ""
"Betriebsmittel (Ziel) / Alle Platzierungen [2]": ""
"Betriebsmittel (Ziel) / Alle Platzierungen [3]": ""
"Betriebsmittel (Ziel) / Alle Platzierungen [4]": ""
"Betriebsmittel (Ziel) / Alle Platzierungen [5]": ""
"Betriebsmittel (Ziel) / Alle Platzierungen [6]": ""
"Betriebsmittel (Ziel) / Alle Platzierungen [7]": ""
"Betriebsmittel (Ziel) / Alle Platzierungen [8]": ""
"Betriebsmittel (Ziel) / Alle Platzierungen [9]": ""
"Betriebsmittel (Ziel) / Alle Platzierungen [10]": ""
}
