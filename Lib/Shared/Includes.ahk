; Automatically-generated file. Manual edits will be overwritten.
#Include Modules\Auth\AuthInfo\AuthInfo.ahk
#Include Modules\Auth\AuthInfo\JwtAuthInfo.ahk
#Include Modules\Auth\AuthProvider\AuthProviderBase.ahk
#Include Modules\Auth\AuthProvider\JwtAuthProvider.ahk
#Include Modules\LaunchpadApi\AuthProvider\LaunchpadApiAuthProvider.ahk
#Include Modules\LaunchpadApi\DataSource\ApiDataSource.ahk
#Include Vendor\Gdip_All.ahk
#Include Vendor\LV_Constants.ahk
#Include Volantis.App\App\AppBase.ahk
#Include Volantis.App\BulkOperation\BulkOperationBase.ahk
#Include Volantis.App\BulkOperation\InstallOp\InstallOp.ahk
#Include Volantis.App\BulkOperation\InstallOp\UpdateOp.ahk
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
#Include Volantis.App\Entity\TaskEntity.ahk
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
#Include Volantis.App\Gui\EntityEditor\SimpleEntityEditor.ahk
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
#Include Volantis.App\Service\AppServiceBase.ahk
#Include Volantis.App\Service\AuthService.ahk
#Include Volantis.App\Service\EventManager.ahk
#Include Volantis.App\Service\LoggerService.ahk
#Include Volantis.App\Service\NotificationService.ahk
#Include Volantis.App\Service\ComponentManager\CacheManager.ahk
#Include Volantis.App\Service\ComponentManager\DataSourceManager.ahk
#Include Volantis.App\Service\ComponentManager\GuiManager.ahk
#Include Volantis.App\Service\ComponentManager\InstallerManager.ahk
#Include Volantis.App\Service\ComponentManager\ThemeManager.ahk
#Include Volantis.App\Service\EntityManager\BackupManager.ahk
#Include Volantis.App\State\AppState.ahk
#Include Volantis.App\State\CacheState.ahk
#Include Volantis.App\State\JsonState.ahk
#Include Volantis.App\State\StateBase.ahk
#Include Volantis.Base\CLR\CLR.ahk
#Include Volantis.Base\Event\EventBase.ahk
#Include Volantis.Base\EventSubscriber\EventSubscriberBase.ahk
#Include Volantis.Base\Exception\ExceptionBase.ahk
#Include Volantis.Base\Exception\FileSystemException.ahk
#Include Volantis.Base\Exception\InvalidParameterException.ahk
#Include Volantis.Base\Exception\MethodNotImplementedException.ahk
#Include Volantis.Base\Exception\OperationFailedException.ahk
#Include Volantis.Base\HttpReq\HttpReqBase.ahk
#Include Volantis.Base\HttpReq\WinHttpReq.ahk
#Include Volantis.Component\ComponentManager\ComponentManagerBase.ahk
#Include Volantis.Component\ComponentManager\SimpleComponentManager.ahk
#Include Volantis.Component\Event\ComponentDefinitionsEvent.ahk
#Include Volantis.Component\Event\ComponentManagerEvent.ahk
#Include Volantis.Component\Events\ComponentEvents.ahk
#Include Volantis.Component\Exception\ComponentException.ahk
#Include Volantis.Config\Config\ChildConfig.ahk
#Include Volantis.Config\Config\ConfigBase.ahk
#Include Volantis.Config\Config\ContainerConfigBase.ahk
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
#Include Volantis.Container\ContainerRef\DataRef.ahk
#Include Volantis.Container\ContainerRef\ParameterRef.ahk
#Include Volantis.Container\ContainerRef\ServiceRef.ahk
#Include Volantis.Container\DefinitionLoader\ClassDiscoveryDefinitionLoader.ahk
#Include Volantis.Container\DefinitionLoader\DefinitionLoaderBase.ahk
#Include Volantis.Container\DefinitionLoader\DirDefinitionLoader.ahk
#Include Volantis.Container\DefinitionLoader\FileDefinitionLoader.ahk
#Include Volantis.Container\DefinitionLoader\FileDiscoveryDefinitionLoaderBase.ahk
#Include Volantis.Container\DefinitionLoader\MapDefinitionLoader.ahk
#Include Volantis.Container\DefinitionLoader\SimpleDefinitionLoader.ahk
#Include Volantis.Container\DefinitionLoader\StructuredDataDefinitionLoader.ahk
#Include Volantis.Container\Exception\ContainerException.ahk
#Include Volantis.Container\Exception\ParameterNotFoundException.ahk
#Include Volantis.Container\ParameterBag\ParameterBag.ahk
#Include Volantis.Container\Query\ContainerQuery.ahk
#Include Volantis.Container\QueryCondition\HasServiceTagsCondition.ahk
#Include Volantis.Container\QueryCondition\NamespaceMatchesCondition.ahk
#Include Volantis.Data\DiffResult.ahk
#Include Volantis.Data\ContainerContext\DataContext.ahk
#Include Volantis.Data\DataProcessor\DataProcessorBase.ahk
#Include Volantis.Data\DataProcessor\PlaceholderExpander.ahk
#Include Volantis.Data\DataProcessor\StringSanitizer.ahk
#Include Volantis.Data\DataProcessor\TokenReplacer.ahk
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
#Include Volantis.Entity\ComponentManager\EntityTypeManager.ahk
#Include Volantis.Entity\DefinitionLoader\DiscoveryEntityDefinitionLoader.ahk
#Include Volantis.Entity\DefinitionLoader\EntityDefinitionLoaderBase.ahk
#Include Volantis.Entity\DefinitionLoader\EntityTypeDefinitionLoaderBase.ahk
#Include Volantis.Entity\DefinitionLoader\ParameterEntityDefinitionLoader.ahk
#Include Volantis.Entity\DefinitionLoader\ParameterEntityTypeDefinitionLoader.ahk
#Include Volantis.Entity\Entity\EntityBase.ahk
#Include Volantis.Entity\Entity\FieldableEntity.ahk
#Include Volantis.Entity\EntityField\BooleanEntityField.ahk
#Include Volantis.Entity\EntityField\ClassNameEntityField.ahk
#Include Volantis.Entity\EntityField\DirEntityField.ahk
#Include Volantis.Entity\EntityField\EntityFieldBase.ahk
#Include Volantis.Entity\EntityField\EntityReferenceField.ahk
#Include Volantis.Entity\EntityField\FileEntityField.ahk
#Include Volantis.Entity\EntityField\FileEntityFieldBase.ahk
#Include Volantis.Entity\EntityField\HotkeyEntityField.ahk
#Include Volantis.Entity\EntityField\IconFileEntityField.ahk
#Include Volantis.Entity\EntityField\IdEntityField.ahk
#Include Volantis.Entity\EntityField\NumberEntityField.ahk
#Include Volantis.Entity\EntityField\ServiceReferenceField.ahk
#Include Volantis.Entity\EntityField\StringEntityField.ahk
#Include Volantis.Entity\EntityField\TimeOffsetEntityField.ahk
#Include Volantis.Entity\EntityField\UrlEntityField.ahk
#Include Volantis.Entity\EntityFieldWidget\CheckboxEntityFieldWidget.ahk
#Include Volantis.Entity\EntityFieldWidget\ComboBoxEntityFieldWidget.ahk
#Include Volantis.Entity\EntityFieldWidget\DirectoryEntityFieldWidget.ahk
#Include Volantis.Entity\EntityFieldWidget\EntityFieldWidgetBase.ahk
#Include Volantis.Entity\EntityFieldWidget\EntityFormEntityFieldWidget.ahk
#Include Volantis.Entity\EntityFieldWidget\EntitySelectEntityFieldWidget.ahk
#Include Volantis.Entity\EntityFieldWidget\FileEntityFieldWidget.ahk
#Include Volantis.Entity\EntityFieldWidget\HotkeyEntityFieldWidget.ahk
#Include Volantis.Entity\EntityFieldWidget\LocationEntityFieldWidgetBase.ahk
#Include Volantis.Entity\EntityFieldWidget\NumberEntityFieldWidget.ahk
#Include Volantis.Entity\EntityFieldWidget\SelectEntityFieldWidget.ahk
#Include Volantis.Entity\EntityFieldWidget\TextEntityFieldWidget.ahk
#Include Volantis.Entity\EntityFieldWidget\TimeOffsetEntityFieldWidget.ahk
#Include Volantis.Entity\EntityFieldWidget\UrlEntityFieldWidget.ahk
#Include Volantis.Entity\EntityForm\EntityFormBase.ahk
#Include Volantis.Entity\EntityForm\SimpleEntityForm.ahk
#Include Volantis.Entity\EntityManager\BasicEntityManager.ahk
#Include Volantis.Entity\EntityManager\EntityManagerBase.ahk
#Include Volantis.Entity\EntityStorage\ConfigEntityStorage.ahk
#Include Volantis.Entity\EntityStorage\EntityStorageBase.ahk
#Include Volantis.Entity\EntityType\BasicEntityType.ahk
#Include Volantis.Entity\EntityType\EntityTypeBase.ahk
#Include Volantis.Entity\Event\EntityDataProcessorsEvent.ahk
#Include Volantis.Entity\Event\EntityEvent.ahk
#Include Volantis.Entity\Event\EntityFieldDefinitionsEvent.ahk
#Include Volantis.Entity\Event\EntityFieldGroupsEvent.ahk
#Include Volantis.Entity\Event\EntityLayersEvent.ahk
#Include Volantis.Entity\Event\EntityReferenceEvent.ahk
#Include Volantis.Entity\Event\EntityRefreshEvent.ahk
#Include Volantis.Entity\Event\EntityStorageEvent.ahk
#Include Volantis.Entity\Event\EntityValidateEvent.ahk
#Include Volantis.Entity\Events\EntityEvents.ahk
#Include Volantis.Entity\Exception\EntityException.ahk
#Include Volantis.Entity\Factory\EntityFactory.ahk
#Include Volantis.Entity\Factory\EntityFieldFactory.ahk
#Include Volantis.Entity\Factory\EntityFieldWidgetFactory.ahk
#Include Volantis.Entity\Factory\EntityFormFactory.ahk
#Include Volantis.Entity\Factory\EntityTypeFactory.ahk
#Include Volantis.Entity\LayeredData\EntityData.ahk
#Include Volantis.Entity\Query\EntityQuery.ahk
#Include Volantis.Entity\Validator\BasicValidator.ahk
#Include Volantis.Entity\Validator\ValidatorBase.ahk
#Include Volantis.File\ArchiveFile\ArchiveFileBase.ahk
#Include Volantis.File\ArchiveFile\ZipArchive.ahk
#Include Volantis.File\ArchiveFile\ZipArchive7z.ahk
#Include Volantis.File\Backup\BackupBase.ahk
#Include Volantis.File\Backup\FileBackup.ahk
#Include Volantis.File\ExeProcess\ExeProcess.ahk
#Include Volantis.Module\ComponentManager\ModuleManager.ahk
#Include Volantis.Module\DefinitionLoader\ModuleDefinitionLoader.ahk
#Include Volantis.Module\Exception\ModuleException.ahk
#Include Volantis.Module\Factory\ModuleFactory.ahk
#Include Volantis.Module\Module\ModuleBase.ahk
#Include Volantis.Module\Module\SimpleModule.ahk
#Include Volantis.Module\ModuleInfo\FileModuleInfo.ahk
#Include Volantis.Module\ModuleInfo\ModuleInfoBase.ahk
#Include Volantis.Module\ModuleInfo\ParameterModuleInfo.ahk
#Include Volantis.Query\Condition\ClassNameExistsCondition.ahk
#Include Volantis.Query\Condition\ConditionBase.ahk
#Include Volantis.Query\Condition\ContainsCondition.ahk
#Include Volantis.Query\Condition\DirConditionBase.ahk
#Include Volantis.Query\Condition\DirExistsCondition.ahk
#Include Volantis.Query\Condition\EndsWithCondition.ahk
#Include Volantis.Query\Condition\FileConditionBase.ahk
#Include Volantis.Query\Condition\FileContainsCondition.ahk
#Include Volantis.Query\Condition\FileExistsCondition.ahk
#Include Volantis.Query\Condition\FileModifiedAfterCondition.ahk
#Include Volantis.Query\Condition\GreaterThanCondition.ahk
#Include Volantis.Query\Condition\IsEmptyCondition.ahk
#Include Volantis.Query\Condition\IsFloatCondition.ahk
#Include Volantis.Query\Condition\IsHotkeyCondition.ahk
#Include Volantis.Query\Condition\IsIntegerCondition.ahk
#Include Volantis.Query\Condition\IsNumberCondition.ahk
#Include Volantis.Query\Condition\IsTrueCondition.ahk
#Include Volantis.Query\Condition\IsUrlCondition.ahk
#Include Volantis.Query\Condition\KeyExistsCondition.ahk
#Include Volantis.Query\Condition\LessThanCondition.ahk
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
#Include Volantis.Theme\ParameterBag\GuiControlParameters.ahk
#Include Volantis.Theme\Theme\BasicTheme.ahk
#Include Volantis.Theme\Theme\ThemeBase.ahk
#Include Volantis.Utility\Cloner\ClonerBase.ahk
#Include Volantis.Utility\Cloner\ListCloner.ahk
#Include Volantis.Utility\Cloner\SimpleCloner.ahk
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
#Include Volantis.Utility\Merger\ListMerger.ahk
#Include Volantis.Utility\Merger\MergerBase.ahk
#Include Volantis.Utility\Notifier\NotifierBase.ahk
#Include Volantis.Utility\Notifier\ToastNotifier.ahk
#Include Volantis.Utility\VersionChecker\VersionChecker.ahk
