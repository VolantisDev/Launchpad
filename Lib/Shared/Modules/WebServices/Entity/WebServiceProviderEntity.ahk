class WebServiceProviderEntity extends FieldableEntity {
    isWebServiceEntity := true

    BaseFieldDefinitions() {
        definitions := super.BaseFieldDefinitions()

        definitions["EndpointUrl"] := Map(
            "default", "",
            "required", true
        )

        definitions["AuthenticationEndpointUrl"] := Map(
            "default", "",
            "required", false
        )

        definitions["AuthenticationRefreshPath"] := Map(
            "default", "",
            "required", false
        )

        definitions["IconSrc"] := Map(
            "type", "icon_file",
            "default", "webhook",
            "required", true
        )

        definitions["SupportsAuthentication"] := Map(
            "type", "boolean",
            "required", false,
            "default", false
        )

        definitions["Authenticator"] := Map(
            "type", "service_reference",
            "servicePrefix", "web_services_authenticator.",
            "default", "",
            "required", false
        )

        definitions["DefaultMethod"] := Map(
            "default", "GET",
            "required", false
        )

        definitions["AuthenticateRequestsByDefault"] := Map(
            "type", "boolean",
            "default", false,
            "required", false
        )

        definitions["LoginWindow"] := Map(
            "default", "",
            "required", false
        )

        definitions["AppKey"] := Map(
            "default", "",
            "required", false
        )

        return definitions
    }

    Url(path, queryParams := "") {
        if (InStr(path, "/") != 1) {
            path := "/" . path
        }

        return UrlObj(this["EndpointUrl"] . path)
            .AddQueryParams(queryParams)
    }

    FullPath(path) {
        url := this.Url(path)
        return url.Path
    }

    GetAuthenticationRefreshUrl(queryParams := "") {
        endpointUrl := this["AuthenticationEndpointUrl"] 
            ? this["AuthenticationEndpointUrl"] 
            : this["EndpointUrl"]
        refreshPath := this["AuthenticationRefreshPath"]

        if (refreshPath && InStr(refreshPath, "/") != 1) {
            refreshPath := "/" . refreshPath
        }

        return UrlObj(endpointUrl . refreshPath)
            .AddQueryParams(queryParams)
    }
}
