import 'dart:convert';

import 'package:tdd_practice_flutter/core/utils/typedef.dart';
import 'package:tdd_practice_flutter/src/authentication/domain/entities/user.dart';

class UserModel extends User{

  const UserModel({
    required super.createdAt,
    required super.name,
    required super.avatar,
    required super.id,
  });

  const UserModel.empty()
    : this(
      createdAt: '_empty.createdAt',
      name: '_empty.name',
      avatar: '_empty.avatar',
      id: '_empty.id',
    );

  factory UserModel.fromJson(String source) =>
    UserModel.fromMap(jsonDecode(source) as DataMap);

  UserModel.fromMap(DataMap map) : 
    this(
      createdAt: map['createdAt'] as String,
      name: map['name'] as String,
      avatar: map['avatar'] as String,
      id: map['id'] as String,
    );

  UserModel copyWith({
    String? createdAt,
    String? name,
    String? avatar,
    String? id,
  }) {
    return UserModel(
      createdAt: createdAt ?? this.createdAt, 
      name: name ?? this.name, 
      avatar: avatar ?? this.avatar,
      id: id ?? this.id, 
    );
  }

  DataMap toMap() => {
    'createdAt' : createdAt,
    'name' : name,
    'avatar' : avatar,
    'id' : id,
  };

  String toJson() => jsonEncode(toMap());
}