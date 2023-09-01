class AddDeviceIdRequest {
  final int userId;
  final String deviceId;

  AddDeviceIdRequest(this.userId, this.deviceId);

  Map<String, dynamic> toJson() => 
  {
    'userId': userId,
    'deviceId': deviceId
  };
}
