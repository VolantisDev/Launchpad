# ContainerLib

ContainerLib provides a container to manage creation and location of services and parameters throughout your application.

Services can be defined either in code or in JSON files, with the automatic convention being AppName.services.json

Launchpad uses the container in a several-step process:
1. Load services/parameters defined in code
2. Load modules and the event handler
3. Call an event that allows other code to register services/parameters which extend or override the defaults
4. Load services/parameters from Launchpad.services.json

AppBase from AppLib handles all of this for you automatically if you are extending it.

If you only want parameters, use ParameterContainer. If you want to use both services and parameters, use ServiceContainer which 
offers the full functionality of both.

## Requires

- DataLib
- UtilityLib
- BaseLib
