import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tugas5_tpm/connection/api_data_source.dart';
import 'package:tugas5_tpm/utils/numbers.dart';
import 'package:tugas5_tpm/widgets/texts.dart';
import '../model/load_ticket_model.dart';
import '../utils/colors.dart';
import '../utils/date.dart';
import 'ticket_detail_page.dart';

class TicketPage extends StatefulWidget {
  const TicketPage({super.key});

  @override
  State<TicketPage> createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> with TickerProviderStateMixin {
  late List<Tickets> activeTickets = [];
  late List<Tickets> expiredTickets = [];
  late String token;
  late TabController _tabController;
  bool _isLoading = true;
  DateTime today = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadToken();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          indicatorColor: blackColor,
          labelColor: blackColor,
          tabs: const [
            Tab(text: 'Active'),
            Tab(text: 'Expired'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildTicketList(activeTickets),
              _buildTicketList(expiredTickets)
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTicketList(List<Tickets> tickets) {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: blackColor,
        ),
      );
    } else if (tickets.isEmpty) {
      return const Center(
        child: Center(child: Text('No tickets available')),
      );
    } else {
      return Container(
        padding: const EdgeInsets.all(15),
        child: ListView.separated(
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return TicketDetailPage(ticket: tickets[index]);
                  }),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: lightGreyColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: smallerText(
                              formattedFlightDate(
                                DateFormat('yyyy-MM-dd')
                                    .parse(tickets[index].date!),
                              ),
                              TextAlign.left),
                        ),
                        const SizedBox(width: 10),
                        Icon(
                          Symbols.confirmation_number,
                          fill: 0,
                          size: 18,
                          color: greyTextColor,
                        ),
                        const SizedBox(width: 10),
                        smallerSubText(tickets[index].id!, TextAlign.right),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(
                          Symbols.travel,
                          fill: 1,
                          size: 24,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: boldDefaultText(
                            '${tickets[index].flight!.airline} (${tickets[index].flight!.flightNumber})',
                            TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    boldDefaultText(
                                        tickets[index]
                                            .flight!
                                            .originAirport!
                                            .name!,
                                        TextAlign.center),
                                    smallerSubText(
                                        tickets[index]
                                            .flight!
                                            .originAirport!
                                            .city!,
                                        TextAlign.center),
                                  ],
                                ),
                              ),
                              const Icon(Symbols.arrow_forward,
                                  fill: 0, size: 28),
                              Expanded(
                                child: Column(
                                  children: [
                                    boldDefaultText(
                                        tickets[index]
                                            .flight!
                                            .destinationAirport!
                                            .name!,
                                        TextAlign.center),
                                    smallerSubText(
                                        tickets[index]
                                            .flight!
                                            .destinationAirport!
                                            .city!,
                                        TextAlign.center),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            smallerSubText('Total', TextAlign.right),
                            boldSmallText(
                              formatNumberDecimal(tickets[index].soldAtPrice!,
                                  tickets[index].currency!, true),
                              TextAlign.right,
                            )
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          },
          separatorBuilder: ((context, index) {
            return const SizedBox(height: 15);
          }),
          itemCount: tickets.length,
        ),
      );
    }
  }

  void _loadTicket() {
    ApiDataSource.getTickets(token).then((data) {
      final loadedTickets = LoadTicketModel.fromJson(data).tickets!;
      setState(() {
        activeTickets = loadedTickets
            .where((ticket) =>
                parseDate('${ticket.date!} ${ticket.flight!.arrivalTime!}')
                    .isAtSameMomentAs(today) ||
                parseDate('${ticket.date!} ${ticket.flight!.arrivalTime!}')
                    .isAfter(today))
            .toList();
        expiredTickets = loadedTickets
            .where((ticket) =>
                parseDate('${ticket.date!} ${ticket.flight!.arrivalTime!}')
                    .isBefore(today))
            .toList()
            .reversed
            .toList();
      });
    }).catchError((error) {
      setState(() {
        activeTickets = [];
        expiredTickets = [];
      });
    }).whenComplete(() {
      setState(() {
        _isLoading = false;
      });
    });
  }

  void _loadToken() {
    SharedPreferences.getInstance().then((storage) {
      token = storage.getString('token')!;
    }).whenComplete(() {
      _loadTicket();
    });
  }
}
