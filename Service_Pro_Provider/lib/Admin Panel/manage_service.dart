import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:service_pro_provider/Provider/service_provider/put_service_provider.dart';
import 'package:service_pro_provider/Provider/service_provider/service_provider.dart';
import 'dart:io';

class ManageService extends StatefulWidget {
  const ManageService({super.key});

  @override
  State<ManageService> createState() => _ManageServiceState();
}

class _ManageServiceState extends State<ManageService> {
  final ImagePicker _picker = ImagePicker();
  String? _compressedImagePath;
  String? _compressedImageUrl;

  Future<void> _pickAndCompressImage() async {
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
        setState(() {
          _compressedImagePath = compressedFile.path;
        });
        print('Compressed image path: $_compressedImagePath');
      } else {
        print('Image compression failed');
      }
    }
  }

  Future<void> _uploadImage(BuildContext context) async {
    if (_compressedImagePath != null) {
      final imageUrl = await Provider.of<UpdateService>(context, listen: false)
          .uploadServiceImage(context, _compressedImagePath!);
      if (imageUrl != null) {
        setState(() {
          _compressedImageUrl = imageUrl;
          print('Compressed and uploaded image URL: $_compressedImageUrl');
        });
      } else {
        print('Image upload failed');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            _buildAddCategoryButton(context),
            const SizedBox(height: 10),
            _buildCategoryList(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAddCategoryButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.blueAccent,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Flexible(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Add Services',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ),
          IconButton(
            onPressed: () async {
              setState(() {
                _compressedImageUrl = null;
              });
              await _showAddCategoryDialog(context);
            },
            icon: const Icon(Icons.add, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Future<void> _showAddCategoryDialog(BuildContext context) async {
    final _formKey = GlobalKey<FormState>();
    String name = '';
    String description = '';
    String price = '';
    String duration = '';

    return await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: const Text('Add Service'),
            content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      name = value!;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Description'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      description = value!;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Price'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a price';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      price = value!;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Duration'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a duration';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      duration = value!;
                    },
                  ),
                  if (_compressedImagePath != null)
                    Image.file(
                      File(_compressedImagePath!),
                      width: 100,
                      height: 100,
                    ),
                  const SizedBox(height: 10),
                  if (_compressedImageUrl != null)
                    Image.network(
                      _compressedImageUrl!,
                      width: 100,
                      height: 100,
                      errorBuilder: (context, error, stackTrace) =>
                          Lottie.asset('assets/lotties_animation/error.json'),
                    ),
                  ElevatedButton(
                    onPressed: () async {
                      await _pickAndCompressImage();
                      setState(() {});
                    },
                    child: const Text('Pick Image'),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    _compressedImageUrl = null;
                  });
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    await _uploadImage(context);

                    Provider.of<ServiceProvider>(context, listen: false)
                        .addService(context, name, description,
                            _compressedImageUrl ?? '', price, duration);
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          );
        });
      },
    );
  }

  Widget _buildCategoryList(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<ServiceProvider>(context).getServices(),
      builder: (context, snapshot) {
        final data =
            Provider.of<ServiceProvider>(context, listen: false).service;
        return Expanded(
          child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final categoryItem = data[index];
              Color activeColor = categoryItem['Active'] == false
                  ? Colors.amber.withOpacity(0.5)
                  : Colors.blue.withOpacity(0.5);

              String image = categoryItem['Image'].toString();
              image = image.replaceFirst('localhost', '20.52.185.247');
              return Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Container(
                  color: activeColor,
                  child: ListTile(
                    leading: Container(
                      width: 50,
                      child: Image.network(
                        image,
                        errorBuilder: (context, error, stackTrace) =>
                            Lottie.asset('assets/lotties_animation/error.json'),
                      ),
                    ),
                    title: Text(categoryItem['Name']),
                    subtitle: Text(categoryItem['Description']),
                    trailing: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () async {
                            setState(() {
                              _compressedImageUrl = null;
                            });
                            await _showEditCategoryDialog(
                                context, categoryItem);
                          },
                          icon:
                              const Icon(Icons.edit, color: Colors.blueAccent),
                        ),
                        IconButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Delete Service'),
                                    content: const Text(
                                        'Are you sure you want to delete this service?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          Provider.of<UpdateService>(context,
                                                  listen: false)
                                              .deleteService(
                                                  context, categoryItem['_id']);
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Delete'),
                                      ),
                                    ],
                                  );
                                });
                          },
                          icon:
                              const Icon(Icons.delete, color: Colors.redAccent),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _showEditCategoryDialog(
      BuildContext context, dynamic categoryItem) async {
    final _formKey = GlobalKey<FormState>();
    String updatedName = categoryItem['Name'];
    String updatedDescription = categoryItem['Description'];
    String? imageUrl;

    return await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: const Text('Edit Service'),
            content: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      initialValue: categoryItem['Name'],
                      decoration: const InputDecoration(labelText: 'Name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a name';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        updatedName = value!;
                      },
                    ),
                    TextFormField(
                      initialValue: categoryItem['Description'],
                      decoration: const InputDecoration(labelText: 'Description'),
                      maxLines: null, // Allows the input to expand vertically
                      keyboardType: TextInputType.multiline,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a description';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        updatedDescription = value!;
                      },
                    ),
                    TextFormField(
                      initialValue: categoryItem['Price'].toString(),
                      decoration: const InputDecoration(labelText: 'Price'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a description';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        updatedDescription = value!;
                      },
                    ),
                    TextFormField(
                      initialValue: categoryItem['Duration'],
                      decoration: const InputDecoration(labelText: 'Duration'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a description';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        updatedDescription = value!;
                      },
                    ),
                    const SizedBox(height: 10),
                    if (_compressedImagePath != null)
                      Image.file(
                        File(_compressedImagePath!),
                        width: 100,
                        height: 100,
                      ),
                    ElevatedButton(
                      onPressed: () async {
                        await _pickAndCompressImage();
                        setState(() {});
                      },
                      child: const Text('Pick Image'),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    _compressedImageUrl = null;
                  });
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    await _uploadImage(context);
                    imageUrl = _compressedImageUrl ?? categoryItem['Image'];

                    bool isSuccess =
                        await Provider.of<UpdateService>(context, listen: false)
                            .updateService(context, categoryItem['_id'],
                                updatedName, imageUrl!, updatedDescription);

                    if (isSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Service updated successfully!'),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Service update failed.'),
                        ),
                      );
                    }

                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Update'),
              ),
            ],
          );
        });
      },
    );
  }
}
