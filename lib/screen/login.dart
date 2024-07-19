import 'package:estif_challange/controller/global.dart';
import 'package:estif_challange/main.dart';
import 'package:estif_challange/screen/conversation.dart';
import 'package:estif_challange/utils/auth_textfield.dart';
import 'package:estif_challange/utils/exception.dart';
import 'package:estif_challange/utils/toast.dart';
import 'package:estif_challange/utils/validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: ,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.15),
              const Text("Mereb Tech Challange",
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.indigo,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              Center(
                child: CustomTextFormFieldWidget(
                  controller: _usernameController,
                  hintText: "Username",
                  validator: (p0) => CustomFormFieldValidators()
                      .emptyFieldeValidator(p0, "username"),
                ),
              ),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    FocusScope.of(context).unfocus();
                    try {
                      await context
                          .read<GlobalProvider>()
                          .authenticate(_usernameController.text)
                          .then((_) => navigationKey.currentState!.push(
                              CupertinoPageRoute(
                                  builder: (context) =>
                                      const ConversationScreen())));
                    } on CustomException catch (e) {
                      // ignore: use_build_context_synchronously
                      customResponse(context: context, message: e.toString());
                    } catch (e) {
                      // ignore: use_build_context_synchronously
                      customResponse(context: context, message: e.toString());
                    }
                  }
                },
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width * .75,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.indigo,
                      borderRadius: BorderRadius.circular(16.0)),
                  child: const Text("Continue",
                      style: TextStyle(color: Colors.white, fontSize: 17)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
