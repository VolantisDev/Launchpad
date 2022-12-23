// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_data.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

extension GetGameDataCollection on Isar {
  IsarCollection<GameData> get gameDatas => this.collection();
}

const GameDataSchema = CollectionSchema(
  name: r'GameData',
  id: -6579857273911918101,
  properties: {
    r'exeFile': PropertySchema(
      id: 0,
      name: r'exeFile',
      type: IsarType.string,
    ),
    r'iconPath': PropertySchema(
      id: 1,
      name: r'iconPath',
      type: IsarType.string,
    ),
    r'iconType': PropertySchema(
      id: 2,
      name: r'iconType',
      type: IsarType.string,
    ),
    r'installDir': PropertySchema(
      id: 3,
      name: r'installDir',
      type: IsarType.string,
    ),
    r'key': PropertySchema(
      id: 4,
      name: r'key',
      type: IsarType.string,
    ),
    r'name': PropertySchema(
      id: 5,
      name: r'name',
      type: IsarType.string,
    ),
    r'platformRef': PropertySchema(
      id: 6,
      name: r'platformRef',
      type: IsarType.string,
    )
  },
  estimateSize: _gameDataEstimateSize,
  serialize: _gameDataSerialize,
  deserialize: _gameDataDeserialize,
  deserializeProp: _gameDataDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'gamePlatform': LinkSchema(
      id: -6693473593046117857,
      name: r'gamePlatform',
      target: r'GamePlatformData',
      single: true,
    ),
    r'launchConfig': LinkSchema(
      id: 6684939833935828972,
      name: r'launchConfig',
      target: r'LaunchConfigData',
      single: true,
    ),
    r'launchProcesses': LinkSchema(
      id: -8678547302105873528,
      name: r'launchProcesses',
      target: r'LaunchProcessData',
      single: false,
    )
  },
  embeddedSchemas: {},
  getId: _gameDataGetId,
  getLinks: _gameDataGetLinks,
  attach: _gameDataAttach,
  version: '3.0.5',
);

int _gameDataEstimateSize(
  GameData object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.exeFile;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.iconPath;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.iconType;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.installDir;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.key;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.name;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.platformRef;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _gameDataSerialize(
  GameData object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.exeFile);
  writer.writeString(offsets[1], object.iconPath);
  writer.writeString(offsets[2], object.iconType);
  writer.writeString(offsets[3], object.installDir);
  writer.writeString(offsets[4], object.key);
  writer.writeString(offsets[5], object.name);
  writer.writeString(offsets[6], object.platformRef);
}

GameData _gameDataDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = GameData();
  object.exeFile = reader.readStringOrNull(offsets[0]);
  object.iconPath = reader.readStringOrNull(offsets[1]);
  object.iconType = reader.readStringOrNull(offsets[2]);
  object.id = id;
  object.installDir = reader.readStringOrNull(offsets[3]);
  object.key = reader.readStringOrNull(offsets[4]);
  object.name = reader.readStringOrNull(offsets[5]);
  object.platformRef = reader.readStringOrNull(offsets[6]);
  return object;
}

P _gameDataDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _gameDataGetId(GameData object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _gameDataGetLinks(GameData object) {
  return [object.gamePlatform, object.launchConfig, object.launchProcesses];
}

void _gameDataAttach(IsarCollection<dynamic> col, Id id, GameData object) {
  object.id = id;
  object.gamePlatform.attach(
      col, col.isar.collection<GamePlatformData>(), r'gamePlatform', id);
  object.launchConfig.attach(
      col, col.isar.collection<LaunchConfigData>(), r'launchConfig', id);
  object.launchProcesses.attach(
      col, col.isar.collection<LaunchProcessData>(), r'launchProcesses', id);
}

extension GameDataQueryWhereSort on QueryBuilder<GameData, GameData, QWhere> {
  QueryBuilder<GameData, GameData, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension GameDataQueryWhere on QueryBuilder<GameData, GameData, QWhereClause> {
  QueryBuilder<GameData, GameData, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<GameData, GameData, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<GameData, GameData, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<GameData, GameData, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<GameData, GameData, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension GameDataQueryFilter
    on QueryBuilder<GameData, GameData, QFilterCondition> {
  QueryBuilder<GameData, GameData, QAfterFilterCondition> exeFileIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'exeFile',
      ));
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition> exeFileIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'exeFile',
      ));
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition> exeFileEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'exeFile',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition> exeFileGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'exeFile',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition> exeFileLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'exeFile',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition> exeFileBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'exeFile',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition> exeFileStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'exeFile',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition> exeFileEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'exeFile',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition> exeFileContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'exeFile',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition> exeFileMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'exeFile',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition> exeFileIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'exeFile',
        value: '',
      ));
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition> exeFileIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'exeFile',
        value: '',
      ));
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition> iconPathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'iconPath',
      ));
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition> iconPathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'iconPath',
      ));
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition> iconPathEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'iconPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition> iconPathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'iconPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition> iconPathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'iconPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition> iconPathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'iconPath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition> iconPathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'iconPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition> iconPathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'iconPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition> iconPathContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'iconPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition> iconPathMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'iconPath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition> iconPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'iconPath',
        value: '',
      ));
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition> iconPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'iconPath',
        value: '',
      ));
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition> iconTypeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'iconType',
      ));
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition> iconTypeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'iconType',
      ));
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition> iconTypeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'iconType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition> iconTypeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'iconType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition> iconTypeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'iconType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition> iconTypeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'iconType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition> iconTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'iconType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition> iconTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'iconType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition> iconTypeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'iconType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition> iconTypeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'iconType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition> iconTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'iconType',
        value: '',
      ));
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition> iconTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'iconType',
        value: '',
      ));
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition> idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition> idEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition> idGreaterThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition> idLessThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition> idBetween(
    Id? lower,
    Id? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition> installDirIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'installDir',
      ));
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition>
      installDirIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'installDir',
      ));
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition> installDirEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'installDir',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition> installDirGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'installDir',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition> installDirLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'installDir',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition> installDirBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'installDir',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition> installDirStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'installDir',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition> installDirEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'installDir',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition> installDirContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'installDir',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition> installDirMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'installDir',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition> installDirIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'installDir',
        value: '',
      ));
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition>
      installDirIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'installDir',
        value: '',
      ));
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition> keyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'key',
      ));
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition> keyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'key',
      ));
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition> keyEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'key',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition> keyGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'key',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition> keyLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'key',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition> keyBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'key',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition> keyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'key',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition> keyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'key',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition> keyContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'key',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition> keyMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'key',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition> keyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'key',
        value: '',
      ));
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition> keyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'key',
        value: '',
      ));
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition> nameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition> nameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition> nameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition> nameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition> nameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition> nameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition> nameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition> platformRefIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'platformRef',
      ));
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition>
      platformRefIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'platformRef',
      ));
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition> platformRefEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'platformRef',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition>
      platformRefGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'platformRef',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition> platformRefLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'platformRef',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition> platformRefBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'platformRef',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition> platformRefStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'platformRef',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition> platformRefEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'platformRef',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition> platformRefContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'platformRef',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition> platformRefMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'platformRef',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition> platformRefIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'platformRef',
        value: '',
      ));
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition>
      platformRefIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'platformRef',
        value: '',
      ));
    });
  }
}

extension GameDataQueryObject
    on QueryBuilder<GameData, GameData, QFilterCondition> {}

extension GameDataQueryLinks
    on QueryBuilder<GameData, GameData, QFilterCondition> {
  QueryBuilder<GameData, GameData, QAfterFilterCondition> gamePlatform(
      FilterQuery<GamePlatformData> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'gamePlatform');
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition> gamePlatformIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'gamePlatform', 0, true, 0, true);
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition> launchConfig(
      FilterQuery<LaunchConfigData> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'launchConfig');
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition> launchConfigIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'launchConfig', 0, true, 0, true);
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition> launchProcesses(
      FilterQuery<LaunchProcessData> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'launchProcesses');
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition>
      launchProcessesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'launchProcesses', length, true, length, true);
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition>
      launchProcessesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'launchProcesses', 0, true, 0, true);
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition>
      launchProcessesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'launchProcesses', 0, false, 999999, true);
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition>
      launchProcessesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'launchProcesses', 0, true, length, include);
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition>
      launchProcessesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'launchProcesses', length, include, 999999, true);
    });
  }

  QueryBuilder<GameData, GameData, QAfterFilterCondition>
      launchProcessesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'launchProcesses', lower, includeLower, upper, includeUpper);
    });
  }
}

extension GameDataQuerySortBy on QueryBuilder<GameData, GameData, QSortBy> {
  QueryBuilder<GameData, GameData, QAfterSortBy> sortByExeFile() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exeFile', Sort.asc);
    });
  }

  QueryBuilder<GameData, GameData, QAfterSortBy> sortByExeFileDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exeFile', Sort.desc);
    });
  }

  QueryBuilder<GameData, GameData, QAfterSortBy> sortByIconPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iconPath', Sort.asc);
    });
  }

  QueryBuilder<GameData, GameData, QAfterSortBy> sortByIconPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iconPath', Sort.desc);
    });
  }

  QueryBuilder<GameData, GameData, QAfterSortBy> sortByIconType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iconType', Sort.asc);
    });
  }

  QueryBuilder<GameData, GameData, QAfterSortBy> sortByIconTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iconType', Sort.desc);
    });
  }

  QueryBuilder<GameData, GameData, QAfterSortBy> sortByInstallDir() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'installDir', Sort.asc);
    });
  }

  QueryBuilder<GameData, GameData, QAfterSortBy> sortByInstallDirDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'installDir', Sort.desc);
    });
  }

  QueryBuilder<GameData, GameData, QAfterSortBy> sortByKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.asc);
    });
  }

  QueryBuilder<GameData, GameData, QAfterSortBy> sortByKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.desc);
    });
  }

  QueryBuilder<GameData, GameData, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<GameData, GameData, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<GameData, GameData, QAfterSortBy> sortByPlatformRef() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'platformRef', Sort.asc);
    });
  }

  QueryBuilder<GameData, GameData, QAfterSortBy> sortByPlatformRefDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'platformRef', Sort.desc);
    });
  }
}

extension GameDataQuerySortThenBy
    on QueryBuilder<GameData, GameData, QSortThenBy> {
  QueryBuilder<GameData, GameData, QAfterSortBy> thenByExeFile() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exeFile', Sort.asc);
    });
  }

  QueryBuilder<GameData, GameData, QAfterSortBy> thenByExeFileDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exeFile', Sort.desc);
    });
  }

  QueryBuilder<GameData, GameData, QAfterSortBy> thenByIconPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iconPath', Sort.asc);
    });
  }

  QueryBuilder<GameData, GameData, QAfterSortBy> thenByIconPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iconPath', Sort.desc);
    });
  }

  QueryBuilder<GameData, GameData, QAfterSortBy> thenByIconType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iconType', Sort.asc);
    });
  }

  QueryBuilder<GameData, GameData, QAfterSortBy> thenByIconTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iconType', Sort.desc);
    });
  }

  QueryBuilder<GameData, GameData, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<GameData, GameData, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<GameData, GameData, QAfterSortBy> thenByInstallDir() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'installDir', Sort.asc);
    });
  }

  QueryBuilder<GameData, GameData, QAfterSortBy> thenByInstallDirDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'installDir', Sort.desc);
    });
  }

  QueryBuilder<GameData, GameData, QAfterSortBy> thenByKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.asc);
    });
  }

  QueryBuilder<GameData, GameData, QAfterSortBy> thenByKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.desc);
    });
  }

  QueryBuilder<GameData, GameData, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<GameData, GameData, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<GameData, GameData, QAfterSortBy> thenByPlatformRef() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'platformRef', Sort.asc);
    });
  }

  QueryBuilder<GameData, GameData, QAfterSortBy> thenByPlatformRefDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'platformRef', Sort.desc);
    });
  }
}

extension GameDataQueryWhereDistinct
    on QueryBuilder<GameData, GameData, QDistinct> {
  QueryBuilder<GameData, GameData, QDistinct> distinctByExeFile(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'exeFile', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<GameData, GameData, QDistinct> distinctByIconPath(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'iconPath', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<GameData, GameData, QDistinct> distinctByIconType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'iconType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<GameData, GameData, QDistinct> distinctByInstallDir(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'installDir', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<GameData, GameData, QDistinct> distinctByKey(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'key', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<GameData, GameData, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<GameData, GameData, QDistinct> distinctByPlatformRef(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'platformRef', caseSensitive: caseSensitive);
    });
  }
}

extension GameDataQueryProperty
    on QueryBuilder<GameData, GameData, QQueryProperty> {
  QueryBuilder<GameData, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<GameData, String?, QQueryOperations> exeFileProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'exeFile');
    });
  }

  QueryBuilder<GameData, String?, QQueryOperations> iconPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'iconPath');
    });
  }

  QueryBuilder<GameData, String?, QQueryOperations> iconTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'iconType');
    });
  }

  QueryBuilder<GameData, String?, QQueryOperations> installDirProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'installDir');
    });
  }

  QueryBuilder<GameData, String?, QQueryOperations> keyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'key');
    });
  }

  QueryBuilder<GameData, String?, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<GameData, String?, QQueryOperations> platformRefProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'platformRef');
    });
  }
}
