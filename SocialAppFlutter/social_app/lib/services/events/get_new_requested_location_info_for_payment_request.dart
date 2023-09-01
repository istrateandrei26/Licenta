class GetNewRequestedLocationInfoForPaymentRequest {
  final String verificationCode;

  GetNewRequestedLocationInfoForPaymentRequest(this.verificationCode);

  Map<String, dynamic> toJson() => {
        'verificationCode': verificationCode,
      };

}
