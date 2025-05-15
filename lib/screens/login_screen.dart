import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:yellow_nav/common/animation/loading_dots.dart';
import 'package:yellow_nav/common/colors.dart';
import 'package:yellow_nav/extensions/context_extension.dart';
import 'package:yellow_nav/extensions/navigation_extensions.dart';
import 'package:yellow_nav/providers/auth_provider.dart';
import 'package:yellow_nav/screens/homescreen.dart';
import 'package:yellow_nav/screens/homescreen2.dart';
import 'package:yellow_nav/screens/sign_up.dart';
import 'package:yellow_nav/widgets/custom_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);

    final success = await authProvider.login(
      emailController.text.trim(),
      passwordController.text.trim(),
    );

    if (success && authProvider.user != null) {
      // Navigate to home screen only if login was successful
      context.pushTo(HomeScreen());
    } else {
      // Show error message if login failed
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.errorMessage ?? 'Login failed'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  bool _passwordVisible = false;
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthenticationProvider>(context);
    return Scaffold(
        backgroundColor: AppColors.white,
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.scaleWidth(0.041),
          ),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: context.scaleHeight(0.142),
                  ),
                  Center(
                    child: Text(
                      'Login',
                      style: Theme.of(context)
                          .textTheme
                          .displayLarge!
                          .copyWith(color: AppColors.darkskyBlue1E2),
                    ),
                  ),
                  SizedBox(
                    height: context.scaleHeight(0.052),
                  ),
                  Text(
                    'E-mail',
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  SizedBox(
                    height: context.scaleHeight(0.007),
                  ),
                  TextFormField(
                    controller: emailController,
                    style: Theme.of(context)
                        .textTheme
                        .displayMedium!
                        .copyWith(color: AppColors.darkskyBlue1E2),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'E-mail is required';
                      }
                      return null;
                    },
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.grey8F0,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(8)),
                      hintText: 'Enter your email',
                      hintStyle: GoogleFonts.gabarito(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.grey94A),
                    ),
                  ),
                  SizedBox(
                    height: context.scaleHeight(0.0142),
                  ),
                  Text(
                    'Password',
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  SizedBox(
                    height: context.scaleHeight(0.007),
                  ),
                  TextFormField(
                    controller: passwordController,
                    style: Theme.of(context)
                        .textTheme
                        .displayMedium!
                        .copyWith(color: AppColors.darkskyBlue1E2),
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: !_passwordVisible,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Password is required';
                      }
                      return null;
                    },
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.grey8F0,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(8)),
                      hintText: 'Enter your Password',
                      hintStyle: GoogleFonts.gabarito(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.grey94A),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _passwordVisible
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: context.scaleHeight(0.0142),
                  ),
                  Text(
                    'Forgot Password?',
                    textAlign: TextAlign.end,
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                          color: AppColors.blue3C9,
                        ),
                  ),
                  SizedBox(
                    height: context.scaleHeight(0.0592),
                  ),
                  CustomButton(
                    width: double.infinity,
                    onPressed: authProvider.isLoading
                        ? null
                        : () async {
                            if (_formKey.currentState!.validate()) {
                              final success = await authProvider.login(
                                emailController.text.trim(),
                                passwordController.text.trim(),
                              );

                              if (success && authProvider.user != null) {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (_) => HomeScreen()),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      authProvider.errorMessage ??
                                          'Login failed',
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          },
                    child: authProvider.isLoading
                        ? LoadingDots()
                        : Text(
                            'Log in',
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(color: AppColors.white),
                          ),
                  ),
                  SizedBox(
                    height: context.scaleHeight(0.24289),
                  ),
                  SizedBox(
                    height: context.scaleHeight(0.026),
                  ),
                  GestureDetector(
                    onTap: authProvider.isLoading
                        ? null
                        : () async {
                            authProvider.setLoading(true);
                            await authProvider.signInWithGoogle();

                            if (authProvider.user != null) {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (_) => HomeScreen()),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    authProvider.errorMessage ?? 'Login failed',
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                            authProvider.setLoading(false);
                          },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: context.scaleWidth(0.258974)),
                      width: double.infinity,
                      height: context.scaleHeight(0.0639),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          border:
                              Border.all(color: AppColors.greyE2E, width: 2)),
                      child: Row(
                        children: [
                          Text(
                            'or login with',
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(
                                    color: AppColors.darkskyBlue1E2,
                                    fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            width: context.scaleWidth(0.041),
                          ),
                          Image.asset('assets/png_images/google.png'),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: context.scaleHeight(0.018957),
                  ),
                  Center(
                    child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(children: <TextSpan>[
                          TextSpan(
                              text: 'Don\'t have an account?  ',
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium!
                                  .copyWith(color: AppColors.grey475)),
                          TextSpan(
                            text: 'Sign up',
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(
                                    color: AppColors
                                        .blue3C9), // Style for "Terms of Service"
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => context.pushTo(SignUpScreen()),
                          ),
                        ])),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
