import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:yellow_nav/common/animation/loading_dots.dart';
import 'package:yellow_nav/common/colors.dart';
import 'package:yellow_nav/extensions/context_extension.dart';
import 'package:yellow_nav/extensions/navigation_extensions.dart';
import 'package:yellow_nav/providers/auth_provider.dart';
import 'package:yellow_nav/screens/homescreen.dart';
import 'package:yellow_nav/screens/homescreen2.dart';
import 'package:yellow_nav/screens/login_screen.dart';
import 'package:yellow_nav/widgets/custom_button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _passwordVisible = false;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();
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
                  height: context.scaleHeight(0.0829),
                ),
                GestureDetector(
                  onTap: () => context.pushTo(LoginScreen()),
                  child: Container(
                    height: context.scaleHeight(0.0379),
                    width: context.scaleWidth(0.08205),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: AppColors.greyF1F),
                    child: Icon(
                      Icons.arrow_back,
                      size: 20,
                    ),
                  ),
                ),
                SizedBox(
                  height: context.scaleHeight(0.0213),
                ),
                Center(
                  child: Text(
                    'Register',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                ),
                SizedBox(
                  height: context.scaleHeight(0.050947),
                ),
                Text(
                  'Full Name',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                SizedBox(
                  height: context.scaleHeight(0.007),
                ),
                TextFormField(
                  controller: nameController,
                  style: Theme.of(context)
                      .textTheme
                      .displayMedium!
                      .copyWith(color: AppColors.darkskyBlue1E2),
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Full name is required';
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
                    hintText: 'Enter your Full name',
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
                  keyboardType: TextInputType.emailAddress,
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
                    helperText: 'must contain 8 char.', // Add this line
                    helperStyle: GoogleFonts.gabarito(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.grey647,
                    ),
                  ),
                ),
                SizedBox(
                  height: context.scaleHeight(0.0142),
                ),
                // Text(
                //   'Confirm Password',
                //   style: Theme.of(context).textTheme.displayMedium,
                // ),
                // SizedBox(
                //   height: context.scaleHeight(0.007),
                // ),
                // TextFormField(
                //    style: Theme.of(context)
                //         .textTheme
                //         .displayMedium!
                //         .copyWith(color: AppColors.darkskyBlue1E2),
                //   keyboardType: TextInputType.emailAddress,
                //   validator: (value) {
                //     if (value == null || value.trim().isEmpty) {
                //       return 'Password is required';
                //     }
                //     return null;
                //   },
                //   onChanged: (_) => setState(() {}),
                //   decoration: InputDecoration(
                //     border: OutlineInputBorder(
                //         borderSide: BorderSide(
                //           color: AppColors.grey8F0,
                //           width: 1.5,
                //         ),
                //         borderRadius: BorderRadius.circular(8)),
                //     hintText: 'Confirm Password',
                //     hintStyle: GoogleFonts.gabarito(
                //         fontSize: 14,
                //         fontWeight: FontWeight.w400,
                //         color: AppColors.grey94A),
                //     suffixIcon: IconButton(
                //       icon: Icon(
                //         _passwordVisible
                //             ? Icons.visibility_outlined
                //             : Icons.visibility_off_outlined,
                //       ),
                //       onPressed: () {
                //         setState(() {
                //           _passwordVisible = !_passwordVisible;
                //         });
                //       },
                //     ),
                //   ),
                // ),
                SizedBox(
                  height: context.scaleHeight(0.15047),
                ),
                CustomButton(
                  width: double.infinity,
                  onPressed: authProvider.isLoading
                      ? null
                      : () async {
                            if (_formKey.currentState!.validate()) {
                              final success = await authProvider.signUp(
                                nameController.text.trim(),
                                emailController.text.trim(),
                                passwordController.text.trim(),
                              );

                              if (success && authProvider.user != null) {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (_) =>  HomeScreen()),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      authProvider.errorMessage ??
                                          'Sign Up failed',
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
                          'Create Account',
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(color: AppColors.white),
                        ),
                ),
                SizedBox(
                  height: context.scaleHeight(0.018957),
                ),
                Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: DefaultTextStyle.of(context)
                          .style
                          .copyWith(fontSize: 12), // Set default text style
                      children: <TextSpan>[
                        TextSpan(
                            text: 'By continuing, you agree to our ',
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(color: AppColors.grey475)),
                        TextSpan(
                          text: 'Terms of Service',
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(
                                  color: AppColors
                                      .blue3C9), // Style for "Terms of Service"
                          recognizer: TapGestureRecognizer()..onTap = () {},
                        ),
                        TextSpan(
                            text: ' and\n',
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(color: AppColors.grey475)),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(
                                  color: AppColors
                                      .blue3C9), // Style for "Privacy Policy"
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {}, // Make it tappable
                        ),
                      ],
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
}
