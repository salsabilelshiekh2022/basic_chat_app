import 'package:chat/components/custom_text_field.dart';
import 'package:chat/pages/chat_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../components/custom_button.dart';
import '../constants.dart';
import '../helper/show_snack_bar.dart';

class RegisterPage extends StatefulWidget {
  static String id = "registerPage";

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String? email;

  String? password;

  bool isLoading = false;

  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Form(
            key: formKey,
            child: ListView(
              children: [
                Column(children: [
                  const SizedBox(
                    height: 100,
                  ),
                  Image.asset(
                    'assets/images/scholar.png',
                    height: 100,
                  ),
                  const Text(
                    'Scholar Chat',
                    style: TextStyle(
                      fontSize: 32,
                      fontFamily: 'Pacifico',
                      color: Colors.white,
                    ),
                  ),
                  Row(
                    children: const [
                      Text(
                        'Register',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                    onChange: (data) {
                      email = data;
                    },
                    hintText: 'Email',
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextField(
                    onChange: (data) {
                      password = data;
                    },
                    obscure: true,
                    hintText: 'Password',
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  CustomButton(
                    onTap: () async {
                      if (formKey.currentState!.validate()) {
                        setState(() {
                          isLoading = true;
                        });
                        try {
                          await registerUser();
                          Navigator.pushNamed(context, ChatPage.id,
                              arguments: email);
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'weak-password') {
                            showSnackBar(context, 'weak password');
                          } else if (e.code == 'email-already-in-use') {
                            showSnackBar(
                              context,
                              'The account already exists for that email.',
                            );
                          }
                        } catch (e) {
                          showSnackBar(context, 'there was an error ');
                        }
                        setState(() {
                          isLoading = false;
                        });
                      } else {
                        showSnackBar(context, 'register failed');
                      }
                    },
                    buttonText: 'REGISTER',
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'already have an account?',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          '  SignIn',
                          style: TextStyle(
                            color: kSecondaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> registerUser() async {
    UserCredential user = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email!, password: password!);
  }
}
