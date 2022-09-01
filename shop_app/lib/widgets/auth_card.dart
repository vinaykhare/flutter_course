import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/auth_service.dart';
import '../models/my_exception.dart';

enum AuthMode { signup, login }

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key? key,
  }) : super(key: key);

  @override
  AuthCardState createState() => AuthCardState();
}

class AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.login;
  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();
  late AnimationController _animationController;
  //late Animation<Size> _heightAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 500,
      ),
    );

    CurvedAnimation curvedAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.fastOutSlowIn,
    );

    // Tween<Size> tweenSize = Tween<Size>(
    //   begin: const Size(
    //     double.infinity,
    //     260,
    //   ),
    //   end: const Size(
    //     double.infinity,
    //     320,
    //   ),
    // );

    Tween<double> tweenOpacity = Tween<double>(
      begin: 0,
      end: 1,
    );

    // _heightAnimation = tweenSize.animate(
    //   curvedAnimation,
    // );

    _opacityAnimation = tweenOpacity.animate(curvedAnimation);

    //_heightAnimation.addListener(() => setState(() {}));
  }

  void _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Error"),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Ok"),
              ),
            ],
          );
        });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState?.save();
    setState(() {
      _isLoading = true;
    });
    String authResponse;
    try {
      if (_authMode == AuthMode.login) {
        authResponse = await Provider.of<AuthService>(context, listen: false)
            .login(_authData['email'] ?? "", _authData['password'] ?? "");
      } else {
        authResponse = await Provider.of<AuthService>(context, listen: false)
            .signUp(_authData['email'] ?? "", _authData['password'] ?? "");
      }
      if (authResponse != "Authenticated!") {
        _showErrorDialog(authResponse);
      } else {
        //Navigator.of(context).pushNamed(ProductsOverview.routePath);
      }
    } on MyException catch (knownError) {
      _showErrorDialog(knownError.toString());
    } catch (unknownError) {
      _showErrorDialog(unknownError.toString());
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.login) {
      setState(() {
        _authMode = AuthMode.signup;
      });
      _animationController.forward();
    } else {
      setState(() {
        _authMode = AuthMode.login;
      });
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.fastOutSlowIn,
        height: _authMode == AuthMode.signup ? 320 : 260,
        constraints:
            BoxConstraints(minHeight: _authMode == AuthMode.signup ? 320 : 260),
        width: deviceSize.width * 0.75,
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(labelText: 'E-Mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Invalid email!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['email'] = value ?? "";
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 5) {
                      return 'Password is too short!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['password'] = value ?? "";
                  },
                ),
                if (_authMode == AuthMode.signup)
                  FadeTransition(
                    opacity: _opacityAnimation,
                    child: TextFormField(
                      enabled: _authMode == AuthMode.signup,
                      decoration:
                          const InputDecoration(labelText: 'Confirm Password'),
                      obscureText: true,
                      validator: _authMode == AuthMode.signup
                          ? (value) {
                              if (value != _passwordController.text) {
                                return 'Passwords do not match!';
                              }
                              return null;
                            }
                          : null,
                    ),
                  ),
                const SizedBox(
                  height: 20,
                ),
                if (_isLoading)
                  const CircularProgressIndicator()
                else
                  ElevatedButton(
                    onPressed: _submit,
                    child:
                        Text(_authMode == AuthMode.login ? 'LOGIN' : 'SIGN UP'),
                  ),
                TextButton(
                  onPressed: _switchAuthMode,
                  child: Text(
                      '${_authMode == AuthMode.login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
                ),
              ],
            ),
          ),
        ),
      ),
      // child: AnimatedBuilder(
      //   animation: _heightAnimation,
      //   builder: (context, ch) {
      //     return Container(
      //       height: _heightAnimation.value.height,
      //       constraints:
      //           BoxConstraints(minHeight: _heightAnimation.value.height),
      //       width: deviceSize.width * 0.75,
      //       padding: const EdgeInsets.all(16.0),
      //       child: ch,
      //     );
      //   },
      //   child: Form(
      //     key: _formKey,
      //     child: SingleChildScrollView(
      //       child: Column(
      //         children: <Widget>[
      //           TextFormField(
      //             decoration: const InputDecoration(labelText: 'E-Mail'),
      //             keyboardType: TextInputType.emailAddress,
      //             validator: (value) {
      //               if (value!.isEmpty || !value.contains('@')) {
      //                 return 'Invalid email!';
      //               }
      //               return null;
      //             },
      //             onSaved: (value) {
      //               _authData['email'] = value ?? "";
      //             },
      //           ),
      //           TextFormField(
      //             decoration: const InputDecoration(labelText: 'Password'),
      //             obscureText: true,
      //             controller: _passwordController,
      //             validator: (value) {
      //               if (value!.isEmpty || value.length < 5) {
      //                 return 'Password is too short!';
      //               }
      //               return null;
      //             },
      //             onSaved: (value) {
      //               _authData['password'] = value ?? "";
      //             },
      //           ),
      //           if (_authMode == AuthMode.signup)
      //             TextFormField(
      //               enabled: _authMode == AuthMode.signup,
      //               decoration:
      //                   const InputDecoration(labelText: 'Confirm Password'),
      //               obscureText: true,
      //               validator: _authMode == AuthMode.signup
      //                   ? (value) {
      //                       if (value != _passwordController.text) {
      //                         return 'Passwords do not match!';
      //                       }
      //                       return null;
      //                     }
      //                   : null,
      //             ),
      //           const SizedBox(
      //             height: 20,
      //           ),
      //           if (_isLoading)
      //             const CircularProgressIndicator()
      //           else
      //             ElevatedButton(
      //               onPressed: _submit,
      //               child:
      //                   Text(_authMode == AuthMode.login ? 'LOGIN' : 'SIGN UP'),
      //             ),
      //           TextButton(
      //             onPressed: _switchAuthMode,
      //             child: Text(
      //                 '${_authMode == AuthMode.login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
      //           ),
      //         ],
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}
