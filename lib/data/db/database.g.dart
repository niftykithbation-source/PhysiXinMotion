// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $ClassSectionsTable extends ClassSections
    with TableInfo<$ClassSectionsTable, ClassSectionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ClassSectionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _sectionIdMeta = const VerificationMeta(
    'sectionId',
  );
  @override
  late final GeneratedColumn<String> sectionId = GeneratedColumn<String>(
    'section_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _teacherIdMeta = const VerificationMeta(
    'teacherId',
  );
  @override
  late final GeneratedColumn<String> teacherId = GeneratedColumn<String>(
    'teacher_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (user_id)',
    ),
  );
  static const VerificationMeta _sectionNameMeta = const VerificationMeta(
    'sectionName',
  );
  @override
  late final GeneratedColumn<String> sectionName = GeneratedColumn<String>(
    'section_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _schoolNameMeta = const VerificationMeta(
    'schoolName',
  );
  @override
  late final GeneratedColumn<String> schoolName = GeneratedColumn<String>(
    'school_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _schoolYearMeta = const VerificationMeta(
    'schoolYear',
  );
  @override
  late final GeneratedColumn<String> schoolYear = GeneratedColumn<String>(
    'school_year',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sectionPinMeta = const VerificationMeta(
    'sectionPin',
  );
  @override
  late final GeneratedColumn<String> sectionPin = GeneratedColumn<String>(
    'section_pin',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    sectionId,
    teacherId,
    sectionName,
    schoolName,
    createdAt,
    schoolYear,
    sectionPin,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'class_sections';
  @override
  VerificationContext validateIntegrity(
    Insertable<ClassSectionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('section_id')) {
      context.handle(
        _sectionIdMeta,
        sectionId.isAcceptableOrUnknown(data['section_id']!, _sectionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sectionIdMeta);
    }
    if (data.containsKey('teacher_id')) {
      context.handle(
        _teacherIdMeta,
        teacherId.isAcceptableOrUnknown(data['teacher_id']!, _teacherIdMeta),
      );
    }
    if (data.containsKey('section_name')) {
      context.handle(
        _sectionNameMeta,
        sectionName.isAcceptableOrUnknown(
          data['section_name']!,
          _sectionNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sectionNameMeta);
    }
    if (data.containsKey('school_name')) {
      context.handle(
        _schoolNameMeta,
        schoolName.isAcceptableOrUnknown(data['school_name']!, _schoolNameMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('school_year')) {
      context.handle(
        _schoolYearMeta,
        schoolYear.isAcceptableOrUnknown(data['school_year']!, _schoolYearMeta),
      );
    }
    if (data.containsKey('section_pin')) {
      context.handle(
        _sectionPinMeta,
        sectionPin.isAcceptableOrUnknown(data['section_pin']!, _sectionPinMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {sectionId};
  @override
  ClassSectionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ClassSectionRow(
      sectionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}section_id'],
      )!,
      teacherId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}teacher_id'],
      ),
      sectionName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}section_name'],
      )!,
      schoolName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}school_name'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      schoolYear: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}school_year'],
      ),
      sectionPin: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}section_pin'],
      ),
    );
  }

  @override
  $ClassSectionsTable createAlias(String alias) {
    return $ClassSectionsTable(attachedDatabase, alias);
  }
}

class ClassSectionRow extends DataClass implements Insertable<ClassSectionRow> {
  final String sectionId;
  final String? teacherId;
  final String sectionName;
  final String? schoolName;
  final int createdAt;
  final String? schoolYear;
  final String? sectionPin;
  const ClassSectionRow({
    required this.sectionId,
    this.teacherId,
    required this.sectionName,
    this.schoolName,
    required this.createdAt,
    this.schoolYear,
    this.sectionPin,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['section_id'] = Variable<String>(sectionId);
    if (!nullToAbsent || teacherId != null) {
      map['teacher_id'] = Variable<String>(teacherId);
    }
    map['section_name'] = Variable<String>(sectionName);
    if (!nullToAbsent || schoolName != null) {
      map['school_name'] = Variable<String>(schoolName);
    }
    map['created_at'] = Variable<int>(createdAt);
    if (!nullToAbsent || schoolYear != null) {
      map['school_year'] = Variable<String>(schoolYear);
    }
    if (!nullToAbsent || sectionPin != null) {
      map['section_pin'] = Variable<String>(sectionPin);
    }
    return map;
  }

  ClassSectionsCompanion toCompanion(bool nullToAbsent) {
    return ClassSectionsCompanion(
      sectionId: Value(sectionId),
      teacherId: teacherId == null && nullToAbsent
          ? const Value.absent()
          : Value(teacherId),
      sectionName: Value(sectionName),
      schoolName: schoolName == null && nullToAbsent
          ? const Value.absent()
          : Value(schoolName),
      createdAt: Value(createdAt),
      schoolYear: schoolYear == null && nullToAbsent
          ? const Value.absent()
          : Value(schoolYear),
      sectionPin: sectionPin == null && nullToAbsent
          ? const Value.absent()
          : Value(sectionPin),
    );
  }

  factory ClassSectionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ClassSectionRow(
      sectionId: serializer.fromJson<String>(json['sectionId']),
      teacherId: serializer.fromJson<String?>(json['teacherId']),
      sectionName: serializer.fromJson<String>(json['sectionName']),
      schoolName: serializer.fromJson<String?>(json['schoolName']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      schoolYear: serializer.fromJson<String?>(json['schoolYear']),
      sectionPin: serializer.fromJson<String?>(json['sectionPin']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'sectionId': serializer.toJson<String>(sectionId),
      'teacherId': serializer.toJson<String?>(teacherId),
      'sectionName': serializer.toJson<String>(sectionName),
      'schoolName': serializer.toJson<String?>(schoolName),
      'createdAt': serializer.toJson<int>(createdAt),
      'schoolYear': serializer.toJson<String?>(schoolYear),
      'sectionPin': serializer.toJson<String?>(sectionPin),
    };
  }

  ClassSectionRow copyWith({
    String? sectionId,
    Value<String?> teacherId = const Value.absent(),
    String? sectionName,
    Value<String?> schoolName = const Value.absent(),
    int? createdAt,
    Value<String?> schoolYear = const Value.absent(),
    Value<String?> sectionPin = const Value.absent(),
  }) => ClassSectionRow(
    sectionId: sectionId ?? this.sectionId,
    teacherId: teacherId.present ? teacherId.value : this.teacherId,
    sectionName: sectionName ?? this.sectionName,
    schoolName: schoolName.present ? schoolName.value : this.schoolName,
    createdAt: createdAt ?? this.createdAt,
    schoolYear: schoolYear.present ? schoolYear.value : this.schoolYear,
    sectionPin: sectionPin.present ? sectionPin.value : this.sectionPin,
  );
  ClassSectionRow copyWithCompanion(ClassSectionsCompanion data) {
    return ClassSectionRow(
      sectionId: data.sectionId.present ? data.sectionId.value : this.sectionId,
      teacherId: data.teacherId.present ? data.teacherId.value : this.teacherId,
      sectionName: data.sectionName.present
          ? data.sectionName.value
          : this.sectionName,
      schoolName: data.schoolName.present
          ? data.schoolName.value
          : this.schoolName,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      schoolYear: data.schoolYear.present
          ? data.schoolYear.value
          : this.schoolYear,
      sectionPin: data.sectionPin.present
          ? data.sectionPin.value
          : this.sectionPin,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ClassSectionRow(')
          ..write('sectionId: $sectionId, ')
          ..write('teacherId: $teacherId, ')
          ..write('sectionName: $sectionName, ')
          ..write('schoolName: $schoolName, ')
          ..write('createdAt: $createdAt, ')
          ..write('schoolYear: $schoolYear, ')
          ..write('sectionPin: $sectionPin')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    sectionId,
    teacherId,
    sectionName,
    schoolName,
    createdAt,
    schoolYear,
    sectionPin,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ClassSectionRow &&
          other.sectionId == this.sectionId &&
          other.teacherId == this.teacherId &&
          other.sectionName == this.sectionName &&
          other.schoolName == this.schoolName &&
          other.createdAt == this.createdAt &&
          other.schoolYear == this.schoolYear &&
          other.sectionPin == this.sectionPin);
}

class ClassSectionsCompanion extends UpdateCompanion<ClassSectionRow> {
  final Value<String> sectionId;
  final Value<String?> teacherId;
  final Value<String> sectionName;
  final Value<String?> schoolName;
  final Value<int> createdAt;
  final Value<String?> schoolYear;
  final Value<String?> sectionPin;
  final Value<int> rowid;
  const ClassSectionsCompanion({
    this.sectionId = const Value.absent(),
    this.teacherId = const Value.absent(),
    this.sectionName = const Value.absent(),
    this.schoolName = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.schoolYear = const Value.absent(),
    this.sectionPin = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ClassSectionsCompanion.insert({
    required String sectionId,
    this.teacherId = const Value.absent(),
    required String sectionName,
    this.schoolName = const Value.absent(),
    required int createdAt,
    this.schoolYear = const Value.absent(),
    this.sectionPin = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : sectionId = Value(sectionId),
       sectionName = Value(sectionName),
       createdAt = Value(createdAt);
  static Insertable<ClassSectionRow> custom({
    Expression<String>? sectionId,
    Expression<String>? teacherId,
    Expression<String>? sectionName,
    Expression<String>? schoolName,
    Expression<int>? createdAt,
    Expression<String>? schoolYear,
    Expression<String>? sectionPin,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (sectionId != null) 'section_id': sectionId,
      if (teacherId != null) 'teacher_id': teacherId,
      if (sectionName != null) 'section_name': sectionName,
      if (schoolName != null) 'school_name': schoolName,
      if (createdAt != null) 'created_at': createdAt,
      if (schoolYear != null) 'school_year': schoolYear,
      if (sectionPin != null) 'section_pin': sectionPin,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ClassSectionsCompanion copyWith({
    Value<String>? sectionId,
    Value<String?>? teacherId,
    Value<String>? sectionName,
    Value<String?>? schoolName,
    Value<int>? createdAt,
    Value<String?>? schoolYear,
    Value<String?>? sectionPin,
    Value<int>? rowid,
  }) {
    return ClassSectionsCompanion(
      sectionId: sectionId ?? this.sectionId,
      teacherId: teacherId ?? this.teacherId,
      sectionName: sectionName ?? this.sectionName,
      schoolName: schoolName ?? this.schoolName,
      createdAt: createdAt ?? this.createdAt,
      schoolYear: schoolYear ?? this.schoolYear,
      sectionPin: sectionPin ?? this.sectionPin,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (sectionId.present) {
      map['section_id'] = Variable<String>(sectionId.value);
    }
    if (teacherId.present) {
      map['teacher_id'] = Variable<String>(teacherId.value);
    }
    if (sectionName.present) {
      map['section_name'] = Variable<String>(sectionName.value);
    }
    if (schoolName.present) {
      map['school_name'] = Variable<String>(schoolName.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (schoolYear.present) {
      map['school_year'] = Variable<String>(schoolYear.value);
    }
    if (sectionPin.present) {
      map['section_pin'] = Variable<String>(sectionPin.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ClassSectionsCompanion(')
          ..write('sectionId: $sectionId, ')
          ..write('teacherId: $teacherId, ')
          ..write('sectionName: $sectionName, ')
          ..write('schoolName: $schoolName, ')
          ..write('createdAt: $createdAt, ')
          ..write('schoolYear: $schoolYear, ')
          ..write('sectionPin: $sectionPin, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UsersTable extends Users with TableInfo<$UsersTable, UserRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (role IN (\'student\',\'teacher\'))',
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pinHashMeta = const VerificationMeta(
    'pinHash',
  );
  @override
  late final GeneratedColumn<String> pinHash = GeneratedColumn<String>(
    'pin_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _avatarIdMeta = const VerificationMeta(
    'avatarId',
  );
  @override
  late final GeneratedColumn<String> avatarId = GeneratedColumn<String>(
    'avatar_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _gradeLevelMeta = const VerificationMeta(
    'gradeLevel',
  );
  @override
  late final GeneratedColumn<String> gradeLevel = GeneratedColumn<String>(
    'grade_level',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _strandMeta = const VerificationMeta('strand');
  @override
  late final GeneratedColumn<String> strand = GeneratedColumn<String>(
    'strand',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sectionIdMeta = const VerificationMeta(
    'sectionId',
  );
  @override
  late final GeneratedColumn<String> sectionId = GeneratedColumn<String>(
    'section_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES class_sections (section_id)',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastLoginAtMeta = const VerificationMeta(
    'lastLoginAt',
  );
  @override
  late final GeneratedColumn<int> lastLoginAt = GeneratedColumn<int>(
    'last_login_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _officialStudentIdMeta = const VerificationMeta(
    'officialStudentId',
  );
  @override
  late final GeneratedColumn<String> officialStudentId =
      GeneratedColumn<String>(
        'official_student_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    userId,
    role,
    displayName,
    pinHash,
    avatarId,
    gradeLevel,
    strand,
    sectionId,
    createdAt,
    lastLoginAt,
    officialStudentId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('pin_hash')) {
      context.handle(
        _pinHashMeta,
        pinHash.isAcceptableOrUnknown(data['pin_hash']!, _pinHashMeta),
      );
    } else if (isInserting) {
      context.missing(_pinHashMeta);
    }
    if (data.containsKey('avatar_id')) {
      context.handle(
        _avatarIdMeta,
        avatarId.isAcceptableOrUnknown(data['avatar_id']!, _avatarIdMeta),
      );
    }
    if (data.containsKey('grade_level')) {
      context.handle(
        _gradeLevelMeta,
        gradeLevel.isAcceptableOrUnknown(data['grade_level']!, _gradeLevelMeta),
      );
    }
    if (data.containsKey('strand')) {
      context.handle(
        _strandMeta,
        strand.isAcceptableOrUnknown(data['strand']!, _strandMeta),
      );
    }
    if (data.containsKey('section_id')) {
      context.handle(
        _sectionIdMeta,
        sectionId.isAcceptableOrUnknown(data['section_id']!, _sectionIdMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('last_login_at')) {
      context.handle(
        _lastLoginAtMeta,
        lastLoginAt.isAcceptableOrUnknown(
          data['last_login_at']!,
          _lastLoginAtMeta,
        ),
      );
    }
    if (data.containsKey('official_student_id')) {
      context.handle(
        _officialStudentIdMeta,
        officialStudentId.isAcceptableOrUnknown(
          data['official_student_id']!,
          _officialStudentIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId};
  @override
  UserRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserRow(
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      )!,
      pinHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pin_hash'],
      )!,
      avatarId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}avatar_id'],
      ),
      gradeLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}grade_level'],
      ),
      strand: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}strand'],
      ),
      sectionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}section_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      lastLoginAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_login_at'],
      ),
      officialStudentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}official_student_id'],
      ),
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class UserRow extends DataClass implements Insertable<UserRow> {
  final String userId;
  final String role;
  final String displayName;
  final String pinHash;
  final String? avatarId;
  final String? gradeLevel;
  final String? strand;
  final String? sectionId;
  final int createdAt;
  final int? lastLoginAt;
  final String? officialStudentId;
  const UserRow({
    required this.userId,
    required this.role,
    required this.displayName,
    required this.pinHash,
    this.avatarId,
    this.gradeLevel,
    this.strand,
    this.sectionId,
    required this.createdAt,
    this.lastLoginAt,
    this.officialStudentId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    map['role'] = Variable<String>(role);
    map['display_name'] = Variable<String>(displayName);
    map['pin_hash'] = Variable<String>(pinHash);
    if (!nullToAbsent || avatarId != null) {
      map['avatar_id'] = Variable<String>(avatarId);
    }
    if (!nullToAbsent || gradeLevel != null) {
      map['grade_level'] = Variable<String>(gradeLevel);
    }
    if (!nullToAbsent || strand != null) {
      map['strand'] = Variable<String>(strand);
    }
    if (!nullToAbsent || sectionId != null) {
      map['section_id'] = Variable<String>(sectionId);
    }
    map['created_at'] = Variable<int>(createdAt);
    if (!nullToAbsent || lastLoginAt != null) {
      map['last_login_at'] = Variable<int>(lastLoginAt);
    }
    if (!nullToAbsent || officialStudentId != null) {
      map['official_student_id'] = Variable<String>(officialStudentId);
    }
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      userId: Value(userId),
      role: Value(role),
      displayName: Value(displayName),
      pinHash: Value(pinHash),
      avatarId: avatarId == null && nullToAbsent
          ? const Value.absent()
          : Value(avatarId),
      gradeLevel: gradeLevel == null && nullToAbsent
          ? const Value.absent()
          : Value(gradeLevel),
      strand: strand == null && nullToAbsent
          ? const Value.absent()
          : Value(strand),
      sectionId: sectionId == null && nullToAbsent
          ? const Value.absent()
          : Value(sectionId),
      createdAt: Value(createdAt),
      lastLoginAt: lastLoginAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastLoginAt),
      officialStudentId: officialStudentId == null && nullToAbsent
          ? const Value.absent()
          : Value(officialStudentId),
    );
  }

  factory UserRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserRow(
      userId: serializer.fromJson<String>(json['userId']),
      role: serializer.fromJson<String>(json['role']),
      displayName: serializer.fromJson<String>(json['displayName']),
      pinHash: serializer.fromJson<String>(json['pinHash']),
      avatarId: serializer.fromJson<String?>(json['avatarId']),
      gradeLevel: serializer.fromJson<String?>(json['gradeLevel']),
      strand: serializer.fromJson<String?>(json['strand']),
      sectionId: serializer.fromJson<String?>(json['sectionId']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      lastLoginAt: serializer.fromJson<int?>(json['lastLoginAt']),
      officialStudentId: serializer.fromJson<String?>(
        json['officialStudentId'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<String>(userId),
      'role': serializer.toJson<String>(role),
      'displayName': serializer.toJson<String>(displayName),
      'pinHash': serializer.toJson<String>(pinHash),
      'avatarId': serializer.toJson<String?>(avatarId),
      'gradeLevel': serializer.toJson<String?>(gradeLevel),
      'strand': serializer.toJson<String?>(strand),
      'sectionId': serializer.toJson<String?>(sectionId),
      'createdAt': serializer.toJson<int>(createdAt),
      'lastLoginAt': serializer.toJson<int?>(lastLoginAt),
      'officialStudentId': serializer.toJson<String?>(officialStudentId),
    };
  }

  UserRow copyWith({
    String? userId,
    String? role,
    String? displayName,
    String? pinHash,
    Value<String?> avatarId = const Value.absent(),
    Value<String?> gradeLevel = const Value.absent(),
    Value<String?> strand = const Value.absent(),
    Value<String?> sectionId = const Value.absent(),
    int? createdAt,
    Value<int?> lastLoginAt = const Value.absent(),
    Value<String?> officialStudentId = const Value.absent(),
  }) => UserRow(
    userId: userId ?? this.userId,
    role: role ?? this.role,
    displayName: displayName ?? this.displayName,
    pinHash: pinHash ?? this.pinHash,
    avatarId: avatarId.present ? avatarId.value : this.avatarId,
    gradeLevel: gradeLevel.present ? gradeLevel.value : this.gradeLevel,
    strand: strand.present ? strand.value : this.strand,
    sectionId: sectionId.present ? sectionId.value : this.sectionId,
    createdAt: createdAt ?? this.createdAt,
    lastLoginAt: lastLoginAt.present ? lastLoginAt.value : this.lastLoginAt,
    officialStudentId: officialStudentId.present
        ? officialStudentId.value
        : this.officialStudentId,
  );
  UserRow copyWithCompanion(UsersCompanion data) {
    return UserRow(
      userId: data.userId.present ? data.userId.value : this.userId,
      role: data.role.present ? data.role.value : this.role,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      pinHash: data.pinHash.present ? data.pinHash.value : this.pinHash,
      avatarId: data.avatarId.present ? data.avatarId.value : this.avatarId,
      gradeLevel: data.gradeLevel.present
          ? data.gradeLevel.value
          : this.gradeLevel,
      strand: data.strand.present ? data.strand.value : this.strand,
      sectionId: data.sectionId.present ? data.sectionId.value : this.sectionId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      lastLoginAt: data.lastLoginAt.present
          ? data.lastLoginAt.value
          : this.lastLoginAt,
      officialStudentId: data.officialStudentId.present
          ? data.officialStudentId.value
          : this.officialStudentId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserRow(')
          ..write('userId: $userId, ')
          ..write('role: $role, ')
          ..write('displayName: $displayName, ')
          ..write('pinHash: $pinHash, ')
          ..write('avatarId: $avatarId, ')
          ..write('gradeLevel: $gradeLevel, ')
          ..write('strand: $strand, ')
          ..write('sectionId: $sectionId, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastLoginAt: $lastLoginAt, ')
          ..write('officialStudentId: $officialStudentId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    userId,
    role,
    displayName,
    pinHash,
    avatarId,
    gradeLevel,
    strand,
    sectionId,
    createdAt,
    lastLoginAt,
    officialStudentId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserRow &&
          other.userId == this.userId &&
          other.role == this.role &&
          other.displayName == this.displayName &&
          other.pinHash == this.pinHash &&
          other.avatarId == this.avatarId &&
          other.gradeLevel == this.gradeLevel &&
          other.strand == this.strand &&
          other.sectionId == this.sectionId &&
          other.createdAt == this.createdAt &&
          other.lastLoginAt == this.lastLoginAt &&
          other.officialStudentId == this.officialStudentId);
}

class UsersCompanion extends UpdateCompanion<UserRow> {
  final Value<String> userId;
  final Value<String> role;
  final Value<String> displayName;
  final Value<String> pinHash;
  final Value<String?> avatarId;
  final Value<String?> gradeLevel;
  final Value<String?> strand;
  final Value<String?> sectionId;
  final Value<int> createdAt;
  final Value<int?> lastLoginAt;
  final Value<String?> officialStudentId;
  final Value<int> rowid;
  const UsersCompanion({
    this.userId = const Value.absent(),
    this.role = const Value.absent(),
    this.displayName = const Value.absent(),
    this.pinHash = const Value.absent(),
    this.avatarId = const Value.absent(),
    this.gradeLevel = const Value.absent(),
    this.strand = const Value.absent(),
    this.sectionId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastLoginAt = const Value.absent(),
    this.officialStudentId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsersCompanion.insert({
    required String userId,
    required String role,
    required String displayName,
    required String pinHash,
    this.avatarId = const Value.absent(),
    this.gradeLevel = const Value.absent(),
    this.strand = const Value.absent(),
    this.sectionId = const Value.absent(),
    required int createdAt,
    this.lastLoginAt = const Value.absent(),
    this.officialStudentId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : userId = Value(userId),
       role = Value(role),
       displayName = Value(displayName),
       pinHash = Value(pinHash),
       createdAt = Value(createdAt);
  static Insertable<UserRow> custom({
    Expression<String>? userId,
    Expression<String>? role,
    Expression<String>? displayName,
    Expression<String>? pinHash,
    Expression<String>? avatarId,
    Expression<String>? gradeLevel,
    Expression<String>? strand,
    Expression<String>? sectionId,
    Expression<int>? createdAt,
    Expression<int>? lastLoginAt,
    Expression<String>? officialStudentId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (role != null) 'role': role,
      if (displayName != null) 'display_name': displayName,
      if (pinHash != null) 'pin_hash': pinHash,
      if (avatarId != null) 'avatar_id': avatarId,
      if (gradeLevel != null) 'grade_level': gradeLevel,
      if (strand != null) 'strand': strand,
      if (sectionId != null) 'section_id': sectionId,
      if (createdAt != null) 'created_at': createdAt,
      if (lastLoginAt != null) 'last_login_at': lastLoginAt,
      if (officialStudentId != null) 'official_student_id': officialStudentId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsersCompanion copyWith({
    Value<String>? userId,
    Value<String>? role,
    Value<String>? displayName,
    Value<String>? pinHash,
    Value<String?>? avatarId,
    Value<String?>? gradeLevel,
    Value<String?>? strand,
    Value<String?>? sectionId,
    Value<int>? createdAt,
    Value<int?>? lastLoginAt,
    Value<String?>? officialStudentId,
    Value<int>? rowid,
  }) {
    return UsersCompanion(
      userId: userId ?? this.userId,
      role: role ?? this.role,
      displayName: displayName ?? this.displayName,
      pinHash: pinHash ?? this.pinHash,
      avatarId: avatarId ?? this.avatarId,
      gradeLevel: gradeLevel ?? this.gradeLevel,
      strand: strand ?? this.strand,
      sectionId: sectionId ?? this.sectionId,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      officialStudentId: officialStudentId ?? this.officialStudentId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (pinHash.present) {
      map['pin_hash'] = Variable<String>(pinHash.value);
    }
    if (avatarId.present) {
      map['avatar_id'] = Variable<String>(avatarId.value);
    }
    if (gradeLevel.present) {
      map['grade_level'] = Variable<String>(gradeLevel.value);
    }
    if (strand.present) {
      map['strand'] = Variable<String>(strand.value);
    }
    if (sectionId.present) {
      map['section_id'] = Variable<String>(sectionId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (lastLoginAt.present) {
      map['last_login_at'] = Variable<int>(lastLoginAt.value);
    }
    if (officialStudentId.present) {
      map['official_student_id'] = Variable<String>(officialStudentId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('userId: $userId, ')
          ..write('role: $role, ')
          ..write('displayName: $displayName, ')
          ..write('pinHash: $pinHash, ')
          ..write('avatarId: $avatarId, ')
          ..write('gradeLevel: $gradeLevel, ')
          ..write('strand: $strand, ')
          ..write('sectionId: $sectionId, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastLoginAt: $lastLoginAt, ')
          ..write('officialStudentId: $officialStudentId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ContentPacksTable extends ContentPacks
    with TableInfo<$ContentPacksTable, ContentPackRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ContentPacksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _packIdMeta = const VerificationMeta('packId');
  @override
  late final GeneratedColumn<String> packId = GeneratedColumn<String>(
    'pack_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _topicNameMeta = const VerificationMeta(
    'topicName',
  );
  @override
  late final GeneratedColumn<String> topicName = GeneratedColumn<String>(
    'topic_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<String> version = GeneratedColumn<String>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _melcCodesMeta = const VerificationMeta(
    'melcCodes',
  );
  @override
  late final GeneratedColumn<String> melcCodes = GeneratedColumn<String>(
    'melc_codes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _importedAtMeta = const VerificationMeta(
    'importedAt',
  );
  @override
  late final GeneratedColumn<int> importedAt = GeneratedColumn<int>(
    'imported_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    packId,
    topicName,
    version,
    melcCodes,
    importedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'content_packs';
  @override
  VerificationContext validateIntegrity(
    Insertable<ContentPackRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('pack_id')) {
      context.handle(
        _packIdMeta,
        packId.isAcceptableOrUnknown(data['pack_id']!, _packIdMeta),
      );
    } else if (isInserting) {
      context.missing(_packIdMeta);
    }
    if (data.containsKey('topic_name')) {
      context.handle(
        _topicNameMeta,
        topicName.isAcceptableOrUnknown(data['topic_name']!, _topicNameMeta),
      );
    } else if (isInserting) {
      context.missing(_topicNameMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    } else if (isInserting) {
      context.missing(_versionMeta);
    }
    if (data.containsKey('melc_codes')) {
      context.handle(
        _melcCodesMeta,
        melcCodes.isAcceptableOrUnknown(data['melc_codes']!, _melcCodesMeta),
      );
    }
    if (data.containsKey('imported_at')) {
      context.handle(
        _importedAtMeta,
        importedAt.isAcceptableOrUnknown(data['imported_at']!, _importedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_importedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {packId};
  @override
  ContentPackRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ContentPackRow(
      packId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pack_id'],
      )!,
      topicName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}topic_name'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}version'],
      )!,
      melcCodes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}melc_codes'],
      ),
      importedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}imported_at'],
      )!,
    );
  }

  @override
  $ContentPacksTable createAlias(String alias) {
    return $ContentPacksTable(attachedDatabase, alias);
  }
}

class ContentPackRow extends DataClass implements Insertable<ContentPackRow> {
  final String packId;
  final String topicName;
  final String version;
  final String? melcCodes;
  final int importedAt;
  const ContentPackRow({
    required this.packId,
    required this.topicName,
    required this.version,
    this.melcCodes,
    required this.importedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['pack_id'] = Variable<String>(packId);
    map['topic_name'] = Variable<String>(topicName);
    map['version'] = Variable<String>(version);
    if (!nullToAbsent || melcCodes != null) {
      map['melc_codes'] = Variable<String>(melcCodes);
    }
    map['imported_at'] = Variable<int>(importedAt);
    return map;
  }

  ContentPacksCompanion toCompanion(bool nullToAbsent) {
    return ContentPacksCompanion(
      packId: Value(packId),
      topicName: Value(topicName),
      version: Value(version),
      melcCodes: melcCodes == null && nullToAbsent
          ? const Value.absent()
          : Value(melcCodes),
      importedAt: Value(importedAt),
    );
  }

  factory ContentPackRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ContentPackRow(
      packId: serializer.fromJson<String>(json['packId']),
      topicName: serializer.fromJson<String>(json['topicName']),
      version: serializer.fromJson<String>(json['version']),
      melcCodes: serializer.fromJson<String?>(json['melcCodes']),
      importedAt: serializer.fromJson<int>(json['importedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'packId': serializer.toJson<String>(packId),
      'topicName': serializer.toJson<String>(topicName),
      'version': serializer.toJson<String>(version),
      'melcCodes': serializer.toJson<String?>(melcCodes),
      'importedAt': serializer.toJson<int>(importedAt),
    };
  }

  ContentPackRow copyWith({
    String? packId,
    String? topicName,
    String? version,
    Value<String?> melcCodes = const Value.absent(),
    int? importedAt,
  }) => ContentPackRow(
    packId: packId ?? this.packId,
    topicName: topicName ?? this.topicName,
    version: version ?? this.version,
    melcCodes: melcCodes.present ? melcCodes.value : this.melcCodes,
    importedAt: importedAt ?? this.importedAt,
  );
  ContentPackRow copyWithCompanion(ContentPacksCompanion data) {
    return ContentPackRow(
      packId: data.packId.present ? data.packId.value : this.packId,
      topicName: data.topicName.present ? data.topicName.value : this.topicName,
      version: data.version.present ? data.version.value : this.version,
      melcCodes: data.melcCodes.present ? data.melcCodes.value : this.melcCodes,
      importedAt: data.importedAt.present
          ? data.importedAt.value
          : this.importedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ContentPackRow(')
          ..write('packId: $packId, ')
          ..write('topicName: $topicName, ')
          ..write('version: $version, ')
          ..write('melcCodes: $melcCodes, ')
          ..write('importedAt: $importedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(packId, topicName, version, melcCodes, importedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ContentPackRow &&
          other.packId == this.packId &&
          other.topicName == this.topicName &&
          other.version == this.version &&
          other.melcCodes == this.melcCodes &&
          other.importedAt == this.importedAt);
}

class ContentPacksCompanion extends UpdateCompanion<ContentPackRow> {
  final Value<String> packId;
  final Value<String> topicName;
  final Value<String> version;
  final Value<String?> melcCodes;
  final Value<int> importedAt;
  final Value<int> rowid;
  const ContentPacksCompanion({
    this.packId = const Value.absent(),
    this.topicName = const Value.absent(),
    this.version = const Value.absent(),
    this.melcCodes = const Value.absent(),
    this.importedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ContentPacksCompanion.insert({
    required String packId,
    required String topicName,
    required String version,
    this.melcCodes = const Value.absent(),
    required int importedAt,
    this.rowid = const Value.absent(),
  }) : packId = Value(packId),
       topicName = Value(topicName),
       version = Value(version),
       importedAt = Value(importedAt);
  static Insertable<ContentPackRow> custom({
    Expression<String>? packId,
    Expression<String>? topicName,
    Expression<String>? version,
    Expression<String>? melcCodes,
    Expression<int>? importedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (packId != null) 'pack_id': packId,
      if (topicName != null) 'topic_name': topicName,
      if (version != null) 'version': version,
      if (melcCodes != null) 'melc_codes': melcCodes,
      if (importedAt != null) 'imported_at': importedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ContentPacksCompanion copyWith({
    Value<String>? packId,
    Value<String>? topicName,
    Value<String>? version,
    Value<String?>? melcCodes,
    Value<int>? importedAt,
    Value<int>? rowid,
  }) {
    return ContentPacksCompanion(
      packId: packId ?? this.packId,
      topicName: topicName ?? this.topicName,
      version: version ?? this.version,
      melcCodes: melcCodes ?? this.melcCodes,
      importedAt: importedAt ?? this.importedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (packId.present) {
      map['pack_id'] = Variable<String>(packId.value);
    }
    if (topicName.present) {
      map['topic_name'] = Variable<String>(topicName.value);
    }
    if (version.present) {
      map['version'] = Variable<String>(version.value);
    }
    if (melcCodes.present) {
      map['melc_codes'] = Variable<String>(melcCodes.value);
    }
    if (importedAt.present) {
      map['imported_at'] = Variable<int>(importedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ContentPacksCompanion(')
          ..write('packId: $packId, ')
          ..write('topicName: $topicName, ')
          ..write('version: $version, ')
          ..write('melcCodes: $melcCodes, ')
          ..write('importedAt: $importedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LessonStagesTable extends LessonStages
    with TableInfo<$LessonStagesTable, LessonStageRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LessonStagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _stageIdMeta = const VerificationMeta(
    'stageId',
  );
  @override
  late final GeneratedColumn<String> stageId = GeneratedColumn<String>(
    'stage_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _packIdMeta = const VerificationMeta('packId');
  @override
  late final GeneratedColumn<String> packId = GeneratedColumn<String>(
    'pack_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES content_packs (pack_id)',
    ),
  );
  static const VerificationMeta _stageNameMeta = const VerificationMeta(
    'stageName',
  );
  @override
  late final GeneratedColumn<String> stageName = GeneratedColumn<String>(
    'stage_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints:
        'NOT NULL CHECK (stage_name IN (\'engage\',\'explore\',\'explain\',\'elaborate\',\'evaluate\'))',
  );
  static const VerificationMeta _moduleKeyMeta = const VerificationMeta(
    'moduleKey',
  );
  @override
  late final GeneratedColumn<String> moduleKey = GeneratedColumn<String>(
    'module_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sequenceOrderMeta = const VerificationMeta(
    'sequenceOrder',
  );
  @override
  late final GeneratedColumn<int> sequenceOrder = GeneratedColumn<int>(
    'sequence_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayTitleMeta = const VerificationMeta(
    'displayTitle',
  );
  @override
  late final GeneratedColumn<String> displayTitle = GeneratedColumn<String>(
    'display_title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bodyJsonMeta = const VerificationMeta(
    'bodyJson',
  );
  @override
  late final GeneratedColumn<String> bodyJson = GeneratedColumn<String>(
    'body_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    stageId,
    packId,
    stageName,
    moduleKey,
    sequenceOrder,
    displayTitle,
    bodyJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lesson_stages';
  @override
  VerificationContext validateIntegrity(
    Insertable<LessonStageRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('stage_id')) {
      context.handle(
        _stageIdMeta,
        stageId.isAcceptableOrUnknown(data['stage_id']!, _stageIdMeta),
      );
    } else if (isInserting) {
      context.missing(_stageIdMeta);
    }
    if (data.containsKey('pack_id')) {
      context.handle(
        _packIdMeta,
        packId.isAcceptableOrUnknown(data['pack_id']!, _packIdMeta),
      );
    }
    if (data.containsKey('stage_name')) {
      context.handle(
        _stageNameMeta,
        stageName.isAcceptableOrUnknown(data['stage_name']!, _stageNameMeta),
      );
    } else if (isInserting) {
      context.missing(_stageNameMeta);
    }
    if (data.containsKey('module_key')) {
      context.handle(
        _moduleKeyMeta,
        moduleKey.isAcceptableOrUnknown(data['module_key']!, _moduleKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_moduleKeyMeta);
    }
    if (data.containsKey('sequence_order')) {
      context.handle(
        _sequenceOrderMeta,
        sequenceOrder.isAcceptableOrUnknown(
          data['sequence_order']!,
          _sequenceOrderMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sequenceOrderMeta);
    }
    if (data.containsKey('display_title')) {
      context.handle(
        _displayTitleMeta,
        displayTitle.isAcceptableOrUnknown(
          data['display_title']!,
          _displayTitleMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayTitleMeta);
    }
    if (data.containsKey('body_json')) {
      context.handle(
        _bodyJsonMeta,
        bodyJson.isAcceptableOrUnknown(data['body_json']!, _bodyJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_bodyJsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {stageId};
  @override
  LessonStageRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LessonStageRow(
      stageId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}stage_id'],
      )!,
      packId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pack_id'],
      ),
      stageName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}stage_name'],
      )!,
      moduleKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}module_key'],
      )!,
      sequenceOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sequence_order'],
      )!,
      displayTitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_title'],
      )!,
      bodyJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body_json'],
      )!,
    );
  }

  @override
  $LessonStagesTable createAlias(String alias) {
    return $LessonStagesTable(attachedDatabase, alias);
  }
}

class LessonStageRow extends DataClass implements Insertable<LessonStageRow> {
  final String stageId;
  final String? packId;
  final String stageName;
  final String moduleKey;
  final int sequenceOrder;
  final String displayTitle;
  final String bodyJson;
  const LessonStageRow({
    required this.stageId,
    this.packId,
    required this.stageName,
    required this.moduleKey,
    required this.sequenceOrder,
    required this.displayTitle,
    required this.bodyJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['stage_id'] = Variable<String>(stageId);
    if (!nullToAbsent || packId != null) {
      map['pack_id'] = Variable<String>(packId);
    }
    map['stage_name'] = Variable<String>(stageName);
    map['module_key'] = Variable<String>(moduleKey);
    map['sequence_order'] = Variable<int>(sequenceOrder);
    map['display_title'] = Variable<String>(displayTitle);
    map['body_json'] = Variable<String>(bodyJson);
    return map;
  }

  LessonStagesCompanion toCompanion(bool nullToAbsent) {
    return LessonStagesCompanion(
      stageId: Value(stageId),
      packId: packId == null && nullToAbsent
          ? const Value.absent()
          : Value(packId),
      stageName: Value(stageName),
      moduleKey: Value(moduleKey),
      sequenceOrder: Value(sequenceOrder),
      displayTitle: Value(displayTitle),
      bodyJson: Value(bodyJson),
    );
  }

  factory LessonStageRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LessonStageRow(
      stageId: serializer.fromJson<String>(json['stageId']),
      packId: serializer.fromJson<String?>(json['packId']),
      stageName: serializer.fromJson<String>(json['stageName']),
      moduleKey: serializer.fromJson<String>(json['moduleKey']),
      sequenceOrder: serializer.fromJson<int>(json['sequenceOrder']),
      displayTitle: serializer.fromJson<String>(json['displayTitle']),
      bodyJson: serializer.fromJson<String>(json['bodyJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'stageId': serializer.toJson<String>(stageId),
      'packId': serializer.toJson<String?>(packId),
      'stageName': serializer.toJson<String>(stageName),
      'moduleKey': serializer.toJson<String>(moduleKey),
      'sequenceOrder': serializer.toJson<int>(sequenceOrder),
      'displayTitle': serializer.toJson<String>(displayTitle),
      'bodyJson': serializer.toJson<String>(bodyJson),
    };
  }

  LessonStageRow copyWith({
    String? stageId,
    Value<String?> packId = const Value.absent(),
    String? stageName,
    String? moduleKey,
    int? sequenceOrder,
    String? displayTitle,
    String? bodyJson,
  }) => LessonStageRow(
    stageId: stageId ?? this.stageId,
    packId: packId.present ? packId.value : this.packId,
    stageName: stageName ?? this.stageName,
    moduleKey: moduleKey ?? this.moduleKey,
    sequenceOrder: sequenceOrder ?? this.sequenceOrder,
    displayTitle: displayTitle ?? this.displayTitle,
    bodyJson: bodyJson ?? this.bodyJson,
  );
  LessonStageRow copyWithCompanion(LessonStagesCompanion data) {
    return LessonStageRow(
      stageId: data.stageId.present ? data.stageId.value : this.stageId,
      packId: data.packId.present ? data.packId.value : this.packId,
      stageName: data.stageName.present ? data.stageName.value : this.stageName,
      moduleKey: data.moduleKey.present ? data.moduleKey.value : this.moduleKey,
      sequenceOrder: data.sequenceOrder.present
          ? data.sequenceOrder.value
          : this.sequenceOrder,
      displayTitle: data.displayTitle.present
          ? data.displayTitle.value
          : this.displayTitle,
      bodyJson: data.bodyJson.present ? data.bodyJson.value : this.bodyJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LessonStageRow(')
          ..write('stageId: $stageId, ')
          ..write('packId: $packId, ')
          ..write('stageName: $stageName, ')
          ..write('moduleKey: $moduleKey, ')
          ..write('sequenceOrder: $sequenceOrder, ')
          ..write('displayTitle: $displayTitle, ')
          ..write('bodyJson: $bodyJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    stageId,
    packId,
    stageName,
    moduleKey,
    sequenceOrder,
    displayTitle,
    bodyJson,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LessonStageRow &&
          other.stageId == this.stageId &&
          other.packId == this.packId &&
          other.stageName == this.stageName &&
          other.moduleKey == this.moduleKey &&
          other.sequenceOrder == this.sequenceOrder &&
          other.displayTitle == this.displayTitle &&
          other.bodyJson == this.bodyJson);
}

class LessonStagesCompanion extends UpdateCompanion<LessonStageRow> {
  final Value<String> stageId;
  final Value<String?> packId;
  final Value<String> stageName;
  final Value<String> moduleKey;
  final Value<int> sequenceOrder;
  final Value<String> displayTitle;
  final Value<String> bodyJson;
  final Value<int> rowid;
  const LessonStagesCompanion({
    this.stageId = const Value.absent(),
    this.packId = const Value.absent(),
    this.stageName = const Value.absent(),
    this.moduleKey = const Value.absent(),
    this.sequenceOrder = const Value.absent(),
    this.displayTitle = const Value.absent(),
    this.bodyJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LessonStagesCompanion.insert({
    required String stageId,
    this.packId = const Value.absent(),
    required String stageName,
    required String moduleKey,
    required int sequenceOrder,
    required String displayTitle,
    required String bodyJson,
    this.rowid = const Value.absent(),
  }) : stageId = Value(stageId),
       stageName = Value(stageName),
       moduleKey = Value(moduleKey),
       sequenceOrder = Value(sequenceOrder),
       displayTitle = Value(displayTitle),
       bodyJson = Value(bodyJson);
  static Insertable<LessonStageRow> custom({
    Expression<String>? stageId,
    Expression<String>? packId,
    Expression<String>? stageName,
    Expression<String>? moduleKey,
    Expression<int>? sequenceOrder,
    Expression<String>? displayTitle,
    Expression<String>? bodyJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (stageId != null) 'stage_id': stageId,
      if (packId != null) 'pack_id': packId,
      if (stageName != null) 'stage_name': stageName,
      if (moduleKey != null) 'module_key': moduleKey,
      if (sequenceOrder != null) 'sequence_order': sequenceOrder,
      if (displayTitle != null) 'display_title': displayTitle,
      if (bodyJson != null) 'body_json': bodyJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LessonStagesCompanion copyWith({
    Value<String>? stageId,
    Value<String?>? packId,
    Value<String>? stageName,
    Value<String>? moduleKey,
    Value<int>? sequenceOrder,
    Value<String>? displayTitle,
    Value<String>? bodyJson,
    Value<int>? rowid,
  }) {
    return LessonStagesCompanion(
      stageId: stageId ?? this.stageId,
      packId: packId ?? this.packId,
      stageName: stageName ?? this.stageName,
      moduleKey: moduleKey ?? this.moduleKey,
      sequenceOrder: sequenceOrder ?? this.sequenceOrder,
      displayTitle: displayTitle ?? this.displayTitle,
      bodyJson: bodyJson ?? this.bodyJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (stageId.present) {
      map['stage_id'] = Variable<String>(stageId.value);
    }
    if (packId.present) {
      map['pack_id'] = Variable<String>(packId.value);
    }
    if (stageName.present) {
      map['stage_name'] = Variable<String>(stageName.value);
    }
    if (moduleKey.present) {
      map['module_key'] = Variable<String>(moduleKey.value);
    }
    if (sequenceOrder.present) {
      map['sequence_order'] = Variable<int>(sequenceOrder.value);
    }
    if (displayTitle.present) {
      map['display_title'] = Variable<String>(displayTitle.value);
    }
    if (bodyJson.present) {
      map['body_json'] = Variable<String>(bodyJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LessonStagesCompanion(')
          ..write('stageId: $stageId, ')
          ..write('packId: $packId, ')
          ..write('stageName: $stageName, ')
          ..write('moduleKey: $moduleKey, ')
          ..write('sequenceOrder: $sequenceOrder, ')
          ..write('displayTitle: $displayTitle, ')
          ..write('bodyJson: $bodyJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $QuizItemsTable extends QuizItems
    with TableInfo<$QuizItemsTable, QuizItemRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuizItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<String> itemId = GeneratedColumn<String>(
    'item_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _packIdMeta = const VerificationMeta('packId');
  @override
  late final GeneratedColumn<String> packId = GeneratedColumn<String>(
    'pack_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES content_packs (pack_id)',
    ),
  );
  static const VerificationMeta _stageIdMeta = const VerificationMeta(
    'stageId',
  );
  @override
  late final GeneratedColumn<String> stageId = GeneratedColumn<String>(
    'stage_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES lesson_stages (stage_id)',
    ),
  );
  static const VerificationMeta _itemTypeMeta = const VerificationMeta(
    'itemType',
  );
  @override
  late final GeneratedColumn<String> itemType = GeneratedColumn<String>(
    'item_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (item_type IN (\'mcq\',\'numeric\'))',
  );
  static const VerificationMeta _promptMeta = const VerificationMeta('prompt');
  @override
  late final GeneratedColumn<String> prompt = GeneratedColumn<String>(
    'prompt',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _choicesJsonMeta = const VerificationMeta(
    'choicesJson',
  );
  @override
  late final GeneratedColumn<String> choicesJson = GeneratedColumn<String>(
    'choices_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _correctAnswerMeta = const VerificationMeta(
    'correctAnswer',
  );
  @override
  late final GeneratedColumn<String> correctAnswer = GeneratedColumn<String>(
    'correct_answer',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _toleranceMeta = const VerificationMeta(
    'tolerance',
  );
  @override
  late final GeneratedColumn<double> tolerance = GeneratedColumn<double>(
    'tolerance',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _explanationMeta = const VerificationMeta(
    'explanation',
  );
  @override
  late final GeneratedColumn<String> explanation = GeneratedColumn<String>(
    'explanation',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tosCompetencyMeta = const VerificationMeta(
    'tosCompetency',
  );
  @override
  late final GeneratedColumn<String> tosCompetency = GeneratedColumn<String>(
    'tos_competency',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _difficultyMeta = const VerificationMeta(
    'difficulty',
  );
  @override
  late final GeneratedColumn<String> difficulty = GeneratedColumn<String>(
    'difficulty',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints:
        'CHECK (difficulty IN (\'easy\',\'average\',\'difficult\'))',
  );
  static const VerificationMeta _teacherFormulaMeta = const VerificationMeta(
    'teacherFormula',
  );
  @override
  late final GeneratedColumn<String> teacherFormula = GeneratedColumn<String>(
    'teacher_formula',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    itemId,
    packId,
    stageId,
    itemType,
    prompt,
    choicesJson,
    correctAnswer,
    tolerance,
    explanation,
    tosCompetency,
    difficulty,
    teacherFormula,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'quiz_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<QuizItemRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('item_id')) {
      context.handle(
        _itemIdMeta,
        itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta),
      );
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('pack_id')) {
      context.handle(
        _packIdMeta,
        packId.isAcceptableOrUnknown(data['pack_id']!, _packIdMeta),
      );
    }
    if (data.containsKey('stage_id')) {
      context.handle(
        _stageIdMeta,
        stageId.isAcceptableOrUnknown(data['stage_id']!, _stageIdMeta),
      );
    }
    if (data.containsKey('item_type')) {
      context.handle(
        _itemTypeMeta,
        itemType.isAcceptableOrUnknown(data['item_type']!, _itemTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_itemTypeMeta);
    }
    if (data.containsKey('prompt')) {
      context.handle(
        _promptMeta,
        prompt.isAcceptableOrUnknown(data['prompt']!, _promptMeta),
      );
    } else if (isInserting) {
      context.missing(_promptMeta);
    }
    if (data.containsKey('choices_json')) {
      context.handle(
        _choicesJsonMeta,
        choicesJson.isAcceptableOrUnknown(
          data['choices_json']!,
          _choicesJsonMeta,
        ),
      );
    }
    if (data.containsKey('correct_answer')) {
      context.handle(
        _correctAnswerMeta,
        correctAnswer.isAcceptableOrUnknown(
          data['correct_answer']!,
          _correctAnswerMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_correctAnswerMeta);
    }
    if (data.containsKey('tolerance')) {
      context.handle(
        _toleranceMeta,
        tolerance.isAcceptableOrUnknown(data['tolerance']!, _toleranceMeta),
      );
    }
    if (data.containsKey('explanation')) {
      context.handle(
        _explanationMeta,
        explanation.isAcceptableOrUnknown(
          data['explanation']!,
          _explanationMeta,
        ),
      );
    }
    if (data.containsKey('tos_competency')) {
      context.handle(
        _tosCompetencyMeta,
        tosCompetency.isAcceptableOrUnknown(
          data['tos_competency']!,
          _tosCompetencyMeta,
        ),
      );
    }
    if (data.containsKey('difficulty')) {
      context.handle(
        _difficultyMeta,
        difficulty.isAcceptableOrUnknown(data['difficulty']!, _difficultyMeta),
      );
    }
    if (data.containsKey('teacher_formula')) {
      context.handle(
        _teacherFormulaMeta,
        teacherFormula.isAcceptableOrUnknown(
          data['teacher_formula']!,
          _teacherFormulaMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {itemId};
  @override
  QuizItemRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuizItemRow(
      itemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item_id'],
      )!,
      packId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pack_id'],
      ),
      stageId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}stage_id'],
      ),
      itemType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item_type'],
      )!,
      prompt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}prompt'],
      )!,
      choicesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}choices_json'],
      ),
      correctAnswer: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}correct_answer'],
      )!,
      tolerance: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}tolerance'],
      ),
      explanation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}explanation'],
      ),
      tosCompetency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tos_competency'],
      ),
      difficulty: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}difficulty'],
      ),
      teacherFormula: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}teacher_formula'],
      ),
    );
  }

  @override
  $QuizItemsTable createAlias(String alias) {
    return $QuizItemsTable(attachedDatabase, alias);
  }
}

class QuizItemRow extends DataClass implements Insertable<QuizItemRow> {
  final String itemId;
  final String? packId;
  final String? stageId;
  final String itemType;
  final String prompt;
  final String? choicesJson;
  final String correctAnswer;
  final double? tolerance;
  final String? explanation;
  final String? tosCompetency;
  final String? difficulty;
  final String? teacherFormula;
  const QuizItemRow({
    required this.itemId,
    this.packId,
    this.stageId,
    required this.itemType,
    required this.prompt,
    this.choicesJson,
    required this.correctAnswer,
    this.tolerance,
    this.explanation,
    this.tosCompetency,
    this.difficulty,
    this.teacherFormula,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['item_id'] = Variable<String>(itemId);
    if (!nullToAbsent || packId != null) {
      map['pack_id'] = Variable<String>(packId);
    }
    if (!nullToAbsent || stageId != null) {
      map['stage_id'] = Variable<String>(stageId);
    }
    map['item_type'] = Variable<String>(itemType);
    map['prompt'] = Variable<String>(prompt);
    if (!nullToAbsent || choicesJson != null) {
      map['choices_json'] = Variable<String>(choicesJson);
    }
    map['correct_answer'] = Variable<String>(correctAnswer);
    if (!nullToAbsent || tolerance != null) {
      map['tolerance'] = Variable<double>(tolerance);
    }
    if (!nullToAbsent || explanation != null) {
      map['explanation'] = Variable<String>(explanation);
    }
    if (!nullToAbsent || tosCompetency != null) {
      map['tos_competency'] = Variable<String>(tosCompetency);
    }
    if (!nullToAbsent || difficulty != null) {
      map['difficulty'] = Variable<String>(difficulty);
    }
    if (!nullToAbsent || teacherFormula != null) {
      map['teacher_formula'] = Variable<String>(teacherFormula);
    }
    return map;
  }

  QuizItemsCompanion toCompanion(bool nullToAbsent) {
    return QuizItemsCompanion(
      itemId: Value(itemId),
      packId: packId == null && nullToAbsent
          ? const Value.absent()
          : Value(packId),
      stageId: stageId == null && nullToAbsent
          ? const Value.absent()
          : Value(stageId),
      itemType: Value(itemType),
      prompt: Value(prompt),
      choicesJson: choicesJson == null && nullToAbsent
          ? const Value.absent()
          : Value(choicesJson),
      correctAnswer: Value(correctAnswer),
      tolerance: tolerance == null && nullToAbsent
          ? const Value.absent()
          : Value(tolerance),
      explanation: explanation == null && nullToAbsent
          ? const Value.absent()
          : Value(explanation),
      tosCompetency: tosCompetency == null && nullToAbsent
          ? const Value.absent()
          : Value(tosCompetency),
      difficulty: difficulty == null && nullToAbsent
          ? const Value.absent()
          : Value(difficulty),
      teacherFormula: teacherFormula == null && nullToAbsent
          ? const Value.absent()
          : Value(teacherFormula),
    );
  }

  factory QuizItemRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuizItemRow(
      itemId: serializer.fromJson<String>(json['itemId']),
      packId: serializer.fromJson<String?>(json['packId']),
      stageId: serializer.fromJson<String?>(json['stageId']),
      itemType: serializer.fromJson<String>(json['itemType']),
      prompt: serializer.fromJson<String>(json['prompt']),
      choicesJson: serializer.fromJson<String?>(json['choicesJson']),
      correctAnswer: serializer.fromJson<String>(json['correctAnswer']),
      tolerance: serializer.fromJson<double?>(json['tolerance']),
      explanation: serializer.fromJson<String?>(json['explanation']),
      tosCompetency: serializer.fromJson<String?>(json['tosCompetency']),
      difficulty: serializer.fromJson<String?>(json['difficulty']),
      teacherFormula: serializer.fromJson<String?>(json['teacherFormula']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'itemId': serializer.toJson<String>(itemId),
      'packId': serializer.toJson<String?>(packId),
      'stageId': serializer.toJson<String?>(stageId),
      'itemType': serializer.toJson<String>(itemType),
      'prompt': serializer.toJson<String>(prompt),
      'choicesJson': serializer.toJson<String?>(choicesJson),
      'correctAnswer': serializer.toJson<String>(correctAnswer),
      'tolerance': serializer.toJson<double?>(tolerance),
      'explanation': serializer.toJson<String?>(explanation),
      'tosCompetency': serializer.toJson<String?>(tosCompetency),
      'difficulty': serializer.toJson<String?>(difficulty),
      'teacherFormula': serializer.toJson<String?>(teacherFormula),
    };
  }

  QuizItemRow copyWith({
    String? itemId,
    Value<String?> packId = const Value.absent(),
    Value<String?> stageId = const Value.absent(),
    String? itemType,
    String? prompt,
    Value<String?> choicesJson = const Value.absent(),
    String? correctAnswer,
    Value<double?> tolerance = const Value.absent(),
    Value<String?> explanation = const Value.absent(),
    Value<String?> tosCompetency = const Value.absent(),
    Value<String?> difficulty = const Value.absent(),
    Value<String?> teacherFormula = const Value.absent(),
  }) => QuizItemRow(
    itemId: itemId ?? this.itemId,
    packId: packId.present ? packId.value : this.packId,
    stageId: stageId.present ? stageId.value : this.stageId,
    itemType: itemType ?? this.itemType,
    prompt: prompt ?? this.prompt,
    choicesJson: choicesJson.present ? choicesJson.value : this.choicesJson,
    correctAnswer: correctAnswer ?? this.correctAnswer,
    tolerance: tolerance.present ? tolerance.value : this.tolerance,
    explanation: explanation.present ? explanation.value : this.explanation,
    tosCompetency: tosCompetency.present
        ? tosCompetency.value
        : this.tosCompetency,
    difficulty: difficulty.present ? difficulty.value : this.difficulty,
    teacherFormula: teacherFormula.present
        ? teacherFormula.value
        : this.teacherFormula,
  );
  QuizItemRow copyWithCompanion(QuizItemsCompanion data) {
    return QuizItemRow(
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      packId: data.packId.present ? data.packId.value : this.packId,
      stageId: data.stageId.present ? data.stageId.value : this.stageId,
      itemType: data.itemType.present ? data.itemType.value : this.itemType,
      prompt: data.prompt.present ? data.prompt.value : this.prompt,
      choicesJson: data.choicesJson.present
          ? data.choicesJson.value
          : this.choicesJson,
      correctAnswer: data.correctAnswer.present
          ? data.correctAnswer.value
          : this.correctAnswer,
      tolerance: data.tolerance.present ? data.tolerance.value : this.tolerance,
      explanation: data.explanation.present
          ? data.explanation.value
          : this.explanation,
      tosCompetency: data.tosCompetency.present
          ? data.tosCompetency.value
          : this.tosCompetency,
      difficulty: data.difficulty.present
          ? data.difficulty.value
          : this.difficulty,
      teacherFormula: data.teacherFormula.present
          ? data.teacherFormula.value
          : this.teacherFormula,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QuizItemRow(')
          ..write('itemId: $itemId, ')
          ..write('packId: $packId, ')
          ..write('stageId: $stageId, ')
          ..write('itemType: $itemType, ')
          ..write('prompt: $prompt, ')
          ..write('choicesJson: $choicesJson, ')
          ..write('correctAnswer: $correctAnswer, ')
          ..write('tolerance: $tolerance, ')
          ..write('explanation: $explanation, ')
          ..write('tosCompetency: $tosCompetency, ')
          ..write('difficulty: $difficulty, ')
          ..write('teacherFormula: $teacherFormula')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    itemId,
    packId,
    stageId,
    itemType,
    prompt,
    choicesJson,
    correctAnswer,
    tolerance,
    explanation,
    tosCompetency,
    difficulty,
    teacherFormula,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuizItemRow &&
          other.itemId == this.itemId &&
          other.packId == this.packId &&
          other.stageId == this.stageId &&
          other.itemType == this.itemType &&
          other.prompt == this.prompt &&
          other.choicesJson == this.choicesJson &&
          other.correctAnswer == this.correctAnswer &&
          other.tolerance == this.tolerance &&
          other.explanation == this.explanation &&
          other.tosCompetency == this.tosCompetency &&
          other.difficulty == this.difficulty &&
          other.teacherFormula == this.teacherFormula);
}

class QuizItemsCompanion extends UpdateCompanion<QuizItemRow> {
  final Value<String> itemId;
  final Value<String?> packId;
  final Value<String?> stageId;
  final Value<String> itemType;
  final Value<String> prompt;
  final Value<String?> choicesJson;
  final Value<String> correctAnswer;
  final Value<double?> tolerance;
  final Value<String?> explanation;
  final Value<String?> tosCompetency;
  final Value<String?> difficulty;
  final Value<String?> teacherFormula;
  final Value<int> rowid;
  const QuizItemsCompanion({
    this.itemId = const Value.absent(),
    this.packId = const Value.absent(),
    this.stageId = const Value.absent(),
    this.itemType = const Value.absent(),
    this.prompt = const Value.absent(),
    this.choicesJson = const Value.absent(),
    this.correctAnswer = const Value.absent(),
    this.tolerance = const Value.absent(),
    this.explanation = const Value.absent(),
    this.tosCompetency = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.teacherFormula = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  QuizItemsCompanion.insert({
    required String itemId,
    this.packId = const Value.absent(),
    this.stageId = const Value.absent(),
    required String itemType,
    required String prompt,
    this.choicesJson = const Value.absent(),
    required String correctAnswer,
    this.tolerance = const Value.absent(),
    this.explanation = const Value.absent(),
    this.tosCompetency = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.teacherFormula = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : itemId = Value(itemId),
       itemType = Value(itemType),
       prompt = Value(prompt),
       correctAnswer = Value(correctAnswer);
  static Insertable<QuizItemRow> custom({
    Expression<String>? itemId,
    Expression<String>? packId,
    Expression<String>? stageId,
    Expression<String>? itemType,
    Expression<String>? prompt,
    Expression<String>? choicesJson,
    Expression<String>? correctAnswer,
    Expression<double>? tolerance,
    Expression<String>? explanation,
    Expression<String>? tosCompetency,
    Expression<String>? difficulty,
    Expression<String>? teacherFormula,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (itemId != null) 'item_id': itemId,
      if (packId != null) 'pack_id': packId,
      if (stageId != null) 'stage_id': stageId,
      if (itemType != null) 'item_type': itemType,
      if (prompt != null) 'prompt': prompt,
      if (choicesJson != null) 'choices_json': choicesJson,
      if (correctAnswer != null) 'correct_answer': correctAnswer,
      if (tolerance != null) 'tolerance': tolerance,
      if (explanation != null) 'explanation': explanation,
      if (tosCompetency != null) 'tos_competency': tosCompetency,
      if (difficulty != null) 'difficulty': difficulty,
      if (teacherFormula != null) 'teacher_formula': teacherFormula,
      if (rowid != null) 'rowid': rowid,
    });
  }

  QuizItemsCompanion copyWith({
    Value<String>? itemId,
    Value<String?>? packId,
    Value<String?>? stageId,
    Value<String>? itemType,
    Value<String>? prompt,
    Value<String?>? choicesJson,
    Value<String>? correctAnswer,
    Value<double?>? tolerance,
    Value<String?>? explanation,
    Value<String?>? tosCompetency,
    Value<String?>? difficulty,
    Value<String?>? teacherFormula,
    Value<int>? rowid,
  }) {
    return QuizItemsCompanion(
      itemId: itemId ?? this.itemId,
      packId: packId ?? this.packId,
      stageId: stageId ?? this.stageId,
      itemType: itemType ?? this.itemType,
      prompt: prompt ?? this.prompt,
      choicesJson: choicesJson ?? this.choicesJson,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      tolerance: tolerance ?? this.tolerance,
      explanation: explanation ?? this.explanation,
      tosCompetency: tosCompetency ?? this.tosCompetency,
      difficulty: difficulty ?? this.difficulty,
      teacherFormula: teacherFormula ?? this.teacherFormula,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (itemId.present) {
      map['item_id'] = Variable<String>(itemId.value);
    }
    if (packId.present) {
      map['pack_id'] = Variable<String>(packId.value);
    }
    if (stageId.present) {
      map['stage_id'] = Variable<String>(stageId.value);
    }
    if (itemType.present) {
      map['item_type'] = Variable<String>(itemType.value);
    }
    if (prompt.present) {
      map['prompt'] = Variable<String>(prompt.value);
    }
    if (choicesJson.present) {
      map['choices_json'] = Variable<String>(choicesJson.value);
    }
    if (correctAnswer.present) {
      map['correct_answer'] = Variable<String>(correctAnswer.value);
    }
    if (tolerance.present) {
      map['tolerance'] = Variable<double>(tolerance.value);
    }
    if (explanation.present) {
      map['explanation'] = Variable<String>(explanation.value);
    }
    if (tosCompetency.present) {
      map['tos_competency'] = Variable<String>(tosCompetency.value);
    }
    if (difficulty.present) {
      map['difficulty'] = Variable<String>(difficulty.value);
    }
    if (teacherFormula.present) {
      map['teacher_formula'] = Variable<String>(teacherFormula.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuizItemsCompanion(')
          ..write('itemId: $itemId, ')
          ..write('packId: $packId, ')
          ..write('stageId: $stageId, ')
          ..write('itemType: $itemType, ')
          ..write('prompt: $prompt, ')
          ..write('choicesJson: $choicesJson, ')
          ..write('correctAnswer: $correctAnswer, ')
          ..write('tolerance: $tolerance, ')
          ..write('explanation: $explanation, ')
          ..write('tosCompetency: $tosCompetency, ')
          ..write('difficulty: $difficulty, ')
          ..write('teacherFormula: $teacherFormula, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MissionLevelsTable extends MissionLevels
    with TableInfo<$MissionLevelsTable, MissionLevelRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MissionLevelsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _levelIdMeta = const VerificationMeta(
    'levelId',
  );
  @override
  late final GeneratedColumn<String> levelId = GeneratedColumn<String>(
    'level_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _packIdMeta = const VerificationMeta('packId');
  @override
  late final GeneratedColumn<String> packId = GeneratedColumn<String>(
    'pack_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES content_packs (pack_id)',
    ),
  );
  static const VerificationMeta _levelNumberMeta = const VerificationMeta(
    'levelNumber',
  );
  @override
  late final GeneratedColumn<int> levelNumber = GeneratedColumn<int>(
    'level_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scenarioTextMeta = const VerificationMeta(
    'scenarioText',
  );
  @override
  late final GeneratedColumn<String> scenarioText = GeneratedColumn<String>(
    'scenario_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _givenValuesMeta = const VerificationMeta(
    'givenValues',
  );
  @override
  late final GeneratedColumn<String> givenValues = GeneratedColumn<String>(
    'given_values',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetVariableMeta = const VerificationMeta(
    'targetVariable',
  );
  @override
  late final GeneratedColumn<String> targetVariable = GeneratedColumn<String>(
    'target_variable',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _correctAnswerMeta = const VerificationMeta(
    'correctAnswer',
  );
  @override
  late final GeneratedColumn<double> correctAnswer = GeneratedColumn<double>(
    'correct_answer',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _toleranceMeta = const VerificationMeta(
    'tolerance',
  );
  @override
  late final GeneratedColumn<double> tolerance = GeneratedColumn<double>(
    'tolerance',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.1),
  );
  static const VerificationMeta _formulaHintMeta = const VerificationMeta(
    'formulaHint',
  );
  @override
  late final GeneratedColumn<String> formulaHint = GeneratedColumn<String>(
    'formula_hint',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _teacherSolutionMeta = const VerificationMeta(
    'teacherSolution',
  );
  @override
  late final GeneratedColumn<String> teacherSolution = GeneratedColumn<String>(
    'teacher_solution',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    levelId,
    packId,
    levelNumber,
    title,
    scenarioText,
    givenValues,
    targetVariable,
    correctAnswer,
    tolerance,
    formulaHint,
    unit,
    teacherSolution,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mission_levels';
  @override
  VerificationContext validateIntegrity(
    Insertable<MissionLevelRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('level_id')) {
      context.handle(
        _levelIdMeta,
        levelId.isAcceptableOrUnknown(data['level_id']!, _levelIdMeta),
      );
    } else if (isInserting) {
      context.missing(_levelIdMeta);
    }
    if (data.containsKey('pack_id')) {
      context.handle(
        _packIdMeta,
        packId.isAcceptableOrUnknown(data['pack_id']!, _packIdMeta),
      );
    }
    if (data.containsKey('level_number')) {
      context.handle(
        _levelNumberMeta,
        levelNumber.isAcceptableOrUnknown(
          data['level_number']!,
          _levelNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_levelNumberMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('scenario_text')) {
      context.handle(
        _scenarioTextMeta,
        scenarioText.isAcceptableOrUnknown(
          data['scenario_text']!,
          _scenarioTextMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_scenarioTextMeta);
    }
    if (data.containsKey('given_values')) {
      context.handle(
        _givenValuesMeta,
        givenValues.isAcceptableOrUnknown(
          data['given_values']!,
          _givenValuesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_givenValuesMeta);
    }
    if (data.containsKey('target_variable')) {
      context.handle(
        _targetVariableMeta,
        targetVariable.isAcceptableOrUnknown(
          data['target_variable']!,
          _targetVariableMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetVariableMeta);
    }
    if (data.containsKey('correct_answer')) {
      context.handle(
        _correctAnswerMeta,
        correctAnswer.isAcceptableOrUnknown(
          data['correct_answer']!,
          _correctAnswerMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_correctAnswerMeta);
    }
    if (data.containsKey('tolerance')) {
      context.handle(
        _toleranceMeta,
        tolerance.isAcceptableOrUnknown(data['tolerance']!, _toleranceMeta),
      );
    }
    if (data.containsKey('formula_hint')) {
      context.handle(
        _formulaHintMeta,
        formulaHint.isAcceptableOrUnknown(
          data['formula_hint']!,
          _formulaHintMeta,
        ),
      );
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    }
    if (data.containsKey('teacher_solution')) {
      context.handle(
        _teacherSolutionMeta,
        teacherSolution.isAcceptableOrUnknown(
          data['teacher_solution']!,
          _teacherSolutionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {levelId};
  @override
  MissionLevelRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MissionLevelRow(
      levelId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}level_id'],
      )!,
      packId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pack_id'],
      ),
      levelNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}level_number'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      scenarioText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}scenario_text'],
      )!,
      givenValues: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}given_values'],
      )!,
      targetVariable: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_variable'],
      )!,
      correctAnswer: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}correct_answer'],
      )!,
      tolerance: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}tolerance'],
      )!,
      formulaHint: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}formula_hint'],
      ),
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      ),
      teacherSolution: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}teacher_solution'],
      ),
    );
  }

  @override
  $MissionLevelsTable createAlias(String alias) {
    return $MissionLevelsTable(attachedDatabase, alias);
  }
}

class MissionLevelRow extends DataClass implements Insertable<MissionLevelRow> {
  final String levelId;
  final String? packId;
  final int levelNumber;
  final String title;
  final String scenarioText;
  final String givenValues;
  final String targetVariable;
  final double correctAnswer;
  final double tolerance;
  final String? formulaHint;
  final String? unit;
  final String? teacherSolution;
  const MissionLevelRow({
    required this.levelId,
    this.packId,
    required this.levelNumber,
    required this.title,
    required this.scenarioText,
    required this.givenValues,
    required this.targetVariable,
    required this.correctAnswer,
    required this.tolerance,
    this.formulaHint,
    this.unit,
    this.teacherSolution,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['level_id'] = Variable<String>(levelId);
    if (!nullToAbsent || packId != null) {
      map['pack_id'] = Variable<String>(packId);
    }
    map['level_number'] = Variable<int>(levelNumber);
    map['title'] = Variable<String>(title);
    map['scenario_text'] = Variable<String>(scenarioText);
    map['given_values'] = Variable<String>(givenValues);
    map['target_variable'] = Variable<String>(targetVariable);
    map['correct_answer'] = Variable<double>(correctAnswer);
    map['tolerance'] = Variable<double>(tolerance);
    if (!nullToAbsent || formulaHint != null) {
      map['formula_hint'] = Variable<String>(formulaHint);
    }
    if (!nullToAbsent || unit != null) {
      map['unit'] = Variable<String>(unit);
    }
    if (!nullToAbsent || teacherSolution != null) {
      map['teacher_solution'] = Variable<String>(teacherSolution);
    }
    return map;
  }

  MissionLevelsCompanion toCompanion(bool nullToAbsent) {
    return MissionLevelsCompanion(
      levelId: Value(levelId),
      packId: packId == null && nullToAbsent
          ? const Value.absent()
          : Value(packId),
      levelNumber: Value(levelNumber),
      title: Value(title),
      scenarioText: Value(scenarioText),
      givenValues: Value(givenValues),
      targetVariable: Value(targetVariable),
      correctAnswer: Value(correctAnswer),
      tolerance: Value(tolerance),
      formulaHint: formulaHint == null && nullToAbsent
          ? const Value.absent()
          : Value(formulaHint),
      unit: unit == null && nullToAbsent ? const Value.absent() : Value(unit),
      teacherSolution: teacherSolution == null && nullToAbsent
          ? const Value.absent()
          : Value(teacherSolution),
    );
  }

  factory MissionLevelRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MissionLevelRow(
      levelId: serializer.fromJson<String>(json['levelId']),
      packId: serializer.fromJson<String?>(json['packId']),
      levelNumber: serializer.fromJson<int>(json['levelNumber']),
      title: serializer.fromJson<String>(json['title']),
      scenarioText: serializer.fromJson<String>(json['scenarioText']),
      givenValues: serializer.fromJson<String>(json['givenValues']),
      targetVariable: serializer.fromJson<String>(json['targetVariable']),
      correctAnswer: serializer.fromJson<double>(json['correctAnswer']),
      tolerance: serializer.fromJson<double>(json['tolerance']),
      formulaHint: serializer.fromJson<String?>(json['formulaHint']),
      unit: serializer.fromJson<String?>(json['unit']),
      teacherSolution: serializer.fromJson<String?>(json['teacherSolution']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'levelId': serializer.toJson<String>(levelId),
      'packId': serializer.toJson<String?>(packId),
      'levelNumber': serializer.toJson<int>(levelNumber),
      'title': serializer.toJson<String>(title),
      'scenarioText': serializer.toJson<String>(scenarioText),
      'givenValues': serializer.toJson<String>(givenValues),
      'targetVariable': serializer.toJson<String>(targetVariable),
      'correctAnswer': serializer.toJson<double>(correctAnswer),
      'tolerance': serializer.toJson<double>(tolerance),
      'formulaHint': serializer.toJson<String?>(formulaHint),
      'unit': serializer.toJson<String?>(unit),
      'teacherSolution': serializer.toJson<String?>(teacherSolution),
    };
  }

  MissionLevelRow copyWith({
    String? levelId,
    Value<String?> packId = const Value.absent(),
    int? levelNumber,
    String? title,
    String? scenarioText,
    String? givenValues,
    String? targetVariable,
    double? correctAnswer,
    double? tolerance,
    Value<String?> formulaHint = const Value.absent(),
    Value<String?> unit = const Value.absent(),
    Value<String?> teacherSolution = const Value.absent(),
  }) => MissionLevelRow(
    levelId: levelId ?? this.levelId,
    packId: packId.present ? packId.value : this.packId,
    levelNumber: levelNumber ?? this.levelNumber,
    title: title ?? this.title,
    scenarioText: scenarioText ?? this.scenarioText,
    givenValues: givenValues ?? this.givenValues,
    targetVariable: targetVariable ?? this.targetVariable,
    correctAnswer: correctAnswer ?? this.correctAnswer,
    tolerance: tolerance ?? this.tolerance,
    formulaHint: formulaHint.present ? formulaHint.value : this.formulaHint,
    unit: unit.present ? unit.value : this.unit,
    teacherSolution: teacherSolution.present
        ? teacherSolution.value
        : this.teacherSolution,
  );
  MissionLevelRow copyWithCompanion(MissionLevelsCompanion data) {
    return MissionLevelRow(
      levelId: data.levelId.present ? data.levelId.value : this.levelId,
      packId: data.packId.present ? data.packId.value : this.packId,
      levelNumber: data.levelNumber.present
          ? data.levelNumber.value
          : this.levelNumber,
      title: data.title.present ? data.title.value : this.title,
      scenarioText: data.scenarioText.present
          ? data.scenarioText.value
          : this.scenarioText,
      givenValues: data.givenValues.present
          ? data.givenValues.value
          : this.givenValues,
      targetVariable: data.targetVariable.present
          ? data.targetVariable.value
          : this.targetVariable,
      correctAnswer: data.correctAnswer.present
          ? data.correctAnswer.value
          : this.correctAnswer,
      tolerance: data.tolerance.present ? data.tolerance.value : this.tolerance,
      formulaHint: data.formulaHint.present
          ? data.formulaHint.value
          : this.formulaHint,
      unit: data.unit.present ? data.unit.value : this.unit,
      teacherSolution: data.teacherSolution.present
          ? data.teacherSolution.value
          : this.teacherSolution,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MissionLevelRow(')
          ..write('levelId: $levelId, ')
          ..write('packId: $packId, ')
          ..write('levelNumber: $levelNumber, ')
          ..write('title: $title, ')
          ..write('scenarioText: $scenarioText, ')
          ..write('givenValues: $givenValues, ')
          ..write('targetVariable: $targetVariable, ')
          ..write('correctAnswer: $correctAnswer, ')
          ..write('tolerance: $tolerance, ')
          ..write('formulaHint: $formulaHint, ')
          ..write('unit: $unit, ')
          ..write('teacherSolution: $teacherSolution')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    levelId,
    packId,
    levelNumber,
    title,
    scenarioText,
    givenValues,
    targetVariable,
    correctAnswer,
    tolerance,
    formulaHint,
    unit,
    teacherSolution,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MissionLevelRow &&
          other.levelId == this.levelId &&
          other.packId == this.packId &&
          other.levelNumber == this.levelNumber &&
          other.title == this.title &&
          other.scenarioText == this.scenarioText &&
          other.givenValues == this.givenValues &&
          other.targetVariable == this.targetVariable &&
          other.correctAnswer == this.correctAnswer &&
          other.tolerance == this.tolerance &&
          other.formulaHint == this.formulaHint &&
          other.unit == this.unit &&
          other.teacherSolution == this.teacherSolution);
}

class MissionLevelsCompanion extends UpdateCompanion<MissionLevelRow> {
  final Value<String> levelId;
  final Value<String?> packId;
  final Value<int> levelNumber;
  final Value<String> title;
  final Value<String> scenarioText;
  final Value<String> givenValues;
  final Value<String> targetVariable;
  final Value<double> correctAnswer;
  final Value<double> tolerance;
  final Value<String?> formulaHint;
  final Value<String?> unit;
  final Value<String?> teacherSolution;
  final Value<int> rowid;
  const MissionLevelsCompanion({
    this.levelId = const Value.absent(),
    this.packId = const Value.absent(),
    this.levelNumber = const Value.absent(),
    this.title = const Value.absent(),
    this.scenarioText = const Value.absent(),
    this.givenValues = const Value.absent(),
    this.targetVariable = const Value.absent(),
    this.correctAnswer = const Value.absent(),
    this.tolerance = const Value.absent(),
    this.formulaHint = const Value.absent(),
    this.unit = const Value.absent(),
    this.teacherSolution = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MissionLevelsCompanion.insert({
    required String levelId,
    this.packId = const Value.absent(),
    required int levelNumber,
    required String title,
    required String scenarioText,
    required String givenValues,
    required String targetVariable,
    required double correctAnswer,
    this.tolerance = const Value.absent(),
    this.formulaHint = const Value.absent(),
    this.unit = const Value.absent(),
    this.teacherSolution = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : levelId = Value(levelId),
       levelNumber = Value(levelNumber),
       title = Value(title),
       scenarioText = Value(scenarioText),
       givenValues = Value(givenValues),
       targetVariable = Value(targetVariable),
       correctAnswer = Value(correctAnswer);
  static Insertable<MissionLevelRow> custom({
    Expression<String>? levelId,
    Expression<String>? packId,
    Expression<int>? levelNumber,
    Expression<String>? title,
    Expression<String>? scenarioText,
    Expression<String>? givenValues,
    Expression<String>? targetVariable,
    Expression<double>? correctAnswer,
    Expression<double>? tolerance,
    Expression<String>? formulaHint,
    Expression<String>? unit,
    Expression<String>? teacherSolution,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (levelId != null) 'level_id': levelId,
      if (packId != null) 'pack_id': packId,
      if (levelNumber != null) 'level_number': levelNumber,
      if (title != null) 'title': title,
      if (scenarioText != null) 'scenario_text': scenarioText,
      if (givenValues != null) 'given_values': givenValues,
      if (targetVariable != null) 'target_variable': targetVariable,
      if (correctAnswer != null) 'correct_answer': correctAnswer,
      if (tolerance != null) 'tolerance': tolerance,
      if (formulaHint != null) 'formula_hint': formulaHint,
      if (unit != null) 'unit': unit,
      if (teacherSolution != null) 'teacher_solution': teacherSolution,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MissionLevelsCompanion copyWith({
    Value<String>? levelId,
    Value<String?>? packId,
    Value<int>? levelNumber,
    Value<String>? title,
    Value<String>? scenarioText,
    Value<String>? givenValues,
    Value<String>? targetVariable,
    Value<double>? correctAnswer,
    Value<double>? tolerance,
    Value<String?>? formulaHint,
    Value<String?>? unit,
    Value<String?>? teacherSolution,
    Value<int>? rowid,
  }) {
    return MissionLevelsCompanion(
      levelId: levelId ?? this.levelId,
      packId: packId ?? this.packId,
      levelNumber: levelNumber ?? this.levelNumber,
      title: title ?? this.title,
      scenarioText: scenarioText ?? this.scenarioText,
      givenValues: givenValues ?? this.givenValues,
      targetVariable: targetVariable ?? this.targetVariable,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      tolerance: tolerance ?? this.tolerance,
      formulaHint: formulaHint ?? this.formulaHint,
      unit: unit ?? this.unit,
      teacherSolution: teacherSolution ?? this.teacherSolution,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (levelId.present) {
      map['level_id'] = Variable<String>(levelId.value);
    }
    if (packId.present) {
      map['pack_id'] = Variable<String>(packId.value);
    }
    if (levelNumber.present) {
      map['level_number'] = Variable<int>(levelNumber.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (scenarioText.present) {
      map['scenario_text'] = Variable<String>(scenarioText.value);
    }
    if (givenValues.present) {
      map['given_values'] = Variable<String>(givenValues.value);
    }
    if (targetVariable.present) {
      map['target_variable'] = Variable<String>(targetVariable.value);
    }
    if (correctAnswer.present) {
      map['correct_answer'] = Variable<double>(correctAnswer.value);
    }
    if (tolerance.present) {
      map['tolerance'] = Variable<double>(tolerance.value);
    }
    if (formulaHint.present) {
      map['formula_hint'] = Variable<String>(formulaHint.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (teacherSolution.present) {
      map['teacher_solution'] = Variable<String>(teacherSolution.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MissionLevelsCompanion(')
          ..write('levelId: $levelId, ')
          ..write('packId: $packId, ')
          ..write('levelNumber: $levelNumber, ')
          ..write('title: $title, ')
          ..write('scenarioText: $scenarioText, ')
          ..write('givenValues: $givenValues, ')
          ..write('targetVariable: $targetVariable, ')
          ..write('correctAnswer: $correctAnswer, ')
          ..write('tolerance: $tolerance, ')
          ..write('formulaHint: $formulaHint, ')
          ..write('unit: $unit, ')
          ..write('teacherSolution: $teacherSolution, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PredictionLogTable extends PredictionLog
    with TableInfo<$PredictionLogTable, PredictionLogRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PredictionLogTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _logIdMeta = const VerificationMeta('logId');
  @override
  late final GeneratedColumn<String> logId = GeneratedColumn<String>(
    'log_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (user_id)',
    ),
  );
  static const VerificationMeta _stageIdMeta = const VerificationMeta(
    'stageId',
  );
  @override
  late final GeneratedColumn<String> stageId = GeneratedColumn<String>(
    'stage_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES lesson_stages (stage_id)',
    ),
  );
  static const VerificationMeta _predictedOptionMeta = const VerificationMeta(
    'predictedOption',
  );
  @override
  late final GeneratedColumn<String> predictedOption = GeneratedColumn<String>(
    'predicted_option',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reasoningKeyMeta = const VerificationMeta(
    'reasoningKey',
  );
  @override
  late final GeneratedColumn<String> reasoningKey = GeneratedColumn<String>(
    'reasoning_key',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _submittedAtMeta = const VerificationMeta(
    'submittedAt',
  );
  @override
  late final GeneratedColumn<int> submittedAt = GeneratedColumn<int>(
    'submitted_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    logId,
    userId,
    stageId,
    predictedOption,
    reasoningKey,
    submittedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'prediction_log';
  @override
  VerificationContext validateIntegrity(
    Insertable<PredictionLogRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('log_id')) {
      context.handle(
        _logIdMeta,
        logId.isAcceptableOrUnknown(data['log_id']!, _logIdMeta),
      );
    } else if (isInserting) {
      context.missing(_logIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    }
    if (data.containsKey('stage_id')) {
      context.handle(
        _stageIdMeta,
        stageId.isAcceptableOrUnknown(data['stage_id']!, _stageIdMeta),
      );
    }
    if (data.containsKey('predicted_option')) {
      context.handle(
        _predictedOptionMeta,
        predictedOption.isAcceptableOrUnknown(
          data['predicted_option']!,
          _predictedOptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_predictedOptionMeta);
    }
    if (data.containsKey('reasoning_key')) {
      context.handle(
        _reasoningKeyMeta,
        reasoningKey.isAcceptableOrUnknown(
          data['reasoning_key']!,
          _reasoningKeyMeta,
        ),
      );
    }
    if (data.containsKey('submitted_at')) {
      context.handle(
        _submittedAtMeta,
        submittedAt.isAcceptableOrUnknown(
          data['submitted_at']!,
          _submittedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_submittedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {logId};
  @override
  PredictionLogRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PredictionLogRow(
      logId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}log_id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      ),
      stageId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}stage_id'],
      ),
      predictedOption: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}predicted_option'],
      )!,
      reasoningKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reasoning_key'],
      ),
      submittedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}submitted_at'],
      )!,
    );
  }

  @override
  $PredictionLogTable createAlias(String alias) {
    return $PredictionLogTable(attachedDatabase, alias);
  }
}

class PredictionLogRow extends DataClass
    implements Insertable<PredictionLogRow> {
  final String logId;
  final String? userId;
  final String? stageId;
  final String predictedOption;
  final String? reasoningKey;
  final int submittedAt;
  const PredictionLogRow({
    required this.logId,
    this.userId,
    this.stageId,
    required this.predictedOption,
    this.reasoningKey,
    required this.submittedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['log_id'] = Variable<String>(logId);
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    if (!nullToAbsent || stageId != null) {
      map['stage_id'] = Variable<String>(stageId);
    }
    map['predicted_option'] = Variable<String>(predictedOption);
    if (!nullToAbsent || reasoningKey != null) {
      map['reasoning_key'] = Variable<String>(reasoningKey);
    }
    map['submitted_at'] = Variable<int>(submittedAt);
    return map;
  }

  PredictionLogCompanion toCompanion(bool nullToAbsent) {
    return PredictionLogCompanion(
      logId: Value(logId),
      userId: userId == null && nullToAbsent
          ? const Value.absent()
          : Value(userId),
      stageId: stageId == null && nullToAbsent
          ? const Value.absent()
          : Value(stageId),
      predictedOption: Value(predictedOption),
      reasoningKey: reasoningKey == null && nullToAbsent
          ? const Value.absent()
          : Value(reasoningKey),
      submittedAt: Value(submittedAt),
    );
  }

  factory PredictionLogRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PredictionLogRow(
      logId: serializer.fromJson<String>(json['logId']),
      userId: serializer.fromJson<String?>(json['userId']),
      stageId: serializer.fromJson<String?>(json['stageId']),
      predictedOption: serializer.fromJson<String>(json['predictedOption']),
      reasoningKey: serializer.fromJson<String?>(json['reasoningKey']),
      submittedAt: serializer.fromJson<int>(json['submittedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'logId': serializer.toJson<String>(logId),
      'userId': serializer.toJson<String?>(userId),
      'stageId': serializer.toJson<String?>(stageId),
      'predictedOption': serializer.toJson<String>(predictedOption),
      'reasoningKey': serializer.toJson<String?>(reasoningKey),
      'submittedAt': serializer.toJson<int>(submittedAt),
    };
  }

  PredictionLogRow copyWith({
    String? logId,
    Value<String?> userId = const Value.absent(),
    Value<String?> stageId = const Value.absent(),
    String? predictedOption,
    Value<String?> reasoningKey = const Value.absent(),
    int? submittedAt,
  }) => PredictionLogRow(
    logId: logId ?? this.logId,
    userId: userId.present ? userId.value : this.userId,
    stageId: stageId.present ? stageId.value : this.stageId,
    predictedOption: predictedOption ?? this.predictedOption,
    reasoningKey: reasoningKey.present ? reasoningKey.value : this.reasoningKey,
    submittedAt: submittedAt ?? this.submittedAt,
  );
  PredictionLogRow copyWithCompanion(PredictionLogCompanion data) {
    return PredictionLogRow(
      logId: data.logId.present ? data.logId.value : this.logId,
      userId: data.userId.present ? data.userId.value : this.userId,
      stageId: data.stageId.present ? data.stageId.value : this.stageId,
      predictedOption: data.predictedOption.present
          ? data.predictedOption.value
          : this.predictedOption,
      reasoningKey: data.reasoningKey.present
          ? data.reasoningKey.value
          : this.reasoningKey,
      submittedAt: data.submittedAt.present
          ? data.submittedAt.value
          : this.submittedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PredictionLogRow(')
          ..write('logId: $logId, ')
          ..write('userId: $userId, ')
          ..write('stageId: $stageId, ')
          ..write('predictedOption: $predictedOption, ')
          ..write('reasoningKey: $reasoningKey, ')
          ..write('submittedAt: $submittedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    logId,
    userId,
    stageId,
    predictedOption,
    reasoningKey,
    submittedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PredictionLogRow &&
          other.logId == this.logId &&
          other.userId == this.userId &&
          other.stageId == this.stageId &&
          other.predictedOption == this.predictedOption &&
          other.reasoningKey == this.reasoningKey &&
          other.submittedAt == this.submittedAt);
}

class PredictionLogCompanion extends UpdateCompanion<PredictionLogRow> {
  final Value<String> logId;
  final Value<String?> userId;
  final Value<String?> stageId;
  final Value<String> predictedOption;
  final Value<String?> reasoningKey;
  final Value<int> submittedAt;
  final Value<int> rowid;
  const PredictionLogCompanion({
    this.logId = const Value.absent(),
    this.userId = const Value.absent(),
    this.stageId = const Value.absent(),
    this.predictedOption = const Value.absent(),
    this.reasoningKey = const Value.absent(),
    this.submittedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PredictionLogCompanion.insert({
    required String logId,
    this.userId = const Value.absent(),
    this.stageId = const Value.absent(),
    required String predictedOption,
    this.reasoningKey = const Value.absent(),
    required int submittedAt,
    this.rowid = const Value.absent(),
  }) : logId = Value(logId),
       predictedOption = Value(predictedOption),
       submittedAt = Value(submittedAt);
  static Insertable<PredictionLogRow> custom({
    Expression<String>? logId,
    Expression<String>? userId,
    Expression<String>? stageId,
    Expression<String>? predictedOption,
    Expression<String>? reasoningKey,
    Expression<int>? submittedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (logId != null) 'log_id': logId,
      if (userId != null) 'user_id': userId,
      if (stageId != null) 'stage_id': stageId,
      if (predictedOption != null) 'predicted_option': predictedOption,
      if (reasoningKey != null) 'reasoning_key': reasoningKey,
      if (submittedAt != null) 'submitted_at': submittedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PredictionLogCompanion copyWith({
    Value<String>? logId,
    Value<String?>? userId,
    Value<String?>? stageId,
    Value<String>? predictedOption,
    Value<String?>? reasoningKey,
    Value<int>? submittedAt,
    Value<int>? rowid,
  }) {
    return PredictionLogCompanion(
      logId: logId ?? this.logId,
      userId: userId ?? this.userId,
      stageId: stageId ?? this.stageId,
      predictedOption: predictedOption ?? this.predictedOption,
      reasoningKey: reasoningKey ?? this.reasoningKey,
      submittedAt: submittedAt ?? this.submittedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (logId.present) {
      map['log_id'] = Variable<String>(logId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (stageId.present) {
      map['stage_id'] = Variable<String>(stageId.value);
    }
    if (predictedOption.present) {
      map['predicted_option'] = Variable<String>(predictedOption.value);
    }
    if (reasoningKey.present) {
      map['reasoning_key'] = Variable<String>(reasoningKey.value);
    }
    if (submittedAt.present) {
      map['submitted_at'] = Variable<int>(submittedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PredictionLogCompanion(')
          ..write('logId: $logId, ')
          ..write('userId: $userId, ')
          ..write('stageId: $stageId, ')
          ..write('predictedOption: $predictedOption, ')
          ..write('reasoningKey: $reasoningKey, ')
          ..write('submittedAt: $submittedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MotionTrialsTable extends MotionTrials
    with TableInfo<$MotionTrialsTable, MotionTrialRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MotionTrialsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _trialIdMeta = const VerificationMeta(
    'trialId',
  );
  @override
  late final GeneratedColumn<String> trialId = GeneratedColumn<String>(
    'trial_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (user_id)',
    ),
  );
  static const VerificationMeta _groupIdMeta = const VerificationMeta(
    'groupId',
  );
  @override
  late final GeneratedColumn<String> groupId = GeneratedColumn<String>(
    'group_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _trialNumberMeta = const VerificationMeta(
    'trialNumber',
  );
  @override
  late final GeneratedColumn<int> trialNumber = GeneratedColumn<int>(
    'trial_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _distanceMMeta = const VerificationMeta(
    'distanceM',
  );
  @override
  late final GeneratedColumn<double> distanceM = GeneratedColumn<double>(
    'distance_m',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displacementMMeta = const VerificationMeta(
    'displacementM',
  );
  @override
  late final GeneratedColumn<double> displacementM = GeneratedColumn<double>(
    'displacement_m',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timeSMeta = const VerificationMeta('timeS');
  @override
  late final GeneratedColumn<double> timeS = GeneratedColumn<double>(
    'time_s',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _computedSpeedMeta = const VerificationMeta(
    'computedSpeed',
  );
  @override
  late final GeneratedColumn<double> computedSpeed = GeneratedColumn<double>(
    'computed_speed',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _computedVelocityMeta = const VerificationMeta(
    'computedVelocity',
  );
  @override
  late final GeneratedColumn<double> computedVelocity = GeneratedColumn<double>(
    'computed_velocity',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _recordedAtMeta = const VerificationMeta(
    'recordedAt',
  );
  @override
  late final GeneratedColumn<int> recordedAt = GeneratedColumn<int>(
    'recorded_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    trialId,
    userId,
    groupId,
    trialNumber,
    distanceM,
    displacementM,
    timeS,
    computedSpeed,
    computedVelocity,
    recordedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'motion_trials';
  @override
  VerificationContext validateIntegrity(
    Insertable<MotionTrialRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('trial_id')) {
      context.handle(
        _trialIdMeta,
        trialId.isAcceptableOrUnknown(data['trial_id']!, _trialIdMeta),
      );
    } else if (isInserting) {
      context.missing(_trialIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    }
    if (data.containsKey('group_id')) {
      context.handle(
        _groupIdMeta,
        groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta),
      );
    }
    if (data.containsKey('trial_number')) {
      context.handle(
        _trialNumberMeta,
        trialNumber.isAcceptableOrUnknown(
          data['trial_number']!,
          _trialNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_trialNumberMeta);
    }
    if (data.containsKey('distance_m')) {
      context.handle(
        _distanceMMeta,
        distanceM.isAcceptableOrUnknown(data['distance_m']!, _distanceMMeta),
      );
    } else if (isInserting) {
      context.missing(_distanceMMeta);
    }
    if (data.containsKey('displacement_m')) {
      context.handle(
        _displacementMMeta,
        displacementM.isAcceptableOrUnknown(
          data['displacement_m']!,
          _displacementMMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displacementMMeta);
    }
    if (data.containsKey('time_s')) {
      context.handle(
        _timeSMeta,
        timeS.isAcceptableOrUnknown(data['time_s']!, _timeSMeta),
      );
    } else if (isInserting) {
      context.missing(_timeSMeta);
    }
    if (data.containsKey('computed_speed')) {
      context.handle(
        _computedSpeedMeta,
        computedSpeed.isAcceptableOrUnknown(
          data['computed_speed']!,
          _computedSpeedMeta,
        ),
      );
    }
    if (data.containsKey('computed_velocity')) {
      context.handle(
        _computedVelocityMeta,
        computedVelocity.isAcceptableOrUnknown(
          data['computed_velocity']!,
          _computedVelocityMeta,
        ),
      );
    }
    if (data.containsKey('recorded_at')) {
      context.handle(
        _recordedAtMeta,
        recordedAt.isAcceptableOrUnknown(data['recorded_at']!, _recordedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_recordedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {trialId};
  @override
  MotionTrialRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MotionTrialRow(
      trialId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}trial_id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      ),
      groupId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}group_id'],
      ),
      trialNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}trial_number'],
      )!,
      distanceM: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}distance_m'],
      )!,
      displacementM: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}displacement_m'],
      )!,
      timeS: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}time_s'],
      )!,
      computedSpeed: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}computed_speed'],
      ),
      computedVelocity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}computed_velocity'],
      ),
      recordedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}recorded_at'],
      )!,
    );
  }

  @override
  $MotionTrialsTable createAlias(String alias) {
    return $MotionTrialsTable(attachedDatabase, alias);
  }
}

class MotionTrialRow extends DataClass implements Insertable<MotionTrialRow> {
  final String trialId;
  final String? userId;
  final String? groupId;
  final int trialNumber;
  final double distanceM;
  final double displacementM;
  final double timeS;
  final double? computedSpeed;
  final double? computedVelocity;
  final int recordedAt;
  const MotionTrialRow({
    required this.trialId,
    this.userId,
    this.groupId,
    required this.trialNumber,
    required this.distanceM,
    required this.displacementM,
    required this.timeS,
    this.computedSpeed,
    this.computedVelocity,
    required this.recordedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['trial_id'] = Variable<String>(trialId);
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    if (!nullToAbsent || groupId != null) {
      map['group_id'] = Variable<String>(groupId);
    }
    map['trial_number'] = Variable<int>(trialNumber);
    map['distance_m'] = Variable<double>(distanceM);
    map['displacement_m'] = Variable<double>(displacementM);
    map['time_s'] = Variable<double>(timeS);
    if (!nullToAbsent || computedSpeed != null) {
      map['computed_speed'] = Variable<double>(computedSpeed);
    }
    if (!nullToAbsent || computedVelocity != null) {
      map['computed_velocity'] = Variable<double>(computedVelocity);
    }
    map['recorded_at'] = Variable<int>(recordedAt);
    return map;
  }

  MotionTrialsCompanion toCompanion(bool nullToAbsent) {
    return MotionTrialsCompanion(
      trialId: Value(trialId),
      userId: userId == null && nullToAbsent
          ? const Value.absent()
          : Value(userId),
      groupId: groupId == null && nullToAbsent
          ? const Value.absent()
          : Value(groupId),
      trialNumber: Value(trialNumber),
      distanceM: Value(distanceM),
      displacementM: Value(displacementM),
      timeS: Value(timeS),
      computedSpeed: computedSpeed == null && nullToAbsent
          ? const Value.absent()
          : Value(computedSpeed),
      computedVelocity: computedVelocity == null && nullToAbsent
          ? const Value.absent()
          : Value(computedVelocity),
      recordedAt: Value(recordedAt),
    );
  }

  factory MotionTrialRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MotionTrialRow(
      trialId: serializer.fromJson<String>(json['trialId']),
      userId: serializer.fromJson<String?>(json['userId']),
      groupId: serializer.fromJson<String?>(json['groupId']),
      trialNumber: serializer.fromJson<int>(json['trialNumber']),
      distanceM: serializer.fromJson<double>(json['distanceM']),
      displacementM: serializer.fromJson<double>(json['displacementM']),
      timeS: serializer.fromJson<double>(json['timeS']),
      computedSpeed: serializer.fromJson<double?>(json['computedSpeed']),
      computedVelocity: serializer.fromJson<double?>(json['computedVelocity']),
      recordedAt: serializer.fromJson<int>(json['recordedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'trialId': serializer.toJson<String>(trialId),
      'userId': serializer.toJson<String?>(userId),
      'groupId': serializer.toJson<String?>(groupId),
      'trialNumber': serializer.toJson<int>(trialNumber),
      'distanceM': serializer.toJson<double>(distanceM),
      'displacementM': serializer.toJson<double>(displacementM),
      'timeS': serializer.toJson<double>(timeS),
      'computedSpeed': serializer.toJson<double?>(computedSpeed),
      'computedVelocity': serializer.toJson<double?>(computedVelocity),
      'recordedAt': serializer.toJson<int>(recordedAt),
    };
  }

  MotionTrialRow copyWith({
    String? trialId,
    Value<String?> userId = const Value.absent(),
    Value<String?> groupId = const Value.absent(),
    int? trialNumber,
    double? distanceM,
    double? displacementM,
    double? timeS,
    Value<double?> computedSpeed = const Value.absent(),
    Value<double?> computedVelocity = const Value.absent(),
    int? recordedAt,
  }) => MotionTrialRow(
    trialId: trialId ?? this.trialId,
    userId: userId.present ? userId.value : this.userId,
    groupId: groupId.present ? groupId.value : this.groupId,
    trialNumber: trialNumber ?? this.trialNumber,
    distanceM: distanceM ?? this.distanceM,
    displacementM: displacementM ?? this.displacementM,
    timeS: timeS ?? this.timeS,
    computedSpeed: computedSpeed.present
        ? computedSpeed.value
        : this.computedSpeed,
    computedVelocity: computedVelocity.present
        ? computedVelocity.value
        : this.computedVelocity,
    recordedAt: recordedAt ?? this.recordedAt,
  );
  MotionTrialRow copyWithCompanion(MotionTrialsCompanion data) {
    return MotionTrialRow(
      trialId: data.trialId.present ? data.trialId.value : this.trialId,
      userId: data.userId.present ? data.userId.value : this.userId,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      trialNumber: data.trialNumber.present
          ? data.trialNumber.value
          : this.trialNumber,
      distanceM: data.distanceM.present ? data.distanceM.value : this.distanceM,
      displacementM: data.displacementM.present
          ? data.displacementM.value
          : this.displacementM,
      timeS: data.timeS.present ? data.timeS.value : this.timeS,
      computedSpeed: data.computedSpeed.present
          ? data.computedSpeed.value
          : this.computedSpeed,
      computedVelocity: data.computedVelocity.present
          ? data.computedVelocity.value
          : this.computedVelocity,
      recordedAt: data.recordedAt.present
          ? data.recordedAt.value
          : this.recordedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MotionTrialRow(')
          ..write('trialId: $trialId, ')
          ..write('userId: $userId, ')
          ..write('groupId: $groupId, ')
          ..write('trialNumber: $trialNumber, ')
          ..write('distanceM: $distanceM, ')
          ..write('displacementM: $displacementM, ')
          ..write('timeS: $timeS, ')
          ..write('computedSpeed: $computedSpeed, ')
          ..write('computedVelocity: $computedVelocity, ')
          ..write('recordedAt: $recordedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    trialId,
    userId,
    groupId,
    trialNumber,
    distanceM,
    displacementM,
    timeS,
    computedSpeed,
    computedVelocity,
    recordedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MotionTrialRow &&
          other.trialId == this.trialId &&
          other.userId == this.userId &&
          other.groupId == this.groupId &&
          other.trialNumber == this.trialNumber &&
          other.distanceM == this.distanceM &&
          other.displacementM == this.displacementM &&
          other.timeS == this.timeS &&
          other.computedSpeed == this.computedSpeed &&
          other.computedVelocity == this.computedVelocity &&
          other.recordedAt == this.recordedAt);
}

class MotionTrialsCompanion extends UpdateCompanion<MotionTrialRow> {
  final Value<String> trialId;
  final Value<String?> userId;
  final Value<String?> groupId;
  final Value<int> trialNumber;
  final Value<double> distanceM;
  final Value<double> displacementM;
  final Value<double> timeS;
  final Value<double?> computedSpeed;
  final Value<double?> computedVelocity;
  final Value<int> recordedAt;
  final Value<int> rowid;
  const MotionTrialsCompanion({
    this.trialId = const Value.absent(),
    this.userId = const Value.absent(),
    this.groupId = const Value.absent(),
    this.trialNumber = const Value.absent(),
    this.distanceM = const Value.absent(),
    this.displacementM = const Value.absent(),
    this.timeS = const Value.absent(),
    this.computedSpeed = const Value.absent(),
    this.computedVelocity = const Value.absent(),
    this.recordedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MotionTrialsCompanion.insert({
    required String trialId,
    this.userId = const Value.absent(),
    this.groupId = const Value.absent(),
    required int trialNumber,
    required double distanceM,
    required double displacementM,
    required double timeS,
    this.computedSpeed = const Value.absent(),
    this.computedVelocity = const Value.absent(),
    required int recordedAt,
    this.rowid = const Value.absent(),
  }) : trialId = Value(trialId),
       trialNumber = Value(trialNumber),
       distanceM = Value(distanceM),
       displacementM = Value(displacementM),
       timeS = Value(timeS),
       recordedAt = Value(recordedAt);
  static Insertable<MotionTrialRow> custom({
    Expression<String>? trialId,
    Expression<String>? userId,
    Expression<String>? groupId,
    Expression<int>? trialNumber,
    Expression<double>? distanceM,
    Expression<double>? displacementM,
    Expression<double>? timeS,
    Expression<double>? computedSpeed,
    Expression<double>? computedVelocity,
    Expression<int>? recordedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (trialId != null) 'trial_id': trialId,
      if (userId != null) 'user_id': userId,
      if (groupId != null) 'group_id': groupId,
      if (trialNumber != null) 'trial_number': trialNumber,
      if (distanceM != null) 'distance_m': distanceM,
      if (displacementM != null) 'displacement_m': displacementM,
      if (timeS != null) 'time_s': timeS,
      if (computedSpeed != null) 'computed_speed': computedSpeed,
      if (computedVelocity != null) 'computed_velocity': computedVelocity,
      if (recordedAt != null) 'recorded_at': recordedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MotionTrialsCompanion copyWith({
    Value<String>? trialId,
    Value<String?>? userId,
    Value<String?>? groupId,
    Value<int>? trialNumber,
    Value<double>? distanceM,
    Value<double>? displacementM,
    Value<double>? timeS,
    Value<double?>? computedSpeed,
    Value<double?>? computedVelocity,
    Value<int>? recordedAt,
    Value<int>? rowid,
  }) {
    return MotionTrialsCompanion(
      trialId: trialId ?? this.trialId,
      userId: userId ?? this.userId,
      groupId: groupId ?? this.groupId,
      trialNumber: trialNumber ?? this.trialNumber,
      distanceM: distanceM ?? this.distanceM,
      displacementM: displacementM ?? this.displacementM,
      timeS: timeS ?? this.timeS,
      computedSpeed: computedSpeed ?? this.computedSpeed,
      computedVelocity: computedVelocity ?? this.computedVelocity,
      recordedAt: recordedAt ?? this.recordedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (trialId.present) {
      map['trial_id'] = Variable<String>(trialId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<String>(groupId.value);
    }
    if (trialNumber.present) {
      map['trial_number'] = Variable<int>(trialNumber.value);
    }
    if (distanceM.present) {
      map['distance_m'] = Variable<double>(distanceM.value);
    }
    if (displacementM.present) {
      map['displacement_m'] = Variable<double>(displacementM.value);
    }
    if (timeS.present) {
      map['time_s'] = Variable<double>(timeS.value);
    }
    if (computedSpeed.present) {
      map['computed_speed'] = Variable<double>(computedSpeed.value);
    }
    if (computedVelocity.present) {
      map['computed_velocity'] = Variable<double>(computedVelocity.value);
    }
    if (recordedAt.present) {
      map['recorded_at'] = Variable<int>(recordedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MotionTrialsCompanion(')
          ..write('trialId: $trialId, ')
          ..write('userId: $userId, ')
          ..write('groupId: $groupId, ')
          ..write('trialNumber: $trialNumber, ')
          ..write('distanceM: $distanceM, ')
          ..write('displacementM: $displacementM, ')
          ..write('timeS: $timeS, ')
          ..write('computedSpeed: $computedSpeed, ')
          ..write('computedVelocity: $computedVelocity, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MissionAttemptsTable extends MissionAttempts
    with TableInfo<$MissionAttemptsTable, MissionAttemptRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MissionAttemptsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _attemptIdMeta = const VerificationMeta(
    'attemptId',
  );
  @override
  late final GeneratedColumn<String> attemptId = GeneratedColumn<String>(
    'attempt_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (user_id)',
    ),
  );
  static const VerificationMeta _levelIdMeta = const VerificationMeta(
    'levelId',
  );
  @override
  late final GeneratedColumn<String> levelId = GeneratedColumn<String>(
    'level_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES mission_levels (level_id)',
    ),
  );
  static const VerificationMeta _submittedAnswerMeta = const VerificationMeta(
    'submittedAnswer',
  );
  @override
  late final GeneratedColumn<double> submittedAnswer = GeneratedColumn<double>(
    'submitted_answer',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isCorrectMeta = const VerificationMeta(
    'isCorrect',
  );
  @override
  late final GeneratedColumn<bool> isCorrect = GeneratedColumn<bool>(
    'is_correct',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_correct" IN (0, 1))',
    ),
  );
  static const VerificationMeta _attemptNumberMeta = const VerificationMeta(
    'attemptNumber',
  );
  @override
  late final GeneratedColumn<int> attemptNumber = GeneratedColumn<int>(
    'attempt_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pointsAwardedMeta = const VerificationMeta(
    'pointsAwarded',
  );
  @override
  late final GeneratedColumn<int> pointsAwarded = GeneratedColumn<int>(
    'points_awarded',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _submittedAtMeta = const VerificationMeta(
    'submittedAt',
  );
  @override
  late final GeneratedColumn<int> submittedAt = GeneratedColumn<int>(
    'submitted_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    attemptId,
    userId,
    levelId,
    submittedAnswer,
    isCorrect,
    attemptNumber,
    pointsAwarded,
    submittedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mission_attempts';
  @override
  VerificationContext validateIntegrity(
    Insertable<MissionAttemptRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('attempt_id')) {
      context.handle(
        _attemptIdMeta,
        attemptId.isAcceptableOrUnknown(data['attempt_id']!, _attemptIdMeta),
      );
    } else if (isInserting) {
      context.missing(_attemptIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    }
    if (data.containsKey('level_id')) {
      context.handle(
        _levelIdMeta,
        levelId.isAcceptableOrUnknown(data['level_id']!, _levelIdMeta),
      );
    }
    if (data.containsKey('submitted_answer')) {
      context.handle(
        _submittedAnswerMeta,
        submittedAnswer.isAcceptableOrUnknown(
          data['submitted_answer']!,
          _submittedAnswerMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_submittedAnswerMeta);
    }
    if (data.containsKey('is_correct')) {
      context.handle(
        _isCorrectMeta,
        isCorrect.isAcceptableOrUnknown(data['is_correct']!, _isCorrectMeta),
      );
    } else if (isInserting) {
      context.missing(_isCorrectMeta);
    }
    if (data.containsKey('attempt_number')) {
      context.handle(
        _attemptNumberMeta,
        attemptNumber.isAcceptableOrUnknown(
          data['attempt_number']!,
          _attemptNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_attemptNumberMeta);
    }
    if (data.containsKey('points_awarded')) {
      context.handle(
        _pointsAwardedMeta,
        pointsAwarded.isAcceptableOrUnknown(
          data['points_awarded']!,
          _pointsAwardedMeta,
        ),
      );
    }
    if (data.containsKey('submitted_at')) {
      context.handle(
        _submittedAtMeta,
        submittedAt.isAcceptableOrUnknown(
          data['submitted_at']!,
          _submittedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_submittedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {attemptId};
  @override
  MissionAttemptRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MissionAttemptRow(
      attemptId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}attempt_id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      ),
      levelId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}level_id'],
      ),
      submittedAnswer: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}submitted_answer'],
      )!,
      isCorrect: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_correct'],
      )!,
      attemptNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempt_number'],
      )!,
      pointsAwarded: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}points_awarded'],
      )!,
      submittedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}submitted_at'],
      )!,
    );
  }

  @override
  $MissionAttemptsTable createAlias(String alias) {
    return $MissionAttemptsTable(attachedDatabase, alias);
  }
}

class MissionAttemptRow extends DataClass
    implements Insertable<MissionAttemptRow> {
  final String attemptId;
  final String? userId;
  final String? levelId;
  final double submittedAnswer;
  final bool isCorrect;
  final int attemptNumber;
  final int pointsAwarded;
  final int submittedAt;
  const MissionAttemptRow({
    required this.attemptId,
    this.userId,
    this.levelId,
    required this.submittedAnswer,
    required this.isCorrect,
    required this.attemptNumber,
    required this.pointsAwarded,
    required this.submittedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['attempt_id'] = Variable<String>(attemptId);
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    if (!nullToAbsent || levelId != null) {
      map['level_id'] = Variable<String>(levelId);
    }
    map['submitted_answer'] = Variable<double>(submittedAnswer);
    map['is_correct'] = Variable<bool>(isCorrect);
    map['attempt_number'] = Variable<int>(attemptNumber);
    map['points_awarded'] = Variable<int>(pointsAwarded);
    map['submitted_at'] = Variable<int>(submittedAt);
    return map;
  }

  MissionAttemptsCompanion toCompanion(bool nullToAbsent) {
    return MissionAttemptsCompanion(
      attemptId: Value(attemptId),
      userId: userId == null && nullToAbsent
          ? const Value.absent()
          : Value(userId),
      levelId: levelId == null && nullToAbsent
          ? const Value.absent()
          : Value(levelId),
      submittedAnswer: Value(submittedAnswer),
      isCorrect: Value(isCorrect),
      attemptNumber: Value(attemptNumber),
      pointsAwarded: Value(pointsAwarded),
      submittedAt: Value(submittedAt),
    );
  }

  factory MissionAttemptRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MissionAttemptRow(
      attemptId: serializer.fromJson<String>(json['attemptId']),
      userId: serializer.fromJson<String?>(json['userId']),
      levelId: serializer.fromJson<String?>(json['levelId']),
      submittedAnswer: serializer.fromJson<double>(json['submittedAnswer']),
      isCorrect: serializer.fromJson<bool>(json['isCorrect']),
      attemptNumber: serializer.fromJson<int>(json['attemptNumber']),
      pointsAwarded: serializer.fromJson<int>(json['pointsAwarded']),
      submittedAt: serializer.fromJson<int>(json['submittedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'attemptId': serializer.toJson<String>(attemptId),
      'userId': serializer.toJson<String?>(userId),
      'levelId': serializer.toJson<String?>(levelId),
      'submittedAnswer': serializer.toJson<double>(submittedAnswer),
      'isCorrect': serializer.toJson<bool>(isCorrect),
      'attemptNumber': serializer.toJson<int>(attemptNumber),
      'pointsAwarded': serializer.toJson<int>(pointsAwarded),
      'submittedAt': serializer.toJson<int>(submittedAt),
    };
  }

  MissionAttemptRow copyWith({
    String? attemptId,
    Value<String?> userId = const Value.absent(),
    Value<String?> levelId = const Value.absent(),
    double? submittedAnswer,
    bool? isCorrect,
    int? attemptNumber,
    int? pointsAwarded,
    int? submittedAt,
  }) => MissionAttemptRow(
    attemptId: attemptId ?? this.attemptId,
    userId: userId.present ? userId.value : this.userId,
    levelId: levelId.present ? levelId.value : this.levelId,
    submittedAnswer: submittedAnswer ?? this.submittedAnswer,
    isCorrect: isCorrect ?? this.isCorrect,
    attemptNumber: attemptNumber ?? this.attemptNumber,
    pointsAwarded: pointsAwarded ?? this.pointsAwarded,
    submittedAt: submittedAt ?? this.submittedAt,
  );
  MissionAttemptRow copyWithCompanion(MissionAttemptsCompanion data) {
    return MissionAttemptRow(
      attemptId: data.attemptId.present ? data.attemptId.value : this.attemptId,
      userId: data.userId.present ? data.userId.value : this.userId,
      levelId: data.levelId.present ? data.levelId.value : this.levelId,
      submittedAnswer: data.submittedAnswer.present
          ? data.submittedAnswer.value
          : this.submittedAnswer,
      isCorrect: data.isCorrect.present ? data.isCorrect.value : this.isCorrect,
      attemptNumber: data.attemptNumber.present
          ? data.attemptNumber.value
          : this.attemptNumber,
      pointsAwarded: data.pointsAwarded.present
          ? data.pointsAwarded.value
          : this.pointsAwarded,
      submittedAt: data.submittedAt.present
          ? data.submittedAt.value
          : this.submittedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MissionAttemptRow(')
          ..write('attemptId: $attemptId, ')
          ..write('userId: $userId, ')
          ..write('levelId: $levelId, ')
          ..write('submittedAnswer: $submittedAnswer, ')
          ..write('isCorrect: $isCorrect, ')
          ..write('attemptNumber: $attemptNumber, ')
          ..write('pointsAwarded: $pointsAwarded, ')
          ..write('submittedAt: $submittedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    attemptId,
    userId,
    levelId,
    submittedAnswer,
    isCorrect,
    attemptNumber,
    pointsAwarded,
    submittedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MissionAttemptRow &&
          other.attemptId == this.attemptId &&
          other.userId == this.userId &&
          other.levelId == this.levelId &&
          other.submittedAnswer == this.submittedAnswer &&
          other.isCorrect == this.isCorrect &&
          other.attemptNumber == this.attemptNumber &&
          other.pointsAwarded == this.pointsAwarded &&
          other.submittedAt == this.submittedAt);
}

class MissionAttemptsCompanion extends UpdateCompanion<MissionAttemptRow> {
  final Value<String> attemptId;
  final Value<String?> userId;
  final Value<String?> levelId;
  final Value<double> submittedAnswer;
  final Value<bool> isCorrect;
  final Value<int> attemptNumber;
  final Value<int> pointsAwarded;
  final Value<int> submittedAt;
  final Value<int> rowid;
  const MissionAttemptsCompanion({
    this.attemptId = const Value.absent(),
    this.userId = const Value.absent(),
    this.levelId = const Value.absent(),
    this.submittedAnswer = const Value.absent(),
    this.isCorrect = const Value.absent(),
    this.attemptNumber = const Value.absent(),
    this.pointsAwarded = const Value.absent(),
    this.submittedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MissionAttemptsCompanion.insert({
    required String attemptId,
    this.userId = const Value.absent(),
    this.levelId = const Value.absent(),
    required double submittedAnswer,
    required bool isCorrect,
    required int attemptNumber,
    this.pointsAwarded = const Value.absent(),
    required int submittedAt,
    this.rowid = const Value.absent(),
  }) : attemptId = Value(attemptId),
       submittedAnswer = Value(submittedAnswer),
       isCorrect = Value(isCorrect),
       attemptNumber = Value(attemptNumber),
       submittedAt = Value(submittedAt);
  static Insertable<MissionAttemptRow> custom({
    Expression<String>? attemptId,
    Expression<String>? userId,
    Expression<String>? levelId,
    Expression<double>? submittedAnswer,
    Expression<bool>? isCorrect,
    Expression<int>? attemptNumber,
    Expression<int>? pointsAwarded,
    Expression<int>? submittedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (attemptId != null) 'attempt_id': attemptId,
      if (userId != null) 'user_id': userId,
      if (levelId != null) 'level_id': levelId,
      if (submittedAnswer != null) 'submitted_answer': submittedAnswer,
      if (isCorrect != null) 'is_correct': isCorrect,
      if (attemptNumber != null) 'attempt_number': attemptNumber,
      if (pointsAwarded != null) 'points_awarded': pointsAwarded,
      if (submittedAt != null) 'submitted_at': submittedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MissionAttemptsCompanion copyWith({
    Value<String>? attemptId,
    Value<String?>? userId,
    Value<String?>? levelId,
    Value<double>? submittedAnswer,
    Value<bool>? isCorrect,
    Value<int>? attemptNumber,
    Value<int>? pointsAwarded,
    Value<int>? submittedAt,
    Value<int>? rowid,
  }) {
    return MissionAttemptsCompanion(
      attemptId: attemptId ?? this.attemptId,
      userId: userId ?? this.userId,
      levelId: levelId ?? this.levelId,
      submittedAnswer: submittedAnswer ?? this.submittedAnswer,
      isCorrect: isCorrect ?? this.isCorrect,
      attemptNumber: attemptNumber ?? this.attemptNumber,
      pointsAwarded: pointsAwarded ?? this.pointsAwarded,
      submittedAt: submittedAt ?? this.submittedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (attemptId.present) {
      map['attempt_id'] = Variable<String>(attemptId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (levelId.present) {
      map['level_id'] = Variable<String>(levelId.value);
    }
    if (submittedAnswer.present) {
      map['submitted_answer'] = Variable<double>(submittedAnswer.value);
    }
    if (isCorrect.present) {
      map['is_correct'] = Variable<bool>(isCorrect.value);
    }
    if (attemptNumber.present) {
      map['attempt_number'] = Variable<int>(attemptNumber.value);
    }
    if (pointsAwarded.present) {
      map['points_awarded'] = Variable<int>(pointsAwarded.value);
    }
    if (submittedAt.present) {
      map['submitted_at'] = Variable<int>(submittedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MissionAttemptsCompanion(')
          ..write('attemptId: $attemptId, ')
          ..write('userId: $userId, ')
          ..write('levelId: $levelId, ')
          ..write('submittedAnswer: $submittedAnswer, ')
          ..write('isCorrect: $isCorrect, ')
          ..write('attemptNumber: $attemptNumber, ')
          ..write('pointsAwarded: $pointsAwarded, ')
          ..write('submittedAt: $submittedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $QuizAttemptsTable extends QuizAttempts
    with TableInfo<$QuizAttemptsTable, QuizAttemptRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuizAttemptsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _attemptIdMeta = const VerificationMeta(
    'attemptId',
  );
  @override
  late final GeneratedColumn<String> attemptId = GeneratedColumn<String>(
    'attempt_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (user_id)',
    ),
  );
  static const VerificationMeta _packIdMeta = const VerificationMeta('packId');
  @override
  late final GeneratedColumn<String> packId = GeneratedColumn<String>(
    'pack_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES content_packs (pack_id)',
    ),
  );
  static const VerificationMeta _attemptTypeMeta = const VerificationMeta(
    'attemptType',
  );
  @override
  late final GeneratedColumn<String> attemptType = GeneratedColumn<String>(
    'attempt_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints:
        'CHECK (attempt_type IN (\'pretest\',\'posttest\',\'formative\'))',
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<int> startedAt = GeneratedColumn<int>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<int> completedAt = GeneratedColumn<int>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _totalScoreMeta = const VerificationMeta(
    'totalScore',
  );
  @override
  late final GeneratedColumn<double> totalScore = GeneratedColumn<double>(
    'total_score',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _maxScoreMeta = const VerificationMeta(
    'maxScore',
  );
  @override
  late final GeneratedColumn<double> maxScore = GeneratedColumn<double>(
    'max_score',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    attemptId,
    userId,
    packId,
    attemptType,
    startedAt,
    completedAt,
    totalScore,
    maxScore,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'quiz_attempts';
  @override
  VerificationContext validateIntegrity(
    Insertable<QuizAttemptRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('attempt_id')) {
      context.handle(
        _attemptIdMeta,
        attemptId.isAcceptableOrUnknown(data['attempt_id']!, _attemptIdMeta),
      );
    } else if (isInserting) {
      context.missing(_attemptIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    }
    if (data.containsKey('pack_id')) {
      context.handle(
        _packIdMeta,
        packId.isAcceptableOrUnknown(data['pack_id']!, _packIdMeta),
      );
    }
    if (data.containsKey('attempt_type')) {
      context.handle(
        _attemptTypeMeta,
        attemptType.isAcceptableOrUnknown(
          data['attempt_type']!,
          _attemptTypeMeta,
        ),
      );
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    if (data.containsKey('total_score')) {
      context.handle(
        _totalScoreMeta,
        totalScore.isAcceptableOrUnknown(data['total_score']!, _totalScoreMeta),
      );
    }
    if (data.containsKey('max_score')) {
      context.handle(
        _maxScoreMeta,
        maxScore.isAcceptableOrUnknown(data['max_score']!, _maxScoreMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {attemptId};
  @override
  QuizAttemptRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuizAttemptRow(
      attemptId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}attempt_id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      ),
      packId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pack_id'],
      ),
      attemptType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}attempt_type'],
      ),
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}started_at'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}completed_at'],
      ),
      totalScore: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_score'],
      ),
      maxScore: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}max_score'],
      ),
    );
  }

  @override
  $QuizAttemptsTable createAlias(String alias) {
    return $QuizAttemptsTable(attachedDatabase, alias);
  }
}

class QuizAttemptRow extends DataClass implements Insertable<QuizAttemptRow> {
  final String attemptId;
  final String? userId;
  final String? packId;
  final String? attemptType;
  final int startedAt;
  final int? completedAt;
  final double? totalScore;
  final double? maxScore;
  const QuizAttemptRow({
    required this.attemptId,
    this.userId,
    this.packId,
    this.attemptType,
    required this.startedAt,
    this.completedAt,
    this.totalScore,
    this.maxScore,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['attempt_id'] = Variable<String>(attemptId);
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    if (!nullToAbsent || packId != null) {
      map['pack_id'] = Variable<String>(packId);
    }
    if (!nullToAbsent || attemptType != null) {
      map['attempt_type'] = Variable<String>(attemptType);
    }
    map['started_at'] = Variable<int>(startedAt);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<int>(completedAt);
    }
    if (!nullToAbsent || totalScore != null) {
      map['total_score'] = Variable<double>(totalScore);
    }
    if (!nullToAbsent || maxScore != null) {
      map['max_score'] = Variable<double>(maxScore);
    }
    return map;
  }

  QuizAttemptsCompanion toCompanion(bool nullToAbsent) {
    return QuizAttemptsCompanion(
      attemptId: Value(attemptId),
      userId: userId == null && nullToAbsent
          ? const Value.absent()
          : Value(userId),
      packId: packId == null && nullToAbsent
          ? const Value.absent()
          : Value(packId),
      attemptType: attemptType == null && nullToAbsent
          ? const Value.absent()
          : Value(attemptType),
      startedAt: Value(startedAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      totalScore: totalScore == null && nullToAbsent
          ? const Value.absent()
          : Value(totalScore),
      maxScore: maxScore == null && nullToAbsent
          ? const Value.absent()
          : Value(maxScore),
    );
  }

  factory QuizAttemptRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuizAttemptRow(
      attemptId: serializer.fromJson<String>(json['attemptId']),
      userId: serializer.fromJson<String?>(json['userId']),
      packId: serializer.fromJson<String?>(json['packId']),
      attemptType: serializer.fromJson<String?>(json['attemptType']),
      startedAt: serializer.fromJson<int>(json['startedAt']),
      completedAt: serializer.fromJson<int?>(json['completedAt']),
      totalScore: serializer.fromJson<double?>(json['totalScore']),
      maxScore: serializer.fromJson<double?>(json['maxScore']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'attemptId': serializer.toJson<String>(attemptId),
      'userId': serializer.toJson<String?>(userId),
      'packId': serializer.toJson<String?>(packId),
      'attemptType': serializer.toJson<String?>(attemptType),
      'startedAt': serializer.toJson<int>(startedAt),
      'completedAt': serializer.toJson<int?>(completedAt),
      'totalScore': serializer.toJson<double?>(totalScore),
      'maxScore': serializer.toJson<double?>(maxScore),
    };
  }

  QuizAttemptRow copyWith({
    String? attemptId,
    Value<String?> userId = const Value.absent(),
    Value<String?> packId = const Value.absent(),
    Value<String?> attemptType = const Value.absent(),
    int? startedAt,
    Value<int?> completedAt = const Value.absent(),
    Value<double?> totalScore = const Value.absent(),
    Value<double?> maxScore = const Value.absent(),
  }) => QuizAttemptRow(
    attemptId: attemptId ?? this.attemptId,
    userId: userId.present ? userId.value : this.userId,
    packId: packId.present ? packId.value : this.packId,
    attemptType: attemptType.present ? attemptType.value : this.attemptType,
    startedAt: startedAt ?? this.startedAt,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    totalScore: totalScore.present ? totalScore.value : this.totalScore,
    maxScore: maxScore.present ? maxScore.value : this.maxScore,
  );
  QuizAttemptRow copyWithCompanion(QuizAttemptsCompanion data) {
    return QuizAttemptRow(
      attemptId: data.attemptId.present ? data.attemptId.value : this.attemptId,
      userId: data.userId.present ? data.userId.value : this.userId,
      packId: data.packId.present ? data.packId.value : this.packId,
      attemptType: data.attemptType.present
          ? data.attemptType.value
          : this.attemptType,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      totalScore: data.totalScore.present
          ? data.totalScore.value
          : this.totalScore,
      maxScore: data.maxScore.present ? data.maxScore.value : this.maxScore,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QuizAttemptRow(')
          ..write('attemptId: $attemptId, ')
          ..write('userId: $userId, ')
          ..write('packId: $packId, ')
          ..write('attemptType: $attemptType, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('totalScore: $totalScore, ')
          ..write('maxScore: $maxScore')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    attemptId,
    userId,
    packId,
    attemptType,
    startedAt,
    completedAt,
    totalScore,
    maxScore,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuizAttemptRow &&
          other.attemptId == this.attemptId &&
          other.userId == this.userId &&
          other.packId == this.packId &&
          other.attemptType == this.attemptType &&
          other.startedAt == this.startedAt &&
          other.completedAt == this.completedAt &&
          other.totalScore == this.totalScore &&
          other.maxScore == this.maxScore);
}

class QuizAttemptsCompanion extends UpdateCompanion<QuizAttemptRow> {
  final Value<String> attemptId;
  final Value<String?> userId;
  final Value<String?> packId;
  final Value<String?> attemptType;
  final Value<int> startedAt;
  final Value<int?> completedAt;
  final Value<double?> totalScore;
  final Value<double?> maxScore;
  final Value<int> rowid;
  const QuizAttemptsCompanion({
    this.attemptId = const Value.absent(),
    this.userId = const Value.absent(),
    this.packId = const Value.absent(),
    this.attemptType = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.totalScore = const Value.absent(),
    this.maxScore = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  QuizAttemptsCompanion.insert({
    required String attemptId,
    this.userId = const Value.absent(),
    this.packId = const Value.absent(),
    this.attemptType = const Value.absent(),
    required int startedAt,
    this.completedAt = const Value.absent(),
    this.totalScore = const Value.absent(),
    this.maxScore = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : attemptId = Value(attemptId),
       startedAt = Value(startedAt);
  static Insertable<QuizAttemptRow> custom({
    Expression<String>? attemptId,
    Expression<String>? userId,
    Expression<String>? packId,
    Expression<String>? attemptType,
    Expression<int>? startedAt,
    Expression<int>? completedAt,
    Expression<double>? totalScore,
    Expression<double>? maxScore,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (attemptId != null) 'attempt_id': attemptId,
      if (userId != null) 'user_id': userId,
      if (packId != null) 'pack_id': packId,
      if (attemptType != null) 'attempt_type': attemptType,
      if (startedAt != null) 'started_at': startedAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (totalScore != null) 'total_score': totalScore,
      if (maxScore != null) 'max_score': maxScore,
      if (rowid != null) 'rowid': rowid,
    });
  }

  QuizAttemptsCompanion copyWith({
    Value<String>? attemptId,
    Value<String?>? userId,
    Value<String?>? packId,
    Value<String?>? attemptType,
    Value<int>? startedAt,
    Value<int?>? completedAt,
    Value<double?>? totalScore,
    Value<double?>? maxScore,
    Value<int>? rowid,
  }) {
    return QuizAttemptsCompanion(
      attemptId: attemptId ?? this.attemptId,
      userId: userId ?? this.userId,
      packId: packId ?? this.packId,
      attemptType: attemptType ?? this.attemptType,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      totalScore: totalScore ?? this.totalScore,
      maxScore: maxScore ?? this.maxScore,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (attemptId.present) {
      map['attempt_id'] = Variable<String>(attemptId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (packId.present) {
      map['pack_id'] = Variable<String>(packId.value);
    }
    if (attemptType.present) {
      map['attempt_type'] = Variable<String>(attemptType.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<int>(startedAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<int>(completedAt.value);
    }
    if (totalScore.present) {
      map['total_score'] = Variable<double>(totalScore.value);
    }
    if (maxScore.present) {
      map['max_score'] = Variable<double>(maxScore.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuizAttemptsCompanion(')
          ..write('attemptId: $attemptId, ')
          ..write('userId: $userId, ')
          ..write('packId: $packId, ')
          ..write('attemptType: $attemptType, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('totalScore: $totalScore, ')
          ..write('maxScore: $maxScore, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $QuizItemResponsesTable extends QuizItemResponses
    with TableInfo<$QuizItemResponsesTable, QuizItemResponseRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuizItemResponsesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _responseIdMeta = const VerificationMeta(
    'responseId',
  );
  @override
  late final GeneratedColumn<String> responseId = GeneratedColumn<String>(
    'response_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _attemptIdMeta = const VerificationMeta(
    'attemptId',
  );
  @override
  late final GeneratedColumn<String> attemptId = GeneratedColumn<String>(
    'attempt_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES quiz_attempts (attempt_id)',
    ),
  );
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<String> itemId = GeneratedColumn<String>(
    'item_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES quiz_items (item_id)',
    ),
  );
  static const VerificationMeta _givenAnswerMeta = const VerificationMeta(
    'givenAnswer',
  );
  @override
  late final GeneratedColumn<String> givenAnswer = GeneratedColumn<String>(
    'given_answer',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isCorrectMeta = const VerificationMeta(
    'isCorrect',
  );
  @override
  late final GeneratedColumn<bool> isCorrect = GeneratedColumn<bool>(
    'is_correct',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_correct" IN (0, 1))',
    ),
  );
  static const VerificationMeta _timeSpentMsMeta = const VerificationMeta(
    'timeSpentMs',
  );
  @override
  late final GeneratedColumn<int> timeSpentMs = GeneratedColumn<int>(
    'time_spent_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _answeredAtMeta = const VerificationMeta(
    'answeredAt',
  );
  @override
  late final GeneratedColumn<int> answeredAt = GeneratedColumn<int>(
    'answered_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    responseId,
    attemptId,
    itemId,
    givenAnswer,
    isCorrect,
    timeSpentMs,
    answeredAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'quiz_item_responses';
  @override
  VerificationContext validateIntegrity(
    Insertable<QuizItemResponseRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('response_id')) {
      context.handle(
        _responseIdMeta,
        responseId.isAcceptableOrUnknown(data['response_id']!, _responseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_responseIdMeta);
    }
    if (data.containsKey('attempt_id')) {
      context.handle(
        _attemptIdMeta,
        attemptId.isAcceptableOrUnknown(data['attempt_id']!, _attemptIdMeta),
      );
    }
    if (data.containsKey('item_id')) {
      context.handle(
        _itemIdMeta,
        itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta),
      );
    }
    if (data.containsKey('given_answer')) {
      context.handle(
        _givenAnswerMeta,
        givenAnswer.isAcceptableOrUnknown(
          data['given_answer']!,
          _givenAnswerMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_givenAnswerMeta);
    }
    if (data.containsKey('is_correct')) {
      context.handle(
        _isCorrectMeta,
        isCorrect.isAcceptableOrUnknown(data['is_correct']!, _isCorrectMeta),
      );
    } else if (isInserting) {
      context.missing(_isCorrectMeta);
    }
    if (data.containsKey('time_spent_ms')) {
      context.handle(
        _timeSpentMsMeta,
        timeSpentMs.isAcceptableOrUnknown(
          data['time_spent_ms']!,
          _timeSpentMsMeta,
        ),
      );
    }
    if (data.containsKey('answered_at')) {
      context.handle(
        _answeredAtMeta,
        answeredAt.isAcceptableOrUnknown(data['answered_at']!, _answeredAtMeta),
      );
    } else if (isInserting) {
      context.missing(_answeredAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {responseId};
  @override
  QuizItemResponseRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuizItemResponseRow(
      responseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}response_id'],
      )!,
      attemptId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}attempt_id'],
      ),
      itemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item_id'],
      ),
      givenAnswer: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}given_answer'],
      )!,
      isCorrect: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_correct'],
      )!,
      timeSpentMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}time_spent_ms'],
      ),
      answeredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}answered_at'],
      )!,
    );
  }

  @override
  $QuizItemResponsesTable createAlias(String alias) {
    return $QuizItemResponsesTable(attachedDatabase, alias);
  }
}

class QuizItemResponseRow extends DataClass
    implements Insertable<QuizItemResponseRow> {
  final String responseId;
  final String? attemptId;
  final String? itemId;
  final String givenAnswer;
  final bool isCorrect;
  final int? timeSpentMs;
  final int answeredAt;
  const QuizItemResponseRow({
    required this.responseId,
    this.attemptId,
    this.itemId,
    required this.givenAnswer,
    required this.isCorrect,
    this.timeSpentMs,
    required this.answeredAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['response_id'] = Variable<String>(responseId);
    if (!nullToAbsent || attemptId != null) {
      map['attempt_id'] = Variable<String>(attemptId);
    }
    if (!nullToAbsent || itemId != null) {
      map['item_id'] = Variable<String>(itemId);
    }
    map['given_answer'] = Variable<String>(givenAnswer);
    map['is_correct'] = Variable<bool>(isCorrect);
    if (!nullToAbsent || timeSpentMs != null) {
      map['time_spent_ms'] = Variable<int>(timeSpentMs);
    }
    map['answered_at'] = Variable<int>(answeredAt);
    return map;
  }

  QuizItemResponsesCompanion toCompanion(bool nullToAbsent) {
    return QuizItemResponsesCompanion(
      responseId: Value(responseId),
      attemptId: attemptId == null && nullToAbsent
          ? const Value.absent()
          : Value(attemptId),
      itemId: itemId == null && nullToAbsent
          ? const Value.absent()
          : Value(itemId),
      givenAnswer: Value(givenAnswer),
      isCorrect: Value(isCorrect),
      timeSpentMs: timeSpentMs == null && nullToAbsent
          ? const Value.absent()
          : Value(timeSpentMs),
      answeredAt: Value(answeredAt),
    );
  }

  factory QuizItemResponseRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuizItemResponseRow(
      responseId: serializer.fromJson<String>(json['responseId']),
      attemptId: serializer.fromJson<String?>(json['attemptId']),
      itemId: serializer.fromJson<String?>(json['itemId']),
      givenAnswer: serializer.fromJson<String>(json['givenAnswer']),
      isCorrect: serializer.fromJson<bool>(json['isCorrect']),
      timeSpentMs: serializer.fromJson<int?>(json['timeSpentMs']),
      answeredAt: serializer.fromJson<int>(json['answeredAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'responseId': serializer.toJson<String>(responseId),
      'attemptId': serializer.toJson<String?>(attemptId),
      'itemId': serializer.toJson<String?>(itemId),
      'givenAnswer': serializer.toJson<String>(givenAnswer),
      'isCorrect': serializer.toJson<bool>(isCorrect),
      'timeSpentMs': serializer.toJson<int?>(timeSpentMs),
      'answeredAt': serializer.toJson<int>(answeredAt),
    };
  }

  QuizItemResponseRow copyWith({
    String? responseId,
    Value<String?> attemptId = const Value.absent(),
    Value<String?> itemId = const Value.absent(),
    String? givenAnswer,
    bool? isCorrect,
    Value<int?> timeSpentMs = const Value.absent(),
    int? answeredAt,
  }) => QuizItemResponseRow(
    responseId: responseId ?? this.responseId,
    attemptId: attemptId.present ? attemptId.value : this.attemptId,
    itemId: itemId.present ? itemId.value : this.itemId,
    givenAnswer: givenAnswer ?? this.givenAnswer,
    isCorrect: isCorrect ?? this.isCorrect,
    timeSpentMs: timeSpentMs.present ? timeSpentMs.value : this.timeSpentMs,
    answeredAt: answeredAt ?? this.answeredAt,
  );
  QuizItemResponseRow copyWithCompanion(QuizItemResponsesCompanion data) {
    return QuizItemResponseRow(
      responseId: data.responseId.present
          ? data.responseId.value
          : this.responseId,
      attemptId: data.attemptId.present ? data.attemptId.value : this.attemptId,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      givenAnswer: data.givenAnswer.present
          ? data.givenAnswer.value
          : this.givenAnswer,
      isCorrect: data.isCorrect.present ? data.isCorrect.value : this.isCorrect,
      timeSpentMs: data.timeSpentMs.present
          ? data.timeSpentMs.value
          : this.timeSpentMs,
      answeredAt: data.answeredAt.present
          ? data.answeredAt.value
          : this.answeredAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QuizItemResponseRow(')
          ..write('responseId: $responseId, ')
          ..write('attemptId: $attemptId, ')
          ..write('itemId: $itemId, ')
          ..write('givenAnswer: $givenAnswer, ')
          ..write('isCorrect: $isCorrect, ')
          ..write('timeSpentMs: $timeSpentMs, ')
          ..write('answeredAt: $answeredAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    responseId,
    attemptId,
    itemId,
    givenAnswer,
    isCorrect,
    timeSpentMs,
    answeredAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuizItemResponseRow &&
          other.responseId == this.responseId &&
          other.attemptId == this.attemptId &&
          other.itemId == this.itemId &&
          other.givenAnswer == this.givenAnswer &&
          other.isCorrect == this.isCorrect &&
          other.timeSpentMs == this.timeSpentMs &&
          other.answeredAt == this.answeredAt);
}

class QuizItemResponsesCompanion extends UpdateCompanion<QuizItemResponseRow> {
  final Value<String> responseId;
  final Value<String?> attemptId;
  final Value<String?> itemId;
  final Value<String> givenAnswer;
  final Value<bool> isCorrect;
  final Value<int?> timeSpentMs;
  final Value<int> answeredAt;
  final Value<int> rowid;
  const QuizItemResponsesCompanion({
    this.responseId = const Value.absent(),
    this.attemptId = const Value.absent(),
    this.itemId = const Value.absent(),
    this.givenAnswer = const Value.absent(),
    this.isCorrect = const Value.absent(),
    this.timeSpentMs = const Value.absent(),
    this.answeredAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  QuizItemResponsesCompanion.insert({
    required String responseId,
    this.attemptId = const Value.absent(),
    this.itemId = const Value.absent(),
    required String givenAnswer,
    required bool isCorrect,
    this.timeSpentMs = const Value.absent(),
    required int answeredAt,
    this.rowid = const Value.absent(),
  }) : responseId = Value(responseId),
       givenAnswer = Value(givenAnswer),
       isCorrect = Value(isCorrect),
       answeredAt = Value(answeredAt);
  static Insertable<QuizItemResponseRow> custom({
    Expression<String>? responseId,
    Expression<String>? attemptId,
    Expression<String>? itemId,
    Expression<String>? givenAnswer,
    Expression<bool>? isCorrect,
    Expression<int>? timeSpentMs,
    Expression<int>? answeredAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (responseId != null) 'response_id': responseId,
      if (attemptId != null) 'attempt_id': attemptId,
      if (itemId != null) 'item_id': itemId,
      if (givenAnswer != null) 'given_answer': givenAnswer,
      if (isCorrect != null) 'is_correct': isCorrect,
      if (timeSpentMs != null) 'time_spent_ms': timeSpentMs,
      if (answeredAt != null) 'answered_at': answeredAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  QuizItemResponsesCompanion copyWith({
    Value<String>? responseId,
    Value<String?>? attemptId,
    Value<String?>? itemId,
    Value<String>? givenAnswer,
    Value<bool>? isCorrect,
    Value<int?>? timeSpentMs,
    Value<int>? answeredAt,
    Value<int>? rowid,
  }) {
    return QuizItemResponsesCompanion(
      responseId: responseId ?? this.responseId,
      attemptId: attemptId ?? this.attemptId,
      itemId: itemId ?? this.itemId,
      givenAnswer: givenAnswer ?? this.givenAnswer,
      isCorrect: isCorrect ?? this.isCorrect,
      timeSpentMs: timeSpentMs ?? this.timeSpentMs,
      answeredAt: answeredAt ?? this.answeredAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (responseId.present) {
      map['response_id'] = Variable<String>(responseId.value);
    }
    if (attemptId.present) {
      map['attempt_id'] = Variable<String>(attemptId.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<String>(itemId.value);
    }
    if (givenAnswer.present) {
      map['given_answer'] = Variable<String>(givenAnswer.value);
    }
    if (isCorrect.present) {
      map['is_correct'] = Variable<bool>(isCorrect.value);
    }
    if (timeSpentMs.present) {
      map['time_spent_ms'] = Variable<int>(timeSpentMs.value);
    }
    if (answeredAt.present) {
      map['answered_at'] = Variable<int>(answeredAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuizItemResponsesCompanion(')
          ..write('responseId: $responseId, ')
          ..write('attemptId: $attemptId, ')
          ..write('itemId: $itemId, ')
          ..write('givenAnswer: $givenAnswer, ')
          ..write('isCorrect: $isCorrect, ')
          ..write('timeSpentMs: $timeSpentMs, ')
          ..write('answeredAt: $answeredAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BadgesTable extends Badges with TableInfo<$BadgesTable, BadgeRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BadgesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _badgeIdMeta = const VerificationMeta(
    'badgeId',
  );
  @override
  late final GeneratedColumn<String> badgeId = GeneratedColumn<String>(
    'badge_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _badgeNameMeta = const VerificationMeta(
    'badgeName',
  );
  @override
  late final GeneratedColumn<String> badgeName = GeneratedColumn<String>(
    'badge_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconAssetMeta = const VerificationMeta(
    'iconAsset',
  );
  @override
  late final GeneratedColumn<String> iconAsset = GeneratedColumn<String>(
    'icon_asset',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unlockRuleJsonMeta = const VerificationMeta(
    'unlockRuleJson',
  );
  @override
  late final GeneratedColumn<String> unlockRuleJson = GeneratedColumn<String>(
    'unlock_rule_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    badgeId,
    badgeName,
    description,
    iconAsset,
    unlockRuleJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'badges';
  @override
  VerificationContext validateIntegrity(
    Insertable<BadgeRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('badge_id')) {
      context.handle(
        _badgeIdMeta,
        badgeId.isAcceptableOrUnknown(data['badge_id']!, _badgeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_badgeIdMeta);
    }
    if (data.containsKey('badge_name')) {
      context.handle(
        _badgeNameMeta,
        badgeName.isAcceptableOrUnknown(data['badge_name']!, _badgeNameMeta),
      );
    } else if (isInserting) {
      context.missing(_badgeNameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('icon_asset')) {
      context.handle(
        _iconAssetMeta,
        iconAsset.isAcceptableOrUnknown(data['icon_asset']!, _iconAssetMeta),
      );
    } else if (isInserting) {
      context.missing(_iconAssetMeta);
    }
    if (data.containsKey('unlock_rule_json')) {
      context.handle(
        _unlockRuleJsonMeta,
        unlockRuleJson.isAcceptableOrUnknown(
          data['unlock_rule_json']!,
          _unlockRuleJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_unlockRuleJsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {badgeId};
  @override
  BadgeRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BadgeRow(
      badgeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}badge_id'],
      )!,
      badgeName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}badge_name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      iconAsset: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon_asset'],
      )!,
      unlockRuleJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unlock_rule_json'],
      )!,
    );
  }

  @override
  $BadgesTable createAlias(String alias) {
    return $BadgesTable(attachedDatabase, alias);
  }
}

class BadgeRow extends DataClass implements Insertable<BadgeRow> {
  final String badgeId;
  final String badgeName;
  final String description;
  final String iconAsset;
  final String unlockRuleJson;
  const BadgeRow({
    required this.badgeId,
    required this.badgeName,
    required this.description,
    required this.iconAsset,
    required this.unlockRuleJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['badge_id'] = Variable<String>(badgeId);
    map['badge_name'] = Variable<String>(badgeName);
    map['description'] = Variable<String>(description);
    map['icon_asset'] = Variable<String>(iconAsset);
    map['unlock_rule_json'] = Variable<String>(unlockRuleJson);
    return map;
  }

  BadgesCompanion toCompanion(bool nullToAbsent) {
    return BadgesCompanion(
      badgeId: Value(badgeId),
      badgeName: Value(badgeName),
      description: Value(description),
      iconAsset: Value(iconAsset),
      unlockRuleJson: Value(unlockRuleJson),
    );
  }

  factory BadgeRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BadgeRow(
      badgeId: serializer.fromJson<String>(json['badgeId']),
      badgeName: serializer.fromJson<String>(json['badgeName']),
      description: serializer.fromJson<String>(json['description']),
      iconAsset: serializer.fromJson<String>(json['iconAsset']),
      unlockRuleJson: serializer.fromJson<String>(json['unlockRuleJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'badgeId': serializer.toJson<String>(badgeId),
      'badgeName': serializer.toJson<String>(badgeName),
      'description': serializer.toJson<String>(description),
      'iconAsset': serializer.toJson<String>(iconAsset),
      'unlockRuleJson': serializer.toJson<String>(unlockRuleJson),
    };
  }

  BadgeRow copyWith({
    String? badgeId,
    String? badgeName,
    String? description,
    String? iconAsset,
    String? unlockRuleJson,
  }) => BadgeRow(
    badgeId: badgeId ?? this.badgeId,
    badgeName: badgeName ?? this.badgeName,
    description: description ?? this.description,
    iconAsset: iconAsset ?? this.iconAsset,
    unlockRuleJson: unlockRuleJson ?? this.unlockRuleJson,
  );
  BadgeRow copyWithCompanion(BadgesCompanion data) {
    return BadgeRow(
      badgeId: data.badgeId.present ? data.badgeId.value : this.badgeId,
      badgeName: data.badgeName.present ? data.badgeName.value : this.badgeName,
      description: data.description.present
          ? data.description.value
          : this.description,
      iconAsset: data.iconAsset.present ? data.iconAsset.value : this.iconAsset,
      unlockRuleJson: data.unlockRuleJson.present
          ? data.unlockRuleJson.value
          : this.unlockRuleJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BadgeRow(')
          ..write('badgeId: $badgeId, ')
          ..write('badgeName: $badgeName, ')
          ..write('description: $description, ')
          ..write('iconAsset: $iconAsset, ')
          ..write('unlockRuleJson: $unlockRuleJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(badgeId, badgeName, description, iconAsset, unlockRuleJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BadgeRow &&
          other.badgeId == this.badgeId &&
          other.badgeName == this.badgeName &&
          other.description == this.description &&
          other.iconAsset == this.iconAsset &&
          other.unlockRuleJson == this.unlockRuleJson);
}

class BadgesCompanion extends UpdateCompanion<BadgeRow> {
  final Value<String> badgeId;
  final Value<String> badgeName;
  final Value<String> description;
  final Value<String> iconAsset;
  final Value<String> unlockRuleJson;
  final Value<int> rowid;
  const BadgesCompanion({
    this.badgeId = const Value.absent(),
    this.badgeName = const Value.absent(),
    this.description = const Value.absent(),
    this.iconAsset = const Value.absent(),
    this.unlockRuleJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BadgesCompanion.insert({
    required String badgeId,
    required String badgeName,
    required String description,
    required String iconAsset,
    required String unlockRuleJson,
    this.rowid = const Value.absent(),
  }) : badgeId = Value(badgeId),
       badgeName = Value(badgeName),
       description = Value(description),
       iconAsset = Value(iconAsset),
       unlockRuleJson = Value(unlockRuleJson);
  static Insertable<BadgeRow> custom({
    Expression<String>? badgeId,
    Expression<String>? badgeName,
    Expression<String>? description,
    Expression<String>? iconAsset,
    Expression<String>? unlockRuleJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (badgeId != null) 'badge_id': badgeId,
      if (badgeName != null) 'badge_name': badgeName,
      if (description != null) 'description': description,
      if (iconAsset != null) 'icon_asset': iconAsset,
      if (unlockRuleJson != null) 'unlock_rule_json': unlockRuleJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BadgesCompanion copyWith({
    Value<String>? badgeId,
    Value<String>? badgeName,
    Value<String>? description,
    Value<String>? iconAsset,
    Value<String>? unlockRuleJson,
    Value<int>? rowid,
  }) {
    return BadgesCompanion(
      badgeId: badgeId ?? this.badgeId,
      badgeName: badgeName ?? this.badgeName,
      description: description ?? this.description,
      iconAsset: iconAsset ?? this.iconAsset,
      unlockRuleJson: unlockRuleJson ?? this.unlockRuleJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (badgeId.present) {
      map['badge_id'] = Variable<String>(badgeId.value);
    }
    if (badgeName.present) {
      map['badge_name'] = Variable<String>(badgeName.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (iconAsset.present) {
      map['icon_asset'] = Variable<String>(iconAsset.value);
    }
    if (unlockRuleJson.present) {
      map['unlock_rule_json'] = Variable<String>(unlockRuleJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BadgesCompanion(')
          ..write('badgeId: $badgeId, ')
          ..write('badgeName: $badgeName, ')
          ..write('description: $description, ')
          ..write('iconAsset: $iconAsset, ')
          ..write('unlockRuleJson: $unlockRuleJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BadgesEarnedTable extends BadgesEarned
    with TableInfo<$BadgesEarnedTable, BadgeEarnedRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BadgesEarnedTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (user_id)',
    ),
  );
  static const VerificationMeta _badgeIdMeta = const VerificationMeta(
    'badgeId',
  );
  @override
  late final GeneratedColumn<String> badgeId = GeneratedColumn<String>(
    'badge_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES badges (badge_id)',
    ),
  );
  static const VerificationMeta _earnedAtMeta = const VerificationMeta(
    'earnedAt',
  );
  @override
  late final GeneratedColumn<int> earnedAt = GeneratedColumn<int>(
    'earned_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [userId, badgeId, earnedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'badges_earned';
  @override
  VerificationContext validateIntegrity(
    Insertable<BadgeEarnedRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('badge_id')) {
      context.handle(
        _badgeIdMeta,
        badgeId.isAcceptableOrUnknown(data['badge_id']!, _badgeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_badgeIdMeta);
    }
    if (data.containsKey('earned_at')) {
      context.handle(
        _earnedAtMeta,
        earnedAt.isAcceptableOrUnknown(data['earned_at']!, _earnedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_earnedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId, badgeId};
  @override
  BadgeEarnedRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BadgeEarnedRow(
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      badgeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}badge_id'],
      )!,
      earnedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}earned_at'],
      )!,
    );
  }

  @override
  $BadgesEarnedTable createAlias(String alias) {
    return $BadgesEarnedTable(attachedDatabase, alias);
  }
}

class BadgeEarnedRow extends DataClass implements Insertable<BadgeEarnedRow> {
  final String userId;
  final String badgeId;
  final int earnedAt;
  const BadgeEarnedRow({
    required this.userId,
    required this.badgeId,
    required this.earnedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    map['badge_id'] = Variable<String>(badgeId);
    map['earned_at'] = Variable<int>(earnedAt);
    return map;
  }

  BadgesEarnedCompanion toCompanion(bool nullToAbsent) {
    return BadgesEarnedCompanion(
      userId: Value(userId),
      badgeId: Value(badgeId),
      earnedAt: Value(earnedAt),
    );
  }

  factory BadgeEarnedRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BadgeEarnedRow(
      userId: serializer.fromJson<String>(json['userId']),
      badgeId: serializer.fromJson<String>(json['badgeId']),
      earnedAt: serializer.fromJson<int>(json['earnedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<String>(userId),
      'badgeId': serializer.toJson<String>(badgeId),
      'earnedAt': serializer.toJson<int>(earnedAt),
    };
  }

  BadgeEarnedRow copyWith({String? userId, String? badgeId, int? earnedAt}) =>
      BadgeEarnedRow(
        userId: userId ?? this.userId,
        badgeId: badgeId ?? this.badgeId,
        earnedAt: earnedAt ?? this.earnedAt,
      );
  BadgeEarnedRow copyWithCompanion(BadgesEarnedCompanion data) {
    return BadgeEarnedRow(
      userId: data.userId.present ? data.userId.value : this.userId,
      badgeId: data.badgeId.present ? data.badgeId.value : this.badgeId,
      earnedAt: data.earnedAt.present ? data.earnedAt.value : this.earnedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BadgeEarnedRow(')
          ..write('userId: $userId, ')
          ..write('badgeId: $badgeId, ')
          ..write('earnedAt: $earnedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(userId, badgeId, earnedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BadgeEarnedRow &&
          other.userId == this.userId &&
          other.badgeId == this.badgeId &&
          other.earnedAt == this.earnedAt);
}

class BadgesEarnedCompanion extends UpdateCompanion<BadgeEarnedRow> {
  final Value<String> userId;
  final Value<String> badgeId;
  final Value<int> earnedAt;
  final Value<int> rowid;
  const BadgesEarnedCompanion({
    this.userId = const Value.absent(),
    this.badgeId = const Value.absent(),
    this.earnedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BadgesEarnedCompanion.insert({
    required String userId,
    required String badgeId,
    required int earnedAt,
    this.rowid = const Value.absent(),
  }) : userId = Value(userId),
       badgeId = Value(badgeId),
       earnedAt = Value(earnedAt);
  static Insertable<BadgeEarnedRow> custom({
    Expression<String>? userId,
    Expression<String>? badgeId,
    Expression<int>? earnedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (badgeId != null) 'badge_id': badgeId,
      if (earnedAt != null) 'earned_at': earnedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BadgesEarnedCompanion copyWith({
    Value<String>? userId,
    Value<String>? badgeId,
    Value<int>? earnedAt,
    Value<int>? rowid,
  }) {
    return BadgesEarnedCompanion(
      userId: userId ?? this.userId,
      badgeId: badgeId ?? this.badgeId,
      earnedAt: earnedAt ?? this.earnedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (badgeId.present) {
      map['badge_id'] = Variable<String>(badgeId.value);
    }
    if (earnedAt.present) {
      map['earned_at'] = Variable<int>(earnedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BadgesEarnedCompanion(')
          ..write('userId: $userId, ')
          ..write('badgeId: $badgeId, ')
          ..write('earnedAt: $earnedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PointsLedgerTable extends PointsLedger
    with TableInfo<$PointsLedgerTable, PointsLedgerRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PointsLedgerTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _entryIdMeta = const VerificationMeta(
    'entryId',
  );
  @override
  late final GeneratedColumn<String> entryId = GeneratedColumn<String>(
    'entry_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (user_id)',
    ),
  );
  static const VerificationMeta _sourceTypeMeta = const VerificationMeta(
    'sourceType',
  );
  @override
  late final GeneratedColumn<String> sourceType = GeneratedColumn<String>(
    'source_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceIdMeta = const VerificationMeta(
    'sourceId',
  );
  @override
  late final GeneratedColumn<String> sourceId = GeneratedColumn<String>(
    'source_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pointsMeta = const VerificationMeta('points');
  @override
  late final GeneratedColumn<int> points = GeneratedColumn<int>(
    'points',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    entryId,
    userId,
    sourceType,
    sourceId,
    points,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'points_ledger';
  @override
  VerificationContext validateIntegrity(
    Insertable<PointsLedgerRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('entry_id')) {
      context.handle(
        _entryIdMeta,
        entryId.isAcceptableOrUnknown(data['entry_id']!, _entryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entryIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    }
    if (data.containsKey('source_type')) {
      context.handle(
        _sourceTypeMeta,
        sourceType.isAcceptableOrUnknown(data['source_type']!, _sourceTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceTypeMeta);
    }
    if (data.containsKey('source_id')) {
      context.handle(
        _sourceIdMeta,
        sourceId.isAcceptableOrUnknown(data['source_id']!, _sourceIdMeta),
      );
    }
    if (data.containsKey('points')) {
      context.handle(
        _pointsMeta,
        points.isAcceptableOrUnknown(data['points']!, _pointsMeta),
      );
    } else if (isInserting) {
      context.missing(_pointsMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {entryId};
  @override
  PointsLedgerRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PointsLedgerRow(
      entryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entry_id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      ),
      sourceType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_type'],
      )!,
      sourceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_id'],
      ),
      points: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}points'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $PointsLedgerTable createAlias(String alias) {
    return $PointsLedgerTable(attachedDatabase, alias);
  }
}

class PointsLedgerRow extends DataClass implements Insertable<PointsLedgerRow> {
  final String entryId;
  final String? userId;
  final String sourceType;
  final String? sourceId;
  final int points;
  final int createdAt;
  const PointsLedgerRow({
    required this.entryId,
    this.userId,
    required this.sourceType,
    this.sourceId,
    required this.points,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['entry_id'] = Variable<String>(entryId);
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    map['source_type'] = Variable<String>(sourceType);
    if (!nullToAbsent || sourceId != null) {
      map['source_id'] = Variable<String>(sourceId);
    }
    map['points'] = Variable<int>(points);
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  PointsLedgerCompanion toCompanion(bool nullToAbsent) {
    return PointsLedgerCompanion(
      entryId: Value(entryId),
      userId: userId == null && nullToAbsent
          ? const Value.absent()
          : Value(userId),
      sourceType: Value(sourceType),
      sourceId: sourceId == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceId),
      points: Value(points),
      createdAt: Value(createdAt),
    );
  }

  factory PointsLedgerRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PointsLedgerRow(
      entryId: serializer.fromJson<String>(json['entryId']),
      userId: serializer.fromJson<String?>(json['userId']),
      sourceType: serializer.fromJson<String>(json['sourceType']),
      sourceId: serializer.fromJson<String?>(json['sourceId']),
      points: serializer.fromJson<int>(json['points']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'entryId': serializer.toJson<String>(entryId),
      'userId': serializer.toJson<String?>(userId),
      'sourceType': serializer.toJson<String>(sourceType),
      'sourceId': serializer.toJson<String?>(sourceId),
      'points': serializer.toJson<int>(points),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  PointsLedgerRow copyWith({
    String? entryId,
    Value<String?> userId = const Value.absent(),
    String? sourceType,
    Value<String?> sourceId = const Value.absent(),
    int? points,
    int? createdAt,
  }) => PointsLedgerRow(
    entryId: entryId ?? this.entryId,
    userId: userId.present ? userId.value : this.userId,
    sourceType: sourceType ?? this.sourceType,
    sourceId: sourceId.present ? sourceId.value : this.sourceId,
    points: points ?? this.points,
    createdAt: createdAt ?? this.createdAt,
  );
  PointsLedgerRow copyWithCompanion(PointsLedgerCompanion data) {
    return PointsLedgerRow(
      entryId: data.entryId.present ? data.entryId.value : this.entryId,
      userId: data.userId.present ? data.userId.value : this.userId,
      sourceType: data.sourceType.present
          ? data.sourceType.value
          : this.sourceType,
      sourceId: data.sourceId.present ? data.sourceId.value : this.sourceId,
      points: data.points.present ? data.points.value : this.points,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PointsLedgerRow(')
          ..write('entryId: $entryId, ')
          ..write('userId: $userId, ')
          ..write('sourceType: $sourceType, ')
          ..write('sourceId: $sourceId, ')
          ..write('points: $points, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(entryId, userId, sourceType, sourceId, points, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PointsLedgerRow &&
          other.entryId == this.entryId &&
          other.userId == this.userId &&
          other.sourceType == this.sourceType &&
          other.sourceId == this.sourceId &&
          other.points == this.points &&
          other.createdAt == this.createdAt);
}

class PointsLedgerCompanion extends UpdateCompanion<PointsLedgerRow> {
  final Value<String> entryId;
  final Value<String?> userId;
  final Value<String> sourceType;
  final Value<String?> sourceId;
  final Value<int> points;
  final Value<int> createdAt;
  final Value<int> rowid;
  const PointsLedgerCompanion({
    this.entryId = const Value.absent(),
    this.userId = const Value.absent(),
    this.sourceType = const Value.absent(),
    this.sourceId = const Value.absent(),
    this.points = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PointsLedgerCompanion.insert({
    required String entryId,
    this.userId = const Value.absent(),
    required String sourceType,
    this.sourceId = const Value.absent(),
    required int points,
    required int createdAt,
    this.rowid = const Value.absent(),
  }) : entryId = Value(entryId),
       sourceType = Value(sourceType),
       points = Value(points),
       createdAt = Value(createdAt);
  static Insertable<PointsLedgerRow> custom({
    Expression<String>? entryId,
    Expression<String>? userId,
    Expression<String>? sourceType,
    Expression<String>? sourceId,
    Expression<int>? points,
    Expression<int>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (entryId != null) 'entry_id': entryId,
      if (userId != null) 'user_id': userId,
      if (sourceType != null) 'source_type': sourceType,
      if (sourceId != null) 'source_id': sourceId,
      if (points != null) 'points': points,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PointsLedgerCompanion copyWith({
    Value<String>? entryId,
    Value<String?>? userId,
    Value<String>? sourceType,
    Value<String?>? sourceId,
    Value<int>? points,
    Value<int>? createdAt,
    Value<int>? rowid,
  }) {
    return PointsLedgerCompanion(
      entryId: entryId ?? this.entryId,
      userId: userId ?? this.userId,
      sourceType: sourceType ?? this.sourceType,
      sourceId: sourceId ?? this.sourceId,
      points: points ?? this.points,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (entryId.present) {
      map['entry_id'] = Variable<String>(entryId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (sourceType.present) {
      map['source_type'] = Variable<String>(sourceType.value);
    }
    if (sourceId.present) {
      map['source_id'] = Variable<String>(sourceId.value);
    }
    if (points.present) {
      map['points'] = Variable<int>(points.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PointsLedgerCompanion(')
          ..write('entryId: $entryId, ')
          ..write('userId: $userId, ')
          ..write('sourceType: $sourceType, ')
          ..write('sourceId: $sourceId, ')
          ..write('points: $points, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExportBundlesTable extends ExportBundles
    with TableInfo<$ExportBundlesTable, ExportBundleRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExportBundlesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _bundleIdMeta = const VerificationMeta(
    'bundleId',
  );
  @override
  late final GeneratedColumn<String> bundleId = GeneratedColumn<String>(
    'bundle_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (user_id)',
    ),
  );
  static const VerificationMeta _generatedAtMeta = const VerificationMeta(
    'generatedAt',
  );
  @override
  late final GeneratedColumn<int> generatedAt = GeneratedColumn<int>(
    'generated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'payload_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _importedByTeacherIdMeta =
      const VerificationMeta('importedByTeacherId');
  @override
  late final GeneratedColumn<String> importedByTeacherId =
      GeneratedColumn<String>(
        'imported_by_teacher_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _importedAtMeta = const VerificationMeta(
    'importedAt',
  );
  @override
  late final GeneratedColumn<int> importedAt = GeneratedColumn<int>(
    'imported_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    bundleId,
    userId,
    generatedAt,
    payloadJson,
    importedByTeacherId,
    importedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'export_bundles';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExportBundleRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('bundle_id')) {
      context.handle(
        _bundleIdMeta,
        bundleId.isAcceptableOrUnknown(data['bundle_id']!, _bundleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_bundleIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    }
    if (data.containsKey('generated_at')) {
      context.handle(
        _generatedAtMeta,
        generatedAt.isAcceptableOrUnknown(
          data['generated_at']!,
          _generatedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_generatedAtMeta);
    }
    if (data.containsKey('payload_json')) {
      context.handle(
        _payloadJsonMeta,
        payloadJson.isAcceptableOrUnknown(
          data['payload_json']!,
          _payloadJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    if (data.containsKey('imported_by_teacher_id')) {
      context.handle(
        _importedByTeacherIdMeta,
        importedByTeacherId.isAcceptableOrUnknown(
          data['imported_by_teacher_id']!,
          _importedByTeacherIdMeta,
        ),
      );
    }
    if (data.containsKey('imported_at')) {
      context.handle(
        _importedAtMeta,
        importedAt.isAcceptableOrUnknown(data['imported_at']!, _importedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {bundleId};
  @override
  ExportBundleRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExportBundleRow(
      bundleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bundle_id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      ),
      generatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}generated_at'],
      )!,
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_json'],
      )!,
      importedByTeacherId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}imported_by_teacher_id'],
      ),
      importedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}imported_at'],
      ),
    );
  }

  @override
  $ExportBundlesTable createAlias(String alias) {
    return $ExportBundlesTable(attachedDatabase, alias);
  }
}

class ExportBundleRow extends DataClass implements Insertable<ExportBundleRow> {
  final String bundleId;
  final String? userId;
  final int generatedAt;
  final String payloadJson;
  final String? importedByTeacherId;
  final int? importedAt;
  const ExportBundleRow({
    required this.bundleId,
    this.userId,
    required this.generatedAt,
    required this.payloadJson,
    this.importedByTeacherId,
    this.importedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['bundle_id'] = Variable<String>(bundleId);
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    map['generated_at'] = Variable<int>(generatedAt);
    map['payload_json'] = Variable<String>(payloadJson);
    if (!nullToAbsent || importedByTeacherId != null) {
      map['imported_by_teacher_id'] = Variable<String>(importedByTeacherId);
    }
    if (!nullToAbsent || importedAt != null) {
      map['imported_at'] = Variable<int>(importedAt);
    }
    return map;
  }

  ExportBundlesCompanion toCompanion(bool nullToAbsent) {
    return ExportBundlesCompanion(
      bundleId: Value(bundleId),
      userId: userId == null && nullToAbsent
          ? const Value.absent()
          : Value(userId),
      generatedAt: Value(generatedAt),
      payloadJson: Value(payloadJson),
      importedByTeacherId: importedByTeacherId == null && nullToAbsent
          ? const Value.absent()
          : Value(importedByTeacherId),
      importedAt: importedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(importedAt),
    );
  }

  factory ExportBundleRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExportBundleRow(
      bundleId: serializer.fromJson<String>(json['bundleId']),
      userId: serializer.fromJson<String?>(json['userId']),
      generatedAt: serializer.fromJson<int>(json['generatedAt']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
      importedByTeacherId: serializer.fromJson<String?>(
        json['importedByTeacherId'],
      ),
      importedAt: serializer.fromJson<int?>(json['importedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'bundleId': serializer.toJson<String>(bundleId),
      'userId': serializer.toJson<String?>(userId),
      'generatedAt': serializer.toJson<int>(generatedAt),
      'payloadJson': serializer.toJson<String>(payloadJson),
      'importedByTeacherId': serializer.toJson<String?>(importedByTeacherId),
      'importedAt': serializer.toJson<int?>(importedAt),
    };
  }

  ExportBundleRow copyWith({
    String? bundleId,
    Value<String?> userId = const Value.absent(),
    int? generatedAt,
    String? payloadJson,
    Value<String?> importedByTeacherId = const Value.absent(),
    Value<int?> importedAt = const Value.absent(),
  }) => ExportBundleRow(
    bundleId: bundleId ?? this.bundleId,
    userId: userId.present ? userId.value : this.userId,
    generatedAt: generatedAt ?? this.generatedAt,
    payloadJson: payloadJson ?? this.payloadJson,
    importedByTeacherId: importedByTeacherId.present
        ? importedByTeacherId.value
        : this.importedByTeacherId,
    importedAt: importedAt.present ? importedAt.value : this.importedAt,
  );
  ExportBundleRow copyWithCompanion(ExportBundlesCompanion data) {
    return ExportBundleRow(
      bundleId: data.bundleId.present ? data.bundleId.value : this.bundleId,
      userId: data.userId.present ? data.userId.value : this.userId,
      generatedAt: data.generatedAt.present
          ? data.generatedAt.value
          : this.generatedAt,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
      importedByTeacherId: data.importedByTeacherId.present
          ? data.importedByTeacherId.value
          : this.importedByTeacherId,
      importedAt: data.importedAt.present
          ? data.importedAt.value
          : this.importedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExportBundleRow(')
          ..write('bundleId: $bundleId, ')
          ..write('userId: $userId, ')
          ..write('generatedAt: $generatedAt, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('importedByTeacherId: $importedByTeacherId, ')
          ..write('importedAt: $importedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    bundleId,
    userId,
    generatedAt,
    payloadJson,
    importedByTeacherId,
    importedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExportBundleRow &&
          other.bundleId == this.bundleId &&
          other.userId == this.userId &&
          other.generatedAt == this.generatedAt &&
          other.payloadJson == this.payloadJson &&
          other.importedByTeacherId == this.importedByTeacherId &&
          other.importedAt == this.importedAt);
}

class ExportBundlesCompanion extends UpdateCompanion<ExportBundleRow> {
  final Value<String> bundleId;
  final Value<String?> userId;
  final Value<int> generatedAt;
  final Value<String> payloadJson;
  final Value<String?> importedByTeacherId;
  final Value<int?> importedAt;
  final Value<int> rowid;
  const ExportBundlesCompanion({
    this.bundleId = const Value.absent(),
    this.userId = const Value.absent(),
    this.generatedAt = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.importedByTeacherId = const Value.absent(),
    this.importedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExportBundlesCompanion.insert({
    required String bundleId,
    this.userId = const Value.absent(),
    required int generatedAt,
    required String payloadJson,
    this.importedByTeacherId = const Value.absent(),
    this.importedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : bundleId = Value(bundleId),
       generatedAt = Value(generatedAt),
       payloadJson = Value(payloadJson);
  static Insertable<ExportBundleRow> custom({
    Expression<String>? bundleId,
    Expression<String>? userId,
    Expression<int>? generatedAt,
    Expression<String>? payloadJson,
    Expression<String>? importedByTeacherId,
    Expression<int>? importedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (bundleId != null) 'bundle_id': bundleId,
      if (userId != null) 'user_id': userId,
      if (generatedAt != null) 'generated_at': generatedAt,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (importedByTeacherId != null)
        'imported_by_teacher_id': importedByTeacherId,
      if (importedAt != null) 'imported_at': importedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExportBundlesCompanion copyWith({
    Value<String>? bundleId,
    Value<String?>? userId,
    Value<int>? generatedAt,
    Value<String>? payloadJson,
    Value<String?>? importedByTeacherId,
    Value<int?>? importedAt,
    Value<int>? rowid,
  }) {
    return ExportBundlesCompanion(
      bundleId: bundleId ?? this.bundleId,
      userId: userId ?? this.userId,
      generatedAt: generatedAt ?? this.generatedAt,
      payloadJson: payloadJson ?? this.payloadJson,
      importedByTeacherId: importedByTeacherId ?? this.importedByTeacherId,
      importedAt: importedAt ?? this.importedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (bundleId.present) {
      map['bundle_id'] = Variable<String>(bundleId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (generatedAt.present) {
      map['generated_at'] = Variable<int>(generatedAt.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (importedByTeacherId.present) {
      map['imported_by_teacher_id'] = Variable<String>(
        importedByTeacherId.value,
      );
    }
    if (importedAt.present) {
      map['imported_at'] = Variable<int>(importedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExportBundlesCompanion(')
          ..write('bundleId: $bundleId, ')
          ..write('userId: $userId, ')
          ..write('generatedAt: $generatedAt, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('importedByTeacherId: $importedByTeacherId, ')
          ..write('importedAt: $importedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSettingRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSettingRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppSettingRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSettingRow(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSettingRow extends DataClass implements Insertable<AppSettingRow> {
  final String key;
  final String value;
  const AppSettingRow({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(key: Value(key), value: Value(value));
  }

  factory AppSettingRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSettingRow(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  AppSettingRow copyWith({String? key, String? value}) =>
      AppSettingRow(key: key ?? this.key, value: value ?? this.value);
  AppSettingRow copyWithCompanion(AppSettingsCompanion data) {
    return AppSettingRow(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingRow(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSettingRow &&
          other.key == this.key &&
          other.value == this.value);
}

class AppSettingsCompanion extends UpdateCompanion<AppSettingRow> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const AppSettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<AppSettingRow> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return AppSettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ClassSectionsTable classSections = $ClassSectionsTable(this);
  late final $UsersTable users = $UsersTable(this);
  late final $ContentPacksTable contentPacks = $ContentPacksTable(this);
  late final $LessonStagesTable lessonStages = $LessonStagesTable(this);
  late final $QuizItemsTable quizItems = $QuizItemsTable(this);
  late final $MissionLevelsTable missionLevels = $MissionLevelsTable(this);
  late final $PredictionLogTable predictionLog = $PredictionLogTable(this);
  late final $MotionTrialsTable motionTrials = $MotionTrialsTable(this);
  late final $MissionAttemptsTable missionAttempts = $MissionAttemptsTable(
    this,
  );
  late final $QuizAttemptsTable quizAttempts = $QuizAttemptsTable(this);
  late final $QuizItemResponsesTable quizItemResponses =
      $QuizItemResponsesTable(this);
  late final $BadgesTable badges = $BadgesTable(this);
  late final $BadgesEarnedTable badgesEarned = $BadgesEarnedTable(this);
  late final $PointsLedgerTable pointsLedger = $PointsLedgerTable(this);
  late final $ExportBundlesTable exportBundles = $ExportBundlesTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    classSections,
    users,
    contentPacks,
    lessonStages,
    quizItems,
    missionLevels,
    predictionLog,
    motionTrials,
    missionAttempts,
    quizAttempts,
    quizItemResponses,
    badges,
    badgesEarned,
    pointsLedger,
    exportBundles,
    appSettings,
  ];
}

typedef $$ClassSectionsTableCreateCompanionBuilder =
    ClassSectionsCompanion Function({
      required String sectionId,
      Value<String?> teacherId,
      required String sectionName,
      Value<String?> schoolName,
      required int createdAt,
      Value<String?> schoolYear,
      Value<String?> sectionPin,
      Value<int> rowid,
    });
typedef $$ClassSectionsTableUpdateCompanionBuilder =
    ClassSectionsCompanion Function({
      Value<String> sectionId,
      Value<String?> teacherId,
      Value<String> sectionName,
      Value<String?> schoolName,
      Value<int> createdAt,
      Value<String?> schoolYear,
      Value<String?> sectionPin,
      Value<int> rowid,
    });

final class $$ClassSectionsTableReferences
    extends
        BaseReferences<_$AppDatabase, $ClassSectionsTable, ClassSectionRow> {
  $$ClassSectionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $UsersTable _teacherIdTable(_$AppDatabase db) =>
      db.users.createAlias('class_sections__teacher_id__users__user_id');

  $$UsersTableProcessedTableManager? get teacherId {
    final $_column = $_itemColumn<String>('teacher_id');
    if ($_column == null) return null;
    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.userId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_teacherIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$UsersTable, List<UserRow>> _usersRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.users,
    aliasName: 'class_sections__section_id__users__section_id',
  );

  $$UsersTableProcessedTableManager get usersRefs {
    final manager = $$UsersTableTableManager($_db, $_db.users).filter(
      (f) =>
          f.sectionId.sectionId.sqlEquals($_itemColumn<String>('section_id')!),
    );

    final cache = $_typedResult.readTableOrNull(_usersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ClassSectionsTableFilterComposer
    extends Composer<_$AppDatabase, $ClassSectionsTable> {
  $$ClassSectionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get sectionId => $composableBuilder(
    column: $table.sectionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sectionName => $composableBuilder(
    column: $table.sectionName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get schoolName => $composableBuilder(
    column: $table.schoolName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get schoolYear => $composableBuilder(
    column: $table.schoolYear,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sectionPin => $composableBuilder(
    column: $table.sectionPin,
    builder: (column) => ColumnFilters(column),
  );

  $$UsersTableFilterComposer get teacherId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.teacherId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> usersRefs(
    Expression<bool> Function($$UsersTableFilterComposer f) f,
  ) {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sectionId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.sectionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ClassSectionsTableOrderingComposer
    extends Composer<_$AppDatabase, $ClassSectionsTable> {
  $$ClassSectionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get sectionId => $composableBuilder(
    column: $table.sectionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sectionName => $composableBuilder(
    column: $table.sectionName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get schoolName => $composableBuilder(
    column: $table.schoolName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get schoolYear => $composableBuilder(
    column: $table.schoolYear,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sectionPin => $composableBuilder(
    column: $table.sectionPin,
    builder: (column) => ColumnOrderings(column),
  );

  $$UsersTableOrderingComposer get teacherId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.teacherId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ClassSectionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ClassSectionsTable> {
  $$ClassSectionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get sectionId =>
      $composableBuilder(column: $table.sectionId, builder: (column) => column);

  GeneratedColumn<String> get sectionName => $composableBuilder(
    column: $table.sectionName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get schoolName => $composableBuilder(
    column: $table.schoolName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get schoolYear => $composableBuilder(
    column: $table.schoolYear,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sectionPin => $composableBuilder(
    column: $table.sectionPin,
    builder: (column) => column,
  );

  $$UsersTableAnnotationComposer get teacherId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.teacherId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> usersRefs<T extends Object>(
    Expression<T> Function($$UsersTableAnnotationComposer a) f,
  ) {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sectionId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.sectionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ClassSectionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ClassSectionsTable,
          ClassSectionRow,
          $$ClassSectionsTableFilterComposer,
          $$ClassSectionsTableOrderingComposer,
          $$ClassSectionsTableAnnotationComposer,
          $$ClassSectionsTableCreateCompanionBuilder,
          $$ClassSectionsTableUpdateCompanionBuilder,
          (ClassSectionRow, $$ClassSectionsTableReferences),
          ClassSectionRow,
          PrefetchHooks Function({bool teacherId, bool usersRefs})
        > {
  $$ClassSectionsTableTableManager(_$AppDatabase db, $ClassSectionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ClassSectionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ClassSectionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ClassSectionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> sectionId = const Value.absent(),
                Value<String?> teacherId = const Value.absent(),
                Value<String> sectionName = const Value.absent(),
                Value<String?> schoolName = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<String?> schoolYear = const Value.absent(),
                Value<String?> sectionPin = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ClassSectionsCompanion(
                sectionId: sectionId,
                teacherId: teacherId,
                sectionName: sectionName,
                schoolName: schoolName,
                createdAt: createdAt,
                schoolYear: schoolYear,
                sectionPin: sectionPin,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String sectionId,
                Value<String?> teacherId = const Value.absent(),
                required String sectionName,
                Value<String?> schoolName = const Value.absent(),
                required int createdAt,
                Value<String?> schoolYear = const Value.absent(),
                Value<String?> sectionPin = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ClassSectionsCompanion.insert(
                sectionId: sectionId,
                teacherId: teacherId,
                sectionName: sectionName,
                schoolName: schoolName,
                createdAt: createdAt,
                schoolYear: schoolYear,
                sectionPin: sectionPin,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ClassSectionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({teacherId = false, usersRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (usersRefs) db.users],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (teacherId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.teacherId,
                                referencedTable: $$ClassSectionsTableReferences
                                    ._teacherIdTable(db),
                                referencedColumn: $$ClassSectionsTableReferences
                                    ._teacherIdTable(db)
                                    .userId,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (usersRefs)
                    await $_getPrefetchedData<
                      ClassSectionRow,
                      $ClassSectionsTable,
                      UserRow
                    >(
                      currentTable: table,
                      referencedTable: $$ClassSectionsTableReferences
                          ._usersRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ClassSectionsTableReferences(
                            db,
                            table,
                            p0,
                          ).usersRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.sectionId == item.sectionId,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ClassSectionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ClassSectionsTable,
      ClassSectionRow,
      $$ClassSectionsTableFilterComposer,
      $$ClassSectionsTableOrderingComposer,
      $$ClassSectionsTableAnnotationComposer,
      $$ClassSectionsTableCreateCompanionBuilder,
      $$ClassSectionsTableUpdateCompanionBuilder,
      (ClassSectionRow, $$ClassSectionsTableReferences),
      ClassSectionRow,
      PrefetchHooks Function({bool teacherId, bool usersRefs})
    >;
typedef $$UsersTableCreateCompanionBuilder =
    UsersCompanion Function({
      required String userId,
      required String role,
      required String displayName,
      required String pinHash,
      Value<String?> avatarId,
      Value<String?> gradeLevel,
      Value<String?> strand,
      Value<String?> sectionId,
      required int createdAt,
      Value<int?> lastLoginAt,
      Value<String?> officialStudentId,
      Value<int> rowid,
    });
typedef $$UsersTableUpdateCompanionBuilder =
    UsersCompanion Function({
      Value<String> userId,
      Value<String> role,
      Value<String> displayName,
      Value<String> pinHash,
      Value<String?> avatarId,
      Value<String?> gradeLevel,
      Value<String?> strand,
      Value<String?> sectionId,
      Value<int> createdAt,
      Value<int?> lastLoginAt,
      Value<String?> officialStudentId,
      Value<int> rowid,
    });

final class $$UsersTableReferences
    extends BaseReferences<_$AppDatabase, $UsersTable, UserRow> {
  $$UsersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ClassSectionsTable _sectionIdTable(_$AppDatabase db) => db
      .classSections
      .createAlias('users__section_id__class_sections__section_id');

  $$ClassSectionsTableProcessedTableManager? get sectionId {
    final $_column = $_itemColumn<String>('section_id');
    if ($_column == null) return null;
    final manager = $$ClassSectionsTableTableManager(
      $_db,
      $_db.classSections,
    ).filter((f) => f.sectionId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sectionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ClassSectionsTable, List<ClassSectionRow>>
  _classSectionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.classSections,
    aliasName: 'users__user_id__class_sections__teacher_id',
  );

  $$ClassSectionsTableProcessedTableManager get classSectionsRefs {
    final manager = $$ClassSectionsTableTableManager($_db, $_db.classSections)
        .filter(
          (f) => f.teacherId.userId.sqlEquals($_itemColumn<String>('user_id')!),
        );

    final cache = $_typedResult.readTableOrNull(_classSectionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PredictionLogTable, List<PredictionLogRow>>
  _predictionLogRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.predictionLog,
    aliasName: 'users__user_id__prediction_log__user_id',
  );

  $$PredictionLogTableProcessedTableManager get predictionLogRefs {
    final manager = $$PredictionLogTableTableManager($_db, $_db.predictionLog)
        .filter(
          (f) => f.userId.userId.sqlEquals($_itemColumn<String>('user_id')!),
        );

    final cache = $_typedResult.readTableOrNull(_predictionLogRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MotionTrialsTable, List<MotionTrialRow>>
  _motionTrialsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.motionTrials,
    aliasName: 'users__user_id__motion_trials__user_id',
  );

  $$MotionTrialsTableProcessedTableManager get motionTrialsRefs {
    final manager = $$MotionTrialsTableTableManager($_db, $_db.motionTrials)
        .filter(
          (f) => f.userId.userId.sqlEquals($_itemColumn<String>('user_id')!),
        );

    final cache = $_typedResult.readTableOrNull(_motionTrialsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MissionAttemptsTable, List<MissionAttemptRow>>
  _missionAttemptsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.missionAttempts,
    aliasName: 'users__user_id__mission_attempts__user_id',
  );

  $$MissionAttemptsTableProcessedTableManager get missionAttemptsRefs {
    final manager =
        $$MissionAttemptsTableTableManager($_db, $_db.missionAttempts).filter(
          (f) => f.userId.userId.sqlEquals($_itemColumn<String>('user_id')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _missionAttemptsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$QuizAttemptsTable, List<QuizAttemptRow>>
  _quizAttemptsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.quizAttempts,
    aliasName: 'users__user_id__quiz_attempts__user_id',
  );

  $$QuizAttemptsTableProcessedTableManager get quizAttemptsRefs {
    final manager = $$QuizAttemptsTableTableManager($_db, $_db.quizAttempts)
        .filter(
          (f) => f.userId.userId.sqlEquals($_itemColumn<String>('user_id')!),
        );

    final cache = $_typedResult.readTableOrNull(_quizAttemptsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$BadgesEarnedTable, List<BadgeEarnedRow>>
  _badgesEarnedRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.badgesEarned,
    aliasName: 'users__user_id__badges_earned__user_id',
  );

  $$BadgesEarnedTableProcessedTableManager get badgesEarnedRefs {
    final manager = $$BadgesEarnedTableTableManager($_db, $_db.badgesEarned)
        .filter(
          (f) => f.userId.userId.sqlEquals($_itemColumn<String>('user_id')!),
        );

    final cache = $_typedResult.readTableOrNull(_badgesEarnedRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PointsLedgerTable, List<PointsLedgerRow>>
  _pointsLedgerRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.pointsLedger,
    aliasName: 'users__user_id__points_ledger__user_id',
  );

  $$PointsLedgerTableProcessedTableManager get pointsLedgerRefs {
    final manager = $$PointsLedgerTableTableManager($_db, $_db.pointsLedger)
        .filter(
          (f) => f.userId.userId.sqlEquals($_itemColumn<String>('user_id')!),
        );

    final cache = $_typedResult.readTableOrNull(_pointsLedgerRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ExportBundlesTable, List<ExportBundleRow>>
  _exportBundlesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.exportBundles,
    aliasName: 'users__user_id__export_bundles__user_id',
  );

  $$ExportBundlesTableProcessedTableManager get exportBundlesRefs {
    final manager = $$ExportBundlesTableTableManager($_db, $_db.exportBundles)
        .filter(
          (f) => f.userId.userId.sqlEquals($_itemColumn<String>('user_id')!),
        );

    final cache = $_typedResult.readTableOrNull(_exportBundlesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pinHash => $composableBuilder(
    column: $table.pinHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get avatarId => $composableBuilder(
    column: $table.avatarId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gradeLevel => $composableBuilder(
    column: $table.gradeLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get strand => $composableBuilder(
    column: $table.strand,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastLoginAt => $composableBuilder(
    column: $table.lastLoginAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get officialStudentId => $composableBuilder(
    column: $table.officialStudentId,
    builder: (column) => ColumnFilters(column),
  );

  $$ClassSectionsTableFilterComposer get sectionId {
    final $$ClassSectionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sectionId,
      referencedTable: $db.classSections,
      getReferencedColumn: (t) => t.sectionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClassSectionsTableFilterComposer(
            $db: $db,
            $table: $db.classSections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> classSectionsRefs(
    Expression<bool> Function($$ClassSectionsTableFilterComposer f) f,
  ) {
    final $$ClassSectionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.classSections,
      getReferencedColumn: (t) => t.teacherId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClassSectionsTableFilterComposer(
            $db: $db,
            $table: $db.classSections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> predictionLogRefs(
    Expression<bool> Function($$PredictionLogTableFilterComposer f) f,
  ) {
    final $$PredictionLogTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.predictionLog,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PredictionLogTableFilterComposer(
            $db: $db,
            $table: $db.predictionLog,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> motionTrialsRefs(
    Expression<bool> Function($$MotionTrialsTableFilterComposer f) f,
  ) {
    final $$MotionTrialsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.motionTrials,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MotionTrialsTableFilterComposer(
            $db: $db,
            $table: $db.motionTrials,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> missionAttemptsRefs(
    Expression<bool> Function($$MissionAttemptsTableFilterComposer f) f,
  ) {
    final $$MissionAttemptsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.missionAttempts,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MissionAttemptsTableFilterComposer(
            $db: $db,
            $table: $db.missionAttempts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> quizAttemptsRefs(
    Expression<bool> Function($$QuizAttemptsTableFilterComposer f) f,
  ) {
    final $$QuizAttemptsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.quizAttempts,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuizAttemptsTableFilterComposer(
            $db: $db,
            $table: $db.quizAttempts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> badgesEarnedRefs(
    Expression<bool> Function($$BadgesEarnedTableFilterComposer f) f,
  ) {
    final $$BadgesEarnedTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.badgesEarned,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BadgesEarnedTableFilterComposer(
            $db: $db,
            $table: $db.badgesEarned,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> pointsLedgerRefs(
    Expression<bool> Function($$PointsLedgerTableFilterComposer f) f,
  ) {
    final $$PointsLedgerTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.pointsLedger,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PointsLedgerTableFilterComposer(
            $db: $db,
            $table: $db.pointsLedger,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> exportBundlesRefs(
    Expression<bool> Function($$ExportBundlesTableFilterComposer f) f,
  ) {
    final $$ExportBundlesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.exportBundles,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExportBundlesTableFilterComposer(
            $db: $db,
            $table: $db.exportBundles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UsersTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pinHash => $composableBuilder(
    column: $table.pinHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get avatarId => $composableBuilder(
    column: $table.avatarId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gradeLevel => $composableBuilder(
    column: $table.gradeLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get strand => $composableBuilder(
    column: $table.strand,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastLoginAt => $composableBuilder(
    column: $table.lastLoginAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get officialStudentId => $composableBuilder(
    column: $table.officialStudentId,
    builder: (column) => ColumnOrderings(column),
  );

  $$ClassSectionsTableOrderingComposer get sectionId {
    final $$ClassSectionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sectionId,
      referencedTable: $db.classSections,
      getReferencedColumn: (t) => t.sectionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClassSectionsTableOrderingComposer(
            $db: $db,
            $table: $db.classSections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get pinHash =>
      $composableBuilder(column: $table.pinHash, builder: (column) => column);

  GeneratedColumn<String> get avatarId =>
      $composableBuilder(column: $table.avatarId, builder: (column) => column);

  GeneratedColumn<String> get gradeLevel => $composableBuilder(
    column: $table.gradeLevel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get strand =>
      $composableBuilder(column: $table.strand, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get lastLoginAt => $composableBuilder(
    column: $table.lastLoginAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get officialStudentId => $composableBuilder(
    column: $table.officialStudentId,
    builder: (column) => column,
  );

  $$ClassSectionsTableAnnotationComposer get sectionId {
    final $$ClassSectionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sectionId,
      referencedTable: $db.classSections,
      getReferencedColumn: (t) => t.sectionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClassSectionsTableAnnotationComposer(
            $db: $db,
            $table: $db.classSections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> classSectionsRefs<T extends Object>(
    Expression<T> Function($$ClassSectionsTableAnnotationComposer a) f,
  ) {
    final $$ClassSectionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.classSections,
      getReferencedColumn: (t) => t.teacherId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClassSectionsTableAnnotationComposer(
            $db: $db,
            $table: $db.classSections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> predictionLogRefs<T extends Object>(
    Expression<T> Function($$PredictionLogTableAnnotationComposer a) f,
  ) {
    final $$PredictionLogTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.predictionLog,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PredictionLogTableAnnotationComposer(
            $db: $db,
            $table: $db.predictionLog,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> motionTrialsRefs<T extends Object>(
    Expression<T> Function($$MotionTrialsTableAnnotationComposer a) f,
  ) {
    final $$MotionTrialsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.motionTrials,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MotionTrialsTableAnnotationComposer(
            $db: $db,
            $table: $db.motionTrials,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> missionAttemptsRefs<T extends Object>(
    Expression<T> Function($$MissionAttemptsTableAnnotationComposer a) f,
  ) {
    final $$MissionAttemptsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.missionAttempts,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MissionAttemptsTableAnnotationComposer(
            $db: $db,
            $table: $db.missionAttempts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> quizAttemptsRefs<T extends Object>(
    Expression<T> Function($$QuizAttemptsTableAnnotationComposer a) f,
  ) {
    final $$QuizAttemptsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.quizAttempts,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuizAttemptsTableAnnotationComposer(
            $db: $db,
            $table: $db.quizAttempts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> badgesEarnedRefs<T extends Object>(
    Expression<T> Function($$BadgesEarnedTableAnnotationComposer a) f,
  ) {
    final $$BadgesEarnedTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.badgesEarned,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BadgesEarnedTableAnnotationComposer(
            $db: $db,
            $table: $db.badgesEarned,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> pointsLedgerRefs<T extends Object>(
    Expression<T> Function($$PointsLedgerTableAnnotationComposer a) f,
  ) {
    final $$PointsLedgerTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.pointsLedger,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PointsLedgerTableAnnotationComposer(
            $db: $db,
            $table: $db.pointsLedger,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> exportBundlesRefs<T extends Object>(
    Expression<T> Function($$ExportBundlesTableAnnotationComposer a) f,
  ) {
    final $$ExportBundlesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.exportBundles,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExportBundlesTableAnnotationComposer(
            $db: $db,
            $table: $db.exportBundles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UsersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UsersTable,
          UserRow,
          $$UsersTableFilterComposer,
          $$UsersTableOrderingComposer,
          $$UsersTableAnnotationComposer,
          $$UsersTableCreateCompanionBuilder,
          $$UsersTableUpdateCompanionBuilder,
          (UserRow, $$UsersTableReferences),
          UserRow,
          PrefetchHooks Function({
            bool sectionId,
            bool classSectionsRefs,
            bool predictionLogRefs,
            bool motionTrialsRefs,
            bool missionAttemptsRefs,
            bool quizAttemptsRefs,
            bool badgesEarnedRefs,
            bool pointsLedgerRefs,
            bool exportBundlesRefs,
          })
        > {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> userId = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<String> displayName = const Value.absent(),
                Value<String> pinHash = const Value.absent(),
                Value<String?> avatarId = const Value.absent(),
                Value<String?> gradeLevel = const Value.absent(),
                Value<String?> strand = const Value.absent(),
                Value<String?> sectionId = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int?> lastLoginAt = const Value.absent(),
                Value<String?> officialStudentId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsersCompanion(
                userId: userId,
                role: role,
                displayName: displayName,
                pinHash: pinHash,
                avatarId: avatarId,
                gradeLevel: gradeLevel,
                strand: strand,
                sectionId: sectionId,
                createdAt: createdAt,
                lastLoginAt: lastLoginAt,
                officialStudentId: officialStudentId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String userId,
                required String role,
                required String displayName,
                required String pinHash,
                Value<String?> avatarId = const Value.absent(),
                Value<String?> gradeLevel = const Value.absent(),
                Value<String?> strand = const Value.absent(),
                Value<String?> sectionId = const Value.absent(),
                required int createdAt,
                Value<int?> lastLoginAt = const Value.absent(),
                Value<String?> officialStudentId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsersCompanion.insert(
                userId: userId,
                role: role,
                displayName: displayName,
                pinHash: pinHash,
                avatarId: avatarId,
                gradeLevel: gradeLevel,
                strand: strand,
                sectionId: sectionId,
                createdAt: createdAt,
                lastLoginAt: lastLoginAt,
                officialStudentId: officialStudentId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$UsersTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                sectionId = false,
                classSectionsRefs = false,
                predictionLogRefs = false,
                motionTrialsRefs = false,
                missionAttemptsRefs = false,
                quizAttemptsRefs = false,
                badgesEarnedRefs = false,
                pointsLedgerRefs = false,
                exportBundlesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (classSectionsRefs) db.classSections,
                    if (predictionLogRefs) db.predictionLog,
                    if (motionTrialsRefs) db.motionTrials,
                    if (missionAttemptsRefs) db.missionAttempts,
                    if (quizAttemptsRefs) db.quizAttempts,
                    if (badgesEarnedRefs) db.badgesEarned,
                    if (pointsLedgerRefs) db.pointsLedger,
                    if (exportBundlesRefs) db.exportBundles,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (sectionId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.sectionId,
                                    referencedTable: $$UsersTableReferences
                                        ._sectionIdTable(db),
                                    referencedColumn: $$UsersTableReferences
                                        ._sectionIdTable(db)
                                        .sectionId,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (classSectionsRefs)
                        await $_getPrefetchedData<
                          UserRow,
                          $UsersTable,
                          ClassSectionRow
                        >(
                          currentTable: table,
                          referencedTable: $$UsersTableReferences
                              ._classSectionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UsersTableReferences(
                                db,
                                table,
                                p0,
                              ).classSectionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.teacherId == item.userId,
                              ),
                          typedResults: items,
                        ),
                      if (predictionLogRefs)
                        await $_getPrefetchedData<
                          UserRow,
                          $UsersTable,
                          PredictionLogRow
                        >(
                          currentTable: table,
                          referencedTable: $$UsersTableReferences
                              ._predictionLogRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UsersTableReferences(
                                db,
                                table,
                                p0,
                              ).predictionLogRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.userId == item.userId,
                              ),
                          typedResults: items,
                        ),
                      if (motionTrialsRefs)
                        await $_getPrefetchedData<
                          UserRow,
                          $UsersTable,
                          MotionTrialRow
                        >(
                          currentTable: table,
                          referencedTable: $$UsersTableReferences
                              ._motionTrialsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UsersTableReferences(
                                db,
                                table,
                                p0,
                              ).motionTrialsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.userId == item.userId,
                              ),
                          typedResults: items,
                        ),
                      if (missionAttemptsRefs)
                        await $_getPrefetchedData<
                          UserRow,
                          $UsersTable,
                          MissionAttemptRow
                        >(
                          currentTable: table,
                          referencedTable: $$UsersTableReferences
                              ._missionAttemptsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UsersTableReferences(
                                db,
                                table,
                                p0,
                              ).missionAttemptsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.userId == item.userId,
                              ),
                          typedResults: items,
                        ),
                      if (quizAttemptsRefs)
                        await $_getPrefetchedData<
                          UserRow,
                          $UsersTable,
                          QuizAttemptRow
                        >(
                          currentTable: table,
                          referencedTable: $$UsersTableReferences
                              ._quizAttemptsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UsersTableReferences(
                                db,
                                table,
                                p0,
                              ).quizAttemptsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.userId == item.userId,
                              ),
                          typedResults: items,
                        ),
                      if (badgesEarnedRefs)
                        await $_getPrefetchedData<
                          UserRow,
                          $UsersTable,
                          BadgeEarnedRow
                        >(
                          currentTable: table,
                          referencedTable: $$UsersTableReferences
                              ._badgesEarnedRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UsersTableReferences(
                                db,
                                table,
                                p0,
                              ).badgesEarnedRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.userId == item.userId,
                              ),
                          typedResults: items,
                        ),
                      if (pointsLedgerRefs)
                        await $_getPrefetchedData<
                          UserRow,
                          $UsersTable,
                          PointsLedgerRow
                        >(
                          currentTable: table,
                          referencedTable: $$UsersTableReferences
                              ._pointsLedgerRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UsersTableReferences(
                                db,
                                table,
                                p0,
                              ).pointsLedgerRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.userId == item.userId,
                              ),
                          typedResults: items,
                        ),
                      if (exportBundlesRefs)
                        await $_getPrefetchedData<
                          UserRow,
                          $UsersTable,
                          ExportBundleRow
                        >(
                          currentTable: table,
                          referencedTable: $$UsersTableReferences
                              ._exportBundlesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UsersTableReferences(
                                db,
                                table,
                                p0,
                              ).exportBundlesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.userId == item.userId,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$UsersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UsersTable,
      UserRow,
      $$UsersTableFilterComposer,
      $$UsersTableOrderingComposer,
      $$UsersTableAnnotationComposer,
      $$UsersTableCreateCompanionBuilder,
      $$UsersTableUpdateCompanionBuilder,
      (UserRow, $$UsersTableReferences),
      UserRow,
      PrefetchHooks Function({
        bool sectionId,
        bool classSectionsRefs,
        bool predictionLogRefs,
        bool motionTrialsRefs,
        bool missionAttemptsRefs,
        bool quizAttemptsRefs,
        bool badgesEarnedRefs,
        bool pointsLedgerRefs,
        bool exportBundlesRefs,
      })
    >;
typedef $$ContentPacksTableCreateCompanionBuilder =
    ContentPacksCompanion Function({
      required String packId,
      required String topicName,
      required String version,
      Value<String?> melcCodes,
      required int importedAt,
      Value<int> rowid,
    });
typedef $$ContentPacksTableUpdateCompanionBuilder =
    ContentPacksCompanion Function({
      Value<String> packId,
      Value<String> topicName,
      Value<String> version,
      Value<String?> melcCodes,
      Value<int> importedAt,
      Value<int> rowid,
    });

final class $$ContentPacksTableReferences
    extends BaseReferences<_$AppDatabase, $ContentPacksTable, ContentPackRow> {
  $$ContentPacksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$LessonStagesTable, List<LessonStageRow>>
  _lessonStagesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.lessonStages,
    aliasName: 'content_packs__pack_id__lesson_stages__pack_id',
  );

  $$LessonStagesTableProcessedTableManager get lessonStagesRefs {
    final manager = $$LessonStagesTableTableManager($_db, $_db.lessonStages)
        .filter(
          (f) => f.packId.packId.sqlEquals($_itemColumn<String>('pack_id')!),
        );

    final cache = $_typedResult.readTableOrNull(_lessonStagesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$QuizItemsTable, List<QuizItemRow>>
  _quizItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.quizItems,
    aliasName: 'content_packs__pack_id__quiz_items__pack_id',
  );

  $$QuizItemsTableProcessedTableManager get quizItemsRefs {
    final manager = $$QuizItemsTableTableManager($_db, $_db.quizItems).filter(
      (f) => f.packId.packId.sqlEquals($_itemColumn<String>('pack_id')!),
    );

    final cache = $_typedResult.readTableOrNull(_quizItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MissionLevelsTable, List<MissionLevelRow>>
  _missionLevelsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.missionLevels,
    aliasName: 'content_packs__pack_id__mission_levels__pack_id',
  );

  $$MissionLevelsTableProcessedTableManager get missionLevelsRefs {
    final manager = $$MissionLevelsTableTableManager($_db, $_db.missionLevels)
        .filter(
          (f) => f.packId.packId.sqlEquals($_itemColumn<String>('pack_id')!),
        );

    final cache = $_typedResult.readTableOrNull(_missionLevelsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$QuizAttemptsTable, List<QuizAttemptRow>>
  _quizAttemptsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.quizAttempts,
    aliasName: 'content_packs__pack_id__quiz_attempts__pack_id',
  );

  $$QuizAttemptsTableProcessedTableManager get quizAttemptsRefs {
    final manager = $$QuizAttemptsTableTableManager($_db, $_db.quizAttempts)
        .filter(
          (f) => f.packId.packId.sqlEquals($_itemColumn<String>('pack_id')!),
        );

    final cache = $_typedResult.readTableOrNull(_quizAttemptsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ContentPacksTableFilterComposer
    extends Composer<_$AppDatabase, $ContentPacksTable> {
  $$ContentPacksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get packId => $composableBuilder(
    column: $table.packId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get topicName => $composableBuilder(
    column: $table.topicName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get melcCodes => $composableBuilder(
    column: $table.melcCodes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get importedAt => $composableBuilder(
    column: $table.importedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> lessonStagesRefs(
    Expression<bool> Function($$LessonStagesTableFilterComposer f) f,
  ) {
    final $$LessonStagesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.lessonStages,
      getReferencedColumn: (t) => t.packId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LessonStagesTableFilterComposer(
            $db: $db,
            $table: $db.lessonStages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> quizItemsRefs(
    Expression<bool> Function($$QuizItemsTableFilterComposer f) f,
  ) {
    final $$QuizItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.quizItems,
      getReferencedColumn: (t) => t.packId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuizItemsTableFilterComposer(
            $db: $db,
            $table: $db.quizItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> missionLevelsRefs(
    Expression<bool> Function($$MissionLevelsTableFilterComposer f) f,
  ) {
    final $$MissionLevelsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.missionLevels,
      getReferencedColumn: (t) => t.packId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MissionLevelsTableFilterComposer(
            $db: $db,
            $table: $db.missionLevels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> quizAttemptsRefs(
    Expression<bool> Function($$QuizAttemptsTableFilterComposer f) f,
  ) {
    final $$QuizAttemptsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.quizAttempts,
      getReferencedColumn: (t) => t.packId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuizAttemptsTableFilterComposer(
            $db: $db,
            $table: $db.quizAttempts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ContentPacksTableOrderingComposer
    extends Composer<_$AppDatabase, $ContentPacksTable> {
  $$ContentPacksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get packId => $composableBuilder(
    column: $table.packId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get topicName => $composableBuilder(
    column: $table.topicName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get melcCodes => $composableBuilder(
    column: $table.melcCodes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get importedAt => $composableBuilder(
    column: $table.importedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ContentPacksTableAnnotationComposer
    extends Composer<_$AppDatabase, $ContentPacksTable> {
  $$ContentPacksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get packId =>
      $composableBuilder(column: $table.packId, builder: (column) => column);

  GeneratedColumn<String> get topicName =>
      $composableBuilder(column: $table.topicName, builder: (column) => column);

  GeneratedColumn<String> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<String> get melcCodes =>
      $composableBuilder(column: $table.melcCodes, builder: (column) => column);

  GeneratedColumn<int> get importedAt => $composableBuilder(
    column: $table.importedAt,
    builder: (column) => column,
  );

  Expression<T> lessonStagesRefs<T extends Object>(
    Expression<T> Function($$LessonStagesTableAnnotationComposer a) f,
  ) {
    final $$LessonStagesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.lessonStages,
      getReferencedColumn: (t) => t.packId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LessonStagesTableAnnotationComposer(
            $db: $db,
            $table: $db.lessonStages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> quizItemsRefs<T extends Object>(
    Expression<T> Function($$QuizItemsTableAnnotationComposer a) f,
  ) {
    final $$QuizItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.quizItems,
      getReferencedColumn: (t) => t.packId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuizItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.quizItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> missionLevelsRefs<T extends Object>(
    Expression<T> Function($$MissionLevelsTableAnnotationComposer a) f,
  ) {
    final $$MissionLevelsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.missionLevels,
      getReferencedColumn: (t) => t.packId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MissionLevelsTableAnnotationComposer(
            $db: $db,
            $table: $db.missionLevels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> quizAttemptsRefs<T extends Object>(
    Expression<T> Function($$QuizAttemptsTableAnnotationComposer a) f,
  ) {
    final $$QuizAttemptsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.quizAttempts,
      getReferencedColumn: (t) => t.packId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuizAttemptsTableAnnotationComposer(
            $db: $db,
            $table: $db.quizAttempts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ContentPacksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ContentPacksTable,
          ContentPackRow,
          $$ContentPacksTableFilterComposer,
          $$ContentPacksTableOrderingComposer,
          $$ContentPacksTableAnnotationComposer,
          $$ContentPacksTableCreateCompanionBuilder,
          $$ContentPacksTableUpdateCompanionBuilder,
          (ContentPackRow, $$ContentPacksTableReferences),
          ContentPackRow,
          PrefetchHooks Function({
            bool lessonStagesRefs,
            bool quizItemsRefs,
            bool missionLevelsRefs,
            bool quizAttemptsRefs,
          })
        > {
  $$ContentPacksTableTableManager(_$AppDatabase db, $ContentPacksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ContentPacksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ContentPacksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ContentPacksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> packId = const Value.absent(),
                Value<String> topicName = const Value.absent(),
                Value<String> version = const Value.absent(),
                Value<String?> melcCodes = const Value.absent(),
                Value<int> importedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ContentPacksCompanion(
                packId: packId,
                topicName: topicName,
                version: version,
                melcCodes: melcCodes,
                importedAt: importedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String packId,
                required String topicName,
                required String version,
                Value<String?> melcCodes = const Value.absent(),
                required int importedAt,
                Value<int> rowid = const Value.absent(),
              }) => ContentPacksCompanion.insert(
                packId: packId,
                topicName: topicName,
                version: version,
                melcCodes: melcCodes,
                importedAt: importedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ContentPacksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                lessonStagesRefs = false,
                quizItemsRefs = false,
                missionLevelsRefs = false,
                quizAttemptsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (lessonStagesRefs) db.lessonStages,
                    if (quizItemsRefs) db.quizItems,
                    if (missionLevelsRefs) db.missionLevels,
                    if (quizAttemptsRefs) db.quizAttempts,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (lessonStagesRefs)
                        await $_getPrefetchedData<
                          ContentPackRow,
                          $ContentPacksTable,
                          LessonStageRow
                        >(
                          currentTable: table,
                          referencedTable: $$ContentPacksTableReferences
                              ._lessonStagesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ContentPacksTableReferences(
                                db,
                                table,
                                p0,
                              ).lessonStagesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.packId == item.packId,
                              ),
                          typedResults: items,
                        ),
                      if (quizItemsRefs)
                        await $_getPrefetchedData<
                          ContentPackRow,
                          $ContentPacksTable,
                          QuizItemRow
                        >(
                          currentTable: table,
                          referencedTable: $$ContentPacksTableReferences
                              ._quizItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ContentPacksTableReferences(
                                db,
                                table,
                                p0,
                              ).quizItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.packId == item.packId,
                              ),
                          typedResults: items,
                        ),
                      if (missionLevelsRefs)
                        await $_getPrefetchedData<
                          ContentPackRow,
                          $ContentPacksTable,
                          MissionLevelRow
                        >(
                          currentTable: table,
                          referencedTable: $$ContentPacksTableReferences
                              ._missionLevelsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ContentPacksTableReferences(
                                db,
                                table,
                                p0,
                              ).missionLevelsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.packId == item.packId,
                              ),
                          typedResults: items,
                        ),
                      if (quizAttemptsRefs)
                        await $_getPrefetchedData<
                          ContentPackRow,
                          $ContentPacksTable,
                          QuizAttemptRow
                        >(
                          currentTable: table,
                          referencedTable: $$ContentPacksTableReferences
                              ._quizAttemptsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ContentPacksTableReferences(
                                db,
                                table,
                                p0,
                              ).quizAttemptsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.packId == item.packId,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ContentPacksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ContentPacksTable,
      ContentPackRow,
      $$ContentPacksTableFilterComposer,
      $$ContentPacksTableOrderingComposer,
      $$ContentPacksTableAnnotationComposer,
      $$ContentPacksTableCreateCompanionBuilder,
      $$ContentPacksTableUpdateCompanionBuilder,
      (ContentPackRow, $$ContentPacksTableReferences),
      ContentPackRow,
      PrefetchHooks Function({
        bool lessonStagesRefs,
        bool quizItemsRefs,
        bool missionLevelsRefs,
        bool quizAttemptsRefs,
      })
    >;
typedef $$LessonStagesTableCreateCompanionBuilder =
    LessonStagesCompanion Function({
      required String stageId,
      Value<String?> packId,
      required String stageName,
      required String moduleKey,
      required int sequenceOrder,
      required String displayTitle,
      required String bodyJson,
      Value<int> rowid,
    });
typedef $$LessonStagesTableUpdateCompanionBuilder =
    LessonStagesCompanion Function({
      Value<String> stageId,
      Value<String?> packId,
      Value<String> stageName,
      Value<String> moduleKey,
      Value<int> sequenceOrder,
      Value<String> displayTitle,
      Value<String> bodyJson,
      Value<int> rowid,
    });

final class $$LessonStagesTableReferences
    extends BaseReferences<_$AppDatabase, $LessonStagesTable, LessonStageRow> {
  $$LessonStagesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ContentPacksTable _packIdTable(_$AppDatabase db) => db.contentPacks
      .createAlias('lesson_stages__pack_id__content_packs__pack_id');

  $$ContentPacksTableProcessedTableManager? get packId {
    final $_column = $_itemColumn<String>('pack_id');
    if ($_column == null) return null;
    final manager = $$ContentPacksTableTableManager(
      $_db,
      $_db.contentPacks,
    ).filter((f) => f.packId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_packIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$QuizItemsTable, List<QuizItemRow>>
  _quizItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.quizItems,
    aliasName: 'lesson_stages__stage_id__quiz_items__stage_id',
  );

  $$QuizItemsTableProcessedTableManager get quizItemsRefs {
    final manager = $$QuizItemsTableTableManager($_db, $_db.quizItems).filter(
      (f) => f.stageId.stageId.sqlEquals($_itemColumn<String>('stage_id')!),
    );

    final cache = $_typedResult.readTableOrNull(_quizItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PredictionLogTable, List<PredictionLogRow>>
  _predictionLogRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.predictionLog,
    aliasName: 'lesson_stages__stage_id__prediction_log__stage_id',
  );

  $$PredictionLogTableProcessedTableManager get predictionLogRefs {
    final manager = $$PredictionLogTableTableManager($_db, $_db.predictionLog)
        .filter(
          (f) => f.stageId.stageId.sqlEquals($_itemColumn<String>('stage_id')!),
        );

    final cache = $_typedResult.readTableOrNull(_predictionLogRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$LessonStagesTableFilterComposer
    extends Composer<_$AppDatabase, $LessonStagesTable> {
  $$LessonStagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get stageId => $composableBuilder(
    column: $table.stageId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get stageName => $composableBuilder(
    column: $table.stageName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get moduleKey => $composableBuilder(
    column: $table.moduleKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sequenceOrder => $composableBuilder(
    column: $table.sequenceOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayTitle => $composableBuilder(
    column: $table.displayTitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bodyJson => $composableBuilder(
    column: $table.bodyJson,
    builder: (column) => ColumnFilters(column),
  );

  $$ContentPacksTableFilterComposer get packId {
    final $$ContentPacksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.packId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableFilterComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> quizItemsRefs(
    Expression<bool> Function($$QuizItemsTableFilterComposer f) f,
  ) {
    final $$QuizItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.stageId,
      referencedTable: $db.quizItems,
      getReferencedColumn: (t) => t.stageId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuizItemsTableFilterComposer(
            $db: $db,
            $table: $db.quizItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> predictionLogRefs(
    Expression<bool> Function($$PredictionLogTableFilterComposer f) f,
  ) {
    final $$PredictionLogTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.stageId,
      referencedTable: $db.predictionLog,
      getReferencedColumn: (t) => t.stageId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PredictionLogTableFilterComposer(
            $db: $db,
            $table: $db.predictionLog,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LessonStagesTableOrderingComposer
    extends Composer<_$AppDatabase, $LessonStagesTable> {
  $$LessonStagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get stageId => $composableBuilder(
    column: $table.stageId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get stageName => $composableBuilder(
    column: $table.stageName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get moduleKey => $composableBuilder(
    column: $table.moduleKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sequenceOrder => $composableBuilder(
    column: $table.sequenceOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayTitle => $composableBuilder(
    column: $table.displayTitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bodyJson => $composableBuilder(
    column: $table.bodyJson,
    builder: (column) => ColumnOrderings(column),
  );

  $$ContentPacksTableOrderingComposer get packId {
    final $$ContentPacksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.packId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableOrderingComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LessonStagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LessonStagesTable> {
  $$LessonStagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get stageId =>
      $composableBuilder(column: $table.stageId, builder: (column) => column);

  GeneratedColumn<String> get stageName =>
      $composableBuilder(column: $table.stageName, builder: (column) => column);

  GeneratedColumn<String> get moduleKey =>
      $composableBuilder(column: $table.moduleKey, builder: (column) => column);

  GeneratedColumn<int> get sequenceOrder => $composableBuilder(
    column: $table.sequenceOrder,
    builder: (column) => column,
  );

  GeneratedColumn<String> get displayTitle => $composableBuilder(
    column: $table.displayTitle,
    builder: (column) => column,
  );

  GeneratedColumn<String> get bodyJson =>
      $composableBuilder(column: $table.bodyJson, builder: (column) => column);

  $$ContentPacksTableAnnotationComposer get packId {
    final $$ContentPacksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.packId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableAnnotationComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> quizItemsRefs<T extends Object>(
    Expression<T> Function($$QuizItemsTableAnnotationComposer a) f,
  ) {
    final $$QuizItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.stageId,
      referencedTable: $db.quizItems,
      getReferencedColumn: (t) => t.stageId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuizItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.quizItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> predictionLogRefs<T extends Object>(
    Expression<T> Function($$PredictionLogTableAnnotationComposer a) f,
  ) {
    final $$PredictionLogTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.stageId,
      referencedTable: $db.predictionLog,
      getReferencedColumn: (t) => t.stageId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PredictionLogTableAnnotationComposer(
            $db: $db,
            $table: $db.predictionLog,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LessonStagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LessonStagesTable,
          LessonStageRow,
          $$LessonStagesTableFilterComposer,
          $$LessonStagesTableOrderingComposer,
          $$LessonStagesTableAnnotationComposer,
          $$LessonStagesTableCreateCompanionBuilder,
          $$LessonStagesTableUpdateCompanionBuilder,
          (LessonStageRow, $$LessonStagesTableReferences),
          LessonStageRow,
          PrefetchHooks Function({
            bool packId,
            bool quizItemsRefs,
            bool predictionLogRefs,
          })
        > {
  $$LessonStagesTableTableManager(_$AppDatabase db, $LessonStagesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LessonStagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LessonStagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LessonStagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> stageId = const Value.absent(),
                Value<String?> packId = const Value.absent(),
                Value<String> stageName = const Value.absent(),
                Value<String> moduleKey = const Value.absent(),
                Value<int> sequenceOrder = const Value.absent(),
                Value<String> displayTitle = const Value.absent(),
                Value<String> bodyJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LessonStagesCompanion(
                stageId: stageId,
                packId: packId,
                stageName: stageName,
                moduleKey: moduleKey,
                sequenceOrder: sequenceOrder,
                displayTitle: displayTitle,
                bodyJson: bodyJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String stageId,
                Value<String?> packId = const Value.absent(),
                required String stageName,
                required String moduleKey,
                required int sequenceOrder,
                required String displayTitle,
                required String bodyJson,
                Value<int> rowid = const Value.absent(),
              }) => LessonStagesCompanion.insert(
                stageId: stageId,
                packId: packId,
                stageName: stageName,
                moduleKey: moduleKey,
                sequenceOrder: sequenceOrder,
                displayTitle: displayTitle,
                bodyJson: bodyJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$LessonStagesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                packId = false,
                quizItemsRefs = false,
                predictionLogRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (quizItemsRefs) db.quizItems,
                    if (predictionLogRefs) db.predictionLog,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (packId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.packId,
                                    referencedTable:
                                        $$LessonStagesTableReferences
                                            ._packIdTable(db),
                                    referencedColumn:
                                        $$LessonStagesTableReferences
                                            ._packIdTable(db)
                                            .packId,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (quizItemsRefs)
                        await $_getPrefetchedData<
                          LessonStageRow,
                          $LessonStagesTable,
                          QuizItemRow
                        >(
                          currentTable: table,
                          referencedTable: $$LessonStagesTableReferences
                              ._quizItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LessonStagesTableReferences(
                                db,
                                table,
                                p0,
                              ).quizItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.stageId == item.stageId,
                              ),
                          typedResults: items,
                        ),
                      if (predictionLogRefs)
                        await $_getPrefetchedData<
                          LessonStageRow,
                          $LessonStagesTable,
                          PredictionLogRow
                        >(
                          currentTable: table,
                          referencedTable: $$LessonStagesTableReferences
                              ._predictionLogRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LessonStagesTableReferences(
                                db,
                                table,
                                p0,
                              ).predictionLogRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.stageId == item.stageId,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$LessonStagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LessonStagesTable,
      LessonStageRow,
      $$LessonStagesTableFilterComposer,
      $$LessonStagesTableOrderingComposer,
      $$LessonStagesTableAnnotationComposer,
      $$LessonStagesTableCreateCompanionBuilder,
      $$LessonStagesTableUpdateCompanionBuilder,
      (LessonStageRow, $$LessonStagesTableReferences),
      LessonStageRow,
      PrefetchHooks Function({
        bool packId,
        bool quizItemsRefs,
        bool predictionLogRefs,
      })
    >;
typedef $$QuizItemsTableCreateCompanionBuilder =
    QuizItemsCompanion Function({
      required String itemId,
      Value<String?> packId,
      Value<String?> stageId,
      required String itemType,
      required String prompt,
      Value<String?> choicesJson,
      required String correctAnswer,
      Value<double?> tolerance,
      Value<String?> explanation,
      Value<String?> tosCompetency,
      Value<String?> difficulty,
      Value<String?> teacherFormula,
      Value<int> rowid,
    });
typedef $$QuizItemsTableUpdateCompanionBuilder =
    QuizItemsCompanion Function({
      Value<String> itemId,
      Value<String?> packId,
      Value<String?> stageId,
      Value<String> itemType,
      Value<String> prompt,
      Value<String?> choicesJson,
      Value<String> correctAnswer,
      Value<double?> tolerance,
      Value<String?> explanation,
      Value<String?> tosCompetency,
      Value<String?> difficulty,
      Value<String?> teacherFormula,
      Value<int> rowid,
    });

final class $$QuizItemsTableReferences
    extends BaseReferences<_$AppDatabase, $QuizItemsTable, QuizItemRow> {
  $$QuizItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ContentPacksTable _packIdTable(_$AppDatabase db) => db.contentPacks
      .createAlias('quiz_items__pack_id__content_packs__pack_id');

  $$ContentPacksTableProcessedTableManager? get packId {
    final $_column = $_itemColumn<String>('pack_id');
    if ($_column == null) return null;
    final manager = $$ContentPacksTableTableManager(
      $_db,
      $_db.contentPacks,
    ).filter((f) => f.packId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_packIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $LessonStagesTable _stageIdTable(_$AppDatabase db) => db.lessonStages
      .createAlias('quiz_items__stage_id__lesson_stages__stage_id');

  $$LessonStagesTableProcessedTableManager? get stageId {
    final $_column = $_itemColumn<String>('stage_id');
    if ($_column == null) return null;
    final manager = $$LessonStagesTableTableManager(
      $_db,
      $_db.lessonStages,
    ).filter((f) => f.stageId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_stageIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$QuizItemResponsesTable, List<QuizItemResponseRow>>
  _quizItemResponsesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.quizItemResponses,
        aliasName: 'quiz_items__item_id__quiz_item_responses__item_id',
      );

  $$QuizItemResponsesTableProcessedTableManager get quizItemResponsesRefs {
    final manager =
        $$QuizItemResponsesTableTableManager(
          $_db,
          $_db.quizItemResponses,
        ).filter(
          (f) => f.itemId.itemId.sqlEquals($_itemColumn<String>('item_id')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _quizItemResponsesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$QuizItemsTableFilterComposer
    extends Composer<_$AppDatabase, $QuizItemsTable> {
  $$QuizItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get itemId => $composableBuilder(
    column: $table.itemId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get itemType => $composableBuilder(
    column: $table.itemType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get prompt => $composableBuilder(
    column: $table.prompt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get choicesJson => $composableBuilder(
    column: $table.choicesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get correctAnswer => $composableBuilder(
    column: $table.correctAnswer,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get tolerance => $composableBuilder(
    column: $table.tolerance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get explanation => $composableBuilder(
    column: $table.explanation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tosCompetency => $composableBuilder(
    column: $table.tosCompetency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get teacherFormula => $composableBuilder(
    column: $table.teacherFormula,
    builder: (column) => ColumnFilters(column),
  );

  $$ContentPacksTableFilterComposer get packId {
    final $$ContentPacksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.packId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableFilterComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LessonStagesTableFilterComposer get stageId {
    final $$LessonStagesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.stageId,
      referencedTable: $db.lessonStages,
      getReferencedColumn: (t) => t.stageId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LessonStagesTableFilterComposer(
            $db: $db,
            $table: $db.lessonStages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> quizItemResponsesRefs(
    Expression<bool> Function($$QuizItemResponsesTableFilterComposer f) f,
  ) {
    final $$QuizItemResponsesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.quizItemResponses,
      getReferencedColumn: (t) => t.itemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuizItemResponsesTableFilterComposer(
            $db: $db,
            $table: $db.quizItemResponses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$QuizItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $QuizItemsTable> {
  $$QuizItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get itemId => $composableBuilder(
    column: $table.itemId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get itemType => $composableBuilder(
    column: $table.itemType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get prompt => $composableBuilder(
    column: $table.prompt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get choicesJson => $composableBuilder(
    column: $table.choicesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get correctAnswer => $composableBuilder(
    column: $table.correctAnswer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get tolerance => $composableBuilder(
    column: $table.tolerance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get explanation => $composableBuilder(
    column: $table.explanation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tosCompetency => $composableBuilder(
    column: $table.tosCompetency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get teacherFormula => $composableBuilder(
    column: $table.teacherFormula,
    builder: (column) => ColumnOrderings(column),
  );

  $$ContentPacksTableOrderingComposer get packId {
    final $$ContentPacksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.packId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableOrderingComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LessonStagesTableOrderingComposer get stageId {
    final $$LessonStagesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.stageId,
      referencedTable: $db.lessonStages,
      getReferencedColumn: (t) => t.stageId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LessonStagesTableOrderingComposer(
            $db: $db,
            $table: $db.lessonStages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$QuizItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuizItemsTable> {
  $$QuizItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get itemId =>
      $composableBuilder(column: $table.itemId, builder: (column) => column);

  GeneratedColumn<String> get itemType =>
      $composableBuilder(column: $table.itemType, builder: (column) => column);

  GeneratedColumn<String> get prompt =>
      $composableBuilder(column: $table.prompt, builder: (column) => column);

  GeneratedColumn<String> get choicesJson => $composableBuilder(
    column: $table.choicesJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get correctAnswer => $composableBuilder(
    column: $table.correctAnswer,
    builder: (column) => column,
  );

  GeneratedColumn<double> get tolerance =>
      $composableBuilder(column: $table.tolerance, builder: (column) => column);

  GeneratedColumn<String> get explanation => $composableBuilder(
    column: $table.explanation,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tosCompetency => $composableBuilder(
    column: $table.tosCompetency,
    builder: (column) => column,
  );

  GeneratedColumn<String> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => column,
  );

  GeneratedColumn<String> get teacherFormula => $composableBuilder(
    column: $table.teacherFormula,
    builder: (column) => column,
  );

  $$ContentPacksTableAnnotationComposer get packId {
    final $$ContentPacksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.packId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableAnnotationComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LessonStagesTableAnnotationComposer get stageId {
    final $$LessonStagesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.stageId,
      referencedTable: $db.lessonStages,
      getReferencedColumn: (t) => t.stageId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LessonStagesTableAnnotationComposer(
            $db: $db,
            $table: $db.lessonStages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> quizItemResponsesRefs<T extends Object>(
    Expression<T> Function($$QuizItemResponsesTableAnnotationComposer a) f,
  ) {
    final $$QuizItemResponsesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.itemId,
          referencedTable: $db.quizItemResponses,
          getReferencedColumn: (t) => t.itemId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$QuizItemResponsesTableAnnotationComposer(
                $db: $db,
                $table: $db.quizItemResponses,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$QuizItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QuizItemsTable,
          QuizItemRow,
          $$QuizItemsTableFilterComposer,
          $$QuizItemsTableOrderingComposer,
          $$QuizItemsTableAnnotationComposer,
          $$QuizItemsTableCreateCompanionBuilder,
          $$QuizItemsTableUpdateCompanionBuilder,
          (QuizItemRow, $$QuizItemsTableReferences),
          QuizItemRow,
          PrefetchHooks Function({
            bool packId,
            bool stageId,
            bool quizItemResponsesRefs,
          })
        > {
  $$QuizItemsTableTableManager(_$AppDatabase db, $QuizItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuizItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuizItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuizItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> itemId = const Value.absent(),
                Value<String?> packId = const Value.absent(),
                Value<String?> stageId = const Value.absent(),
                Value<String> itemType = const Value.absent(),
                Value<String> prompt = const Value.absent(),
                Value<String?> choicesJson = const Value.absent(),
                Value<String> correctAnswer = const Value.absent(),
                Value<double?> tolerance = const Value.absent(),
                Value<String?> explanation = const Value.absent(),
                Value<String?> tosCompetency = const Value.absent(),
                Value<String?> difficulty = const Value.absent(),
                Value<String?> teacherFormula = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => QuizItemsCompanion(
                itemId: itemId,
                packId: packId,
                stageId: stageId,
                itemType: itemType,
                prompt: prompt,
                choicesJson: choicesJson,
                correctAnswer: correctAnswer,
                tolerance: tolerance,
                explanation: explanation,
                tosCompetency: tosCompetency,
                difficulty: difficulty,
                teacherFormula: teacherFormula,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String itemId,
                Value<String?> packId = const Value.absent(),
                Value<String?> stageId = const Value.absent(),
                required String itemType,
                required String prompt,
                Value<String?> choicesJson = const Value.absent(),
                required String correctAnswer,
                Value<double?> tolerance = const Value.absent(),
                Value<String?> explanation = const Value.absent(),
                Value<String?> tosCompetency = const Value.absent(),
                Value<String?> difficulty = const Value.absent(),
                Value<String?> teacherFormula = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => QuizItemsCompanion.insert(
                itemId: itemId,
                packId: packId,
                stageId: stageId,
                itemType: itemType,
                prompt: prompt,
                choicesJson: choicesJson,
                correctAnswer: correctAnswer,
                tolerance: tolerance,
                explanation: explanation,
                tosCompetency: tosCompetency,
                difficulty: difficulty,
                teacherFormula: teacherFormula,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$QuizItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                packId = false,
                stageId = false,
                quizItemResponsesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (quizItemResponsesRefs) db.quizItemResponses,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (packId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.packId,
                                    referencedTable: $$QuizItemsTableReferences
                                        ._packIdTable(db),
                                    referencedColumn: $$QuizItemsTableReferences
                                        ._packIdTable(db)
                                        .packId,
                                  )
                                  as T;
                        }
                        if (stageId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.stageId,
                                    referencedTable: $$QuizItemsTableReferences
                                        ._stageIdTable(db),
                                    referencedColumn: $$QuizItemsTableReferences
                                        ._stageIdTable(db)
                                        .stageId,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (quizItemResponsesRefs)
                        await $_getPrefetchedData<
                          QuizItemRow,
                          $QuizItemsTable,
                          QuizItemResponseRow
                        >(
                          currentTable: table,
                          referencedTable: $$QuizItemsTableReferences
                              ._quizItemResponsesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$QuizItemsTableReferences(
                                db,
                                table,
                                p0,
                              ).quizItemResponsesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.itemId == item.itemId,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$QuizItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QuizItemsTable,
      QuizItemRow,
      $$QuizItemsTableFilterComposer,
      $$QuizItemsTableOrderingComposer,
      $$QuizItemsTableAnnotationComposer,
      $$QuizItemsTableCreateCompanionBuilder,
      $$QuizItemsTableUpdateCompanionBuilder,
      (QuizItemRow, $$QuizItemsTableReferences),
      QuizItemRow,
      PrefetchHooks Function({
        bool packId,
        bool stageId,
        bool quizItemResponsesRefs,
      })
    >;
typedef $$MissionLevelsTableCreateCompanionBuilder =
    MissionLevelsCompanion Function({
      required String levelId,
      Value<String?> packId,
      required int levelNumber,
      required String title,
      required String scenarioText,
      required String givenValues,
      required String targetVariable,
      required double correctAnswer,
      Value<double> tolerance,
      Value<String?> formulaHint,
      Value<String?> unit,
      Value<String?> teacherSolution,
      Value<int> rowid,
    });
typedef $$MissionLevelsTableUpdateCompanionBuilder =
    MissionLevelsCompanion Function({
      Value<String> levelId,
      Value<String?> packId,
      Value<int> levelNumber,
      Value<String> title,
      Value<String> scenarioText,
      Value<String> givenValues,
      Value<String> targetVariable,
      Value<double> correctAnswer,
      Value<double> tolerance,
      Value<String?> formulaHint,
      Value<String?> unit,
      Value<String?> teacherSolution,
      Value<int> rowid,
    });

final class $$MissionLevelsTableReferences
    extends
        BaseReferences<_$AppDatabase, $MissionLevelsTable, MissionLevelRow> {
  $$MissionLevelsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ContentPacksTable _packIdTable(_$AppDatabase db) => db.contentPacks
      .createAlias('mission_levels__pack_id__content_packs__pack_id');

  $$ContentPacksTableProcessedTableManager? get packId {
    final $_column = $_itemColumn<String>('pack_id');
    if ($_column == null) return null;
    final manager = $$ContentPacksTableTableManager(
      $_db,
      $_db.contentPacks,
    ).filter((f) => f.packId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_packIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$MissionAttemptsTable, List<MissionAttemptRow>>
  _missionAttemptsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.missionAttempts,
    aliasName: 'mission_levels__level_id__mission_attempts__level_id',
  );

  $$MissionAttemptsTableProcessedTableManager get missionAttemptsRefs {
    final manager =
        $$MissionAttemptsTableTableManager($_db, $_db.missionAttempts).filter(
          (f) => f.levelId.levelId.sqlEquals($_itemColumn<String>('level_id')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _missionAttemptsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MissionLevelsTableFilterComposer
    extends Composer<_$AppDatabase, $MissionLevelsTable> {
  $$MissionLevelsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get levelId => $composableBuilder(
    column: $table.levelId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get levelNumber => $composableBuilder(
    column: $table.levelNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get scenarioText => $composableBuilder(
    column: $table.scenarioText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get givenValues => $composableBuilder(
    column: $table.givenValues,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetVariable => $composableBuilder(
    column: $table.targetVariable,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get correctAnswer => $composableBuilder(
    column: $table.correctAnswer,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get tolerance => $composableBuilder(
    column: $table.tolerance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get formulaHint => $composableBuilder(
    column: $table.formulaHint,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get teacherSolution => $composableBuilder(
    column: $table.teacherSolution,
    builder: (column) => ColumnFilters(column),
  );

  $$ContentPacksTableFilterComposer get packId {
    final $$ContentPacksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.packId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableFilterComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> missionAttemptsRefs(
    Expression<bool> Function($$MissionAttemptsTableFilterComposer f) f,
  ) {
    final $$MissionAttemptsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.levelId,
      referencedTable: $db.missionAttempts,
      getReferencedColumn: (t) => t.levelId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MissionAttemptsTableFilterComposer(
            $db: $db,
            $table: $db.missionAttempts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MissionLevelsTableOrderingComposer
    extends Composer<_$AppDatabase, $MissionLevelsTable> {
  $$MissionLevelsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get levelId => $composableBuilder(
    column: $table.levelId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get levelNumber => $composableBuilder(
    column: $table.levelNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scenarioText => $composableBuilder(
    column: $table.scenarioText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get givenValues => $composableBuilder(
    column: $table.givenValues,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetVariable => $composableBuilder(
    column: $table.targetVariable,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get correctAnswer => $composableBuilder(
    column: $table.correctAnswer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get tolerance => $composableBuilder(
    column: $table.tolerance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get formulaHint => $composableBuilder(
    column: $table.formulaHint,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get teacherSolution => $composableBuilder(
    column: $table.teacherSolution,
    builder: (column) => ColumnOrderings(column),
  );

  $$ContentPacksTableOrderingComposer get packId {
    final $$ContentPacksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.packId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableOrderingComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MissionLevelsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MissionLevelsTable> {
  $$MissionLevelsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get levelId =>
      $composableBuilder(column: $table.levelId, builder: (column) => column);

  GeneratedColumn<int> get levelNumber => $composableBuilder(
    column: $table.levelNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get scenarioText => $composableBuilder(
    column: $table.scenarioText,
    builder: (column) => column,
  );

  GeneratedColumn<String> get givenValues => $composableBuilder(
    column: $table.givenValues,
    builder: (column) => column,
  );

  GeneratedColumn<String> get targetVariable => $composableBuilder(
    column: $table.targetVariable,
    builder: (column) => column,
  );

  GeneratedColumn<double> get correctAnswer => $composableBuilder(
    column: $table.correctAnswer,
    builder: (column) => column,
  );

  GeneratedColumn<double> get tolerance =>
      $composableBuilder(column: $table.tolerance, builder: (column) => column);

  GeneratedColumn<String> get formulaHint => $composableBuilder(
    column: $table.formulaHint,
    builder: (column) => column,
  );

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<String> get teacherSolution => $composableBuilder(
    column: $table.teacherSolution,
    builder: (column) => column,
  );

  $$ContentPacksTableAnnotationComposer get packId {
    final $$ContentPacksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.packId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableAnnotationComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> missionAttemptsRefs<T extends Object>(
    Expression<T> Function($$MissionAttemptsTableAnnotationComposer a) f,
  ) {
    final $$MissionAttemptsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.levelId,
      referencedTable: $db.missionAttempts,
      getReferencedColumn: (t) => t.levelId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MissionAttemptsTableAnnotationComposer(
            $db: $db,
            $table: $db.missionAttempts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MissionLevelsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MissionLevelsTable,
          MissionLevelRow,
          $$MissionLevelsTableFilterComposer,
          $$MissionLevelsTableOrderingComposer,
          $$MissionLevelsTableAnnotationComposer,
          $$MissionLevelsTableCreateCompanionBuilder,
          $$MissionLevelsTableUpdateCompanionBuilder,
          (MissionLevelRow, $$MissionLevelsTableReferences),
          MissionLevelRow,
          PrefetchHooks Function({bool packId, bool missionAttemptsRefs})
        > {
  $$MissionLevelsTableTableManager(_$AppDatabase db, $MissionLevelsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MissionLevelsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MissionLevelsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MissionLevelsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> levelId = const Value.absent(),
                Value<String?> packId = const Value.absent(),
                Value<int> levelNumber = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> scenarioText = const Value.absent(),
                Value<String> givenValues = const Value.absent(),
                Value<String> targetVariable = const Value.absent(),
                Value<double> correctAnswer = const Value.absent(),
                Value<double> tolerance = const Value.absent(),
                Value<String?> formulaHint = const Value.absent(),
                Value<String?> unit = const Value.absent(),
                Value<String?> teacherSolution = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MissionLevelsCompanion(
                levelId: levelId,
                packId: packId,
                levelNumber: levelNumber,
                title: title,
                scenarioText: scenarioText,
                givenValues: givenValues,
                targetVariable: targetVariable,
                correctAnswer: correctAnswer,
                tolerance: tolerance,
                formulaHint: formulaHint,
                unit: unit,
                teacherSolution: teacherSolution,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String levelId,
                Value<String?> packId = const Value.absent(),
                required int levelNumber,
                required String title,
                required String scenarioText,
                required String givenValues,
                required String targetVariable,
                required double correctAnswer,
                Value<double> tolerance = const Value.absent(),
                Value<String?> formulaHint = const Value.absent(),
                Value<String?> unit = const Value.absent(),
                Value<String?> teacherSolution = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MissionLevelsCompanion.insert(
                levelId: levelId,
                packId: packId,
                levelNumber: levelNumber,
                title: title,
                scenarioText: scenarioText,
                givenValues: givenValues,
                targetVariable: targetVariable,
                correctAnswer: correctAnswer,
                tolerance: tolerance,
                formulaHint: formulaHint,
                unit: unit,
                teacherSolution: teacherSolution,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MissionLevelsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({packId = false, missionAttemptsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (missionAttemptsRefs) db.missionAttempts,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (packId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.packId,
                                    referencedTable:
                                        $$MissionLevelsTableReferences
                                            ._packIdTable(db),
                                    referencedColumn:
                                        $$MissionLevelsTableReferences
                                            ._packIdTable(db)
                                            .packId,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (missionAttemptsRefs)
                        await $_getPrefetchedData<
                          MissionLevelRow,
                          $MissionLevelsTable,
                          MissionAttemptRow
                        >(
                          currentTable: table,
                          referencedTable: $$MissionLevelsTableReferences
                              ._missionAttemptsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MissionLevelsTableReferences(
                                db,
                                table,
                                p0,
                              ).missionAttemptsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.levelId == item.levelId,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$MissionLevelsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MissionLevelsTable,
      MissionLevelRow,
      $$MissionLevelsTableFilterComposer,
      $$MissionLevelsTableOrderingComposer,
      $$MissionLevelsTableAnnotationComposer,
      $$MissionLevelsTableCreateCompanionBuilder,
      $$MissionLevelsTableUpdateCompanionBuilder,
      (MissionLevelRow, $$MissionLevelsTableReferences),
      MissionLevelRow,
      PrefetchHooks Function({bool packId, bool missionAttemptsRefs})
    >;
typedef $$PredictionLogTableCreateCompanionBuilder =
    PredictionLogCompanion Function({
      required String logId,
      Value<String?> userId,
      Value<String?> stageId,
      required String predictedOption,
      Value<String?> reasoningKey,
      required int submittedAt,
      Value<int> rowid,
    });
typedef $$PredictionLogTableUpdateCompanionBuilder =
    PredictionLogCompanion Function({
      Value<String> logId,
      Value<String?> userId,
      Value<String?> stageId,
      Value<String> predictedOption,
      Value<String?> reasoningKey,
      Value<int> submittedAt,
      Value<int> rowid,
    });

final class $$PredictionLogTableReferences
    extends
        BaseReferences<_$AppDatabase, $PredictionLogTable, PredictionLogRow> {
  $$PredictionLogTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $UsersTable _userIdTable(_$AppDatabase db) =>
      db.users.createAlias('prediction_log__user_id__users__user_id');

  $$UsersTableProcessedTableManager? get userId {
    final $_column = $_itemColumn<String>('user_id');
    if ($_column == null) return null;
    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.userId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $LessonStagesTable _stageIdTable(_$AppDatabase db) => db.lessonStages
      .createAlias('prediction_log__stage_id__lesson_stages__stage_id');

  $$LessonStagesTableProcessedTableManager? get stageId {
    final $_column = $_itemColumn<String>('stage_id');
    if ($_column == null) return null;
    final manager = $$LessonStagesTableTableManager(
      $_db,
      $_db.lessonStages,
    ).filter((f) => f.stageId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_stageIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PredictionLogTableFilterComposer
    extends Composer<_$AppDatabase, $PredictionLogTable> {
  $$PredictionLogTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get logId => $composableBuilder(
    column: $table.logId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get predictedOption => $composableBuilder(
    column: $table.predictedOption,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reasoningKey => $composableBuilder(
    column: $table.reasoningKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get submittedAt => $composableBuilder(
    column: $table.submittedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LessonStagesTableFilterComposer get stageId {
    final $$LessonStagesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.stageId,
      referencedTable: $db.lessonStages,
      getReferencedColumn: (t) => t.stageId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LessonStagesTableFilterComposer(
            $db: $db,
            $table: $db.lessonStages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PredictionLogTableOrderingComposer
    extends Composer<_$AppDatabase, $PredictionLogTable> {
  $$PredictionLogTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get logId => $composableBuilder(
    column: $table.logId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get predictedOption => $composableBuilder(
    column: $table.predictedOption,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reasoningKey => $composableBuilder(
    column: $table.reasoningKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get submittedAt => $composableBuilder(
    column: $table.submittedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LessonStagesTableOrderingComposer get stageId {
    final $$LessonStagesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.stageId,
      referencedTable: $db.lessonStages,
      getReferencedColumn: (t) => t.stageId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LessonStagesTableOrderingComposer(
            $db: $db,
            $table: $db.lessonStages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PredictionLogTableAnnotationComposer
    extends Composer<_$AppDatabase, $PredictionLogTable> {
  $$PredictionLogTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get logId =>
      $composableBuilder(column: $table.logId, builder: (column) => column);

  GeneratedColumn<String> get predictedOption => $composableBuilder(
    column: $table.predictedOption,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reasoningKey => $composableBuilder(
    column: $table.reasoningKey,
    builder: (column) => column,
  );

  GeneratedColumn<int> get submittedAt => $composableBuilder(
    column: $table.submittedAt,
    builder: (column) => column,
  );

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LessonStagesTableAnnotationComposer get stageId {
    final $$LessonStagesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.stageId,
      referencedTable: $db.lessonStages,
      getReferencedColumn: (t) => t.stageId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LessonStagesTableAnnotationComposer(
            $db: $db,
            $table: $db.lessonStages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PredictionLogTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PredictionLogTable,
          PredictionLogRow,
          $$PredictionLogTableFilterComposer,
          $$PredictionLogTableOrderingComposer,
          $$PredictionLogTableAnnotationComposer,
          $$PredictionLogTableCreateCompanionBuilder,
          $$PredictionLogTableUpdateCompanionBuilder,
          (PredictionLogRow, $$PredictionLogTableReferences),
          PredictionLogRow,
          PrefetchHooks Function({bool userId, bool stageId})
        > {
  $$PredictionLogTableTableManager(_$AppDatabase db, $PredictionLogTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PredictionLogTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PredictionLogTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PredictionLogTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> logId = const Value.absent(),
                Value<String?> userId = const Value.absent(),
                Value<String?> stageId = const Value.absent(),
                Value<String> predictedOption = const Value.absent(),
                Value<String?> reasoningKey = const Value.absent(),
                Value<int> submittedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PredictionLogCompanion(
                logId: logId,
                userId: userId,
                stageId: stageId,
                predictedOption: predictedOption,
                reasoningKey: reasoningKey,
                submittedAt: submittedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String logId,
                Value<String?> userId = const Value.absent(),
                Value<String?> stageId = const Value.absent(),
                required String predictedOption,
                Value<String?> reasoningKey = const Value.absent(),
                required int submittedAt,
                Value<int> rowid = const Value.absent(),
              }) => PredictionLogCompanion.insert(
                logId: logId,
                userId: userId,
                stageId: stageId,
                predictedOption: predictedOption,
                reasoningKey: reasoningKey,
                submittedAt: submittedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PredictionLogTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({userId = false, stageId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (userId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.userId,
                                referencedTable: $$PredictionLogTableReferences
                                    ._userIdTable(db),
                                referencedColumn: $$PredictionLogTableReferences
                                    ._userIdTable(db)
                                    .userId,
                              )
                              as T;
                    }
                    if (stageId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.stageId,
                                referencedTable: $$PredictionLogTableReferences
                                    ._stageIdTable(db),
                                referencedColumn: $$PredictionLogTableReferences
                                    ._stageIdTable(db)
                                    .stageId,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PredictionLogTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PredictionLogTable,
      PredictionLogRow,
      $$PredictionLogTableFilterComposer,
      $$PredictionLogTableOrderingComposer,
      $$PredictionLogTableAnnotationComposer,
      $$PredictionLogTableCreateCompanionBuilder,
      $$PredictionLogTableUpdateCompanionBuilder,
      (PredictionLogRow, $$PredictionLogTableReferences),
      PredictionLogRow,
      PrefetchHooks Function({bool userId, bool stageId})
    >;
typedef $$MotionTrialsTableCreateCompanionBuilder =
    MotionTrialsCompanion Function({
      required String trialId,
      Value<String?> userId,
      Value<String?> groupId,
      required int trialNumber,
      required double distanceM,
      required double displacementM,
      required double timeS,
      Value<double?> computedSpeed,
      Value<double?> computedVelocity,
      required int recordedAt,
      Value<int> rowid,
    });
typedef $$MotionTrialsTableUpdateCompanionBuilder =
    MotionTrialsCompanion Function({
      Value<String> trialId,
      Value<String?> userId,
      Value<String?> groupId,
      Value<int> trialNumber,
      Value<double> distanceM,
      Value<double> displacementM,
      Value<double> timeS,
      Value<double?> computedSpeed,
      Value<double?> computedVelocity,
      Value<int> recordedAt,
      Value<int> rowid,
    });

final class $$MotionTrialsTableReferences
    extends BaseReferences<_$AppDatabase, $MotionTrialsTable, MotionTrialRow> {
  $$MotionTrialsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UsersTable _userIdTable(_$AppDatabase db) =>
      db.users.createAlias('motion_trials__user_id__users__user_id');

  $$UsersTableProcessedTableManager? get userId {
    final $_column = $_itemColumn<String>('user_id');
    if ($_column == null) return null;
    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.userId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MotionTrialsTableFilterComposer
    extends Composer<_$AppDatabase, $MotionTrialsTable> {
  $$MotionTrialsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get trialId => $composableBuilder(
    column: $table.trialId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get groupId => $composableBuilder(
    column: $table.groupId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get trialNumber => $composableBuilder(
    column: $table.trialNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get distanceM => $composableBuilder(
    column: $table.distanceM,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get displacementM => $composableBuilder(
    column: $table.displacementM,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get timeS => $composableBuilder(
    column: $table.timeS,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get computedSpeed => $composableBuilder(
    column: $table.computedSpeed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get computedVelocity => $composableBuilder(
    column: $table.computedVelocity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MotionTrialsTableOrderingComposer
    extends Composer<_$AppDatabase, $MotionTrialsTable> {
  $$MotionTrialsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get trialId => $composableBuilder(
    column: $table.trialId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get groupId => $composableBuilder(
    column: $table.groupId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get trialNumber => $composableBuilder(
    column: $table.trialNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get distanceM => $composableBuilder(
    column: $table.distanceM,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get displacementM => $composableBuilder(
    column: $table.displacementM,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get timeS => $composableBuilder(
    column: $table.timeS,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get computedSpeed => $composableBuilder(
    column: $table.computedSpeed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get computedVelocity => $composableBuilder(
    column: $table.computedVelocity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MotionTrialsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MotionTrialsTable> {
  $$MotionTrialsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get trialId =>
      $composableBuilder(column: $table.trialId, builder: (column) => column);

  GeneratedColumn<String> get groupId =>
      $composableBuilder(column: $table.groupId, builder: (column) => column);

  GeneratedColumn<int> get trialNumber => $composableBuilder(
    column: $table.trialNumber,
    builder: (column) => column,
  );

  GeneratedColumn<double> get distanceM =>
      $composableBuilder(column: $table.distanceM, builder: (column) => column);

  GeneratedColumn<double> get displacementM => $composableBuilder(
    column: $table.displacementM,
    builder: (column) => column,
  );

  GeneratedColumn<double> get timeS =>
      $composableBuilder(column: $table.timeS, builder: (column) => column);

  GeneratedColumn<double> get computedSpeed => $composableBuilder(
    column: $table.computedSpeed,
    builder: (column) => column,
  );

  GeneratedColumn<double> get computedVelocity => $composableBuilder(
    column: $table.computedVelocity,
    builder: (column) => column,
  );

  GeneratedColumn<int> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => column,
  );

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MotionTrialsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MotionTrialsTable,
          MotionTrialRow,
          $$MotionTrialsTableFilterComposer,
          $$MotionTrialsTableOrderingComposer,
          $$MotionTrialsTableAnnotationComposer,
          $$MotionTrialsTableCreateCompanionBuilder,
          $$MotionTrialsTableUpdateCompanionBuilder,
          (MotionTrialRow, $$MotionTrialsTableReferences),
          MotionTrialRow,
          PrefetchHooks Function({bool userId})
        > {
  $$MotionTrialsTableTableManager(_$AppDatabase db, $MotionTrialsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MotionTrialsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MotionTrialsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MotionTrialsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> trialId = const Value.absent(),
                Value<String?> userId = const Value.absent(),
                Value<String?> groupId = const Value.absent(),
                Value<int> trialNumber = const Value.absent(),
                Value<double> distanceM = const Value.absent(),
                Value<double> displacementM = const Value.absent(),
                Value<double> timeS = const Value.absent(),
                Value<double?> computedSpeed = const Value.absent(),
                Value<double?> computedVelocity = const Value.absent(),
                Value<int> recordedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MotionTrialsCompanion(
                trialId: trialId,
                userId: userId,
                groupId: groupId,
                trialNumber: trialNumber,
                distanceM: distanceM,
                displacementM: displacementM,
                timeS: timeS,
                computedSpeed: computedSpeed,
                computedVelocity: computedVelocity,
                recordedAt: recordedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String trialId,
                Value<String?> userId = const Value.absent(),
                Value<String?> groupId = const Value.absent(),
                required int trialNumber,
                required double distanceM,
                required double displacementM,
                required double timeS,
                Value<double?> computedSpeed = const Value.absent(),
                Value<double?> computedVelocity = const Value.absent(),
                required int recordedAt,
                Value<int> rowid = const Value.absent(),
              }) => MotionTrialsCompanion.insert(
                trialId: trialId,
                userId: userId,
                groupId: groupId,
                trialNumber: trialNumber,
                distanceM: distanceM,
                displacementM: displacementM,
                timeS: timeS,
                computedSpeed: computedSpeed,
                computedVelocity: computedVelocity,
                recordedAt: recordedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MotionTrialsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({userId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (userId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.userId,
                                referencedTable: $$MotionTrialsTableReferences
                                    ._userIdTable(db),
                                referencedColumn: $$MotionTrialsTableReferences
                                    ._userIdTable(db)
                                    .userId,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MotionTrialsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MotionTrialsTable,
      MotionTrialRow,
      $$MotionTrialsTableFilterComposer,
      $$MotionTrialsTableOrderingComposer,
      $$MotionTrialsTableAnnotationComposer,
      $$MotionTrialsTableCreateCompanionBuilder,
      $$MotionTrialsTableUpdateCompanionBuilder,
      (MotionTrialRow, $$MotionTrialsTableReferences),
      MotionTrialRow,
      PrefetchHooks Function({bool userId})
    >;
typedef $$MissionAttemptsTableCreateCompanionBuilder =
    MissionAttemptsCompanion Function({
      required String attemptId,
      Value<String?> userId,
      Value<String?> levelId,
      required double submittedAnswer,
      required bool isCorrect,
      required int attemptNumber,
      Value<int> pointsAwarded,
      required int submittedAt,
      Value<int> rowid,
    });
typedef $$MissionAttemptsTableUpdateCompanionBuilder =
    MissionAttemptsCompanion Function({
      Value<String> attemptId,
      Value<String?> userId,
      Value<String?> levelId,
      Value<double> submittedAnswer,
      Value<bool> isCorrect,
      Value<int> attemptNumber,
      Value<int> pointsAwarded,
      Value<int> submittedAt,
      Value<int> rowid,
    });

final class $$MissionAttemptsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $MissionAttemptsTable,
          MissionAttemptRow
        > {
  $$MissionAttemptsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $UsersTable _userIdTable(_$AppDatabase db) =>
      db.users.createAlias('mission_attempts__user_id__users__user_id');

  $$UsersTableProcessedTableManager? get userId {
    final $_column = $_itemColumn<String>('user_id');
    if ($_column == null) return null;
    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.userId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $MissionLevelsTable _levelIdTable(_$AppDatabase db) => db.missionLevels
      .createAlias('mission_attempts__level_id__mission_levels__level_id');

  $$MissionLevelsTableProcessedTableManager? get levelId {
    final $_column = $_itemColumn<String>('level_id');
    if ($_column == null) return null;
    final manager = $$MissionLevelsTableTableManager(
      $_db,
      $_db.missionLevels,
    ).filter((f) => f.levelId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_levelIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MissionAttemptsTableFilterComposer
    extends Composer<_$AppDatabase, $MissionAttemptsTable> {
  $$MissionAttemptsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get attemptId => $composableBuilder(
    column: $table.attemptId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get submittedAnswer => $composableBuilder(
    column: $table.submittedAnswer,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCorrect => $composableBuilder(
    column: $table.isCorrect,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attemptNumber => $composableBuilder(
    column: $table.attemptNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pointsAwarded => $composableBuilder(
    column: $table.pointsAwarded,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get submittedAt => $composableBuilder(
    column: $table.submittedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MissionLevelsTableFilterComposer get levelId {
    final $$MissionLevelsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.levelId,
      referencedTable: $db.missionLevels,
      getReferencedColumn: (t) => t.levelId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MissionLevelsTableFilterComposer(
            $db: $db,
            $table: $db.missionLevels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MissionAttemptsTableOrderingComposer
    extends Composer<_$AppDatabase, $MissionAttemptsTable> {
  $$MissionAttemptsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get attemptId => $composableBuilder(
    column: $table.attemptId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get submittedAnswer => $composableBuilder(
    column: $table.submittedAnswer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCorrect => $composableBuilder(
    column: $table.isCorrect,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attemptNumber => $composableBuilder(
    column: $table.attemptNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pointsAwarded => $composableBuilder(
    column: $table.pointsAwarded,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get submittedAt => $composableBuilder(
    column: $table.submittedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MissionLevelsTableOrderingComposer get levelId {
    final $$MissionLevelsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.levelId,
      referencedTable: $db.missionLevels,
      getReferencedColumn: (t) => t.levelId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MissionLevelsTableOrderingComposer(
            $db: $db,
            $table: $db.missionLevels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MissionAttemptsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MissionAttemptsTable> {
  $$MissionAttemptsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get attemptId =>
      $composableBuilder(column: $table.attemptId, builder: (column) => column);

  GeneratedColumn<double> get submittedAnswer => $composableBuilder(
    column: $table.submittedAnswer,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isCorrect =>
      $composableBuilder(column: $table.isCorrect, builder: (column) => column);

  GeneratedColumn<int> get attemptNumber => $composableBuilder(
    column: $table.attemptNumber,
    builder: (column) => column,
  );

  GeneratedColumn<int> get pointsAwarded => $composableBuilder(
    column: $table.pointsAwarded,
    builder: (column) => column,
  );

  GeneratedColumn<int> get submittedAt => $composableBuilder(
    column: $table.submittedAt,
    builder: (column) => column,
  );

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MissionLevelsTableAnnotationComposer get levelId {
    final $$MissionLevelsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.levelId,
      referencedTable: $db.missionLevels,
      getReferencedColumn: (t) => t.levelId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MissionLevelsTableAnnotationComposer(
            $db: $db,
            $table: $db.missionLevels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MissionAttemptsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MissionAttemptsTable,
          MissionAttemptRow,
          $$MissionAttemptsTableFilterComposer,
          $$MissionAttemptsTableOrderingComposer,
          $$MissionAttemptsTableAnnotationComposer,
          $$MissionAttemptsTableCreateCompanionBuilder,
          $$MissionAttemptsTableUpdateCompanionBuilder,
          (MissionAttemptRow, $$MissionAttemptsTableReferences),
          MissionAttemptRow,
          PrefetchHooks Function({bool userId, bool levelId})
        > {
  $$MissionAttemptsTableTableManager(
    _$AppDatabase db,
    $MissionAttemptsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MissionAttemptsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MissionAttemptsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MissionAttemptsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> attemptId = const Value.absent(),
                Value<String?> userId = const Value.absent(),
                Value<String?> levelId = const Value.absent(),
                Value<double> submittedAnswer = const Value.absent(),
                Value<bool> isCorrect = const Value.absent(),
                Value<int> attemptNumber = const Value.absent(),
                Value<int> pointsAwarded = const Value.absent(),
                Value<int> submittedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MissionAttemptsCompanion(
                attemptId: attemptId,
                userId: userId,
                levelId: levelId,
                submittedAnswer: submittedAnswer,
                isCorrect: isCorrect,
                attemptNumber: attemptNumber,
                pointsAwarded: pointsAwarded,
                submittedAt: submittedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String attemptId,
                Value<String?> userId = const Value.absent(),
                Value<String?> levelId = const Value.absent(),
                required double submittedAnswer,
                required bool isCorrect,
                required int attemptNumber,
                Value<int> pointsAwarded = const Value.absent(),
                required int submittedAt,
                Value<int> rowid = const Value.absent(),
              }) => MissionAttemptsCompanion.insert(
                attemptId: attemptId,
                userId: userId,
                levelId: levelId,
                submittedAnswer: submittedAnswer,
                isCorrect: isCorrect,
                attemptNumber: attemptNumber,
                pointsAwarded: pointsAwarded,
                submittedAt: submittedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MissionAttemptsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({userId = false, levelId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (userId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.userId,
                                referencedTable:
                                    $$MissionAttemptsTableReferences
                                        ._userIdTable(db),
                                referencedColumn:
                                    $$MissionAttemptsTableReferences
                                        ._userIdTable(db)
                                        .userId,
                              )
                              as T;
                    }
                    if (levelId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.levelId,
                                referencedTable:
                                    $$MissionAttemptsTableReferences
                                        ._levelIdTable(db),
                                referencedColumn:
                                    $$MissionAttemptsTableReferences
                                        ._levelIdTable(db)
                                        .levelId,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MissionAttemptsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MissionAttemptsTable,
      MissionAttemptRow,
      $$MissionAttemptsTableFilterComposer,
      $$MissionAttemptsTableOrderingComposer,
      $$MissionAttemptsTableAnnotationComposer,
      $$MissionAttemptsTableCreateCompanionBuilder,
      $$MissionAttemptsTableUpdateCompanionBuilder,
      (MissionAttemptRow, $$MissionAttemptsTableReferences),
      MissionAttemptRow,
      PrefetchHooks Function({bool userId, bool levelId})
    >;
typedef $$QuizAttemptsTableCreateCompanionBuilder =
    QuizAttemptsCompanion Function({
      required String attemptId,
      Value<String?> userId,
      Value<String?> packId,
      Value<String?> attemptType,
      required int startedAt,
      Value<int?> completedAt,
      Value<double?> totalScore,
      Value<double?> maxScore,
      Value<int> rowid,
    });
typedef $$QuizAttemptsTableUpdateCompanionBuilder =
    QuizAttemptsCompanion Function({
      Value<String> attemptId,
      Value<String?> userId,
      Value<String?> packId,
      Value<String?> attemptType,
      Value<int> startedAt,
      Value<int?> completedAt,
      Value<double?> totalScore,
      Value<double?> maxScore,
      Value<int> rowid,
    });

final class $$QuizAttemptsTableReferences
    extends BaseReferences<_$AppDatabase, $QuizAttemptsTable, QuizAttemptRow> {
  $$QuizAttemptsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UsersTable _userIdTable(_$AppDatabase db) =>
      db.users.createAlias('quiz_attempts__user_id__users__user_id');

  $$UsersTableProcessedTableManager? get userId {
    final $_column = $_itemColumn<String>('user_id');
    if ($_column == null) return null;
    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.userId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ContentPacksTable _packIdTable(_$AppDatabase db) => db.contentPacks
      .createAlias('quiz_attempts__pack_id__content_packs__pack_id');

  $$ContentPacksTableProcessedTableManager? get packId {
    final $_column = $_itemColumn<String>('pack_id');
    if ($_column == null) return null;
    final manager = $$ContentPacksTableTableManager(
      $_db,
      $_db.contentPacks,
    ).filter((f) => f.packId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_packIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$QuizItemResponsesTable, List<QuizItemResponseRow>>
  _quizItemResponsesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.quizItemResponses,
        aliasName: 'quiz_attempts__attempt_id__quiz_item_responses__attempt_id',
      );

  $$QuizItemResponsesTableProcessedTableManager get quizItemResponsesRefs {
    final manager =
        $$QuizItemResponsesTableTableManager(
          $_db,
          $_db.quizItemResponses,
        ).filter(
          (f) => f.attemptId.attemptId.sqlEquals(
            $_itemColumn<String>('attempt_id')!,
          ),
        );

    final cache = $_typedResult.readTableOrNull(
      _quizItemResponsesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$QuizAttemptsTableFilterComposer
    extends Composer<_$AppDatabase, $QuizAttemptsTable> {
  $$QuizAttemptsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get attemptId => $composableBuilder(
    column: $table.attemptId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get attemptType => $composableBuilder(
    column: $table.attemptType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalScore => $composableBuilder(
    column: $table.totalScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get maxScore => $composableBuilder(
    column: $table.maxScore,
    builder: (column) => ColumnFilters(column),
  );

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ContentPacksTableFilterComposer get packId {
    final $$ContentPacksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.packId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableFilterComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> quizItemResponsesRefs(
    Expression<bool> Function($$QuizItemResponsesTableFilterComposer f) f,
  ) {
    final $$QuizItemResponsesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.attemptId,
      referencedTable: $db.quizItemResponses,
      getReferencedColumn: (t) => t.attemptId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuizItemResponsesTableFilterComposer(
            $db: $db,
            $table: $db.quizItemResponses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$QuizAttemptsTableOrderingComposer
    extends Composer<_$AppDatabase, $QuizAttemptsTable> {
  $$QuizAttemptsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get attemptId => $composableBuilder(
    column: $table.attemptId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get attemptType => $composableBuilder(
    column: $table.attemptType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalScore => $composableBuilder(
    column: $table.totalScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get maxScore => $composableBuilder(
    column: $table.maxScore,
    builder: (column) => ColumnOrderings(column),
  );

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ContentPacksTableOrderingComposer get packId {
    final $$ContentPacksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.packId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableOrderingComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$QuizAttemptsTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuizAttemptsTable> {
  $$QuizAttemptsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get attemptId =>
      $composableBuilder(column: $table.attemptId, builder: (column) => column);

  GeneratedColumn<String> get attemptType => $composableBuilder(
    column: $table.attemptType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<int> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalScore => $composableBuilder(
    column: $table.totalScore,
    builder: (column) => column,
  );

  GeneratedColumn<double> get maxScore =>
      $composableBuilder(column: $table.maxScore, builder: (column) => column);

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ContentPacksTableAnnotationComposer get packId {
    final $$ContentPacksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.packId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableAnnotationComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> quizItemResponsesRefs<T extends Object>(
    Expression<T> Function($$QuizItemResponsesTableAnnotationComposer a) f,
  ) {
    final $$QuizItemResponsesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.attemptId,
          referencedTable: $db.quizItemResponses,
          getReferencedColumn: (t) => t.attemptId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$QuizItemResponsesTableAnnotationComposer(
                $db: $db,
                $table: $db.quizItemResponses,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$QuizAttemptsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QuizAttemptsTable,
          QuizAttemptRow,
          $$QuizAttemptsTableFilterComposer,
          $$QuizAttemptsTableOrderingComposer,
          $$QuizAttemptsTableAnnotationComposer,
          $$QuizAttemptsTableCreateCompanionBuilder,
          $$QuizAttemptsTableUpdateCompanionBuilder,
          (QuizAttemptRow, $$QuizAttemptsTableReferences),
          QuizAttemptRow,
          PrefetchHooks Function({
            bool userId,
            bool packId,
            bool quizItemResponsesRefs,
          })
        > {
  $$QuizAttemptsTableTableManager(_$AppDatabase db, $QuizAttemptsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuizAttemptsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuizAttemptsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuizAttemptsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> attemptId = const Value.absent(),
                Value<String?> userId = const Value.absent(),
                Value<String?> packId = const Value.absent(),
                Value<String?> attemptType = const Value.absent(),
                Value<int> startedAt = const Value.absent(),
                Value<int?> completedAt = const Value.absent(),
                Value<double?> totalScore = const Value.absent(),
                Value<double?> maxScore = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => QuizAttemptsCompanion(
                attemptId: attemptId,
                userId: userId,
                packId: packId,
                attemptType: attemptType,
                startedAt: startedAt,
                completedAt: completedAt,
                totalScore: totalScore,
                maxScore: maxScore,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String attemptId,
                Value<String?> userId = const Value.absent(),
                Value<String?> packId = const Value.absent(),
                Value<String?> attemptType = const Value.absent(),
                required int startedAt,
                Value<int?> completedAt = const Value.absent(),
                Value<double?> totalScore = const Value.absent(),
                Value<double?> maxScore = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => QuizAttemptsCompanion.insert(
                attemptId: attemptId,
                userId: userId,
                packId: packId,
                attemptType: attemptType,
                startedAt: startedAt,
                completedAt: completedAt,
                totalScore: totalScore,
                maxScore: maxScore,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$QuizAttemptsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                userId = false,
                packId = false,
                quizItemResponsesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (quizItemResponsesRefs) db.quizItemResponses,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (userId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.userId,
                                    referencedTable:
                                        $$QuizAttemptsTableReferences
                                            ._userIdTable(db),
                                    referencedColumn:
                                        $$QuizAttemptsTableReferences
                                            ._userIdTable(db)
                                            .userId,
                                  )
                                  as T;
                        }
                        if (packId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.packId,
                                    referencedTable:
                                        $$QuizAttemptsTableReferences
                                            ._packIdTable(db),
                                    referencedColumn:
                                        $$QuizAttemptsTableReferences
                                            ._packIdTable(db)
                                            .packId,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (quizItemResponsesRefs)
                        await $_getPrefetchedData<
                          QuizAttemptRow,
                          $QuizAttemptsTable,
                          QuizItemResponseRow
                        >(
                          currentTable: table,
                          referencedTable: $$QuizAttemptsTableReferences
                              ._quizItemResponsesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$QuizAttemptsTableReferences(
                                db,
                                table,
                                p0,
                              ).quizItemResponsesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.attemptId == item.attemptId,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$QuizAttemptsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QuizAttemptsTable,
      QuizAttemptRow,
      $$QuizAttemptsTableFilterComposer,
      $$QuizAttemptsTableOrderingComposer,
      $$QuizAttemptsTableAnnotationComposer,
      $$QuizAttemptsTableCreateCompanionBuilder,
      $$QuizAttemptsTableUpdateCompanionBuilder,
      (QuizAttemptRow, $$QuizAttemptsTableReferences),
      QuizAttemptRow,
      PrefetchHooks Function({
        bool userId,
        bool packId,
        bool quizItemResponsesRefs,
      })
    >;
typedef $$QuizItemResponsesTableCreateCompanionBuilder =
    QuizItemResponsesCompanion Function({
      required String responseId,
      Value<String?> attemptId,
      Value<String?> itemId,
      required String givenAnswer,
      required bool isCorrect,
      Value<int?> timeSpentMs,
      required int answeredAt,
      Value<int> rowid,
    });
typedef $$QuizItemResponsesTableUpdateCompanionBuilder =
    QuizItemResponsesCompanion Function({
      Value<String> responseId,
      Value<String?> attemptId,
      Value<String?> itemId,
      Value<String> givenAnswer,
      Value<bool> isCorrect,
      Value<int?> timeSpentMs,
      Value<int> answeredAt,
      Value<int> rowid,
    });

final class $$QuizItemResponsesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $QuizItemResponsesTable,
          QuizItemResponseRow
        > {
  $$QuizItemResponsesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $QuizAttemptsTable _attemptIdTable(_$AppDatabase db) =>
      db.quizAttempts.createAlias(
        'quiz_item_responses__attempt_id__quiz_attempts__attempt_id',
      );

  $$QuizAttemptsTableProcessedTableManager? get attemptId {
    final $_column = $_itemColumn<String>('attempt_id');
    if ($_column == null) return null;
    final manager = $$QuizAttemptsTableTableManager(
      $_db,
      $_db.quizAttempts,
    ).filter((f) => f.attemptId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_attemptIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $QuizItemsTable _itemIdTable(_$AppDatabase db) => db.quizItems
      .createAlias('quiz_item_responses__item_id__quiz_items__item_id');

  $$QuizItemsTableProcessedTableManager? get itemId {
    final $_column = $_itemColumn<String>('item_id');
    if ($_column == null) return null;
    final manager = $$QuizItemsTableTableManager(
      $_db,
      $_db.quizItems,
    ).filter((f) => f.itemId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_itemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$QuizItemResponsesTableFilterComposer
    extends Composer<_$AppDatabase, $QuizItemResponsesTable> {
  $$QuizItemResponsesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get responseId => $composableBuilder(
    column: $table.responseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get givenAnswer => $composableBuilder(
    column: $table.givenAnswer,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCorrect => $composableBuilder(
    column: $table.isCorrect,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get timeSpentMs => $composableBuilder(
    column: $table.timeSpentMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get answeredAt => $composableBuilder(
    column: $table.answeredAt,
    builder: (column) => ColumnFilters(column),
  );

  $$QuizAttemptsTableFilterComposer get attemptId {
    final $$QuizAttemptsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.attemptId,
      referencedTable: $db.quizAttempts,
      getReferencedColumn: (t) => t.attemptId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuizAttemptsTableFilterComposer(
            $db: $db,
            $table: $db.quizAttempts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$QuizItemsTableFilterComposer get itemId {
    final $$QuizItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.quizItems,
      getReferencedColumn: (t) => t.itemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuizItemsTableFilterComposer(
            $db: $db,
            $table: $db.quizItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$QuizItemResponsesTableOrderingComposer
    extends Composer<_$AppDatabase, $QuizItemResponsesTable> {
  $$QuizItemResponsesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get responseId => $composableBuilder(
    column: $table.responseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get givenAnswer => $composableBuilder(
    column: $table.givenAnswer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCorrect => $composableBuilder(
    column: $table.isCorrect,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get timeSpentMs => $composableBuilder(
    column: $table.timeSpentMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get answeredAt => $composableBuilder(
    column: $table.answeredAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$QuizAttemptsTableOrderingComposer get attemptId {
    final $$QuizAttemptsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.attemptId,
      referencedTable: $db.quizAttempts,
      getReferencedColumn: (t) => t.attemptId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuizAttemptsTableOrderingComposer(
            $db: $db,
            $table: $db.quizAttempts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$QuizItemsTableOrderingComposer get itemId {
    final $$QuizItemsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.quizItems,
      getReferencedColumn: (t) => t.itemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuizItemsTableOrderingComposer(
            $db: $db,
            $table: $db.quizItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$QuizItemResponsesTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuizItemResponsesTable> {
  $$QuizItemResponsesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get responseId => $composableBuilder(
    column: $table.responseId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get givenAnswer => $composableBuilder(
    column: $table.givenAnswer,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isCorrect =>
      $composableBuilder(column: $table.isCorrect, builder: (column) => column);

  GeneratedColumn<int> get timeSpentMs => $composableBuilder(
    column: $table.timeSpentMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get answeredAt => $composableBuilder(
    column: $table.answeredAt,
    builder: (column) => column,
  );

  $$QuizAttemptsTableAnnotationComposer get attemptId {
    final $$QuizAttemptsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.attemptId,
      referencedTable: $db.quizAttempts,
      getReferencedColumn: (t) => t.attemptId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuizAttemptsTableAnnotationComposer(
            $db: $db,
            $table: $db.quizAttempts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$QuizItemsTableAnnotationComposer get itemId {
    final $$QuizItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.quizItems,
      getReferencedColumn: (t) => t.itemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuizItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.quizItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$QuizItemResponsesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QuizItemResponsesTable,
          QuizItemResponseRow,
          $$QuizItemResponsesTableFilterComposer,
          $$QuizItemResponsesTableOrderingComposer,
          $$QuizItemResponsesTableAnnotationComposer,
          $$QuizItemResponsesTableCreateCompanionBuilder,
          $$QuizItemResponsesTableUpdateCompanionBuilder,
          (QuizItemResponseRow, $$QuizItemResponsesTableReferences),
          QuizItemResponseRow,
          PrefetchHooks Function({bool attemptId, bool itemId})
        > {
  $$QuizItemResponsesTableTableManager(
    _$AppDatabase db,
    $QuizItemResponsesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuizItemResponsesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuizItemResponsesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuizItemResponsesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> responseId = const Value.absent(),
                Value<String?> attemptId = const Value.absent(),
                Value<String?> itemId = const Value.absent(),
                Value<String> givenAnswer = const Value.absent(),
                Value<bool> isCorrect = const Value.absent(),
                Value<int?> timeSpentMs = const Value.absent(),
                Value<int> answeredAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => QuizItemResponsesCompanion(
                responseId: responseId,
                attemptId: attemptId,
                itemId: itemId,
                givenAnswer: givenAnswer,
                isCorrect: isCorrect,
                timeSpentMs: timeSpentMs,
                answeredAt: answeredAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String responseId,
                Value<String?> attemptId = const Value.absent(),
                Value<String?> itemId = const Value.absent(),
                required String givenAnswer,
                required bool isCorrect,
                Value<int?> timeSpentMs = const Value.absent(),
                required int answeredAt,
                Value<int> rowid = const Value.absent(),
              }) => QuizItemResponsesCompanion.insert(
                responseId: responseId,
                attemptId: attemptId,
                itemId: itemId,
                givenAnswer: givenAnswer,
                isCorrect: isCorrect,
                timeSpentMs: timeSpentMs,
                answeredAt: answeredAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$QuizItemResponsesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({attemptId = false, itemId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (attemptId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.attemptId,
                                referencedTable:
                                    $$QuizItemResponsesTableReferences
                                        ._attemptIdTable(db),
                                referencedColumn:
                                    $$QuizItemResponsesTableReferences
                                        ._attemptIdTable(db)
                                        .attemptId,
                              )
                              as T;
                    }
                    if (itemId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.itemId,
                                referencedTable:
                                    $$QuizItemResponsesTableReferences
                                        ._itemIdTable(db),
                                referencedColumn:
                                    $$QuizItemResponsesTableReferences
                                        ._itemIdTable(db)
                                        .itemId,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$QuizItemResponsesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QuizItemResponsesTable,
      QuizItemResponseRow,
      $$QuizItemResponsesTableFilterComposer,
      $$QuizItemResponsesTableOrderingComposer,
      $$QuizItemResponsesTableAnnotationComposer,
      $$QuizItemResponsesTableCreateCompanionBuilder,
      $$QuizItemResponsesTableUpdateCompanionBuilder,
      (QuizItemResponseRow, $$QuizItemResponsesTableReferences),
      QuizItemResponseRow,
      PrefetchHooks Function({bool attemptId, bool itemId})
    >;
typedef $$BadgesTableCreateCompanionBuilder =
    BadgesCompanion Function({
      required String badgeId,
      required String badgeName,
      required String description,
      required String iconAsset,
      required String unlockRuleJson,
      Value<int> rowid,
    });
typedef $$BadgesTableUpdateCompanionBuilder =
    BadgesCompanion Function({
      Value<String> badgeId,
      Value<String> badgeName,
      Value<String> description,
      Value<String> iconAsset,
      Value<String> unlockRuleJson,
      Value<int> rowid,
    });

final class $$BadgesTableReferences
    extends BaseReferences<_$AppDatabase, $BadgesTable, BadgeRow> {
  $$BadgesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$BadgesEarnedTable, List<BadgeEarnedRow>>
  _badgesEarnedRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.badgesEarned,
    aliasName: 'badges__badge_id__badges_earned__badge_id',
  );

  $$BadgesEarnedTableProcessedTableManager get badgesEarnedRefs {
    final manager = $$BadgesEarnedTableTableManager($_db, $_db.badgesEarned)
        .filter(
          (f) => f.badgeId.badgeId.sqlEquals($_itemColumn<String>('badge_id')!),
        );

    final cache = $_typedResult.readTableOrNull(_badgesEarnedRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$BadgesTableFilterComposer
    extends Composer<_$AppDatabase, $BadgesTable> {
  $$BadgesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get badgeId => $composableBuilder(
    column: $table.badgeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get badgeName => $composableBuilder(
    column: $table.badgeName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get iconAsset => $composableBuilder(
    column: $table.iconAsset,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unlockRuleJson => $composableBuilder(
    column: $table.unlockRuleJson,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> badgesEarnedRefs(
    Expression<bool> Function($$BadgesEarnedTableFilterComposer f) f,
  ) {
    final $$BadgesEarnedTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.badgeId,
      referencedTable: $db.badgesEarned,
      getReferencedColumn: (t) => t.badgeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BadgesEarnedTableFilterComposer(
            $db: $db,
            $table: $db.badgesEarned,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BadgesTableOrderingComposer
    extends Composer<_$AppDatabase, $BadgesTable> {
  $$BadgesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get badgeId => $composableBuilder(
    column: $table.badgeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get badgeName => $composableBuilder(
    column: $table.badgeName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get iconAsset => $composableBuilder(
    column: $table.iconAsset,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unlockRuleJson => $composableBuilder(
    column: $table.unlockRuleJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BadgesTableAnnotationComposer
    extends Composer<_$AppDatabase, $BadgesTable> {
  $$BadgesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get badgeId =>
      $composableBuilder(column: $table.badgeId, builder: (column) => column);

  GeneratedColumn<String> get badgeName =>
      $composableBuilder(column: $table.badgeName, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get iconAsset =>
      $composableBuilder(column: $table.iconAsset, builder: (column) => column);

  GeneratedColumn<String> get unlockRuleJson => $composableBuilder(
    column: $table.unlockRuleJson,
    builder: (column) => column,
  );

  Expression<T> badgesEarnedRefs<T extends Object>(
    Expression<T> Function($$BadgesEarnedTableAnnotationComposer a) f,
  ) {
    final $$BadgesEarnedTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.badgeId,
      referencedTable: $db.badgesEarned,
      getReferencedColumn: (t) => t.badgeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BadgesEarnedTableAnnotationComposer(
            $db: $db,
            $table: $db.badgesEarned,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BadgesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BadgesTable,
          BadgeRow,
          $$BadgesTableFilterComposer,
          $$BadgesTableOrderingComposer,
          $$BadgesTableAnnotationComposer,
          $$BadgesTableCreateCompanionBuilder,
          $$BadgesTableUpdateCompanionBuilder,
          (BadgeRow, $$BadgesTableReferences),
          BadgeRow,
          PrefetchHooks Function({bool badgesEarnedRefs})
        > {
  $$BadgesTableTableManager(_$AppDatabase db, $BadgesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BadgesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BadgesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BadgesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> badgeId = const Value.absent(),
                Value<String> badgeName = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> iconAsset = const Value.absent(),
                Value<String> unlockRuleJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BadgesCompanion(
                badgeId: badgeId,
                badgeName: badgeName,
                description: description,
                iconAsset: iconAsset,
                unlockRuleJson: unlockRuleJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String badgeId,
                required String badgeName,
                required String description,
                required String iconAsset,
                required String unlockRuleJson,
                Value<int> rowid = const Value.absent(),
              }) => BadgesCompanion.insert(
                badgeId: badgeId,
                badgeName: badgeName,
                description: description,
                iconAsset: iconAsset,
                unlockRuleJson: unlockRuleJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$BadgesTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({badgesEarnedRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (badgesEarnedRefs) db.badgesEarned],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (badgesEarnedRefs)
                    await $_getPrefetchedData<
                      BadgeRow,
                      $BadgesTable,
                      BadgeEarnedRow
                    >(
                      currentTable: table,
                      referencedTable: $$BadgesTableReferences
                          ._badgesEarnedRefsTable(db),
                      managerFromTypedResult: (p0) => $$BadgesTableReferences(
                        db,
                        table,
                        p0,
                      ).badgesEarnedRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.badgeId == item.badgeId,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$BadgesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BadgesTable,
      BadgeRow,
      $$BadgesTableFilterComposer,
      $$BadgesTableOrderingComposer,
      $$BadgesTableAnnotationComposer,
      $$BadgesTableCreateCompanionBuilder,
      $$BadgesTableUpdateCompanionBuilder,
      (BadgeRow, $$BadgesTableReferences),
      BadgeRow,
      PrefetchHooks Function({bool badgesEarnedRefs})
    >;
typedef $$BadgesEarnedTableCreateCompanionBuilder =
    BadgesEarnedCompanion Function({
      required String userId,
      required String badgeId,
      required int earnedAt,
      Value<int> rowid,
    });
typedef $$BadgesEarnedTableUpdateCompanionBuilder =
    BadgesEarnedCompanion Function({
      Value<String> userId,
      Value<String> badgeId,
      Value<int> earnedAt,
      Value<int> rowid,
    });

final class $$BadgesEarnedTableReferences
    extends BaseReferences<_$AppDatabase, $BadgesEarnedTable, BadgeEarnedRow> {
  $$BadgesEarnedTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UsersTable _userIdTable(_$AppDatabase db) =>
      db.users.createAlias('badges_earned__user_id__users__user_id');

  $$UsersTableProcessedTableManager get userId {
    final $_column = $_itemColumn<String>('user_id')!;

    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.userId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $BadgesTable _badgeIdTable(_$AppDatabase db) =>
      db.badges.createAlias('badges_earned__badge_id__badges__badge_id');

  $$BadgesTableProcessedTableManager get badgeId {
    final $_column = $_itemColumn<String>('badge_id')!;

    final manager = $$BadgesTableTableManager(
      $_db,
      $_db.badges,
    ).filter((f) => f.badgeId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_badgeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$BadgesEarnedTableFilterComposer
    extends Composer<_$AppDatabase, $BadgesEarnedTable> {
  $$BadgesEarnedTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get earnedAt => $composableBuilder(
    column: $table.earnedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BadgesTableFilterComposer get badgeId {
    final $$BadgesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.badgeId,
      referencedTable: $db.badges,
      getReferencedColumn: (t) => t.badgeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BadgesTableFilterComposer(
            $db: $db,
            $table: $db.badges,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BadgesEarnedTableOrderingComposer
    extends Composer<_$AppDatabase, $BadgesEarnedTable> {
  $$BadgesEarnedTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get earnedAt => $composableBuilder(
    column: $table.earnedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BadgesTableOrderingComposer get badgeId {
    final $$BadgesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.badgeId,
      referencedTable: $db.badges,
      getReferencedColumn: (t) => t.badgeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BadgesTableOrderingComposer(
            $db: $db,
            $table: $db.badges,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BadgesEarnedTableAnnotationComposer
    extends Composer<_$AppDatabase, $BadgesEarnedTable> {
  $$BadgesEarnedTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get earnedAt =>
      $composableBuilder(column: $table.earnedAt, builder: (column) => column);

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BadgesTableAnnotationComposer get badgeId {
    final $$BadgesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.badgeId,
      referencedTable: $db.badges,
      getReferencedColumn: (t) => t.badgeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BadgesTableAnnotationComposer(
            $db: $db,
            $table: $db.badges,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BadgesEarnedTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BadgesEarnedTable,
          BadgeEarnedRow,
          $$BadgesEarnedTableFilterComposer,
          $$BadgesEarnedTableOrderingComposer,
          $$BadgesEarnedTableAnnotationComposer,
          $$BadgesEarnedTableCreateCompanionBuilder,
          $$BadgesEarnedTableUpdateCompanionBuilder,
          (BadgeEarnedRow, $$BadgesEarnedTableReferences),
          BadgeEarnedRow,
          PrefetchHooks Function({bool userId, bool badgeId})
        > {
  $$BadgesEarnedTableTableManager(_$AppDatabase db, $BadgesEarnedTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BadgesEarnedTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BadgesEarnedTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BadgesEarnedTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> userId = const Value.absent(),
                Value<String> badgeId = const Value.absent(),
                Value<int> earnedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BadgesEarnedCompanion(
                userId: userId,
                badgeId: badgeId,
                earnedAt: earnedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String userId,
                required String badgeId,
                required int earnedAt,
                Value<int> rowid = const Value.absent(),
              }) => BadgesEarnedCompanion.insert(
                userId: userId,
                badgeId: badgeId,
                earnedAt: earnedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$BadgesEarnedTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({userId = false, badgeId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (userId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.userId,
                                referencedTable: $$BadgesEarnedTableReferences
                                    ._userIdTable(db),
                                referencedColumn: $$BadgesEarnedTableReferences
                                    ._userIdTable(db)
                                    .userId,
                              )
                              as T;
                    }
                    if (badgeId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.badgeId,
                                referencedTable: $$BadgesEarnedTableReferences
                                    ._badgeIdTable(db),
                                referencedColumn: $$BadgesEarnedTableReferences
                                    ._badgeIdTable(db)
                                    .badgeId,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$BadgesEarnedTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BadgesEarnedTable,
      BadgeEarnedRow,
      $$BadgesEarnedTableFilterComposer,
      $$BadgesEarnedTableOrderingComposer,
      $$BadgesEarnedTableAnnotationComposer,
      $$BadgesEarnedTableCreateCompanionBuilder,
      $$BadgesEarnedTableUpdateCompanionBuilder,
      (BadgeEarnedRow, $$BadgesEarnedTableReferences),
      BadgeEarnedRow,
      PrefetchHooks Function({bool userId, bool badgeId})
    >;
typedef $$PointsLedgerTableCreateCompanionBuilder =
    PointsLedgerCompanion Function({
      required String entryId,
      Value<String?> userId,
      required String sourceType,
      Value<String?> sourceId,
      required int points,
      required int createdAt,
      Value<int> rowid,
    });
typedef $$PointsLedgerTableUpdateCompanionBuilder =
    PointsLedgerCompanion Function({
      Value<String> entryId,
      Value<String?> userId,
      Value<String> sourceType,
      Value<String?> sourceId,
      Value<int> points,
      Value<int> createdAt,
      Value<int> rowid,
    });

final class $$PointsLedgerTableReferences
    extends BaseReferences<_$AppDatabase, $PointsLedgerTable, PointsLedgerRow> {
  $$PointsLedgerTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UsersTable _userIdTable(_$AppDatabase db) =>
      db.users.createAlias('points_ledger__user_id__users__user_id');

  $$UsersTableProcessedTableManager? get userId {
    final $_column = $_itemColumn<String>('user_id');
    if ($_column == null) return null;
    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.userId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PointsLedgerTableFilterComposer
    extends Composer<_$AppDatabase, $PointsLedgerTable> {
  $$PointsLedgerTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get entryId => $composableBuilder(
    column: $table.entryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceId => $composableBuilder(
    column: $table.sourceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get points => $composableBuilder(
    column: $table.points,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PointsLedgerTableOrderingComposer
    extends Composer<_$AppDatabase, $PointsLedgerTable> {
  $$PointsLedgerTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get entryId => $composableBuilder(
    column: $table.entryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceId => $composableBuilder(
    column: $table.sourceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get points => $composableBuilder(
    column: $table.points,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PointsLedgerTableAnnotationComposer
    extends Composer<_$AppDatabase, $PointsLedgerTable> {
  $$PointsLedgerTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get entryId =>
      $composableBuilder(column: $table.entryId, builder: (column) => column);

  GeneratedColumn<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceId =>
      $composableBuilder(column: $table.sourceId, builder: (column) => column);

  GeneratedColumn<int> get points =>
      $composableBuilder(column: $table.points, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PointsLedgerTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PointsLedgerTable,
          PointsLedgerRow,
          $$PointsLedgerTableFilterComposer,
          $$PointsLedgerTableOrderingComposer,
          $$PointsLedgerTableAnnotationComposer,
          $$PointsLedgerTableCreateCompanionBuilder,
          $$PointsLedgerTableUpdateCompanionBuilder,
          (PointsLedgerRow, $$PointsLedgerTableReferences),
          PointsLedgerRow,
          PrefetchHooks Function({bool userId})
        > {
  $$PointsLedgerTableTableManager(_$AppDatabase db, $PointsLedgerTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PointsLedgerTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PointsLedgerTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PointsLedgerTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> entryId = const Value.absent(),
                Value<String?> userId = const Value.absent(),
                Value<String> sourceType = const Value.absent(),
                Value<String?> sourceId = const Value.absent(),
                Value<int> points = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PointsLedgerCompanion(
                entryId: entryId,
                userId: userId,
                sourceType: sourceType,
                sourceId: sourceId,
                points: points,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String entryId,
                Value<String?> userId = const Value.absent(),
                required String sourceType,
                Value<String?> sourceId = const Value.absent(),
                required int points,
                required int createdAt,
                Value<int> rowid = const Value.absent(),
              }) => PointsLedgerCompanion.insert(
                entryId: entryId,
                userId: userId,
                sourceType: sourceType,
                sourceId: sourceId,
                points: points,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PointsLedgerTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({userId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (userId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.userId,
                                referencedTable: $$PointsLedgerTableReferences
                                    ._userIdTable(db),
                                referencedColumn: $$PointsLedgerTableReferences
                                    ._userIdTable(db)
                                    .userId,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PointsLedgerTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PointsLedgerTable,
      PointsLedgerRow,
      $$PointsLedgerTableFilterComposer,
      $$PointsLedgerTableOrderingComposer,
      $$PointsLedgerTableAnnotationComposer,
      $$PointsLedgerTableCreateCompanionBuilder,
      $$PointsLedgerTableUpdateCompanionBuilder,
      (PointsLedgerRow, $$PointsLedgerTableReferences),
      PointsLedgerRow,
      PrefetchHooks Function({bool userId})
    >;
typedef $$ExportBundlesTableCreateCompanionBuilder =
    ExportBundlesCompanion Function({
      required String bundleId,
      Value<String?> userId,
      required int generatedAt,
      required String payloadJson,
      Value<String?> importedByTeacherId,
      Value<int?> importedAt,
      Value<int> rowid,
    });
typedef $$ExportBundlesTableUpdateCompanionBuilder =
    ExportBundlesCompanion Function({
      Value<String> bundleId,
      Value<String?> userId,
      Value<int> generatedAt,
      Value<String> payloadJson,
      Value<String?> importedByTeacherId,
      Value<int?> importedAt,
      Value<int> rowid,
    });

final class $$ExportBundlesTableReferences
    extends
        BaseReferences<_$AppDatabase, $ExportBundlesTable, ExportBundleRow> {
  $$ExportBundlesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $UsersTable _userIdTable(_$AppDatabase db) =>
      db.users.createAlias('export_bundles__user_id__users__user_id');

  $$UsersTableProcessedTableManager? get userId {
    final $_column = $_itemColumn<String>('user_id');
    if ($_column == null) return null;
    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.userId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ExportBundlesTableFilterComposer
    extends Composer<_$AppDatabase, $ExportBundlesTable> {
  $$ExportBundlesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get bundleId => $composableBuilder(
    column: $table.bundleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get generatedAt => $composableBuilder(
    column: $table.generatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get importedByTeacherId => $composableBuilder(
    column: $table.importedByTeacherId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get importedAt => $composableBuilder(
    column: $table.importedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExportBundlesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExportBundlesTable> {
  $$ExportBundlesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get bundleId => $composableBuilder(
    column: $table.bundleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get generatedAt => $composableBuilder(
    column: $table.generatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get importedByTeacherId => $composableBuilder(
    column: $table.importedByTeacherId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get importedAt => $composableBuilder(
    column: $table.importedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExportBundlesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExportBundlesTable> {
  $$ExportBundlesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get bundleId =>
      $composableBuilder(column: $table.bundleId, builder: (column) => column);

  GeneratedColumn<int> get generatedAt => $composableBuilder(
    column: $table.generatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get importedByTeacherId => $composableBuilder(
    column: $table.importedByTeacherId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get importedAt => $composableBuilder(
    column: $table.importedAt,
    builder: (column) => column,
  );

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExportBundlesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExportBundlesTable,
          ExportBundleRow,
          $$ExportBundlesTableFilterComposer,
          $$ExportBundlesTableOrderingComposer,
          $$ExportBundlesTableAnnotationComposer,
          $$ExportBundlesTableCreateCompanionBuilder,
          $$ExportBundlesTableUpdateCompanionBuilder,
          (ExportBundleRow, $$ExportBundlesTableReferences),
          ExportBundleRow,
          PrefetchHooks Function({bool userId})
        > {
  $$ExportBundlesTableTableManager(_$AppDatabase db, $ExportBundlesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExportBundlesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExportBundlesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExportBundlesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> bundleId = const Value.absent(),
                Value<String?> userId = const Value.absent(),
                Value<int> generatedAt = const Value.absent(),
                Value<String> payloadJson = const Value.absent(),
                Value<String?> importedByTeacherId = const Value.absent(),
                Value<int?> importedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExportBundlesCompanion(
                bundleId: bundleId,
                userId: userId,
                generatedAt: generatedAt,
                payloadJson: payloadJson,
                importedByTeacherId: importedByTeacherId,
                importedAt: importedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String bundleId,
                Value<String?> userId = const Value.absent(),
                required int generatedAt,
                required String payloadJson,
                Value<String?> importedByTeacherId = const Value.absent(),
                Value<int?> importedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExportBundlesCompanion.insert(
                bundleId: bundleId,
                userId: userId,
                generatedAt: generatedAt,
                payloadJson: payloadJson,
                importedByTeacherId: importedByTeacherId,
                importedAt: importedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ExportBundlesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({userId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (userId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.userId,
                                referencedTable: $$ExportBundlesTableReferences
                                    ._userIdTable(db),
                                referencedColumn: $$ExportBundlesTableReferences
                                    ._userIdTable(db)
                                    .userId,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ExportBundlesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExportBundlesTable,
      ExportBundleRow,
      $$ExportBundlesTableFilterComposer,
      $$ExportBundlesTableOrderingComposer,
      $$ExportBundlesTableAnnotationComposer,
      $$ExportBundlesTableCreateCompanionBuilder,
      $$ExportBundlesTableUpdateCompanionBuilder,
      (ExportBundleRow, $$ExportBundlesTableReferences),
      ExportBundleRow,
      PrefetchHooks Function({bool userId})
    >;
typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTable,
          AppSettingRow,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            AppSettingRow,
            BaseReferences<_$AppDatabase, $AppSettingsTable, AppSettingRow>,
          ),
          AppSettingRow,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTable,
      AppSettingRow,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        AppSettingRow,
        BaseReferences<_$AppDatabase, $AppSettingsTable, AppSettingRow>,
      ),
      AppSettingRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ClassSectionsTableTableManager get classSections =>
      $$ClassSectionsTableTableManager(_db, _db.classSections);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$ContentPacksTableTableManager get contentPacks =>
      $$ContentPacksTableTableManager(_db, _db.contentPacks);
  $$LessonStagesTableTableManager get lessonStages =>
      $$LessonStagesTableTableManager(_db, _db.lessonStages);
  $$QuizItemsTableTableManager get quizItems =>
      $$QuizItemsTableTableManager(_db, _db.quizItems);
  $$MissionLevelsTableTableManager get missionLevels =>
      $$MissionLevelsTableTableManager(_db, _db.missionLevels);
  $$PredictionLogTableTableManager get predictionLog =>
      $$PredictionLogTableTableManager(_db, _db.predictionLog);
  $$MotionTrialsTableTableManager get motionTrials =>
      $$MotionTrialsTableTableManager(_db, _db.motionTrials);
  $$MissionAttemptsTableTableManager get missionAttempts =>
      $$MissionAttemptsTableTableManager(_db, _db.missionAttempts);
  $$QuizAttemptsTableTableManager get quizAttempts =>
      $$QuizAttemptsTableTableManager(_db, _db.quizAttempts);
  $$QuizItemResponsesTableTableManager get quizItemResponses =>
      $$QuizItemResponsesTableTableManager(_db, _db.quizItemResponses);
  $$BadgesTableTableManager get badges =>
      $$BadgesTableTableManager(_db, _db.badges);
  $$BadgesEarnedTableTableManager get badgesEarned =>
      $$BadgesEarnedTableTableManager(_db, _db.badgesEarned);
  $$PointsLedgerTableTableManager get pointsLedger =>
      $$PointsLedgerTableTableManager(_db, _db.pointsLedger);
  $$ExportBundlesTableTableManager get exportBundles =>
      $$ExportBundlesTableTableManager(_db, _db.exportBundles);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
}
