// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $MusicBucketsTable extends MusicBuckets
    with TableInfo<$MusicBucketsTable, MusicBucket> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MusicBucketsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name =
      GeneratedColumn<String>('name', aliasedName, false,
          additionalChecks: GeneratedColumn.checkTextLength(
            minTextLength: 1,
          ),
          type: DriftSqlType.string,
          requiredDuringInsert: true,
          defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _endpointMeta =
      const VerificationMeta('endpoint');
  @override
  late final GeneratedColumn<String> endpoint =
      GeneratedColumn<String>('endpoint', aliasedName, false,
          additionalChecks: GeneratedColumn.checkTextLength(
            minTextLength: 1,
          ),
          type: DriftSqlType.string,
          requiredDuringInsert: true);
  static const VerificationMeta _musicFolderPrefixMeta =
      const VerificationMeta('musicFolderPrefix');
  @override
  late final GeneratedColumn<String> musicFolderPrefix =
      GeneratedColumn<String>('music_folder_prefix', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, name, endpoint, musicFolderPrefix];
  @override
  String get aliasedName => _alias ?? 'music_buckets';
  @override
  String get actualTableName => 'music_buckets';
  @override
  VerificationContext validateIntegrity(Insertable<MusicBucket> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('endpoint')) {
      context.handle(_endpointMeta,
          endpoint.isAcceptableOrUnknown(data['endpoint']!, _endpointMeta));
    } else if (isInserting) {
      context.missing(_endpointMeta);
    }
    if (data.containsKey('music_folder_prefix')) {
      context.handle(
          _musicFolderPrefixMeta,
          musicFolderPrefix.isAcceptableOrUnknown(
              data['music_folder_prefix']!, _musicFolderPrefixMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MusicBucket map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MusicBucket(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      endpoint: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}endpoint'])!,
      musicFolderPrefix: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}music_folder_prefix']),
    );
  }

  @override
  $MusicBucketsTable createAlias(String alias) {
    return $MusicBucketsTable(attachedDatabase, alias);
  }
}

class MusicBucket extends DataClass implements Insertable<MusicBucket> {
  final int id;
  final String name;
  final String endpoint;
  final String? musicFolderPrefix;
  const MusicBucket(
      {required this.id,
      required this.name,
      required this.endpoint,
      this.musicFolderPrefix});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['endpoint'] = Variable<String>(endpoint);
    if (!nullToAbsent || musicFolderPrefix != null) {
      map['music_folder_prefix'] = Variable<String>(musicFolderPrefix);
    }
    return map;
  }

  MusicBucketsCompanion toCompanion(bool nullToAbsent) {
    return MusicBucketsCompanion(
      id: Value(id),
      name: Value(name),
      endpoint: Value(endpoint),
      musicFolderPrefix: musicFolderPrefix == null && nullToAbsent
          ? const Value.absent()
          : Value(musicFolderPrefix),
    );
  }

  factory MusicBucket.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MusicBucket(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      endpoint: serializer.fromJson<String>(json['endpoint']),
      musicFolderPrefix:
          serializer.fromJson<String?>(json['musicFolderPrefix']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'endpoint': serializer.toJson<String>(endpoint),
      'musicFolderPrefix': serializer.toJson<String?>(musicFolderPrefix),
    };
  }

  MusicBucket copyWith(
          {int? id,
          String? name,
          String? endpoint,
          Value<String?> musicFolderPrefix = const Value.absent()}) =>
      MusicBucket(
        id: id ?? this.id,
        name: name ?? this.name,
        endpoint: endpoint ?? this.endpoint,
        musicFolderPrefix: musicFolderPrefix.present
            ? musicFolderPrefix.value
            : this.musicFolderPrefix,
      );
  @override
  String toString() {
    return (StringBuffer('MusicBucket(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('endpoint: $endpoint, ')
          ..write('musicFolderPrefix: $musicFolderPrefix')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, endpoint, musicFolderPrefix);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MusicBucket &&
          other.id == this.id &&
          other.name == this.name &&
          other.endpoint == this.endpoint &&
          other.musicFolderPrefix == this.musicFolderPrefix);
}

class MusicBucketsCompanion extends UpdateCompanion<MusicBucket> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> endpoint;
  final Value<String?> musicFolderPrefix;
  const MusicBucketsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.endpoint = const Value.absent(),
    this.musicFolderPrefix = const Value.absent(),
  });
  MusicBucketsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String endpoint,
    this.musicFolderPrefix = const Value.absent(),
  })  : name = Value(name),
        endpoint = Value(endpoint);
  static Insertable<MusicBucket> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? endpoint,
    Expression<String>? musicFolderPrefix,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (endpoint != null) 'endpoint': endpoint,
      if (musicFolderPrefix != null) 'music_folder_prefix': musicFolderPrefix,
    });
  }

  MusicBucketsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? endpoint,
      Value<String?>? musicFolderPrefix}) {
    return MusicBucketsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      endpoint: endpoint ?? this.endpoint,
      musicFolderPrefix: musicFolderPrefix ?? this.musicFolderPrefix,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (endpoint.present) {
      map['endpoint'] = Variable<String>(endpoint.value);
    }
    if (musicFolderPrefix.present) {
      map['music_folder_prefix'] = Variable<String>(musicFolderPrefix.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MusicBucketsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('endpoint: $endpoint, ')
          ..write('musicFolderPrefix: $musicFolderPrefix')
          ..write(')'))
        .toString();
  }
}

class $GenresTable extends Genres with TableInfo<$GenresTable, Genre> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GenresTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name =
      GeneratedColumn<String>('name', aliasedName, false,
          additionalChecks: GeneratedColumn.checkTextLength(
            minTextLength: 1,
          ),
          type: DriftSqlType.string,
          requiredDuringInsert: true,
          defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  String get aliasedName => _alias ?? 'genres';
  @override
  String get actualTableName => 'genres';
  @override
  VerificationContext validateIntegrity(Insertable<Genre> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Genre map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Genre(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
    );
  }

  @override
  $GenresTable createAlias(String alias) {
    return $GenresTable(attachedDatabase, alias);
  }
}

class Genre extends DataClass implements Insertable<Genre> {
  final int id;
  final String name;
  const Genre({required this.id, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    return map;
  }

  GenresCompanion toCompanion(bool nullToAbsent) {
    return GenresCompanion(
      id: Value(id),
      name: Value(name),
    );
  }

  factory Genre.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Genre(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  Genre copyWith({int? id, String? name}) => Genre(
        id: id ?? this.id,
        name: name ?? this.name,
      );
  @override
  String toString() {
    return (StringBuffer('Genre(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Genre && other.id == this.id && other.name == this.name);
}

class GenresCompanion extends UpdateCompanion<Genre> {
  final Value<int> id;
  final Value<String> name;
  const GenresCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
  });
  GenresCompanion.insert({
    this.id = const Value.absent(),
    required String name,
  }) : name = Value(name);
  static Insertable<Genre> custom({
    Expression<int>? id,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
    });
  }

  GenresCompanion copyWith({Value<int>? id, Value<String>? name}) {
    return GenresCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GenresCompanion(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $LabelsTable extends Labels with TableInfo<$LabelsTable, Label> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LabelsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name =
      GeneratedColumn<String>('name', aliasedName, false,
          additionalChecks: GeneratedColumn.checkTextLength(
            minTextLength: 1,
          ),
          type: DriftSqlType.string,
          requiredDuringInsert: true,
          defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _imageUrlMeta =
      const VerificationMeta('imageUrl');
  @override
  late final GeneratedColumn<String> imageUrl =
      GeneratedColumn<String>('image_url', aliasedName, true,
          additionalChecks: GeneratedColumn.checkTextLength(
            minTextLength: 1,
          ),
          type: DriftSqlType.string,
          requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, name, imageUrl];
  @override
  String get aliasedName => _alias ?? 'labels';
  @override
  String get actualTableName => 'labels';
  @override
  VerificationContext validateIntegrity(Insertable<Label> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('image_url')) {
      context.handle(_imageUrlMeta,
          imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Label map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Label(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      imageUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image_url']),
    );
  }

  @override
  $LabelsTable createAlias(String alias) {
    return $LabelsTable(attachedDatabase, alias);
  }
}

class Label extends DataClass implements Insertable<Label> {
  final int id;
  final String name;
  final String? imageUrl;
  const Label({required this.id, required this.name, this.imageUrl});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || imageUrl != null) {
      map['image_url'] = Variable<String>(imageUrl);
    }
    return map;
  }

  LabelsCompanion toCompanion(bool nullToAbsent) {
    return LabelsCompanion(
      id: Value(id),
      name: Value(name),
      imageUrl: imageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrl),
    );
  }

  factory Label.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Label(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      imageUrl: serializer.fromJson<String?>(json['imageUrl']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'imageUrl': serializer.toJson<String?>(imageUrl),
    };
  }

  Label copyWith(
          {int? id,
          String? name,
          Value<String?> imageUrl = const Value.absent()}) =>
      Label(
        id: id ?? this.id,
        name: name ?? this.name,
        imageUrl: imageUrl.present ? imageUrl.value : this.imageUrl,
      );
  @override
  String toString() {
    return (StringBuffer('Label(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('imageUrl: $imageUrl')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, imageUrl);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Label &&
          other.id == this.id &&
          other.name == this.name &&
          other.imageUrl == this.imageUrl);
}

class LabelsCompanion extends UpdateCompanion<Label> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> imageUrl;
  const LabelsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.imageUrl = const Value.absent(),
  });
  LabelsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.imageUrl = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Label> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? imageUrl,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (imageUrl != null) 'image_url': imageUrl,
    });
  }

  LabelsCompanion copyWith(
      {Value<int>? id, Value<String>? name, Value<String?>? imageUrl}) {
    return LabelsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LabelsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('imageUrl: $imageUrl')
          ..write(')'))
        .toString();
  }
}

class $LabelGenresTable extends LabelGenres
    with TableInfo<$LabelGenresTable, LabelGenre> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LabelGenresTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _labelIdMeta =
      const VerificationMeta('labelId');
  @override
  late final GeneratedColumn<int> labelId = GeneratedColumn<int>(
      'label_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES labels (id)'));
  static const VerificationMeta _genreIdMeta =
      const VerificationMeta('genreId');
  @override
  late final GeneratedColumn<int> genreId = GeneratedColumn<int>(
      'genre_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES genres (id)'));
  @override
  List<GeneratedColumn> get $columns => [id, labelId, genreId];
  @override
  String get aliasedName => _alias ?? 'label_genres';
  @override
  String get actualTableName => 'label_genres';
  @override
  VerificationContext validateIntegrity(Insertable<LabelGenre> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('label_id')) {
      context.handle(_labelIdMeta,
          labelId.isAcceptableOrUnknown(data['label_id']!, _labelIdMeta));
    } else if (isInserting) {
      context.missing(_labelIdMeta);
    }
    if (data.containsKey('genre_id')) {
      context.handle(_genreIdMeta,
          genreId.isAcceptableOrUnknown(data['genre_id']!, _genreIdMeta));
    } else if (isInserting) {
      context.missing(_genreIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  LabelGenre map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LabelGenre(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      labelId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}label_id'])!,
      genreId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}genre_id'])!,
    );
  }

  @override
  $LabelGenresTable createAlias(String alias) {
    return $LabelGenresTable(attachedDatabase, alias);
  }
}

class LabelGenre extends DataClass implements Insertable<LabelGenre> {
  final String id;
  final int labelId;
  final int genreId;
  const LabelGenre(
      {required this.id, required this.labelId, required this.genreId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['label_id'] = Variable<int>(labelId);
    map['genre_id'] = Variable<int>(genreId);
    return map;
  }

  LabelGenresCompanion toCompanion(bool nullToAbsent) {
    return LabelGenresCompanion(
      id: Value(id),
      labelId: Value(labelId),
      genreId: Value(genreId),
    );
  }

  factory LabelGenre.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LabelGenre(
      id: serializer.fromJson<String>(json['id']),
      labelId: serializer.fromJson<int>(json['labelId']),
      genreId: serializer.fromJson<int>(json['genreId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'labelId': serializer.toJson<int>(labelId),
      'genreId': serializer.toJson<int>(genreId),
    };
  }

  LabelGenre copyWith({String? id, int? labelId, int? genreId}) => LabelGenre(
        id: id ?? this.id,
        labelId: labelId ?? this.labelId,
        genreId: genreId ?? this.genreId,
      );
  @override
  String toString() {
    return (StringBuffer('LabelGenre(')
          ..write('id: $id, ')
          ..write('labelId: $labelId, ')
          ..write('genreId: $genreId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, labelId, genreId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LabelGenre &&
          other.id == this.id &&
          other.labelId == this.labelId &&
          other.genreId == this.genreId);
}

class LabelGenresCompanion extends UpdateCompanion<LabelGenre> {
  final Value<String> id;
  final Value<int> labelId;
  final Value<int> genreId;
  final Value<int> rowid;
  const LabelGenresCompanion({
    this.id = const Value.absent(),
    this.labelId = const Value.absent(),
    this.genreId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LabelGenresCompanion.insert({
    required String id,
    required int labelId,
    required int genreId,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        labelId = Value(labelId),
        genreId = Value(genreId);
  static Insertable<LabelGenre> custom({
    Expression<String>? id,
    Expression<int>? labelId,
    Expression<int>? genreId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (labelId != null) 'label_id': labelId,
      if (genreId != null) 'genre_id': genreId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LabelGenresCompanion copyWith(
      {Value<String>? id,
      Value<int>? labelId,
      Value<int>? genreId,
      Value<int>? rowid}) {
    return LabelGenresCompanion(
      id: id ?? this.id,
      labelId: labelId ?? this.labelId,
      genreId: genreId ?? this.genreId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (labelId.present) {
      map['label_id'] = Variable<int>(labelId.value);
    }
    if (genreId.present) {
      map['genre_id'] = Variable<int>(genreId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LabelGenresCompanion(')
          ..write('id: $id, ')
          ..write('labelId: $labelId, ')
          ..write('genreId: $genreId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GroupsTable extends Groups with TableInfo<$GroupsTable, Group> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GroupsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _bucketPrefixMeta =
      const VerificationMeta('bucketPrefix');
  @override
  late final GeneratedColumn<String> bucketPrefix =
      GeneratedColumn<String>('bucket_prefix', aliasedName, false,
          additionalChecks: GeneratedColumn.checkTextLength(
            minTextLength: 1,
          ),
          type: DriftSqlType.string,
          requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name =
      GeneratedColumn<String>('name', aliasedName, false,
          additionalChecks: GeneratedColumn.checkTextLength(
            minTextLength: 1,
          ),
          type: DriftSqlType.string,
          requiredDuringInsert: true);
  static const VerificationMeta _imageUrlMeta =
      const VerificationMeta('imageUrl');
  @override
  late final GeneratedColumn<String> imageUrl =
      GeneratedColumn<String>('image_url', aliasedName, false,
          additionalChecks: GeneratedColumn.checkTextLength(
            minTextLength: 1,
          ),
          type: DriftSqlType.string,
          requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, bucketPrefix, name, imageUrl];
  @override
  String get aliasedName => _alias ?? 'groups';
  @override
  String get actualTableName => 'groups';
  @override
  VerificationContext validateIntegrity(Insertable<Group> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('bucket_prefix')) {
      context.handle(
          _bucketPrefixMeta,
          bucketPrefix.isAcceptableOrUnknown(
              data['bucket_prefix']!, _bucketPrefixMeta));
    } else if (isInserting) {
      context.missing(_bucketPrefixMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('image_url')) {
      context.handle(_imageUrlMeta,
          imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta));
    } else if (isInserting) {
      context.missing(_imageUrlMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Group map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Group(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      bucketPrefix: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}bucket_prefix'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      imageUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image_url'])!,
    );
  }

  @override
  $GroupsTable createAlias(String alias) {
    return $GroupsTable(attachedDatabase, alias);
  }
}

class Group extends DataClass implements Insertable<Group> {
  final int id;
  final String bucketPrefix;
  final String name;
  final String imageUrl;
  const Group(
      {required this.id,
      required this.bucketPrefix,
      required this.name,
      required this.imageUrl});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['bucket_prefix'] = Variable<String>(bucketPrefix);
    map['name'] = Variable<String>(name);
    map['image_url'] = Variable<String>(imageUrl);
    return map;
  }

  GroupsCompanion toCompanion(bool nullToAbsent) {
    return GroupsCompanion(
      id: Value(id),
      bucketPrefix: Value(bucketPrefix),
      name: Value(name),
      imageUrl: Value(imageUrl),
    );
  }

  factory Group.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Group(
      id: serializer.fromJson<int>(json['id']),
      bucketPrefix: serializer.fromJson<String>(json['bucketPrefix']),
      name: serializer.fromJson<String>(json['name']),
      imageUrl: serializer.fromJson<String>(json['imageUrl']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'bucketPrefix': serializer.toJson<String>(bucketPrefix),
      'name': serializer.toJson<String>(name),
      'imageUrl': serializer.toJson<String>(imageUrl),
    };
  }

  Group copyWith(
          {int? id, String? bucketPrefix, String? name, String? imageUrl}) =>
      Group(
        id: id ?? this.id,
        bucketPrefix: bucketPrefix ?? this.bucketPrefix,
        name: name ?? this.name,
        imageUrl: imageUrl ?? this.imageUrl,
      );
  @override
  String toString() {
    return (StringBuffer('Group(')
          ..write('id: $id, ')
          ..write('bucketPrefix: $bucketPrefix, ')
          ..write('name: $name, ')
          ..write('imageUrl: $imageUrl')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, bucketPrefix, name, imageUrl);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Group &&
          other.id == this.id &&
          other.bucketPrefix == this.bucketPrefix &&
          other.name == this.name &&
          other.imageUrl == this.imageUrl);
}

class GroupsCompanion extends UpdateCompanion<Group> {
  final Value<int> id;
  final Value<String> bucketPrefix;
  final Value<String> name;
  final Value<String> imageUrl;
  const GroupsCompanion({
    this.id = const Value.absent(),
    this.bucketPrefix = const Value.absent(),
    this.name = const Value.absent(),
    this.imageUrl = const Value.absent(),
  });
  GroupsCompanion.insert({
    this.id = const Value.absent(),
    required String bucketPrefix,
    required String name,
    required String imageUrl,
  })  : bucketPrefix = Value(bucketPrefix),
        name = Value(name),
        imageUrl = Value(imageUrl);
  static Insertable<Group> custom({
    Expression<int>? id,
    Expression<String>? bucketPrefix,
    Expression<String>? name,
    Expression<String>? imageUrl,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bucketPrefix != null) 'bucket_prefix': bucketPrefix,
      if (name != null) 'name': name,
      if (imageUrl != null) 'image_url': imageUrl,
    });
  }

  GroupsCompanion copyWith(
      {Value<int>? id,
      Value<String>? bucketPrefix,
      Value<String>? name,
      Value<String>? imageUrl}) {
    return GroupsCompanion(
      id: id ?? this.id,
      bucketPrefix: bucketPrefix ?? this.bucketPrefix,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (bucketPrefix.present) {
      map['bucket_prefix'] = Variable<String>(bucketPrefix.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GroupsCompanion(')
          ..write('id: $id, ')
          ..write('bucketPrefix: $bucketPrefix, ')
          ..write('name: $name, ')
          ..write('imageUrl: $imageUrl')
          ..write(')'))
        .toString();
  }
}

class $GroupGenresTable extends GroupGenres
    with TableInfo<$GroupGenresTable, GroupGenre> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GroupGenresTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _groupIdMeta =
      const VerificationMeta('groupId');
  @override
  late final GeneratedColumn<int> groupId = GeneratedColumn<int>(
      'group_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES "groups" (id)'));
  static const VerificationMeta _genreIdMeta =
      const VerificationMeta('genreId');
  @override
  late final GeneratedColumn<int> genreId = GeneratedColumn<int>(
      'genre_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES genres (id)'));
  @override
  List<GeneratedColumn> get $columns => [id, groupId, genreId];
  @override
  String get aliasedName => _alias ?? 'group_genres';
  @override
  String get actualTableName => 'group_genres';
  @override
  VerificationContext validateIntegrity(Insertable<GroupGenre> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('group_id')) {
      context.handle(_groupIdMeta,
          groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta));
    } else if (isInserting) {
      context.missing(_groupIdMeta);
    }
    if (data.containsKey('genre_id')) {
      context.handle(_genreIdMeta,
          genreId.isAcceptableOrUnknown(data['genre_id']!, _genreIdMeta));
    } else if (isInserting) {
      context.missing(_genreIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  GroupGenre map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GroupGenre(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      groupId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}group_id'])!,
      genreId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}genre_id'])!,
    );
  }

  @override
  $GroupGenresTable createAlias(String alias) {
    return $GroupGenresTable(attachedDatabase, alias);
  }
}

class GroupGenre extends DataClass implements Insertable<GroupGenre> {
  final String id;
  final int groupId;
  final int genreId;
  const GroupGenre(
      {required this.id, required this.groupId, required this.genreId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['group_id'] = Variable<int>(groupId);
    map['genre_id'] = Variable<int>(genreId);
    return map;
  }

  GroupGenresCompanion toCompanion(bool nullToAbsent) {
    return GroupGenresCompanion(
      id: Value(id),
      groupId: Value(groupId),
      genreId: Value(genreId),
    );
  }

  factory GroupGenre.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GroupGenre(
      id: serializer.fromJson<String>(json['id']),
      groupId: serializer.fromJson<int>(json['groupId']),
      genreId: serializer.fromJson<int>(json['genreId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'groupId': serializer.toJson<int>(groupId),
      'genreId': serializer.toJson<int>(genreId),
    };
  }

  GroupGenre copyWith({String? id, int? groupId, int? genreId}) => GroupGenre(
        id: id ?? this.id,
        groupId: groupId ?? this.groupId,
        genreId: genreId ?? this.genreId,
      );
  @override
  String toString() {
    return (StringBuffer('GroupGenre(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('genreId: $genreId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, groupId, genreId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GroupGenre &&
          other.id == this.id &&
          other.groupId == this.groupId &&
          other.genreId == this.genreId);
}

class GroupGenresCompanion extends UpdateCompanion<GroupGenre> {
  final Value<String> id;
  final Value<int> groupId;
  final Value<int> genreId;
  final Value<int> rowid;
  const GroupGenresCompanion({
    this.id = const Value.absent(),
    this.groupId = const Value.absent(),
    this.genreId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GroupGenresCompanion.insert({
    required String id,
    required int groupId,
    required int genreId,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        groupId = Value(groupId),
        genreId = Value(genreId);
  static Insertable<GroupGenre> custom({
    Expression<String>? id,
    Expression<int>? groupId,
    Expression<int>? genreId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (groupId != null) 'group_id': groupId,
      if (genreId != null) 'genre_id': genreId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GroupGenresCompanion copyWith(
      {Value<String>? id,
      Value<int>? groupId,
      Value<int>? genreId,
      Value<int>? rowid}) {
    return GroupGenresCompanion(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      genreId: genreId ?? this.genreId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<int>(groupId.value);
    }
    if (genreId.present) {
      map['genre_id'] = Variable<int>(genreId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GroupGenresCompanion(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('genreId: $genreId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GroupLabelsTable extends GroupLabels
    with TableInfo<$GroupLabelsTable, GroupLabel> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GroupLabelsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _groupIdMeta =
      const VerificationMeta('groupId');
  @override
  late final GeneratedColumn<int> groupId = GeneratedColumn<int>(
      'group_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES "groups" (id)'));
  static const VerificationMeta _labelIdMeta =
      const VerificationMeta('labelId');
  @override
  late final GeneratedColumn<int> labelId = GeneratedColumn<int>(
      'label_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES genres (id)'));
  @override
  List<GeneratedColumn> get $columns => [id, groupId, labelId];
  @override
  String get aliasedName => _alias ?? 'group_labels';
  @override
  String get actualTableName => 'group_labels';
  @override
  VerificationContext validateIntegrity(Insertable<GroupLabel> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('group_id')) {
      context.handle(_groupIdMeta,
          groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta));
    } else if (isInserting) {
      context.missing(_groupIdMeta);
    }
    if (data.containsKey('label_id')) {
      context.handle(_labelIdMeta,
          labelId.isAcceptableOrUnknown(data['label_id']!, _labelIdMeta));
    } else if (isInserting) {
      context.missing(_labelIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  GroupLabel map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GroupLabel(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      groupId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}group_id'])!,
      labelId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}label_id'])!,
    );
  }

  @override
  $GroupLabelsTable createAlias(String alias) {
    return $GroupLabelsTable(attachedDatabase, alias);
  }
}

class GroupLabel extends DataClass implements Insertable<GroupLabel> {
  final String id;
  final int groupId;
  final int labelId;
  const GroupLabel(
      {required this.id, required this.groupId, required this.labelId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['group_id'] = Variable<int>(groupId);
    map['label_id'] = Variable<int>(labelId);
    return map;
  }

  GroupLabelsCompanion toCompanion(bool nullToAbsent) {
    return GroupLabelsCompanion(
      id: Value(id),
      groupId: Value(groupId),
      labelId: Value(labelId),
    );
  }

  factory GroupLabel.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GroupLabel(
      id: serializer.fromJson<String>(json['id']),
      groupId: serializer.fromJson<int>(json['groupId']),
      labelId: serializer.fromJson<int>(json['labelId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'groupId': serializer.toJson<int>(groupId),
      'labelId': serializer.toJson<int>(labelId),
    };
  }

  GroupLabel copyWith({String? id, int? groupId, int? labelId}) => GroupLabel(
        id: id ?? this.id,
        groupId: groupId ?? this.groupId,
        labelId: labelId ?? this.labelId,
      );
  @override
  String toString() {
    return (StringBuffer('GroupLabel(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('labelId: $labelId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, groupId, labelId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GroupLabel &&
          other.id == this.id &&
          other.groupId == this.groupId &&
          other.labelId == this.labelId);
}

class GroupLabelsCompanion extends UpdateCompanion<GroupLabel> {
  final Value<String> id;
  final Value<int> groupId;
  final Value<int> labelId;
  final Value<int> rowid;
  const GroupLabelsCompanion({
    this.id = const Value.absent(),
    this.groupId = const Value.absent(),
    this.labelId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GroupLabelsCompanion.insert({
    required String id,
    required int groupId,
    required int labelId,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        groupId = Value(groupId),
        labelId = Value(labelId);
  static Insertable<GroupLabel> custom({
    Expression<String>? id,
    Expression<int>? groupId,
    Expression<int>? labelId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (groupId != null) 'group_id': groupId,
      if (labelId != null) 'label_id': labelId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GroupLabelsCompanion copyWith(
      {Value<String>? id,
      Value<int>? groupId,
      Value<int>? labelId,
      Value<int>? rowid}) {
    return GroupLabelsCompanion(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      labelId: labelId ?? this.labelId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<int>(groupId.value);
    }
    if (labelId.present) {
      map['label_id'] = Variable<int>(labelId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GroupLabelsCompanion(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('labelId: $labelId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ArtistsTable extends Artists with TableInfo<$ArtistsTable, Artist> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ArtistsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _bucketPrefixMeta =
      const VerificationMeta('bucketPrefix');
  @override
  late final GeneratedColumn<String> bucketPrefix =
      GeneratedColumn<String>('bucket_prefix', aliasedName, false,
          additionalChecks: GeneratedColumn.checkTextLength(
            minTextLength: 1,
          ),
          type: DriftSqlType.string,
          requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name =
      GeneratedColumn<String>('name', aliasedName, false,
          additionalChecks: GeneratedColumn.checkTextLength(
            minTextLength: 1,
          ),
          type: DriftSqlType.string,
          requiredDuringInsert: true,
          defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _imageUrlMeta =
      const VerificationMeta('imageUrl');
  @override
  late final GeneratedColumn<String> imageUrl =
      GeneratedColumn<String>('image_url', aliasedName, true,
          additionalChecks: GeneratedColumn.checkTextLength(
            minTextLength: 1,
          ),
          type: DriftSqlType.string,
          requiredDuringInsert: false);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, bucketPrefix, name, imageUrl, description];
  @override
  String get aliasedName => _alias ?? 'artists';
  @override
  String get actualTableName => 'artists';
  @override
  VerificationContext validateIntegrity(Insertable<Artist> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('bucket_prefix')) {
      context.handle(
          _bucketPrefixMeta,
          bucketPrefix.isAcceptableOrUnknown(
              data['bucket_prefix']!, _bucketPrefixMeta));
    } else if (isInserting) {
      context.missing(_bucketPrefixMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('image_url')) {
      context.handle(_imageUrlMeta,
          imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Artist map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Artist(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      bucketPrefix: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}bucket_prefix'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      imageUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image_url']),
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
    );
  }

  @override
  $ArtistsTable createAlias(String alias) {
    return $ArtistsTable(attachedDatabase, alias);
  }
}

class Artist extends DataClass implements Insertable<Artist> {
  final int id;
  final String bucketPrefix;
  final String name;
  final String? imageUrl;
  final String? description;
  const Artist(
      {required this.id,
      required this.bucketPrefix,
      required this.name,
      this.imageUrl,
      this.description});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['bucket_prefix'] = Variable<String>(bucketPrefix);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || imageUrl != null) {
      map['image_url'] = Variable<String>(imageUrl);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    return map;
  }

  ArtistsCompanion toCompanion(bool nullToAbsent) {
    return ArtistsCompanion(
      id: Value(id),
      bucketPrefix: Value(bucketPrefix),
      name: Value(name),
      imageUrl: imageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrl),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
    );
  }

  factory Artist.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Artist(
      id: serializer.fromJson<int>(json['id']),
      bucketPrefix: serializer.fromJson<String>(json['bucketPrefix']),
      name: serializer.fromJson<String>(json['name']),
      imageUrl: serializer.fromJson<String?>(json['imageUrl']),
      description: serializer.fromJson<String?>(json['description']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'bucketPrefix': serializer.toJson<String>(bucketPrefix),
      'name': serializer.toJson<String>(name),
      'imageUrl': serializer.toJson<String?>(imageUrl),
      'description': serializer.toJson<String?>(description),
    };
  }

  Artist copyWith(
          {int? id,
          String? bucketPrefix,
          String? name,
          Value<String?> imageUrl = const Value.absent(),
          Value<String?> description = const Value.absent()}) =>
      Artist(
        id: id ?? this.id,
        bucketPrefix: bucketPrefix ?? this.bucketPrefix,
        name: name ?? this.name,
        imageUrl: imageUrl.present ? imageUrl.value : this.imageUrl,
        description: description.present ? description.value : this.description,
      );
  @override
  String toString() {
    return (StringBuffer('Artist(')
          ..write('id: $id, ')
          ..write('bucketPrefix: $bucketPrefix, ')
          ..write('name: $name, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, bucketPrefix, name, imageUrl, description);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Artist &&
          other.id == this.id &&
          other.bucketPrefix == this.bucketPrefix &&
          other.name == this.name &&
          other.imageUrl == this.imageUrl &&
          other.description == this.description);
}

class ArtistsCompanion extends UpdateCompanion<Artist> {
  final Value<int> id;
  final Value<String> bucketPrefix;
  final Value<String> name;
  final Value<String?> imageUrl;
  final Value<String?> description;
  const ArtistsCompanion({
    this.id = const Value.absent(),
    this.bucketPrefix = const Value.absent(),
    this.name = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.description = const Value.absent(),
  });
  ArtistsCompanion.insert({
    this.id = const Value.absent(),
    required String bucketPrefix,
    required String name,
    this.imageUrl = const Value.absent(),
    this.description = const Value.absent(),
  })  : bucketPrefix = Value(bucketPrefix),
        name = Value(name);
  static Insertable<Artist> custom({
    Expression<int>? id,
    Expression<String>? bucketPrefix,
    Expression<String>? name,
    Expression<String>? imageUrl,
    Expression<String>? description,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bucketPrefix != null) 'bucket_prefix': bucketPrefix,
      if (name != null) 'name': name,
      if (imageUrl != null) 'image_url': imageUrl,
      if (description != null) 'description': description,
    });
  }

  ArtistsCompanion copyWith(
      {Value<int>? id,
      Value<String>? bucketPrefix,
      Value<String>? name,
      Value<String?>? imageUrl,
      Value<String?>? description}) {
    return ArtistsCompanion(
      id: id ?? this.id,
      bucketPrefix: bucketPrefix ?? this.bucketPrefix,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (bucketPrefix.present) {
      map['bucket_prefix'] = Variable<String>(bucketPrefix.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ArtistsCompanion(')
          ..write('id: $id, ')
          ..write('bucketPrefix: $bucketPrefix, ')
          ..write('name: $name, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }
}

class $ArtistGenresTable extends ArtistGenres
    with TableInfo<$ArtistGenresTable, ArtistGenre> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ArtistGenresTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _artistIdMeta =
      const VerificationMeta('artistId');
  @override
  late final GeneratedColumn<int> artistId = GeneratedColumn<int>(
      'artist_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES artists (id)'));
  static const VerificationMeta _genreIdMeta =
      const VerificationMeta('genreId');
  @override
  late final GeneratedColumn<int> genreId = GeneratedColumn<int>(
      'genre_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES genres (id)'));
  @override
  List<GeneratedColumn> get $columns => [artistId, genreId];
  @override
  String get aliasedName => _alias ?? 'artist_genres';
  @override
  String get actualTableName => 'artist_genres';
  @override
  VerificationContext validateIntegrity(Insertable<ArtistGenre> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('artist_id')) {
      context.handle(_artistIdMeta,
          artistId.isAcceptableOrUnknown(data['artist_id']!, _artistIdMeta));
    } else if (isInserting) {
      context.missing(_artistIdMeta);
    }
    if (data.containsKey('genre_id')) {
      context.handle(_genreIdMeta,
          genreId.isAcceptableOrUnknown(data['genre_id']!, _genreIdMeta));
    } else if (isInserting) {
      context.missing(_genreIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  ArtistGenre map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ArtistGenre(
      artistId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}artist_id'])!,
      genreId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}genre_id'])!,
    );
  }

  @override
  $ArtistGenresTable createAlias(String alias) {
    return $ArtistGenresTable(attachedDatabase, alias);
  }
}

class ArtistGenre extends DataClass implements Insertable<ArtistGenre> {
  final int artistId;
  final int genreId;
  const ArtistGenre({required this.artistId, required this.genreId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['artist_id'] = Variable<int>(artistId);
    map['genre_id'] = Variable<int>(genreId);
    return map;
  }

  ArtistGenresCompanion toCompanion(bool nullToAbsent) {
    return ArtistGenresCompanion(
      artistId: Value(artistId),
      genreId: Value(genreId),
    );
  }

  factory ArtistGenre.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ArtistGenre(
      artistId: serializer.fromJson<int>(json['artistId']),
      genreId: serializer.fromJson<int>(json['genreId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'artistId': serializer.toJson<int>(artistId),
      'genreId': serializer.toJson<int>(genreId),
    };
  }

  ArtistGenre copyWith({int? artistId, int? genreId}) => ArtistGenre(
        artistId: artistId ?? this.artistId,
        genreId: genreId ?? this.genreId,
      );
  @override
  String toString() {
    return (StringBuffer('ArtistGenre(')
          ..write('artistId: $artistId, ')
          ..write('genreId: $genreId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(artistId, genreId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ArtistGenre &&
          other.artistId == this.artistId &&
          other.genreId == this.genreId);
}

class ArtistGenresCompanion extends UpdateCompanion<ArtistGenre> {
  final Value<int> artistId;
  final Value<int> genreId;
  final Value<int> rowid;
  const ArtistGenresCompanion({
    this.artistId = const Value.absent(),
    this.genreId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ArtistGenresCompanion.insert({
    required int artistId,
    required int genreId,
    this.rowid = const Value.absent(),
  })  : artistId = Value(artistId),
        genreId = Value(genreId);
  static Insertable<ArtistGenre> custom({
    Expression<int>? artistId,
    Expression<int>? genreId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (artistId != null) 'artist_id': artistId,
      if (genreId != null) 'genre_id': genreId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ArtistGenresCompanion copyWith(
      {Value<int>? artistId, Value<int>? genreId, Value<int>? rowid}) {
    return ArtistGenresCompanion(
      artistId: artistId ?? this.artistId,
      genreId: genreId ?? this.genreId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (artistId.present) {
      map['artist_id'] = Variable<int>(artistId.value);
    }
    if (genreId.present) {
      map['genre_id'] = Variable<int>(genreId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ArtistGenresCompanion(')
          ..write('artistId: $artistId, ')
          ..write('genreId: $genreId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ArtistLabelsTable extends ArtistLabels
    with TableInfo<$ArtistLabelsTable, ArtistLabel> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ArtistLabelsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _artistIdMeta =
      const VerificationMeta('artistId');
  @override
  late final GeneratedColumn<int> artistId = GeneratedColumn<int>(
      'artist_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES artists (id)'));
  static const VerificationMeta _genreIdMeta =
      const VerificationMeta('genreId');
  @override
  late final GeneratedColumn<int> genreId = GeneratedColumn<int>(
      'genre_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES genres (id)'));
  @override
  List<GeneratedColumn> get $columns => [artistId, genreId];
  @override
  String get aliasedName => _alias ?? 'artist_labels';
  @override
  String get actualTableName => 'artist_labels';
  @override
  VerificationContext validateIntegrity(Insertable<ArtistLabel> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('artist_id')) {
      context.handle(_artistIdMeta,
          artistId.isAcceptableOrUnknown(data['artist_id']!, _artistIdMeta));
    } else if (isInserting) {
      context.missing(_artistIdMeta);
    }
    if (data.containsKey('genre_id')) {
      context.handle(_genreIdMeta,
          genreId.isAcceptableOrUnknown(data['genre_id']!, _genreIdMeta));
    } else if (isInserting) {
      context.missing(_genreIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  ArtistLabel map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ArtistLabel(
      artistId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}artist_id'])!,
      genreId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}genre_id'])!,
    );
  }

  @override
  $ArtistLabelsTable createAlias(String alias) {
    return $ArtistLabelsTable(attachedDatabase, alias);
  }
}

class ArtistLabel extends DataClass implements Insertable<ArtistLabel> {
  final int artistId;
  final int genreId;
  const ArtistLabel({required this.artistId, required this.genreId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['artist_id'] = Variable<int>(artistId);
    map['genre_id'] = Variable<int>(genreId);
    return map;
  }

  ArtistLabelsCompanion toCompanion(bool nullToAbsent) {
    return ArtistLabelsCompanion(
      artistId: Value(artistId),
      genreId: Value(genreId),
    );
  }

  factory ArtistLabel.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ArtistLabel(
      artistId: serializer.fromJson<int>(json['artistId']),
      genreId: serializer.fromJson<int>(json['genreId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'artistId': serializer.toJson<int>(artistId),
      'genreId': serializer.toJson<int>(genreId),
    };
  }

  ArtistLabel copyWith({int? artistId, int? genreId}) => ArtistLabel(
        artistId: artistId ?? this.artistId,
        genreId: genreId ?? this.genreId,
      );
  @override
  String toString() {
    return (StringBuffer('ArtistLabel(')
          ..write('artistId: $artistId, ')
          ..write('genreId: $genreId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(artistId, genreId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ArtistLabel &&
          other.artistId == this.artistId &&
          other.genreId == this.genreId);
}

class ArtistLabelsCompanion extends UpdateCompanion<ArtistLabel> {
  final Value<int> artistId;
  final Value<int> genreId;
  final Value<int> rowid;
  const ArtistLabelsCompanion({
    this.artistId = const Value.absent(),
    this.genreId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ArtistLabelsCompanion.insert({
    required int artistId,
    required int genreId,
    this.rowid = const Value.absent(),
  })  : artistId = Value(artistId),
        genreId = Value(genreId);
  static Insertable<ArtistLabel> custom({
    Expression<int>? artistId,
    Expression<int>? genreId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (artistId != null) 'artist_id': artistId,
      if (genreId != null) 'genre_id': genreId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ArtistLabelsCompanion copyWith(
      {Value<int>? artistId, Value<int>? genreId, Value<int>? rowid}) {
    return ArtistLabelsCompanion(
      artistId: artistId ?? this.artistId,
      genreId: genreId ?? this.genreId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (artistId.present) {
      map['artist_id'] = Variable<int>(artistId.value);
    }
    if (genreId.present) {
      map['genre_id'] = Variable<int>(genreId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ArtistLabelsCompanion(')
          ..write('artistId: $artistId, ')
          ..write('genreId: $genreId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ArtistGroupsTable extends ArtistGroups
    with TableInfo<$ArtistGroupsTable, ArtistGroup> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ArtistGroupsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _artistIdMeta =
      const VerificationMeta('artistId');
  @override
  late final GeneratedColumn<int> artistId = GeneratedColumn<int>(
      'artist_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES artists (id)'));
  static const VerificationMeta _groupIdMeta =
      const VerificationMeta('groupId');
  @override
  late final GeneratedColumn<int> groupId = GeneratedColumn<int>(
      'group_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES "groups" (id)'));
  @override
  List<GeneratedColumn> get $columns => [artistId, groupId];
  @override
  String get aliasedName => _alias ?? 'artist_groups';
  @override
  String get actualTableName => 'artist_groups';
  @override
  VerificationContext validateIntegrity(Insertable<ArtistGroup> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('artist_id')) {
      context.handle(_artistIdMeta,
          artistId.isAcceptableOrUnknown(data['artist_id']!, _artistIdMeta));
    } else if (isInserting) {
      context.missing(_artistIdMeta);
    }
    if (data.containsKey('group_id')) {
      context.handle(_groupIdMeta,
          groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta));
    } else if (isInserting) {
      context.missing(_groupIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  ArtistGroup map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ArtistGroup(
      artistId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}artist_id'])!,
      groupId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}group_id'])!,
    );
  }

  @override
  $ArtistGroupsTable createAlias(String alias) {
    return $ArtistGroupsTable(attachedDatabase, alias);
  }
}

class ArtistGroup extends DataClass implements Insertable<ArtistGroup> {
  final int artistId;
  final int groupId;
  const ArtistGroup({required this.artistId, required this.groupId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['artist_id'] = Variable<int>(artistId);
    map['group_id'] = Variable<int>(groupId);
    return map;
  }

  ArtistGroupsCompanion toCompanion(bool nullToAbsent) {
    return ArtistGroupsCompanion(
      artistId: Value(artistId),
      groupId: Value(groupId),
    );
  }

  factory ArtistGroup.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ArtistGroup(
      artistId: serializer.fromJson<int>(json['artistId']),
      groupId: serializer.fromJson<int>(json['groupId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'artistId': serializer.toJson<int>(artistId),
      'groupId': serializer.toJson<int>(groupId),
    };
  }

  ArtistGroup copyWith({int? artistId, int? groupId}) => ArtistGroup(
        artistId: artistId ?? this.artistId,
        groupId: groupId ?? this.groupId,
      );
  @override
  String toString() {
    return (StringBuffer('ArtistGroup(')
          ..write('artistId: $artistId, ')
          ..write('groupId: $groupId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(artistId, groupId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ArtistGroup &&
          other.artistId == this.artistId &&
          other.groupId == this.groupId);
}

class ArtistGroupsCompanion extends UpdateCompanion<ArtistGroup> {
  final Value<int> artistId;
  final Value<int> groupId;
  final Value<int> rowid;
  const ArtistGroupsCompanion({
    this.artistId = const Value.absent(),
    this.groupId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ArtistGroupsCompanion.insert({
    required int artistId,
    required int groupId,
    this.rowid = const Value.absent(),
  })  : artistId = Value(artistId),
        groupId = Value(groupId);
  static Insertable<ArtistGroup> custom({
    Expression<int>? artistId,
    Expression<int>? groupId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (artistId != null) 'artist_id': artistId,
      if (groupId != null) 'group_id': groupId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ArtistGroupsCompanion copyWith(
      {Value<int>? artistId, Value<int>? groupId, Value<int>? rowid}) {
    return ArtistGroupsCompanion(
      artistId: artistId ?? this.artistId,
      groupId: groupId ?? this.groupId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (artistId.present) {
      map['artist_id'] = Variable<int>(artistId.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<int>(groupId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ArtistGroupsCompanion(')
          ..write('artistId: $artistId, ')
          ..write('groupId: $groupId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AlbumsTable extends Albums with TableInfo<$AlbumsTable, Album> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AlbumsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name =
      GeneratedColumn<String>('name', aliasedName, false,
          additionalChecks: GeneratedColumn.checkTextLength(
            minTextLength: 1,
          ),
          type: DriftSqlType.string,
          requiredDuringInsert: true,
          defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _bucketPrefixMeta =
      const VerificationMeta('bucketPrefix');
  @override
  late final GeneratedColumn<String> bucketPrefix =
      GeneratedColumn<String>('bucket_prefix', aliasedName, false,
          additionalChecks: GeneratedColumn.checkTextLength(
            minTextLength: 1,
          ),
          type: DriftSqlType.string,
          requiredDuringInsert: true);
  static const VerificationMeta _imageUrlMeta =
      const VerificationMeta('imageUrl');
  @override
  late final GeneratedColumn<String> imageUrl =
      GeneratedColumn<String>('image_url', aliasedName, true,
          additionalChecks: GeneratedColumn.checkTextLength(
            minTextLength: 1,
          ),
          type: DriftSqlType.string,
          requiredDuringInsert: false);
  static const VerificationMeta _imageBlobMeta =
      const VerificationMeta('imageBlob');
  @override
  late final GeneratedColumn<Uint8List> imageBlob = GeneratedColumn<Uint8List>(
      'image_blob', aliasedName, true,
      type: DriftSqlType.blob, requiredDuringInsert: false);
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<DateTime> year = GeneratedColumn<DateTime>(
      'year', aliasedName, false,
      check: () => year.isBiggerThan(Constant(DateTime(1000))),
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, bucketPrefix, imageUrl, imageBlob, year];
  @override
  String get aliasedName => _alias ?? 'albums';
  @override
  String get actualTableName => 'albums';
  @override
  VerificationContext validateIntegrity(Insertable<Album> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('bucket_prefix')) {
      context.handle(
          _bucketPrefixMeta,
          bucketPrefix.isAcceptableOrUnknown(
              data['bucket_prefix']!, _bucketPrefixMeta));
    } else if (isInserting) {
      context.missing(_bucketPrefixMeta);
    }
    if (data.containsKey('image_url')) {
      context.handle(_imageUrlMeta,
          imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta));
    }
    if (data.containsKey('image_blob')) {
      context.handle(_imageBlobMeta,
          imageBlob.isAcceptableOrUnknown(data['image_blob']!, _imageBlobMeta));
    }
    if (data.containsKey('year')) {
      context.handle(
          _yearMeta, year.isAcceptableOrUnknown(data['year']!, _yearMeta));
    } else if (isInserting) {
      context.missing(_yearMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Album map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Album(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      bucketPrefix: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}bucket_prefix'])!,
      imageUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image_url']),
      imageBlob: attachedDatabase.typeMapping
          .read(DriftSqlType.blob, data['${effectivePrefix}image_blob']),
      year: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}year'])!,
    );
  }

  @override
  $AlbumsTable createAlias(String alias) {
    return $AlbumsTable(attachedDatabase, alias);
  }
}

class Album extends DataClass implements Insertable<Album> {
  final int id;
  final String name;
  final String bucketPrefix;
  final String? imageUrl;
  final Uint8List? imageBlob;
  final DateTime year;
  const Album(
      {required this.id,
      required this.name,
      required this.bucketPrefix,
      this.imageUrl,
      this.imageBlob,
      required this.year});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['bucket_prefix'] = Variable<String>(bucketPrefix);
    if (!nullToAbsent || imageUrl != null) {
      map['image_url'] = Variable<String>(imageUrl);
    }
    if (!nullToAbsent || imageBlob != null) {
      map['image_blob'] = Variable<Uint8List>(imageBlob);
    }
    map['year'] = Variable<DateTime>(year);
    return map;
  }

  AlbumsCompanion toCompanion(bool nullToAbsent) {
    return AlbumsCompanion(
      id: Value(id),
      name: Value(name),
      bucketPrefix: Value(bucketPrefix),
      imageUrl: imageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrl),
      imageBlob: imageBlob == null && nullToAbsent
          ? const Value.absent()
          : Value(imageBlob),
      year: Value(year),
    );
  }

  factory Album.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Album(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      bucketPrefix: serializer.fromJson<String>(json['bucketPrefix']),
      imageUrl: serializer.fromJson<String?>(json['imageUrl']),
      imageBlob: serializer.fromJson<Uint8List?>(json['imageBlob']),
      year: serializer.fromJson<DateTime>(json['year']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'bucketPrefix': serializer.toJson<String>(bucketPrefix),
      'imageUrl': serializer.toJson<String?>(imageUrl),
      'imageBlob': serializer.toJson<Uint8List?>(imageBlob),
      'year': serializer.toJson<DateTime>(year),
    };
  }

  Album copyWith(
          {int? id,
          String? name,
          String? bucketPrefix,
          Value<String?> imageUrl = const Value.absent(),
          Value<Uint8List?> imageBlob = const Value.absent(),
          DateTime? year}) =>
      Album(
        id: id ?? this.id,
        name: name ?? this.name,
        bucketPrefix: bucketPrefix ?? this.bucketPrefix,
        imageUrl: imageUrl.present ? imageUrl.value : this.imageUrl,
        imageBlob: imageBlob.present ? imageBlob.value : this.imageBlob,
        year: year ?? this.year,
      );
  @override
  String toString() {
    return (StringBuffer('Album(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('bucketPrefix: $bucketPrefix, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('imageBlob: $imageBlob, ')
          ..write('year: $year')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, bucketPrefix, imageUrl,
      $driftBlobEquality.hash(imageBlob), year);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Album &&
          other.id == this.id &&
          other.name == this.name &&
          other.bucketPrefix == this.bucketPrefix &&
          other.imageUrl == this.imageUrl &&
          $driftBlobEquality.equals(other.imageBlob, this.imageBlob) &&
          other.year == this.year);
}

class AlbumsCompanion extends UpdateCompanion<Album> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> bucketPrefix;
  final Value<String?> imageUrl;
  final Value<Uint8List?> imageBlob;
  final Value<DateTime> year;
  const AlbumsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.bucketPrefix = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.imageBlob = const Value.absent(),
    this.year = const Value.absent(),
  });
  AlbumsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String bucketPrefix,
    this.imageUrl = const Value.absent(),
    this.imageBlob = const Value.absent(),
    required DateTime year,
  })  : name = Value(name),
        bucketPrefix = Value(bucketPrefix),
        year = Value(year);
  static Insertable<Album> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? bucketPrefix,
    Expression<String>? imageUrl,
    Expression<Uint8List>? imageBlob,
    Expression<DateTime>? year,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (bucketPrefix != null) 'bucket_prefix': bucketPrefix,
      if (imageUrl != null) 'image_url': imageUrl,
      if (imageBlob != null) 'image_blob': imageBlob,
      if (year != null) 'year': year,
    });
  }

  AlbumsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? bucketPrefix,
      Value<String?>? imageUrl,
      Value<Uint8List?>? imageBlob,
      Value<DateTime>? year}) {
    return AlbumsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      bucketPrefix: bucketPrefix ?? this.bucketPrefix,
      imageUrl: imageUrl ?? this.imageUrl,
      imageBlob: imageBlob ?? this.imageBlob,
      year: year ?? this.year,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (bucketPrefix.present) {
      map['bucket_prefix'] = Variable<String>(bucketPrefix.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (imageBlob.present) {
      map['image_blob'] = Variable<Uint8List>(imageBlob.value);
    }
    if (year.present) {
      map['year'] = Variable<DateTime>(year.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AlbumsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('bucketPrefix: $bucketPrefix, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('imageBlob: $imageBlob, ')
          ..write('year: $year')
          ..write(')'))
        .toString();
  }
}

class $AlbumGenresTable extends AlbumGenres
    with TableInfo<$AlbumGenresTable, AlbumGenre> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AlbumGenresTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _albumIdMeta =
      const VerificationMeta('albumId');
  @override
  late final GeneratedColumn<int> albumId = GeneratedColumn<int>(
      'album_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES albums (id)'));
  static const VerificationMeta _genreIdMeta =
      const VerificationMeta('genreId');
  @override
  late final GeneratedColumn<int> genreId = GeneratedColumn<int>(
      'genre_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES genres (id)'));
  @override
  List<GeneratedColumn> get $columns => [albumId, genreId];
  @override
  String get aliasedName => _alias ?? 'album_genres';
  @override
  String get actualTableName => 'album_genres';
  @override
  VerificationContext validateIntegrity(Insertable<AlbumGenre> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('album_id')) {
      context.handle(_albumIdMeta,
          albumId.isAcceptableOrUnknown(data['album_id']!, _albumIdMeta));
    } else if (isInserting) {
      context.missing(_albumIdMeta);
    }
    if (data.containsKey('genre_id')) {
      context.handle(_genreIdMeta,
          genreId.isAcceptableOrUnknown(data['genre_id']!, _genreIdMeta));
    } else if (isInserting) {
      context.missing(_genreIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  AlbumGenre map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AlbumGenre(
      albumId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}album_id'])!,
      genreId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}genre_id'])!,
    );
  }

  @override
  $AlbumGenresTable createAlias(String alias) {
    return $AlbumGenresTable(attachedDatabase, alias);
  }
}

class AlbumGenre extends DataClass implements Insertable<AlbumGenre> {
  final int albumId;
  final int genreId;
  const AlbumGenre({required this.albumId, required this.genreId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['album_id'] = Variable<int>(albumId);
    map['genre_id'] = Variable<int>(genreId);
    return map;
  }

  AlbumGenresCompanion toCompanion(bool nullToAbsent) {
    return AlbumGenresCompanion(
      albumId: Value(albumId),
      genreId: Value(genreId),
    );
  }

  factory AlbumGenre.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AlbumGenre(
      albumId: serializer.fromJson<int>(json['albumId']),
      genreId: serializer.fromJson<int>(json['genreId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'albumId': serializer.toJson<int>(albumId),
      'genreId': serializer.toJson<int>(genreId),
    };
  }

  AlbumGenre copyWith({int? albumId, int? genreId}) => AlbumGenre(
        albumId: albumId ?? this.albumId,
        genreId: genreId ?? this.genreId,
      );
  @override
  String toString() {
    return (StringBuffer('AlbumGenre(')
          ..write('albumId: $albumId, ')
          ..write('genreId: $genreId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(albumId, genreId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AlbumGenre &&
          other.albumId == this.albumId &&
          other.genreId == this.genreId);
}

class AlbumGenresCompanion extends UpdateCompanion<AlbumGenre> {
  final Value<int> albumId;
  final Value<int> genreId;
  final Value<int> rowid;
  const AlbumGenresCompanion({
    this.albumId = const Value.absent(),
    this.genreId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AlbumGenresCompanion.insert({
    required int albumId,
    required int genreId,
    this.rowid = const Value.absent(),
  })  : albumId = Value(albumId),
        genreId = Value(genreId);
  static Insertable<AlbumGenre> custom({
    Expression<int>? albumId,
    Expression<int>? genreId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (albumId != null) 'album_id': albumId,
      if (genreId != null) 'genre_id': genreId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AlbumGenresCompanion copyWith(
      {Value<int>? albumId, Value<int>? genreId, Value<int>? rowid}) {
    return AlbumGenresCompanion(
      albumId: albumId ?? this.albumId,
      genreId: genreId ?? this.genreId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (albumId.present) {
      map['album_id'] = Variable<int>(albumId.value);
    }
    if (genreId.present) {
      map['genre_id'] = Variable<int>(genreId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AlbumGenresCompanion(')
          ..write('albumId: $albumId, ')
          ..write('genreId: $genreId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AlbumLabelsTable extends AlbumLabels
    with TableInfo<$AlbumLabelsTable, AlbumLabel> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AlbumLabelsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _albumIdMeta =
      const VerificationMeta('albumId');
  @override
  late final GeneratedColumn<int> albumId = GeneratedColumn<int>(
      'album_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES albums (id)'));
  static const VerificationMeta _genreIdMeta =
      const VerificationMeta('genreId');
  @override
  late final GeneratedColumn<int> genreId = GeneratedColumn<int>(
      'genre_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES genres (id)'));
  @override
  List<GeneratedColumn> get $columns => [albumId, genreId];
  @override
  String get aliasedName => _alias ?? 'album_labels';
  @override
  String get actualTableName => 'album_labels';
  @override
  VerificationContext validateIntegrity(Insertable<AlbumLabel> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('album_id')) {
      context.handle(_albumIdMeta,
          albumId.isAcceptableOrUnknown(data['album_id']!, _albumIdMeta));
    } else if (isInserting) {
      context.missing(_albumIdMeta);
    }
    if (data.containsKey('genre_id')) {
      context.handle(_genreIdMeta,
          genreId.isAcceptableOrUnknown(data['genre_id']!, _genreIdMeta));
    } else if (isInserting) {
      context.missing(_genreIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  AlbumLabel map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AlbumLabel(
      albumId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}album_id'])!,
      genreId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}genre_id'])!,
    );
  }

  @override
  $AlbumLabelsTable createAlias(String alias) {
    return $AlbumLabelsTable(attachedDatabase, alias);
  }
}

class AlbumLabel extends DataClass implements Insertable<AlbumLabel> {
  final int albumId;
  final int genreId;
  const AlbumLabel({required this.albumId, required this.genreId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['album_id'] = Variable<int>(albumId);
    map['genre_id'] = Variable<int>(genreId);
    return map;
  }

  AlbumLabelsCompanion toCompanion(bool nullToAbsent) {
    return AlbumLabelsCompanion(
      albumId: Value(albumId),
      genreId: Value(genreId),
    );
  }

  factory AlbumLabel.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AlbumLabel(
      albumId: serializer.fromJson<int>(json['albumId']),
      genreId: serializer.fromJson<int>(json['genreId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'albumId': serializer.toJson<int>(albumId),
      'genreId': serializer.toJson<int>(genreId),
    };
  }

  AlbumLabel copyWith({int? albumId, int? genreId}) => AlbumLabel(
        albumId: albumId ?? this.albumId,
        genreId: genreId ?? this.genreId,
      );
  @override
  String toString() {
    return (StringBuffer('AlbumLabel(')
          ..write('albumId: $albumId, ')
          ..write('genreId: $genreId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(albumId, genreId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AlbumLabel &&
          other.albumId == this.albumId &&
          other.genreId == this.genreId);
}

class AlbumLabelsCompanion extends UpdateCompanion<AlbumLabel> {
  final Value<int> albumId;
  final Value<int> genreId;
  final Value<int> rowid;
  const AlbumLabelsCompanion({
    this.albumId = const Value.absent(),
    this.genreId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AlbumLabelsCompanion.insert({
    required int albumId,
    required int genreId,
    this.rowid = const Value.absent(),
  })  : albumId = Value(albumId),
        genreId = Value(genreId);
  static Insertable<AlbumLabel> custom({
    Expression<int>? albumId,
    Expression<int>? genreId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (albumId != null) 'album_id': albumId,
      if (genreId != null) 'genre_id': genreId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AlbumLabelsCompanion copyWith(
      {Value<int>? albumId, Value<int>? genreId, Value<int>? rowid}) {
    return AlbumLabelsCompanion(
      albumId: albumId ?? this.albumId,
      genreId: genreId ?? this.genreId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (albumId.present) {
      map['album_id'] = Variable<int>(albumId.value);
    }
    if (genreId.present) {
      map['genre_id'] = Variable<int>(genreId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AlbumLabelsCompanion(')
          ..write('albumId: $albumId, ')
          ..write('genreId: $genreId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AlbumArtistsTable extends AlbumArtists
    with TableInfo<$AlbumArtistsTable, AlbumArtist> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AlbumArtistsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id =
      GeneratedColumn<String>('id', aliasedName, false,
          additionalChecks: GeneratedColumn.checkTextLength(
            minTextLength: 2,
          ),
          type: DriftSqlType.string,
          requiredDuringInsert: true,
          defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _albumIdMeta =
      const VerificationMeta('albumId');
  @override
  late final GeneratedColumn<int> albumId = GeneratedColumn<int>(
      'album_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES albums (id)'));
  static const VerificationMeta _artistIdMeta =
      const VerificationMeta('artistId');
  @override
  late final GeneratedColumn<int> artistId = GeneratedColumn<int>(
      'artist_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES artists (id)'));
  @override
  List<GeneratedColumn> get $columns => [id, albumId, artistId];
  @override
  String get aliasedName => _alias ?? 'album_artists';
  @override
  String get actualTableName => 'album_artists';
  @override
  VerificationContext validateIntegrity(Insertable<AlbumArtist> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('album_id')) {
      context.handle(_albumIdMeta,
          albumId.isAcceptableOrUnknown(data['album_id']!, _albumIdMeta));
    } else if (isInserting) {
      context.missing(_albumIdMeta);
    }
    if (data.containsKey('artist_id')) {
      context.handle(_artistIdMeta,
          artistId.isAcceptableOrUnknown(data['artist_id']!, _artistIdMeta));
    } else if (isInserting) {
      context.missing(_artistIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  AlbumArtist map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AlbumArtist(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      albumId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}album_id'])!,
      artistId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}artist_id'])!,
    );
  }

  @override
  $AlbumArtistsTable createAlias(String alias) {
    return $AlbumArtistsTable(attachedDatabase, alias);
  }
}

class AlbumArtist extends DataClass implements Insertable<AlbumArtist> {
  final String id;
  final int albumId;
  final int artistId;
  const AlbumArtist(
      {required this.id, required this.albumId, required this.artistId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['album_id'] = Variable<int>(albumId);
    map['artist_id'] = Variable<int>(artistId);
    return map;
  }

  AlbumArtistsCompanion toCompanion(bool nullToAbsent) {
    return AlbumArtistsCompanion(
      id: Value(id),
      albumId: Value(albumId),
      artistId: Value(artistId),
    );
  }

  factory AlbumArtist.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AlbumArtist(
      id: serializer.fromJson<String>(json['id']),
      albumId: serializer.fromJson<int>(json['albumId']),
      artistId: serializer.fromJson<int>(json['artistId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'albumId': serializer.toJson<int>(albumId),
      'artistId': serializer.toJson<int>(artistId),
    };
  }

  AlbumArtist copyWith({String? id, int? albumId, int? artistId}) =>
      AlbumArtist(
        id: id ?? this.id,
        albumId: albumId ?? this.albumId,
        artistId: artistId ?? this.artistId,
      );
  @override
  String toString() {
    return (StringBuffer('AlbumArtist(')
          ..write('id: $id, ')
          ..write('albumId: $albumId, ')
          ..write('artistId: $artistId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, albumId, artistId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AlbumArtist &&
          other.id == this.id &&
          other.albumId == this.albumId &&
          other.artistId == this.artistId);
}

class AlbumArtistsCompanion extends UpdateCompanion<AlbumArtist> {
  final Value<String> id;
  final Value<int> albumId;
  final Value<int> artistId;
  final Value<int> rowid;
  const AlbumArtistsCompanion({
    this.id = const Value.absent(),
    this.albumId = const Value.absent(),
    this.artistId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AlbumArtistsCompanion.insert({
    required String id,
    required int albumId,
    required int artistId,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        albumId = Value(albumId),
        artistId = Value(artistId);
  static Insertable<AlbumArtist> custom({
    Expression<String>? id,
    Expression<int>? albumId,
    Expression<int>? artistId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (albumId != null) 'album_id': albumId,
      if (artistId != null) 'artist_id': artistId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AlbumArtistsCompanion copyWith(
      {Value<String>? id,
      Value<int>? albumId,
      Value<int>? artistId,
      Value<int>? rowid}) {
    return AlbumArtistsCompanion(
      id: id ?? this.id,
      albumId: albumId ?? this.albumId,
      artistId: artistId ?? this.artistId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (albumId.present) {
      map['album_id'] = Variable<int>(albumId.value);
    }
    if (artistId.present) {
      map['artist_id'] = Variable<int>(artistId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AlbumArtistsCompanion(')
          ..write('id: $id, ')
          ..write('albumId: $albumId, ')
          ..write('artistId: $artistId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SongsTable extends Songs with TableInfo<$SongsTable, Song> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SongsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title =
      GeneratedColumn<String>('title', aliasedName, false,
          additionalChecks: GeneratedColumn.checkTextLength(
            minTextLength: 1,
          ),
          type: DriftSqlType.string,
          requiredDuringInsert: true);
  static const VerificationMeta _bucketNameMeta =
      const VerificationMeta('bucketName');
  @override
  late final GeneratedColumn<String> bucketName = GeneratedColumn<String>(
      'bucket_name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES music_buckets (name)'));
  static const VerificationMeta _bucketKeyMeta =
      const VerificationMeta('bucketKey');
  @override
  late final GeneratedColumn<String> bucketKey =
      GeneratedColumn<String>('bucket_key', aliasedName, false,
          additionalChecks: GeneratedColumn.checkTextLength(
            minTextLength: 1,
          ),
          type: DriftSqlType.string,
          requiredDuringInsert: true,
          defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _streamUrlMeta =
      const VerificationMeta('streamUrl');
  @override
  late final GeneratedColumn<String> streamUrl =
      GeneratedColumn<String>('stream_url', aliasedName, true,
          additionalChecks: GeneratedColumn.checkTextLength(
            minTextLength: 1,
          ),
          type: DriftSqlType.string,
          requiredDuringInsert: false);
  static const VerificationMeta _localPathMeta =
      const VerificationMeta('localPath');
  @override
  late final GeneratedColumn<String> localPath = GeneratedColumn<String>(
      'local_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _imageUrlMeta =
      const VerificationMeta('imageUrl');
  @override
  late final GeneratedColumn<String> imageUrl =
      GeneratedColumn<String>('image_url', aliasedName, true,
          additionalChecks: GeneratedColumn.checkTextLength(
            minTextLength: 1,
          ),
          type: DriftSqlType.string,
          requiredDuringInsert: false);
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<DateTime> year = GeneratedColumn<DateTime>(
      'year', aliasedName, false,
      check: () => year.isBiggerThan(Constant(DateTime(1000))),
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true);
  static const VerificationMeta _isSingleMeta =
      const VerificationMeta('isSingle');
  @override
  late final GeneratedColumn<bool> isSingle =
      GeneratedColumn<bool>('is_single', aliasedName, false,
          type: DriftSqlType.bool,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintsDependsOnDialect({
            SqlDialect.sqlite: 'CHECK ("is_single" IN (0, 1))',
            SqlDialect.mysql: '',
            SqlDialect.postgres: '',
          }),
          defaultValue: const Constant(false));
  static const VerificationMeta _durationMeta =
      const VerificationMeta('duration');
  @override
  late final GeneratedColumn<int> duration = GeneratedColumn<int>(
      'duration', aliasedName, false,
      check: () => duration.isBiggerOrEqual(const Constant(1)),
      type: DriftSqlType.int,
      requiredDuringInsert: true);
  static const VerificationMeta _albumIdMeta =
      const VerificationMeta('albumId');
  @override
  late final GeneratedColumn<int> albumId = GeneratedColumn<int>(
      'album_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES albums (id)'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        bucketName,
        bucketKey,
        streamUrl,
        localPath,
        imageUrl,
        year,
        isSingle,
        duration,
        albumId
      ];
  @override
  String get aliasedName => _alias ?? 'songs';
  @override
  String get actualTableName => 'songs';
  @override
  VerificationContext validateIntegrity(Insertable<Song> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('bucket_name')) {
      context.handle(
          _bucketNameMeta,
          bucketName.isAcceptableOrUnknown(
              data['bucket_name']!, _bucketNameMeta));
    } else if (isInserting) {
      context.missing(_bucketNameMeta);
    }
    if (data.containsKey('bucket_key')) {
      context.handle(_bucketKeyMeta,
          bucketKey.isAcceptableOrUnknown(data['bucket_key']!, _bucketKeyMeta));
    } else if (isInserting) {
      context.missing(_bucketKeyMeta);
    }
    if (data.containsKey('stream_url')) {
      context.handle(_streamUrlMeta,
          streamUrl.isAcceptableOrUnknown(data['stream_url']!, _streamUrlMeta));
    }
    if (data.containsKey('local_path')) {
      context.handle(_localPathMeta,
          localPath.isAcceptableOrUnknown(data['local_path']!, _localPathMeta));
    }
    if (data.containsKey('image_url')) {
      context.handle(_imageUrlMeta,
          imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta));
    }
    if (data.containsKey('year')) {
      context.handle(
          _yearMeta, year.isAcceptableOrUnknown(data['year']!, _yearMeta));
    } else if (isInserting) {
      context.missing(_yearMeta);
    }
    if (data.containsKey('is_single')) {
      context.handle(_isSingleMeta,
          isSingle.isAcceptableOrUnknown(data['is_single']!, _isSingleMeta));
    }
    if (data.containsKey('duration')) {
      context.handle(_durationMeta,
          duration.isAcceptableOrUnknown(data['duration']!, _durationMeta));
    } else if (isInserting) {
      context.missing(_durationMeta);
    }
    if (data.containsKey('album_id')) {
      context.handle(_albumIdMeta,
          albumId.isAcceptableOrUnknown(data['album_id']!, _albumIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Song map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Song(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      bucketName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}bucket_name'])!,
      bucketKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}bucket_key'])!,
      streamUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}stream_url']),
      localPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}local_path']),
      imageUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image_url']),
      year: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}year'])!,
      isSingle: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_single'])!,
      duration: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}duration'])!,
      albumId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}album_id']),
    );
  }

  @override
  $SongsTable createAlias(String alias) {
    return $SongsTable(attachedDatabase, alias);
  }
}

class Song extends DataClass implements Insertable<Song> {
  final int id;
  final String title;
  final String bucketName;
  final String bucketKey;
  final String? streamUrl;
  final String? localPath;
  final String? imageUrl;
  final DateTime year;
  final bool isSingle;
  final int duration;
  final int? albumId;
  const Song(
      {required this.id,
      required this.title,
      required this.bucketName,
      required this.bucketKey,
      this.streamUrl,
      this.localPath,
      this.imageUrl,
      required this.year,
      required this.isSingle,
      required this.duration,
      this.albumId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['bucket_name'] = Variable<String>(bucketName);
    map['bucket_key'] = Variable<String>(bucketKey);
    if (!nullToAbsent || streamUrl != null) {
      map['stream_url'] = Variable<String>(streamUrl);
    }
    if (!nullToAbsent || localPath != null) {
      map['local_path'] = Variable<String>(localPath);
    }
    if (!nullToAbsent || imageUrl != null) {
      map['image_url'] = Variable<String>(imageUrl);
    }
    map['year'] = Variable<DateTime>(year);
    map['is_single'] = Variable<bool>(isSingle);
    map['duration'] = Variable<int>(duration);
    if (!nullToAbsent || albumId != null) {
      map['album_id'] = Variable<int>(albumId);
    }
    return map;
  }

  SongsCompanion toCompanion(bool nullToAbsent) {
    return SongsCompanion(
      id: Value(id),
      title: Value(title),
      bucketName: Value(bucketName),
      bucketKey: Value(bucketKey),
      streamUrl: streamUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(streamUrl),
      localPath: localPath == null && nullToAbsent
          ? const Value.absent()
          : Value(localPath),
      imageUrl: imageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrl),
      year: Value(year),
      isSingle: Value(isSingle),
      duration: Value(duration),
      albumId: albumId == null && nullToAbsent
          ? const Value.absent()
          : Value(albumId),
    );
  }

  factory Song.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Song(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      bucketName: serializer.fromJson<String>(json['bucketName']),
      bucketKey: serializer.fromJson<String>(json['bucketKey']),
      streamUrl: serializer.fromJson<String?>(json['streamUrl']),
      localPath: serializer.fromJson<String?>(json['localPath']),
      imageUrl: serializer.fromJson<String?>(json['imageUrl']),
      year: serializer.fromJson<DateTime>(json['year']),
      isSingle: serializer.fromJson<bool>(json['isSingle']),
      duration: serializer.fromJson<int>(json['duration']),
      albumId: serializer.fromJson<int?>(json['albumId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'bucketName': serializer.toJson<String>(bucketName),
      'bucketKey': serializer.toJson<String>(bucketKey),
      'streamUrl': serializer.toJson<String?>(streamUrl),
      'localPath': serializer.toJson<String?>(localPath),
      'imageUrl': serializer.toJson<String?>(imageUrl),
      'year': serializer.toJson<DateTime>(year),
      'isSingle': serializer.toJson<bool>(isSingle),
      'duration': serializer.toJson<int>(duration),
      'albumId': serializer.toJson<int?>(albumId),
    };
  }

  Song copyWith(
          {int? id,
          String? title,
          String? bucketName,
          String? bucketKey,
          Value<String?> streamUrl = const Value.absent(),
          Value<String?> localPath = const Value.absent(),
          Value<String?> imageUrl = const Value.absent(),
          DateTime? year,
          bool? isSingle,
          int? duration,
          Value<int?> albumId = const Value.absent()}) =>
      Song(
        id: id ?? this.id,
        title: title ?? this.title,
        bucketName: bucketName ?? this.bucketName,
        bucketKey: bucketKey ?? this.bucketKey,
        streamUrl: streamUrl.present ? streamUrl.value : this.streamUrl,
        localPath: localPath.present ? localPath.value : this.localPath,
        imageUrl: imageUrl.present ? imageUrl.value : this.imageUrl,
        year: year ?? this.year,
        isSingle: isSingle ?? this.isSingle,
        duration: duration ?? this.duration,
        albumId: albumId.present ? albumId.value : this.albumId,
      );
  @override
  String toString() {
    return (StringBuffer('Song(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('bucketName: $bucketName, ')
          ..write('bucketKey: $bucketKey, ')
          ..write('streamUrl: $streamUrl, ')
          ..write('localPath: $localPath, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('year: $year, ')
          ..write('isSingle: $isSingle, ')
          ..write('duration: $duration, ')
          ..write('albumId: $albumId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, bucketName, bucketKey, streamUrl,
      localPath, imageUrl, year, isSingle, duration, albumId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Song &&
          other.id == this.id &&
          other.title == this.title &&
          other.bucketName == this.bucketName &&
          other.bucketKey == this.bucketKey &&
          other.streamUrl == this.streamUrl &&
          other.localPath == this.localPath &&
          other.imageUrl == this.imageUrl &&
          other.year == this.year &&
          other.isSingle == this.isSingle &&
          other.duration == this.duration &&
          other.albumId == this.albumId);
}

class SongsCompanion extends UpdateCompanion<Song> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> bucketName;
  final Value<String> bucketKey;
  final Value<String?> streamUrl;
  final Value<String?> localPath;
  final Value<String?> imageUrl;
  final Value<DateTime> year;
  final Value<bool> isSingle;
  final Value<int> duration;
  final Value<int?> albumId;
  const SongsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.bucketName = const Value.absent(),
    this.bucketKey = const Value.absent(),
    this.streamUrl = const Value.absent(),
    this.localPath = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.year = const Value.absent(),
    this.isSingle = const Value.absent(),
    this.duration = const Value.absent(),
    this.albumId = const Value.absent(),
  });
  SongsCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required String bucketName,
    required String bucketKey,
    this.streamUrl = const Value.absent(),
    this.localPath = const Value.absent(),
    this.imageUrl = const Value.absent(),
    required DateTime year,
    this.isSingle = const Value.absent(),
    required int duration,
    this.albumId = const Value.absent(),
  })  : title = Value(title),
        bucketName = Value(bucketName),
        bucketKey = Value(bucketKey),
        year = Value(year),
        duration = Value(duration);
  static Insertable<Song> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? bucketName,
    Expression<String>? bucketKey,
    Expression<String>? streamUrl,
    Expression<String>? localPath,
    Expression<String>? imageUrl,
    Expression<DateTime>? year,
    Expression<bool>? isSingle,
    Expression<int>? duration,
    Expression<int>? albumId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (bucketName != null) 'bucket_name': bucketName,
      if (bucketKey != null) 'bucket_key': bucketKey,
      if (streamUrl != null) 'stream_url': streamUrl,
      if (localPath != null) 'local_path': localPath,
      if (imageUrl != null) 'image_url': imageUrl,
      if (year != null) 'year': year,
      if (isSingle != null) 'is_single': isSingle,
      if (duration != null) 'duration': duration,
      if (albumId != null) 'album_id': albumId,
    });
  }

  SongsCompanion copyWith(
      {Value<int>? id,
      Value<String>? title,
      Value<String>? bucketName,
      Value<String>? bucketKey,
      Value<String?>? streamUrl,
      Value<String?>? localPath,
      Value<String?>? imageUrl,
      Value<DateTime>? year,
      Value<bool>? isSingle,
      Value<int>? duration,
      Value<int?>? albumId}) {
    return SongsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      bucketName: bucketName ?? this.bucketName,
      bucketKey: bucketKey ?? this.bucketKey,
      streamUrl: streamUrl ?? this.streamUrl,
      localPath: localPath ?? this.localPath,
      imageUrl: imageUrl ?? this.imageUrl,
      year: year ?? this.year,
      isSingle: isSingle ?? this.isSingle,
      duration: duration ?? this.duration,
      albumId: albumId ?? this.albumId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (bucketName.present) {
      map['bucket_name'] = Variable<String>(bucketName.value);
    }
    if (bucketKey.present) {
      map['bucket_key'] = Variable<String>(bucketKey.value);
    }
    if (streamUrl.present) {
      map['stream_url'] = Variable<String>(streamUrl.value);
    }
    if (localPath.present) {
      map['local_path'] = Variable<String>(localPath.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (year.present) {
      map['year'] = Variable<DateTime>(year.value);
    }
    if (isSingle.present) {
      map['is_single'] = Variable<bool>(isSingle.value);
    }
    if (duration.present) {
      map['duration'] = Variable<int>(duration.value);
    }
    if (albumId.present) {
      map['album_id'] = Variable<int>(albumId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SongsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('bucketName: $bucketName, ')
          ..write('bucketKey: $bucketKey, ')
          ..write('streamUrl: $streamUrl, ')
          ..write('localPath: $localPath, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('year: $year, ')
          ..write('isSingle: $isSingle, ')
          ..write('duration: $duration, ')
          ..write('albumId: $albumId')
          ..write(')'))
        .toString();
  }
}

class $SongGenresTable extends SongGenres
    with TableInfo<$SongGenresTable, SongGenre> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SongGenresTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id =
      GeneratedColumn<String>('id', aliasedName, false,
          additionalChecks: GeneratedColumn.checkTextLength(
            minTextLength: 2,
          ),
          type: DriftSqlType.string,
          requiredDuringInsert: true,
          defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _songIdMeta = const VerificationMeta('songId');
  @override
  late final GeneratedColumn<int> songId = GeneratedColumn<int>(
      'song_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES songs (id)'));
  static const VerificationMeta _genreIdMeta =
      const VerificationMeta('genreId');
  @override
  late final GeneratedColumn<int> genreId = GeneratedColumn<int>(
      'genre_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES genres (id)'));
  @override
  List<GeneratedColumn> get $columns => [id, songId, genreId];
  @override
  String get aliasedName => _alias ?? 'song_genres';
  @override
  String get actualTableName => 'song_genres';
  @override
  VerificationContext validateIntegrity(Insertable<SongGenre> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('song_id')) {
      context.handle(_songIdMeta,
          songId.isAcceptableOrUnknown(data['song_id']!, _songIdMeta));
    } else if (isInserting) {
      context.missing(_songIdMeta);
    }
    if (data.containsKey('genre_id')) {
      context.handle(_genreIdMeta,
          genreId.isAcceptableOrUnknown(data['genre_id']!, _genreIdMeta));
    } else if (isInserting) {
      context.missing(_genreIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  SongGenre map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SongGenre(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      songId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}song_id'])!,
      genreId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}genre_id'])!,
    );
  }

  @override
  $SongGenresTable createAlias(String alias) {
    return $SongGenresTable(attachedDatabase, alias);
  }
}

class SongGenre extends DataClass implements Insertable<SongGenre> {
  final String id;
  final int songId;
  final int genreId;
  const SongGenre(
      {required this.id, required this.songId, required this.genreId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['song_id'] = Variable<int>(songId);
    map['genre_id'] = Variable<int>(genreId);
    return map;
  }

  SongGenresCompanion toCompanion(bool nullToAbsent) {
    return SongGenresCompanion(
      id: Value(id),
      songId: Value(songId),
      genreId: Value(genreId),
    );
  }

  factory SongGenre.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SongGenre(
      id: serializer.fromJson<String>(json['id']),
      songId: serializer.fromJson<int>(json['songId']),
      genreId: serializer.fromJson<int>(json['genreId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'songId': serializer.toJson<int>(songId),
      'genreId': serializer.toJson<int>(genreId),
    };
  }

  SongGenre copyWith({String? id, int? songId, int? genreId}) => SongGenre(
        id: id ?? this.id,
        songId: songId ?? this.songId,
        genreId: genreId ?? this.genreId,
      );
  @override
  String toString() {
    return (StringBuffer('SongGenre(')
          ..write('id: $id, ')
          ..write('songId: $songId, ')
          ..write('genreId: $genreId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, songId, genreId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SongGenre &&
          other.id == this.id &&
          other.songId == this.songId &&
          other.genreId == this.genreId);
}

class SongGenresCompanion extends UpdateCompanion<SongGenre> {
  final Value<String> id;
  final Value<int> songId;
  final Value<int> genreId;
  final Value<int> rowid;
  const SongGenresCompanion({
    this.id = const Value.absent(),
    this.songId = const Value.absent(),
    this.genreId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SongGenresCompanion.insert({
    required String id,
    required int songId,
    required int genreId,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        songId = Value(songId),
        genreId = Value(genreId);
  static Insertable<SongGenre> custom({
    Expression<String>? id,
    Expression<int>? songId,
    Expression<int>? genreId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (songId != null) 'song_id': songId,
      if (genreId != null) 'genre_id': genreId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SongGenresCompanion copyWith(
      {Value<String>? id,
      Value<int>? songId,
      Value<int>? genreId,
      Value<int>? rowid}) {
    return SongGenresCompanion(
      id: id ?? this.id,
      songId: songId ?? this.songId,
      genreId: genreId ?? this.genreId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (songId.present) {
      map['song_id'] = Variable<int>(songId.value);
    }
    if (genreId.present) {
      map['genre_id'] = Variable<int>(genreId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SongGenresCompanion(')
          ..write('id: $id, ')
          ..write('songId: $songId, ')
          ..write('genreId: $genreId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SongLabelsTable extends SongLabels
    with TableInfo<$SongLabelsTable, SongLabel> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SongLabelsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id =
      GeneratedColumn<String>('id', aliasedName, false,
          additionalChecks: GeneratedColumn.checkTextLength(
            minTextLength: 2,
          ),
          type: DriftSqlType.string,
          requiredDuringInsert: true,
          defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _songIdMeta = const VerificationMeta('songId');
  @override
  late final GeneratedColumn<int> songId = GeneratedColumn<int>(
      'song_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES songs (id)'));
  static const VerificationMeta _genreIdMeta =
      const VerificationMeta('genreId');
  @override
  late final GeneratedColumn<int> genreId = GeneratedColumn<int>(
      'genre_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES genres (id)'));
  @override
  List<GeneratedColumn> get $columns => [id, songId, genreId];
  @override
  String get aliasedName => _alias ?? 'song_labels';
  @override
  String get actualTableName => 'song_labels';
  @override
  VerificationContext validateIntegrity(Insertable<SongLabel> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('song_id')) {
      context.handle(_songIdMeta,
          songId.isAcceptableOrUnknown(data['song_id']!, _songIdMeta));
    } else if (isInserting) {
      context.missing(_songIdMeta);
    }
    if (data.containsKey('genre_id')) {
      context.handle(_genreIdMeta,
          genreId.isAcceptableOrUnknown(data['genre_id']!, _genreIdMeta));
    } else if (isInserting) {
      context.missing(_genreIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  SongLabel map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SongLabel(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      songId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}song_id'])!,
      genreId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}genre_id'])!,
    );
  }

  @override
  $SongLabelsTable createAlias(String alias) {
    return $SongLabelsTable(attachedDatabase, alias);
  }
}

class SongLabel extends DataClass implements Insertable<SongLabel> {
  final String id;
  final int songId;
  final int genreId;
  const SongLabel(
      {required this.id, required this.songId, required this.genreId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['song_id'] = Variable<int>(songId);
    map['genre_id'] = Variable<int>(genreId);
    return map;
  }

  SongLabelsCompanion toCompanion(bool nullToAbsent) {
    return SongLabelsCompanion(
      id: Value(id),
      songId: Value(songId),
      genreId: Value(genreId),
    );
  }

  factory SongLabel.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SongLabel(
      id: serializer.fromJson<String>(json['id']),
      songId: serializer.fromJson<int>(json['songId']),
      genreId: serializer.fromJson<int>(json['genreId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'songId': serializer.toJson<int>(songId),
      'genreId': serializer.toJson<int>(genreId),
    };
  }

  SongLabel copyWith({String? id, int? songId, int? genreId}) => SongLabel(
        id: id ?? this.id,
        songId: songId ?? this.songId,
        genreId: genreId ?? this.genreId,
      );
  @override
  String toString() {
    return (StringBuffer('SongLabel(')
          ..write('id: $id, ')
          ..write('songId: $songId, ')
          ..write('genreId: $genreId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, songId, genreId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SongLabel &&
          other.id == this.id &&
          other.songId == this.songId &&
          other.genreId == this.genreId);
}

class SongLabelsCompanion extends UpdateCompanion<SongLabel> {
  final Value<String> id;
  final Value<int> songId;
  final Value<int> genreId;
  final Value<int> rowid;
  const SongLabelsCompanion({
    this.id = const Value.absent(),
    this.songId = const Value.absent(),
    this.genreId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SongLabelsCompanion.insert({
    required String id,
    required int songId,
    required int genreId,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        songId = Value(songId),
        genreId = Value(genreId);
  static Insertable<SongLabel> custom({
    Expression<String>? id,
    Expression<int>? songId,
    Expression<int>? genreId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (songId != null) 'song_id': songId,
      if (genreId != null) 'genre_id': genreId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SongLabelsCompanion copyWith(
      {Value<String>? id,
      Value<int>? songId,
      Value<int>? genreId,
      Value<int>? rowid}) {
    return SongLabelsCompanion(
      id: id ?? this.id,
      songId: songId ?? this.songId,
      genreId: genreId ?? this.genreId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (songId.present) {
      map['song_id'] = Variable<int>(songId.value);
    }
    if (genreId.present) {
      map['genre_id'] = Variable<int>(genreId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SongLabelsCompanion(')
          ..write('id: $id, ')
          ..write('songId: $songId, ')
          ..write('genreId: $genreId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SongArtistsTable extends SongArtists
    with TableInfo<$SongArtistsTable, SongArtist> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SongArtistsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id =
      GeneratedColumn<String>('id', aliasedName, false,
          additionalChecks: GeneratedColumn.checkTextLength(
            minTextLength: 2,
          ),
          type: DriftSqlType.string,
          requiredDuringInsert: true,
          defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _songIdMeta = const VerificationMeta('songId');
  @override
  late final GeneratedColumn<int> songId = GeneratedColumn<int>(
      'song_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES songs (id)'));
  static const VerificationMeta _artistIdMeta =
      const VerificationMeta('artistId');
  @override
  late final GeneratedColumn<int> artistId = GeneratedColumn<int>(
      'artist_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES artists (id)'));
  @override
  List<GeneratedColumn> get $columns => [id, songId, artistId];
  @override
  String get aliasedName => _alias ?? 'song_artists';
  @override
  String get actualTableName => 'song_artists';
  @override
  VerificationContext validateIntegrity(Insertable<SongArtist> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('song_id')) {
      context.handle(_songIdMeta,
          songId.isAcceptableOrUnknown(data['song_id']!, _songIdMeta));
    } else if (isInserting) {
      context.missing(_songIdMeta);
    }
    if (data.containsKey('artist_id')) {
      context.handle(_artistIdMeta,
          artistId.isAcceptableOrUnknown(data['artist_id']!, _artistIdMeta));
    } else if (isInserting) {
      context.missing(_artistIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  SongArtist map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SongArtist(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      songId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}song_id'])!,
      artistId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}artist_id'])!,
    );
  }

  @override
  $SongArtistsTable createAlias(String alias) {
    return $SongArtistsTable(attachedDatabase, alias);
  }
}

class SongArtist extends DataClass implements Insertable<SongArtist> {
  final String id;
  final int songId;
  final int artistId;
  const SongArtist(
      {required this.id, required this.songId, required this.artistId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['song_id'] = Variable<int>(songId);
    map['artist_id'] = Variable<int>(artistId);
    return map;
  }

  SongArtistsCompanion toCompanion(bool nullToAbsent) {
    return SongArtistsCompanion(
      id: Value(id),
      songId: Value(songId),
      artistId: Value(artistId),
    );
  }

  factory SongArtist.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SongArtist(
      id: serializer.fromJson<String>(json['id']),
      songId: serializer.fromJson<int>(json['songId']),
      artistId: serializer.fromJson<int>(json['artistId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'songId': serializer.toJson<int>(songId),
      'artistId': serializer.toJson<int>(artistId),
    };
  }

  SongArtist copyWith({String? id, int? songId, int? artistId}) => SongArtist(
        id: id ?? this.id,
        songId: songId ?? this.songId,
        artistId: artistId ?? this.artistId,
      );
  @override
  String toString() {
    return (StringBuffer('SongArtist(')
          ..write('id: $id, ')
          ..write('songId: $songId, ')
          ..write('artistId: $artistId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, songId, artistId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SongArtist &&
          other.id == this.id &&
          other.songId == this.songId &&
          other.artistId == this.artistId);
}

class SongArtistsCompanion extends UpdateCompanion<SongArtist> {
  final Value<String> id;
  final Value<int> songId;
  final Value<int> artistId;
  final Value<int> rowid;
  const SongArtistsCompanion({
    this.id = const Value.absent(),
    this.songId = const Value.absent(),
    this.artistId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SongArtistsCompanion.insert({
    required String id,
    required int songId,
    required int artistId,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        songId = Value(songId),
        artistId = Value(artistId);
  static Insertable<SongArtist> custom({
    Expression<String>? id,
    Expression<int>? songId,
    Expression<int>? artistId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (songId != null) 'song_id': songId,
      if (artistId != null) 'artist_id': artistId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SongArtistsCompanion copyWith(
      {Value<String>? id,
      Value<int>? songId,
      Value<int>? artistId,
      Value<int>? rowid}) {
    return SongArtistsCompanion(
      id: id ?? this.id,
      songId: songId ?? this.songId,
      artistId: artistId ?? this.artistId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (songId.present) {
      map['song_id'] = Variable<int>(songId.value);
    }
    if (artistId.present) {
      map['artist_id'] = Variable<int>(artistId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SongArtistsCompanion(')
          ..write('id: $id, ')
          ..write('songId: $songId, ')
          ..write('artistId: $artistId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SongGroupsTable extends SongGroups
    with TableInfo<$SongGroupsTable, SongGroup> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SongGroupsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id =
      GeneratedColumn<String>('id', aliasedName, false,
          additionalChecks: GeneratedColumn.checkTextLength(
            minTextLength: 2,
          ),
          type: DriftSqlType.string,
          requiredDuringInsert: true,
          defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _songIdMeta = const VerificationMeta('songId');
  @override
  late final GeneratedColumn<int> songId = GeneratedColumn<int>(
      'song_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES songs (id)'));
  static const VerificationMeta _groupIdMeta =
      const VerificationMeta('groupId');
  @override
  late final GeneratedColumn<int> groupId = GeneratedColumn<int>(
      'group_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES "groups" (id)'));
  @override
  List<GeneratedColumn> get $columns => [id, songId, groupId];
  @override
  String get aliasedName => _alias ?? 'song_groups';
  @override
  String get actualTableName => 'song_groups';
  @override
  VerificationContext validateIntegrity(Insertable<SongGroup> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('song_id')) {
      context.handle(_songIdMeta,
          songId.isAcceptableOrUnknown(data['song_id']!, _songIdMeta));
    } else if (isInserting) {
      context.missing(_songIdMeta);
    }
    if (data.containsKey('group_id')) {
      context.handle(_groupIdMeta,
          groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta));
    } else if (isInserting) {
      context.missing(_groupIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  SongGroup map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SongGroup(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      songId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}song_id'])!,
      groupId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}group_id'])!,
    );
  }

  @override
  $SongGroupsTable createAlias(String alias) {
    return $SongGroupsTable(attachedDatabase, alias);
  }
}

class SongGroup extends DataClass implements Insertable<SongGroup> {
  final String id;
  final int songId;
  final int groupId;
  const SongGroup(
      {required this.id, required this.songId, required this.groupId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['song_id'] = Variable<int>(songId);
    map['group_id'] = Variable<int>(groupId);
    return map;
  }

  SongGroupsCompanion toCompanion(bool nullToAbsent) {
    return SongGroupsCompanion(
      id: Value(id),
      songId: Value(songId),
      groupId: Value(groupId),
    );
  }

  factory SongGroup.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SongGroup(
      id: serializer.fromJson<String>(json['id']),
      songId: serializer.fromJson<int>(json['songId']),
      groupId: serializer.fromJson<int>(json['groupId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'songId': serializer.toJson<int>(songId),
      'groupId': serializer.toJson<int>(groupId),
    };
  }

  SongGroup copyWith({String? id, int? songId, int? groupId}) => SongGroup(
        id: id ?? this.id,
        songId: songId ?? this.songId,
        groupId: groupId ?? this.groupId,
      );
  @override
  String toString() {
    return (StringBuffer('SongGroup(')
          ..write('id: $id, ')
          ..write('songId: $songId, ')
          ..write('groupId: $groupId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, songId, groupId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SongGroup &&
          other.id == this.id &&
          other.songId == this.songId &&
          other.groupId == this.groupId);
}

class SongGroupsCompanion extends UpdateCompanion<SongGroup> {
  final Value<String> id;
  final Value<int> songId;
  final Value<int> groupId;
  final Value<int> rowid;
  const SongGroupsCompanion({
    this.id = const Value.absent(),
    this.songId = const Value.absent(),
    this.groupId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SongGroupsCompanion.insert({
    required String id,
    required int songId,
    required int groupId,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        songId = Value(songId),
        groupId = Value(groupId);
  static Insertable<SongGroup> custom({
    Expression<String>? id,
    Expression<int>? songId,
    Expression<int>? groupId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (songId != null) 'song_id': songId,
      if (groupId != null) 'group_id': groupId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SongGroupsCompanion copyWith(
      {Value<String>? id,
      Value<int>? songId,
      Value<int>? groupId,
      Value<int>? rowid}) {
    return SongGroupsCompanion(
      id: id ?? this.id,
      songId: songId ?? this.songId,
      groupId: groupId ?? this.groupId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (songId.present) {
      map['song_id'] = Variable<int>(songId.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<int>(groupId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SongGroupsCompanion(')
          ..write('id: $id, ')
          ..write('songId: $songId, ')
          ..write('groupId: $groupId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PlaylistsTable extends Playlists
    with TableInfo<$PlaylistsTable, Playlist> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlaylistsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name =
      GeneratedColumn<String>('name', aliasedName, false,
          additionalChecks: GeneratedColumn.checkTextLength(
            minTextLength: 1,
          ),
          type: DriftSqlType.string,
          requiredDuringInsert: true,
          defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  String get aliasedName => _alias ?? 'playlists';
  @override
  String get actualTableName => 'playlists';
  @override
  VerificationContext validateIntegrity(Insertable<Playlist> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Playlist map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Playlist(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
    );
  }

  @override
  $PlaylistsTable createAlias(String alias) {
    return $PlaylistsTable(attachedDatabase, alias);
  }
}

class Playlist extends DataClass implements Insertable<Playlist> {
  final int id;
  final String name;
  const Playlist({required this.id, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    return map;
  }

  PlaylistsCompanion toCompanion(bool nullToAbsent) {
    return PlaylistsCompanion(
      id: Value(id),
      name: Value(name),
    );
  }

  factory Playlist.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Playlist(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  Playlist copyWith({int? id, String? name}) => Playlist(
        id: id ?? this.id,
        name: name ?? this.name,
      );
  @override
  String toString() {
    return (StringBuffer('Playlist(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Playlist && other.id == this.id && other.name == this.name);
}

class PlaylistsCompanion extends UpdateCompanion<Playlist> {
  final Value<int> id;
  final Value<String> name;
  const PlaylistsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
  });
  PlaylistsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
  }) : name = Value(name);
  static Insertable<Playlist> custom({
    Expression<int>? id,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
    });
  }

  PlaylistsCompanion copyWith({Value<int>? id, Value<String>? name}) {
    return PlaylistsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlaylistsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $PlaylistSongsTable extends PlaylistSongs
    with TableInfo<$PlaylistSongsTable, PlaylistSong> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlaylistSongsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id =
      GeneratedColumn<String>('id', aliasedName, false,
          additionalChecks: GeneratedColumn.checkTextLength(
            minTextLength: 2,
          ),
          type: DriftSqlType.string,
          requiredDuringInsert: true,
          defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _playlistIdMeta =
      const VerificationMeta('playlistId');
  @override
  late final GeneratedColumn<int> playlistId = GeneratedColumn<int>(
      'playlist_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES playlists (id)'));
  static const VerificationMeta _songIdMeta = const VerificationMeta('songId');
  @override
  late final GeneratedColumn<int> songId = GeneratedColumn<int>(
      'song_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES songs (id)'));
  @override
  List<GeneratedColumn> get $columns => [id, playlistId, songId];
  @override
  String get aliasedName => _alias ?? 'playlist_songs';
  @override
  String get actualTableName => 'playlist_songs';
  @override
  VerificationContext validateIntegrity(Insertable<PlaylistSong> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('playlist_id')) {
      context.handle(
          _playlistIdMeta,
          playlistId.isAcceptableOrUnknown(
              data['playlist_id']!, _playlistIdMeta));
    } else if (isInserting) {
      context.missing(_playlistIdMeta);
    }
    if (data.containsKey('song_id')) {
      context.handle(_songIdMeta,
          songId.isAcceptableOrUnknown(data['song_id']!, _songIdMeta));
    } else if (isInserting) {
      context.missing(_songIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  PlaylistSong map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlaylistSong(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      playlistId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}playlist_id'])!,
      songId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}song_id'])!,
    );
  }

  @override
  $PlaylistSongsTable createAlias(String alias) {
    return $PlaylistSongsTable(attachedDatabase, alias);
  }
}

class PlaylistSong extends DataClass implements Insertable<PlaylistSong> {
  final String id;
  final int playlistId;
  final int songId;
  const PlaylistSong(
      {required this.id, required this.playlistId, required this.songId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['playlist_id'] = Variable<int>(playlistId);
    map['song_id'] = Variable<int>(songId);
    return map;
  }

  PlaylistSongsCompanion toCompanion(bool nullToAbsent) {
    return PlaylistSongsCompanion(
      id: Value(id),
      playlistId: Value(playlistId),
      songId: Value(songId),
    );
  }

  factory PlaylistSong.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlaylistSong(
      id: serializer.fromJson<String>(json['id']),
      playlistId: serializer.fromJson<int>(json['playlistId']),
      songId: serializer.fromJson<int>(json['songId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'playlistId': serializer.toJson<int>(playlistId),
      'songId': serializer.toJson<int>(songId),
    };
  }

  PlaylistSong copyWith({String? id, int? playlistId, int? songId}) =>
      PlaylistSong(
        id: id ?? this.id,
        playlistId: playlistId ?? this.playlistId,
        songId: songId ?? this.songId,
      );
  @override
  String toString() {
    return (StringBuffer('PlaylistSong(')
          ..write('id: $id, ')
          ..write('playlistId: $playlistId, ')
          ..write('songId: $songId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, playlistId, songId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlaylistSong &&
          other.id == this.id &&
          other.playlistId == this.playlistId &&
          other.songId == this.songId);
}

class PlaylistSongsCompanion extends UpdateCompanion<PlaylistSong> {
  final Value<String> id;
  final Value<int> playlistId;
  final Value<int> songId;
  final Value<int> rowid;
  const PlaylistSongsCompanion({
    this.id = const Value.absent(),
    this.playlistId = const Value.absent(),
    this.songId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlaylistSongsCompanion.insert({
    required String id,
    required int playlistId,
    required int songId,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        playlistId = Value(playlistId),
        songId = Value(songId);
  static Insertable<PlaylistSong> custom({
    Expression<String>? id,
    Expression<int>? playlistId,
    Expression<int>? songId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (playlistId != null) 'playlist_id': playlistId,
      if (songId != null) 'song_id': songId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlaylistSongsCompanion copyWith(
      {Value<String>? id,
      Value<int>? playlistId,
      Value<int>? songId,
      Value<int>? rowid}) {
    return PlaylistSongsCompanion(
      id: id ?? this.id,
      playlistId: playlistId ?? this.playlistId,
      songId: songId ?? this.songId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (playlistId.present) {
      map['playlist_id'] = Variable<int>(playlistId.value);
    }
    if (songId.present) {
      map['song_id'] = Variable<int>(songId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlaylistSongsCompanion(')
          ..write('id: $id, ')
          ..write('playlistId: $playlistId, ')
          ..write('songId: $songId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$LocalDB extends GeneratedDatabase {
  _$LocalDB(QueryExecutor e) : super(e);
  late final $MusicBucketsTable musicBuckets = $MusicBucketsTable(this);
  late final $GenresTable genres = $GenresTable(this);
  late final $LabelsTable labels = $LabelsTable(this);
  late final $LabelGenresTable labelGenres = $LabelGenresTable(this);
  late final $GroupsTable groups = $GroupsTable(this);
  late final $GroupGenresTable groupGenres = $GroupGenresTable(this);
  late final $GroupLabelsTable groupLabels = $GroupLabelsTable(this);
  late final $ArtistsTable artists = $ArtistsTable(this);
  late final $ArtistGenresTable artistGenres = $ArtistGenresTable(this);
  late final $ArtistLabelsTable artistLabels = $ArtistLabelsTable(this);
  late final $ArtistGroupsTable artistGroups = $ArtistGroupsTable(this);
  late final $AlbumsTable albums = $AlbumsTable(this);
  late final $AlbumGenresTable albumGenres = $AlbumGenresTable(this);
  late final $AlbumLabelsTable albumLabels = $AlbumLabelsTable(this);
  late final $AlbumArtistsTable albumArtists = $AlbumArtistsTable(this);
  late final $SongsTable songs = $SongsTable(this);
  late final $SongGenresTable songGenres = $SongGenresTable(this);
  late final $SongLabelsTable songLabels = $SongLabelsTable(this);
  late final $SongArtistsTable songArtists = $SongArtistsTable(this);
  late final $SongGroupsTable songGroups = $SongGroupsTable(this);
  late final $PlaylistsTable playlists = $PlaylistsTable(this);
  late final $PlaylistSongsTable playlistSongs = $PlaylistSongsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        musicBuckets,
        genres,
        labels,
        labelGenres,
        groups,
        groupGenres,
        groupLabels,
        artists,
        artistGenres,
        artistLabels,
        artistGroups,
        albums,
        albumGenres,
        albumLabels,
        albumArtists,
        songs,
        songGenres,
        songLabels,
        songArtists,
        songGroups,
        playlists,
        playlistSongs
      ];
}
