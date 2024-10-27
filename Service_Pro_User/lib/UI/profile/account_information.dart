import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:service_pro_user/Provider/user_provider/put_user_provider.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:service_pro_user/UI/Navigator/navigator_scaffold.dart';
import 'package:service_pro_user/UI/profile/profile_page.dart';

class AccountInformationPage extends StatefulWidget {
  final String name;
  final String email;
  final String phone;
  final String address;
  final String profile;

  const AccountInformationPage(
      {Key? key,
      required this.name,
      required this.email,
      required this.phone,
      required this.address,
      required this.profile})
      : super(key: key);

  @override
  _AccountInformationPageState createState() => _AccountInformationPageState();
}

class _AccountInformationPageState extends State<AccountInformationPage> {
  bool _isDataChanged = false;
  final Color primaryColor = const Color(0xFF43cbac);
  final Color secondaryColor = const Color(0xFFf5f5f5);
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  String? _profileImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _profileImage = widget.profile;
    _nameController = TextEditingController(text: widget.name);
    _emailController = TextEditingController(text: widget.email);
    _phoneController = TextEditingController(text: widget.phone.toString());
    _addressController = TextEditingController(text: widget.address);
    _nameController.addListener(
        _onDataChanged); //name controller ma kei change vayo vani receive garxa
    _emailController.addListener(_onDataChanged);
    _phoneController.addListener(_onDataChanged);
    _addressController.addListener(_onDataChanged);
  }

  @override
  void dispose() {
    _nameController.removeListener(_onDataChanged);
    _emailController.removeListener(_onDataChanged);
    _phoneController.removeListener(_onDataChanged);
    _addressController.removeListener(_onDataChanged);
    super.dispose();
  }

  void _onDataChanged() {
    setState(() {
      _isDataChanged =
          true; //data change vayo vani true hunxa abi true vasei data update gardinxa
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final directory = await getTemporaryDirectory();
      final targetPath = path.join(directory.path,
          '${DateTime.now().millisecondsSinceEpoch}_compressed.jpg');

      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        pickedFile.path,
        targetPath,
      );

      if (compressedFile != null) {
        final imageUrl =
            await Provider.of<UpdateUserDetails>(context, listen: false)
                .uploadProfileImage(context, compressedFile.path);
        if (imageUrl != null) {
          setState(() {
            _profileImage = imageUrl; // Update the profile image URL
            _isDataChanged = true;
          });
        } else {
          print('Image upload failed');
        }
      } else {
        print('Image compression failed');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Information',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: primaryColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20),
              Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: primaryColor,
                    backgroundImage: _profileImage != null &&
                            _profileImage!.startsWith('http')
                        ? NetworkImage(_profileImage!)
                        : FileImage(File(_profileImage!)) as ImageProvider,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: IconButton(
                      icon: Icon(Icons.edit, color: primaryColor),
                      onPressed: _pickImage,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              _buildEditableField(
                leadingIcon: Icons.person,
                controller: _nameController,
                title: widget.name,
              ),
              _buildEditableField(
                leadingIcon: Icons.email,
                controller: _emailController,
                title: widget.email,
              ),
              _buildEditableField(
                leadingIcon: Icons.phone,
                controller: _phoneController,
                title: widget.phone.toString(),
              ),
              _buildEditableField(
                leadingIcon: Icons.home,
                controller: _addressController,
                title: widget.address,
              ),
              const SizedBox(height: 30),
              if (_isDataChanged)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () async {
                    if (_nameController.text.isEmpty ||
                        _addressController.text.isEmpty ||
                        _phoneController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please fill in all fields'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }
                    bool isUpdated = await Provider.of<UpdateUserDetails>(
                            context,
                            listen: false)
                        .updateUserDetails(
                      context,
                      _nameController.text,
                      _addressController.text,
                      _phoneController.text,
                      _profileImage ?? '',
                    );
                    if (isUpdated) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NavigatorScaffold(
                                    initialIndex: 3,
                                  )));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('User updated successfully'),
                          backgroundColor: Colors.green,
                        ),
                      );
                      setState(() {
                        _isDataChanged = false;
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Error updating user'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: const Text('Save', style: TextStyle(fontSize: 16)),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditableField({
    required IconData leadingIcon,
    required TextEditingController controller,
    required String title,
  }) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: Icon(leadingIcon, color: primaryColor),
        title: TextField(
          controller: controller,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: title,
          ),
        ),
      ),
    );
  }
}
