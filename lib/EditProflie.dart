import 'package:flutter/material.dart';
import 'package:appiot/model/load_data.dart';
class EditProfileForm extends StatefulWidget {
  final User user;
  final VoidCallback reloadUserDataCallback;
  const EditProfileForm({Key? key, required this.user, required this.reloadUserDataCallback}) : super(key: key);

  @override
  _EditProfileFormState createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> {
  late TextEditingController _usernameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.user.username);
    _phoneController = TextEditingController(text: widget.user.phone);
    _emailController = TextEditingController(text: widget.user.email);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Profile'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _usernameController,
            decoration: InputDecoration(labelText: 'Username'),
          ),
          TextField(
            controller: _phoneController,
            decoration: InputDecoration(labelText: 'Phone'),
          ),
          TextField(
            controller: _emailController,
            decoration: InputDecoration(labelText: 'Email'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            updateUserInformation();
            Navigator.pop(context);
            widget.reloadUserDataCallback();
          },
          child: Text('Save'),
        ),
      ],
    );
  }

  Future<void> updateUserInformation() async {
    await widget.user.updateInformation(
      _usernameController.text,
      _phoneController.text,
      _emailController.text,
    );

    
    
  }

}
