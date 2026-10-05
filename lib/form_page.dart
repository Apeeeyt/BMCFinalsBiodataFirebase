import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final TextEditingController lastController = TextEditingController();
  final TextEditingController firstController = TextEditingController();
  final TextEditingController middleController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController birthdateController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nationalityController = TextEditingController();
  final TextEditingController religionController = TextEditingController();
  final TextEditingController civilStatusController = TextEditingController();

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // List of all controllers for easy validation / clearing
  late final List<TextEditingController> _allControllers = [
    lastController,
    firstController,
    middleController,
    addressController,
    ageController,
    birthdateController,
    genderController,
    contactController,
    emailController,
    nationalityController,
    religionController,
    civilStatusController,
  ];

  Future<void> saveData() async {
    // Validate that all fields are filled
    for (final controller in _allControllers) {
      if (controller.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill in all fields')),
        );
        return;
      }
    }

    await firestore.collection('students').add({
      'surname': lastController.text.trim(),
      'firstName': firstController.text.trim(),
      'middleName': middleController.text.trim(),
      'address': addressController.text.trim(),
      'age': ageController.text.trim(),
      'birthdate': birthdateController.text.trim(),
      'gender': genderController.text.trim(),
      'contactNumber': contactController.text.trim(),
      'email': emailController.text.trim(),
      'nationality': nationalityController.text.trim(),
      'religion': religionController.text.trim(),
      'civilStatus': civilStatusController.text.trim(),
      'createdAt': FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Data saved successfully')),
    );

    for (final controller in _allControllers) {
      controller.clear();
    }
  }

  @override
  void dispose() {
    for (final controller in _allControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Form'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildField(controller: lastController, label: 'Surname:'),
            _buildField(controller: firstController, label: 'First Name:'),
            _buildField(controller: middleController, label: 'Middle Name:'),
            _buildField(controller: addressController, label: 'Address:'),
            _buildField(
              controller: ageController,
              label: 'Age:',
              keyboardType: TextInputType.number,
            ),
            _buildField(
              controller: birthdateController,
              label: 'Birthdate:',
            ),
            _buildField(controller: genderController, label: 'Gender:'),
            _buildField(
              controller: contactController,
              label: 'Contact Number:',
              keyboardType: TextInputType.phone,
            ),
            _buildField(
              controller: emailController,
              label: 'Email Address:',
              keyboardType: TextInputType.emailAddress,
            ),
            _buildField(
              controller: nationalityController,
              label: 'Nationality:',
            ),
            _buildField(controller: religionController, label: 'Religion:'),
            _buildField(
              controller: civilStatusController,
              label: 'Civil Status:',
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: saveData,
              child: const Text('Save to Firebase'),
            ),
          ],
        ),
      ),
    );
  }
}