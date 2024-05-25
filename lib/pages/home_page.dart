import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:tugas5_tpm/data/recommendation.dart';
import 'package:tugas5_tpm/pages/profile_page.dart';
import 'package:tugas5_tpm/widgets/texts.dart';
import '../utils/text_sizes.dart';
import 'search_page.dart';
import '../utils/colors.dart';
import '../widgets/appbar.dart';
import 'ticket_page.dart';

class HomePage extends StatefulWidget {
  final int index;
  const HomePage({
    super.key,
    required this.index,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String token = '';
  late int currentPageIndex = widget.index;
  String? dAirportName, dAirportCode;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBar(context),
        bottomNavigationBar: _bottomNavbar(),
        body: currentPageIndex == 0
            ? _homeDisplay()
            : currentPageIndex == 1
                ? SearchPage(
                    dAirportName: dAirportName, dAirportCode: dAirportCode)
                : currentPageIndex == 2
                    ? const TicketPage()
                    : const ProfilePage(),
      ),
    );
  }

  Widget _homeDisplay() {
    return Center(
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              listTitleText('Popular Destinations'),
              const SizedBox(height: 15),
              _recommendationDisplay(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _recommendationDisplay() {
    final items = recommendationList.asMap().values.toList();
    return Column(
      children: items.map((item) {
        int index = items.indexOf(item);
        bool isLastItem = index == items.length - 1;
        return Column(
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  dAirportName = item.name;
                  dAirportCode = item.code;
                  currentPageIndex = 1;
                });
              },
              child: AspectRatio(
                aspectRatio: 2 / 1,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                  child: Stack(
                    children: <Widget>[
                      Image.asset(
                        'assets/images/${item.image}',
                        fit: BoxFit.cover,
                        height: double.infinity,
                        width: double.infinity,
                      ),
                      Positioned(
                        bottom: 0.0,
                        left: 0.0,
                        right: 0.0,
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromARGB(255, 0, 0, 0),
                                Color.fromARGB(150, 0, 0, 0),
                                Color.fromARGB(0, 0, 0, 0)
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 20),
                              Text(
                                item.name,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: whiteColor,
                                  fontSize: bigSize,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subText(item.code, TextAlign.left),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (!isLastItem) const SizedBox(height: 15),
          ],
        );
      }).toList(),
    );
  }

  Widget _bottomNavbar() {
    return NavigationBar(
      elevation: 0,
      onDestinationSelected: (int index) {
        setState(() {
          currentPageIndex = index;
          dAirportCode = null;
          dAirportName = null;
        });
      },
      indicatorColor: blackColor,
      selectedIndex: currentPageIndex,
      destinations: const <Widget>[
        NavigationDestination(
          selectedIcon: Icon(
            Symbols.home,
            color: Colors.white,
            fill: 1,
          ),
          icon: Icon(
            Symbols.home,
            fill: 0,
          ),
          label: 'Home',
        ),
        NavigationDestination(
          selectedIcon: Icon(
            Symbols.search,
            color: Colors.white,
            fill: 1,
            weight: 600,
          ),
          icon: Icon(
            Icons.search,
            fill: 0,
          ),
          label: 'Search',
        ),
        NavigationDestination(
          selectedIcon: Icon(
            Symbols.confirmation_number,
            color: Colors.white,
            fill: 1,
          ),
          icon: Icon(
            Symbols.confirmation_number,
            fill: 0,
          ),
          label: 'Tickets',
        ),
        NavigationDestination(
          selectedIcon: Icon(Symbols.person, color: Colors.white, fill: 1),
          icon: Icon(
            Symbols.person,
            fill: 0,
          ),
          label: 'Profile',
        ),
      ],
    );
  }
}
