# glob **/* --depth 2
def starProjektEdit [name] {
	clear
	print $"----------------\n($name)\n----------------\nPlease Pick\nn = NC\nd = Draht\nb = BMK"

	let nc = "04 FERTIGUNGSDATEN/01 NC"
	let draht = "04 FERTIGUNGSDATEN/02 DRAHT"
	let bmk = "04 FERTIGUNGSDATEN/03 BESCHRIFTUNG"

	let ziel = (input -s --numchar 1)
	(if $ziel == n {ls -s ...(glob $"($nc)/*/*+*.dxf") | get name | to text | fzf; starProjektEdit $name}
		else if $ziel == d {ls -s ...(glob $"($draht)/*_WIR.csv") | get name | to text | fzf | open --raw ($draht + '\' + $in) | from csv --separator ';' | explore -i; starProjektEdit $name}
		else if $ziel == b {ls -s ...(glob $"($bmk)/*.mtp") | get name | to text | fzf; starProjektEdit $name}
		else {print "input not correct"})
}

def --env loadProjekts [] {
	const kundeList = 'C:\Users\administrator.ME0\home\siteca\projekte\projekte.json'
	const projektList = 'C:\Users\administrator.ME0\home\projekte.json'
	if ($kundeList | path exists) {rm $kundeList}
	if ($projektList | path exists) {rm $projektList}


	const drives = [
		'\\192.168.20.200\Projektdaten 2022' 
		'\\192.168.20.200\Projektdaten 2023' 
		'\\192.168.20.200\Projektdaten 2024'
	]

	const includeKunde = [
		'ENEG'
		'MIRION TECHNOLOGY'
		'MP GMBH'
		'OFFTRACK'
		'ORAFOL'
		'BERGEMANN'
		'BRINKMANN'
		'CMSWIND'
		'DEUTSCHE LICHTMIETE'
		'DRYTEC'
		'EAE'
		'ELF'
		'ETNA'
		'FRIMO CS'
		'FRIMO HH'
		'HANSELLA'
		'HINRICHS&KEMPKE'
		'HPS'
		'IKS'
		'KROENERT'
		'LUDLUM'
		'MFH'
		'MIRION TECHNOLOGIES'
		'MP'
		'MTH'
		'ONECLICK'
		'OPTONAVAL'
		'OSWALDIDEN'
		'PLB'
		'PNS24'
		'RECONSITE'
		'SAFETEC'
		'TEDSEN'
		'TIG'
		'WAVETEC'
		'ZAE'
		'ZELLERFELD'
	]

	const excludeKunde = [
		'**/#recycle/**'
		'**/AAA - FERTIGUNG-MUSTER-PROJEKTNUMMER_ANLAGENTYP/**'
		'**/ALLGEMEIN/**'
		'**/Archiv/**'
		'**/Beschriftung Vorlage/**'
		'**/Neuer Ordner/**'
		'**/Revisionen abzuarbeiten/**'
		'**/AAA - FERTIGUNG-MUSTER-PROJEKTNUMMER_ANLAGENTYP Kopie/**'
		'**/REVISIONEN/**'
		'**/02 DGUV V3 ANLAGENPRUEFUNGEN/**'
		#'**//**'
	]

	let kunde = ($includeKunde | str join ",")
	
	print ($excludeKunde | describe)
	
	#updateKundelist 2022 $excludeKunde $kunde 4
	#updateKundelist 2023 $excludeKunde $kunde 3
	#updateKundelist 2024 $excludeKunde $kunde 4
	
	glob '~/home/siteca/projekte/Kunde_202*' --depth 1 | each {|e| open $e | writeJSONarray $in $kundeList} 

	

	prepProjektValues $kundeList	

	


	cd 'C:\Users\administrator.ME0\home\siteca\projekte'
} 

def prepProjektValues [projektRaw] {
	const projektClean = 'C:\Users\administrator.ME0\home\siteca\projekte\projekteClean.json'
	"{\n" | save --force $projektClean

	let table = open $projektRaw 
	$table | each {|pfad|
		print $pfad
		let e = ($pfad | split column '\')
		let elength = ($e | columns | length)
		print $e
		
		let length = ($e | columns | length)
		
		mut kunde = ($e.column5 | to text) 
		mut kundeLength = ($e.column5 | to text | str length)
		while $kundeLength < 20 { $kunde = $kunde + ' '; $kundeLength = $kundeLength + 1 }
		
		let column1 = ($e.column1 | to text)
		let column2 = ($e.column2 | to text)
		let column3 = ($e.column3 | to text)
		let column4 = ($e.column4 | to text)
		let column5 = ($e.column5 | to text)
		let column6 = ($e.column6 | to text)
		let column7 = (if ($elength > 6) {$e.column7 | to text})
		let column8 = (if ($elength > 7) {$e.column8 | to text})

			print ($"length: ($elength)")	
			print ($"6: ($column6)")
			print ($"7: ($column7)")
			print ($"8: ($column8)")

		match $column4 {
			'Projektdaten 2022' => {
				let jahr = $column6
				let projektname = (if ($column7 == "01 ANLAGEN" or $column7 == "01 Anlagen") {$column8} else {$column7})
				setProjektValues $jahr $kunde $projektname $projektClean $pfad

			}
			'Projektdaten 2023' => {
				let jahr = ($column4 | to text | split column ' ' | $in.column2 | to text)
				let projektname = (if (($column6 == "SITECA" or $column6 == "MOELLER-ELECTRO") and ($length == 7)) {$column7} else {$column6})
				setProjektValues $jahr $kunde $projektname $projektClean $pfad

			}
			'Projektdaten 2024' => {
				let jahr = ($column4 | to text| split column ' ' | $in.column2 | to text)
				let projektname = (if (($column6 == "SITECA" or $column6 == "MOELLER-ELECTRO") and ($length == 7)) {$column7} else {$column6})
				setProjektValues $jahr $kunde $projektname $projektClean $pfad
			}
		}
	}

	"}" | save --append $projektClean
	#open $projektClean --raw | to json | save --force $projektClean 
}

def setProjektValues [jahr kunde projekt file pfad] {
	let pfadClean = ($pfad | str replace --all '\' '\\')

	$'"($jahr) | ($kunde) | ($projekt)": {"jahr": "($jahr)" "kunde": "($kunde)" "projekt": "($projekt)" "pfad": "($pfadClean)"}' | save --append $file
	"\n" | save --append $file

}

def updateKundelist [jahr: int exclude kunde depth] {
	let drive = $'\\192.168.20.200\Projektdaten ($jahr)'
	let saveFile = $'C:\Users\administrator.ME0\home\siteca\projekte\Kunde_($jahr).json'
	if ($saveFile | path exists) {rm $saveFile}
	cd $drive
	match $jahr {
		2024 => {
			writeJSONarray (glob $"**/{($kunde)}/*" --no-file --exclude $exclude --depth $depth) $saveFile
			writeJSONarray (glob $"**/{($kunde)}/{MOELLER-ELECTRO,SITECA}/*" --no-file --exclude $exclude --depth $depth) $saveFile
		}
		2023 => {
			writeJSONarray (glob $"**/{($kunde)}/*" --no-file --exclude $exclude --depth $depth) $saveFile
			writeJSONarray (glob $"**/{($kunde)}/{MOELLER-ELECTRO,SITECA}/*" --no-file --exclude $exclude --depth $depth) $saveFile
		}
		2022 => {
			writeJSONarray (glob $"**/{($kunde)}/{201?,202?}/*" --no-file --exclude $exclude --depth $depth) $saveFile
			writeJSONarray (glob $"**/{($kunde)}/{201?,202?}/{01 ANLAGEN,01 Anlagen}/*" --no-file --exclude $exclude --depth $depth) $saveFile
			#writeJSONarray (glob $"**/{($kunde)}/{MOELLER-ELECTRO,SITECA}/*" --no-file --exclude $exclude --depth $depth) $saveFile
		}



	}
	#writeJSONarray (glob $"**/{($kunde)}/*/*{0,1,2,3,4,5,6,7,8,9}*_*" --no-file --exclude [$exclude] --depth $depth) $saveFile
}

def updateProjektlist [] {

}

def writeJSONarray [array file] {
	if ($file | path exists) {open $file | append $array | to json | save --force $file} else {$array | to json | save $file}
}
