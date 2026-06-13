// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ProductsTable extends Products with TableInfo<$ProductsTable, Product> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
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
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sellingPriceMinorMeta = const VerificationMeta(
    'sellingPriceMinor',
  );
  @override
  late final GeneratedColumn<int> sellingPriceMinor = GeneratedColumn<int>(
    'selling_price_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lowStockThresholdMeta = const VerificationMeta(
    'lowStockThreshold',
  );
  @override
  late final GeneratedColumn<int> lowStockThreshold = GeneratedColumn<int>(
    'low_stock_threshold',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    description,
    category,
    sellingPriceMinor,
    lowStockThreshold,
    isActive,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'products';
  @override
  VerificationContext validateIntegrity(
    Insertable<Product> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('selling_price_minor')) {
      context.handle(
        _sellingPriceMinorMeta,
        sellingPriceMinor.isAcceptableOrUnknown(
          data['selling_price_minor']!,
          _sellingPriceMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sellingPriceMinorMeta);
    }
    if (data.containsKey('low_stock_threshold')) {
      context.handle(
        _lowStockThresholdMeta,
        lowStockThreshold.isAcceptableOrUnknown(
          data['low_stock_threshold']!,
          _lowStockThresholdMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Product map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Product(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      ),
      sellingPriceMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}selling_price_minor'],
      )!,
      lowStockThreshold: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}low_stock_threshold'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ProductsTable createAlias(String alias) {
    return $ProductsTable(attachedDatabase, alias);
  }
}

class Product extends DataClass implements Insertable<Product> {
  final int id;
  final String name;
  final String? description;
  final String? category;
  final int sellingPriceMinor;
  final int lowStockThreshold;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Product({
    required this.id,
    required this.name,
    this.description,
    this.category,
    required this.sellingPriceMinor,
    required this.lowStockThreshold,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    map['selling_price_minor'] = Variable<int>(sellingPriceMinor);
    map['low_stock_threshold'] = Variable<int>(lowStockThreshold);
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ProductsCompanion toCompanion(bool nullToAbsent) {
    return ProductsCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      sellingPriceMinor: Value(sellingPriceMinor),
      lowStockThreshold: Value(lowStockThreshold),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Product.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Product(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      category: serializer.fromJson<String?>(json['category']),
      sellingPriceMinor: serializer.fromJson<int>(json['sellingPriceMinor']),
      lowStockThreshold: serializer.fromJson<int>(json['lowStockThreshold']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'category': serializer.toJson<String?>(category),
      'sellingPriceMinor': serializer.toJson<int>(sellingPriceMinor),
      'lowStockThreshold': serializer.toJson<int>(lowStockThreshold),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Product copyWith({
    int? id,
    String? name,
    Value<String?> description = const Value.absent(),
    Value<String?> category = const Value.absent(),
    int? sellingPriceMinor,
    int? lowStockThreshold,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Product(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    category: category.present ? category.value : this.category,
    sellingPriceMinor: sellingPriceMinor ?? this.sellingPriceMinor,
    lowStockThreshold: lowStockThreshold ?? this.lowStockThreshold,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Product copyWithCompanion(ProductsCompanion data) {
    return Product(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      category: data.category.present ? data.category.value : this.category,
      sellingPriceMinor: data.sellingPriceMinor.present
          ? data.sellingPriceMinor.value
          : this.sellingPriceMinor,
      lowStockThreshold: data.lowStockThreshold.present
          ? data.lowStockThreshold.value
          : this.lowStockThreshold,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Product(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('category: $category, ')
          ..write('sellingPriceMinor: $sellingPriceMinor, ')
          ..write('lowStockThreshold: $lowStockThreshold, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    description,
    category,
    sellingPriceMinor,
    lowStockThreshold,
    isActive,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Product &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.category == this.category &&
          other.sellingPriceMinor == this.sellingPriceMinor &&
          other.lowStockThreshold == this.lowStockThreshold &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ProductsCompanion extends UpdateCompanion<Product> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<String?> category;
  final Value<int> sellingPriceMinor;
  final Value<int> lowStockThreshold;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const ProductsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.category = const Value.absent(),
    this.sellingPriceMinor = const Value.absent(),
    this.lowStockThreshold = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ProductsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.description = const Value.absent(),
    this.category = const Value.absent(),
    required int sellingPriceMinor,
    this.lowStockThreshold = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : name = Value(name),
       sellingPriceMinor = Value(sellingPriceMinor);
  static Insertable<Product> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? category,
    Expression<int>? sellingPriceMinor,
    Expression<int>? lowStockThreshold,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (category != null) 'category': category,
      if (sellingPriceMinor != null) 'selling_price_minor': sellingPriceMinor,
      if (lowStockThreshold != null) 'low_stock_threshold': lowStockThreshold,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ProductsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? description,
    Value<String?>? category,
    Value<int>? sellingPriceMinor,
    Value<int>? lowStockThreshold,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return ProductsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      sellingPriceMinor: sellingPriceMinor ?? this.sellingPriceMinor,
      lowStockThreshold: lowStockThreshold ?? this.lowStockThreshold,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
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
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (sellingPriceMinor.present) {
      map['selling_price_minor'] = Variable<int>(sellingPriceMinor.value);
    }
    if (lowStockThreshold.present) {
      map['low_stock_threshold'] = Variable<int>(lowStockThreshold.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('category: $category, ')
          ..write('sellingPriceMinor: $sellingPriceMinor, ')
          ..write('lowStockThreshold: $lowStockThreshold, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ProductCodesTable extends ProductCodes
    with TableInfo<$ProductCodesTable, ProductCode> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductCodesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<int> productId = GeneratedColumn<int>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES products (id)',
    ),
  );
  static const VerificationMeta _codeValueMeta = const VerificationMeta(
    'codeValue',
  );
  @override
  late final GeneratedColumn<String> codeValue = GeneratedColumn<String>(
    'code_value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _codeTypeMeta = const VerificationMeta(
    'codeType',
  );
  @override
  late final GeneratedColumn<String> codeType = GeneratedColumn<String>(
    'code_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isPrimaryMeta = const VerificationMeta(
    'isPrimary',
  );
  @override
  late final GeneratedColumn<bool> isPrimary = GeneratedColumn<bool>(
    'is_primary',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_primary" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    productId,
    codeValue,
    codeType,
    source,
    isPrimary,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'product_codes';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProductCode> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('code_value')) {
      context.handle(
        _codeValueMeta,
        codeValue.isAcceptableOrUnknown(data['code_value']!, _codeValueMeta),
      );
    } else if (isInserting) {
      context.missing(_codeValueMeta);
    }
    if (data.containsKey('code_type')) {
      context.handle(
        _codeTypeMeta,
        codeType.isAcceptableOrUnknown(data['code_type']!, _codeTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeTypeMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('is_primary')) {
      context.handle(
        _isPrimaryMeta,
        isPrimary.isAcceptableOrUnknown(data['is_primary']!, _isPrimaryMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProductCode map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProductCode(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}product_id'],
      )!,
      codeValue: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code_value'],
      )!,
      codeType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code_type'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      isPrimary: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_primary'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ProductCodesTable createAlias(String alias) {
    return $ProductCodesTable(attachedDatabase, alias);
  }
}

class ProductCode extends DataClass implements Insertable<ProductCode> {
  final int id;
  final int productId;
  final String codeValue;
  final String codeType;
  final String source;
  final bool isPrimary;
  final DateTime createdAt;
  const ProductCode({
    required this.id,
    required this.productId,
    required this.codeValue,
    required this.codeType,
    required this.source,
    required this.isPrimary,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['product_id'] = Variable<int>(productId);
    map['code_value'] = Variable<String>(codeValue);
    map['code_type'] = Variable<String>(codeType);
    map['source'] = Variable<String>(source);
    map['is_primary'] = Variable<bool>(isPrimary);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ProductCodesCompanion toCompanion(bool nullToAbsent) {
    return ProductCodesCompanion(
      id: Value(id),
      productId: Value(productId),
      codeValue: Value(codeValue),
      codeType: Value(codeType),
      source: Value(source),
      isPrimary: Value(isPrimary),
      createdAt: Value(createdAt),
    );
  }

  factory ProductCode.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductCode(
      id: serializer.fromJson<int>(json['id']),
      productId: serializer.fromJson<int>(json['productId']),
      codeValue: serializer.fromJson<String>(json['codeValue']),
      codeType: serializer.fromJson<String>(json['codeType']),
      source: serializer.fromJson<String>(json['source']),
      isPrimary: serializer.fromJson<bool>(json['isPrimary']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'productId': serializer.toJson<int>(productId),
      'codeValue': serializer.toJson<String>(codeValue),
      'codeType': serializer.toJson<String>(codeType),
      'source': serializer.toJson<String>(source),
      'isPrimary': serializer.toJson<bool>(isPrimary),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ProductCode copyWith({
    int? id,
    int? productId,
    String? codeValue,
    String? codeType,
    String? source,
    bool? isPrimary,
    DateTime? createdAt,
  }) => ProductCode(
    id: id ?? this.id,
    productId: productId ?? this.productId,
    codeValue: codeValue ?? this.codeValue,
    codeType: codeType ?? this.codeType,
    source: source ?? this.source,
    isPrimary: isPrimary ?? this.isPrimary,
    createdAt: createdAt ?? this.createdAt,
  );
  ProductCode copyWithCompanion(ProductCodesCompanion data) {
    return ProductCode(
      id: data.id.present ? data.id.value : this.id,
      productId: data.productId.present ? data.productId.value : this.productId,
      codeValue: data.codeValue.present ? data.codeValue.value : this.codeValue,
      codeType: data.codeType.present ? data.codeType.value : this.codeType,
      source: data.source.present ? data.source.value : this.source,
      isPrimary: data.isPrimary.present ? data.isPrimary.value : this.isPrimary,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProductCode(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('codeValue: $codeValue, ')
          ..write('codeType: $codeType, ')
          ..write('source: $source, ')
          ..write('isPrimary: $isPrimary, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    productId,
    codeValue,
    codeType,
    source,
    isPrimary,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductCode &&
          other.id == this.id &&
          other.productId == this.productId &&
          other.codeValue == this.codeValue &&
          other.codeType == this.codeType &&
          other.source == this.source &&
          other.isPrimary == this.isPrimary &&
          other.createdAt == this.createdAt);
}

class ProductCodesCompanion extends UpdateCompanion<ProductCode> {
  final Value<int> id;
  final Value<int> productId;
  final Value<String> codeValue;
  final Value<String> codeType;
  final Value<String> source;
  final Value<bool> isPrimary;
  final Value<DateTime> createdAt;
  const ProductCodesCompanion({
    this.id = const Value.absent(),
    this.productId = const Value.absent(),
    this.codeValue = const Value.absent(),
    this.codeType = const Value.absent(),
    this.source = const Value.absent(),
    this.isPrimary = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ProductCodesCompanion.insert({
    this.id = const Value.absent(),
    required int productId,
    required String codeValue,
    required String codeType,
    required String source,
    this.isPrimary = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : productId = Value(productId),
       codeValue = Value(codeValue),
       codeType = Value(codeType),
       source = Value(source);
  static Insertable<ProductCode> custom({
    Expression<int>? id,
    Expression<int>? productId,
    Expression<String>? codeValue,
    Expression<String>? codeType,
    Expression<String>? source,
    Expression<bool>? isPrimary,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productId != null) 'product_id': productId,
      if (codeValue != null) 'code_value': codeValue,
      if (codeType != null) 'code_type': codeType,
      if (source != null) 'source': source,
      if (isPrimary != null) 'is_primary': isPrimary,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ProductCodesCompanion copyWith({
    Value<int>? id,
    Value<int>? productId,
    Value<String>? codeValue,
    Value<String>? codeType,
    Value<String>? source,
    Value<bool>? isPrimary,
    Value<DateTime>? createdAt,
  }) {
    return ProductCodesCompanion(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      codeValue: codeValue ?? this.codeValue,
      codeType: codeType ?? this.codeType,
      source: source ?? this.source,
      isPrimary: isPrimary ?? this.isPrimary,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<int>(productId.value);
    }
    if (codeValue.present) {
      map['code_value'] = Variable<String>(codeValue.value);
    }
    if (codeType.present) {
      map['code_type'] = Variable<String>(codeType.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (isPrimary.present) {
      map['is_primary'] = Variable<bool>(isPrimary.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductCodesCompanion(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('codeValue: $codeValue, ')
          ..write('codeType: $codeType, ')
          ..write('source: $source, ')
          ..write('isPrimary: $isPrimary, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $StockBatchesTable extends StockBatches
    with TableInfo<$StockBatchesTable, StockBatche> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StockBatchesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<int> productId = GeneratedColumn<int>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES products (id)',
    ),
  );
  static const VerificationMeta _quantityReceivedMeta = const VerificationMeta(
    'quantityReceived',
  );
  @override
  late final GeneratedColumn<int> quantityReceived = GeneratedColumn<int>(
    'quantity_received',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityRemainingMeta = const VerificationMeta(
    'quantityRemaining',
  );
  @override
  late final GeneratedColumn<int> quantityRemaining = GeneratedColumn<int>(
    'quantity_remaining',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _costPerUnitMinorMeta = const VerificationMeta(
    'costPerUnitMinor',
  );
  @override
  late final GeneratedColumn<int> costPerUnitMinor = GeneratedColumn<int>(
    'cost_per_unit_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _receivedAtMeta = const VerificationMeta(
    'receivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> receivedAt = GeneratedColumn<DateTime>(
    'received_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    productId,
    quantityReceived,
    quantityRemaining,
    costPerUnitMinor,
    receivedAt,
    note,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stock_batches';
  @override
  VerificationContext validateIntegrity(
    Insertable<StockBatche> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('quantity_received')) {
      context.handle(
        _quantityReceivedMeta,
        quantityReceived.isAcceptableOrUnknown(
          data['quantity_received']!,
          _quantityReceivedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_quantityReceivedMeta);
    }
    if (data.containsKey('quantity_remaining')) {
      context.handle(
        _quantityRemainingMeta,
        quantityRemaining.isAcceptableOrUnknown(
          data['quantity_remaining']!,
          _quantityRemainingMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_quantityRemainingMeta);
    }
    if (data.containsKey('cost_per_unit_minor')) {
      context.handle(
        _costPerUnitMinorMeta,
        costPerUnitMinor.isAcceptableOrUnknown(
          data['cost_per_unit_minor']!,
          _costPerUnitMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_costPerUnitMinorMeta);
    }
    if (data.containsKey('received_at')) {
      context.handle(
        _receivedAtMeta,
        receivedAt.isAcceptableOrUnknown(data['received_at']!, _receivedAtMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StockBatche map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StockBatche(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}product_id'],
      )!,
      quantityReceived: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity_received'],
      )!,
      quantityRemaining: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity_remaining'],
      )!,
      costPerUnitMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cost_per_unit_minor'],
      )!,
      receivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}received_at'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $StockBatchesTable createAlias(String alias) {
    return $StockBatchesTable(attachedDatabase, alias);
  }
}

class StockBatche extends DataClass implements Insertable<StockBatche> {
  final int id;
  final int productId;
  final int quantityReceived;
  final int quantityRemaining;
  final int costPerUnitMinor;
  final DateTime receivedAt;
  final String? note;
  final DateTime createdAt;
  const StockBatche({
    required this.id,
    required this.productId,
    required this.quantityReceived,
    required this.quantityRemaining,
    required this.costPerUnitMinor,
    required this.receivedAt,
    this.note,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['product_id'] = Variable<int>(productId);
    map['quantity_received'] = Variable<int>(quantityReceived);
    map['quantity_remaining'] = Variable<int>(quantityRemaining);
    map['cost_per_unit_minor'] = Variable<int>(costPerUnitMinor);
    map['received_at'] = Variable<DateTime>(receivedAt);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  StockBatchesCompanion toCompanion(bool nullToAbsent) {
    return StockBatchesCompanion(
      id: Value(id),
      productId: Value(productId),
      quantityReceived: Value(quantityReceived),
      quantityRemaining: Value(quantityRemaining),
      costPerUnitMinor: Value(costPerUnitMinor),
      receivedAt: Value(receivedAt),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      createdAt: Value(createdAt),
    );
  }

  factory StockBatche.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StockBatche(
      id: serializer.fromJson<int>(json['id']),
      productId: serializer.fromJson<int>(json['productId']),
      quantityReceived: serializer.fromJson<int>(json['quantityReceived']),
      quantityRemaining: serializer.fromJson<int>(json['quantityRemaining']),
      costPerUnitMinor: serializer.fromJson<int>(json['costPerUnitMinor']),
      receivedAt: serializer.fromJson<DateTime>(json['receivedAt']),
      note: serializer.fromJson<String?>(json['note']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'productId': serializer.toJson<int>(productId),
      'quantityReceived': serializer.toJson<int>(quantityReceived),
      'quantityRemaining': serializer.toJson<int>(quantityRemaining),
      'costPerUnitMinor': serializer.toJson<int>(costPerUnitMinor),
      'receivedAt': serializer.toJson<DateTime>(receivedAt),
      'note': serializer.toJson<String?>(note),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  StockBatche copyWith({
    int? id,
    int? productId,
    int? quantityReceived,
    int? quantityRemaining,
    int? costPerUnitMinor,
    DateTime? receivedAt,
    Value<String?> note = const Value.absent(),
    DateTime? createdAt,
  }) => StockBatche(
    id: id ?? this.id,
    productId: productId ?? this.productId,
    quantityReceived: quantityReceived ?? this.quantityReceived,
    quantityRemaining: quantityRemaining ?? this.quantityRemaining,
    costPerUnitMinor: costPerUnitMinor ?? this.costPerUnitMinor,
    receivedAt: receivedAt ?? this.receivedAt,
    note: note.present ? note.value : this.note,
    createdAt: createdAt ?? this.createdAt,
  );
  StockBatche copyWithCompanion(StockBatchesCompanion data) {
    return StockBatche(
      id: data.id.present ? data.id.value : this.id,
      productId: data.productId.present ? data.productId.value : this.productId,
      quantityReceived: data.quantityReceived.present
          ? data.quantityReceived.value
          : this.quantityReceived,
      quantityRemaining: data.quantityRemaining.present
          ? data.quantityRemaining.value
          : this.quantityRemaining,
      costPerUnitMinor: data.costPerUnitMinor.present
          ? data.costPerUnitMinor.value
          : this.costPerUnitMinor,
      receivedAt: data.receivedAt.present
          ? data.receivedAt.value
          : this.receivedAt,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StockBatche(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('quantityReceived: $quantityReceived, ')
          ..write('quantityRemaining: $quantityRemaining, ')
          ..write('costPerUnitMinor: $costPerUnitMinor, ')
          ..write('receivedAt: $receivedAt, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    productId,
    quantityReceived,
    quantityRemaining,
    costPerUnitMinor,
    receivedAt,
    note,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StockBatche &&
          other.id == this.id &&
          other.productId == this.productId &&
          other.quantityReceived == this.quantityReceived &&
          other.quantityRemaining == this.quantityRemaining &&
          other.costPerUnitMinor == this.costPerUnitMinor &&
          other.receivedAt == this.receivedAt &&
          other.note == this.note &&
          other.createdAt == this.createdAt);
}

class StockBatchesCompanion extends UpdateCompanion<StockBatche> {
  final Value<int> id;
  final Value<int> productId;
  final Value<int> quantityReceived;
  final Value<int> quantityRemaining;
  final Value<int> costPerUnitMinor;
  final Value<DateTime> receivedAt;
  final Value<String?> note;
  final Value<DateTime> createdAt;
  const StockBatchesCompanion({
    this.id = const Value.absent(),
    this.productId = const Value.absent(),
    this.quantityReceived = const Value.absent(),
    this.quantityRemaining = const Value.absent(),
    this.costPerUnitMinor = const Value.absent(),
    this.receivedAt = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  StockBatchesCompanion.insert({
    this.id = const Value.absent(),
    required int productId,
    required int quantityReceived,
    required int quantityRemaining,
    required int costPerUnitMinor,
    this.receivedAt = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : productId = Value(productId),
       quantityReceived = Value(quantityReceived),
       quantityRemaining = Value(quantityRemaining),
       costPerUnitMinor = Value(costPerUnitMinor);
  static Insertable<StockBatche> custom({
    Expression<int>? id,
    Expression<int>? productId,
    Expression<int>? quantityReceived,
    Expression<int>? quantityRemaining,
    Expression<int>? costPerUnitMinor,
    Expression<DateTime>? receivedAt,
    Expression<String>? note,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productId != null) 'product_id': productId,
      if (quantityReceived != null) 'quantity_received': quantityReceived,
      if (quantityRemaining != null) 'quantity_remaining': quantityRemaining,
      if (costPerUnitMinor != null) 'cost_per_unit_minor': costPerUnitMinor,
      if (receivedAt != null) 'received_at': receivedAt,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  StockBatchesCompanion copyWith({
    Value<int>? id,
    Value<int>? productId,
    Value<int>? quantityReceived,
    Value<int>? quantityRemaining,
    Value<int>? costPerUnitMinor,
    Value<DateTime>? receivedAt,
    Value<String?>? note,
    Value<DateTime>? createdAt,
  }) {
    return StockBatchesCompanion(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      quantityReceived: quantityReceived ?? this.quantityReceived,
      quantityRemaining: quantityRemaining ?? this.quantityRemaining,
      costPerUnitMinor: costPerUnitMinor ?? this.costPerUnitMinor,
      receivedAt: receivedAt ?? this.receivedAt,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<int>(productId.value);
    }
    if (quantityReceived.present) {
      map['quantity_received'] = Variable<int>(quantityReceived.value);
    }
    if (quantityRemaining.present) {
      map['quantity_remaining'] = Variable<int>(quantityRemaining.value);
    }
    if (costPerUnitMinor.present) {
      map['cost_per_unit_minor'] = Variable<int>(costPerUnitMinor.value);
    }
    if (receivedAt.present) {
      map['received_at'] = Variable<DateTime>(receivedAt.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StockBatchesCompanion(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('quantityReceived: $quantityReceived, ')
          ..write('quantityRemaining: $quantityRemaining, ')
          ..write('costPerUnitMinor: $costPerUnitMinor, ')
          ..write('receivedAt: $receivedAt, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $StockAdjustmentsTable extends StockAdjustments
    with TableInfo<$StockAdjustmentsTable, StockAdjustment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StockAdjustmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<int> productId = GeneratedColumn<int>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES products (id)',
    ),
  );
  static const VerificationMeta _adjustmentQuantityMeta =
      const VerificationMeta('adjustmentQuantity');
  @override
  late final GeneratedColumn<int> adjustmentQuantity = GeneratedColumn<int>(
    'adjustment_quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
    'reason',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    productId,
    adjustmentQuantity,
    reason,
    note,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stock_adjustments';
  @override
  VerificationContext validateIntegrity(
    Insertable<StockAdjustment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('adjustment_quantity')) {
      context.handle(
        _adjustmentQuantityMeta,
        adjustmentQuantity.isAcceptableOrUnknown(
          data['adjustment_quantity']!,
          _adjustmentQuantityMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_adjustmentQuantityMeta);
    }
    if (data.containsKey('reason')) {
      context.handle(
        _reasonMeta,
        reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta),
      );
    } else if (isInserting) {
      context.missing(_reasonMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StockAdjustment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StockAdjustment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}product_id'],
      )!,
      adjustmentQuantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}adjustment_quantity'],
      )!,
      reason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reason'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $StockAdjustmentsTable createAlias(String alias) {
    return $StockAdjustmentsTable(attachedDatabase, alias);
  }
}

class StockAdjustment extends DataClass implements Insertable<StockAdjustment> {
  final int id;
  final int productId;
  final int adjustmentQuantity;
  final String reason;
  final String? note;
  final DateTime createdAt;
  const StockAdjustment({
    required this.id,
    required this.productId,
    required this.adjustmentQuantity,
    required this.reason,
    this.note,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['product_id'] = Variable<int>(productId);
    map['adjustment_quantity'] = Variable<int>(adjustmentQuantity);
    map['reason'] = Variable<String>(reason);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  StockAdjustmentsCompanion toCompanion(bool nullToAbsent) {
    return StockAdjustmentsCompanion(
      id: Value(id),
      productId: Value(productId),
      adjustmentQuantity: Value(adjustmentQuantity),
      reason: Value(reason),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      createdAt: Value(createdAt),
    );
  }

  factory StockAdjustment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StockAdjustment(
      id: serializer.fromJson<int>(json['id']),
      productId: serializer.fromJson<int>(json['productId']),
      adjustmentQuantity: serializer.fromJson<int>(json['adjustmentQuantity']),
      reason: serializer.fromJson<String>(json['reason']),
      note: serializer.fromJson<String?>(json['note']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'productId': serializer.toJson<int>(productId),
      'adjustmentQuantity': serializer.toJson<int>(adjustmentQuantity),
      'reason': serializer.toJson<String>(reason),
      'note': serializer.toJson<String?>(note),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  StockAdjustment copyWith({
    int? id,
    int? productId,
    int? adjustmentQuantity,
    String? reason,
    Value<String?> note = const Value.absent(),
    DateTime? createdAt,
  }) => StockAdjustment(
    id: id ?? this.id,
    productId: productId ?? this.productId,
    adjustmentQuantity: adjustmentQuantity ?? this.adjustmentQuantity,
    reason: reason ?? this.reason,
    note: note.present ? note.value : this.note,
    createdAt: createdAt ?? this.createdAt,
  );
  StockAdjustment copyWithCompanion(StockAdjustmentsCompanion data) {
    return StockAdjustment(
      id: data.id.present ? data.id.value : this.id,
      productId: data.productId.present ? data.productId.value : this.productId,
      adjustmentQuantity: data.adjustmentQuantity.present
          ? data.adjustmentQuantity.value
          : this.adjustmentQuantity,
      reason: data.reason.present ? data.reason.value : this.reason,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StockAdjustment(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('adjustmentQuantity: $adjustmentQuantity, ')
          ..write('reason: $reason, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, productId, adjustmentQuantity, reason, note, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StockAdjustment &&
          other.id == this.id &&
          other.productId == this.productId &&
          other.adjustmentQuantity == this.adjustmentQuantity &&
          other.reason == this.reason &&
          other.note == this.note &&
          other.createdAt == this.createdAt);
}

class StockAdjustmentsCompanion extends UpdateCompanion<StockAdjustment> {
  final Value<int> id;
  final Value<int> productId;
  final Value<int> adjustmentQuantity;
  final Value<String> reason;
  final Value<String?> note;
  final Value<DateTime> createdAt;
  const StockAdjustmentsCompanion({
    this.id = const Value.absent(),
    this.productId = const Value.absent(),
    this.adjustmentQuantity = const Value.absent(),
    this.reason = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  StockAdjustmentsCompanion.insert({
    this.id = const Value.absent(),
    required int productId,
    required int adjustmentQuantity,
    required String reason,
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : productId = Value(productId),
       adjustmentQuantity = Value(adjustmentQuantity),
       reason = Value(reason);
  static Insertable<StockAdjustment> custom({
    Expression<int>? id,
    Expression<int>? productId,
    Expression<int>? adjustmentQuantity,
    Expression<String>? reason,
    Expression<String>? note,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productId != null) 'product_id': productId,
      if (adjustmentQuantity != null) 'adjustment_quantity': adjustmentQuantity,
      if (reason != null) 'reason': reason,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  StockAdjustmentsCompanion copyWith({
    Value<int>? id,
    Value<int>? productId,
    Value<int>? adjustmentQuantity,
    Value<String>? reason,
    Value<String?>? note,
    Value<DateTime>? createdAt,
  }) {
    return StockAdjustmentsCompanion(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      adjustmentQuantity: adjustmentQuantity ?? this.adjustmentQuantity,
      reason: reason ?? this.reason,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<int>(productId.value);
    }
    if (adjustmentQuantity.present) {
      map['adjustment_quantity'] = Variable<int>(adjustmentQuantity.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StockAdjustmentsCompanion(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('adjustmentQuantity: $adjustmentQuantity, ')
          ..write('reason: $reason, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $SalesTable extends Sales with TableInfo<$SalesTable, Sale> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SalesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _receiptNumberMeta = const VerificationMeta(
    'receiptNumber',
  );
  @override
  late final GeneratedColumn<String> receiptNumber = GeneratedColumn<String>(
    'receipt_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _soldAtMeta = const VerificationMeta('soldAt');
  @override
  late final GeneratedColumn<DateTime> soldAt = GeneratedColumn<DateTime>(
    'sold_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _subtotalMinorMeta = const VerificationMeta(
    'subtotalMinor',
  );
  @override
  late final GeneratedColumn<int> subtotalMinor = GeneratedColumn<int>(
    'subtotal_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _discountTotalMinorMeta =
      const VerificationMeta('discountTotalMinor');
  @override
  late final GeneratedColumn<int> discountTotalMinor = GeneratedColumn<int>(
    'discount_total_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalMinorMeta = const VerificationMeta(
    'totalMinor',
  );
  @override
  late final GeneratedColumn<int> totalMinor = GeneratedColumn<int>(
    'total_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _costTotalMinorMeta = const VerificationMeta(
    'costTotalMinor',
  );
  @override
  late final GeneratedColumn<int> costTotalMinor = GeneratedColumn<int>(
    'cost_total_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _grossProfitMinorMeta = const VerificationMeta(
    'grossProfitMinor',
  );
  @override
  late final GeneratedColumn<int> grossProfitMinor = GeneratedColumn<int>(
    'gross_profit_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paymentMethodMeta = const VerificationMeta(
    'paymentMethod',
  );
  @override
  late final GeneratedColumn<String> paymentMethod = GeneratedColumn<String>(
    'payment_method',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountPaidMinorMeta = const VerificationMeta(
    'amountPaidMinor',
  );
  @override
  late final GeneratedColumn<int> amountPaidMinor = GeneratedColumn<int>(
    'amount_paid_minor',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _changeDueMinorMeta = const VerificationMeta(
    'changeDueMinor',
  );
  @override
  late final GeneratedColumn<int> changeDueMinor = GeneratedColumn<int>(
    'change_due_minor',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    receiptNumber,
    soldAt,
    subtotalMinor,
    discountTotalMinor,
    totalMinor,
    costTotalMinor,
    grossProfitMinor,
    paymentMethod,
    amountPaidMinor,
    changeDueMinor,
    note,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sales';
  @override
  VerificationContext validateIntegrity(
    Insertable<Sale> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('receipt_number')) {
      context.handle(
        _receiptNumberMeta,
        receiptNumber.isAcceptableOrUnknown(
          data['receipt_number']!,
          _receiptNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_receiptNumberMeta);
    }
    if (data.containsKey('sold_at')) {
      context.handle(
        _soldAtMeta,
        soldAt.isAcceptableOrUnknown(data['sold_at']!, _soldAtMeta),
      );
    }
    if (data.containsKey('subtotal_minor')) {
      context.handle(
        _subtotalMinorMeta,
        subtotalMinor.isAcceptableOrUnknown(
          data['subtotal_minor']!,
          _subtotalMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_subtotalMinorMeta);
    }
    if (data.containsKey('discount_total_minor')) {
      context.handle(
        _discountTotalMinorMeta,
        discountTotalMinor.isAcceptableOrUnknown(
          data['discount_total_minor']!,
          _discountTotalMinorMeta,
        ),
      );
    }
    if (data.containsKey('total_minor')) {
      context.handle(
        _totalMinorMeta,
        totalMinor.isAcceptableOrUnknown(data['total_minor']!, _totalMinorMeta),
      );
    } else if (isInserting) {
      context.missing(_totalMinorMeta);
    }
    if (data.containsKey('cost_total_minor')) {
      context.handle(
        _costTotalMinorMeta,
        costTotalMinor.isAcceptableOrUnknown(
          data['cost_total_minor']!,
          _costTotalMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_costTotalMinorMeta);
    }
    if (data.containsKey('gross_profit_minor')) {
      context.handle(
        _grossProfitMinorMeta,
        grossProfitMinor.isAcceptableOrUnknown(
          data['gross_profit_minor']!,
          _grossProfitMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_grossProfitMinorMeta);
    }
    if (data.containsKey('payment_method')) {
      context.handle(
        _paymentMethodMeta,
        paymentMethod.isAcceptableOrUnknown(
          data['payment_method']!,
          _paymentMethodMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_paymentMethodMeta);
    }
    if (data.containsKey('amount_paid_minor')) {
      context.handle(
        _amountPaidMinorMeta,
        amountPaidMinor.isAcceptableOrUnknown(
          data['amount_paid_minor']!,
          _amountPaidMinorMeta,
        ),
      );
    }
    if (data.containsKey('change_due_minor')) {
      context.handle(
        _changeDueMinorMeta,
        changeDueMinor.isAcceptableOrUnknown(
          data['change_due_minor']!,
          _changeDueMinorMeta,
        ),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Sale map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Sale(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      receiptNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}receipt_number'],
      )!,
      soldAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}sold_at'],
      )!,
      subtotalMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}subtotal_minor'],
      )!,
      discountTotalMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}discount_total_minor'],
      )!,
      totalMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_minor'],
      )!,
      costTotalMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cost_total_minor'],
      )!,
      grossProfitMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}gross_profit_minor'],
      )!,
      paymentMethod: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_method'],
      )!,
      amountPaidMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_paid_minor'],
      ),
      changeDueMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}change_due_minor'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $SalesTable createAlias(String alias) {
    return $SalesTable(attachedDatabase, alias);
  }
}

class Sale extends DataClass implements Insertable<Sale> {
  final int id;
  final String receiptNumber;
  final DateTime soldAt;
  final int subtotalMinor;
  final int discountTotalMinor;
  final int totalMinor;
  final int costTotalMinor;
  final int grossProfitMinor;
  final String paymentMethod;
  final int? amountPaidMinor;
  final int? changeDueMinor;
  final String? note;
  final DateTime createdAt;
  const Sale({
    required this.id,
    required this.receiptNumber,
    required this.soldAt,
    required this.subtotalMinor,
    required this.discountTotalMinor,
    required this.totalMinor,
    required this.costTotalMinor,
    required this.grossProfitMinor,
    required this.paymentMethod,
    this.amountPaidMinor,
    this.changeDueMinor,
    this.note,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['receipt_number'] = Variable<String>(receiptNumber);
    map['sold_at'] = Variable<DateTime>(soldAt);
    map['subtotal_minor'] = Variable<int>(subtotalMinor);
    map['discount_total_minor'] = Variable<int>(discountTotalMinor);
    map['total_minor'] = Variable<int>(totalMinor);
    map['cost_total_minor'] = Variable<int>(costTotalMinor);
    map['gross_profit_minor'] = Variable<int>(grossProfitMinor);
    map['payment_method'] = Variable<String>(paymentMethod);
    if (!nullToAbsent || amountPaidMinor != null) {
      map['amount_paid_minor'] = Variable<int>(amountPaidMinor);
    }
    if (!nullToAbsent || changeDueMinor != null) {
      map['change_due_minor'] = Variable<int>(changeDueMinor);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SalesCompanion toCompanion(bool nullToAbsent) {
    return SalesCompanion(
      id: Value(id),
      receiptNumber: Value(receiptNumber),
      soldAt: Value(soldAt),
      subtotalMinor: Value(subtotalMinor),
      discountTotalMinor: Value(discountTotalMinor),
      totalMinor: Value(totalMinor),
      costTotalMinor: Value(costTotalMinor),
      grossProfitMinor: Value(grossProfitMinor),
      paymentMethod: Value(paymentMethod),
      amountPaidMinor: amountPaidMinor == null && nullToAbsent
          ? const Value.absent()
          : Value(amountPaidMinor),
      changeDueMinor: changeDueMinor == null && nullToAbsent
          ? const Value.absent()
          : Value(changeDueMinor),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      createdAt: Value(createdAt),
    );
  }

  factory Sale.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Sale(
      id: serializer.fromJson<int>(json['id']),
      receiptNumber: serializer.fromJson<String>(json['receiptNumber']),
      soldAt: serializer.fromJson<DateTime>(json['soldAt']),
      subtotalMinor: serializer.fromJson<int>(json['subtotalMinor']),
      discountTotalMinor: serializer.fromJson<int>(json['discountTotalMinor']),
      totalMinor: serializer.fromJson<int>(json['totalMinor']),
      costTotalMinor: serializer.fromJson<int>(json['costTotalMinor']),
      grossProfitMinor: serializer.fromJson<int>(json['grossProfitMinor']),
      paymentMethod: serializer.fromJson<String>(json['paymentMethod']),
      amountPaidMinor: serializer.fromJson<int?>(json['amountPaidMinor']),
      changeDueMinor: serializer.fromJson<int?>(json['changeDueMinor']),
      note: serializer.fromJson<String?>(json['note']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'receiptNumber': serializer.toJson<String>(receiptNumber),
      'soldAt': serializer.toJson<DateTime>(soldAt),
      'subtotalMinor': serializer.toJson<int>(subtotalMinor),
      'discountTotalMinor': serializer.toJson<int>(discountTotalMinor),
      'totalMinor': serializer.toJson<int>(totalMinor),
      'costTotalMinor': serializer.toJson<int>(costTotalMinor),
      'grossProfitMinor': serializer.toJson<int>(grossProfitMinor),
      'paymentMethod': serializer.toJson<String>(paymentMethod),
      'amountPaidMinor': serializer.toJson<int?>(amountPaidMinor),
      'changeDueMinor': serializer.toJson<int?>(changeDueMinor),
      'note': serializer.toJson<String?>(note),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Sale copyWith({
    int? id,
    String? receiptNumber,
    DateTime? soldAt,
    int? subtotalMinor,
    int? discountTotalMinor,
    int? totalMinor,
    int? costTotalMinor,
    int? grossProfitMinor,
    String? paymentMethod,
    Value<int?> amountPaidMinor = const Value.absent(),
    Value<int?> changeDueMinor = const Value.absent(),
    Value<String?> note = const Value.absent(),
    DateTime? createdAt,
  }) => Sale(
    id: id ?? this.id,
    receiptNumber: receiptNumber ?? this.receiptNumber,
    soldAt: soldAt ?? this.soldAt,
    subtotalMinor: subtotalMinor ?? this.subtotalMinor,
    discountTotalMinor: discountTotalMinor ?? this.discountTotalMinor,
    totalMinor: totalMinor ?? this.totalMinor,
    costTotalMinor: costTotalMinor ?? this.costTotalMinor,
    grossProfitMinor: grossProfitMinor ?? this.grossProfitMinor,
    paymentMethod: paymentMethod ?? this.paymentMethod,
    amountPaidMinor: amountPaidMinor.present
        ? amountPaidMinor.value
        : this.amountPaidMinor,
    changeDueMinor: changeDueMinor.present
        ? changeDueMinor.value
        : this.changeDueMinor,
    note: note.present ? note.value : this.note,
    createdAt: createdAt ?? this.createdAt,
  );
  Sale copyWithCompanion(SalesCompanion data) {
    return Sale(
      id: data.id.present ? data.id.value : this.id,
      receiptNumber: data.receiptNumber.present
          ? data.receiptNumber.value
          : this.receiptNumber,
      soldAt: data.soldAt.present ? data.soldAt.value : this.soldAt,
      subtotalMinor: data.subtotalMinor.present
          ? data.subtotalMinor.value
          : this.subtotalMinor,
      discountTotalMinor: data.discountTotalMinor.present
          ? data.discountTotalMinor.value
          : this.discountTotalMinor,
      totalMinor: data.totalMinor.present
          ? data.totalMinor.value
          : this.totalMinor,
      costTotalMinor: data.costTotalMinor.present
          ? data.costTotalMinor.value
          : this.costTotalMinor,
      grossProfitMinor: data.grossProfitMinor.present
          ? data.grossProfitMinor.value
          : this.grossProfitMinor,
      paymentMethod: data.paymentMethod.present
          ? data.paymentMethod.value
          : this.paymentMethod,
      amountPaidMinor: data.amountPaidMinor.present
          ? data.amountPaidMinor.value
          : this.amountPaidMinor,
      changeDueMinor: data.changeDueMinor.present
          ? data.changeDueMinor.value
          : this.changeDueMinor,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Sale(')
          ..write('id: $id, ')
          ..write('receiptNumber: $receiptNumber, ')
          ..write('soldAt: $soldAt, ')
          ..write('subtotalMinor: $subtotalMinor, ')
          ..write('discountTotalMinor: $discountTotalMinor, ')
          ..write('totalMinor: $totalMinor, ')
          ..write('costTotalMinor: $costTotalMinor, ')
          ..write('grossProfitMinor: $grossProfitMinor, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('amountPaidMinor: $amountPaidMinor, ')
          ..write('changeDueMinor: $changeDueMinor, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    receiptNumber,
    soldAt,
    subtotalMinor,
    discountTotalMinor,
    totalMinor,
    costTotalMinor,
    grossProfitMinor,
    paymentMethod,
    amountPaidMinor,
    changeDueMinor,
    note,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Sale &&
          other.id == this.id &&
          other.receiptNumber == this.receiptNumber &&
          other.soldAt == this.soldAt &&
          other.subtotalMinor == this.subtotalMinor &&
          other.discountTotalMinor == this.discountTotalMinor &&
          other.totalMinor == this.totalMinor &&
          other.costTotalMinor == this.costTotalMinor &&
          other.grossProfitMinor == this.grossProfitMinor &&
          other.paymentMethod == this.paymentMethod &&
          other.amountPaidMinor == this.amountPaidMinor &&
          other.changeDueMinor == this.changeDueMinor &&
          other.note == this.note &&
          other.createdAt == this.createdAt);
}

class SalesCompanion extends UpdateCompanion<Sale> {
  final Value<int> id;
  final Value<String> receiptNumber;
  final Value<DateTime> soldAt;
  final Value<int> subtotalMinor;
  final Value<int> discountTotalMinor;
  final Value<int> totalMinor;
  final Value<int> costTotalMinor;
  final Value<int> grossProfitMinor;
  final Value<String> paymentMethod;
  final Value<int?> amountPaidMinor;
  final Value<int?> changeDueMinor;
  final Value<String?> note;
  final Value<DateTime> createdAt;
  const SalesCompanion({
    this.id = const Value.absent(),
    this.receiptNumber = const Value.absent(),
    this.soldAt = const Value.absent(),
    this.subtotalMinor = const Value.absent(),
    this.discountTotalMinor = const Value.absent(),
    this.totalMinor = const Value.absent(),
    this.costTotalMinor = const Value.absent(),
    this.grossProfitMinor = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.amountPaidMinor = const Value.absent(),
    this.changeDueMinor = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SalesCompanion.insert({
    this.id = const Value.absent(),
    required String receiptNumber,
    this.soldAt = const Value.absent(),
    required int subtotalMinor,
    this.discountTotalMinor = const Value.absent(),
    required int totalMinor,
    required int costTotalMinor,
    required int grossProfitMinor,
    required String paymentMethod,
    this.amountPaidMinor = const Value.absent(),
    this.changeDueMinor = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : receiptNumber = Value(receiptNumber),
       subtotalMinor = Value(subtotalMinor),
       totalMinor = Value(totalMinor),
       costTotalMinor = Value(costTotalMinor),
       grossProfitMinor = Value(grossProfitMinor),
       paymentMethod = Value(paymentMethod);
  static Insertable<Sale> custom({
    Expression<int>? id,
    Expression<String>? receiptNumber,
    Expression<DateTime>? soldAt,
    Expression<int>? subtotalMinor,
    Expression<int>? discountTotalMinor,
    Expression<int>? totalMinor,
    Expression<int>? costTotalMinor,
    Expression<int>? grossProfitMinor,
    Expression<String>? paymentMethod,
    Expression<int>? amountPaidMinor,
    Expression<int>? changeDueMinor,
    Expression<String>? note,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (receiptNumber != null) 'receipt_number': receiptNumber,
      if (soldAt != null) 'sold_at': soldAt,
      if (subtotalMinor != null) 'subtotal_minor': subtotalMinor,
      if (discountTotalMinor != null)
        'discount_total_minor': discountTotalMinor,
      if (totalMinor != null) 'total_minor': totalMinor,
      if (costTotalMinor != null) 'cost_total_minor': costTotalMinor,
      if (grossProfitMinor != null) 'gross_profit_minor': grossProfitMinor,
      if (paymentMethod != null) 'payment_method': paymentMethod,
      if (amountPaidMinor != null) 'amount_paid_minor': amountPaidMinor,
      if (changeDueMinor != null) 'change_due_minor': changeDueMinor,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SalesCompanion copyWith({
    Value<int>? id,
    Value<String>? receiptNumber,
    Value<DateTime>? soldAt,
    Value<int>? subtotalMinor,
    Value<int>? discountTotalMinor,
    Value<int>? totalMinor,
    Value<int>? costTotalMinor,
    Value<int>? grossProfitMinor,
    Value<String>? paymentMethod,
    Value<int?>? amountPaidMinor,
    Value<int?>? changeDueMinor,
    Value<String?>? note,
    Value<DateTime>? createdAt,
  }) {
    return SalesCompanion(
      id: id ?? this.id,
      receiptNumber: receiptNumber ?? this.receiptNumber,
      soldAt: soldAt ?? this.soldAt,
      subtotalMinor: subtotalMinor ?? this.subtotalMinor,
      discountTotalMinor: discountTotalMinor ?? this.discountTotalMinor,
      totalMinor: totalMinor ?? this.totalMinor,
      costTotalMinor: costTotalMinor ?? this.costTotalMinor,
      grossProfitMinor: grossProfitMinor ?? this.grossProfitMinor,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      amountPaidMinor: amountPaidMinor ?? this.amountPaidMinor,
      changeDueMinor: changeDueMinor ?? this.changeDueMinor,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (receiptNumber.present) {
      map['receipt_number'] = Variable<String>(receiptNumber.value);
    }
    if (soldAt.present) {
      map['sold_at'] = Variable<DateTime>(soldAt.value);
    }
    if (subtotalMinor.present) {
      map['subtotal_minor'] = Variable<int>(subtotalMinor.value);
    }
    if (discountTotalMinor.present) {
      map['discount_total_minor'] = Variable<int>(discountTotalMinor.value);
    }
    if (totalMinor.present) {
      map['total_minor'] = Variable<int>(totalMinor.value);
    }
    if (costTotalMinor.present) {
      map['cost_total_minor'] = Variable<int>(costTotalMinor.value);
    }
    if (grossProfitMinor.present) {
      map['gross_profit_minor'] = Variable<int>(grossProfitMinor.value);
    }
    if (paymentMethod.present) {
      map['payment_method'] = Variable<String>(paymentMethod.value);
    }
    if (amountPaidMinor.present) {
      map['amount_paid_minor'] = Variable<int>(amountPaidMinor.value);
    }
    if (changeDueMinor.present) {
      map['change_due_minor'] = Variable<int>(changeDueMinor.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SalesCompanion(')
          ..write('id: $id, ')
          ..write('receiptNumber: $receiptNumber, ')
          ..write('soldAt: $soldAt, ')
          ..write('subtotalMinor: $subtotalMinor, ')
          ..write('discountTotalMinor: $discountTotalMinor, ')
          ..write('totalMinor: $totalMinor, ')
          ..write('costTotalMinor: $costTotalMinor, ')
          ..write('grossProfitMinor: $grossProfitMinor, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('amountPaidMinor: $amountPaidMinor, ')
          ..write('changeDueMinor: $changeDueMinor, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $SaleLinesTable extends SaleLines
    with TableInfo<$SaleLinesTable, SaleLine> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SaleLinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _saleIdMeta = const VerificationMeta('saleId');
  @override
  late final GeneratedColumn<int> saleId = GeneratedColumn<int>(
    'sale_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES sales (id)',
    ),
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<int> productId = GeneratedColumn<int>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES products (id)',
    ),
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitPriceMinorMeta = const VerificationMeta(
    'unitPriceMinor',
  );
  @override
  late final GeneratedColumn<int> unitPriceMinor = GeneratedColumn<int>(
    'unit_price_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _discountAmountMinorMeta =
      const VerificationMeta('discountAmountMinor');
  @override
  late final GeneratedColumn<int> discountAmountMinor = GeneratedColumn<int>(
    'discount_amount_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lineTotalMinorMeta = const VerificationMeta(
    'lineTotalMinor',
  );
  @override
  late final GeneratedColumn<int> lineTotalMinor = GeneratedColumn<int>(
    'line_total_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _costTotalMinorMeta = const VerificationMeta(
    'costTotalMinor',
  );
  @override
  late final GeneratedColumn<int> costTotalMinor = GeneratedColumn<int>(
    'cost_total_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _grossProfitMinorMeta = const VerificationMeta(
    'grossProfitMinor',
  );
  @override
  late final GeneratedColumn<int> grossProfitMinor = GeneratedColumn<int>(
    'gross_profit_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    saleId,
    productId,
    quantity,
    unitPriceMinor,
    discountAmountMinor,
    lineTotalMinor,
    costTotalMinor,
    grossProfitMinor,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sale_lines';
  @override
  VerificationContext validateIntegrity(
    Insertable<SaleLine> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('sale_id')) {
      context.handle(
        _saleIdMeta,
        saleId.isAcceptableOrUnknown(data['sale_id']!, _saleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_saleIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('unit_price_minor')) {
      context.handle(
        _unitPriceMinorMeta,
        unitPriceMinor.isAcceptableOrUnknown(
          data['unit_price_minor']!,
          _unitPriceMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_unitPriceMinorMeta);
    }
    if (data.containsKey('discount_amount_minor')) {
      context.handle(
        _discountAmountMinorMeta,
        discountAmountMinor.isAcceptableOrUnknown(
          data['discount_amount_minor']!,
          _discountAmountMinorMeta,
        ),
      );
    }
    if (data.containsKey('line_total_minor')) {
      context.handle(
        _lineTotalMinorMeta,
        lineTotalMinor.isAcceptableOrUnknown(
          data['line_total_minor']!,
          _lineTotalMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lineTotalMinorMeta);
    }
    if (data.containsKey('cost_total_minor')) {
      context.handle(
        _costTotalMinorMeta,
        costTotalMinor.isAcceptableOrUnknown(
          data['cost_total_minor']!,
          _costTotalMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_costTotalMinorMeta);
    }
    if (data.containsKey('gross_profit_minor')) {
      context.handle(
        _grossProfitMinorMeta,
        grossProfitMinor.isAcceptableOrUnknown(
          data['gross_profit_minor']!,
          _grossProfitMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_grossProfitMinorMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SaleLine map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SaleLine(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      saleId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sale_id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}product_id'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
      unitPriceMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unit_price_minor'],
      )!,
      discountAmountMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}discount_amount_minor'],
      )!,
      lineTotalMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}line_total_minor'],
      )!,
      costTotalMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cost_total_minor'],
      )!,
      grossProfitMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}gross_profit_minor'],
      )!,
    );
  }

  @override
  $SaleLinesTable createAlias(String alias) {
    return $SaleLinesTable(attachedDatabase, alias);
  }
}

class SaleLine extends DataClass implements Insertable<SaleLine> {
  final int id;
  final int saleId;
  final int productId;
  final int quantity;
  final int unitPriceMinor;
  final int discountAmountMinor;
  final int lineTotalMinor;
  final int costTotalMinor;
  final int grossProfitMinor;
  const SaleLine({
    required this.id,
    required this.saleId,
    required this.productId,
    required this.quantity,
    required this.unitPriceMinor,
    required this.discountAmountMinor,
    required this.lineTotalMinor,
    required this.costTotalMinor,
    required this.grossProfitMinor,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['sale_id'] = Variable<int>(saleId);
    map['product_id'] = Variable<int>(productId);
    map['quantity'] = Variable<int>(quantity);
    map['unit_price_minor'] = Variable<int>(unitPriceMinor);
    map['discount_amount_minor'] = Variable<int>(discountAmountMinor);
    map['line_total_minor'] = Variable<int>(lineTotalMinor);
    map['cost_total_minor'] = Variable<int>(costTotalMinor);
    map['gross_profit_minor'] = Variable<int>(grossProfitMinor);
    return map;
  }

  SaleLinesCompanion toCompanion(bool nullToAbsent) {
    return SaleLinesCompanion(
      id: Value(id),
      saleId: Value(saleId),
      productId: Value(productId),
      quantity: Value(quantity),
      unitPriceMinor: Value(unitPriceMinor),
      discountAmountMinor: Value(discountAmountMinor),
      lineTotalMinor: Value(lineTotalMinor),
      costTotalMinor: Value(costTotalMinor),
      grossProfitMinor: Value(grossProfitMinor),
    );
  }

  factory SaleLine.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SaleLine(
      id: serializer.fromJson<int>(json['id']),
      saleId: serializer.fromJson<int>(json['saleId']),
      productId: serializer.fromJson<int>(json['productId']),
      quantity: serializer.fromJson<int>(json['quantity']),
      unitPriceMinor: serializer.fromJson<int>(json['unitPriceMinor']),
      discountAmountMinor: serializer.fromJson<int>(
        json['discountAmountMinor'],
      ),
      lineTotalMinor: serializer.fromJson<int>(json['lineTotalMinor']),
      costTotalMinor: serializer.fromJson<int>(json['costTotalMinor']),
      grossProfitMinor: serializer.fromJson<int>(json['grossProfitMinor']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'saleId': serializer.toJson<int>(saleId),
      'productId': serializer.toJson<int>(productId),
      'quantity': serializer.toJson<int>(quantity),
      'unitPriceMinor': serializer.toJson<int>(unitPriceMinor),
      'discountAmountMinor': serializer.toJson<int>(discountAmountMinor),
      'lineTotalMinor': serializer.toJson<int>(lineTotalMinor),
      'costTotalMinor': serializer.toJson<int>(costTotalMinor),
      'grossProfitMinor': serializer.toJson<int>(grossProfitMinor),
    };
  }

  SaleLine copyWith({
    int? id,
    int? saleId,
    int? productId,
    int? quantity,
    int? unitPriceMinor,
    int? discountAmountMinor,
    int? lineTotalMinor,
    int? costTotalMinor,
    int? grossProfitMinor,
  }) => SaleLine(
    id: id ?? this.id,
    saleId: saleId ?? this.saleId,
    productId: productId ?? this.productId,
    quantity: quantity ?? this.quantity,
    unitPriceMinor: unitPriceMinor ?? this.unitPriceMinor,
    discountAmountMinor: discountAmountMinor ?? this.discountAmountMinor,
    lineTotalMinor: lineTotalMinor ?? this.lineTotalMinor,
    costTotalMinor: costTotalMinor ?? this.costTotalMinor,
    grossProfitMinor: grossProfitMinor ?? this.grossProfitMinor,
  );
  SaleLine copyWithCompanion(SaleLinesCompanion data) {
    return SaleLine(
      id: data.id.present ? data.id.value : this.id,
      saleId: data.saleId.present ? data.saleId.value : this.saleId,
      productId: data.productId.present ? data.productId.value : this.productId,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      unitPriceMinor: data.unitPriceMinor.present
          ? data.unitPriceMinor.value
          : this.unitPriceMinor,
      discountAmountMinor: data.discountAmountMinor.present
          ? data.discountAmountMinor.value
          : this.discountAmountMinor,
      lineTotalMinor: data.lineTotalMinor.present
          ? data.lineTotalMinor.value
          : this.lineTotalMinor,
      costTotalMinor: data.costTotalMinor.present
          ? data.costTotalMinor.value
          : this.costTotalMinor,
      grossProfitMinor: data.grossProfitMinor.present
          ? data.grossProfitMinor.value
          : this.grossProfitMinor,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SaleLine(')
          ..write('id: $id, ')
          ..write('saleId: $saleId, ')
          ..write('productId: $productId, ')
          ..write('quantity: $quantity, ')
          ..write('unitPriceMinor: $unitPriceMinor, ')
          ..write('discountAmountMinor: $discountAmountMinor, ')
          ..write('lineTotalMinor: $lineTotalMinor, ')
          ..write('costTotalMinor: $costTotalMinor, ')
          ..write('grossProfitMinor: $grossProfitMinor')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    saleId,
    productId,
    quantity,
    unitPriceMinor,
    discountAmountMinor,
    lineTotalMinor,
    costTotalMinor,
    grossProfitMinor,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SaleLine &&
          other.id == this.id &&
          other.saleId == this.saleId &&
          other.productId == this.productId &&
          other.quantity == this.quantity &&
          other.unitPriceMinor == this.unitPriceMinor &&
          other.discountAmountMinor == this.discountAmountMinor &&
          other.lineTotalMinor == this.lineTotalMinor &&
          other.costTotalMinor == this.costTotalMinor &&
          other.grossProfitMinor == this.grossProfitMinor);
}

class SaleLinesCompanion extends UpdateCompanion<SaleLine> {
  final Value<int> id;
  final Value<int> saleId;
  final Value<int> productId;
  final Value<int> quantity;
  final Value<int> unitPriceMinor;
  final Value<int> discountAmountMinor;
  final Value<int> lineTotalMinor;
  final Value<int> costTotalMinor;
  final Value<int> grossProfitMinor;
  const SaleLinesCompanion({
    this.id = const Value.absent(),
    this.saleId = const Value.absent(),
    this.productId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unitPriceMinor = const Value.absent(),
    this.discountAmountMinor = const Value.absent(),
    this.lineTotalMinor = const Value.absent(),
    this.costTotalMinor = const Value.absent(),
    this.grossProfitMinor = const Value.absent(),
  });
  SaleLinesCompanion.insert({
    this.id = const Value.absent(),
    required int saleId,
    required int productId,
    required int quantity,
    required int unitPriceMinor,
    this.discountAmountMinor = const Value.absent(),
    required int lineTotalMinor,
    required int costTotalMinor,
    required int grossProfitMinor,
  }) : saleId = Value(saleId),
       productId = Value(productId),
       quantity = Value(quantity),
       unitPriceMinor = Value(unitPriceMinor),
       lineTotalMinor = Value(lineTotalMinor),
       costTotalMinor = Value(costTotalMinor),
       grossProfitMinor = Value(grossProfitMinor);
  static Insertable<SaleLine> custom({
    Expression<int>? id,
    Expression<int>? saleId,
    Expression<int>? productId,
    Expression<int>? quantity,
    Expression<int>? unitPriceMinor,
    Expression<int>? discountAmountMinor,
    Expression<int>? lineTotalMinor,
    Expression<int>? costTotalMinor,
    Expression<int>? grossProfitMinor,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (saleId != null) 'sale_id': saleId,
      if (productId != null) 'product_id': productId,
      if (quantity != null) 'quantity': quantity,
      if (unitPriceMinor != null) 'unit_price_minor': unitPriceMinor,
      if (discountAmountMinor != null)
        'discount_amount_minor': discountAmountMinor,
      if (lineTotalMinor != null) 'line_total_minor': lineTotalMinor,
      if (costTotalMinor != null) 'cost_total_minor': costTotalMinor,
      if (grossProfitMinor != null) 'gross_profit_minor': grossProfitMinor,
    });
  }

  SaleLinesCompanion copyWith({
    Value<int>? id,
    Value<int>? saleId,
    Value<int>? productId,
    Value<int>? quantity,
    Value<int>? unitPriceMinor,
    Value<int>? discountAmountMinor,
    Value<int>? lineTotalMinor,
    Value<int>? costTotalMinor,
    Value<int>? grossProfitMinor,
  }) {
    return SaleLinesCompanion(
      id: id ?? this.id,
      saleId: saleId ?? this.saleId,
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      unitPriceMinor: unitPriceMinor ?? this.unitPriceMinor,
      discountAmountMinor: discountAmountMinor ?? this.discountAmountMinor,
      lineTotalMinor: lineTotalMinor ?? this.lineTotalMinor,
      costTotalMinor: costTotalMinor ?? this.costTotalMinor,
      grossProfitMinor: grossProfitMinor ?? this.grossProfitMinor,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (saleId.present) {
      map['sale_id'] = Variable<int>(saleId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<int>(productId.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (unitPriceMinor.present) {
      map['unit_price_minor'] = Variable<int>(unitPriceMinor.value);
    }
    if (discountAmountMinor.present) {
      map['discount_amount_minor'] = Variable<int>(discountAmountMinor.value);
    }
    if (lineTotalMinor.present) {
      map['line_total_minor'] = Variable<int>(lineTotalMinor.value);
    }
    if (costTotalMinor.present) {
      map['cost_total_minor'] = Variable<int>(costTotalMinor.value);
    }
    if (grossProfitMinor.present) {
      map['gross_profit_minor'] = Variable<int>(grossProfitMinor.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SaleLinesCompanion(')
          ..write('id: $id, ')
          ..write('saleId: $saleId, ')
          ..write('productId: $productId, ')
          ..write('quantity: $quantity, ')
          ..write('unitPriceMinor: $unitPriceMinor, ')
          ..write('discountAmountMinor: $discountAmountMinor, ')
          ..write('lineTotalMinor: $lineTotalMinor, ')
          ..write('costTotalMinor: $costTotalMinor, ')
          ..write('grossProfitMinor: $grossProfitMinor')
          ..write(')'))
        .toString();
  }
}

class $SaleLineBatchAllocationsTable extends SaleLineBatchAllocations
    with TableInfo<$SaleLineBatchAllocationsTable, SaleLineBatchAllocation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SaleLineBatchAllocationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _saleLineIdMeta = const VerificationMeta(
    'saleLineId',
  );
  @override
  late final GeneratedColumn<int> saleLineId = GeneratedColumn<int>(
    'sale_line_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES sale_lines (id)',
    ),
  );
  static const VerificationMeta _stockBatchIdMeta = const VerificationMeta(
    'stockBatchId',
  );
  @override
  late final GeneratedColumn<int> stockBatchId = GeneratedColumn<int>(
    'stock_batch_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES stock_batches (id)',
    ),
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _costPerUnitMinorMeta = const VerificationMeta(
    'costPerUnitMinor',
  );
  @override
  late final GeneratedColumn<int> costPerUnitMinor = GeneratedColumn<int>(
    'cost_per_unit_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _costTotalMinorMeta = const VerificationMeta(
    'costTotalMinor',
  );
  @override
  late final GeneratedColumn<int> costTotalMinor = GeneratedColumn<int>(
    'cost_total_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    saleLineId,
    stockBatchId,
    quantity,
    costPerUnitMinor,
    costTotalMinor,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sale_line_batch_allocations';
  @override
  VerificationContext validateIntegrity(
    Insertable<SaleLineBatchAllocation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('sale_line_id')) {
      context.handle(
        _saleLineIdMeta,
        saleLineId.isAcceptableOrUnknown(
          data['sale_line_id']!,
          _saleLineIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_saleLineIdMeta);
    }
    if (data.containsKey('stock_batch_id')) {
      context.handle(
        _stockBatchIdMeta,
        stockBatchId.isAcceptableOrUnknown(
          data['stock_batch_id']!,
          _stockBatchIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_stockBatchIdMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('cost_per_unit_minor')) {
      context.handle(
        _costPerUnitMinorMeta,
        costPerUnitMinor.isAcceptableOrUnknown(
          data['cost_per_unit_minor']!,
          _costPerUnitMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_costPerUnitMinorMeta);
    }
    if (data.containsKey('cost_total_minor')) {
      context.handle(
        _costTotalMinorMeta,
        costTotalMinor.isAcceptableOrUnknown(
          data['cost_total_minor']!,
          _costTotalMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_costTotalMinorMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SaleLineBatchAllocation map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SaleLineBatchAllocation(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      saleLineId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sale_line_id'],
      )!,
      stockBatchId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}stock_batch_id'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
      costPerUnitMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cost_per_unit_minor'],
      )!,
      costTotalMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cost_total_minor'],
      )!,
    );
  }

  @override
  $SaleLineBatchAllocationsTable createAlias(String alias) {
    return $SaleLineBatchAllocationsTable(attachedDatabase, alias);
  }
}

class SaleLineBatchAllocation extends DataClass
    implements Insertable<SaleLineBatchAllocation> {
  final int id;
  final int saleLineId;
  final int stockBatchId;
  final int quantity;
  final int costPerUnitMinor;
  final int costTotalMinor;
  const SaleLineBatchAllocation({
    required this.id,
    required this.saleLineId,
    required this.stockBatchId,
    required this.quantity,
    required this.costPerUnitMinor,
    required this.costTotalMinor,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['sale_line_id'] = Variable<int>(saleLineId);
    map['stock_batch_id'] = Variable<int>(stockBatchId);
    map['quantity'] = Variable<int>(quantity);
    map['cost_per_unit_minor'] = Variable<int>(costPerUnitMinor);
    map['cost_total_minor'] = Variable<int>(costTotalMinor);
    return map;
  }

  SaleLineBatchAllocationsCompanion toCompanion(bool nullToAbsent) {
    return SaleLineBatchAllocationsCompanion(
      id: Value(id),
      saleLineId: Value(saleLineId),
      stockBatchId: Value(stockBatchId),
      quantity: Value(quantity),
      costPerUnitMinor: Value(costPerUnitMinor),
      costTotalMinor: Value(costTotalMinor),
    );
  }

  factory SaleLineBatchAllocation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SaleLineBatchAllocation(
      id: serializer.fromJson<int>(json['id']),
      saleLineId: serializer.fromJson<int>(json['saleLineId']),
      stockBatchId: serializer.fromJson<int>(json['stockBatchId']),
      quantity: serializer.fromJson<int>(json['quantity']),
      costPerUnitMinor: serializer.fromJson<int>(json['costPerUnitMinor']),
      costTotalMinor: serializer.fromJson<int>(json['costTotalMinor']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'saleLineId': serializer.toJson<int>(saleLineId),
      'stockBatchId': serializer.toJson<int>(stockBatchId),
      'quantity': serializer.toJson<int>(quantity),
      'costPerUnitMinor': serializer.toJson<int>(costPerUnitMinor),
      'costTotalMinor': serializer.toJson<int>(costTotalMinor),
    };
  }

  SaleLineBatchAllocation copyWith({
    int? id,
    int? saleLineId,
    int? stockBatchId,
    int? quantity,
    int? costPerUnitMinor,
    int? costTotalMinor,
  }) => SaleLineBatchAllocation(
    id: id ?? this.id,
    saleLineId: saleLineId ?? this.saleLineId,
    stockBatchId: stockBatchId ?? this.stockBatchId,
    quantity: quantity ?? this.quantity,
    costPerUnitMinor: costPerUnitMinor ?? this.costPerUnitMinor,
    costTotalMinor: costTotalMinor ?? this.costTotalMinor,
  );
  SaleLineBatchAllocation copyWithCompanion(
    SaleLineBatchAllocationsCompanion data,
  ) {
    return SaleLineBatchAllocation(
      id: data.id.present ? data.id.value : this.id,
      saleLineId: data.saleLineId.present
          ? data.saleLineId.value
          : this.saleLineId,
      stockBatchId: data.stockBatchId.present
          ? data.stockBatchId.value
          : this.stockBatchId,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      costPerUnitMinor: data.costPerUnitMinor.present
          ? data.costPerUnitMinor.value
          : this.costPerUnitMinor,
      costTotalMinor: data.costTotalMinor.present
          ? data.costTotalMinor.value
          : this.costTotalMinor,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SaleLineBatchAllocation(')
          ..write('id: $id, ')
          ..write('saleLineId: $saleLineId, ')
          ..write('stockBatchId: $stockBatchId, ')
          ..write('quantity: $quantity, ')
          ..write('costPerUnitMinor: $costPerUnitMinor, ')
          ..write('costTotalMinor: $costTotalMinor')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    saleLineId,
    stockBatchId,
    quantity,
    costPerUnitMinor,
    costTotalMinor,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SaleLineBatchAllocation &&
          other.id == this.id &&
          other.saleLineId == this.saleLineId &&
          other.stockBatchId == this.stockBatchId &&
          other.quantity == this.quantity &&
          other.costPerUnitMinor == this.costPerUnitMinor &&
          other.costTotalMinor == this.costTotalMinor);
}

class SaleLineBatchAllocationsCompanion
    extends UpdateCompanion<SaleLineBatchAllocation> {
  final Value<int> id;
  final Value<int> saleLineId;
  final Value<int> stockBatchId;
  final Value<int> quantity;
  final Value<int> costPerUnitMinor;
  final Value<int> costTotalMinor;
  const SaleLineBatchAllocationsCompanion({
    this.id = const Value.absent(),
    this.saleLineId = const Value.absent(),
    this.stockBatchId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.costPerUnitMinor = const Value.absent(),
    this.costTotalMinor = const Value.absent(),
  });
  SaleLineBatchAllocationsCompanion.insert({
    this.id = const Value.absent(),
    required int saleLineId,
    required int stockBatchId,
    required int quantity,
    required int costPerUnitMinor,
    required int costTotalMinor,
  }) : saleLineId = Value(saleLineId),
       stockBatchId = Value(stockBatchId),
       quantity = Value(quantity),
       costPerUnitMinor = Value(costPerUnitMinor),
       costTotalMinor = Value(costTotalMinor);
  static Insertable<SaleLineBatchAllocation> custom({
    Expression<int>? id,
    Expression<int>? saleLineId,
    Expression<int>? stockBatchId,
    Expression<int>? quantity,
    Expression<int>? costPerUnitMinor,
    Expression<int>? costTotalMinor,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (saleLineId != null) 'sale_line_id': saleLineId,
      if (stockBatchId != null) 'stock_batch_id': stockBatchId,
      if (quantity != null) 'quantity': quantity,
      if (costPerUnitMinor != null) 'cost_per_unit_minor': costPerUnitMinor,
      if (costTotalMinor != null) 'cost_total_minor': costTotalMinor,
    });
  }

  SaleLineBatchAllocationsCompanion copyWith({
    Value<int>? id,
    Value<int>? saleLineId,
    Value<int>? stockBatchId,
    Value<int>? quantity,
    Value<int>? costPerUnitMinor,
    Value<int>? costTotalMinor,
  }) {
    return SaleLineBatchAllocationsCompanion(
      id: id ?? this.id,
      saleLineId: saleLineId ?? this.saleLineId,
      stockBatchId: stockBatchId ?? this.stockBatchId,
      quantity: quantity ?? this.quantity,
      costPerUnitMinor: costPerUnitMinor ?? this.costPerUnitMinor,
      costTotalMinor: costTotalMinor ?? this.costTotalMinor,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (saleLineId.present) {
      map['sale_line_id'] = Variable<int>(saleLineId.value);
    }
    if (stockBatchId.present) {
      map['stock_batch_id'] = Variable<int>(stockBatchId.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (costPerUnitMinor.present) {
      map['cost_per_unit_minor'] = Variable<int>(costPerUnitMinor.value);
    }
    if (costTotalMinor.present) {
      map['cost_total_minor'] = Variable<int>(costTotalMinor.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SaleLineBatchAllocationsCompanion(')
          ..write('id: $id, ')
          ..write('saleLineId: $saleLineId, ')
          ..write('stockBatchId: $stockBatchId, ')
          ..write('quantity: $quantity, ')
          ..write('costPerUnitMinor: $costPerUnitMinor, ')
          ..write('costTotalMinor: $costTotalMinor')
          ..write(')'))
        .toString();
  }
}

class $ReceiptsTable extends Receipts with TableInfo<$ReceiptsTable, Receipt> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReceiptsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _saleIdMeta = const VerificationMeta('saleId');
  @override
  late final GeneratedColumn<int> saleId = GeneratedColumn<int>(
    'sale_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES sales (id)',
    ),
  );
  static const VerificationMeta _receiptNumberMeta = const VerificationMeta(
    'receiptNumber',
  );
  @override
  late final GeneratedColumn<String> receiptNumber = GeneratedColumn<String>(
    'receipt_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _pdfPathMeta = const VerificationMeta(
    'pdfPath',
  );
  @override
  late final GeneratedColumn<String> pdfPath = GeneratedColumn<String>(
    'pdf_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _lastSharedAtMeta = const VerificationMeta(
    'lastSharedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSharedAt = GeneratedColumn<DateTime>(
    'last_shared_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastPrintedAtMeta = const VerificationMeta(
    'lastPrintedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastPrintedAt =
      GeneratedColumn<DateTime>(
        'last_printed_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    saleId,
    receiptNumber,
    pdfPath,
    createdAt,
    lastSharedAt,
    lastPrintedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'receipts';
  @override
  VerificationContext validateIntegrity(
    Insertable<Receipt> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('sale_id')) {
      context.handle(
        _saleIdMeta,
        saleId.isAcceptableOrUnknown(data['sale_id']!, _saleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_saleIdMeta);
    }
    if (data.containsKey('receipt_number')) {
      context.handle(
        _receiptNumberMeta,
        receiptNumber.isAcceptableOrUnknown(
          data['receipt_number']!,
          _receiptNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_receiptNumberMeta);
    }
    if (data.containsKey('pdf_path')) {
      context.handle(
        _pdfPathMeta,
        pdfPath.isAcceptableOrUnknown(data['pdf_path']!, _pdfPathMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('last_shared_at')) {
      context.handle(
        _lastSharedAtMeta,
        lastSharedAt.isAcceptableOrUnknown(
          data['last_shared_at']!,
          _lastSharedAtMeta,
        ),
      );
    }
    if (data.containsKey('last_printed_at')) {
      context.handle(
        _lastPrintedAtMeta,
        lastPrintedAt.isAcceptableOrUnknown(
          data['last_printed_at']!,
          _lastPrintedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Receipt map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Receipt(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      saleId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sale_id'],
      )!,
      receiptNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}receipt_number'],
      )!,
      pdfPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pdf_path'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      lastSharedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_shared_at'],
      ),
      lastPrintedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_printed_at'],
      ),
    );
  }

  @override
  $ReceiptsTable createAlias(String alias) {
    return $ReceiptsTable(attachedDatabase, alias);
  }
}

class Receipt extends DataClass implements Insertable<Receipt> {
  final int id;
  final int saleId;
  final String receiptNumber;
  final String? pdfPath;
  final DateTime createdAt;
  final DateTime? lastSharedAt;
  final DateTime? lastPrintedAt;
  const Receipt({
    required this.id,
    required this.saleId,
    required this.receiptNumber,
    this.pdfPath,
    required this.createdAt,
    this.lastSharedAt,
    this.lastPrintedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['sale_id'] = Variable<int>(saleId);
    map['receipt_number'] = Variable<String>(receiptNumber);
    if (!nullToAbsent || pdfPath != null) {
      map['pdf_path'] = Variable<String>(pdfPath);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || lastSharedAt != null) {
      map['last_shared_at'] = Variable<DateTime>(lastSharedAt);
    }
    if (!nullToAbsent || lastPrintedAt != null) {
      map['last_printed_at'] = Variable<DateTime>(lastPrintedAt);
    }
    return map;
  }

  ReceiptsCompanion toCompanion(bool nullToAbsent) {
    return ReceiptsCompanion(
      id: Value(id),
      saleId: Value(saleId),
      receiptNumber: Value(receiptNumber),
      pdfPath: pdfPath == null && nullToAbsent
          ? const Value.absent()
          : Value(pdfPath),
      createdAt: Value(createdAt),
      lastSharedAt: lastSharedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSharedAt),
      lastPrintedAt: lastPrintedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastPrintedAt),
    );
  }

  factory Receipt.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Receipt(
      id: serializer.fromJson<int>(json['id']),
      saleId: serializer.fromJson<int>(json['saleId']),
      receiptNumber: serializer.fromJson<String>(json['receiptNumber']),
      pdfPath: serializer.fromJson<String?>(json['pdfPath']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      lastSharedAt: serializer.fromJson<DateTime?>(json['lastSharedAt']),
      lastPrintedAt: serializer.fromJson<DateTime?>(json['lastPrintedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'saleId': serializer.toJson<int>(saleId),
      'receiptNumber': serializer.toJson<String>(receiptNumber),
      'pdfPath': serializer.toJson<String?>(pdfPath),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'lastSharedAt': serializer.toJson<DateTime?>(lastSharedAt),
      'lastPrintedAt': serializer.toJson<DateTime?>(lastPrintedAt),
    };
  }

  Receipt copyWith({
    int? id,
    int? saleId,
    String? receiptNumber,
    Value<String?> pdfPath = const Value.absent(),
    DateTime? createdAt,
    Value<DateTime?> lastSharedAt = const Value.absent(),
    Value<DateTime?> lastPrintedAt = const Value.absent(),
  }) => Receipt(
    id: id ?? this.id,
    saleId: saleId ?? this.saleId,
    receiptNumber: receiptNumber ?? this.receiptNumber,
    pdfPath: pdfPath.present ? pdfPath.value : this.pdfPath,
    createdAt: createdAt ?? this.createdAt,
    lastSharedAt: lastSharedAt.present ? lastSharedAt.value : this.lastSharedAt,
    lastPrintedAt: lastPrintedAt.present
        ? lastPrintedAt.value
        : this.lastPrintedAt,
  );
  Receipt copyWithCompanion(ReceiptsCompanion data) {
    return Receipt(
      id: data.id.present ? data.id.value : this.id,
      saleId: data.saleId.present ? data.saleId.value : this.saleId,
      receiptNumber: data.receiptNumber.present
          ? data.receiptNumber.value
          : this.receiptNumber,
      pdfPath: data.pdfPath.present ? data.pdfPath.value : this.pdfPath,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      lastSharedAt: data.lastSharedAt.present
          ? data.lastSharedAt.value
          : this.lastSharedAt,
      lastPrintedAt: data.lastPrintedAt.present
          ? data.lastPrintedAt.value
          : this.lastPrintedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Receipt(')
          ..write('id: $id, ')
          ..write('saleId: $saleId, ')
          ..write('receiptNumber: $receiptNumber, ')
          ..write('pdfPath: $pdfPath, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastSharedAt: $lastSharedAt, ')
          ..write('lastPrintedAt: $lastPrintedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    saleId,
    receiptNumber,
    pdfPath,
    createdAt,
    lastSharedAt,
    lastPrintedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Receipt &&
          other.id == this.id &&
          other.saleId == this.saleId &&
          other.receiptNumber == this.receiptNumber &&
          other.pdfPath == this.pdfPath &&
          other.createdAt == this.createdAt &&
          other.lastSharedAt == this.lastSharedAt &&
          other.lastPrintedAt == this.lastPrintedAt);
}

class ReceiptsCompanion extends UpdateCompanion<Receipt> {
  final Value<int> id;
  final Value<int> saleId;
  final Value<String> receiptNumber;
  final Value<String?> pdfPath;
  final Value<DateTime> createdAt;
  final Value<DateTime?> lastSharedAt;
  final Value<DateTime?> lastPrintedAt;
  const ReceiptsCompanion({
    this.id = const Value.absent(),
    this.saleId = const Value.absent(),
    this.receiptNumber = const Value.absent(),
    this.pdfPath = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastSharedAt = const Value.absent(),
    this.lastPrintedAt = const Value.absent(),
  });
  ReceiptsCompanion.insert({
    this.id = const Value.absent(),
    required int saleId,
    required String receiptNumber,
    this.pdfPath = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastSharedAt = const Value.absent(),
    this.lastPrintedAt = const Value.absent(),
  }) : saleId = Value(saleId),
       receiptNumber = Value(receiptNumber);
  static Insertable<Receipt> custom({
    Expression<int>? id,
    Expression<int>? saleId,
    Expression<String>? receiptNumber,
    Expression<String>? pdfPath,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? lastSharedAt,
    Expression<DateTime>? lastPrintedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (saleId != null) 'sale_id': saleId,
      if (receiptNumber != null) 'receipt_number': receiptNumber,
      if (pdfPath != null) 'pdf_path': pdfPath,
      if (createdAt != null) 'created_at': createdAt,
      if (lastSharedAt != null) 'last_shared_at': lastSharedAt,
      if (lastPrintedAt != null) 'last_printed_at': lastPrintedAt,
    });
  }

  ReceiptsCompanion copyWith({
    Value<int>? id,
    Value<int>? saleId,
    Value<String>? receiptNumber,
    Value<String?>? pdfPath,
    Value<DateTime>? createdAt,
    Value<DateTime?>? lastSharedAt,
    Value<DateTime?>? lastPrintedAt,
  }) {
    return ReceiptsCompanion(
      id: id ?? this.id,
      saleId: saleId ?? this.saleId,
      receiptNumber: receiptNumber ?? this.receiptNumber,
      pdfPath: pdfPath ?? this.pdfPath,
      createdAt: createdAt ?? this.createdAt,
      lastSharedAt: lastSharedAt ?? this.lastSharedAt,
      lastPrintedAt: lastPrintedAt ?? this.lastPrintedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (saleId.present) {
      map['sale_id'] = Variable<int>(saleId.value);
    }
    if (receiptNumber.present) {
      map['receipt_number'] = Variable<String>(receiptNumber.value);
    }
    if (pdfPath.present) {
      map['pdf_path'] = Variable<String>(pdfPath.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (lastSharedAt.present) {
      map['last_shared_at'] = Variable<DateTime>(lastSharedAt.value);
    }
    if (lastPrintedAt.present) {
      map['last_printed_at'] = Variable<DateTime>(lastPrintedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReceiptsCompanion(')
          ..write('id: $id, ')
          ..write('saleId: $saleId, ')
          ..write('receiptNumber: $receiptNumber, ')
          ..write('pdfPath: $pdfPath, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastSharedAt: $lastSharedAt, ')
          ..write('lastPrintedAt: $lastPrintedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProductsTable products = $ProductsTable(this);
  late final $ProductCodesTable productCodes = $ProductCodesTable(this);
  late final $StockBatchesTable stockBatches = $StockBatchesTable(this);
  late final $StockAdjustmentsTable stockAdjustments = $StockAdjustmentsTable(
    this,
  );
  late final $SalesTable sales = $SalesTable(this);
  late final $SaleLinesTable saleLines = $SaleLinesTable(this);
  late final $SaleLineBatchAllocationsTable saleLineBatchAllocations =
      $SaleLineBatchAllocationsTable(this);
  late final $ReceiptsTable receipts = $ReceiptsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    products,
    productCodes,
    stockBatches,
    stockAdjustments,
    sales,
    saleLines,
    saleLineBatchAllocations,
    receipts,
  ];
}

typedef $$ProductsTableCreateCompanionBuilder =
    ProductsCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> description,
      Value<String?> category,
      required int sellingPriceMinor,
      Value<int> lowStockThreshold,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$ProductsTableUpdateCompanionBuilder =
    ProductsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> description,
      Value<String?> category,
      Value<int> sellingPriceMinor,
      Value<int> lowStockThreshold,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$ProductsTableReferences
    extends BaseReferences<_$AppDatabase, $ProductsTable, Product> {
  $$ProductsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ProductCodesTable, List<ProductCode>>
  _productCodesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.productCodes,
    aliasName: $_aliasNameGenerator(db.products.id, db.productCodes.productId),
  );

  $$ProductCodesTableProcessedTableManager get productCodesRefs {
    final manager = $$ProductCodesTableTableManager(
      $_db,
      $_db.productCodes,
    ).filter((f) => f.productId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_productCodesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$StockBatchesTable, List<StockBatche>>
  _stockBatchesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.stockBatches,
    aliasName: $_aliasNameGenerator(db.products.id, db.stockBatches.productId),
  );

  $$StockBatchesTableProcessedTableManager get stockBatchesRefs {
    final manager = $$StockBatchesTableTableManager(
      $_db,
      $_db.stockBatches,
    ).filter((f) => f.productId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_stockBatchesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$StockAdjustmentsTable, List<StockAdjustment>>
  _stockAdjustmentsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.stockAdjustments,
    aliasName: $_aliasNameGenerator(
      db.products.id,
      db.stockAdjustments.productId,
    ),
  );

  $$StockAdjustmentsTableProcessedTableManager get stockAdjustmentsRefs {
    final manager = $$StockAdjustmentsTableTableManager(
      $_db,
      $_db.stockAdjustments,
    ).filter((f) => f.productId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _stockAdjustmentsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SaleLinesTable, List<SaleLine>>
  _saleLinesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.saleLines,
    aliasName: $_aliasNameGenerator(db.products.id, db.saleLines.productId),
  );

  $$SaleLinesTableProcessedTableManager get saleLinesRefs {
    final manager = $$SaleLinesTableTableManager(
      $_db,
      $_db.saleLines,
    ).filter((f) => f.productId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_saleLinesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProductsTableFilterComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sellingPriceMinor => $composableBuilder(
    column: $table.sellingPriceMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lowStockThreshold => $composableBuilder(
    column: $table.lowStockThreshold,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> productCodesRefs(
    Expression<bool> Function($$ProductCodesTableFilterComposer f) f,
  ) {
    final $$ProductCodesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.productCodes,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductCodesTableFilterComposer(
            $db: $db,
            $table: $db.productCodes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> stockBatchesRefs(
    Expression<bool> Function($$StockBatchesTableFilterComposer f) f,
  ) {
    final $$StockBatchesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.stockBatches,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StockBatchesTableFilterComposer(
            $db: $db,
            $table: $db.stockBatches,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> stockAdjustmentsRefs(
    Expression<bool> Function($$StockAdjustmentsTableFilterComposer f) f,
  ) {
    final $$StockAdjustmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.stockAdjustments,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StockAdjustmentsTableFilterComposer(
            $db: $db,
            $table: $db.stockAdjustments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> saleLinesRefs(
    Expression<bool> Function($$SaleLinesTableFilterComposer f) f,
  ) {
    final $$SaleLinesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.saleLines,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SaleLinesTableFilterComposer(
            $db: $db,
            $table: $db.saleLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProductsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sellingPriceMinor => $composableBuilder(
    column: $table.sellingPriceMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lowStockThreshold => $composableBuilder(
    column: $table.lowStockThreshold,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProductsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<int> get sellingPriceMinor => $composableBuilder(
    column: $table.sellingPriceMinor,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lowStockThreshold => $composableBuilder(
    column: $table.lowStockThreshold,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> productCodesRefs<T extends Object>(
    Expression<T> Function($$ProductCodesTableAnnotationComposer a) f,
  ) {
    final $$ProductCodesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.productCodes,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductCodesTableAnnotationComposer(
            $db: $db,
            $table: $db.productCodes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> stockBatchesRefs<T extends Object>(
    Expression<T> Function($$StockBatchesTableAnnotationComposer a) f,
  ) {
    final $$StockBatchesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.stockBatches,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StockBatchesTableAnnotationComposer(
            $db: $db,
            $table: $db.stockBatches,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> stockAdjustmentsRefs<T extends Object>(
    Expression<T> Function($$StockAdjustmentsTableAnnotationComposer a) f,
  ) {
    final $$StockAdjustmentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.stockAdjustments,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StockAdjustmentsTableAnnotationComposer(
            $db: $db,
            $table: $db.stockAdjustments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> saleLinesRefs<T extends Object>(
    Expression<T> Function($$SaleLinesTableAnnotationComposer a) f,
  ) {
    final $$SaleLinesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.saleLines,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SaleLinesTableAnnotationComposer(
            $db: $db,
            $table: $db.saleLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProductsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductsTable,
          Product,
          $$ProductsTableFilterComposer,
          $$ProductsTableOrderingComposer,
          $$ProductsTableAnnotationComposer,
          $$ProductsTableCreateCompanionBuilder,
          $$ProductsTableUpdateCompanionBuilder,
          (Product, $$ProductsTableReferences),
          Product,
          PrefetchHooks Function({
            bool productCodesRefs,
            bool stockBatchesRefs,
            bool stockAdjustmentsRefs,
            bool saleLinesRefs,
          })
        > {
  $$ProductsTableTableManager(_$AppDatabase db, $ProductsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<int> sellingPriceMinor = const Value.absent(),
                Value<int> lowStockThreshold = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ProductsCompanion(
                id: id,
                name: name,
                description: description,
                category: category,
                sellingPriceMinor: sellingPriceMinor,
                lowStockThreshold: lowStockThreshold,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> description = const Value.absent(),
                Value<String?> category = const Value.absent(),
                required int sellingPriceMinor,
                Value<int> lowStockThreshold = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ProductsCompanion.insert(
                id: id,
                name: name,
                description: description,
                category: category,
                sellingPriceMinor: sellingPriceMinor,
                lowStockThreshold: lowStockThreshold,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ProductsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                productCodesRefs = false,
                stockBatchesRefs = false,
                stockAdjustmentsRefs = false,
                saleLinesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (productCodesRefs) db.productCodes,
                    if (stockBatchesRefs) db.stockBatches,
                    if (stockAdjustmentsRefs) db.stockAdjustments,
                    if (saleLinesRefs) db.saleLines,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (productCodesRefs)
                        await $_getPrefetchedData<
                          Product,
                          $ProductsTable,
                          ProductCode
                        >(
                          currentTable: table,
                          referencedTable: $$ProductsTableReferences
                              ._productCodesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProductsTableReferences(
                                db,
                                table,
                                p0,
                              ).productCodesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.productId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (stockBatchesRefs)
                        await $_getPrefetchedData<
                          Product,
                          $ProductsTable,
                          StockBatche
                        >(
                          currentTable: table,
                          referencedTable: $$ProductsTableReferences
                              ._stockBatchesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProductsTableReferences(
                                db,
                                table,
                                p0,
                              ).stockBatchesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.productId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (stockAdjustmentsRefs)
                        await $_getPrefetchedData<
                          Product,
                          $ProductsTable,
                          StockAdjustment
                        >(
                          currentTable: table,
                          referencedTable: $$ProductsTableReferences
                              ._stockAdjustmentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProductsTableReferences(
                                db,
                                table,
                                p0,
                              ).stockAdjustmentsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.productId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (saleLinesRefs)
                        await $_getPrefetchedData<
                          Product,
                          $ProductsTable,
                          SaleLine
                        >(
                          currentTable: table,
                          referencedTable: $$ProductsTableReferences
                              ._saleLinesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProductsTableReferences(
                                db,
                                table,
                                p0,
                              ).saleLinesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.productId == item.id,
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

typedef $$ProductsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductsTable,
      Product,
      $$ProductsTableFilterComposer,
      $$ProductsTableOrderingComposer,
      $$ProductsTableAnnotationComposer,
      $$ProductsTableCreateCompanionBuilder,
      $$ProductsTableUpdateCompanionBuilder,
      (Product, $$ProductsTableReferences),
      Product,
      PrefetchHooks Function({
        bool productCodesRefs,
        bool stockBatchesRefs,
        bool stockAdjustmentsRefs,
        bool saleLinesRefs,
      })
    >;
typedef $$ProductCodesTableCreateCompanionBuilder =
    ProductCodesCompanion Function({
      Value<int> id,
      required int productId,
      required String codeValue,
      required String codeType,
      required String source,
      Value<bool> isPrimary,
      Value<DateTime> createdAt,
    });
typedef $$ProductCodesTableUpdateCompanionBuilder =
    ProductCodesCompanion Function({
      Value<int> id,
      Value<int> productId,
      Value<String> codeValue,
      Value<String> codeType,
      Value<String> source,
      Value<bool> isPrimary,
      Value<DateTime> createdAt,
    });

final class $$ProductCodesTableReferences
    extends BaseReferences<_$AppDatabase, $ProductCodesTable, ProductCode> {
  $$ProductCodesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProductsTable _productIdTable(_$AppDatabase db) =>
      db.products.createAlias(
        $_aliasNameGenerator(db.productCodes.productId, db.products.id),
      );

  $$ProductsTableProcessedTableManager get productId {
    final $_column = $_itemColumn<int>('product_id')!;

    final manager = $$ProductsTableTableManager(
      $_db,
      $_db.products,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ProductCodesTableFilterComposer
    extends Composer<_$AppDatabase, $ProductCodesTable> {
  $$ProductCodesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get codeValue => $composableBuilder(
    column: $table.codeValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get codeType => $composableBuilder(
    column: $table.codeType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPrimary => $composableBuilder(
    column: $table.isPrimary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ProductsTableFilterComposer get productId {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableFilterComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProductCodesTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductCodesTable> {
  $$ProductCodesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get codeValue => $composableBuilder(
    column: $table.codeValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get codeType => $composableBuilder(
    column: $table.codeType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPrimary => $composableBuilder(
    column: $table.isPrimary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProductsTableOrderingComposer get productId {
    final $$ProductsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableOrderingComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProductCodesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductCodesTable> {
  $$ProductCodesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get codeValue =>
      $composableBuilder(column: $table.codeValue, builder: (column) => column);

  GeneratedColumn<String> get codeType =>
      $composableBuilder(column: $table.codeType, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<bool> get isPrimary =>
      $composableBuilder(column: $table.isPrimary, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$ProductsTableAnnotationComposer get productId {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableAnnotationComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProductCodesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductCodesTable,
          ProductCode,
          $$ProductCodesTableFilterComposer,
          $$ProductCodesTableOrderingComposer,
          $$ProductCodesTableAnnotationComposer,
          $$ProductCodesTableCreateCompanionBuilder,
          $$ProductCodesTableUpdateCompanionBuilder,
          (ProductCode, $$ProductCodesTableReferences),
          ProductCode,
          PrefetchHooks Function({bool productId})
        > {
  $$ProductCodesTableTableManager(_$AppDatabase db, $ProductCodesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductCodesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductCodesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductCodesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> productId = const Value.absent(),
                Value<String> codeValue = const Value.absent(),
                Value<String> codeType = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<bool> isPrimary = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ProductCodesCompanion(
                id: id,
                productId: productId,
                codeValue: codeValue,
                codeType: codeType,
                source: source,
                isPrimary: isPrimary,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int productId,
                required String codeValue,
                required String codeType,
                required String source,
                Value<bool> isPrimary = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ProductCodesCompanion.insert(
                id: id,
                productId: productId,
                codeValue: codeValue,
                codeType: codeType,
                source: source,
                isPrimary: isPrimary,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ProductCodesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({productId = false}) {
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
                    if (productId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.productId,
                                referencedTable: $$ProductCodesTableReferences
                                    ._productIdTable(db),
                                referencedColumn: $$ProductCodesTableReferences
                                    ._productIdTable(db)
                                    .id,
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

typedef $$ProductCodesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductCodesTable,
      ProductCode,
      $$ProductCodesTableFilterComposer,
      $$ProductCodesTableOrderingComposer,
      $$ProductCodesTableAnnotationComposer,
      $$ProductCodesTableCreateCompanionBuilder,
      $$ProductCodesTableUpdateCompanionBuilder,
      (ProductCode, $$ProductCodesTableReferences),
      ProductCode,
      PrefetchHooks Function({bool productId})
    >;
typedef $$StockBatchesTableCreateCompanionBuilder =
    StockBatchesCompanion Function({
      Value<int> id,
      required int productId,
      required int quantityReceived,
      required int quantityRemaining,
      required int costPerUnitMinor,
      Value<DateTime> receivedAt,
      Value<String?> note,
      Value<DateTime> createdAt,
    });
typedef $$StockBatchesTableUpdateCompanionBuilder =
    StockBatchesCompanion Function({
      Value<int> id,
      Value<int> productId,
      Value<int> quantityReceived,
      Value<int> quantityRemaining,
      Value<int> costPerUnitMinor,
      Value<DateTime> receivedAt,
      Value<String?> note,
      Value<DateTime> createdAt,
    });

final class $$StockBatchesTableReferences
    extends BaseReferences<_$AppDatabase, $StockBatchesTable, StockBatche> {
  $$StockBatchesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProductsTable _productIdTable(_$AppDatabase db) =>
      db.products.createAlias(
        $_aliasNameGenerator(db.stockBatches.productId, db.products.id),
      );

  $$ProductsTableProcessedTableManager get productId {
    final $_column = $_itemColumn<int>('product_id')!;

    final manager = $$ProductsTableTableManager(
      $_db,
      $_db.products,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $SaleLineBatchAllocationsTable,
    List<SaleLineBatchAllocation>
  >
  _saleLineBatchAllocationsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.saleLineBatchAllocations,
        aliasName: $_aliasNameGenerator(
          db.stockBatches.id,
          db.saleLineBatchAllocations.stockBatchId,
        ),
      );

  $$SaleLineBatchAllocationsTableProcessedTableManager
  get saleLineBatchAllocationsRefs {
    final manager = $$SaleLineBatchAllocationsTableTableManager(
      $_db,
      $_db.saleLineBatchAllocations,
    ).filter((f) => f.stockBatchId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _saleLineBatchAllocationsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$StockBatchesTableFilterComposer
    extends Composer<_$AppDatabase, $StockBatchesTable> {
  $$StockBatchesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantityReceived => $composableBuilder(
    column: $table.quantityReceived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantityRemaining => $composableBuilder(
    column: $table.quantityRemaining,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get costPerUnitMinor => $composableBuilder(
    column: $table.costPerUnitMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get receivedAt => $composableBuilder(
    column: $table.receivedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ProductsTableFilterComposer get productId {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableFilterComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> saleLineBatchAllocationsRefs(
    Expression<bool> Function($$SaleLineBatchAllocationsTableFilterComposer f)
    f,
  ) {
    final $$SaleLineBatchAllocationsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.saleLineBatchAllocations,
          getReferencedColumn: (t) => t.stockBatchId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$SaleLineBatchAllocationsTableFilterComposer(
                $db: $db,
                $table: $db.saleLineBatchAllocations,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$StockBatchesTableOrderingComposer
    extends Composer<_$AppDatabase, $StockBatchesTable> {
  $$StockBatchesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantityReceived => $composableBuilder(
    column: $table.quantityReceived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantityRemaining => $composableBuilder(
    column: $table.quantityRemaining,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get costPerUnitMinor => $composableBuilder(
    column: $table.costPerUnitMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get receivedAt => $composableBuilder(
    column: $table.receivedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProductsTableOrderingComposer get productId {
    final $$ProductsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableOrderingComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StockBatchesTableAnnotationComposer
    extends Composer<_$AppDatabase, $StockBatchesTable> {
  $$StockBatchesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get quantityReceived => $composableBuilder(
    column: $table.quantityReceived,
    builder: (column) => column,
  );

  GeneratedColumn<int> get quantityRemaining => $composableBuilder(
    column: $table.quantityRemaining,
    builder: (column) => column,
  );

  GeneratedColumn<int> get costPerUnitMinor => $composableBuilder(
    column: $table.costPerUnitMinor,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get receivedAt => $composableBuilder(
    column: $table.receivedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$ProductsTableAnnotationComposer get productId {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableAnnotationComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> saleLineBatchAllocationsRefs<T extends Object>(
    Expression<T> Function($$SaleLineBatchAllocationsTableAnnotationComposer a)
    f,
  ) {
    final $$SaleLineBatchAllocationsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.saleLineBatchAllocations,
          getReferencedColumn: (t) => t.stockBatchId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$SaleLineBatchAllocationsTableAnnotationComposer(
                $db: $db,
                $table: $db.saleLineBatchAllocations,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$StockBatchesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StockBatchesTable,
          StockBatche,
          $$StockBatchesTableFilterComposer,
          $$StockBatchesTableOrderingComposer,
          $$StockBatchesTableAnnotationComposer,
          $$StockBatchesTableCreateCompanionBuilder,
          $$StockBatchesTableUpdateCompanionBuilder,
          (StockBatche, $$StockBatchesTableReferences),
          StockBatche,
          PrefetchHooks Function({
            bool productId,
            bool saleLineBatchAllocationsRefs,
          })
        > {
  $$StockBatchesTableTableManager(_$AppDatabase db, $StockBatchesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StockBatchesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StockBatchesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StockBatchesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> productId = const Value.absent(),
                Value<int> quantityReceived = const Value.absent(),
                Value<int> quantityRemaining = const Value.absent(),
                Value<int> costPerUnitMinor = const Value.absent(),
                Value<DateTime> receivedAt = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => StockBatchesCompanion(
                id: id,
                productId: productId,
                quantityReceived: quantityReceived,
                quantityRemaining: quantityRemaining,
                costPerUnitMinor: costPerUnitMinor,
                receivedAt: receivedAt,
                note: note,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int productId,
                required int quantityReceived,
                required int quantityRemaining,
                required int costPerUnitMinor,
                Value<DateTime> receivedAt = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => StockBatchesCompanion.insert(
                id: id,
                productId: productId,
                quantityReceived: quantityReceived,
                quantityRemaining: quantityRemaining,
                costPerUnitMinor: costPerUnitMinor,
                receivedAt: receivedAt,
                note: note,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$StockBatchesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({productId = false, saleLineBatchAllocationsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (saleLineBatchAllocationsRefs)
                      db.saleLineBatchAllocations,
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
                        if (productId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.productId,
                                    referencedTable:
                                        $$StockBatchesTableReferences
                                            ._productIdTable(db),
                                    referencedColumn:
                                        $$StockBatchesTableReferences
                                            ._productIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (saleLineBatchAllocationsRefs)
                        await $_getPrefetchedData<
                          StockBatche,
                          $StockBatchesTable,
                          SaleLineBatchAllocation
                        >(
                          currentTable: table,
                          referencedTable: $$StockBatchesTableReferences
                              ._saleLineBatchAllocationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$StockBatchesTableReferences(
                                db,
                                table,
                                p0,
                              ).saleLineBatchAllocationsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.stockBatchId == item.id,
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

typedef $$StockBatchesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StockBatchesTable,
      StockBatche,
      $$StockBatchesTableFilterComposer,
      $$StockBatchesTableOrderingComposer,
      $$StockBatchesTableAnnotationComposer,
      $$StockBatchesTableCreateCompanionBuilder,
      $$StockBatchesTableUpdateCompanionBuilder,
      (StockBatche, $$StockBatchesTableReferences),
      StockBatche,
      PrefetchHooks Function({
        bool productId,
        bool saleLineBatchAllocationsRefs,
      })
    >;
typedef $$StockAdjustmentsTableCreateCompanionBuilder =
    StockAdjustmentsCompanion Function({
      Value<int> id,
      required int productId,
      required int adjustmentQuantity,
      required String reason,
      Value<String?> note,
      Value<DateTime> createdAt,
    });
typedef $$StockAdjustmentsTableUpdateCompanionBuilder =
    StockAdjustmentsCompanion Function({
      Value<int> id,
      Value<int> productId,
      Value<int> adjustmentQuantity,
      Value<String> reason,
      Value<String?> note,
      Value<DateTime> createdAt,
    });

final class $$StockAdjustmentsTableReferences
    extends
        BaseReferences<_$AppDatabase, $StockAdjustmentsTable, StockAdjustment> {
  $$StockAdjustmentsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ProductsTable _productIdTable(_$AppDatabase db) =>
      db.products.createAlias(
        $_aliasNameGenerator(db.stockAdjustments.productId, db.products.id),
      );

  $$ProductsTableProcessedTableManager get productId {
    final $_column = $_itemColumn<int>('product_id')!;

    final manager = $$ProductsTableTableManager(
      $_db,
      $_db.products,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$StockAdjustmentsTableFilterComposer
    extends Composer<_$AppDatabase, $StockAdjustmentsTable> {
  $$StockAdjustmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get adjustmentQuantity => $composableBuilder(
    column: $table.adjustmentQuantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ProductsTableFilterComposer get productId {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableFilterComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StockAdjustmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $StockAdjustmentsTable> {
  $$StockAdjustmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get adjustmentQuantity => $composableBuilder(
    column: $table.adjustmentQuantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProductsTableOrderingComposer get productId {
    final $$ProductsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableOrderingComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StockAdjustmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StockAdjustmentsTable> {
  $$StockAdjustmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get adjustmentQuantity => $composableBuilder(
    column: $table.adjustmentQuantity,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$ProductsTableAnnotationComposer get productId {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableAnnotationComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StockAdjustmentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StockAdjustmentsTable,
          StockAdjustment,
          $$StockAdjustmentsTableFilterComposer,
          $$StockAdjustmentsTableOrderingComposer,
          $$StockAdjustmentsTableAnnotationComposer,
          $$StockAdjustmentsTableCreateCompanionBuilder,
          $$StockAdjustmentsTableUpdateCompanionBuilder,
          (StockAdjustment, $$StockAdjustmentsTableReferences),
          StockAdjustment,
          PrefetchHooks Function({bool productId})
        > {
  $$StockAdjustmentsTableTableManager(
    _$AppDatabase db,
    $StockAdjustmentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StockAdjustmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StockAdjustmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StockAdjustmentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> productId = const Value.absent(),
                Value<int> adjustmentQuantity = const Value.absent(),
                Value<String> reason = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => StockAdjustmentsCompanion(
                id: id,
                productId: productId,
                adjustmentQuantity: adjustmentQuantity,
                reason: reason,
                note: note,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int productId,
                required int adjustmentQuantity,
                required String reason,
                Value<String?> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => StockAdjustmentsCompanion.insert(
                id: id,
                productId: productId,
                adjustmentQuantity: adjustmentQuantity,
                reason: reason,
                note: note,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$StockAdjustmentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({productId = false}) {
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
                    if (productId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.productId,
                                referencedTable:
                                    $$StockAdjustmentsTableReferences
                                        ._productIdTable(db),
                                referencedColumn:
                                    $$StockAdjustmentsTableReferences
                                        ._productIdTable(db)
                                        .id,
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

typedef $$StockAdjustmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StockAdjustmentsTable,
      StockAdjustment,
      $$StockAdjustmentsTableFilterComposer,
      $$StockAdjustmentsTableOrderingComposer,
      $$StockAdjustmentsTableAnnotationComposer,
      $$StockAdjustmentsTableCreateCompanionBuilder,
      $$StockAdjustmentsTableUpdateCompanionBuilder,
      (StockAdjustment, $$StockAdjustmentsTableReferences),
      StockAdjustment,
      PrefetchHooks Function({bool productId})
    >;
typedef $$SalesTableCreateCompanionBuilder =
    SalesCompanion Function({
      Value<int> id,
      required String receiptNumber,
      Value<DateTime> soldAt,
      required int subtotalMinor,
      Value<int> discountTotalMinor,
      required int totalMinor,
      required int costTotalMinor,
      required int grossProfitMinor,
      required String paymentMethod,
      Value<int?> amountPaidMinor,
      Value<int?> changeDueMinor,
      Value<String?> note,
      Value<DateTime> createdAt,
    });
typedef $$SalesTableUpdateCompanionBuilder =
    SalesCompanion Function({
      Value<int> id,
      Value<String> receiptNumber,
      Value<DateTime> soldAt,
      Value<int> subtotalMinor,
      Value<int> discountTotalMinor,
      Value<int> totalMinor,
      Value<int> costTotalMinor,
      Value<int> grossProfitMinor,
      Value<String> paymentMethod,
      Value<int?> amountPaidMinor,
      Value<int?> changeDueMinor,
      Value<String?> note,
      Value<DateTime> createdAt,
    });

final class $$SalesTableReferences
    extends BaseReferences<_$AppDatabase, $SalesTable, Sale> {
  $$SalesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SaleLinesTable, List<SaleLine>>
  _saleLinesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.saleLines,
    aliasName: $_aliasNameGenerator(db.sales.id, db.saleLines.saleId),
  );

  $$SaleLinesTableProcessedTableManager get saleLinesRefs {
    final manager = $$SaleLinesTableTableManager(
      $_db,
      $_db.saleLines,
    ).filter((f) => f.saleId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_saleLinesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ReceiptsTable, List<Receipt>> _receiptsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.receipts,
    aliasName: $_aliasNameGenerator(db.sales.id, db.receipts.saleId),
  );

  $$ReceiptsTableProcessedTableManager get receiptsRefs {
    final manager = $$ReceiptsTableTableManager(
      $_db,
      $_db.receipts,
    ).filter((f) => f.saleId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_receiptsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SalesTableFilterComposer extends Composer<_$AppDatabase, $SalesTable> {
  $$SalesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get receiptNumber => $composableBuilder(
    column: $table.receiptNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get soldAt => $composableBuilder(
    column: $table.soldAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get subtotalMinor => $composableBuilder(
    column: $table.subtotalMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get discountTotalMinor => $composableBuilder(
    column: $table.discountTotalMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalMinor => $composableBuilder(
    column: $table.totalMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get costTotalMinor => $composableBuilder(
    column: $table.costTotalMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get grossProfitMinor => $composableBuilder(
    column: $table.grossProfitMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountPaidMinor => $composableBuilder(
    column: $table.amountPaidMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get changeDueMinor => $composableBuilder(
    column: $table.changeDueMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> saleLinesRefs(
    Expression<bool> Function($$SaleLinesTableFilterComposer f) f,
  ) {
    final $$SaleLinesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.saleLines,
      getReferencedColumn: (t) => t.saleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SaleLinesTableFilterComposer(
            $db: $db,
            $table: $db.saleLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> receiptsRefs(
    Expression<bool> Function($$ReceiptsTableFilterComposer f) f,
  ) {
    final $$ReceiptsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.receipts,
      getReferencedColumn: (t) => t.saleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReceiptsTableFilterComposer(
            $db: $db,
            $table: $db.receipts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SalesTableOrderingComposer
    extends Composer<_$AppDatabase, $SalesTable> {
  $$SalesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get receiptNumber => $composableBuilder(
    column: $table.receiptNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get soldAt => $composableBuilder(
    column: $table.soldAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get subtotalMinor => $composableBuilder(
    column: $table.subtotalMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get discountTotalMinor => $composableBuilder(
    column: $table.discountTotalMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalMinor => $composableBuilder(
    column: $table.totalMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get costTotalMinor => $composableBuilder(
    column: $table.costTotalMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get grossProfitMinor => $composableBuilder(
    column: $table.grossProfitMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountPaidMinor => $composableBuilder(
    column: $table.amountPaidMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get changeDueMinor => $composableBuilder(
    column: $table.changeDueMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SalesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SalesTable> {
  $$SalesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get receiptNumber => $composableBuilder(
    column: $table.receiptNumber,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get soldAt =>
      $composableBuilder(column: $table.soldAt, builder: (column) => column);

  GeneratedColumn<int> get subtotalMinor => $composableBuilder(
    column: $table.subtotalMinor,
    builder: (column) => column,
  );

  GeneratedColumn<int> get discountTotalMinor => $composableBuilder(
    column: $table.discountTotalMinor,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalMinor => $composableBuilder(
    column: $table.totalMinor,
    builder: (column) => column,
  );

  GeneratedColumn<int> get costTotalMinor => $composableBuilder(
    column: $table.costTotalMinor,
    builder: (column) => column,
  );

  GeneratedColumn<int> get grossProfitMinor => $composableBuilder(
    column: $table.grossProfitMinor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => column,
  );

  GeneratedColumn<int> get amountPaidMinor => $composableBuilder(
    column: $table.amountPaidMinor,
    builder: (column) => column,
  );

  GeneratedColumn<int> get changeDueMinor => $composableBuilder(
    column: $table.changeDueMinor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> saleLinesRefs<T extends Object>(
    Expression<T> Function($$SaleLinesTableAnnotationComposer a) f,
  ) {
    final $$SaleLinesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.saleLines,
      getReferencedColumn: (t) => t.saleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SaleLinesTableAnnotationComposer(
            $db: $db,
            $table: $db.saleLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> receiptsRefs<T extends Object>(
    Expression<T> Function($$ReceiptsTableAnnotationComposer a) f,
  ) {
    final $$ReceiptsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.receipts,
      getReferencedColumn: (t) => t.saleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReceiptsTableAnnotationComposer(
            $db: $db,
            $table: $db.receipts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SalesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SalesTable,
          Sale,
          $$SalesTableFilterComposer,
          $$SalesTableOrderingComposer,
          $$SalesTableAnnotationComposer,
          $$SalesTableCreateCompanionBuilder,
          $$SalesTableUpdateCompanionBuilder,
          (Sale, $$SalesTableReferences),
          Sale,
          PrefetchHooks Function({bool saleLinesRefs, bool receiptsRefs})
        > {
  $$SalesTableTableManager(_$AppDatabase db, $SalesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SalesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SalesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SalesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> receiptNumber = const Value.absent(),
                Value<DateTime> soldAt = const Value.absent(),
                Value<int> subtotalMinor = const Value.absent(),
                Value<int> discountTotalMinor = const Value.absent(),
                Value<int> totalMinor = const Value.absent(),
                Value<int> costTotalMinor = const Value.absent(),
                Value<int> grossProfitMinor = const Value.absent(),
                Value<String> paymentMethod = const Value.absent(),
                Value<int?> amountPaidMinor = const Value.absent(),
                Value<int?> changeDueMinor = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => SalesCompanion(
                id: id,
                receiptNumber: receiptNumber,
                soldAt: soldAt,
                subtotalMinor: subtotalMinor,
                discountTotalMinor: discountTotalMinor,
                totalMinor: totalMinor,
                costTotalMinor: costTotalMinor,
                grossProfitMinor: grossProfitMinor,
                paymentMethod: paymentMethod,
                amountPaidMinor: amountPaidMinor,
                changeDueMinor: changeDueMinor,
                note: note,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String receiptNumber,
                Value<DateTime> soldAt = const Value.absent(),
                required int subtotalMinor,
                Value<int> discountTotalMinor = const Value.absent(),
                required int totalMinor,
                required int costTotalMinor,
                required int grossProfitMinor,
                required String paymentMethod,
                Value<int?> amountPaidMinor = const Value.absent(),
                Value<int?> changeDueMinor = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => SalesCompanion.insert(
                id: id,
                receiptNumber: receiptNumber,
                soldAt: soldAt,
                subtotalMinor: subtotalMinor,
                discountTotalMinor: discountTotalMinor,
                totalMinor: totalMinor,
                costTotalMinor: costTotalMinor,
                grossProfitMinor: grossProfitMinor,
                paymentMethod: paymentMethod,
                amountPaidMinor: amountPaidMinor,
                changeDueMinor: changeDueMinor,
                note: note,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$SalesTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({saleLinesRefs = false, receiptsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (saleLinesRefs) db.saleLines,
                    if (receiptsRefs) db.receipts,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (saleLinesRefs)
                        await $_getPrefetchedData<Sale, $SalesTable, SaleLine>(
                          currentTable: table,
                          referencedTable: $$SalesTableReferences
                              ._saleLinesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SalesTableReferences(
                                db,
                                table,
                                p0,
                              ).saleLinesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.saleId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (receiptsRefs)
                        await $_getPrefetchedData<Sale, $SalesTable, Receipt>(
                          currentTable: table,
                          referencedTable: $$SalesTableReferences
                              ._receiptsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SalesTableReferences(
                                db,
                                table,
                                p0,
                              ).receiptsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.saleId == item.id,
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

typedef $$SalesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SalesTable,
      Sale,
      $$SalesTableFilterComposer,
      $$SalesTableOrderingComposer,
      $$SalesTableAnnotationComposer,
      $$SalesTableCreateCompanionBuilder,
      $$SalesTableUpdateCompanionBuilder,
      (Sale, $$SalesTableReferences),
      Sale,
      PrefetchHooks Function({bool saleLinesRefs, bool receiptsRefs})
    >;
typedef $$SaleLinesTableCreateCompanionBuilder =
    SaleLinesCompanion Function({
      Value<int> id,
      required int saleId,
      required int productId,
      required int quantity,
      required int unitPriceMinor,
      Value<int> discountAmountMinor,
      required int lineTotalMinor,
      required int costTotalMinor,
      required int grossProfitMinor,
    });
typedef $$SaleLinesTableUpdateCompanionBuilder =
    SaleLinesCompanion Function({
      Value<int> id,
      Value<int> saleId,
      Value<int> productId,
      Value<int> quantity,
      Value<int> unitPriceMinor,
      Value<int> discountAmountMinor,
      Value<int> lineTotalMinor,
      Value<int> costTotalMinor,
      Value<int> grossProfitMinor,
    });

final class $$SaleLinesTableReferences
    extends BaseReferences<_$AppDatabase, $SaleLinesTable, SaleLine> {
  $$SaleLinesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SalesTable _saleIdTable(_$AppDatabase db) => db.sales.createAlias(
    $_aliasNameGenerator(db.saleLines.saleId, db.sales.id),
  );

  $$SalesTableProcessedTableManager get saleId {
    final $_column = $_itemColumn<int>('sale_id')!;

    final manager = $$SalesTableTableManager(
      $_db,
      $_db.sales,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_saleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ProductsTable _productIdTable(_$AppDatabase db) =>
      db.products.createAlias(
        $_aliasNameGenerator(db.saleLines.productId, db.products.id),
      );

  $$ProductsTableProcessedTableManager get productId {
    final $_column = $_itemColumn<int>('product_id')!;

    final manager = $$ProductsTableTableManager(
      $_db,
      $_db.products,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $SaleLineBatchAllocationsTable,
    List<SaleLineBatchAllocation>
  >
  _saleLineBatchAllocationsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.saleLineBatchAllocations,
        aliasName: $_aliasNameGenerator(
          db.saleLines.id,
          db.saleLineBatchAllocations.saleLineId,
        ),
      );

  $$SaleLineBatchAllocationsTableProcessedTableManager
  get saleLineBatchAllocationsRefs {
    final manager = $$SaleLineBatchAllocationsTableTableManager(
      $_db,
      $_db.saleLineBatchAllocations,
    ).filter((f) => f.saleLineId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _saleLineBatchAllocationsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SaleLinesTableFilterComposer
    extends Composer<_$AppDatabase, $SaleLinesTable> {
  $$SaleLinesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get unitPriceMinor => $composableBuilder(
    column: $table.unitPriceMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get discountAmountMinor => $composableBuilder(
    column: $table.discountAmountMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lineTotalMinor => $composableBuilder(
    column: $table.lineTotalMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get costTotalMinor => $composableBuilder(
    column: $table.costTotalMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get grossProfitMinor => $composableBuilder(
    column: $table.grossProfitMinor,
    builder: (column) => ColumnFilters(column),
  );

  $$SalesTableFilterComposer get saleId {
    final $$SalesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.saleId,
      referencedTable: $db.sales,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SalesTableFilterComposer(
            $db: $db,
            $table: $db.sales,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductsTableFilterComposer get productId {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableFilterComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> saleLineBatchAllocationsRefs(
    Expression<bool> Function($$SaleLineBatchAllocationsTableFilterComposer f)
    f,
  ) {
    final $$SaleLineBatchAllocationsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.saleLineBatchAllocations,
          getReferencedColumn: (t) => t.saleLineId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$SaleLineBatchAllocationsTableFilterComposer(
                $db: $db,
                $table: $db.saleLineBatchAllocations,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$SaleLinesTableOrderingComposer
    extends Composer<_$AppDatabase, $SaleLinesTable> {
  $$SaleLinesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get unitPriceMinor => $composableBuilder(
    column: $table.unitPriceMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get discountAmountMinor => $composableBuilder(
    column: $table.discountAmountMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lineTotalMinor => $composableBuilder(
    column: $table.lineTotalMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get costTotalMinor => $composableBuilder(
    column: $table.costTotalMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get grossProfitMinor => $composableBuilder(
    column: $table.grossProfitMinor,
    builder: (column) => ColumnOrderings(column),
  );

  $$SalesTableOrderingComposer get saleId {
    final $$SalesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.saleId,
      referencedTable: $db.sales,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SalesTableOrderingComposer(
            $db: $db,
            $table: $db.sales,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductsTableOrderingComposer get productId {
    final $$ProductsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableOrderingComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SaleLinesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SaleLinesTable> {
  $$SaleLinesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<int> get unitPriceMinor => $composableBuilder(
    column: $table.unitPriceMinor,
    builder: (column) => column,
  );

  GeneratedColumn<int> get discountAmountMinor => $composableBuilder(
    column: $table.discountAmountMinor,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lineTotalMinor => $composableBuilder(
    column: $table.lineTotalMinor,
    builder: (column) => column,
  );

  GeneratedColumn<int> get costTotalMinor => $composableBuilder(
    column: $table.costTotalMinor,
    builder: (column) => column,
  );

  GeneratedColumn<int> get grossProfitMinor => $composableBuilder(
    column: $table.grossProfitMinor,
    builder: (column) => column,
  );

  $$SalesTableAnnotationComposer get saleId {
    final $$SalesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.saleId,
      referencedTable: $db.sales,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SalesTableAnnotationComposer(
            $db: $db,
            $table: $db.sales,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductsTableAnnotationComposer get productId {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableAnnotationComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> saleLineBatchAllocationsRefs<T extends Object>(
    Expression<T> Function($$SaleLineBatchAllocationsTableAnnotationComposer a)
    f,
  ) {
    final $$SaleLineBatchAllocationsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.saleLineBatchAllocations,
          getReferencedColumn: (t) => t.saleLineId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$SaleLineBatchAllocationsTableAnnotationComposer(
                $db: $db,
                $table: $db.saleLineBatchAllocations,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$SaleLinesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SaleLinesTable,
          SaleLine,
          $$SaleLinesTableFilterComposer,
          $$SaleLinesTableOrderingComposer,
          $$SaleLinesTableAnnotationComposer,
          $$SaleLinesTableCreateCompanionBuilder,
          $$SaleLinesTableUpdateCompanionBuilder,
          (SaleLine, $$SaleLinesTableReferences),
          SaleLine,
          PrefetchHooks Function({
            bool saleId,
            bool productId,
            bool saleLineBatchAllocationsRefs,
          })
        > {
  $$SaleLinesTableTableManager(_$AppDatabase db, $SaleLinesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SaleLinesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SaleLinesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SaleLinesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> saleId = const Value.absent(),
                Value<int> productId = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<int> unitPriceMinor = const Value.absent(),
                Value<int> discountAmountMinor = const Value.absent(),
                Value<int> lineTotalMinor = const Value.absent(),
                Value<int> costTotalMinor = const Value.absent(),
                Value<int> grossProfitMinor = const Value.absent(),
              }) => SaleLinesCompanion(
                id: id,
                saleId: saleId,
                productId: productId,
                quantity: quantity,
                unitPriceMinor: unitPriceMinor,
                discountAmountMinor: discountAmountMinor,
                lineTotalMinor: lineTotalMinor,
                costTotalMinor: costTotalMinor,
                grossProfitMinor: grossProfitMinor,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int saleId,
                required int productId,
                required int quantity,
                required int unitPriceMinor,
                Value<int> discountAmountMinor = const Value.absent(),
                required int lineTotalMinor,
                required int costTotalMinor,
                required int grossProfitMinor,
              }) => SaleLinesCompanion.insert(
                id: id,
                saleId: saleId,
                productId: productId,
                quantity: quantity,
                unitPriceMinor: unitPriceMinor,
                discountAmountMinor: discountAmountMinor,
                lineTotalMinor: lineTotalMinor,
                costTotalMinor: costTotalMinor,
                grossProfitMinor: grossProfitMinor,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SaleLinesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                saleId = false,
                productId = false,
                saleLineBatchAllocationsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (saleLineBatchAllocationsRefs)
                      db.saleLineBatchAllocations,
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
                        if (saleId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.saleId,
                                    referencedTable: $$SaleLinesTableReferences
                                        ._saleIdTable(db),
                                    referencedColumn: $$SaleLinesTableReferences
                                        ._saleIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (productId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.productId,
                                    referencedTable: $$SaleLinesTableReferences
                                        ._productIdTable(db),
                                    referencedColumn: $$SaleLinesTableReferences
                                        ._productIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (saleLineBatchAllocationsRefs)
                        await $_getPrefetchedData<
                          SaleLine,
                          $SaleLinesTable,
                          SaleLineBatchAllocation
                        >(
                          currentTable: table,
                          referencedTable: $$SaleLinesTableReferences
                              ._saleLineBatchAllocationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SaleLinesTableReferences(
                                db,
                                table,
                                p0,
                              ).saleLineBatchAllocationsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.saleLineId == item.id,
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

typedef $$SaleLinesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SaleLinesTable,
      SaleLine,
      $$SaleLinesTableFilterComposer,
      $$SaleLinesTableOrderingComposer,
      $$SaleLinesTableAnnotationComposer,
      $$SaleLinesTableCreateCompanionBuilder,
      $$SaleLinesTableUpdateCompanionBuilder,
      (SaleLine, $$SaleLinesTableReferences),
      SaleLine,
      PrefetchHooks Function({
        bool saleId,
        bool productId,
        bool saleLineBatchAllocationsRefs,
      })
    >;
typedef $$SaleLineBatchAllocationsTableCreateCompanionBuilder =
    SaleLineBatchAllocationsCompanion Function({
      Value<int> id,
      required int saleLineId,
      required int stockBatchId,
      required int quantity,
      required int costPerUnitMinor,
      required int costTotalMinor,
    });
typedef $$SaleLineBatchAllocationsTableUpdateCompanionBuilder =
    SaleLineBatchAllocationsCompanion Function({
      Value<int> id,
      Value<int> saleLineId,
      Value<int> stockBatchId,
      Value<int> quantity,
      Value<int> costPerUnitMinor,
      Value<int> costTotalMinor,
    });

final class $$SaleLineBatchAllocationsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $SaleLineBatchAllocationsTable,
          SaleLineBatchAllocation
        > {
  $$SaleLineBatchAllocationsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $SaleLinesTable _saleLineIdTable(_$AppDatabase db) =>
      db.saleLines.createAlias(
        $_aliasNameGenerator(
          db.saleLineBatchAllocations.saleLineId,
          db.saleLines.id,
        ),
      );

  $$SaleLinesTableProcessedTableManager get saleLineId {
    final $_column = $_itemColumn<int>('sale_line_id')!;

    final manager = $$SaleLinesTableTableManager(
      $_db,
      $_db.saleLines,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_saleLineIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $StockBatchesTable _stockBatchIdTable(_$AppDatabase db) =>
      db.stockBatches.createAlias(
        $_aliasNameGenerator(
          db.saleLineBatchAllocations.stockBatchId,
          db.stockBatches.id,
        ),
      );

  $$StockBatchesTableProcessedTableManager get stockBatchId {
    final $_column = $_itemColumn<int>('stock_batch_id')!;

    final manager = $$StockBatchesTableTableManager(
      $_db,
      $_db.stockBatches,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_stockBatchIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SaleLineBatchAllocationsTableFilterComposer
    extends Composer<_$AppDatabase, $SaleLineBatchAllocationsTable> {
  $$SaleLineBatchAllocationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get costPerUnitMinor => $composableBuilder(
    column: $table.costPerUnitMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get costTotalMinor => $composableBuilder(
    column: $table.costTotalMinor,
    builder: (column) => ColumnFilters(column),
  );

  $$SaleLinesTableFilterComposer get saleLineId {
    final $$SaleLinesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.saleLineId,
      referencedTable: $db.saleLines,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SaleLinesTableFilterComposer(
            $db: $db,
            $table: $db.saleLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$StockBatchesTableFilterComposer get stockBatchId {
    final $$StockBatchesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.stockBatchId,
      referencedTable: $db.stockBatches,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StockBatchesTableFilterComposer(
            $db: $db,
            $table: $db.stockBatches,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SaleLineBatchAllocationsTableOrderingComposer
    extends Composer<_$AppDatabase, $SaleLineBatchAllocationsTable> {
  $$SaleLineBatchAllocationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get costPerUnitMinor => $composableBuilder(
    column: $table.costPerUnitMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get costTotalMinor => $composableBuilder(
    column: $table.costTotalMinor,
    builder: (column) => ColumnOrderings(column),
  );

  $$SaleLinesTableOrderingComposer get saleLineId {
    final $$SaleLinesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.saleLineId,
      referencedTable: $db.saleLines,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SaleLinesTableOrderingComposer(
            $db: $db,
            $table: $db.saleLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$StockBatchesTableOrderingComposer get stockBatchId {
    final $$StockBatchesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.stockBatchId,
      referencedTable: $db.stockBatches,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StockBatchesTableOrderingComposer(
            $db: $db,
            $table: $db.stockBatches,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SaleLineBatchAllocationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SaleLineBatchAllocationsTable> {
  $$SaleLineBatchAllocationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<int> get costPerUnitMinor => $composableBuilder(
    column: $table.costPerUnitMinor,
    builder: (column) => column,
  );

  GeneratedColumn<int> get costTotalMinor => $composableBuilder(
    column: $table.costTotalMinor,
    builder: (column) => column,
  );

  $$SaleLinesTableAnnotationComposer get saleLineId {
    final $$SaleLinesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.saleLineId,
      referencedTable: $db.saleLines,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SaleLinesTableAnnotationComposer(
            $db: $db,
            $table: $db.saleLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$StockBatchesTableAnnotationComposer get stockBatchId {
    final $$StockBatchesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.stockBatchId,
      referencedTable: $db.stockBatches,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StockBatchesTableAnnotationComposer(
            $db: $db,
            $table: $db.stockBatches,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SaleLineBatchAllocationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SaleLineBatchAllocationsTable,
          SaleLineBatchAllocation,
          $$SaleLineBatchAllocationsTableFilterComposer,
          $$SaleLineBatchAllocationsTableOrderingComposer,
          $$SaleLineBatchAllocationsTableAnnotationComposer,
          $$SaleLineBatchAllocationsTableCreateCompanionBuilder,
          $$SaleLineBatchAllocationsTableUpdateCompanionBuilder,
          (SaleLineBatchAllocation, $$SaleLineBatchAllocationsTableReferences),
          SaleLineBatchAllocation,
          PrefetchHooks Function({bool saleLineId, bool stockBatchId})
        > {
  $$SaleLineBatchAllocationsTableTableManager(
    _$AppDatabase db,
    $SaleLineBatchAllocationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SaleLineBatchAllocationsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$SaleLineBatchAllocationsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$SaleLineBatchAllocationsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> saleLineId = const Value.absent(),
                Value<int> stockBatchId = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<int> costPerUnitMinor = const Value.absent(),
                Value<int> costTotalMinor = const Value.absent(),
              }) => SaleLineBatchAllocationsCompanion(
                id: id,
                saleLineId: saleLineId,
                stockBatchId: stockBatchId,
                quantity: quantity,
                costPerUnitMinor: costPerUnitMinor,
                costTotalMinor: costTotalMinor,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int saleLineId,
                required int stockBatchId,
                required int quantity,
                required int costPerUnitMinor,
                required int costTotalMinor,
              }) => SaleLineBatchAllocationsCompanion.insert(
                id: id,
                saleLineId: saleLineId,
                stockBatchId: stockBatchId,
                quantity: quantity,
                costPerUnitMinor: costPerUnitMinor,
                costTotalMinor: costTotalMinor,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SaleLineBatchAllocationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({saleLineId = false, stockBatchId = false}) {
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
                    if (saleLineId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.saleLineId,
                                referencedTable:
                                    $$SaleLineBatchAllocationsTableReferences
                                        ._saleLineIdTable(db),
                                referencedColumn:
                                    $$SaleLineBatchAllocationsTableReferences
                                        ._saleLineIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (stockBatchId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.stockBatchId,
                                referencedTable:
                                    $$SaleLineBatchAllocationsTableReferences
                                        ._stockBatchIdTable(db),
                                referencedColumn:
                                    $$SaleLineBatchAllocationsTableReferences
                                        ._stockBatchIdTable(db)
                                        .id,
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

typedef $$SaleLineBatchAllocationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SaleLineBatchAllocationsTable,
      SaleLineBatchAllocation,
      $$SaleLineBatchAllocationsTableFilterComposer,
      $$SaleLineBatchAllocationsTableOrderingComposer,
      $$SaleLineBatchAllocationsTableAnnotationComposer,
      $$SaleLineBatchAllocationsTableCreateCompanionBuilder,
      $$SaleLineBatchAllocationsTableUpdateCompanionBuilder,
      (SaleLineBatchAllocation, $$SaleLineBatchAllocationsTableReferences),
      SaleLineBatchAllocation,
      PrefetchHooks Function({bool saleLineId, bool stockBatchId})
    >;
typedef $$ReceiptsTableCreateCompanionBuilder =
    ReceiptsCompanion Function({
      Value<int> id,
      required int saleId,
      required String receiptNumber,
      Value<String?> pdfPath,
      Value<DateTime> createdAt,
      Value<DateTime?> lastSharedAt,
      Value<DateTime?> lastPrintedAt,
    });
typedef $$ReceiptsTableUpdateCompanionBuilder =
    ReceiptsCompanion Function({
      Value<int> id,
      Value<int> saleId,
      Value<String> receiptNumber,
      Value<String?> pdfPath,
      Value<DateTime> createdAt,
      Value<DateTime?> lastSharedAt,
      Value<DateTime?> lastPrintedAt,
    });

final class $$ReceiptsTableReferences
    extends BaseReferences<_$AppDatabase, $ReceiptsTable, Receipt> {
  $$ReceiptsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SalesTable _saleIdTable(_$AppDatabase db) => db.sales.createAlias(
    $_aliasNameGenerator(db.receipts.saleId, db.sales.id),
  );

  $$SalesTableProcessedTableManager get saleId {
    final $_column = $_itemColumn<int>('sale_id')!;

    final manager = $$SalesTableTableManager(
      $_db,
      $_db.sales,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_saleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ReceiptsTableFilterComposer
    extends Composer<_$AppDatabase, $ReceiptsTable> {
  $$ReceiptsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get receiptNumber => $composableBuilder(
    column: $table.receiptNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pdfPath => $composableBuilder(
    column: $table.pdfPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSharedAt => $composableBuilder(
    column: $table.lastSharedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastPrintedAt => $composableBuilder(
    column: $table.lastPrintedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$SalesTableFilterComposer get saleId {
    final $$SalesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.saleId,
      referencedTable: $db.sales,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SalesTableFilterComposer(
            $db: $db,
            $table: $db.sales,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReceiptsTableOrderingComposer
    extends Composer<_$AppDatabase, $ReceiptsTable> {
  $$ReceiptsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get receiptNumber => $composableBuilder(
    column: $table.receiptNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pdfPath => $composableBuilder(
    column: $table.pdfPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSharedAt => $composableBuilder(
    column: $table.lastSharedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastPrintedAt => $composableBuilder(
    column: $table.lastPrintedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$SalesTableOrderingComposer get saleId {
    final $$SalesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.saleId,
      referencedTable: $db.sales,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SalesTableOrderingComposer(
            $db: $db,
            $table: $db.sales,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReceiptsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReceiptsTable> {
  $$ReceiptsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get receiptNumber => $composableBuilder(
    column: $table.receiptNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get pdfPath =>
      $composableBuilder(column: $table.pdfPath, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSharedAt => $composableBuilder(
    column: $table.lastSharedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastPrintedAt => $composableBuilder(
    column: $table.lastPrintedAt,
    builder: (column) => column,
  );

  $$SalesTableAnnotationComposer get saleId {
    final $$SalesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.saleId,
      referencedTable: $db.sales,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SalesTableAnnotationComposer(
            $db: $db,
            $table: $db.sales,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReceiptsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReceiptsTable,
          Receipt,
          $$ReceiptsTableFilterComposer,
          $$ReceiptsTableOrderingComposer,
          $$ReceiptsTableAnnotationComposer,
          $$ReceiptsTableCreateCompanionBuilder,
          $$ReceiptsTableUpdateCompanionBuilder,
          (Receipt, $$ReceiptsTableReferences),
          Receipt,
          PrefetchHooks Function({bool saleId})
        > {
  $$ReceiptsTableTableManager(_$AppDatabase db, $ReceiptsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReceiptsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReceiptsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReceiptsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> saleId = const Value.absent(),
                Value<String> receiptNumber = const Value.absent(),
                Value<String?> pdfPath = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> lastSharedAt = const Value.absent(),
                Value<DateTime?> lastPrintedAt = const Value.absent(),
              }) => ReceiptsCompanion(
                id: id,
                saleId: saleId,
                receiptNumber: receiptNumber,
                pdfPath: pdfPath,
                createdAt: createdAt,
                lastSharedAt: lastSharedAt,
                lastPrintedAt: lastPrintedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int saleId,
                required String receiptNumber,
                Value<String?> pdfPath = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> lastSharedAt = const Value.absent(),
                Value<DateTime?> lastPrintedAt = const Value.absent(),
              }) => ReceiptsCompanion.insert(
                id: id,
                saleId: saleId,
                receiptNumber: receiptNumber,
                pdfPath: pdfPath,
                createdAt: createdAt,
                lastSharedAt: lastSharedAt,
                lastPrintedAt: lastPrintedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ReceiptsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({saleId = false}) {
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
                    if (saleId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.saleId,
                                referencedTable: $$ReceiptsTableReferences
                                    ._saleIdTable(db),
                                referencedColumn: $$ReceiptsTableReferences
                                    ._saleIdTable(db)
                                    .id,
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

typedef $$ReceiptsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReceiptsTable,
      Receipt,
      $$ReceiptsTableFilterComposer,
      $$ReceiptsTableOrderingComposer,
      $$ReceiptsTableAnnotationComposer,
      $$ReceiptsTableCreateCompanionBuilder,
      $$ReceiptsTableUpdateCompanionBuilder,
      (Receipt, $$ReceiptsTableReferences),
      Receipt,
      PrefetchHooks Function({bool saleId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProductsTableTableManager get products =>
      $$ProductsTableTableManager(_db, _db.products);
  $$ProductCodesTableTableManager get productCodes =>
      $$ProductCodesTableTableManager(_db, _db.productCodes);
  $$StockBatchesTableTableManager get stockBatches =>
      $$StockBatchesTableTableManager(_db, _db.stockBatches);
  $$StockAdjustmentsTableTableManager get stockAdjustments =>
      $$StockAdjustmentsTableTableManager(_db, _db.stockAdjustments);
  $$SalesTableTableManager get sales =>
      $$SalesTableTableManager(_db, _db.sales);
  $$SaleLinesTableTableManager get saleLines =>
      $$SaleLinesTableTableManager(_db, _db.saleLines);
  $$SaleLineBatchAllocationsTableTableManager get saleLineBatchAllocations =>
      $$SaleLineBatchAllocationsTableTableManager(
        _db,
        _db.saleLineBatchAllocations,
      );
  $$ReceiptsTableTableManager get receipts =>
      $$ReceiptsTableTableManager(_db, _db.receipts);
}
