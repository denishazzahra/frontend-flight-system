import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import '../connection/api_data_source.dart';
import '../model/airport_model.dart';
import '../utils/colors.dart';
import '../utils/date.dart';
import '../widgets/buttons.dart';
import '../widgets/texts.dart';
import 'flight_page.dart';

class SearchPage extends StatefulWidget {
  final String? dAirportName, dAirportCode;
  const SearchPage({super.key, this.dAirportName, this.dAirportCode});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Airport> airportList = [];
  late TextEditingController _originController;
  late TextEditingController _destinationController;
  late TextEditingController _dateController;
  final DateTime today = DateTime.now();
  String selectedOrigin = '', selectedDestination = '', selectedDate = '';
  late DateTime oneMonthFromNow =
      DateTime(today.year, today.month + 1, today.day);

  @override
  void initState() {
    super.initState();
    _loadAirports();
    _originController = TextEditingController();
    _destinationController = TextEditingController();
    _dateController = TextEditingController();
    setState(() {
      _dateController.text = formattedFlightDate(today);
      selectedDate = formattedSearchDate(today);
      if (widget.dAirportCode != '') {
        _destinationController.text =
            '${widget.dAirportName!} (${widget.dAirportCode})';
        selectedDestination = widget.dAirportCode!;
      }
    });
  }

  @override
  void dispose() {
    _originController.dispose();
    _destinationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return searchDisplay();
  }

  Widget searchDisplay() {
    return Center(
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(15),
          constraints: const BoxConstraints(
            maxWidth: 600,
          ),
          width: double.infinity,
          child: Column(
            children: [
              listTitleText('Flight Details'),
              const SizedBox(height: 15),
              airportDropdown('Origin', _originController, Symbols.my_location),
              const SizedBox(height: 15),
              airportDropdown(
                  'Destination', _destinationController, Symbols.location_on),
              const SizedBox(height: 15),
              datePicker(),
              const SizedBox(height: 15),
              blackButton(context, 'Search Ticket', () {
                executeSearch();
              })
            ],
          ),
        ),
      ),
    );
  }

  Widget datePicker() {
    return TextField(
      controller: _dateController,
      readOnly: true,
      onTap: () {
        _selectDate(context);
      },
      decoration: InputDecoration(
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
        labelText: 'Date',
        prefixIcon: const Icon(Symbols.calendar_month),
      ),
    );
  }

  DropdownMenu<String> airportDropdown(
      String title, TextEditingController controller, IconData icon) {
    return DropdownMenu<String>(
      width: MediaQuery.of(context).size.width - 30,
      controller: controller,
      enableFilter: true,
      requestFocusOnTap: true,
      leadingIcon: Icon(icon, fill: 0),
      label: Text(title),
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
      onSelected: (String? airport) {
        setState(() {
          if (title == 'Origin') {
            selectedOrigin = airport!;
          } else {
            selectedDestination = airport!;
          }
        });
      },
      dropdownMenuEntries: airportList.map<DropdownMenuEntry<String>>(
        (Airport airport) {
          return DropdownMenuEntry<String>(
            value: airport.code!,
            label: '${airport.name} (${airport.code})',
          );
        },
      ).toList(),
    );
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: today,
      firstDate: today,
      lastDate: oneMonthFromNow,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: blackColor, // Header background color
            dividerColor: whiteColor,
            // accentColor: Colors.black, // Text color of selected date
            colorScheme: ColorScheme.light(
              primary: blackColor, // Selected date color
              onPrimary: whiteColor, // Text color on selected date
              surface: whiteColor, // Background color
            ),
            dialogBackgroundColor: whiteColor, // Background color of the picker
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != today) {
      // Handle the selected date (picked)
      setState(() {
        _dateController.text = formattedFlightDate(picked);
        selectedDate = formattedSearchDate(picked);
      });
    }
  }

  void _loadAirports() {
    ApiDataSource.getAirports().then((data) {
      setState(() {
        airportList = AirportList.fromJson(data).airport!;
      });
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $error')),
      );
    });
  }

  void executeSearch() {
    if (selectedDestination == '' && selectedOrigin == '') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Fill at least one of the origin or destination field!'),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          return FlightPage(
            origin: selectedOrigin,
            destination: selectedDestination,
            date: selectedDate,
          );
        }),
      );
    }
  }
}
