class TokenReplacer extends DataProcessorBase {
    tokens := ""
    tokenPattern := ""
    tokenSeparator := ":"
    expansions := ""
    
    __New(tokens := "", tokenPattern := "", tokenSeparator := "", expansions := "") {
        if (!tokens) {
            tokens := Map()
        }

        if (!tokenPattern) {
            tokenPattern := "{{([^}]+)}}"
        }

        if (!expansions) {
            expansions := Map()
        }

        if (!tokenSeparator) {
            tokenSeparator := ":"
        }

        this.tokens := tokens
        this.tokenPattern := tokenPattern
        this.tokenSeparator := tokenSeparator
        this.expansions := expansions
    }

    ProcessSingleValue(value) {
        if (HasBase(value, Array.Prototype) || HasBase(value, Map.Prototype)) {
            for key, val in value {
                value[key] := this.ProcessSingleValue(val)
            }

            return value
        }

        if (Type(value) == "String") {
            startingPos := 1
            match := ""
            fullToken := ""
            replacements := Map()
            
            while (startingPos := RegExMatch(value, this.tokenPattern, &match, (startingPos + StrLen(fullToken)))) {
                fullToken := match[]
                innerToken := match[1]

                if (this.expansions.Has(fullToken)) {
                    innerToken := this.expansions[fullToken]
                } else if (this.expansions.Has(innerToken)) {
                    innerToken := this.expansions[innerToken]
                }
                
                tokenParts := StrSplit(innerToken, this.tokenSeparator)

                if (this.expansions.Has(tokenParts[1])) {
                    tokenParts[1] := this.expansions[tokenParts[1]]
                }

                known := false

                for key, val in this.tokens {
                    if (tokenParts[1] == key) {
                        known := true
                        break
                    }
                }

                if (known) {
                    replacements[fullToken] := this._replaceToken(tokenParts)
                }
                if (fullToken == "{{param.selectOptionsInternal}}") {
                    test := "here"
                }
                
            }

            for pattern, replacement in replacements {
                if (value == pattern) {
                    value := replacement
                } else if (Type(replacement) == "String" || IsNumber(replacement)) {
                    value := StrReplace(value, pattern, replacement)
                } else {
                    throw AppException("Replacement of type " . Type(replacement) " cannot be used.")
                }
            }
        }
        
        return value
    }

    _replaceToken(tokenParts) {
        context := this.tokens

        for index, token in tokenParts {
            if (!context.Has(token)) {
                throw DataException("Token not found: " . token)
            }

            context := context[token]
        }

        return this.Process(context)
    }
}
