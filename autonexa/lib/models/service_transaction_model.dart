import 'package:autonexa/models/enums.dart';

class ServiceTransactionModel {
  final String id;
  final String serviceRequestId;
  final String? providerId;
  final String customerId;
  final double agreedAmount;
  final PaymentStatus paymentStatus;
  final bool invoiceGenerated;
  final DateTime? completedAt;

  ServiceTransactionModel({
    required this.id,
    required this.serviceRequestId,
    this.providerId,
    required this.customerId,
    required this.agreedAmount,
    this.paymentStatus = PaymentStatus.pending,
    this.invoiceGenerated = false,
    this.completedAt,
  });

  ServiceTransactionModel copyWith({
    String? id,
    String? serviceRequestId,
    String? providerId,
    String? customerId,
    double? agreedAmount,
    PaymentStatus? paymentStatus,
    bool? invoiceGenerated,
    DateTime? completedAt,
  }) {
    return ServiceTransactionModel(
      id: id ?? this.id,
      serviceRequestId: serviceRequestId ?? this.serviceRequestId,
      providerId: providerId ?? this.providerId,
      customerId: customerId ?? this.customerId,
      agreedAmount: agreedAmount ?? this.agreedAmount,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      invoiceGenerated: invoiceGenerated ?? this.invoiceGenerated,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'service_request_id': serviceRequestId,
      if (providerId != null) 'provider_id': providerId,
      'customer_id': customerId,
      'agreed_amount': agreedAmount,
      'payment_status': paymentStatus.value,
      'invoice_generated': invoiceGenerated,
      if (completedAt != null) 'completed_at': completedAt?.toIso8601String(),
    };
  }

  factory ServiceTransactionModel.fromMap(Map<String, dynamic> map) {
    return ServiceTransactionModel(
      id: map['id'] ?? '',
      serviceRequestId: map['service_request_id'] ?? '',
      providerId: map['provider_id'],
      customerId: map['customer_id'] ?? '',
      agreedAmount: map['agreed_amount']?.toDouble() ?? 0.0,
      paymentStatus: map['payment_status'] != null
          ? parsePaymentStatus(map['payment_status'])
          : PaymentStatus.pending,
      invoiceGenerated: map['invoice_generated'] ?? false,
      completedAt: map['completed_at'] != null
          ? DateTime.tryParse(map['completed_at'])
          : null,
    );
  }
}
