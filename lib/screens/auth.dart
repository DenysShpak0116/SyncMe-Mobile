import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:syncme/screens/feed.dart';
import 'package:syncme/screens/tabs.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen> {
  final _form = GlobalKey<FormState>();

  var _isLogin = true;
  var _enteredEmail = '';
  var _enterdPassowrd = '';
  final _passwordController = TextEditingController();

  void _submit() {
    if (_form.currentState!.validate()) {
      _form.currentState!.save();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (ctx) => const TabsScreen(),
        ),
      );
      print(_enteredEmail);
      print(_enterdPassowrd);
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> formChildren = [
      TextFormField(
        decoration: const InputDecoration(
          labelStyle: TextStyle(
            color: Color.fromARGB(255, 211, 179, 233),
          ),
          labelText: 'Email Address',
        ),
        keyboardType: TextInputType.emailAddress,
        autocorrect: false,
        textCapitalization: TextCapitalization.none,
        validator: (value) {
          if (value == null || value.trim().isEmpty || !value.contains('@')) {
            return 'Please enter an valid email address.';
          }
          return null;
        },
        onSaved: (newValue) {
          _enteredEmail = newValue!;
        },
      ),
      TextFormField(
        decoration: const InputDecoration(
          labelStyle: TextStyle(
            color: Color.fromARGB(255, 211, 179, 233),
          ),
          labelText: 'Password',
        ),
        obscureText: true,
        validator: (value) {
          if (value == null || value.trim().length < 8) {
            return 'Password must be at least 8 characters long.';
          }
          return null;
        },
        onSaved: (newValue) {
          _enterdPassowrd = newValue!;
        },
      ),
      const SizedBox(
        height: 12,
      ),
      ElevatedButton(
        onPressed: _submit,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 107, 68, 135),
        ),
        child: Text(
          _isLogin ? 'Log in' : 'Sign up',
          style: const TextStyle(
            color: Color.fromARGB(255, 211, 179, 233),
          ),
        ),
      ),
      TextButton(
        onPressed: () {
          setState(() {
            _isLogin = !_isLogin;
          });
        },
        child: Text(
          _isLogin ? 'Register now' : 'Log in',
          style: const TextStyle(
            color: Color.fromARGB(255, 211, 179, 233),
          ),
        ),
      ),
    ];

    if (!_isLogin) {
      formChildren = [
        TextFormField(
          decoration: const InputDecoration(
            labelStyle: TextStyle(
              color: Color.fromARGB(255, 211, 179, 233),
            ),
            labelText: 'Email Address',
          ),
          keyboardType: TextInputType.emailAddress,
          autocorrect: false,
          textCapitalization: TextCapitalization.none,
          validator: (value) {
            if (value == null || value.trim().isEmpty || !value.contains('@')) {
              return 'Please enter an valid email address.';
            }
            return null;
          },
          onSaved: (newValue) {
            _enteredEmail = newValue!;
          },
        ),
        // TextFormField(
        //   decoration: const InputDecoration(
        //     labelStyle: TextStyle(
        //       color: Color.fromARGB(255, 211, 179, 233),
        //     ),
        //     labelText: 'Verification code',
        //   ),
        //   validator: (value) {
        //     if (value == null ||
        //         value.isEmpty ||
        //         value.trim().length < 6 ||
        //         int.tryParse(value) == null ||
        //         value.trim().length > 6) {
        //       return 'Verification code must contain only 6 digits.';
        //     }
        //     return null;
        //   },
        //   onSaved: (newValue) {
        //     _enterdPassowrd = newValue!;
        //   },
        // ),
        TextFormField(
          decoration: const InputDecoration(
            labelStyle: TextStyle(
              color: Color.fromARGB(255, 211, 179, 233),
            ),
            labelText: '@user_name',
          ),
          keyboardType: TextInputType.emailAddress,
          autocorrect: false,
          textCapitalization: TextCapitalization.none,
          validator: (value) {
            if (value == null ||
                value.trim().isEmpty ||
                value.lastIndexOf('@') != 0 ||
                value.length < 4) {
              return 'User name must start with \'@\' and be at least 4 characters.';
            }
            return null;
          },
          onSaved: (newValue) {
            _enteredEmail = newValue!;
          },
        ),
        DropdownButtonFormField(
          decoration: const InputDecoration(
            labelText: 'Country',
            labelStyle: TextStyle(
              color: Color.fromARGB(255, 211, 179, 233),
            ),
          ),
          value: 'Ukraine',
          dropdownColor: const Color.fromARGB(255, 67, 43, 85),
          onChanged: (value) {},
          items: const [
            DropdownMenuItem(
              value: 'Ukraine',
              child: Text('Ukraine'),
            ),
            DropdownMenuItem(
              value: 'USA',
              child: Text('USA'),
            ),
          ],
          style: const TextStyle(
            color: Color.fromARGB(255, 211, 179, 233),
          ),
        ),
        TextFormField(
          decoration: const InputDecoration(
            labelStyle: TextStyle(
              color: Color.fromARGB(255, 211, 179, 233),
            ),
            labelText: 'Enter password',
          ),
          obscureText: true,
          validator: (value) {
            if (value == null || value.trim().length < 8) {
              return 'Password must be at least 8 characters long.';
            }
            return null;
          },
          controller: _passwordController,
          onSaved: (newValue) {
            _enterdPassowrd = newValue!;
          },
        ),
        TextFormField(
          decoration: const InputDecoration(
            labelStyle: TextStyle(
              color: Color.fromARGB(255, 211, 179, 233),
            ),
            labelText: 'Enter password again',
          ),
          obscureText: true,
          validator: (value) {
            if (_passwordController.text != value) {
              return 'Passwords do not match';
            }
            return null;
          },
          onSaved: (newValue) {
            _enterdPassowrd = newValue!;
          },
        ),
        const SizedBox(
          height: 12,
        ),
        ElevatedButton(
          onPressed: _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 107, 68, 135),
          ),
          child: Text(
            _isLogin ? 'Log in' : 'Sign up',
            style: const TextStyle(
              color: Color.fromARGB(255, 211, 179, 233),
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              _isLogin = !_isLogin;
            });
          },
          child: Text(
            _isLogin ? 'Register now' : 'Log in',
            style: const TextStyle(
              color: Color.fromARGB(255, 211, 179, 233),
            ),
          ),
        ),
      ];
    }

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(
                  top: 30,
                  bottom: 20,
                  left: 20,
                  right: 20,
                ),
                width: 250,
                child: Image.asset('assets/images/SyncMe.png'),
              ),
              Text(
                _isLogin ? 'Account Log in' : 'Account Sing up',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontSize: 20,
                      color: const Color.fromARGB(255, 211, 179, 233),
                    ),
              ),
              Card(
                margin: const EdgeInsets.only(
                  top: 10,
                  bottom: 20,
                  left: 20,
                  right: 20,
                ),
                color: const Color.fromARGB(255, 94, 59, 118),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _form,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: formChildren,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
