$env.EPLAN_XML_TYPE = ([tag] | into cell-path)
$env.EPLAN_XML_BODY = ([content 0 content 0 content] | into cell-path)
$env.EPLAN_XML_DATA = ([content 0 content] | into cell-path)


def EPLAN_XML_PARSING [xmlFile] {
	let body = (open ($xmlFile | path expand) | get $env.EPLAN_XML_BODY)
	mut header = {}
	mut columnHeader = []
	mut line = []
	mut footer = null
	mut file = {}

	$header = ($body | where tag == Header | get content.0? | if ($in != null) {EPLAN_XML_PARSING HEADER $in})
	$columnHeader = ($body | where tag == ColumnHeader | EPLAN_XML_PARSING COLUMNHEADER $in)
	$line = ($body | where tag == Line | EPLAN_XML_PARSING LINE $in)
	print "Creating new File"	
	$file = ($file | insert 'header' $header | insert 'columnHeader' $columnHeader | insert 'line' $line)
	print "done"
	return $file
}
def "EPLAN_XML_PARSING HEADER" [table] {
	print "Reading header"
	let size = ($table | length)
	let pathData = ([content] | into cell-path)
	let pathKey = ([0 content 0] | into cell-path)
	let pathValue = ([1 content 0] | into cell-path)
	mut header = {}
	mut data = null
	mut key = null
	mut value = null
	mut x = 0; while $x < $size {
		$table | get $x | get $pathData | $data = $in;
		$key = $data.0.content.0.content;
		$value = $data.1.content.0.content;

		$header = ($header | upsert $key $value)
		loadingBar $x $size;
		$x += 1}

	return $header

}
def "EPLAN_XML_PARSING COLUMNHEADER" [table] {
	print "Reading column header"
	let size = ($table | length)
	let pathData = ([content] | into cell-path)
	let pathKey = ([0 content 0] | into cell-path)
	let pathValue = ([1 content 0] | into cell-path)
	mut header = []
	mut data = null
	mut key = null
	mut value = null
	mut x = 0; while $x < $size {
		$table | get $x | get $pathData | $data = $in;
		$key = $data.0.content.0.content;
		#$value = $data.1.content;
		$header = ($header | append $key)
		loadingBar $x $size;
		$x += 1}

	return $header



}
def "EPLAN_XML_PARSING LINE" [table] {
	print "Reading line"
	let size = ($table | length)
	let pathData = ([content 0 content] | into cell-path)
	let pathKey = ([0 content 0] | into cell-path)
	let pathValue = ([1 content 0] | into cell-path)
	mut header = []
	mut data = null
	mut key = null
	mut value = null
	mut x = 0; while $x < $size {
		$table | get $x | get $pathData | each {|e| [[key value]; [$e.content.0.content.0.content $e.content.1.content.0?.content?]]} | flatten | transpose -r -d | $data = $in;
		$header = ($header | append $data);
		loadingBar $x $size;
		$x += 1}
	return $header




}
def "EPLAN_XML_PARSING FOOTER" [] {
	

}

def loadingBar [current1 max] {
	let current = ((($current1 / $max) * 100) | into int)
	let prev = (((($current1 - 1) / $max) * 100) | into int)
	#print $current " / " $max
	if ($current == 0) {print '(' (0..((100)) | par-each {"-"} | str join) ')' "\r" -n} else if (($current1 + 1) == $max) {print '(' (0..((100)) | par-each {"="} | str join) ')' -n; print ""} else if ($current > $prev) {print '(' (0..(($current)) | par-each {"="} | str join) "\r" -n} 
}
