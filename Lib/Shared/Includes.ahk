; Automatically-generated file. Manual edits will be overwritten.
#Include Vendor\Gdip_All.ahk
#Include Vendor\LV_Constants.ahk
#Include Volantis.App\App\AppBase.ahk
#Include Volantis.App\Authentication\AuthInfo\AuthInfo.ahk
#Include Volantis.App\Authentication\AuthInfo\JwtAuthInfo.ahk
#Include Volantis.App\Authentication\AuthProvider\AuthProviderBase.ahk
#Include Volantis.App\Authentication\AuthProvider\JwtAuthProvider.ahk
#Include Volantis.App\BulkOperation\BulkOperationBase.ahk
#Include Volantis.App\BulkOperation\ComponentDiscoverer\ClassFileComponentDiscoverer.ahk
#Include Volantis.App\BulkOperation\ComponentDiscoverer\ComponentDiscovererBase.ahk
#Include Volantis.App\BulkOperation\ComponentDiscoverer\ConfigComponentDiscoverer.ahk
#Include Volantis.App\BulkOperation\ComponentDiscoverer\FileComponentDiscovererBase.ahk
#Include Volantis.App\BulkOperation\ComponentDiscoverer\ModuleDiscoverer.ahk
#Include Volantis.App\BulkOperation\ComponentLoader\ClassComponentLoader.ahk
#Include Volantis.App\BulkOperation\ComponentLoader\ComponentLoaderBase.ahk
#Include Volantis.App\BulkOperation\ComponentLoader\SimpleComponentLoader.ahk
#Include Volantis.App\BulkOperation\InstallOp\InstallOp.ahk
#Include Volantis.App\BulkOperation\InstallOp\UpdateOp.ahk
#Include Volantis.App\BulkOperation\LoadOp\LoadBackupsOp.ahk
#Include Volantis.App\BulkOperation\LoadOp\LoadModulesOp.ahk
#Include Volantis.App\BulkOperation\OpError\BasicOpError.ahk
#Include Volantis.App\BulkOperation\OpError\OpErrorBase.ahk
#Include Volantis.App\BulkOperation\OpStatus\BasicOpStatus.ahk
#Include Volantis.App\BulkOperation\OpStatus\OpStatusBase.ahk
#Include Volantis.App\Cache\CacheBase.ahk
#Include Volantis.App\Cache\FileCache.ahk
#Include Volantis.App\Cache\ObjectCache.ahk
#Include Volantis.App\Config\AppConfig.ahk
#Include Volantis.App\Container\ServiceComponentContainer.ahk
#Include Volantis.App\Container\WindowContainer.ahk
#Include Volantis.App\DataSource\DataSourceBase.ahk
#Include Volantis.App\DataSourceItem\DataSourceItemBase.ahk
#Include Volantis.App\DataSourceItem\DSAssetFile.ahk
#Include Volantis.App\DataSourceItem\DSFile.ahk
#Include Volantis.App\DataSourceItem\DSJson.ahk
#Include Volantis.App\DataSourceItem\DSListing.ahk
#Include Volantis.App\Entity\AppEntityBase.ahk
#Include Volantis.App\Entity\BackupEntity.ahk
#Include Volantis.App\Event\AlterComponentsEvent.ahk
#Include Volantis.App\Event\AppRunEvent.ahk
#Include Volantis.App\Event\ComponentEvent.ahk
#Include Volantis.App\Event\ComponentInfoEvent.ahk
#Include Volantis.App\Event\DefineComponentsEvent.ahk
#Include Volantis.App\Event\LoadComponentEvent.ahk
#Include Volantis.App\Event\RegisterComponentsEvent.ahk
#Include Volantis.App\Event\ServiceDefinitionsEvent.ahk
#Include Volantis.App\Events\Events.ahk
#Include Volantis.App\Exception\AppException.ahk
#Include Volantis.App\Exception\LoginFailedException.ahk
#Include Volantis.App\Exception\ServiceNotFoundException.ahk
#Include Volantis.App\Exception\WindowNotFoundException.ahk
#Include Volantis.App\Gui\GuiBase.ahk
#Include Volantis.App\Gui\Dialog\DialogBox.ahk
#Include Volantis.App\Gui\Dialog\EntityDeleteWindow.ahk
#Include Volantis.App\Gui\Dialog\ErrorDialog.ahk
#Include Volantis.App\Gui\Dialog\SingleInputBox.ahk
#Include Volantis.App\Gui\Dialog\UpdateAvailableWindow.ahk
#Include Volantis.App\Gui\EntityEditor\EntityEditorBase.ahk
#Include Volantis.App\Gui\Form\FeedbackWindow.ahk
#Include Volantis.App\Gui\Form\FormGuiBase.ahk
#Include Volantis.App\Gui\Form\IconSelector.ahk
#Include Volantis.App\Gui\Menu\MenuGui.ahk
#Include Volantis.App\Gui\Progress\MiniProgressIndicator.ahk
#Include Volantis.App\Gui\Progress\ProgressIndicator.ahk
#Include Volantis.App\Gui\Progress\ProgressIndicatorBase.ahk
#Include Volantis.App\GuiControl\BasicControl.ahk
#Include Volantis.App\GuiControl\ButtonControl.ahk
#Include Volantis.App\GuiControl\CheckboxControl.ahk
#Include Volantis.App\GuiControl\ComboBoxControl.ahk
#Include Volantis.App\GuiControl\EditControl.ahk
#Include Volantis.App\GuiControl\EntityControl.ahk
#Include Volantis.App\GuiControl\GuiControlBase.ahk
#Include Volantis.App\GuiControl\ListViewControl.ahk
#Include Volantis.App\GuiControl\LocationBlock.ahk
#Include Volantis.App\GuiControl\SelectControl.ahk
#Include Volantis.App\GuiControl\StatusIndicatorControl.ahk
#Include Volantis.App\GuiControl\TabsControl.ahk
#Include Volantis.App\GuiControl\TitlebarControl.ahk
#Include Volantis.App\Installer\InstallerBase.ahk
#Include Volantis.App\Installer\ThemeInstaller.ahk
#Include Volantis.App\Installer\InstallerComponent\CopyableInstallerComponent.ahk
#Include Volantis.App\Installer\InstallerComponent\DownloadableInstallerComponent.ahk
#Include Volantis.App\Installer\InstallerComponent\FileInstallerComponentBase.ahk
#Include Volantis.App\Installer\InstallerComponent\GitHubReleaseInstallerComponent.ahk
#Include Volantis.App\Installer\InstallerComponent\InstallerComponentBase.ahk
#Include Volantis.App\Module\ModuleBase.ahk
#Include Volantis.App\Modules\Auth\Auth.module.ahk
#Include Volantis.App\Service\AppServiceBase.ahk
#Include Volantis.App\Service\AuthService.ahk
#Include Volantis.App\Service\EventManager.ahk
#Include Volantis.App\Service\LoggerService.ahk
#Include Volantis.App\Service\NotificationService.ahk
#Include Volantis.App\Service\ComponentManager\AppComponentServiceBase.ahk
#Include Volantis.App\Service\ComponentManager\CacheManager.ahk
#Include Volantis.App\Service\ComponentManager\ComponentServiceBase.ahk
#Include Volantis.App\Service\ComponentManager\DataSourceManager.ahk
#Include Volantis.App\Service\ComponentManager\GuiManager.ahk
#Include Volantis.App\Service\ComponentManager\InstallerManager.ahk
#Include Volantis.App\Service\ComponentManager\ThemeManager.ahk
#Include Volantis.App\Service\ContainerService\ConfigurableContainerServiceBase.ahk
#Include Volantis.App\Service\ContainerService\ContainerServiceBase.ahk
#Include Volantis.App\Service\ContainerService\ModuleManager.ahk
#Include Volantis.App\Service\EntityManager\BackupManager.ahk
#Include Volantis.App\Service\EntityManager\EntityManagerBase.ahk
#Include Volantis.App\State\AppState.ahk
#Include Volantis.App\State\CacheState.ahk
#Include Volantis.App\State\JsonState.ahk
#Include Volantis.App\State\StateBase.ahk
#Include Volantis.Base\CLR\CLR.ahk
#Include Volantis.Base\Event\EventBase.ahk
#Include Volantis.Base\Exception\ExceptionBase.ahk
#Include Volantis.Base\Exception\FileSystemException.ahk
#Include Volantis.Base\Exception\InvalidParameterException.ahk
#Include Volantis.Base\Exception\MethodNotImplementedException.ahk
#Include Volantis.Base\Exception\OperationFailedException.ahk
#Include Volantis.Base\HttpReq\HttpReqBase.ahk
#Include Volantis.Base\HttpReq\WinHttpReq.ahk
#Include Volantis.Component\Component\ComponentBase.ahk
#Include Volantis.Component\ComponentManager\ComponentManagerBase.ahk
#Include Volantis.Component\Event\ComponentDefinitionsEvent.ahk
#Include Volantis.Component\Event\ComponentManagerEvent.ahk
#Include Volantis.Component\Events\ComponentEvents.ahk
#Include Volantis.Component\Exception\ComponentException.ahk
#Include Volantis.Config\Config\ConfigBase.ahk
#Include Volantis.Config\Config\PersistentConfig.ahk
#Include Volantis.Config\Config\RuntimeConfig.ahk
#Include Volantis.Config\ConfigStorage\ConfigStorageBase.ahk
#Include Volantis.Config\ConfigStorage\JsonConfigStorage.ahk
#Include Volantis.Config\Exception\ConfigException.ahk
#Include Volantis.Container\Container\BasicContainer.ahk
#Include Volantis.Container\Container\ContainerBase.ahk
#Include Volantis.Container\Container\ParameterContainer.ahk
#Include Volantis.Container\Container\ServiceContainer.ahk
#Include Volantis.Container\ContainerRef\AppRef.ahk
#Include Volantis.Container\ContainerRef\ContainerRef.ahk
#Include Volantis.Container\ContainerRef\ContainerRefBase.ahk
#Include Volantis.Container\ContainerRef\ParameterRef.ahk
#Include Volantis.Container\ContainerRef\ServiceRef.ahk
#Include Volantis.Container\DefinitionLoader\ClassDiscoveryDefinitionLoader.ahk
#Include Volantis.Container\DefinitionLoader\DefinitionLoaderBase.ahk
#Include Volantis.Container\DefinitionLoader\DirDefinitionLoader.ahk
#Include Volantis.Container\DefinitionLoader\FileDefinitionLoader.ahk
#Include Volantis.Container\DefinitionLoader\MapDefinitionLoader.ahk
#Include Volantis.Container\DefinitionLoader\SimpleDefinitionLoader.ahk
#Include Volantis.Container\DefinitionLoader\StructuredDataDefinitionLoader.ahk
#Include Volantis.Container\Exception\ContainerException.ahk
#Include Volantis.Container\Exception\ParameterNotFoundException.ahk
#Include Volantis.Container\Query\ContainerQuery.ahk
#Include Volantis.Container\QueryCondition\HasServiceTagsCondition.ahk
#Include Volantis.Data\DiffResult.ahk
#Include Volantis.Data\DataProcessor\DataProcessorBase.ahk
#Include Volantis.Data\DataProcessor\PlaceholderExpander.ahk
#Include Volantis.Data\DataProcessor\StringSanitizer.ahk
#Include Volantis.Data\DataTemplate\AhkTemplate.ahk
#Include Volantis.Data\DataTemplate\DataTemplateBase.ahk
#Include Volantis.Data\DataTemplate\StringTemplate.ahk
#Include Volantis.Data\Exception\DataException.ahk
#Include Volantis.Data\Factory\StructuredDataFactory.ahk
#Include Volantis.Data\LayeredData\LayeredDataBase.ahk
#Include Volantis.Data\StructuredData\AhkVariable.ahk
#Include Volantis.Data\StructuredData\BasicData.ahk
#Include Volantis.Data\StructuredData\JsonData.ahk
#Include Volantis.Data\StructuredData\ProtobufData.ahk
#Include Volantis.Data\StructuredData\StructuredDataBase.ahk
#Include Volantis.Data\StructuredData\VdfData.ahk
#Include Volantis.Data\StructuredData\Xml.ahk
#Include Volantis.Entity\Entity\EntityBase.ahk
#Include Volantis.Entity\Exception\EntityException.ahk
#Include Volantis.Entity\Factory\EntityFactory.ahk
#Include Volantis.Entity\LayeredData\LayeredEntityData.ahk
#Include Volantis.File\ArchiveFile\ArchiveFileBase.ahk
#Include Volantis.File\ArchiveFile\ZipArchive.ahk
#Include Volantis.File\ArchiveFile\ZipArchive7z.ahk
#Include Volantis.File\Backup\BackupBase.ahk
#Include Volantis.File\Backup\FileBackup.ahk
#Include Volantis.File\ExeProcess\ExeProcess.ahk
#Include Volantis.Query\Condition\ConditionBase.ahk
#Include Volantis.Query\Condition\ContainsCondition.ahk
#Include Volantis.Query\Condition\EndsWithCondition.ahk
#Include Volantis.Query\Condition\FileConditionBase.ahk
#Include Volantis.Query\Condition\FileContainsCondition.ahk
#Include Volantis.Query\Condition\FileModifiedAfterCondition.ahk
#Include Volantis.Query\Condition\MatchesCondition.ahk
#Include Volantis.Query\Condition\RegExCondition.ahk
#Include Volantis.Query\Condition\StartsWithCondition.ahk
#Include Volantis.Query\ConditionGroup\AndGroup.ahk
#Include Volantis.Query\ConditionGroup\ConditionGroupBase.ahk
#Include Volantis.Query\ConditionGroup\OrGroup.ahk
#Include Volantis.Query\Exception\QueryException.ahk
#Include Volantis.Query\Query\MapQuery.ahk
#Include Volantis.Query\Query\QueryBase.ahk
#Include Volantis.Query\QueryCondition\FieldCondition.ahk
#Include Volantis.Query\QueryCondition\HasFieldCondition.ahk
#Include Volantis.Query\QueryCondition\IdCondition.ahk
#Include Volantis.Query\QueryCondition\QueryConditionBase.ahk
#Include Volantis.Theme\AnimatedGif\AnimatedGif.ahk
#Include Volantis.Theme\Factory\GuiFactory.ahk
#Include Volantis.Theme\Factory\ThemeFactory.ahk
#Include Volantis.Theme\GdiPlus\Gdip.ahk
#Include Volantis.Theme\GdiPlus\GdiPlusBase.ahk
#Include Volantis.Theme\GuiShape\GuiShapeBase.ahk
#Include Volantis.Theme\GuiShape\Button\ButtonShape.ahk
#Include Volantis.Theme\GuiShape\Button\MainMenuButtonShape.ahk
#Include Volantis.Theme\GuiShape\Button\ManageButtonShape.ahk
#Include Volantis.Theme\GuiShape\Button\MenuSeparatorShape.ahk
#Include Volantis.Theme\GuiShape\Button\StatusIndicatorButtonShape.ahk
#Include Volantis.Theme\GuiShape\Button\SymbolButtonShape.ahk
#Include Volantis.Theme\GuiSymbol\AddSymbol.ahk
#Include Volantis.Theme\GuiSymbol\ArrowDownSymbol.ahk
#Include Volantis.Theme\GuiSymbol\GuiSymbolBase.ahk
#Include Volantis.Theme\GuiSymbol\Titlebar\CloseSymbol.ahk
#Include Volantis.Theme\GuiSymbol\Titlebar\MaximizeSymbol.ahk
#Include Volantis.Theme\GuiSymbol\Titlebar\MinimizeSymbol.ahk
#Include Volantis.Theme\GuiSymbol\Titlebar\UnmaximizeSymbol.ahk
#Include Volantis.Theme\Theme\BasicTheme.ahk
#Include Volantis.Theme\Theme\ThemeBase.ahk
#Include Volantis.Utility\Debugger\Debugger.ahk
#Include Volantis.Utility\Hasher\FileHasher.ahk
#Include Volantis.Utility\Hasher\HasherBase.ahk
#Include Volantis.Utility\IdGenerator\IdGeneratorBase.ahk
#Include Volantis.Utility\IdGenerator\UuidGenerator.ahk
#Include Volantis.Utility\IncludeBuilder\AhkIncludeBuilder.ahk
#Include Volantis.Utility\IncludeBuilder\IncludeBuilderBase.ahk
#Include Volantis.Utility\IncludeWriter\AhkIncludeWriter.ahk
#Include Volantis.Utility\IncludeWriter\IncludeWriterBase.ahk
#Include Volantis.Utility\Locator\FileLocator.ahk
#Include Volantis.Utility\Locator\LocatorBase.ahk
#Include Volantis.Utility\Logger\FileLogger.ahk
#Include Volantis.Utility\Logger\LoggerBase.ahk
#Include Volantis.Utility\Notifier\NotifierBase.ahk
#Include Volantis.Utility\Notifier\ToastNotifier.ahk
#Include Volantis.Utility\VersionChecker\VersionChecker.ahk
