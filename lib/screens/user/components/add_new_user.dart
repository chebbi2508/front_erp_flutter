import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pfe/theme/colors.dart';
import 'package:http/http.dart' as http;
import '../../../services/callapi.dart';
import '../user.dart';

class EditProfileUser extends StatefulWidget {
  late int iduser;
  late String firstname;
  late String user_image;
  late String lastname;
  late String email;
  late String job;
  late String status;
  late int id;
  late String population;
  late String password;
  late List populations;
  List jobs;
  late bool willAdd;
  EditProfileUser(
      {this.email = '',
      this.firstname = '',
      this.lastname = '',
      this.user_image = 'Unknown_person.jpg',
      this.status = '',
      this.job = '',
      this.population = '',
      this.password = '',
      required this.populations,
      required this.iduser,
      required this.jobs,
      this.id = 0}) {
    willAdd = email.isEmpty;
  }
  @override
  State<EditProfileUser> createState() => _EditProfileUserState();
}

class _EditProfileUserState extends State<EditProfileUser> {
  TextEditingController cc = TextEditingController();
  TextEditingController po = TextEditingController();
  TextEditingController st = TextEditingController();

  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController firstNameController = new TextEditingController();
  TextEditingController confirmPasswordController = new TextEditingController();
  TextEditingController newPasswordController = new TextEditingController();
  TextEditingController lastNamepasswordController =
      new TextEditingController();
  GlobalKey<FormState> _form = GlobalKey<FormState>();
  bool _isHidden = true;
  bool _isHiddenNew = true;
  bool _isHiddenConfirm = true;
  bool isLoading = false;
  bool showPassword = false;
  var _selectedStatus;
  var _selectedPopulation;
  var _selectedJobs;
  //ProfileModel profileModel;

  // getDataUser() async {
  // return await profileApi.getUserData(UserDataModel.userId);
  // }

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  void _togglePasswordView2() {
    setState(() {
      _isHiddenNew = !_isHiddenNew;
    });
  }

  void _togglePasswordView3() {
    setState(() {
      _isHiddenConfirm = !_isHiddenConfirm;
    });
  }

  @override
  void initState() {
    super.initState();

    if (widget.email.isNotEmpty && widget.email != '') {
      _selectedStatus = widget.status;
      _selectedPopulation = widget.population;
      _selectedJobs = widget.job;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.willAdd ? 'Add User' : 'Modify User'),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 25, right: 16),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Form(
            key: _form,
            child: ListView(
              children: [
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 40.0,
                        backgroundColor: Colors.grey,
                        child: Align(
                          alignment: Alignment.center,
                          child: CircleAvatar(
                            backgroundColor: Colors.grey[300],
                            radius: 60.0,
                            child: Icon(
                              Icons.person,
                              size: 60.0,
                              // color: Color(0xFF404040),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: TextFormField(
                    key: new Key('First name'),
                    controller: widget.firstname.isEmpty
                        ? TextEditingController()
                        : TextEditingController(text: widget.firstname),
                    onChanged: (value) {
                      widget.firstname = value;
                    },
                    cursorColor: Color(0xFF0D47A1),
                    style: TextStyle(color: Color(0xFF0D47A1)),
                    decoration: InputDecoration(
                      labelText: 'First name',
                      labelStyle: TextStyle(
                        fontSize: 17,
                        // Tweak this 1,2 moves label bottom-> -1,-2 moves label upwards
                        fontWeight: FontWeight.w500,
                      ),
                      prefixIcon: Icon(
                        Icons.person,
                        color: Colors.grey[800],
                        size: 22,
                      ),
                      border: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFF0D47A1), width: 1.0)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: TextFormField(
                    key: new Key('Last name'),
                    controller: widget.lastname.isEmpty
                        ? TextEditingController()
                        : TextEditingController(text: widget.lastname),
                    onChanged: (value) {
                      widget.lastname = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        setState(() {
                          isLoading = false;
                        });
                        return 'Please enter your password';
                      }
                      return null;
                    },
                    cursorColor: Color(0xFF0D47A1),
                    style: TextStyle(color: Color(0xFF0D47A1)),
                    decoration: InputDecoration(
                      labelText: 'Last name',
                      labelStyle: TextStyle(
                        fontSize: 17,
                        // Tweak this 1,2 moves label bottom-> -1,-2 moves label upwards
                        fontWeight: FontWeight.w500,
                      ),
                      prefixIcon: Icon(
                        Icons.person,
                        color: Colors.grey[800],
                        size: 22,
                      ),
                      border: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFF0D47A1), width: 1.0)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: TextFormField(
                    key: new Key('Email'),
                    controller: widget.email.isEmpty
                        ? TextEditingController()
                        : TextEditingController(text: widget.email),
                    onChanged: (value) {
                      widget.email = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        setState(() {
                          isLoading = false;
                        });
                        return 'Please enter your password';
                      }
                      return null;
                    },
                    cursorColor: Color(0xFF0D47A1),
                    style: TextStyle(color: Color(0xFF0D47A1)),
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(
                        fontSize: 17,
                        // Tweak this 1,2 moves label bottom-> -1,-2 moves label upwards
                        fontWeight: FontWeight.w500,
                      ),
                      prefixIcon: Icon(
                        Icons.email,
                        color: Colors.grey[800],
                        size: 22,
                      ),
                      //icon: Icon(Icons.lock, color: Color(0xFF1A237E)),
                      // hintText: "Password",
                      border: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFF0D47A1), width: 1.0)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: TextFormField(
                    key: new Key('password'),
                    controller: widget.password.isEmpty
                        ? TextEditingController()
                        : TextEditingController(text: widget.password),
                    onChanged: (value) {
                      widget.password = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty || value == '') {
                        setState(() {
                          isLoading = false;
                        });
                        return 'Please enter your password';
                      }
                      return null;
                    },
                    cursorColor: Color(0xFF0D47A1),
                    //obscureText: true,
                    obscureText: _isHidden,
                    style: TextStyle(color: Color(0xFF0D47A1)),
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(
                        fontSize: 15,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Colors.grey[800],
                        size: 22,
                      ),
                      border: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: kPrimaryColor, width: 1.0)),
                      suffix: InkWell(
                        onTap: _togglePasswordView,
                        child: Icon(
                            _isHidden ? Icons.visibility : Icons.visibility_off,
                            color: Colors.grey),
                      ),
                    ),
                  ),
                ),

                // Padding(
                //   padding: const EdgeInsets.only(bottom: 20.0),
                //   child: DropDownField(
                //   //controller: ligneselected,
                //   hintText: "Job",
                //   enabled: true,
                //   controller: widget.job.isEmpty
                //       ? TextEditingController()
                //       : TextEditingController(text: widget.job),
                //   items: widget.jobs.cast<String>(),
                //   onValueChanged: (value) {
                //     widget.job = value;
                //   },
                // ),
                // ),
                //  Padding(
                //   padding: const EdgeInsets.only(bottom: 20.0),
                //   child:DropDownField(
                //   //controller: ligneselected,
                //   hintText: "Population",
                //   enabled: true,
                //   controller: widget.population.isEmpty
                //       ? TextEditingController()
                //       : TextEditingController(text: widget.population),
                //   items: widget.populations.cast<String>(),
                //   onValueChanged: (value) {
                //     widget.population = value;
                //   },
                // ),
                // ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: DropdownButtonFormField<dynamic>(
                    isExpanded: true,
                    validator: (value) =>
                        value == null ? 'choose Population' : null,
                    hint: Text("Population *"),
                    items: widget.populations.map((dynamic item) {
                      return new DropdownMenuItem<dynamic>(
                          child: Text(
                            item, //Names that the api dropdown contains
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                          value: item //id projects
                          );
                    }).toList(),
                    onChanged: (var val) {
                      setState(() {
                        _selectedPopulation = val;
                      });
                    },
                    value: _selectedPopulation,
                  ),
                ),
              widget.jobs.toSet() != null ?  Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: DropdownButtonFormField<String>(
                    isExpanded: true,
                    validator: (value) =>
                        value == null ? 'choose equipment' : null,
                    hint: Text("Jobs *"),
                    items: widget.jobs.toSet().map((dynamic item) {
                      return new DropdownMenuItem<String>(
                          child: Text(
                            item, //Names that the api dropdown contains
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                          value: item //id projects
                          );
                    }).toList(),
                    onChanged: (var val) {
                      setState(() {
                        _selectedJobs = val;
                      });
                    },
                    value: _selectedJobs,
                  ),
                ):  Container(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: DropdownButtonFormField<String>(
                    isExpanded: true,
                    validator: (value) =>
                        value == null ? 'choose equipment' : null,
                    hint: Text("Status *"),
                    items: <String>['active', 'Bloqué'].map((String item) {
                      return new DropdownMenuItem<String>(
                          child: Text(
                            item, //Names that the api dropdown contains
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                          value: item //id projects
                          );
                    }).toList(),
                    onChanged: (var val) {
                      setState(() {
                        _selectedStatus = val;
                      });
                    },
                    value: _selectedStatus,
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.only(bottom: 20.0),
                //   child: DropdownButton<String>(
                //     items: ['active' , 'Bloqué'].map((String value) {
                //       return DropdownMenuItem<String>(
                //         value:  _selectedStatus,
                //         child: Text(value),
                //       );
                //     }).toList(),
                //     onChanged: (value) {
                //        setState(() {
                //        _selectedStatus = value!;
                //       });
                //     },
                //   )),
                // Padding(
                //   padding: const EdgeInsets.only(bottom: 20.0),
                //   child:DropDownField(
                //   //controller: ligneselected,
                //   hintText: "Status",
                //   enabled: true,
                //   controller: widget.status.isEmpty
                //       ? TextEditingController()
                //       : TextEditingController(text: widget.status),
                //   items: widget.statu.cast<String>(),
                //   onValueChanged: (value) {
                //     widget.status = value;
                //   },
                // ),
                // ),

                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RaisedButton(
                      onPressed: () async {
                        if (widget.willAdd) {
                          if (widget.email != '') {
                            print(widget.email);
                            String statusCode = await createuser();
                            print(statusCode);
                            if (statusCode == 'success') {
                               Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        UsersScreen(),
                                  )); ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  duration: Duration(milliseconds: 2000),
                                  content: Text(
                                    'User added successFully',
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.0,
                                    ),
                                  ),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  duration: Duration(milliseconds: 2000),
                                  content: Text(
                                    'Something went wrong, Please try again!',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.0,
                                    ),
                                  ),
                                  backgroundColor: Colors.redAccent,
                                ),
                              );
                            }
                            Navigator.pop(context, statusCode);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                duration: Duration(milliseconds: 2000),
                                content: Text(
                                  'Fill all the details!',
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0,
                                  ),
                                ),
                                backgroundColor: Color(0xff066163),
                              ),
                            );
                          }
                        } else {
                          String statusCode = await updateuser();
                          if (statusCode == 'success') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                duration: Duration(milliseconds: 2000),
                                content: Text(
                                  'User Modified successFully',
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0,
                                  ),
                                ),
                                backgroundColor: Colors.green,
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                duration: Duration(milliseconds: 2000),
                                content: Text(
                                  'Something went wrong, Please try again!',
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0,
                                  ),
                                ),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                          }
                          Navigator.pop(context, statusCode);
                        }
                      },
                      color: primaryColor,
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: Text(
                        (widget.willAdd) ? 'Add user' : 'Modify user',
                        style: TextStyle(
                            fontSize: 14,
                            // letterSpacing: 2.2,
                            color: Colors.white),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  createuser() async {
    int created_by = widget.iduser;
    var data = {
      'firstname': widget.firstname,
      'lastname': widget.lastname,
      'job': _selectedJobs,
      'email': widget.email,
      'password': widget.password,
      'status': _selectedStatus,
      'population': _selectedPopulation,
      'created_by': created_by,
    };

    print(data);
    http.Response res = await CallApi().postData(data, 'createuser');
    var body = jsonDecode(res.body);
    print(body);
 if (body['status'] == "success") {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.green,
        content: Text("Success .. !"),
        duration: Duration(seconds: 2),
      ));
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const UsersScreen(),
        ),
      );
    }
    return body['status'];
    
  }

  updateuser() async {
    var data = {
      'firstname': widget.firstname,
      'lastname': widget.lastname,
      'job': _selectedJobs,
      'email': widget.email,
      'password': widget.password,
      'status': _selectedStatus,
      'population': _selectedPopulation,
      'created_by': widget.iduser,
    };

    print(data);
    http.Response res =
        await CallApi().putData(data, 'updateuser/${widget.id}');
    print(widget.id);

    var body = json.decode(res.body);
    print(body);
 if (body['status'] == "success") {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.green,
        content: Text("Success .. !"),
        duration: Duration(seconds: 2),
      ));
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const UsersScreen(),
        ),
      );
    }
    return body['message'];
  }
}
