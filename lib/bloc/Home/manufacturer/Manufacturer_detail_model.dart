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
  final List<String>? interestingFacts;

  ManufacturerData({
    required this.id,
    required this.general,
    required this.company,
    required this.product,
    this.interestingFacts,
  });

  factory ManufacturerData.fromJson(Map<String, dynamic> json) {
    return ManufacturerData(
      id: json['id'],
      general: General.fromJson(json['general']),
      company: Company.fromJson(json['company']),
      product: (json['product'] as List<dynamic>)
          .map((e) => Product.fromJson(e))
          .toList(),
      interestingFacts: (json['interesting_facts'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
    );
  }
}

class General {
  final String companyName;
  final String? headquarter;
  final String foundingDate;
  final String logo;
  final String? description;
  final CoverPhoto coverPhoto;

  General({
    required this.companyName,
    this.headquarter,
    required this.foundingDate,
    required this.logo,
    required this.description,
    required this.coverPhoto,
  });

  factory General.fromJson(Map<String, dynamic> json) {
    return General(
      companyName: json['company_name'],
      headquarter: json['headquarter'],
      foundingDate: json['founding_date'],
      logo: json['logo'],
      description: json['description'],
      coverPhoto: CoverPhoto.fromJson(json['cover_photo']),
    );
  }
}

class CoverPhoto {
  final String url;
  final String license;
  final String? author; // make nullable
  final String? wiki;

  CoverPhoto({
    required this.url,
    required this.license,
    this.author, // optional
    this.wiki,
  });

  factory CoverPhoto.fromJson(Map<String, dynamic> json) {
    return CoverPhoto(
      url: json['url'] ?? '', // default empty string if missing
      license: json['license'] ?? 'Unknown',
      author: json['author'], // nullable
      wiki: json['wiki'],     // nullable
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
