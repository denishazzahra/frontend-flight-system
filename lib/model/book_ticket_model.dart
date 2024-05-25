class BookTicketModel {
  String? status;
  String? message;
  Ticket? ticket;

  BookTicketModel({this.status, this.message, this.ticket});

  BookTicketModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    ticket = json['ticket'] != null ? Ticket.fromJson(json['ticket']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (ticket != null) {
      data['ticket'] = ticket!.toJson();
    }
    return data;
  }
}

class Ticket {
  String? id;
  String? fullName;
  String? email;
  String? phone;
  String? date;
  double? soldAtPrice;
  String? currency;
  String? userId;
  int? flightId;
  int? seatId;

  Ticket(
      {this.id,
      this.fullName,
      this.email,
      this.phone,
      this.date,
      this.soldAtPrice,
      this.currency,
      this.userId,
      this.flightId,
      this.seatId});

  Ticket.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['fullName'];
    email = json['email'];
    phone = json['phone'];
    date = json['date'];
    soldAtPrice = double.tryParse(json['soldAtPrice'].toString());
    currency = json['currency'];
    userId = json['userId'];
    flightId = json['flightId'];
    seatId = json['seatId'];
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
    data['userId'] = userId;
    data['flightId'] = flightId;
    data['seatId'] = seatId;
    return data;
  }
}
