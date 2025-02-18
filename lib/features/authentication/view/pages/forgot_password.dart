import 'package:flutter/material.dart';
// import 'package:todo_list_app/features/authentication/model/register_modal.dart';
import 'package:todo_list_app/features/authentication/view/pages/register.dart';
import 'package:todo_list_app/features/authentication/view/widgets/custom_text.dart';
// import 'package:todo_list_app/features/authentication/viewmodel/forgot_controller.dart';

class Forgot_Password extends StatefulWidget {
  const Forgot_Password({super.key});

  @override
  State<Forgot_Password> createState() => _Forgot_PasswordState();
}

class _Forgot_PasswordState extends State<Forgot_Password> {
  final _emailcontroller = TextEditingController();
  // final user_forgot_controller  _userforgetcontroller = user_forgot_controller();
  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formkey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 120, left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomText(text: 'Forgot Password', 
                          size: 24, 
                          color: Colors.black,
                          weight: FontWeight.w600,
                          textAlign: TextAlign.center,
                          ),
          
                const SizedBox(height: 30),
                 TextFormField(
                  controller: _emailcontroller,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(
                      color: Colors.grey, 
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue, 
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey, 
                      )
                    )
                  ),
                  validator: (value) {
                    if(value == null || value.isEmpty){
                      return 'Feild cannot be empty';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.center,
                  child: CustomText(text: 'Enter the email address associated with your account and we will send you a link to reset your password', 
                          size: 14, 
                          color: Colors.grey,
                          weight: FontWeight.w600,
                          textAlign: TextAlign.center,
                          ), 
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Color.fromARGB(255, 77, 32, 238)),
                    ),
                    onPressed: () {
                      // if(_formkey.currentState!.validate()){
                      //   if(_formkey.currentState!.validate()){
                      //     userRegisterModel userforgot = userRegisterModel(
                      //       email: _emailcontroller.text
                      //     );
                      //     // _userforgetcontroller.userpassrest(userforgot, context);
                      //   }
                      // }
                      Navigator.pop(context);
                    },
                    child: const Text('CONTINUE', style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Don\'t have an account?'),
                    TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Register()));
                      },
                      child: const Text('Register',style: TextStyle(
                        fontWeight: FontWeight.bold
                      ),),
                    ),
                  ],
                )
          
              ],
            ),
          ),
        ),
      ),
    );
  }
}