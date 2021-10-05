# ComponentLib

Often, an application needs one or more "manager" services which handle a list of "components" that they contain.

Launchpad makes use of this concept heavily, primarily within EntityLib where every entity is actually a component managed by an EntityManager service, which itself is a ComponentManager.

Components can be anything though, they don't have to be Entities. The idea is to make the concept generic enough to easily plug into a Service Container and use to manage a list of whatever you want.

## Requires

- ConfigLib
- ContainerLib
- UtilityLib
- DataLib
- BaseLib