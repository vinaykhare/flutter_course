class Address {
  String? id = "",
      houseNo = "",
      addressLine = "",
      landmark = "",
      pincode = "",
      city = "",
      state = "",
      latitude = "",
      longitude = "";

  Address({
    this.id,
    this.houseNo,
    this.addressLine,
    this.landmark,
    this.pincode,
    this.city,
    this.state,
    this.latitude,
    this.longitude,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "houseNo": houseNo,
      "addressLine": addressLine,
      "landmark": landmark,
      "pincode": pincode,
      "city": city,
      "state": state,
      "latitude": latitude,
      "longitude": longitude,
    };
  }

  Address.fromJson(Map<String, dynamic> json) {
    id = DateTime.now().toIso8601String();
    houseNo = json["houseNo"];
    addressLine = json["addressLine"];
    landmark = json["landmark"];
    pincode = json["pincode"];
    city = json["city"];
    state = json["state"];
    latitude = json["latitude"];
    longitude = json["longitude"];
  }
}
