import 'package:flutter/material.dart';
import '../../../../core/constants/size_config.dart';

enum LoginType { user, admin }

class LoginForm extends StatefulWidget {
  const LoginForm({
    super.key,
    required this.loginType,
    required this.onSubmit,            // now required
    this.emailController,
    this.passwordController,
    this.buttonText = 'Login',
    this.showForgotButton = true,
  });

  final LoginType loginType;
  final TextEditingController? emailController;
  final TextEditingController? passwordController;

  /// REQUIRED callback — parent decides what to do (navigate, API call, etc.)
  final Future<void> Function(String emailOrMobile, String password) onSubmit;

  final String buttonText;
  final bool showForgotButton;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailCtrl;
  late final TextEditingController _passwordCtrl;

  bool _obscure = true;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _emailCtrl = widget.emailController ?? TextEditingController();
    _passwordCtrl = widget.passwordController ?? TextEditingController();
  }

  @override
  void dispose() {
    if (widget.emailController == null) _emailCtrl.dispose();
    if (widget.passwordController == null) _passwordCtrl.dispose();
    super.dispose();
  }

  String? _validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'Please enter email';
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(v.trim())) return 'Enter a valid email';
    return null;
  }

  String? _validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'Enter password';
    if (v.length < 6) return 'Password must be at least 6 chars';
    return null;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    final input = _emailCtrl.text.trim();
    final password = _passwordCtrl.text;

    try {
      // Parent handles API, navigation etc.
      await widget.onSubmit.call(input, password);
    } catch (e) {
      // Optionally show error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: ${e.toString()}')),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Column(
            children: [
              SizedBox(
                width: SizeConfig.w(80),
                child: TextFormField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: "Email",
                    hintText: "Enter email",
                    prefixIcon: const Icon(Icons.email),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xffE4E7EB)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.deepPurple),
                    ),
                  ),
                  validator: _validateEmail,
                ),
              ),

              const SizedBox(height: 15),

              SizedBox(
                width: SizeConfig.w(80),
                child: TextFormField(
                  controller: _passwordCtrl,
                  obscureText: _obscure,
                  decoration: InputDecoration(
                    labelText: "Password",
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xffE4E7EB)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.deepPurple),
                    ),
                  ),
                  validator: _validatePassword,
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                height: SizeConfig.h(5),
                width: SizeConfig.w(80),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    backgroundColor: Color(0xFF00695C),
                  ),
                  onPressed: _isSubmitting ? null : _submit,
                  child: _isSubmitting
                      ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : Text(widget.buttonText, style: const TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
