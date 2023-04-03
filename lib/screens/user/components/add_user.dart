import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'package:pfe/screens/user/components/rounted_btn.dart';
import 'package:pfe/theme/theme.dart';
import 'package:dropdownfield/dropdownfield.dart';
import '../../../services/callapi.dart';
import '../../planning/planning.dart';
import '../user.dart';
import 'constant.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:async/src/delegate/stream.dart';

class AddModifyUserScreen extends StatelessWidget {
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
  List<String> statu = ['active', 'Bloqué'];
  List jobs;
  late bool willAdd;
  AddModifyUserScreen(
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

  TextEditingController cc = TextEditingController();
  TextEditingController po = TextEditingController();
  TextEditingController st = TextEditingController();
  late File _image;
  late String _selectedStatus; // Option 2

  String lien = "http://10.0.2.2:8000/public/images/";
  @override
  Widget build(BuildContext context) {
    print('cc $populations');
    return Scaffold(
      backgroundColor: const Color(0xffF2F2F2),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(60.0),
          decoration: const BoxDecoration(
            color: Color(0xffF2F2F2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Text(
                  willAdd ? 'Add User' : 'Modify User',
                  style: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff383838),
                  ),
                ),
              ),
              //  Padding(
              // padding: EdgeInsets.only(top: 20),

              // child: SizedBox(
              //     width: 330,
              //     child:

              //                GestureDetector(
              //                 onTap: () async {
              //                   final image = await ImagePicker()
              //                       .pickImage(source: ImageSource.gallery);
              //                           _image = File (image!.path);
              //                           var uri = Uri.parse("http://10.0.2.2:8000/api/imageadd");
              //                            var request =  http.MultipartRequest('POST', uri);
              //                           var stream= new http.ByteStream(DelegatingStream.typed(_image.openRead()));
              //                           var length= await _image.length();
              // var multipartFile =  http.MultipartFile("image", stream, length, filename: path.basename(_image.path));
              // print(multipartFile.filename);
              // request.files.add(multipartFile);

              // var respond = await request.send();

              //                   if (image == null) return;

              //                   final location = await getApplicationDocumentsDirectory();
              //                   final name = basename(image.path);
              //                   final imageFile = File('${location.path}/$name');
              //                   final newImage =
              //                       await File(image.path).copy(imageFile.path);

              //                 },
              //                 child: Image.network(lien + user_image, height: 150,width: 150,),
              //               )
              // )),
              const SizedBox(
                height: 10.0,
              ),
              const CircleAvatar(
                  radius: 50.0,
                  backgroundColor: Colors.grey,
                  child: CircleAvatar(
                    backgroundColor: Colors.grey,
                    child: Icon(
                      Icons.person,
                      size: 40.0,
                      color: Colors.white,
                    ),
                  )),
              Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        width: 330,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {},
                          child: const Text(
                            'Update',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ))),
              const SizedBox(
                height: 20.0,
              ),
              TextFormField(
                controller: firstname.isEmpty
                    ? TextEditingController()
                    : TextEditingController(text: firstname),
                onChanged: (value) {
                  firstname = value;
                },
                autofocus: true,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  hintText: 'First Name',
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextFormField(
                controller: lastname.isEmpty
                    ? TextEditingController()
                    : TextEditingController(text: lastname),
                onChanged: (value) {
                  lastname = value;
                },
                autofocus: true,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  hintText: 'Last Name',
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Container(
                color: Color.fromARGB(255, 90, 118, 245),
                child: DropDownField(
                  //controller: ligneselected,
                  hintText: "Job",
                  enabled: true,
                  controller: job.isEmpty
                      ? TextEditingController()
                      : TextEditingController(text: job),
                  items: jobs.cast<String>(),
                  onValueChanged: (value) {
                    job = value;
                  },
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Container(
                color: Color.fromARGB(255, 245, 132, 124),
                child: DropDownField(
                  //controller: ligneselected,
                  hintText: "Population",
                  enabled: true,
                  controller: population.isEmpty
                      ? TextEditingController()
                      : TextEditingController(text: population),
                  items: populations.cast<String>(),
                  onValueChanged: (value) {
                    population = value;
                  },
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextFormField(
                controller: email.isEmpty
                    ? TextEditingController()
                    : TextEditingController(text: email),
                onChanged: (value) {
                  email = value;
                },
                autofocus: true,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  hintText: 'Email',
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextFormField(
                controller: password.isEmpty
                    ? TextEditingController()
                    : TextEditingController(text: password),
                onChanged: (value) {
                  password = value;
                },
                autofocus: true,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  hintText: 'Password',
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),

              Container(
                color: Color.fromARGB(255, 245, 132, 124),
                child: DropDownField(
                  //controller: ligneselected,
                  hintText: "Status",
                  enabled: true,
                  controller: status.isEmpty
                      ? TextEditingController()
                      : TextEditingController(text: status),
                  items: statu.cast<String>(),
                  onValueChanged: (value) {
                    status = value;
                  },
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              RoundedButton(
                color: primaryclr,
                onPressed: () async {
                  if (willAdd) {
                    if (email != '') {
                      String statusCode = await createuser();
                      if (statusCode == 'success') {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => CalendarPage(),
                            ));
                        ScaffoldMessenger.of(context).showSnackBar(
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const UsersScreen(),
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
                      );  Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const UsersScreen(),
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
                title: (willAdd) ? 'Add' : 'Modify',
              )
            ],
          ),
        ),
      ),
    );
  }

  createuser() async {
    int created_by = iduser;
    var data = {
      'firstname': firstname,
      'lastname': lastname,
      'job': job,
      'email': email,
      'password': password,
      'status': status,
      'population': population,
      'created_by': created_by,
    };

    print(data);
    http.Response res = await CallApi().postData(data, 'createuser');
    var body = jsonDecode(res.body);
    print(body);

    return body['status'];
  }

  updateuser() async {
    var data = {
      'firstname': firstname,
      'lastname': lastname,
      'job': job,
      'email': email,
      'password': password,
      'status': status,
      'population': population,
    };

    print(data);
    http.Response res = await CallApi().putData(data, 'updateuser/$id');
    var body = json.decode(res.body);
    print(body);

    return body['message'];
  }
}
