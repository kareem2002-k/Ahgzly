import 'package:flutter/material.dart';
import 'package:ahgzly/services/FirebaseAuth.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  bool _isPasswordVisible = false;
  final AuthenticationService _auth = AuthenticationService();

  Future<void> _signUp() async {
    final String? error = await _auth.signUp(
      _emailController.text,
      _passwordController.text,
      _nameController.text,
      _phoneController.text,
      _ageController.text,
    );

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
        ),
      );
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    const Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                buildTextField(
                    controller: _nameController, labelText: "Full Name"),
                const SizedBox(height: 16),
                buildTextField(
                  controller: _emailController,
                  labelText: 'Email',
                ),
                const SizedBox(height: 16),
                buildPasswordField(
                  controller: _passwordController,
                  labelText: 'Password',
                  isPasswordVisible: _isPasswordVisible,
                  togglePasswordVisibility: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
                const SizedBox(height: 16),
                buildTextField(
                  controller: _confirmPasswordController,
                  labelText: 'Confirm Password',
                  obscureText: true,
                ),
                const SizedBox(height: 16),
                buildTextField(
                  controller: _phoneController,
                  labelText: 'Phone',
                ),
                const SizedBox(height: 16),
                buildTextField(
                  controller: _ageController,
                  labelText: 'Age',
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    // Handle Sign Up
                    _signUp();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    minimumSize: const Size(400, 60), // Increase width here
                  ),
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    // Navigate to the login page
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Already have an account? Sign in',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color.fromARGB(255, 129, 125, 125),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String labelText,
    bool obscureText = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(color: Color.fromARGB(255, 24, 24, 24)),
          enabledBorder: OutlineInputBorder(
            borderSide:
                const BorderSide(color: Color.fromARGB(255, 199, 198, 198)),
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
                const BorderSide(color: Color.fromARGB(255, 88, 224, 76)),
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }

  Widget buildPasswordField({
    required TextEditingController controller,
    required String labelText,
    required bool isPasswordVisible,
    required Function togglePasswordVisibility,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: TextFormField(
        controller: controller,
        obscureText: !isPasswordVisible,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(color: Colors.black),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(10.0),
          ),
          suffixIcon: IconButton(
            icon: Icon(
              isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.black,
            ),
            onPressed: () {
              togglePasswordVisibility();
            },
          ),
        ),
      ),
    );
  }
}
