// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detected_game_data.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

extension GetDetectedGameDataCollection on Isar {
  IsarCollection<DetectedGameData> get detectedGameDatas => this.collection();
}

const DetectedGameDataSchema = CollectionSchema(
  name: r'DetectedGameData',
  id: -4412309580152230318,
  properties: {
    r'gameExe': PropertySchema(
      id: 0,
      name: r'gameExe',
      type: IsarType.string,
    ),
    r'gameProcessType': PropertySchema(
      id: 1,
      name: r'gameProcessType',
      type: IsarType.string,
    ),
    r'installDir': PropertySchema(
      id: 2,
      name: r'installDir',
      type: IsarType.string,
    ),
    r'key': PropertySchema(
      id: 3,
      name: r'key',
      type: IsarType.string,
    ),
    r'launcherProcessType': PropertySchema(
      id: 4,
      name: r'launcherProcessType',
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
  estimateSize: _detectedGameDataEstimateSize,
  serialize: _detectedGameDataSerialize,
  deserialize: _detectedGameDataDeserialize,
  deserializeProp: _detectedGameDataDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _detectedGameDataGetId,
  getLinks: _detectedGameDataGetLinks,
  attach: _detectedGameDataAttach,
  version: '3.0.5',
);

int _detectedGameDataEstimateSize(
  DetectedGameData object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.gameExe;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.gameProcessType.length * 3;
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
  bytesCount += 3 + object.launcherProcessType.length * 3;
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

void _detectedGameDataSerialize(
  DetectedGameData object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.gameExe);
  writer.writeString(offsets[1], object.gameProcessType);
  writer.writeString(offsets[2], object.installDir);
  writer.writeString(offsets[3], object.key);
  writer.writeString(offsets[4], object.launcherProcessType);
  writer.writeString(offsets[5], object.name);
  writer.writeString(offsets[6], object.platformRef);
}

DetectedGameData _detectedGameDataDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DetectedGameData();
  object.gameExe = reader.readStringOrNull(offsets[0]);
  object.gameProcessType = reader.readString(offsets[1]);
  object.id = id;
  object.installDir = reader.readStringOrNull(offsets[2]);
  object.key = reader.readStringOrNull(offsets[3]);
  object.launcherProcessType = reader.readString(offsets[4]);
  object.name = reader.readStringOrNull(offsets[5]);
  object.platformRef = reader.readStringOrNull(offsets[6]);
  return object;
}

P _detectedGameDataDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _detectedGameDataGetId(DetectedGameData object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _detectedGameDataGetLinks(DetectedGameData object) {
  return [];
}

void _detectedGameDataAttach(
    IsarCollection<dynamic> col, Id id, DetectedGameData object) {
  object.id = id;
}

extension DetectedGameDataQueryWhereSort
    on QueryBuilder<DetectedGameData, DetectedGameData, QWhere> {
  QueryBuilder<DetectedGameData, DetectedGameData, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension DetectedGameDataQueryWhere
    on QueryBuilder<DetectedGameData, DetectedGameData, QWhereClause> {
  QueryBuilder<DetectedGameData, DetectedGameData, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterWhereClause>
      idNotEqualTo(Id id) {
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

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterWhereClause> idBetween(
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

extension DetectedGameDataQueryFilter
    on QueryBuilder<DetectedGameData, DetectedGameData, QFilterCondition> {
  QueryBuilder<DetectedGameData, DetectedGameData, QAfterFilterCondition>
      gameExeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'gameExe',
      ));
    });
  }

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterFilterCondition>
      gameExeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'gameExe',
      ));
    });
  }

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterFilterCondition>
      gameExeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'gameExe',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterFilterCondition>
      gameExeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'gameExe',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterFilterCondition>
      gameExeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'gameExe',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterFilterCondition>
      gameExeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'gameExe',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterFilterCondition>
      gameExeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'gameExe',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterFilterCondition>
      gameExeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'gameExe',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterFilterCondition>
      gameExeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'gameExe',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterFilterCondition>
      gameExeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'gameExe',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterFilterCondition>
      gameExeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'gameExe',
        value: '',
      ));
    });
  }

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterFilterCondition>
      gameExeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'gameExe',
        value: '',
      ));
    });
  }

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterFilterCondition>
      gameProcessTypeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'gameProcessType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterFilterCondition>
      gameProcessTypeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'gameProcessType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterFilterCondition>
      gameProcessTypeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'gameProcessType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterFilterCondition>
      gameProcessTypeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'gameProcessType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterFilterCondition>
      gameProcessTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'gameProcessType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterFilterCondition>
      gameProcessTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'gameProcessType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterFilterCondition>
      gameProcessTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'gameProcessType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterFilterCondition>
      gameProcessTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'gameProcessType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterFilterCondition>
      gameProcessTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'gameProcessType',
        value: '',
      ));
    });
  }

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterFilterCondition>
      gameProcessTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'gameProcessType',
        value: '',
      ));
    });
  }

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterFilterCondition>
      idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterFilterCondition>
      idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterFilterCondition>
      idEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterFilterCondition>
      idGreaterThan(
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

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterFilterCondition>
      idLessThan(
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

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterFilterCondition>
      idBetween(
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

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterFilterCondition>
      installDirIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'installDir',
      ));
    });
  }

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterFilterCondition>
      installDirIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'installDir',
      ));
    });
  }

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterFilterCondition>
      installDirEqualTo(
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

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterFilterCondition>
      installDirGreaterThan(
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

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterFilterCondition>
      installDirLessThan(
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

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterFilterCondition>
      installDirBetween(
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

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterFilterCondition>
      installDirStartsWith(
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

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterFilterCondition>
      installDirEndsWith(
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

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterFilterCondition>
      installDirContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'installDir',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterFilterCondition>
      installDirMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'installDir',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterFilterCondition>
      installDirIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'installDir',
        value: '',
      ));
    });
  }

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterFilterCondition>
      installDirIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'installDir',
        value: '',
      ));
    });
  }

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterFilterCondition>
      keyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'key',
      ));
    });
  }

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterFilterCondition>
      keyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'key',
      ));
    });
  }

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterFilterCondition>
      keyEqualTo(
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

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterFilterCondition>
      keyGreaterThan(
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

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterFilterCondition>
      keyLessThan(
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

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterFilterCondition>
      keyBetween(
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

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterFilterCondition>
      keyStartsWith(
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

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterFilterCondition>
      keyEndsWith(
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

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterFilterCondition>
      keyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'key',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterFilterCondition>
      keyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'key',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterFilterCondition>
      keyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'key',
        value: '',
      ));
    });
  }

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterFilterCondition>
      keyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'key',
        value: '',
      ));
    });
  }

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterFilterCondition>
      launcherProcessTypeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'launcherProcessType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterFilterCondition>
      launcherProcessTypeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'launcherProcessType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterFilterCondition>
      launcherProcessTypeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'launcherProcessType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterFilterCondition>
      launcherProcessTypeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'launcherProcessType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterFilterCondition>
      launcherProcessTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'launcherProcessType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterFilterCondition>
      launcherProcessTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'launcherProcessType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterFilterCondition>
      launcherProcessTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'launcherProcessType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterFilterCondition>
      launcherProcessTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'launcherProcessType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterFilterCondition>
      launcherProcessTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'launcherProcessType',
        value: '',
      ));
    });
  }

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterFilterCondition>
      launcherProcessTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'launcherProcessType',
        value: '',
      ));
    });
  }

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterFilterCondition>
      nameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterFilterCondition>
      nameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterFilterCondition>
      nameEqualTo(
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

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterFilterCondition>
      nameGreaterThan(
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

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterFilterCondition>
      nameLessThan(
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

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterFilterCondition>
      nameBetween(
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

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterFilterCondition>
      nameStartsWith(
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

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterFilterCondition>
      nameEndsWith(
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

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterFilterCondition>
      nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterFilterCondition>
      nameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterFilterCondition>
      nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterFilterCondition>
      nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterFilterCondition>
      platformRefIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'platformRef',
      ));
    });
  }

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterFilterCondition>
      platformRefIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'platformRef',
      ));
    });
  }

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterFilterCondition>
      platformRefEqualTo(
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

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterFilterCondition>
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

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterFilterCondition>
      platformRefLessThan(
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

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterFilterCondition>
      platformRefBetween(
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

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterFilterCondition>
      platformRefStartsWith(
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

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterFilterCondition>
      platformRefEndsWith(
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

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterFilterCondition>
      platformRefContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'platformRef',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterFilterCondition>
      platformRefMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'platformRef',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterFilterCondition>
      platformRefIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'platformRef',
        value: '',
      ));
    });
  }

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterFilterCondition>
      platformRefIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'platformRef',
        value: '',
      ));
    });
  }
}

extension DetectedGameDataQueryObject
    on QueryBuilder<DetectedGameData, DetectedGameData, QFilterCondition> {}

extension DetectedGameDataQueryLinks
    on QueryBuilder<DetectedGameData, DetectedGameData, QFilterCondition> {}

extension DetectedGameDataQuerySortBy
    on QueryBuilder<DetectedGameData, DetectedGameData, QSortBy> {
  QueryBuilder<DetectedGameData, DetectedGameData, QAfterSortBy>
      sortByGameExe() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gameExe', Sort.asc);
    });
  }

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterSortBy>
      sortByGameExeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gameExe', Sort.desc);
    });
  }

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterSortBy>
      sortByGameProcessType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gameProcessType', Sort.asc);
    });
  }

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterSortBy>
      sortByGameProcessTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gameProcessType', Sort.desc);
    });
  }

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterSortBy>
      sortByInstallDir() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'installDir', Sort.asc);
    });
  }

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterSortBy>
      sortByInstallDirDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'installDir', Sort.desc);
    });
  }

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterSortBy> sortByKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.asc);
    });
  }

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterSortBy>
      sortByKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.desc);
    });
  }

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterSortBy>
      sortByLauncherProcessType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'launcherProcessType', Sort.asc);
    });
  }

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterSortBy>
      sortByLauncherProcessTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'launcherProcessType', Sort.desc);
    });
  }

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterSortBy>
      sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterSortBy>
      sortByPlatformRef() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'platformRef', Sort.asc);
    });
  }

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterSortBy>
      sortByPlatformRefDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'platformRef', Sort.desc);
    });
  }
}

extension DetectedGameDataQuerySortThenBy
    on QueryBuilder<DetectedGameData, DetectedGameData, QSortThenBy> {
  QueryBuilder<DetectedGameData, DetectedGameData, QAfterSortBy>
      thenByGameExe() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gameExe', Sort.asc);
    });
  }

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterSortBy>
      thenByGameExeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gameExe', Sort.desc);
    });
  }

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterSortBy>
      thenByGameProcessType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gameProcessType', Sort.asc);
    });
  }

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterSortBy>
      thenByGameProcessTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gameProcessType', Sort.desc);
    });
  }

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterSortBy>
      thenByInstallDir() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'installDir', Sort.asc);
    });
  }

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterSortBy>
      thenByInstallDirDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'installDir', Sort.desc);
    });
  }

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterSortBy> thenByKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.asc);
    });
  }

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterSortBy>
      thenByKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.desc);
    });
  }

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterSortBy>
      thenByLauncherProcessType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'launcherProcessType', Sort.asc);
    });
  }

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterSortBy>
      thenByLauncherProcessTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'launcherProcessType', Sort.desc);
    });
  }

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterSortBy>
      thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterSortBy>
      thenByPlatformRef() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'platformRef', Sort.asc);
    });
  }

  QueryBuilder<DetectedGameData, DetectedGameData, QAfterSortBy>
      thenByPlatformRefDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'platformRef', Sort.desc);
    });
  }
}

extension DetectedGameDataQueryWhereDistinct
    on QueryBuilder<DetectedGameData, DetectedGameData, QDistinct> {
  QueryBuilder<DetectedGameData, DetectedGameData, QDistinct> distinctByGameExe(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'gameExe', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DetectedGameData, DetectedGameData, QDistinct>
      distinctByGameProcessType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'gameProcessType',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DetectedGameData, DetectedGameData, QDistinct>
      distinctByInstallDir({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'installDir', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DetectedGameData, DetectedGameData, QDistinct> distinctByKey(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'key', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DetectedGameData, DetectedGameData, QDistinct>
      distinctByLauncherProcessType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'launcherProcessType',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DetectedGameData, DetectedGameData, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DetectedGameData, DetectedGameData, QDistinct>
      distinctByPlatformRef({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'platformRef', caseSensitive: caseSensitive);
    });
  }
}

extension DetectedGameDataQueryProperty
    on QueryBuilder<DetectedGameData, DetectedGameData, QQueryProperty> {
  QueryBuilder<DetectedGameData, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<DetectedGameData, String?, QQueryOperations> gameExeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'gameExe');
    });
  }

  QueryBuilder<DetectedGameData, String, QQueryOperations>
      gameProcessTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'gameProcessType');
    });
  }

  QueryBuilder<DetectedGameData, String?, QQueryOperations>
      installDirProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'installDir');
    });
  }

  QueryBuilder<DetectedGameData, String?, QQueryOperations> keyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'key');
    });
  }

  QueryBuilder<DetectedGameData, String, QQueryOperations>
      launcherProcessTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'launcherProcessType');
    });
  }

  QueryBuilder<DetectedGameData, String?, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<DetectedGameData, String?, QQueryOperations>
      platformRefProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'platformRef');
    });
  }
}
