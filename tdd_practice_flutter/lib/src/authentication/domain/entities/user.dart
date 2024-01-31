import 'package:equatable/equatable.dart';

class User extends Equatable {
  
  const User({
    required this.createdAt,
    required this.name,
    required this.avatar,
    required this.id,
  });

  const User.empty()
    : this(
      createdAt: '_empty.createdAt',
      name: '_empty.name',
      avatar: '_empty.avatar',
      id: '_empty.id',
    );

  final String createdAt;
  final String name;
  final String avatar;
  final String id;

  @override
  List<Object> get props => [id, name, avatar];
}