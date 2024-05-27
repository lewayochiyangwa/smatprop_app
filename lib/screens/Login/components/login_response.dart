/*class LoginResponse {
  final String status;
  final int code;
  final String message;
  final List<String> data;

  LoginResponse({required this.status, required this.code, required this.message, required this.data});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      status: json['status'],
      code: json['code'],
      message: json['message'],
      data: List<String>.from(json['data']),
    );
  }
}*/

class LoginResponse {
  final String status;
  final int code;
  final String message;
  final LoginData data;

  LoginResponse({
    required this.status,
    required this.code,
    required this.message,
    required this.data,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      status: json['status'],
      code: json['code'],
      message: json['message'],
      data: LoginData.fromJson(json['data']),
    );
  }
}

class LoginData {
  final String email;
  final int userId;
  final String role;
  final String accessToken;
  final String refreshToken;

  LoginData({
    required this.email,
    required this.userId,
    required this.role,
    required this.accessToken,
    required this.refreshToken,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      email: json['email'],
      userId: json['userId'],
      role: json['role'],
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
    );
  }
}