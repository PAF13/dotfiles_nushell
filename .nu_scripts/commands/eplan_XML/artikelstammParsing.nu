def EPLANSTAMM [] {
	let artikelstamm = (open 'C:\Users\administrator.ME0\home\siteca\eplan\export\Eplan2024_Datenbank.xml')
	let propertiesOld = ($artikelstamm.content | where tag == 'DataConfiguration' | get content.0 | where tag == 'XPropertyEntry' | get attributes)
	let artikelOld = ($artikelstamm.content | where tag == 'O117' | get attributes)
	let artikelOld = ($artikelstamm.content | where tag == 'O99' | get attributes)
	
	let properties = (EPLANSTAMM getProbID $propertiesOld)
	let artikel = (EPLANSTAMM getartikel $artikelOld)

	let final = {properties: $properties artikel: $artikel}

	$final | explore -i
}


def "EPLANSTAMM getProbID" [properties] {
	let length = ($properties | length)
	mut propertyID = {}

	mut x = 0; while $x < $length {
		let prop = ($properties | get $x);
		$propertyID = ($propertyID | insert $prop.ID $prop.Description);
		$x += 1}

	return $propertyID
}

def "EPLANSTAMM getartikel" [artikellist] {
	let length = ($artikellist | length)
	mut artikellistnew = {}

	mut x = 0; while $x < $length {
		let artikel = ($artikellist | get $x | insert 'extra' []);
		$artikellistnew = ($artikellistnew | insert $artikel.A15 $artikel);
		$x += 1}

	return $artikellistnew
}

def "EPLANSTAMM getExtra" [artikel extraList] {
	let length = ($extraList | length)
	mut artikelList = $artikel

	mut x = 0; while $x < $length {
		let extra = ($extraList | get $x); 
		let extraID = ($extra.A15 | split column ' ' | get column1.0 | split column '/' | reject column1 column4 | transpose -i | get column0 | str join '/')
		$artikelList = ($artikelList | insert $artikel.A15 $artikel);
		$x += 1}

	return $artikelList
}
