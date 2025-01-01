import 'package:flutter/material.dart';

import '../../db_helper/db_helper.dart';

class UpdateNews extends StatefulWidget {
  final int id;
  final String initialTitle;
  final String initialDescription;
  final String businessStatus;
  final double lat;
  final double lng;
  final double viewportNortheastLat;
  final double viewportNortheastLng;
  final double viewportSouthwestLat;
  final double viewportSouthwestLng;
  final String icon;
  final String iconBackgroundColor;
  final String iconMaskBaseUri;
  final String name;
  final String placeId;
  final double rating;
  final String reference;
  final String scope;
  final int userRatingsTotal;
  final String vicinity;

  const UpdateNews({
    Key? key,
    required this.id,
    required this.initialTitle,
    required this.initialDescription,
    required this.businessStatus,
    required this.lat,
    required this.lng,
    required this.viewportNortheastLat,
    required this.viewportNortheastLng,
    required this.viewportSouthwestLat,
    required this.viewportSouthwestLng,
    required this.icon,
    required this.iconBackgroundColor,
    required this.iconMaskBaseUri,
    required this.name,
    required this.placeId,
    required this.rating,
    required this.reference,
    required this.scope,
    required this.userRatingsTotal,
    required this.vicinity,
  }) : super(key: key);

  @override
  State<UpdateNews> createState() => _UpdateNewsState();
}

class _UpdateNewsState extends State<UpdateNews> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _latController;
  late TextEditingController _lngController;
  late TextEditingController _viewportNortheastLatController;
  late TextEditingController _viewportNortheastLngController;
  late TextEditingController _viewportSouthwestLatController;
  late TextEditingController _viewportSouthwestLngController;
  late TextEditingController _ratingController;
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);
    _descriptionController = TextEditingController(text: widget.initialDescription);
    _latController = TextEditingController(text: widget.lat.toString());
    _lngController = TextEditingController(text: widget.lng.toString());
    _viewportNortheastLatController = TextEditingController(text: widget.viewportNortheastLat.toString());
    _viewportNortheastLngController = TextEditingController(text: widget.viewportNortheastLng.toString());
    _viewportSouthwestLatController = TextEditingController(text: widget.viewportSouthwestLat.toString());
    _viewportSouthwestLngController = TextEditingController(text: widget.viewportSouthwestLng.toString());
    _ratingController = TextEditingController(text: widget.rating.toString());
    _nameController = TextEditingController(text: widget.name);
  }

  @override
  void dispose() {
    _latController.dispose();
    _lngController.dispose();
    _viewportNortheastLatController.dispose();
    _viewportNortheastLngController.dispose();
    _viewportSouthwestLatController.dispose();
    _viewportSouthwestLngController.dispose();
    _ratingController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title, description, and name cannot be empty')),
      );
      return;
    }

    final updatedValues = {
      'name': _nameController.text,
    };
    final dbHelper = DatabaseHelper();
    await dbHelper.updateFav(widget.id, updatedValues);
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(
          'Edit Article',
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
        ),),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: const Color(0xFF1A1A2E),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'Edit Name',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextField(
                  controller: _nameController,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    hintText: 'Enter name',
                    hintStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'Edit Latitude',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextField(
                  controller: _latController,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    hintText: 'Enter latitude',
                    hintStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'Edit Longitude',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextField(
                  controller: _lngController,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    hintText: 'Enter longitude',
                    hintStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'Edit Northeast Latitude',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextField(
                  controller: _viewportNortheastLatController,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    hintText: 'Enter Northeast Latitude',
                    hintStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'Edit Northeast Longitude',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextField(
                  controller: _viewportNortheastLngController,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    hintText: 'Enter Northeast Longitude',
                    hintStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'Edit Southwest Latitude',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextField(
                  controller: _viewportSouthwestLatController,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    hintText: 'Enter Southwest Latitude',
                    hintStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'Edit Southwest Longitude',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextField(
                  controller: _viewportSouthwestLngController,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    hintText: 'Enter Southwest Longitude',
                    hintStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'Edit Rating',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextField(
                  controller: _ratingController,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    hintText: 'Enter rating',
                    hintStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(child: ElevatedButton(
                onPressed: _saveChanges,
                child: const Text('Save Changes'),
              ),)
            ],
          ),
        ),
      ),
    );
  }
}
