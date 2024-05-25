class LoadTicketModel {
  String? status;
  String? message;
  List<Tickets>? tickets;

  LoadTicketModel({this.status, this.message, this.tickets});

  LoadTicketModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['tickets'] != null) {
      tickets = <Tickets>[];
      json['tickets'].forEach((v) {
        tickets!.add(Tickets.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (tickets != null) {
      data['tickets'] = tickets!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Tickets {
  String? id;
  String? fullName;
  String? email;
  String? phone;
  String? date;
  double? soldAtPrice;
  String? currency;
  Flight? flight;
  Seat? seat;

  Tickets(
      {this.id,
      this.fullName,
      this.email,
      this.phone,
      this.date,
      this.soldAtPrice,
      this.currency,
      this.flight,
      this.seat});

  Tickets.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['fullName'];
    email = json['email'];
    phone = json['phone'];
    date = json['date'];
    soldAtPrice = double.tryParse(json['soldAtPrice'].toString());
    currency = json['currency'];
    flight = json['flight'] != null ? Flight.fromJson(json['flight']) : null;
    seat = json['seat'] != null ? Seat.fromJson(json['seat']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['fullName'] = fullName;
    data['email'] = email;
    data['phone'] = phone;
    data['date'] = date;
    data['soldAtPrice'] = soldAtPrice;
    data['currency'] = currency;
    if (flight != null) {
      data['flight'] = flight!.toJson();
    }
    if (seat != null) {
      data['seat'] = seat!.toJson();
    }
    return data;
  }
}

class Flight {
  String? airline;
  String? flightNumber;
  String? departureTime;
  String? arrivalTime;
  OriginAirport? originAirport;
  OriginAirport? destinationAirport;

  Flight(
      {this.airline,
      this.flightNumber,
      this.departureTime,
      this.arrivalTime,
      this.originAirport,
      this.destinationAirport});

  Flight.fromJson(Map<String, dynamic> json) {
    airline = json['airline'];
    flightNumber = json['flightNumber'];
    departureTime = json['departure_time'];
    arrivalTime = json['arrival_time'];
    originAirport = json['origin_airport'] != null
        ? OriginAirport.fromJson(json['origin_airport'])
        : null;
    destinationAirport = json['destination_airport'] != null
        ? OriginAirport.fromJson(json['destination_airport'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['airline'] = airline;
    data['flightNumber'] = flightNumber;
    data['departure_time'] = departureTime;
    data['arrival_time'] = arrivalTime;
    if (originAirport != null) {
      data['origin_airport'] = originAirport!.toJson();
    }
    if (destinationAirport != null) {
      data['destination_airport'] = destinationAirport!.toJson();
    }
    return data;
  }
}

class OriginAirport {
  String? name;
  String? code;
  String? city;
  String? province;
  String? timezone;

  OriginAirport(
      {this.name, this.code, this.city, this.province, this.timezone});

  OriginAirport.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    code = json['code'];
    city = json['city'];
    province = json['province'];
    timezone = json['timezone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['code'] = code;
    data['city'] = city;
    data['province'] = province;
    data['timezone'] = timezone;
    return data;
  }
}

class Seat {
  String? type;

  Seat({this.type});

  Seat.fromJson(Map<String, dynamic> json) {
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    return data;
  }
}
