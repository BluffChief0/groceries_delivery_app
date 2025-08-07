import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable(createToJson: false)
class User extends Equatable {
  const User({
    required this.emailOrPhone,
    required this.name,
  });

  factory User.fromJson(json) {
    return _$UserFromJson(json);
  }
  final String emailOrPhone;
  final String name;

  @override
  List<Object?> get props => [emailOrPhone];
}
