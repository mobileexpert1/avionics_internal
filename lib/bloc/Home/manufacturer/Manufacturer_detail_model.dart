class ManufacturerDetailResponse {
  final String detail;
  final ManufacturerData data;

  ManufacturerDetailResponse({required this.detail, required this.data});

  factory ManufacturerDetailResponse.fromJson(Map<String, dynamic> json) {
    return ManufacturerDetailResponse(
      detail: json['detail'],
      data: ManufacturerData.fromJson(json['data']),
    );
  }
}

class ManufacturerData {
  final String id;
  final General general;
  final Company company;
  final List<Product> product;

  ManufacturerData({
    required this.id,
    required this.general,
    required this.company,
    required this.product,
  });

  factory ManufacturerData.fromJson(Map<String, dynamic> json) {
    return ManufacturerData(
      id: json['id'],
      general: General.fromJson(json['general']),
      company: Company.fromJson(json['company']),
      product: (json['product'] as List<dynamic>)
          .map((e) => Product.fromJson(e))
          .toList(),
    );
  }
}

class General {
  final String companyName;
  final String? headquarter;
  final String ceo;
  final String foundingDate;
  final String lastYearRevenue;
  final String logo;
  final String description;
  final List<String> gallery;
  final List<String> coverPhoto;

  General({
    required this.companyName,
    this.headquarter,
    required this.ceo,
    required this.foundingDate,
    required this.lastYearRevenue,
    required this.logo,
    required this.description,
    required this.gallery,
    required this.coverPhoto,
  });

  factory General.fromJson(Map<String, dynamic> json) {
    return General(
      companyName: json['company_name'],
      headquarter: json['headquarter'],
      ceo: json['ceo'],
      foundingDate: json['founding_date'],
      lastYearRevenue: json['last_year_revenue'],
      logo: json['logo'],
      description: json['description'],
      gallery: List<String>.from(json['gallery']),
      coverPhoto: List<String>.from(json['cover_photo']),
    );
  }
}

class Company {
  final String companyDescription;
  final String companyHistory;

  Company({required this.companyDescription, required this.companyHistory});

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      companyDescription: json['company_description'],
      companyHistory: json['company_history'],
    );
  }
}

class Product {
  final String series;
  final String description;

  Product({required this.series, required this.description});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(series: json['series'], description: json['description']);
  }
}
