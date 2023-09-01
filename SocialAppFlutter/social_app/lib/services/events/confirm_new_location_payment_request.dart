class ConfirmNewLocationPaymentRequest {
  final int approvedLocationId;

  ConfirmNewLocationPaymentRequest(this.approvedLocationId);

  Map<String, dynamic> toJson() => {
        'approvedLocationId': approvedLocationId,
      };
}
