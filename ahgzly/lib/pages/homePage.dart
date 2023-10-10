import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ahgzly/widgets/SportButton.dart';
import 'package:ahgzly/services/LocationService.dart';
import 'package:ahgzly/services/FireStoreService.dart';
import 'package:ahgzly/models/Court.dart'; // Import the Court model
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ahgzly/widgets/CourtCard.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Properties
  String selectedSport = '';
  TextEditingController searchController = TextEditingController();
  String location = '';
  LocationService locationService = LocationService();
  List<Court> courts = []; // List to hold retrieved courts

  // Lifecycle methods
  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
    _loadCourts('football'); // Load courts when the page initializes
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // Permission handling
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
      setState(() {
        location = 'Location permission denied';
      });
    }
  }

  // Load courts based on selected sport
  Future<void> _loadCourts(String sport) async {
    try {
      final loadedCourts = await FirestoreService().getCourts(sport);
      setState(() {
        courts = loadedCourts;
      });
    } catch (e) {
      print(e);
    }
  }

  // UI rendering
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTopBar(),
              const SizedBox(height: 16),
              _buildSearchBar(),
              const SizedBox(height: 16),
              _buildSportButtons(),
              if (selectedSport.isNotEmpty) _buildSelectedSportInfo(),
              const SizedBox(height: 16),
              _buildCourtList(), // Display the list of courts
            ],
          ),
        ),
      ),
    );
  }

  // Widget methods
  Widget _buildTopBar() {
    return Padding(
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
    );
  }

  Widget _buildSearchBar() {
    return Container(
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
              style: const TextStyle(fontSize: 16),
              decoration: const InputDecoration(
                hintText: 'Search address, or near you',
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSportButtons() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildSportButton('Sport 1'),
          _buildSportButton('Sport 2'),
          _buildSportButton('Sport 3'),
        ],
      ),
    );
  }

  Widget _buildSportButton(String label) {
    return SportButton(
      label: label,
      selected: selectedSport == label,
      onPressed: () => toggleSport(label),
    );
  }

  Widget _buildSelectedSportInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.green,
      child: Text(
        'Selected Sport: $selectedSport',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
      ),
    );
  }

  // Build the list of courts
  Widget _buildCourtList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(), // Disable scrolling for the list
      itemCount: courts.length,
      itemBuilder: (context, index) {
        return CourtCard(court: courts[index]);
      },
    );
  }

  // Helper methods
  void toggleSport(String sport) {
    setState(() {
      selectedSport = selectedSport == sport ? '' : sport;
      _loadCourts(selectedSport); // Load courts for the selected sport
    });
  }
}
