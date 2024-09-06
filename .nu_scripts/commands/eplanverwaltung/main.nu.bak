def EPLANVERWALTUNG [] {}

def "EPLANVERWALTUNG LIST_SCHEMATA" [] {
	cd 'X:\02 EPLAN\EPLAN\Data\Schemata\Siteca'
	#cd 'X:\02 EPLAN\EPLAN\Data\Schemata\Siteca'
	let list = (ls -a **/*/* | where name =~ .xml | where type == file)
	#print $list
	let length = ($list | length)
	mut schemaList = []
	mut x = 0; while $x < $length {
		let base = ($list | get $x)
		let pfad = ($list | get $x | get name);
		let split = ($pfad | path parse);
		let verzeichnisse = ($split | get parent | path split | get 0?);
		let schema = (open $pfad);
		let results = (EPLANVERWALTUNG CHECK_NAME $schema $pfad);
		$schemaList = ($schemaList | append $results);
		$x += 1
	}

	print ($schemaList | sort-by EPlan_type)

	#EPLANDOCUMENTATION ENTRY $schemaList
}

def "EPLANVERWALTUNG GET_DESCRIPTION" [schema] {
	let temp = ($schema 
	| get content.0?.content.0?.content.0.content.0.content 
	| where tag == Setting 
	| where attributes == {name: "Description" type: "mlstring"} 
	| get content.0?.content.0.content.0?)
	if (($temp | describe) == "nothing") {return "TODO"} else {return ($temp | str replace "??_??@" ""| str replace ";" "")}
}

def "EPLANVERWALTUNG CHECK_NAME" [schema pfad] {
	#steps:
	#
	
	let DEBUG = true

	let filename = ($pfad | path basename | path parse | get stem)

	mut name = ""
	mut nameschema = ""
	mut EPlan_type = ""
	mut EPlan_type = ""
	mut EPlan_variant = ""
	mut EPlan_sub_variant = ""
	let tag = ($schema | get tag)
	mut beschreibung = ""

	match $tag {
		#"Settings" => {$EPlan_type = ($schema | get content.0.content.0.attributes.name)}
		"Settings" => {
			$EPlan_type = ($schema | get content.attributes.0.name)

		}
		"EplanPxfRoot" => {
			$EPlan_type = ($schema | get attributes.Type)

		}
	}

	match $EPlan_type {
		"COMPANY" => {$EPlan_variant = ($schema | get content.0.content.0.attributes.name)}
		"PROJECT" => {$EPlan_variant = ($schema | get content.0.content.0.attributes.name)}
		"USER" => {$EPlan_variant = ($schema | get content.0.content.0.attributes.name)}
		"PlaPddTreePart" => {$EPlan_variant = ($EPlan_type)}
	}


	mut renamed = true
	mut EPlan_sub_variant = "TODO"
	mut EPlan_sub_variant = "TODO"
	mut prefix = ""
	(if ($DEBUG) {
		print "────────────────────────────────────────────────────────────────────────────"
		print "Type:		" $EPlan_type "\n" -n
		print "Variant:	" $EPlan_variant "\n" -n
	})	
	#EPlan Variant
	match $EPlan_variant {
		"Labelling" => {
			$beschreibung = (EPLANVERWALTUNG GET_DESCRIPTION $schema)
			$EPlan_variant = "Beschriftungen"
			$EPlan_sub_variant = ($schema | get content.0.content.0.content.0.content.0.content.0.content.1.content.0.content.0.content)
			match $EPlan_sub_variant {
				"30" => {$EPlan_sub_variant = "Artikelsummenstueckliste"}
				"19" => {$EPlan_sub_variant = "Verbindungsliste"}
				"13" => {$EPlan_sub_variant = "Betriebsmittelliste"}
				"12" => {$EPlan_sub_variant = "Klemmenaufreihplan"}
				"21" => {$EPlan_sub_variant = "Kabeluebersicht"}
				"11" => {$EPlan_sub_variant = "Kabelplan"}
				"9" => {$EPlan_sub_variant = "Klemmenplan"}
			}
		}
		"GedEdit3dGui" => {
			$beschreibung = (EPLANVERWALTUNG GET_DESCRIPTION $schema)
			$EPlan_variant = "Projekt 3D Auswertung"
			$EPlan_sub_variant = ($schema | get content.0.content.0.content.0.attributes.name)
			match $EPlan_sub_variant {
				"SelectUnits" => {
				}
				"Templates" => {
					$nameschema = ($filename)
				}

				"ViewPlacementLabeling" => {
				}
				_ => {$renamed = false}
			}
		}
		"FormGeneratorGui" => {
			$beschreibung = (EPLANVERWALTUNG GET_DESCRIPTION $schema)
			$EPlan_variant = "Projekt Auswertung"
			$EPlan_sub_variant = ($schema | get content.0.content.0.content.0.attributes.name)
			match $EPlan_sub_variant {
				"FilterScheme" => {
				}
				"Templates" => {
					$nameschema = ($filename)
				}
				_ => {$renamed = false}
			}
		}
		"XEsInspectionGui" => {
			$beschreibung = (EPLANVERWALTUNG GET_DESCRIPTION $schema)
			$EPlan_sub_variant = ($schema | get content.0.content.0.content.0.attributes.name)
			match $EPlan_sub_variant {
				_ => {$renamed = false}
			}
		}
		"CabinetGui" => {
			$beschreibung = (EPLANVERWALTUNG GET_DESCRIPTION $schema)
			$EPlan_variant = "Projekt Einstellung"
			$EPlan_sub_variant = ($schema | get content.0.content.0.content.0.attributes.name)
			match $EPlan_sub_variant {
				_ => {$renamed = false}
			}
		}
		"CabinetLog" => {
			$beschreibung = (EPLANVERWALTUNG GET_DESCRIPTION $schema)
			$EPlan_sub_variant = ($schema | get content.0.content.0.content.0.attributes.name)
			match $EPlan_sub_variant {
				_ => {$renamed = false}
			}
		}
		"AF" => {
			$beschreibung = (EPLANVERWALTUNG GET_DESCRIPTION $schema)
			$EPlan_sub_variant = ($schema | get content.0.content.0.content.0.attributes.name)
			match $EPlan_sub_variant {
				_ => {$renamed = false}
			}
		}
		"ConnectionBrowserGui" => {
			$beschreibung = (EPLANVERWALTUNG GET_DESCRIPTION $schema)
			$EPlan_sub_variant = ($schema | get content.0.content.0.content.0.attributes.name)
			match $EPlan_sub_variant {
				_ => {$renamed = false}
			}
		}
		"EServicesGui" => {
			$beschreibung = (EPLANVERWALTUNG GET_DESCRIPTION $schema)
			$EPlan_sub_variant = ($schema | get content.0.content.0.content.0.attributes.name)
			match $EPlan_sub_variant {
				_ => {$renamed = false}
			}
		}
		"NCLog" => {
			$beschreibung = (EPLANVERWALTUNG GET_DESCRIPTION $schema)
			$EPlan_variant = "Mechanische Bearbeitung"
			$EPlan_sub_variant = ($schema | get content.0.content.0.content.0.attributes.name)
		
		}
		"PDFExportGUI" => {
			$beschreibung = (EPLANVERWALTUNG GET_DESCRIPTION $schema)
			$EPlan_variant = "Export PDF"
		#$prefix = "PDs."
			$EPlan_sub_variant = ($schema | get content.0.content.0.content.0.attributes.name)
		
		}
		"PartsExtensionGui" => {
			$beschreibung = (EPLANVERWALTUNG GET_DESCRIPTION $schema)
			$EPlan_sub_variant = ($schema | get content.0.content.0.content.0.attributes.name)
			match $EPlan_sub_variant {
				_ => {$renamed = false}
			}
		}
		"ProjectCleanGui" => {
			$beschreibung = (EPLANVERWALTUNG GET_DESCRIPTION $schema)
			$EPlan_sub_variant = ($schema | get content.0.content.0.content.0.attributes.name)
			match $EPlan_sub_variant {
				_ => {$renamed = false}
			}
		}
		"WORKSPACE_BCG" => {
			$beschreibung = (EPLANVERWALTUNG GET_DESCRIPTION $schema)

			$EPlan_sub_variant = ($schema | get content.0.content.0.content.0.attributes.name)
			match $EPlan_sub_variant {
				_ => {$renamed = false}
			}
		}
		"WireNumberingLog" => {
			$beschreibung = (EPLANVERWALTUNG GET_DESCRIPTION $schema)
			$EPlan_sub_variant = ($schema | get content.0.content.0.content.0.attributes.name)
			match $EPlan_sub_variant {
				_ => {$renamed = false}
			}
		}
		"PlaPddTreePart" => {
			#$beschreibung = (EPLANVERWALTUNG GET_DESCRIPTION $schema)
			$prefix = "PcPr."
			#$EPlan_sub_variant = ($schema | get content.0.content.0.content.0.attributes.name)
			match $EPlan_sub_variant {
				_ => {$renamed = false}
			}
		}
		_ => {
			$EPlan_variant = "TODO"	
			$EPlan_sub_variant = "TODO"
			match $EPlan_sub_variant {
				_ => {$renamed = false}
			}
	}

	}
	
	
	mut typ = ''
	mut kurztext = ''
	mut version = '00.00'
	
	let pathParsed = ($pfad | path parse)

	let pathOld = ($pathParsed | get parent)
	let pathNew = ($EPlan_variant)

	let fileOld = (($pathParsed | get stem) + '.' + ($pathParsed | get extension))
	let fileNew = (($pathParsed | get stem) + '.' + ($pathParsed | get extension))
	let start = ($'($pathOld)\($fileNew)')
	let goal = ($'($EPlan_variant)\($fileNew)')

	(if ($DEBUG) {
		print "Tag:		" $tag "\n" -n
		print "Sub Variant:	" $EPlan_sub_variant "\n" -n
		print "─────────────────"
		print "File Old:	" $fileOld "\n" -n
		print "Path Old:	" $pathOld "\n" -n
		print "File New:	" $fileNew "\n" -n
		print "Path New:	" $pathNew "\n" -n
		print "Start:		" $start "\n" -n
		print "Goal:		" $goal "\n" -n
		print "────────────────────────────────────────────────────────────────────────────"

	})	


	let e = {
		tag: $tag
		EPlan_type: $EPlan_type 
		EPlan_Variant: $EPlan_variant
		EPlan_SubVariant: $EPlan_sub_variant
		renamed: $renamed
		beschreibung: $beschreibung
		dateiname: $fileNew
		#prefix: $prefix
		#name: $name
		#schema: $nameschema
		#typ: $typ 
		#kurztext: $kurztext 
		#beschreibung: $beschreibung 
		version: $version
	}
	#organize

	#EPLANVERWALTUNG RENAME_NAME $schema $noName $name $pfad
	EPLANVERWALTUNG FILE_MOVE $start $goal $pathNew
	EPLANDOCUMENTATION ENTRY $schema $e

	return $e
}


def "EPLANVERWALTUNG FILE_MOVE" [oldPath newPath newDir] {
	if (($newPath | path exists) == false) {mkdir $newDir}
	if ($oldPath != $newPath) {mv -v -p -i $oldPath $newPath}
}

def "EPLANVERWALTUNG RENAME_NAME" [schema noName name file] {
	let name = ($schema | get content.0.content.0.content.0.content.0.attributes.name?)
	mut schemaNew = $schema
	print $'"($name)"'
	print ($name | describe)
	if ($noName and $name != "" and $name != null) {
		print "Input new name"
		print $name
		mut value = (input)
		if ($value == "") {$value = $name}
		$schemaNew = ($schema | update content.0.content.0.content.0.content.0.attributes.name $value)
	}
	
	$schemaNew | save --force $file
	#return $schemaNew
}


def EPLANDOCUMENTATION [] {}

#C:\Users\administrator.ME0\home\notes\siteca_wiki\Eplan\P8 und ProPanel\Schemata


def "EPLANDOCUMENTATION ENTRY" [xml e] {
	let docs = 'C:\Users\administrator.ME0\home\notes\siteca_wiki\Eplan\P8 und ProPanel'
	let template = (open ~/home/.config/nushell/.nu_scripts/commands/obsidian/templates/quartz_base.txt)
	cd $docs
	#print "removing folder"
	#if ("Schemata" | path exists) {rm -r "Schemata"}
	#print "re-adding folder"
	#mkdir "Schemata"
	
	EPLANDOCUMENTATION MKFILES $e $template $xml

}


def "EPLANDOCUMENTATION MKFILES" [schema template xml] {
	mut file = $template
	if (($schema.EPlan_Variant | path exists) == false) {mkdir $'Schemata\($schema.EPlan_Variant)'}
	"" | save --force $'Schemata\($schema.EPlan_Variant)\($schema.dateiname).md'
	
	$file = ($file | str replace '{{ID}}' $schema.dateiname)
	$file = ($file | str replace '{{TAGS}}' (
		"\n"
		+ "- Eplan"
		+ "\n"
		+ $"- ($schema.EPlan_Variant)"
	))
	$file = ($file | str replace '{{TITLE}}' $schema.dateiname)

	$file = (
		$file

		+ "\n"
		+ "\n"
		+ "# Info"
		+ "\n"
		+ "\n"
		+ "# Beschreibung"
		+ "\n"
		+ $schema.beschreibung
		+ "\n"
		+ "# XML"
		+ "\n"
		+ "```xml\n"
		#+ ($xml | to xml --indent 3) 
		+ "```"
	)
	
	#print $file
	$file | save --append $'Schemata\($schema.EPlan_Variant)\($schema.dateiname).md'
}
