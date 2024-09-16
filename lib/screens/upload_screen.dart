import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/ipfs_service.dart';
import '../services/contract_service.dart';
import '../models/media_item.dart';

class UploadScreen extends StatefulWidget {
  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  XFile? _image;
  final _ipfsService = IPFSService();
  final _contractService = ContractService();

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  Future<void> _uploadMedia() async {
    if (_formKey.currentState!.validate() && _image != null) {
      // Upload image to IPFS
      final cid = await _ipfsService.uploadToIPFS(_image!.path);
      
      // Get current location and time
      final location = await _getCurrentLocation();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      
      // Create MediaItem
      final mediaItem = MediaItem(
        cid: cid,
        description: _descriptionController.text,
        location: location,
        timestamp: timestamp,
      );
      
      // Upload to blockchain
      await _contractService.uploadMediaData(mediaItem);
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Media uploaded successfully!')),
      );
    }
  }

  Future<String> _getCurrentLocation() async {
    // Implement location fetching logic here
    return "Sample Location";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Upload Media')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Pick Image'),
            ),
            if (_image != null) Image.asset(_image!.path),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
            ElevatedButton(
              onPressed: _uploadMedia,
              child: Text('Upload'),
            ),
          ],
        ),
      ),
    );
  }
}