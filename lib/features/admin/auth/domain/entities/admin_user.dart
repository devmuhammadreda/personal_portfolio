import 'package:equatable/equatable.dart';

class AdminUser extends Equatable {
  const AdminUser({required this.uid, required this.email});

  final String uid;
  final String email;

  @override
  List<Object?> get props => [uid, email];
}
