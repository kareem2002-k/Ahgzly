// ignore: file_names
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ahgzly/widgets/SportButton.dart';
import 'package:ahgzly/services/LocationService.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedSport = '';
  TextEditingController searchController = TextEditingController();
  String location = '';
  LocationService locationService = LocationService();

  @override
  void initState() {
    super.initState();
    // Request location permissions when the app starts
    _requestLocationPermission();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> _requestLocationPermission() async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      try {
        final currentLocation = await locationService.getCurrentLocation();
        setState(() {
          location = currentLocation;
        });
      } catch (e) {
        print(e);
        setState(() {
          location = 'Location not found';
        });
      }
    } else {
      // Location permission denied, handle it as needed
      setState(() {
        location = 'Location permission denied';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Add location selection functionality here
                        // For example, open a location picker dialog
                        // and update the 'location' variable.
                      },
                      child: Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Colors.black,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            location,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // Add notification icon's functionality here
                      },
                      icon: const Icon(
                        Icons.notifications_none_outlined,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                  height: 16), // Add space between the search bar and buttons
              Container(
                width: double.infinity,
                height: 51.31,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: const Color(0xFFF6F6F6),
                  borderRadius: BorderRadius.circular(10.69),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ignore: sized_box_for_whitespace
                    Container(
                      width: 26.41,
                      height: 25.66,
                      child: const Icon(
                        Icons.search,
                        color: Color(0xFF848484),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 11.57),
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        style:
                            const TextStyle(fontSize: 16), // Increase font size
                        decoration: const InputDecoration(
                          hintText: 'Search address, or near you',
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                  height: 16), // Add space between the search bar and buttons
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    SportButton(
                      label: 'Sport 1',
                      selected: selectedSport == 'Sport 1',
                      onPressed: () => toggleSport('Sport 1'),
                    ),
                    SportButton(
                      label: 'Sport 2',
                      selected: selectedSport == 'Sport 2',
                      onPressed: () => toggleSport('Sport 2'),
                    ),
                    SportButton(
                      label: 'Sport 3',
                      selected: selectedSport == 'Sport 3',
                      onPressed: () => toggleSport('Sport 3'),
                    ),
                  ],
                ),
              ),
              if (selectedSport.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: Colors.green,
                  child: Text(
                    'Selected Sport: $selectedSport',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void toggleSport(String sport) {
    setState(() {
      selectedSport = selectedSport == sport ? '' : sport;
    });
  }
}
