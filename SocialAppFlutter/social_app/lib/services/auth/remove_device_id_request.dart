class RemoveDeviceIdRequest {
  final int userId;
  final String deviceId;

  RemoveDeviceIdRequest(this.userId, this.deviceId);

  Map<String, dynamic> toJson() => 
  {
    'userId': userId,
    'deviceId': deviceId
  };
}