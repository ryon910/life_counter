// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'important_person.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetImportantPersonCollection on Isar {
  IsarCollection<ImportantPerson> get importantPersons => this.collection();
}

const ImportantPersonSchema = CollectionSchema(
  name: r'ImportantPerson',
  id: 4817208070282781061,
  properties: {
    r'birthDate': PropertySchema(
      id: 0,
      name: r'birthDate',
      type: IsarType.dateTime,
    ),
    r'createdAt': PropertySchema(
      id: 1,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'gender': PropertySchema(
      id: 2,
      name: r'gender',
      type: IsarType.string,
      enumMap: _ImportantPersongenderEnumValueMap,
    ),
    r'lastMetDate': PropertySchema(
      id: 3,
      name: r'lastMetDate',
      type: IsarType.dateTime,
    ),
    r'meetingFrequency': PropertySchema(
      id: 4,
      name: r'meetingFrequency',
      type: IsarType.long,
    ),
    r'nickname': PropertySchema(
      id: 5,
      name: r'nickname',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 6,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _importantPersonEstimateSize,
  serialize: _importantPersonSerialize,
  deserialize: _importantPersonDeserialize,
  deserializeProp: _importantPersonDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _importantPersonGetId,
  getLinks: _importantPersonGetLinks,
  attach: _importantPersonAttach,
  version: '3.1.0+1',
);

int _importantPersonEstimateSize(
  ImportantPerson object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.gender.name.length * 3;
  bytesCount += 3 + object.nickname.length * 3;
  return bytesCount;
}

void _importantPersonSerialize(
  ImportantPerson object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.birthDate);
  writer.writeDateTime(offsets[1], object.createdAt);
  writer.writeString(offsets[2], object.gender.name);
  writer.writeDateTime(offsets[3], object.lastMetDate);
  writer.writeLong(offsets[4], object.meetingFrequency);
  writer.writeString(offsets[5], object.nickname);
  writer.writeDateTime(offsets[6], object.updatedAt);
}

ImportantPerson _importantPersonDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ImportantPerson();
  object.birthDate = reader.readDateTime(offsets[0]);
  object.createdAt = reader.readDateTime(offsets[1]);
  object.gender =
      _ImportantPersongenderValueEnumMap[reader.readStringOrNull(offsets[2])] ??
          Gender.male;
  object.id = id;
  object.lastMetDate = reader.readDateTimeOrNull(offsets[3]);
  object.meetingFrequency = reader.readLong(offsets[4]);
  object.nickname = reader.readString(offsets[5]);
  object.updatedAt = reader.readDateTime(offsets[6]);
  return object;
}

P _importantPersonDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (_ImportantPersongenderValueEnumMap[
              reader.readStringOrNull(offset)] ??
          Gender.male) as P;
    case 3:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _ImportantPersongenderEnumValueMap = {
  r'male': r'male',
  r'female': r'female',
  r'unspecified': r'unspecified',
};
const _ImportantPersongenderValueEnumMap = {
  r'male': Gender.male,
  r'female': Gender.female,
  r'unspecified': Gender.unspecified,
};

Id _importantPersonGetId(ImportantPerson object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _importantPersonGetLinks(ImportantPerson object) {
  return [];
}

void _importantPersonAttach(
    IsarCollection<dynamic> col, Id id, ImportantPerson object) {
  object.id = id;
}

extension ImportantPersonQueryWhereSort
    on QueryBuilder<ImportantPerson, ImportantPerson, QWhere> {
  QueryBuilder<ImportantPerson, ImportantPerson, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ImportantPersonQueryWhere
    on QueryBuilder<ImportantPerson, ImportantPerson, QWhereClause> {
  QueryBuilder<ImportantPerson, ImportantPerson, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ImportantPerson, ImportantPerson, QAfterWhereClause>
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

  QueryBuilder<ImportantPerson, ImportantPerson, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ImportantPerson, ImportantPerson, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ImportantPerson, ImportantPerson, QAfterWhereClause> idBetween(
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

extension ImportantPersonQueryFilter
    on QueryBuilder<ImportantPerson, ImportantPerson, QFilterCondition> {
  QueryBuilder<ImportantPerson, ImportantPerson, QAfterFilterCondition>
      birthDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'birthDate',
        value: value,
      ));
    });
  }

  QueryBuilder<ImportantPerson, ImportantPerson, QAfterFilterCondition>
      birthDateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'birthDate',
        value: value,
      ));
    });
  }

  QueryBuilder<ImportantPerson, ImportantPerson, QAfterFilterCondition>
      birthDateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'birthDate',
        value: value,
      ));
    });
  }

  QueryBuilder<ImportantPerson, ImportantPerson, QAfterFilterCondition>
      birthDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'birthDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ImportantPerson, ImportantPerson, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ImportantPerson, ImportantPerson, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ImportantPerson, ImportantPerson, QAfterFilterCondition>
      createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ImportantPerson, ImportantPerson, QAfterFilterCondition>
      createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ImportantPerson, ImportantPerson, QAfterFilterCondition>
      genderEqualTo(
    Gender value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'gender',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ImportantPerson, ImportantPerson, QAfterFilterCondition>
      genderGreaterThan(
    Gender value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'gender',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ImportantPerson, ImportantPerson, QAfterFilterCondition>
      genderLessThan(
    Gender value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'gender',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ImportantPerson, ImportantPerson, QAfterFilterCondition>
      genderBetween(
    Gender lower,
    Gender upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'gender',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ImportantPerson, ImportantPerson, QAfterFilterCondition>
      genderStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'gender',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ImportantPerson, ImportantPerson, QAfterFilterCondition>
      genderEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'gender',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ImportantPerson, ImportantPerson, QAfterFilterCondition>
      genderContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'gender',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ImportantPerson, ImportantPerson, QAfterFilterCondition>
      genderMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'gender',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ImportantPerson, ImportantPerson, QAfterFilterCondition>
      genderIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'gender',
        value: '',
      ));
    });
  }

  QueryBuilder<ImportantPerson, ImportantPerson, QAfterFilterCondition>
      genderIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'gender',
        value: '',
      ));
    });
  }

  QueryBuilder<ImportantPerson, ImportantPerson, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ImportantPerson, ImportantPerson, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
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

  QueryBuilder<ImportantPerson, ImportantPerson, QAfterFilterCondition>
      idLessThan(
    Id value, {
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

  QueryBuilder<ImportantPerson, ImportantPerson, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
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

  QueryBuilder<ImportantPerson, ImportantPerson, QAfterFilterCondition>
      lastMetDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastMetDate',
      ));
    });
  }

  QueryBuilder<ImportantPerson, ImportantPerson, QAfterFilterCondition>
      lastMetDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastMetDate',
      ));
    });
  }

  QueryBuilder<ImportantPerson, ImportantPerson, QAfterFilterCondition>
      lastMetDateEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastMetDate',
        value: value,
      ));
    });
  }

  QueryBuilder<ImportantPerson, ImportantPerson, QAfterFilterCondition>
      lastMetDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastMetDate',
        value: value,
      ));
    });
  }

  QueryBuilder<ImportantPerson, ImportantPerson, QAfterFilterCondition>
      lastMetDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastMetDate',
        value: value,
      ));
    });
  }

  QueryBuilder<ImportantPerson, ImportantPerson, QAfterFilterCondition>
      lastMetDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastMetDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ImportantPerson, ImportantPerson, QAfterFilterCondition>
      meetingFrequencyEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'meetingFrequency',
        value: value,
      ));
    });
  }

  QueryBuilder<ImportantPerson, ImportantPerson, QAfterFilterCondition>
      meetingFrequencyGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'meetingFrequency',
        value: value,
      ));
    });
  }

  QueryBuilder<ImportantPerson, ImportantPerson, QAfterFilterCondition>
      meetingFrequencyLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'meetingFrequency',
        value: value,
      ));
    });
  }

  QueryBuilder<ImportantPerson, ImportantPerson, QAfterFilterCondition>
      meetingFrequencyBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'meetingFrequency',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ImportantPerson, ImportantPerson, QAfterFilterCondition>
      nicknameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nickname',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ImportantPerson, ImportantPerson, QAfterFilterCondition>
      nicknameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'nickname',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ImportantPerson, ImportantPerson, QAfterFilterCondition>
      nicknameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'nickname',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ImportantPerson, ImportantPerson, QAfterFilterCondition>
      nicknameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'nickname',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ImportantPerson, ImportantPerson, QAfterFilterCondition>
      nicknameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'nickname',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ImportantPerson, ImportantPerson, QAfterFilterCondition>
      nicknameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'nickname',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ImportantPerson, ImportantPerson, QAfterFilterCondition>
      nicknameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'nickname',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ImportantPerson, ImportantPerson, QAfterFilterCondition>
      nicknameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'nickname',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ImportantPerson, ImportantPerson, QAfterFilterCondition>
      nicknameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nickname',
        value: '',
      ));
    });
  }

  QueryBuilder<ImportantPerson, ImportantPerson, QAfterFilterCondition>
      nicknameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'nickname',
        value: '',
      ));
    });
  }

  QueryBuilder<ImportantPerson, ImportantPerson, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ImportantPerson, ImportantPerson, QAfterFilterCondition>
      updatedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ImportantPerson, ImportantPerson, QAfterFilterCondition>
      updatedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ImportantPerson, ImportantPerson, QAfterFilterCondition>
      updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ImportantPersonQueryObject
    on QueryBuilder<ImportantPerson, ImportantPerson, QFilterCondition> {}

extension ImportantPersonQueryLinks
    on QueryBuilder<ImportantPerson, ImportantPerson, QFilterCondition> {}

extension ImportantPersonQuerySortBy
    on QueryBuilder<ImportantPerson, ImportantPerson, QSortBy> {
  QueryBuilder<ImportantPerson, ImportantPerson, QAfterSortBy>
      sortByBirthDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'birthDate', Sort.asc);
    });
  }

  QueryBuilder<ImportantPerson, ImportantPerson, QAfterSortBy>
      sortByBirthDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'birthDate', Sort.desc);
    });
  }

  QueryBuilder<ImportantPerson, ImportantPerson, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<ImportantPerson, ImportantPerson, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<ImportantPerson, ImportantPerson, QAfterSortBy> sortByGender() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gender', Sort.asc);
    });
  }

  QueryBuilder<ImportantPerson, ImportantPerson, QAfterSortBy>
      sortByGenderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gender', Sort.desc);
    });
  }

  QueryBuilder<ImportantPerson, ImportantPerson, QAfterSortBy>
      sortByLastMetDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastMetDate', Sort.asc);
    });
  }

  QueryBuilder<ImportantPerson, ImportantPerson, QAfterSortBy>
      sortByLastMetDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastMetDate', Sort.desc);
    });
  }

  QueryBuilder<ImportantPerson, ImportantPerson, QAfterSortBy>
      sortByMeetingFrequency() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'meetingFrequency', Sort.asc);
    });
  }

  QueryBuilder<ImportantPerson, ImportantPerson, QAfterSortBy>
      sortByMeetingFrequencyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'meetingFrequency', Sort.desc);
    });
  }

  QueryBuilder<ImportantPerson, ImportantPerson, QAfterSortBy>
      sortByNickname() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nickname', Sort.asc);
    });
  }

  QueryBuilder<ImportantPerson, ImportantPerson, QAfterSortBy>
      sortByNicknameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nickname', Sort.desc);
    });
  }

  QueryBuilder<ImportantPerson, ImportantPerson, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<ImportantPerson, ImportantPerson, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension ImportantPersonQuerySortThenBy
    on QueryBuilder<ImportantPerson, ImportantPerson, QSortThenBy> {
  QueryBuilder<ImportantPerson, ImportantPerson, QAfterSortBy>
      thenByBirthDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'birthDate', Sort.asc);
    });
  }

  QueryBuilder<ImportantPerson, ImportantPerson, QAfterSortBy>
      thenByBirthDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'birthDate', Sort.desc);
    });
  }

  QueryBuilder<ImportantPerson, ImportantPerson, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<ImportantPerson, ImportantPerson, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<ImportantPerson, ImportantPerson, QAfterSortBy> thenByGender() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gender', Sort.asc);
    });
  }

  QueryBuilder<ImportantPerson, ImportantPerson, QAfterSortBy>
      thenByGenderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gender', Sort.desc);
    });
  }

  QueryBuilder<ImportantPerson, ImportantPerson, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ImportantPerson, ImportantPerson, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ImportantPerson, ImportantPerson, QAfterSortBy>
      thenByLastMetDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastMetDate', Sort.asc);
    });
  }

  QueryBuilder<ImportantPerson, ImportantPerson, QAfterSortBy>
      thenByLastMetDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastMetDate', Sort.desc);
    });
  }

  QueryBuilder<ImportantPerson, ImportantPerson, QAfterSortBy>
      thenByMeetingFrequency() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'meetingFrequency', Sort.asc);
    });
  }

  QueryBuilder<ImportantPerson, ImportantPerson, QAfterSortBy>
      thenByMeetingFrequencyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'meetingFrequency', Sort.desc);
    });
  }

  QueryBuilder<ImportantPerson, ImportantPerson, QAfterSortBy>
      thenByNickname() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nickname', Sort.asc);
    });
  }

  QueryBuilder<ImportantPerson, ImportantPerson, QAfterSortBy>
      thenByNicknameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nickname', Sort.desc);
    });
  }

  QueryBuilder<ImportantPerson, ImportantPerson, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<ImportantPerson, ImportantPerson, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension ImportantPersonQueryWhereDistinct
    on QueryBuilder<ImportantPerson, ImportantPerson, QDistinct> {
  QueryBuilder<ImportantPerson, ImportantPerson, QDistinct>
      distinctByBirthDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'birthDate');
    });
  }

  QueryBuilder<ImportantPerson, ImportantPerson, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<ImportantPerson, ImportantPerson, QDistinct> distinctByGender(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'gender', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ImportantPerson, ImportantPerson, QDistinct>
      distinctByLastMetDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastMetDate');
    });
  }

  QueryBuilder<ImportantPerson, ImportantPerson, QDistinct>
      distinctByMeetingFrequency() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'meetingFrequency');
    });
  }

  QueryBuilder<ImportantPerson, ImportantPerson, QDistinct> distinctByNickname(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nickname', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ImportantPerson, ImportantPerson, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension ImportantPersonQueryProperty
    on QueryBuilder<ImportantPerson, ImportantPerson, QQueryProperty> {
  QueryBuilder<ImportantPerson, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ImportantPerson, DateTime, QQueryOperations>
      birthDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'birthDate');
    });
  }

  QueryBuilder<ImportantPerson, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<ImportantPerson, Gender, QQueryOperations> genderProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'gender');
    });
  }

  QueryBuilder<ImportantPerson, DateTime?, QQueryOperations>
      lastMetDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastMetDate');
    });
  }

  QueryBuilder<ImportantPerson, int, QQueryOperations>
      meetingFrequencyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'meetingFrequency');
    });
  }

  QueryBuilder<ImportantPerson, String, QQueryOperations> nicknameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nickname');
    });
  }

  QueryBuilder<ImportantPerson, DateTime, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
