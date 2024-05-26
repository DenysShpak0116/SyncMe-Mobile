import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncme/models/user.dart';
import 'package:syncme/providers/user_provider.dart';
import 'package:syncme/screens/tabs.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  var _form = GlobalKey<FormState>();

  var _isLogin = true;
  var _isSigning = false;
  var _enteredEmail = '';
  var _enterdPassowrd = '';
  var _enteredUsername = '';
  var _chosenCountry = 'Ukraine';
  var _enteredFirstname = '';
  var _enteredLastname = '';
  var _chosenSex = 'Male';
  final _passwordController = TextEditingController();

  bool _submit() {
    if (_form.currentState!.validate()) {
      _form.currentState!.save();
      return true;
    }
    return false;
  }

  void _login() {
    _submit();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (ctx) => const TabsScreen(),
      ),
    );
  }

  void _signup() async {
    _submit();
    _form = GlobalKey<FormState>();
    
    User user = User(
        userId: -1,
        username: _enteredUsername,
        password: _enterdPassowrd,
        email: _enteredEmail,
        firstName: _enteredFirstname,
        lastName: _enteredLastname,
        sex: _chosenSex,
        country: _chosenCountry,
        role: 'user');

    bool isDataValid =
        await ref.read(userProvider.notifier).createNewUser(user);
    if (!isDataValid) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Email or username are already taken'),
        ));
      }

      setState(() {
        _isSigning = false;
        _isLogin = false;
        _enteredEmail = '';
        _enteredUsername = '';
        _passwordController.clear();
      });
    }

    if (context.mounted) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('New account is created, login now!'),
      ));
    }
    setState(() {
        _isSigning = false;
        _isLogin = true;
        _enteredUsername = '';
        _passwordController.clear();
      });
  }

  void _moveToNextSignupForm() {
    if (_submit()) {
      setState(() {
        _isSigning = true;
        _form = GlobalKey<FormState>();
      });
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
        initialValue: _enteredEmail,
        style: const TextStyle(
          color: Color.fromARGB(255, 211, 179, 233),
        ),
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
        style: const TextStyle(
          color: Color.fromARGB(255, 211, 179, 233),
        ),
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
        child: const Text(
          'Log in',
          style: TextStyle(
            color: Color.fromARGB(255, 211, 179, 233),
          ),
        ),
      ),
      TextButton(
        onPressed: () {
          setState(() {
            _isLogin = !_isLogin;
            _form = GlobalKey<FormState>();
          });
        },
        child: const Text(
          'Register now',
          style: TextStyle(
            color: Color.fromARGB(255, 211, 179, 233),
          ),
        ),
      ),
    ];

    if (!_isLogin) {
      formChildren = [
        TextFormField(
          initialValue: _enteredEmail,
          style: const TextStyle(
            color: Color.fromARGB(255, 211, 179, 233),
          ),
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
          style: const TextStyle(
            color: Color.fromARGB(255, 211, 179, 233),
          ),
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
            _enteredUsername = newValue!;
          },
        ),
        DropdownButtonFormField(
          decoration: const InputDecoration(
            labelText: 'Country',
            labelStyle: TextStyle(
              color: Color.fromARGB(255, 211, 179, 233),
            ),
          ),
          value: _chosenCountry,
          dropdownColor: const Color.fromARGB(255, 67, 43, 85),
          onChanged: (value) {
            _chosenCountry = value!;
          },
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
          style: const TextStyle(
            color: Color.fromARGB(255, 211, 179, 233),
          ),
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
          style: const TextStyle(
            color: Color.fromARGB(255, 211, 179, 233),
          ),
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
          onPressed: _isLogin ? _login : _moveToNextSignupForm,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 107, 68, 135),
          ),
          child: const Text(
            'Continue',
            style: TextStyle(
              color: Color.fromARGB(255, 211, 179, 233),
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              _isLogin = !_isLogin;
              _form = GlobalKey<FormState>();
              _passwordController.clear();
            });
          },
          child: const Text(
            'Log in',
            style: TextStyle(
              color: Color.fromARGB(255, 211, 179, 233),
            ),
          ),
        ),
      ];
    }

    if (_isSigning) {
      formChildren = [
        TextFormField(
          style: const TextStyle(
            color: Color.fromARGB(255, 211, 179, 233),
          ),
          decoration: const InputDecoration(
            labelStyle: TextStyle(
              color: Color.fromARGB(255, 211, 179, 233),
            ),
            labelText: 'Firstname',
          ),
          textCapitalization: TextCapitalization.words,
          validator: (value) {
            if (value == null ||
                value.trim().isEmpty ||
                value.split('.')[0] != value.split('.')[0].toUpperCase()) {
              return 'Firstname must start from capital latter.';
            }
            return null;
          },
          onSaved: (newValue) {
            _enteredFirstname = newValue!;
          },
        ),
        TextFormField(
          style: const TextStyle(
            color: Color.fromARGB(255, 211, 179, 233),
          ),
          decoration: const InputDecoration(
            labelStyle: TextStyle(
              color: Color.fromARGB(255, 211, 179, 233),
            ),
            labelText: 'Lastname',
          ),
          textCapitalization: TextCapitalization.words,
          validator: (value) {
            if (value == null ||
                value.trim().isEmpty ||
                value.split('.')[0] != value.split('.')[0].toUpperCase()) {
              return 'Lastname must start from capital latter.';
            }
            return null;
          },
          onSaved: (newValue) {
            _enteredLastname = newValue!;
          },
        ),
        const SizedBox(
          height: 12,
        ),
        DropdownButtonFormField(
          decoration: const InputDecoration(
            labelText: 'Sex',
            labelStyle: TextStyle(
              color: Color.fromARGB(255, 211, 179, 233),
            ),
          ),
          value: _chosenSex,
          dropdownColor: const Color.fromARGB(255, 67, 43, 85),
          onChanged: (value) {
            _chosenSex = value!;
          },
          items: const [
            DropdownMenuItem(
              value: 'Male',
              child: Text('Male'),
            ),
            DropdownMenuItem(
              value: 'Female',
              child: Text('Female'),
            ),
            DropdownMenuItem(
              value: 'Other',
              child: Text('Other'),
            ),
          ],
          style: const TextStyle(
            color: Color.fromARGB(255, 211, 179, 233),
          ),
        ),
        ElevatedButton(
          onPressed: _signup,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 107, 68, 135),
          ),
          child: const Text(
            'Sign up',
            style: TextStyle(
              color: Color.fromARGB(255, 211, 179, 233),
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              _isSigning = false;
              _passwordController.clear();
              _form = GlobalKey<FormState>();
            });
          },
          icon: const Icon(
            Icons.keyboard_backspace,
            color: Color.fromARGB(255, 211, 179, 233),
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
