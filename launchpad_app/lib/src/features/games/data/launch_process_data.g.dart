// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'launch_process_data.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

extension GetLaunchProcessDataCollection on Isar {
  IsarCollection<LaunchProcessData> get launchProcessDatas => this.collection();
}

const LaunchProcessDataSchema = CollectionSchema(
  name: r'LaunchProcessData',
  id: -8203881271593144308,
  properties: {
    r'dir': PropertySchema(
      id: 0,
      name: r'dir',
      type: IsarType.string,
    ),
    r'exe': PropertySchema(
      id: 1,
      name: r'exe',
      type: IsarType.string,
    ),
    r'processId': PropertySchema(
      id: 2,
      name: r'processId',
      type: IsarType.string,
    ),
    r'processIdType': PropertySchema(
      id: 3,
      name: r'processIdType',
      type: IsarType.string,
    ),
    r'startArgs': PropertySchema(
      id: 4,
      name: r'startArgs',
      type: IsarType.string,
    ),
    r'startCommand': PropertySchema(
      id: 5,
      name: r'startCommand',
      type: IsarType.string,
    ),
    r'startUri': PropertySchema(
      id: 6,
      name: r'startUri',
      type: IsarType.string,
    ),
    r'type': PropertySchema(
      id: 7,
      name: r'type',
      type: IsarType.string,
    )
  },
  estimateSize: _launchProcessDataEstimateSize,
  serialize: _launchProcessDataSerialize,
  deserialize: _launchProcessDataDeserialize,
  deserializeProp: _launchProcessDataDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'game': LinkSchema(
      id: 7299628713932688470,
      name: r'game',
      target: r'GameData',
      single: true,
    ),
    r'childProcesses': LinkSchema(
      id: 5523404633728566519,
      name: r'childProcesses',
      target: r'LaunchProcessData',
      single: false,
    )
  },
  embeddedSchemas: {},
  getId: _launchProcessDataGetId,
  getLinks: _launchProcessDataGetLinks,
  attach: _launchProcessDataAttach,
  version: '3.0.5',
);

int _launchProcessDataEstimateSize(
  LaunchProcessData object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.dir;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.exe;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.processId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.processIdType;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.startArgs;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.startCommand;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.startUri;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.type;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _launchProcessDataSerialize(
  LaunchProcessData object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.dir);
  writer.writeString(offsets[1], object.exe);
  writer.writeString(offsets[2], object.processId);
  writer.writeString(offsets[3], object.processIdType);
  writer.writeString(offsets[4], object.startArgs);
  writer.writeString(offsets[5], object.startCommand);
  writer.writeString(offsets[6], object.startUri);
  writer.writeString(offsets[7], object.type);
}

LaunchProcessData _launchProcessDataDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = LaunchProcessData();
  object.dir = reader.readStringOrNull(offsets[0]);
  object.exe = reader.readStringOrNull(offsets[1]);
  object.id = id;
  object.processId = reader.readStringOrNull(offsets[2]);
  object.processIdType = reader.readStringOrNull(offsets[3]);
  object.startArgs = reader.readStringOrNull(offsets[4]);
  object.startCommand = reader.readStringOrNull(offsets[5]);
  object.startUri = reader.readStringOrNull(offsets[6]);
  object.type = reader.readStringOrNull(offsets[7]);
  return object;
}

P _launchProcessDataDeserializeProp<P>(
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
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _launchProcessDataGetId(LaunchProcessData object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _launchProcessDataGetLinks(
    LaunchProcessData object) {
  return [object.game, object.childProcesses];
}

void _launchProcessDataAttach(
    IsarCollection<dynamic> col, Id id, LaunchProcessData object) {
  object.id = id;
  object.game.attach(col, col.isar.collection<GameData>(), r'game', id);
  object.childProcesses.attach(
      col, col.isar.collection<LaunchProcessData>(), r'childProcesses', id);
}

extension LaunchProcessDataQueryWhereSort
    on QueryBuilder<LaunchProcessData, LaunchProcessData, QWhere> {
  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension LaunchProcessDataQueryWhere
    on QueryBuilder<LaunchProcessData, LaunchProcessData, QWhereClause> {
  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterWhereClause>
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

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterWhereClause>
      idBetween(
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

extension LaunchProcessDataQueryFilter
    on QueryBuilder<LaunchProcessData, LaunchProcessData, QFilterCondition> {
  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      dirIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dir',
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      dirIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dir',
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      dirEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dir',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      dirGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dir',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      dirLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dir',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      dirBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dir',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      dirStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'dir',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      dirEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'dir',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      dirContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'dir',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      dirMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'dir',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      dirIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dir',
        value: '',
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      dirIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'dir',
        value: '',
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      exeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'exe',
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      exeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'exe',
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      exeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'exe',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      exeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'exe',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      exeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'exe',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      exeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'exe',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      exeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'exe',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      exeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'exe',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      exeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'exe',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      exeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'exe',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      exeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'exe',
        value: '',
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      exeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'exe',
        value: '',
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      idEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
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

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
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

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
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

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      processIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'processId',
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      processIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'processId',
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      processIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'processId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      processIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'processId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      processIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'processId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      processIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'processId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      processIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'processId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      processIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'processId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      processIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'processId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      processIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'processId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      processIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'processId',
        value: '',
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      processIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'processId',
        value: '',
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      processIdTypeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'processIdType',
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      processIdTypeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'processIdType',
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      processIdTypeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'processIdType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      processIdTypeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'processIdType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      processIdTypeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'processIdType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      processIdTypeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'processIdType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      processIdTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'processIdType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      processIdTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'processIdType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      processIdTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'processIdType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      processIdTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'processIdType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      processIdTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'processIdType',
        value: '',
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      processIdTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'processIdType',
        value: '',
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      startArgsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'startArgs',
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      startArgsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'startArgs',
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      startArgsEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startArgs',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      startArgsGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'startArgs',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      startArgsLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'startArgs',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      startArgsBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'startArgs',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      startArgsStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'startArgs',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      startArgsEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'startArgs',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      startArgsContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'startArgs',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      startArgsMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'startArgs',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      startArgsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startArgs',
        value: '',
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      startArgsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'startArgs',
        value: '',
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      startCommandIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'startCommand',
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      startCommandIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'startCommand',
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      startCommandEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startCommand',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      startCommandGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'startCommand',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      startCommandLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'startCommand',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      startCommandBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'startCommand',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      startCommandStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'startCommand',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      startCommandEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'startCommand',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      startCommandContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'startCommand',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      startCommandMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'startCommand',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      startCommandIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startCommand',
        value: '',
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      startCommandIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'startCommand',
        value: '',
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      startUriIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'startUri',
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      startUriIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'startUri',
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      startUriEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startUri',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      startUriGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'startUri',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      startUriLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'startUri',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      startUriBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'startUri',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      startUriStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'startUri',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      startUriEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'startUri',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      startUriContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'startUri',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      startUriMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'startUri',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      startUriIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startUri',
        value: '',
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      startUriIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'startUri',
        value: '',
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      typeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'type',
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      typeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'type',
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      typeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      typeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      typeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      typeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'type',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      typeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      typeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      typeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      typeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'type',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      typeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: '',
      ));
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      typeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'type',
        value: '',
      ));
    });
  }
}

extension LaunchProcessDataQueryObject
    on QueryBuilder<LaunchProcessData, LaunchProcessData, QFilterCondition> {}

extension LaunchProcessDataQueryLinks
    on QueryBuilder<LaunchProcessData, LaunchProcessData, QFilterCondition> {
  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      game(FilterQuery<GameData> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'game');
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      gameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'game', 0, true, 0, true);
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      childProcesses(FilterQuery<LaunchProcessData> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'childProcesses');
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      childProcessesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'childProcesses', length, true, length, true);
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      childProcessesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'childProcesses', 0, true, 0, true);
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      childProcessesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'childProcesses', 0, false, 999999, true);
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      childProcessesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'childProcesses', 0, true, length, include);
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      childProcessesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'childProcesses', length, include, 999999, true);
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterFilterCondition>
      childProcessesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'childProcesses', lower, includeLower, upper, includeUpper);
    });
  }
}

extension LaunchProcessDataQuerySortBy
    on QueryBuilder<LaunchProcessData, LaunchProcessData, QSortBy> {
  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterSortBy> sortByDir() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dir', Sort.asc);
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterSortBy>
      sortByDirDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dir', Sort.desc);
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterSortBy> sortByExe() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exe', Sort.asc);
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterSortBy>
      sortByExeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exe', Sort.desc);
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterSortBy>
      sortByProcessId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'processId', Sort.asc);
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterSortBy>
      sortByProcessIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'processId', Sort.desc);
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterSortBy>
      sortByProcessIdType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'processIdType', Sort.asc);
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterSortBy>
      sortByProcessIdTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'processIdType', Sort.desc);
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterSortBy>
      sortByStartArgs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startArgs', Sort.asc);
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterSortBy>
      sortByStartArgsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startArgs', Sort.desc);
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterSortBy>
      sortByStartCommand() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startCommand', Sort.asc);
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterSortBy>
      sortByStartCommandDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startCommand', Sort.desc);
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterSortBy>
      sortByStartUri() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startUri', Sort.asc);
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterSortBy>
      sortByStartUriDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startUri', Sort.desc);
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterSortBy>
      sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterSortBy>
      sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension LaunchProcessDataQuerySortThenBy
    on QueryBuilder<LaunchProcessData, LaunchProcessData, QSortThenBy> {
  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterSortBy> thenByDir() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dir', Sort.asc);
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterSortBy>
      thenByDirDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dir', Sort.desc);
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterSortBy> thenByExe() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exe', Sort.asc);
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterSortBy>
      thenByExeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exe', Sort.desc);
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterSortBy>
      thenByProcessId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'processId', Sort.asc);
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterSortBy>
      thenByProcessIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'processId', Sort.desc);
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterSortBy>
      thenByProcessIdType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'processIdType', Sort.asc);
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterSortBy>
      thenByProcessIdTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'processIdType', Sort.desc);
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterSortBy>
      thenByStartArgs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startArgs', Sort.asc);
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterSortBy>
      thenByStartArgsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startArgs', Sort.desc);
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterSortBy>
      thenByStartCommand() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startCommand', Sort.asc);
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterSortBy>
      thenByStartCommandDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startCommand', Sort.desc);
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterSortBy>
      thenByStartUri() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startUri', Sort.asc);
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterSortBy>
      thenByStartUriDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startUri', Sort.desc);
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterSortBy>
      thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QAfterSortBy>
      thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension LaunchProcessDataQueryWhereDistinct
    on QueryBuilder<LaunchProcessData, LaunchProcessData, QDistinct> {
  QueryBuilder<LaunchProcessData, LaunchProcessData, QDistinct> distinctByDir(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dir', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QDistinct> distinctByExe(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'exe', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QDistinct>
      distinctByProcessId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'processId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QDistinct>
      distinctByProcessIdType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'processIdType',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QDistinct>
      distinctByStartArgs({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startArgs', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QDistinct>
      distinctByStartCommand({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startCommand', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QDistinct>
      distinctByStartUri({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startUri', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LaunchProcessData, LaunchProcessData, QDistinct> distinctByType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type', caseSensitive: caseSensitive);
    });
  }
}

extension LaunchProcessDataQueryProperty
    on QueryBuilder<LaunchProcessData, LaunchProcessData, QQueryProperty> {
  QueryBuilder<LaunchProcessData, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<LaunchProcessData, String?, QQueryOperations> dirProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dir');
    });
  }

  QueryBuilder<LaunchProcessData, String?, QQueryOperations> exeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'exe');
    });
  }

  QueryBuilder<LaunchProcessData, String?, QQueryOperations>
      processIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'processId');
    });
  }

  QueryBuilder<LaunchProcessData, String?, QQueryOperations>
      processIdTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'processIdType');
    });
  }

  QueryBuilder<LaunchProcessData, String?, QQueryOperations>
      startArgsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startArgs');
    });
  }

  QueryBuilder<LaunchProcessData, String?, QQueryOperations>
      startCommandProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startCommand');
    });
  }

  QueryBuilder<LaunchProcessData, String?, QQueryOperations>
      startUriProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startUri');
    });
  }

  QueryBuilder<LaunchProcessData, String?, QQueryOperations> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }
}
