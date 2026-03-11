enum ProviderCategory {
  regular_user,
  mechanic,
  petrol_bunk,
  towing_agency,
  parts_seller,
  admin,
}

enum ServiceType {
  fuel_share,
  towing,
  mechanical_repair,
  flat_tire,
  jump_start,
  parts_delivery,
}

enum ServiceStatus { searching, accepted, arriving, completed, cancelled }

enum PaymentStatus { pending, received }

// Helpers to stringify enums and parse from DB constraints
extension ProviderCategoryExt on ProviderCategory {
  String get value => name;
}

extension ServiceTypeExt on ServiceType {
  String get value => name;

  String get displayName {
    switch (this) {
      case ServiceType.fuel_share:
        return 'Fuel Delivery';
      case ServiceType.towing:
        return 'Towing';
      case ServiceType.mechanical_repair:
        return 'Mechanical Repair';
      case ServiceType.flat_tire:
        return 'Flat Tire';
      case ServiceType.jump_start:
        return 'Jump Start';
      case ServiceType.parts_delivery:
        return 'Parts Delivery';
    }
  }
}

extension ServiceStatusExt on ServiceStatus {
  String get value => name;
}

extension PaymentStatusExt on PaymentStatus {
  String get value => name;
}

ProviderCategory parseProviderCategory(String value) {
  return ProviderCategory.values.firstWhere(
    (e) => e.name == value,
    orElse: () => ProviderCategory.regular_user,
  );
}

ServiceType parseServiceType(String value) {
  return ServiceType.values.firstWhere(
    (e) => e.name == value,
    orElse: () => ServiceType.mechanical_repair,
  );
}

ServiceStatus parseServiceStatus(String value) {
  return ServiceStatus.values.firstWhere(
    (e) => e.name == value,
    orElse: () => ServiceStatus.searching,
  );
}

PaymentStatus parsePaymentStatus(String value) {
  return PaymentStatus.values.firstWhere(
    (e) => e.name == value,
    orElse: () => PaymentStatus.pending,
  );
}
