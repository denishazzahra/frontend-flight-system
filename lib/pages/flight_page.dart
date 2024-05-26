import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:tugas5_tpm/connection/api_data_source.dart';
import 'package:tugas5_tpm/utils/colors.dart';
import 'package:tugas5_tpm/utils/date.dart';
import 'package:tugas5_tpm/utils/numbers.dart';
import 'package:tugas5_tpm/widgets/texts.dart';

import '../model/flight_model.dart';
import 'flight_detail_page.dart';

class FlightPage extends StatefulWidget {
  final String origin, destination, date;
  const FlightPage({
    super.key,
    required this.origin,
    required this.destination,
    required this.date,
  });

  @override
  State<FlightPage> createState() => _FlightPageState();
}

class _FlightPageState extends State<FlightPage> {
  List<Flights> flightList = [];
  List<bool> stateIndex = [];
  String title = '';
  late DateTime parsedDate;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFlights();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.origin != '' && widget.destination != '') {
      title = '${widget.origin} > ${widget.destination}';
    } else if (widget.origin == '') {
      title = 'To ${widget.destination}';
    } else {
      title = 'From ${widget.origin}';
    }
    parsedDate = DateFormat('yyyy-MM-dd').parse(widget.date);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          title: Column(
            children: [
              boldDefaultText(title, TextAlign.center),
              smallerSubText(formattedFlightDate(parsedDate), TextAlign.center)
            ],
          ),
        ),
        body: _flightDisplay(),
      ),
    );
  }

  Widget _flightDisplay() {
    return flightList.isNotEmpty
        ? ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return _flightItem(index);
            },
            itemCount: flightList.length,
          )
        : Center(
            child: _isLoading
                ? CircularProgressIndicator(color: blackColor)
                : const Text('No flight is available.'));
  }

  Widget _flightItem(int index) {
    int cheapestPrice = flightList[index].seats![0].price!;
    for (var seat in flightList[index].seats!) {
      if (seat.price! < cheapestPrice) {
        cheapestPrice = seat.price!;
      }
    }
    double topMargin = index == 0 ? 15 : 7.5;
    double bottomMargin = index == flightList.length - 1 ? 15 : 7.5;
    Map<String, String> duration = flightDuration(
      widget.date,
      flightList[index].departureTime!,
      flightList[index].originAirport!.timezone!,
      flightList[index].arrivalTime!,
      flightList[index].destinationAirport!.timezone!,
      true,
    );
    return Container(
      margin: EdgeInsets.only(
        top: topMargin,
        bottom: bottomMargin,
        left: 15,
        right: 15,
      ),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: lightGreyColor),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: listTitleText(
                    '${flightList[index].airline!} (${flightList[index].flightNumber})'),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  smallerSubText('Available from', TextAlign.right),
                  boldDefaultText(
                      formatNumber(cheapestPrice, 'IDR', true), TextAlign.right)
                ],
              )
            ],
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Symbols.my_location,
                          fill: 0,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: 85,
                          child: boldSmallText(
                            duration['departure_time']!,
                            TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: smallerSubText(
                          '${flightList[index].originAirport!.name!} (${flightList[index].originAirport!.code!})',
                          TextAlign.left),
                    )
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              const SizedBox(width: 30),
              smallerSubText(
                  '${duration['duration']} ${duration['note']}', TextAlign.left)
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Symbols.location_on,
                          fill: 0,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: 85,
                          child: boldSmallText(
                            duration['arrival_time']!,
                            TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: smallerSubText(
                          '${flightList[index].destinationAirport!.name!} (${flightList[index].destinationAirport!.code!})',
                          TextAlign.left),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 5),
              IconButton(
                onPressed: () {
                  setState(() {
                    stateIndex[index] = !stateIndex[index];
                  });
                },
                icon: Icon(
                  stateIndex[index]
                      ? Symbols.keyboard_arrow_down
                      : Symbols.keyboard_arrow_right,
                  fill: 0,
                ),
                iconSize: 24,
                splashRadius: 24,
                constraints:
                    const BoxConstraints.tightFor(height: 24, width: 24),
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
          _flightDetail(index),
        ],
      ),
    );
  }

  Widget _flightDetail(int index) {
    return stateIndex[index]
        ? Column(
            children: flightList[index].seats!.asMap().entries.map((item) {
              double topMargin = item.key == 0 ? 15 : 7.5;
              double bottomMargin =
                  item.key == flightList[index].seats!.length - 1 ? 0 : 7.5;
              int remainingSeats =
                  item.value.capacity! - item.value.ticketCount!;
              return InkWell(
                overlayColor: MaterialStateProperty.all(Colors.transparent),
                onTap: remainingSeats == 0
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return FlightBookingPage(
                              flightId: flightList[index].id!,
                              seatId: item.value.id!,
                              date: widget.date,
                              flight: flightList[index],
                            );
                          }),
                        );
                      },
                child: Container(
                  margin: EdgeInsets.only(top: topMargin, bottom: bottomMargin),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: lightGreyColor),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: remainingSeats == 0
                            ? boldDefaultDisableText(
                                item.value.type!, TextAlign.left)
                            : boldDefaultText(item.value.type!, TextAlign.left),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          remainingSeats == 0
                              ? boldSmallDisableText(
                                  formatNumber(item.value.price!, 'IDR', true),
                                  TextAlign.right)
                              : boldSmallText(
                                  formatNumber(item.value.price!, 'IDR', true),
                                  TextAlign.right),
                          remainingSeats == 0
                              ? disableSubText('Sold out', TextAlign.right)
                              : remainingSeats <= 10
                                  ? dangerSubText(
                                      '$remainingSeats seats left',
                                      TextAlign.right,
                                    )
                                  : safeSubText('Available', TextAlign.right)
                        ],
                      )
                    ],
                  ),
                ),
              );
            }).toList(),
          )
        : Container();
  }

  void _loadFlights() {
    Map<String, String> body = {
      'origin': widget.origin,
      'destination': widget.destination,
      'date': widget.date
    };
    ApiDataSource.getFlights(body).then((data) {
      setState(() {
        flightList = FilteredFlight.fromJson(data).flights!;
        stateIndex = List.filled(flightList.length, false);
      });
    }).catchError((error) {
      setState(() {
        flightList = [];
        stateIndex = [];
      });
    }).whenComplete(() {
      setState(() {
        _isLoading = false;
      });
    });
  }
}
