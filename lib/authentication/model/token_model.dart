class TokenModel {
  String accessToken;
  String refreshToken;

  TokenModel({required this.accessToken, required this.refreshToken});

  factory TokenModel.fromJson(Map<String, dynamic> json) {
    return TokenModel(
        accessToken: json['result']['accessToken'],
        refreshToken: json['result']['refreshToken']);
  }

  Map<String, dynamic> toJson() {
    return {
      'token': accessToken,
      'refreshToken': refreshToken,
    };
  }
}
