; WARNING: This class probably doesn't work yet.
class CLR {
    static nullVal := ComValue(1, 0)
    static emptyArray := ComObjArray(0xC, 0)

    static LoadLibrary(assemblyName, appDomain := 0) {
        if (!appDomain) {
            appDomain := CLR.GetDefaultDomain()
        }

        assembly := ""

        Loop 1 {
                assembly := appDomain.Load_2(assemblyName)

                if (assembly) {
                    break
                }

                args := ComObjArray(0xC, 1)
                typeofAssembly := appDomain.GetType().Assembly.GetType()
                assembly := typeofAssembly.InvokeMember_3("LoadWithPartialName", 0x158, CLR.nullVal, CLR.nullVal, args)

                if (assembly) {
                    break
                }

                assembly := typeofAssembly.InvokeMember_3("LoadFrom", 0x158, CLR.nullVal, CLR.nullVal, args)

                if (assembly) {
                    break
                }
            }

        try {
            
        } catch Any {
            ; Ignore COM errors
        }
        
        return assembly
    }

    static CreateObject(assembly, typeName, args*) {
        argCount := args.MaxIndex()

        if (!argCount) {
            return assembly.CreateInstance_2(TypeName, true)
        }

        vargs := ComObjArray(0xC, argCount)

        Loop argCount {
            vargs[A_Index - 1] := args[A_Index]
        }

        return assembly.CreateInstance_3(typeName, true, 0, CLR.nullVal, vargs, CLR.nullVal, CLR.emptyArray)
    }

    static CompileCSharp(code, references := "", appDomain := 0, fileName := "", compilerOptions := "") {
        return CLR.CompileAssembly(code, references, "System", "Microsoft.CSharp.CSharpCodeProvider", appDomain, fileName, compilerOptions)
    }

    static CompileVB(code, references := "", appDomain := "", fileName := "", compilerOptions := "") {
        return CLR.CompileAssembly(code, references, "System", "Microsoft.VisualBasic.VBCodeProvider", appDomain, fileName, compilerOptions)
    }

    static StartDomain(&appDomain, baseDirectory := "") {
        args := ComObjArray(0xC, 5)
        args[0] := ""
        args[2] := baseDirectory
        args[4] := ComValue(0xB, false)

        appDomain := CLR.GetDefaultDomain().GetType().InvokeMember_3("CreateDomain", 0x158, CLR.nullVal, CLR.nullVal, args)
        return A_LastError >= 0
    }

    static StopDomain(&appDomain) {
        ; ICorRuntimeHost::UnloadDomain
        rtHst := CLR.Start()
        hr := DllCall(NumGet(NumGet(0+rtHst, "Ptr")+20*A_PtrSize, "Ptr"), "Ptr", rtHst, "Ptr", ComObjValue(appDomain))
        DllCall("SetLastError", "uint", hr)
        appDomain := ""
        return hr >= 0
    }

    static Start(version := "") {
        static rtHst := 0

        if (rtHst) {
            return rtHst
        }

        systemRoot := EnvGet("SystemRoot")

        if (version == "") {
            Loop Files systemRoot . "\Microsoft.NET\Framework" . (A_PtrSize == 8 ? "64" : "") . "\*", "D" {
                if (FileExist(A_LoopFileFullPath . "\mscorlib.dll")) {
                    version := A_LoopFileName
                }
            }
        }

        result := DllCall("mscoree\CorBindToRuntimeEx", "wstr", version, "Ptr", 0, "UInt", 0
        , "Ptr", CLR.GUID(&CLSID_CorRuntimeHost, "{CB2F6723-AB3A-11D2-9C40-00C04FA30A3E}")
        , "Ptr", CLR.GUID(&IID_ICorRuntimeHost,  "{CB2F6722-AB3A-11D2-9C40-00C04FA30A3E}")
        , "Ptr*", &rtHst)

        if (result) {
            DllCall(NumGet(NumGet(rtHst+0, "Ptr")+10*A_PtrSize, "Ptr"), "Ptr", rtHst)
        }

        return rtHst
    }

    static GetDefaultDomain() {
        static defaultDomain := 0

        if (!defaultDomain) {
            ; ICorRuntimeHost::GetDefaultDomain
            rtHst := CLR.Start()
            p := 0
            result := DllCall(NumGet(NumGet(rtHst+0, "Ptr")+13*A_PtrSize, "Ptr"), "Ptr", rtHst, "Ptr*", &p)

            if (result >= 0) {
                defaultDomain := ComObject(p)
                ObjRelease(p)
            }
        }

        return defaultDomain
    }

    static CompileAssembly(code, references, providerAssembly, providerType, appDomain := 0, fileName := "", compilerOptions := "") {
        if (!appDomain) {
            appDomain := CLR.GetDefaultDomain()
        }

        if !(asmProvider := CLR.LoadLibrary(providerAssembly, appDomain))
        || !(codeProvider := asmProvider.CreateInstance(providerType))
        || !(codeCompiler := codeProvider.CreateCompiler()) {
            return 0
        }

        asmSystem := (providerAssembly == "System") ? asmProvider : CLR.LoadLibrary("System", appDomain)

        if (!asmSystem) {
            return 0
        }

        refs := StrSplit(references, "|", A_Space . A_Tab)
        aRefs := ComObjArray(8, refs.Length)

        for index, value in refs {
            aRefs[index - 1] := value
        }

        prms := CLR.CreateObject(asmSystem, "System.CodeDom.Compiler.CompilerParameters", aRefs)
        prms.OutputAssembly := fileName
        prms.GenerateInMemory := (fileName == "")
        prms.GenerateExecutable := (SubStr(fileName, -3) == ".exe")
        prms.CompilerOptions := compilerOptions
        prms.IncludeDebugInformation := true

        compilerRes := codeCompiler.CompileAssemblyFromSource(prms, code)

        errors := compilerRes.Errors
        errorCount := errors.Count

        if (errorCount) {
            errorText := ""

            Loop errorCount {
                er := errors.Item[A_Index-1]
                errorText .= (er.IsWarning ? "Warning " : "Error ") . er.ErrorNumber . " on line " . er.Line . ": " . er.ErrorText . "`n`n"
            }

            MsgBox(errorText, "Compilation Failed", "Iconx")
            return 0
        }
        
        resultKey := fileName == "" ? "CompiledAssembly" : "PathToAssembly"
        return compilerRes[resultKey]
    }

    static GUID(&GUID, sGUID) {
        GUID := Buffer(16, 0)
        result := DllCall("ole32\CLSIDFromString", "WStr", sGUID, "Ptr", GUID.Ptr)

        return result >= 0 ? GUID.Ptr : ""
    }
}
