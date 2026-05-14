class LoginResponse {
  final bool success;
  final String message;
  final String? token;
  final User? user;

  LoginResponse({
    required this.success,
    required this.message,
    this.token,
    this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      token: json['data']?['token'],
      user: json['data']?['user'] != null
          ? User.fromJson(json['data']['user'])
          : null,
    );
  }
}

class User {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String? address;
  final String? role;
  final String? profileImage;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.address,
    this.role,
    this.profileImage,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      address: json['address'],
      role: json['role'],
      profileImage: json['profile_image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'role': role,
      'profile_image': profileImage,
    };
  }
}

class PresenceResponse {
  final bool success;
  final String message;
  final Presence? data;
  final bool hasCheckedIn;
  final bool hasCheckedOut;
  PresenceResponse({
    required this.success,
    required this.message,
    this.data,
    this.hasCheckedIn = false,
    this.hasCheckedOut = false,
  });
  factory PresenceResponse.fromJson(Map<String, dynamic> json) {
    final responseData = json['data'];
    return PresenceResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      hasCheckedIn: responseData?['has_checked_in'] ?? false,
      hasCheckedOut: responseData?['has_checked_out'] ?? false,
      data: responseData?['presence'] != null
          ? Presence.fromJson(responseData['presence'])
          : null,
    );
  }
}

class Presence {
  final int id;
  final int userId;
  final String? checkInTime;
  final String? checkOutTime;
  final String? checkInLocation;
  final String? checkOutLocation;
  final String? checkInPhoto;
  final String? checkOutPhoto;
  final String status;
  final String date;

  Presence({
    required this.id,
    required this.userId,
    this.checkInTime,
    this.checkOutTime,
    this.checkInLocation,
    this.checkOutLocation,
    this.checkInPhoto,
    this.checkOutPhoto,
    required this.status,
    required this.date,
  });

  factory Presence.fromJson(Map<String, dynamic> json) {
    return Presence(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      checkInTime: json['check_in']?['time'],
      checkOutTime: json['check_out']?['time'],
      checkInLocation: json['check_in_location'],
      checkOutLocation: json['check_out_location'],
      checkInPhoto: json['check_in_photo'],
      checkOutPhoto: json['check_out_photo'],
      status: json['status'] ?? '',
      date: json['presence_date'] ?? '',
    );
  }
}
