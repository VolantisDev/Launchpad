import 'dart:io';

import 'package:xml/xml.dart';

import 'platform_locator.dart';

class XmlLocator extends PlatformLocatorBase {
  XmlLocator({
    required this.xmlFilePath,
    this.installDir,
    this.mainExe,
    this.installedVersion,
    this.uninstallCommand,
    this.icon,
    this.libraryDir,
  }) {
    var file = File(xmlFilePath);

    if (file.existsSync()) {
      document = XmlDocument.parse(file.readAsStringSync());
    }
  }

  final String xmlFilePath;
  XmlDocument? document;
  final XmlLocatorValue? installDir;
  final XmlLocatorValue? mainExe;
  final XmlLocatorValue? installedVersion;
  final XmlLocatorValue? uninstallCommand;
  final XmlLocatorValue? icon;
  final XmlLocatorValue? libraryDir;

  @override
  Future<String?> locateInstallDir() {
    return lookupValue(installDir);
  }

  @override
  Future<String?> locateMainExe() {
    return lookupValue(mainExe);
  }

  @override
  Future<String?> locateInstalledVersion() {
    return lookupValue(installedVersion);
  }

  @override
  Future<String?> locateUninstallCommand() {
    return lookupValue(uninstallCommand);
  }

  @override
  Future<String?> locateIcon() {
    return lookupValue(icon);
  }

  @override
  Future<List<String>?> locateLibraryDirs() async {
    var value = await lookupValue(libraryDir);

    return (value != null) ? [value] : null;
  }

  Future<String?> lookupValue(XmlLocatorValue? xmlValue) {
    return (xmlValue != null && document != null)
        ? xmlValue.lookupValue(document!.rootElement)
        : Future.value(null);
  }
}

class XmlLocatorValue {
  XmlLocatorValue(this.elementSelector);

  /// Select an element by path such as /settings/setting
  final String elementSelector;

  Future<String?> lookupValue(XmlElement rootElement) async {
    var xmlNode = rootElement;
    String? selectAttribute;

    if (elementSelector != '/') {
      var searchPath = elementSelector;

      if (searchPath.substring(0, 1) == '/') {
        searchPath = searchPath.substring(1);
      }

      for (final element in searchPath.split('/')) {
        final match = RegExp(
                r'(?<element>[^\[@]+)(\[@(?<attribute>[^=]+)=?"?(?<value>[^\]"]*)?"?\])?(@(?<selectAttribute>.+))?')
            .firstMatch(searchPath)!;

        final attribute = match.namedGroup('attribute');
        final value = match.namedGroup('value');
        selectAttribute = match.namedGroup('selectAttribute');

        for (final node in xmlNode.findElements(element)) {
          if (attribute != null && value != null) {
            var attributeValue = node.getAttribute(attribute);

            if (attributeValue == null || attributeValue != value) {
              continue;
            }
          }

          xmlNode = node;
          break;
        }
      }
    }

    var value = (selectAttribute != null && selectAttribute != "")
        ? xmlNode.getAttribute(selectAttribute)
        : xmlNode.text;

    return value;
  }
}
