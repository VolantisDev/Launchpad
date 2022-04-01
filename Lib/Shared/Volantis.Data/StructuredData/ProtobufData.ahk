class ProtobufData extends StructuredDataBase {
	primaryKey := "Database"
	protoFile := ""
	protoPath := ""
	protocLocal := ""

	; TODO: Remove dependency on A_ScriptDir
	static protoc := A_ScriptDir . "\Vendor\Protoc\bin\protoc.exe"

	__New(protoFile, protoPath := "", primaryKey := "", obj := "", protoc := "") {
		if (protoPath == "") {
			SplitPath(protoFile, &protoFile, &protoPath)
		}

		this.protoPath := protoPath
		this.protoFile := protoFile

		if (primaryKey) {
			this.primaryKey := primaryKey
		}

		if (!protoc) {
			protoc := ProtobufData.protoc
		}

		this.protocLocal := protoc

		super.__New(obj)
	}

	CountItems() {
		count := 0

		for key, value in this.obj {
			count++
		}

		return count
	}

	Clone() {
		newEntity := super.Clone()
        newEntity.obj := this.obj.Clone()
        newEntity := this.CloneChildMaps(newEntity)
	}

	CloneChildMaps(parentMap) {
        for key, child in parentMap {
            if (HasBase(child, Map.Prototype)) {
                parentMap[key] := this.CloneChildMaps(child)
            }
        }

        return parentMap
    }

    FromString(&src, args*) {
		static q := Chr(34)
		static letters := "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
		static numbers := "1234567890"

		returnData := Map()
		mainKey := ""
		key := ""
		is_key := true
		tree := []
		stack := [tree]
		is_arr := Map(tree, 1)
		next := letters . numbers
		pos := 0
		
		while ((ch := SubStr(src, ++pos, 1)) != "") {
			if InStr(" `t`n`r", ch) {
				continue
			}
				
			if !InStr(next, ch, true) {
				testArr := StrSplit(SubStr(src, 1, pos), "`n")				
				line := testArr.Length
				col := pos - InStr(src, "`n",, -(StrLen(src)-pos+1))

				msg := Format("{}: line {} col {} (char {})"
				,   (next == "")      ? ["Extra data", ch := SubStr(src, pos)][1]
				: (next == "\")     ? "Invalid \escape"
				: (next == ":")     ? "Expecting ':' delimiter"
				: (next == q)       ? "Expecting object key enclosed in double quotes"
				: (next == q . "}") ? "Expecting object key enclosed in double quotes or object closing '}'"
				: (next == ",}")    ? "Expecting ',' delimiter or object closing '}'"
				: (next == ",]")    ? "Expecting ',' delimiter or array closing ']'"
				: [ "Expecting value (string, number, true, false, null, map, or array)"
					, ch := SubStr(src, pos, (SubStr(src, pos)~="[\]\},\s]|$")-1) ][1]
				, line, col, pos)

				throw Error(msg, -1, ch)
			}
			
			obj := stack[1]
			is_array := HasBase(obj, Array.Prototype)
			
			if (ch == "{") { ; start new map
				val := Map()
				
				is_array ? obj.Push(val) : this.AddOrMergeValue(obj, key, val)
				stack.InsertAt(1,val)
				
				is_key := true
				is_arr[val] := false
				next := "}" . letters . numbers
			} else if (ch == "}") {
				stack.RemoveAt(1)
				next := stack[1]==tree ? "" : "}" . letters . numbers
				is_key := true
			} else if (ch == ":") {
				is_key := false
				next := q . numbers . letters
			} else if (is_key) {
				key := SubStr(src, pos, i := RegExMatch(src, "[:\s]|$",, pos)-pos)

				if (mainKey == "") {
					mainKey := key
				}

				next := ":{"
				is_key := false
				pos += i-1
			} else { ; string | number | true | false | null | enum
				if (ch == q) { ; string
					i := pos
					while i := InStr(src, q,, i+1) {
						val := StrReplace(SubStr(src, pos+1, i-pos-1), "\\", "\u005C")
						if (SubStr(val, -1) != "\")
							break
					}
					if !i ? (pos--, next := "'") : 0
						continue

					pos := i

					val := StrReplace(val, "\/", "/")
					val := StrReplace(val, "\" . q, q)
					, val := StrReplace(val, "\b", "`b")
					, val := StrReplace(val, "\f", "`f")
					, val := StrReplace(val, "\n", "`n")
					, val := StrReplace(val, "\r", "`r")
					, val := StrReplace(val, "\t", "`t")

					i := 0
					while i := InStr(val, "\",, i+1) {
						if (SubStr(val, i+1, 1) != "u") ? (pos -= StrLen(SubStr(val, i)), next := "\") : 0
							continue 2
					}
				} else { ; number | true | false | null
					val := SubStr(src, pos, i := RegExMatch(src, "[\]\},\s]|$",, pos)-pos)
					
					if IsInteger(val)
						val += 0
					else if IsFloat(val)
						val += 0
					else if (val == "true" || val == "false")
						val := (val == "true")
					else if (val == "null")
						val := ""

					pos += i-1
				}
				
				is_array ? obj.Push(val) : obj[key] := val
				is_key := true
				next := "}" . letters . numbers
			}

			if (next == "") {
				this.AddOrMergeValue(returnData, mainKey, tree[1])
				tree.RemoveAt(1)
				mainKey := ""
				is_key := true
				next := letters . numbers
			}
		}
		
		this.obj := returnData
		return this.obj
	}

	AddOrMergeValue(mapObj, key, val) {
		if (mapObj.Has(key)) {
			if (!HasBase(mapObj[key], Array.Prototype)) {
				mapObj[key] := [mapObj[key]]
			}

			mapObj[key].Push(val)
		} else {
			mapObj[key] := val
		}
	}

	FromFile(filePath, messageType := "") {
		if (messageType == "") {
			messageType := this.primaryKey
		}

		command := this.protocLocal . " --proto_path=`"" . this.protoPath . "`" --decode=" . messageType . " `"" . this.protoFile . "`" < `"" . filePath . "`""
		shell := ComObject("WScript.Shell")
        exec := Shell.Exec(A_ComSpec . " /C " . command)
		output := exec.StdOut.ReadAll()
		return this.FromString(&output)
	}

	ToString(obj := "", args*) {
        throw MethodNotImplementedException("ProtobufData", "ToString")
    }
}
