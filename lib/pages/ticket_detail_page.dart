import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:tugas5_tpm/utils/numbers.dart';

import '../model/load_ticket_model.dart';
import '../utils/colors.dart';
import '../utils/date.dart';
import '../widgets/texts.dart';

class TicketDetailPage extends StatefulWidget {
  final Tickets ticket;
  const TicketDetailPage({super.key, required this.ticket});

  @override
  State<TicketDetailPage> createState() => _TicketDetailPageState();
}

class _TicketDetailPageState extends State<TicketDetailPage> {
  late String originTimezone = widget.ticket.flight!.originAirport!.timezone!;
  late String destinationTimezone =
      widget.ticket.flight!.destinationAirport!.timezone!;
  List<String> timezones = ['WIB', 'WITA', 'WIT', 'GMT'];
  late TextEditingController _originTimezoneController;
  late TextEditingController _destinationTimezoneController;

  @override
  void initState() {
    super.initState();
    _originTimezoneController = TextEditingController();
    _destinationTimezoneController = TextEditingController();
  }

  @override
  void dispose() {
    _originTimezoneController.dispose();
    _destinationTimezoneController.dispose();
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
          title: boldDefaultText('Ticket Details', TextAlign.center),
        ),
        backgroundColor: backgroundColor,
        body: _ticketDetailDisplay(),
      ),
    );
  }

  Widget _ticketDetailDisplay() {
    Map<String, String> duration = flightDuration(
      widget.ticket.date!,
      widget.ticket.flight!.departureTime!,
      originTimezone,
      widget.ticket.flight!.arrivalTime!,
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
                      Icon(
                        Symbols.confirmation_number,
                        fill: 0,
                        size: 20,
                        color: greyTextColor,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                          child: subText(widget.ticket.id!, TextAlign.left))
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            boldDefaultText(
                                widget.ticket.flight!.originAirport!.name!,
                                TextAlign.center),
                            smallerSubText(
                                widget.ticket.flight!.originAirport!.city!,
                                TextAlign.center),
                          ],
                        ),
                      ),
                      const Icon(Symbols.arrow_forward, fill: 0, size: 28),
                      Expanded(
                        child: Column(
                          children: [
                            boldDefaultText(
                                widget.ticket.flight!.destinationAirport!.name!,
                                TextAlign.center),
                            smallerSubText(
                                widget.ticket.flight!.destinationAirport!.city!,
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
                        widget.ticket.flight!.airline!,
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
                        widget.ticket.flight!.flightNumber!,
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
                            smallerSubText('Seat Class', TextAlign.left),
                            boldDefaultText(
                              widget.ticket.seat!.type!,
                              TextAlign.left,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            smallerSubText('Total Price', TextAlign.right),
                            boldDefaultText(
                              formatNumberDecimal(widget.ticket.soldAtPrice!,
                                  widget.ticket.currency!, true),
                              TextAlign.right,
                            ),
                          ],
                        ),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      smallerSubText('Full Name', TextAlign.left),
                      boldDefaultText(
                        widget.ticket.fullName!,
                        TextAlign.left,
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      smallerSubText('Email', TextAlign.left),
                      boldDefaultText(
                        widget.ticket.email!,
                        TextAlign.left,
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      smallerSubText('Phone', TextAlign.left),
                      boldDefaultText(
                        widget.ticket.phone!,
                        TextAlign.left,
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
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
}
