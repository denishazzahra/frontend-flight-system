import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tugas5_tpm/connection/api_data_source.dart';
import 'package:tugas5_tpm/model/book_ticket_model.dart';
import 'package:tugas5_tpm/model/exchange_model.dart';
import 'package:tugas5_tpm/utils/numbers.dart';
import 'package:tugas5_tpm/widgets/buttons.dart';
import 'package:tugas5_tpm/widgets/texts.dart';

import '../data/currency.dart';
import '../model/flight_model.dart';
import '../model/user_model.dart';
import '../utils/colors.dart';
import '../utils/date.dart';
import '../widgets/text_fields.dart';
import 'home_page.dart';

class FlightBookingPage extends StatefulWidget {
  final int flightId;
  final int seatId;
  final String date;
  final Flights flight;
  const FlightBookingPage({
    super.key,
    required this.flightId,
    required this.seatId,
    required this.date,
    required this.flight,
  });

  @override
  State<FlightBookingPage> createState() => _FlightBookingPageState();
}

class _FlightBookingPageState extends State<FlightBookingPage> {
  late String originTimezone = widget.flight.originAirport!.timezone!;
  late String destinationTimezone = widget.flight.destinationAirport!.timezone!;
  List<String> timezones = ['WIB', 'WITA', 'WIT', 'GMT'];
  late TextEditingController _originTimezoneController;
  late TextEditingController _destinationTimezoneController;
  late TextEditingController _fullNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _currencyController;
  bool addData = false;
  String token = '';
  late User user;
  late Seats seat;
  late double price;
  String currency = 'IDR';
  late Map<String, double> conversionRates;
  bool agreeState = false;

  @override
  void initState() {
    super.initState();
    _loadToken();
    _originTimezoneController = TextEditingController();
    _destinationTimezoneController = TextEditingController();
    _fullNameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _currencyController = TextEditingController();
    seat = widget.flight.seats!.firstWhere((seat) => seat.id == widget.seatId);
    price = seat.price!.toDouble();
  }

  @override
  void dispose() {
    _originTimezoneController.dispose();
    _destinationTimezoneController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _currencyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          title: boldDefaultText('Ticket Booking', TextAlign.center),
        ),
        backgroundColor: backgroundColor,
        body: _bookingDisplay(),
      ),
    );
  }

  Widget _bookingDisplay() {
    Map<String, String> duration = flightDuration(
      widget.date,
      widget.flight.departureTime!,
      originTimezone,
      widget.flight.arrivalTime!,
      destinationTimezone,
      false,
    );
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            listTitleText('Flight Information'),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(15),
              width: double.infinity,
              decoration: BoxDecoration(
                color: whiteColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(1, 3),
                  ),
                ],
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            boldDefaultText(widget.flight.originAirport!.name!,
                                TextAlign.center),
                            smallerSubText(widget.flight.originAirport!.city!,
                                TextAlign.center),
                          ],
                        ),
                      ),
                      const Icon(Symbols.arrow_forward, fill: 0, size: 28),
                      Expanded(
                        child: Column(
                          children: [
                            boldDefaultText(
                                widget.flight.destinationAirport!.name!,
                                TextAlign.center),
                            smallerSubText(
                                widget.flight.destinationAirport!.city!,
                                TextAlign.center),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      smallerSubText('Airline', TextAlign.left),
                      boldDefaultText(
                        widget.flight.airline!,
                        TextAlign.left,
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      smallerSubText('Flight Number', TextAlign.left),
                      boldDefaultText(
                        widget.flight.flightNumber!,
                        TextAlign.left,
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            smallerSubText('Departure Time', TextAlign.left),
                            boldDefaultText(
                              '${duration['departure_date']!}, ${duration['departure_time']!}',
                              TextAlign.left,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      _timezoneDropdown(
                          'Origin', originTimezone, _originTimezoneController)
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            smallerSubText('Arrival Time', TextAlign.left),
                            boldDefaultText(
                              '${duration['arrival_date']!}, ${duration['arrival_time']!}',
                              TextAlign.left,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      _timezoneDropdown('Destination', destinationTimezone,
                          _destinationTimezoneController)
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            listTitleText('Passenger Information'),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(15),
              width: double.infinity,
              decoration: BoxDecoration(
                color: whiteColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(1, 3),
                  ),
                ],
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                children: [
                  textFieldWithLabel(
                    controller: _fullNameController,
                    placeholder: 'Full Name',
                    prefixIcon: const Icon(Icons.person_outline_rounded),
                  ),
                  const SizedBox(height: 15),
                  textFieldWithLabel(
                    controller: _emailController,
                    placeholder: 'Email Address',
                    prefixIcon: const Icon(Icons.alternate_email_rounded),
                  ),
                  const SizedBox(height: 15),
                  textFieldWithLabel(
                    controller: _phoneController,
                    placeholder: 'Phone Number',
                    prefixIcon: const Icon(Icons.numbers_rounded),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Switch(
                        value: addData,
                        activeColor: blackColor,
                        onChanged: (bool value) {
                          setState(() {
                            addData = value;
                          });
                          fillForm();
                        },
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: subText(
                          'Add your data to the form',
                          TextAlign.left,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 15),
            listTitleText('Seat Information'),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(15),
              width: double.infinity,
              decoration: BoxDecoration(
                color: whiteColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(1, 3),
                  ),
                ],
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      smallerSubText('Class', TextAlign.left),
                      boldDefaultText(
                        seat.type!,
                        TextAlign.left,
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            smallerSubText('Price', TextAlign.left),
                            boldDefaultText(
                              formatNumberDecimal(price, currency, false),
                              TextAlign.left,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      _currencyDropdown(currency, _currencyController)
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Checkbox(
                  checkColor: whiteColor,
                  activeColor: blackColor,
                  value: agreeState,
                  onChanged: (bool? value) {
                    setState(() {
                      agreeState = value!;
                    });
                  },
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'I agree to the Terms & Condition and Privacy Policy.',
                    softWrap: true,
                  ),
                )
              ],
            ),
            const SizedBox(height: 15),
            blackButton(context, 'Purchase Ticket', () {
              _sendRequest();
            }),
          ],
        ),
      ),
    );
  }

  void _sendRequest() {
    if (!agreeState) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'You have to agree to Terms and Condition and Privacy Policy to continue.'),
        ),
      );
    } else if (_fullNameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Full name, email, and phone can\'t be empty.'),
        ),
      );
    } else {
      Map<String, dynamic> body = {
        'flightId': widget.flightId,
        'seatId': seat.id!,
        'fullName': _fullNameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'date': widget.date,
        'soldAtPrice': price,
        'currency': currency
      };
      ApiDataSource.bookTicket(token, body).then((data) {
        BookTicketModel ticketModel = BookTicketModel.fromJson(data);
        String text = '';
        if (ticketModel.status == 'Success') {
          text = 'Ticket booked successfully.';
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) {
              return const HomePage(index: 2);
            }),
          );
        } else {
          text = 'Failed to book ticket!';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(text)),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('An error occurred: $error')));
      });
    }
  }

  void fillForm() {
    if (addData) {
      setState(() {
        _fullNameController.text = user.fullName!;
        _emailController.text = user.email!;
        _phoneController.text = user.phone!;
      });
    } else {
      setState(() {
        _fullNameController.text = '';
        _emailController.text = '';
        _phoneController.text = '';
      });
    }
  }

  DropdownMenu<String> _timezoneDropdown(
      String title, String selectedValue, TextEditingController controller) {
    return DropdownMenu<String>(
      controller: controller,
      initialSelection: selectedValue,
      enableSearch: false,
      enableFilter: false,
      requestFocusOnTap: false,
      inputDecorationTheme: InputDecorationTheme(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          borderSide: BorderSide(color: Colors.grey.shade600),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          borderSide: BorderSide(color: Colors.grey.shade600),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          borderSide: BorderSide(color: Colors.grey.shade600, width: 1.5),
        ),
      ),
      onSelected: (String? value) {
        setState(() {
          if (title == 'Origin') {
            originTimezone = value!;
          } else {
            destinationTimezone = value!;
          }
        });
      },
      dropdownMenuEntries: timezones.map<DropdownMenuEntry<String>>(
        (String timezone) {
          return DropdownMenuEntry<String>(
            value: timezone,
            label: timezone,
          );
        },
      ).toList(),
    );
  }

  DropdownMenu<String> _currencyDropdown(
      String selectedValue, TextEditingController controller) {
    return DropdownMenu<String>(
      controller: controller,
      initialSelection: selectedValue,
      enableSearch: false,
      enableFilter: false,
      requestFocusOnTap: false,
      inputDecorationTheme: InputDecorationTheme(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          borderSide: BorderSide(color: Colors.grey.shade600),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          borderSide: BorderSide(color: Colors.grey.shade600),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          borderSide: BorderSide(color: Colors.grey.shade600, width: 1.5),
        ),
      ),
      onSelected: (String? value) {
        setState(() {
          currency = value!;
          _loadCurrency();
        });
      },
      dropdownMenuEntries: currencyCodes.map<DropdownMenuEntry<String>>(
        (String code) {
          return DropdownMenuEntry<String>(
            value: code,
            label: code,
          );
        },
      ).toList(),
    );
  }

  void _loadCurrency() {
    ApiDataSource.getExchangeRate().then((data) {
      setState(() {
        conversionRates = ExchangeModel.fromJson(data).conversionRates!;
        price = seat.price!.toDouble() * conversionRates[currency]!;
      });
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $error')),
      );
    });
  }

  void _loadUser() {
    ApiDataSource.getUser(token).then((data) {
      user = UserModel.fromJson(data).user!;
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $error')),
      );
    });
  }

  void _loadToken() {
    SharedPreferences.getInstance().then((storage) {
      token = storage.getString('token')!;
    }).whenComplete(() {
      _loadUser();
    });
  }
}
