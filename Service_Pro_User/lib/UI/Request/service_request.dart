import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provider/provider.dart';
import 'package:service_pro_user/Provider/login_signup_provider/login_logout_provider.dart';
import 'package:service_pro_user/Provider/serviceRequest_provider/get_service_request_provider.dart';
import 'package:service_pro_user/Provider/serviceRequest_provider/serviceRequest_provider.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:service_pro_user/UI/Navigator/navigator_scaffold.dart';
import 'package:service_pro_user/UI/Request/booking.dart';
import 'package:shimmer/shimmer.dart';

class ServiceRequest extends StatefulWidget {
  final dynamic serviceData;
  final String providerId;
  final String providerName;
  final String providerProfile;
  final String providerAddress;
  final String providerPhone;
  final String providerEmail;
  final String providerServiceTotal;
  final String providerServiceCompleted;

  const ServiceRequest({
    super.key,
    required this.serviceData,
    required this.providerId,
    required this.providerName,
    required this.providerProfile,
    required this.providerAddress,
    required this.providerPhone,
    required this.providerEmail,
    required this.providerServiceTotal,
    required this.providerServiceCompleted,
  });

  @override
  State<ServiceRequest> createState() => _ServiceRequestState();
}

class _ServiceRequestState extends State<ServiceRequest> {
  DateTime? selectedDateTime;
  PickedFile? _imageFile;
  final ImagePicker _picker = ImagePicker();
  List<dynamic> existingRequests = [];

  @override
  void initState() {
    super.initState();
    _fetchExistingRequests();
  }

  Future<void> _fetchExistingRequests() async {
    final token =
        Provider.of<LoginLogoutProvider>(context, listen: false).token;
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    final userId = decodedToken['id'];
    final requests =
        await Provider.of<GetServiceRequest>(context, listen: false)
            .getServiceRequest(context);
    setState(() {
      existingRequests =
          requests.where((item) => item['UserId'] == userId).toList();
    });
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        pickedFile.path,
        pickedFile.path + '_compressed.jpg',
        quality: 50,
      );

      setState(() {
        _imageFile =
            compressedFile != null ? PickedFile(compressedFile.path) : null;
      });
    }
  }

  Future<void> _submitServiceRequest() async {
    final token =
        Provider.of<LoginLogoutProvider>(context, listen: false).token;
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    final userId = decodedToken['id'];

    final matchedRequest = existingRequests.firstWhere(
      (item) =>
          item['ServiceId'] == widget.serviceData['_id'] &&
          item['ProviderId'] == widget.providerId,
      orElse: () => null,
    );

    if (_imageFile == null || selectedDateTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image and date/time.')),
      );
      return;
    }

    if (matchedRequest != null && matchedRequest['Status'] == 'pending') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            backgroundColor: Colors.orange,
            content: Text('Your request is still pending.')),
      );
      return;
    }

    final imageUploadUrl =
        await Provider.of<ServiceRequestProvider>(context, listen: false)
            .uploadImage(context, _imageFile!.path);

    if (imageUploadUrl != null) {
      if (matchedRequest != null && matchedRequest['Status'] == 'rejected') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              backgroundColor: Colors.red,
              content: Text('Your request was rejected.')),
        );
        return;
      } else {
        Provider.of<ServiceRequestProvider>(context, listen: false)
            .sendServiceRequest(
              context,
              userId,
              widget.providerId,
              widget.serviceData['_id'],
              imageUploadUrl,
              selectedDateTime.toString(),
            )
            .then(
              (value) => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => NavigatorScaffold(initialIndex: 2),
                ),
              ),
            );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text('Service request submitted successfully.'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to upload image.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final serviceImage = (widget.serviceData['Image'] != null)
        ? widget.serviceData['Image'].toString()
        : 'https://th.bing.com/th/id/OIG2.ebtM9kzsN5eDgtsdGFVB?w=1024&h=1024&rs=1&pid=ImgDetMain';

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: serviceImage,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        height: 250,
                        width: double.infinity,
                        color: Colors.white,
                      ),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: const Color(0xFF43CBAC).withOpacity(0.75),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.serviceData['Name'],
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  widget.serviceData['Description'],
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: const Color(0xFF43CBAC).withOpacity(0.75),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Provider Details',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Name: ${widget.providerName}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Completed Services: ${widget.providerServiceCompleted}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (_imageFile != null)
                    Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                          image: FileImage(File(_imageFile!.path)),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(0xFF43CBAC)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    icon: const Icon(
                      Icons.image,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Select Image',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: const Icon(Icons.camera_alt),
                              title: const Text('Camera'),
                              onTap: () {
                                Navigator.pop(context);
                                _pickImage(ImageSource.camera);
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.photo_library),
                              title: const Text('Gallery'),
                              onTap: () {
                                Navigator.pop(context);
                                _pickImage(ImageSource.gallery);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _selectDateTime(context),
                    child: Text(
                      selectedDateTime == null
                          ? 'Select Date & Time'
                          : DateFormat('yyyy-MM-dd HH:mm')
                              .format(selectedDateTime!),
                    ),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0xFF43CBAC),
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 30,
                      ),
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _submitServiceRequest,
                    child: const Text('Submit'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 30,
                      ),
                      backgroundColor: const Color(0xFF43CBAC),
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
