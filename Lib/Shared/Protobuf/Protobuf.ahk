; Class: Protobuf
; Description: Protobuf parser for Autohotkey
; Author: Ben McClure <ben.mcclure@gmail.com>
; Version: 1.0.0
;
; Requirements:
;   Either:
;     - An already-decompiled protobuff structure
;   Or:
;     - protoc.exe from https://github.com/protocolbuffers/protobuf/releases and
;     - A .proto schema file
;
; Note: There is no dumping a map back to a protobuf structure yet, sorry!
; 
class Protobuf {
	static protoc := A_ScriptDir . "\Vendor\Protoc\bin\protoc.exe"

    static FromString(ByRef src) {
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
				ln := testArr.Length
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
				, ln, col, pos)

				throw Exception(msg, -1, ch)
			}
			
			obj := stack[1]
			is_array := (Type(obj) == "Array") ? 1 : 0
			
			if (ch == "{") { ; start new map
				val := Map()
				
				is_array ? obj.Push(val) : Protobuf.AddOrMergeValue(obj, key, val)
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
				Protobuf.AddOrMergeValue(returnData, mainKey, tree[1])
				mainKey := ""
				is_key := true
				next := letters . numbers
			}
		}
		
		return returnData
	}

	static AddOrMergeValue(mapObj, key, val) {
		if (mapObj.Has(key)) {
			if (Type(mapObj[key]) != "Array") {
				mapObj[key] := [mapObj[key]]
			}

			mapObj[key].Push(val)
		} else {
			mapObj[key] := val
		}
	}

	static FromFile(filePath, messageType, protoFile, protoPath := "", protoc := "") {
		if (protoPath == "") {
			SplitPath(protoFile, protoFile, protoPath)
		}

		if (protoc == "") {
			protoc := Protobuf.protoc
		}

		command := protoc . " --proto_path=`"" . protoPath . "`" --decode=" . messageType . " `"" . protoFile . "`" < `"" . filePath . "`""
		shell := ComObjCreate("WScript.Shell")
        exec := Shell.Exec(A_ComSpec . " /C " . command)
		output := exec.StdOut.ReadAll()
		return Protobuf.FromString(output)
	}
}
