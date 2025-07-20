class Address {
  final String addressLine1;
  final String? addressLine2;
  final String country;
  final String state;
  final String city;
  final String pincode;

  Address({
    required this.addressLine1,
    this.addressLine2,
    required this.country,
    required this.state,
    required this.city,
    required this.pincode,
  });

  Map<String, String?> toJson() => {
    'addressLine1': addressLine1,
    'addressLine2': addressLine2,
    'country': country,
    'state': state,
    'city': city,
    'pincode': pincode,
  };
} 