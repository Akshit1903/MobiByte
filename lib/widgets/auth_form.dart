import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class AuthForm extends StatefulWidget {
  bool isLogin;
  Function signInSignUpGoogle;
  Function signInSignUpEmail;

  AuthForm(
    this.isLogin,
    this.signInSignUpGoogle,
    this.signInSignUpEmail,
  );

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  var _userPassword = '';
  var _userEmail = '';
  var _userName = '';
  var _userPhoneNo = -1;

  final _formKey = GlobalKey<FormState>();

  String _passConfirm = "";

  var _hidePassword = true;

  @override
  Widget build(BuildContext context) {
    void _saveForm() {
      _formKey.currentState!.validate();
      FocusScope.of(context).unfocus();

      if (_formKey.currentState != null && _formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        widget.signInSignUpEmail(
          _userEmail,
          _userPassword,
          _userName,
          _userPhoneNo,
          context,
        );
      } else {}
    }

    return Column(
      children: [
        Container(
          child: SignInButton(
            Buttons.Google,
            text: widget.isLogin ? 'Log in with Google' : 'Sign up with Google',
            onPressed: () {
              widget.signInSignUpGoogle(context);
            },
          ),
          alignment: Alignment.center,
          width: double.infinity,
        ),
        const Divider(),
        const SizedBox(
          height: 0,
        ),
        Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                TextFormField(
                  key: const ValueKey('email'),
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  validator: (value) {
                    if (RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(value.toString())) {
                      return null;
                    }
                    return 'Invalid email entered, please check again!';
                  },
                  textCapitalization: TextCapitalization.none,
                  enableSuggestions: false,
                  onSaved: (value) {
                    _userEmail = value ?? '';
                  },
                  onEditingComplete: () {
                    FocusScope.of(context).nextFocus();
                  },
                  decoration: InputDecoration(
                    label: const Text('E-mail'),
                    hintText: 'Enter your E-mail',
                    labelStyle: TextStyle(
                      color: Theme.of(context).indicatorColor,
                    ),
                    // helperText: 'Please enter a valid Google email id',
                    prefixIcon: Icon(
                      Icons.person,
                      color: Theme.of(context).indicatorColor,
                    ),
                    // enabledBorder: OutlineInputBorder(
                    //   borderSide: const BorderSide(
                    //       color: Colors.grey,
                    //       width: 2.0,
                    //       style: BorderStyle.solid),
                    //   borderRadius: BorderRadius.circular(15),
                    // ),
                    // focusedBorder: const OutlineInputBorder(
                    //   borderSide: BorderSide(
                    //       color: Colors.grey,
                    //       width: 2.0,
                    //       style: BorderStyle.solid),
                    // ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  key: const ValueKey('password'),
                  onChanged: (val) {
                    _passConfirm = val;
                  },
                  obscureText: _hidePassword,
                  autocorrect: false,
                  textCapitalization: TextCapitalization.none,
                  validator: (value) {
                    if (value!.length >= 8) {
                      return null;
                    }
                    return 'Password too short, must be at least 8 characters!';
                  },
                  enableSuggestions: false,
                  onEditingComplete: () {
                    if (widget.isLogin) {
                      _saveForm();
                    } else {
                      FocusScope.of(context).nextFocus();
                    }
                  },
                  onSaved: (value) {
                    _userPassword = value ?? '';
                  },
                  decoration: InputDecoration(
                    labelStyle: TextStyle(
                      color: Theme.of(context).indicatorColor,
                    ),

                    label: const Text('Password'),
                    hintText: 'Enter your Password',
                    // helperText: 'Don\'t share your password with anyone',
                    prefixIcon: Icon(
                      Icons.password,
                      color: Theme.of(context).indicatorColor,
                    ),
                    // enabledBorder: OutlineInputBorder(
                    //   borderSide: const BorderSide(
                    //       color: Colors.grey,
                    //       width: 2.0,
                    //       style: BorderStyle.solid),
                    //   borderRadius: BorderRadius.circular(15),
                    // ),
                    // focusedBorder: const OutlineInputBorder(
                    //   borderSide: BorderSide(
                    //     color: Colors.grey,
                    //     width: 2.0,
                    //     style: BorderStyle.solid,
                    //   ),
                    // ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Checkbox(
                        value: !_hidePassword,
                        onChanged: (val) {
                          setState(() {
                            _hidePassword = !_hidePassword;
                          });
                        }),
                    const Text('Show password')
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                if (!widget.isLogin)
                  TextFormField(
                    key: const ValueKey('repeat-password'),
                    obscureText: _hidePassword,
                    autocorrect: false,
                    textCapitalization: TextCapitalization.none,
                    validator: (value) {
                      if (value == _passConfirm) {
                        return null;
                      }
                      return 'Passwords do not match!';
                    },
                    enableSuggestions: false,
                    onEditingComplete: () {
                      if (widget.isLogin) {
                        _saveForm();
                      } else {
                        FocusScope.of(context).nextFocus();
                      }
                    },
                    decoration: InputDecoration(
                      labelStyle: TextStyle(
                        color: Theme.of(context).indicatorColor,
                      ),

                      label: const Text('Repeat Password'),
                      hintText: 'Enter your Password',
                      // helperText: 'Don\'t share your password with anyone',
                      prefixIcon: Icon(
                        Icons.password,
                        color: Theme.of(context).indicatorColor,
                      ),
                      // enabledBorder: OutlineInputBorder(
                      //   borderSide: const BorderSide(
                      //       color: Colors.grey,
                      //       width: 2.0,
                      //       style: BorderStyle.solid),
                      //   borderRadius: BorderRadius.circular(15),
                      // ),
                      // focusedBorder: const OutlineInputBorder(
                      //   borderSide: BorderSide(
                      //     color: Colors.grey,
                      //     width: 2.0,
                      //     style: BorderStyle.solid,
                      //   ),
                      // ),
                    ),
                  ),
                const SizedBox(
                  height: 10,
                ),
                if (!widget.isLogin)
                  TextFormField(
                    key: const ValueKey('username'),
                    validator: (val) {
                      if (val != "") {
                        return null;
                      }
                      return "Name cannot be empty";
                    },
                    keyboardType: TextInputType.name,
                    autocorrect: false,
                    textCapitalization: TextCapitalization.words,
                    enableSuggestions: true,
                    onSaved: (value) {
                      _userName = value ?? '';
                    },
                    onEditingComplete: () {
                      print('onEditingComplete');
                      FocusScope.of(context).nextFocus();
                    },
                    onFieldSubmitted: (val) => print('onFieldSubmitted'),
                    decoration: InputDecoration(
                      labelStyle: TextStyle(
                        color: Theme.of(context).indicatorColor,
                      ),

                      label: const Text('Name'),
                      hintText: 'Enter your Name',
                      // helperText: 'What do we call you?',
                      prefixIcon: Icon(
                        Icons.account_circle,
                        color: Theme.of(context).indicatorColor,
                      ),
                      // enabledBorder: OutlineInputBorder(
                      //   borderSide: const BorderSide(
                      //       color: Colors.grey,
                      //       width: 2.0,
                      //       style: BorderStyle.solid),
                      //   borderRadius: BorderRadius.circular(15),
                      // ),
                      // focusedBorder: const OutlineInputBorder(
                      //   borderSide: BorderSide(
                      //       color: Colors.grey,
                      //       width: 2.0,
                      //       style: BorderStyle.solid),
                      // ),
                    ),
                  ),
                const SizedBox(
                  height: 20,
                ),
                if (!widget.isLogin)
                  TextFormField(
                    key: const ValueKey('phone'),
                    keyboardType: TextInputType.phone,
                    onEditingComplete: _saveForm,
                    onSaved: (value) {
                      _userPhoneNo = int.parse(value.toString());
                    },
                    validator: (value) {
                      if (value.toString().length == 10) {
                        return null;
                      }
                      return 'Phone number must contain 10 digits!';
                    },
                    decoration: InputDecoration(
                      labelStyle: TextStyle(
                        color: Theme.of(context).indicatorColor,
                      ),

                      label: const Text('Phone Number'),
                      hintText: 'Enter your Phone Number',
                      // helperText:
                      //     'We need your phone number for identity verification',
                      prefixIcon: Icon(
                        Icons.phone,
                        color: Theme.of(context).indicatorColor,
                      ),
                      // enabledBorder: OutlineInputBorder(
                      //   borderSide: const BorderSide(
                      //       color: Colors.grey,
                      //       width: 2.0,
                      //       style: BorderStyle.solid),
                      //   borderRadius: BorderRadius.circular(15),
                      // ),
                      // focusedBorder: const OutlineInputBorder(
                      //   borderSide: BorderSide(
                      //     color: Colors.grey,
                      //     width: 2.0,
                      //     style: BorderStyle.solid,
                      //   ),
                      // ),
                    ),
                  ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton.icon(
                  onPressed: _saveForm,
                  label: Text(widget.isLogin ? 'Login' : 'Sign Up'),
                  icon: const Icon(Icons.login),
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
