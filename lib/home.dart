// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, sized_box_for_whitespace, avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  TextEditingController countryTxt = TextEditingController();
  TextEditingController deathsTxt = TextEditingController();
  TextEditingController recoveredTxt = TextEditingController();
  TextEditingController activeCaseTxt = TextEditingController();
  TextEditingController monthTxt = TextEditingController();

  @override
  void initState() {
    super.initState();
    getdata();
    datadelet(id);
    update(id);
    dataCreate();
  }

  List data = [];
  String? id;

  String base_url = '192.168.254.3';

  Future dataCreate() async {
    final response = await http
        .post(Uri.parse('http://$base_url:80/api/covid-tracker/store'),
            body: jsonEncode({
              "country": countryTxt.text,
              "deaths": deathsTxt.text,
              "recovered": recoveredTxt.text,
              "active_case": activeCaseTxt.text,
              "month": monthTxt.text,
            }),
            headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
        });

    print(response.statusCode);
    if (response.statusCode == 200) {
      print('Data Created Successfully');
      print(response.body);
      countryTxt.clear();
      deathsTxt.clear();
      recoveredTxt.clear();
      activeCaseTxt.clear();
      monthTxt.clear();
    } else {
      print('error from create');
    }
  }

  Future getdata() async {
    final responce =
        await http.get(Uri.parse('http://$base_url:80/api/covid-tracker'));
    print(base_url);
    if (responce.statusCode == 200) {
      setState(() {
        data = jsonDecode(responce.body);
      });
      print('Add data-> $data');
    } else {
      print('erro');
    }
  }

  Future datadelet(id) async {
    final responce = await http
        .delete(Uri.parse('http://$base_url:80/api/covid-tracker-delete/$id'));
    print('outside');
    print(responce.statusCode);
    final responceShow =
        await http.get(Uri.parse('http://$base_url:80/api/covid-tracker/$id'));
    print(responceShow.body);
    if (responce.statusCode == 200) {
      print('DELETE COMPLETE');
      print(responceShow.body);
      countryTxt.clear();
      deathsTxt.clear();
      recoveredTxt.clear();
      activeCaseTxt.clear();
      monthTxt.clear();
    } else {
      print('nOT dELET');
    }
  }

  Future update(id) async {
    final responce = await http
        .put(Uri.parse('http://$base_url:80/api/covid-tracker/edit/$id'),
            body: jsonEncode({
              "country": countryTxt.text,
              "deaths": deathsTxt.text,
              "recovered": deathsTxt.text,
              "active_case": activeCaseTxt.text,
              "month": monthTxt.text,
            }),
            headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
        });
    print(responce.statusCode);
    if (responce.statusCode == 200) {
      print('Data Update Sucassfully');
      print(responce.body);
      countryTxt.clear();
      deathsTxt.clear();
      recoveredTxt.clear();
      activeCaseTxt.clear();
      monthTxt.clear();
    } else {
      print('erro');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Covid Tracker'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(Duration(seconds: 2));
          getdata();
          // dataCreate();
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Container(
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return Container(
                              height: 210,
                              child: Stack(
                                children: [
                                  Card(
                                      color: Colors.blue,
                                      child: Card(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              data[index]['country'],
                                              style: TextStyle(fontSize: 25),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              data[index]['deaths'],
                                              style: TextStyle(fontSize: 25),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              data[index]['recovered'],
                                              style: TextStyle(fontSize: 25),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              data[index]['active_case'],
                                              style: TextStyle(fontSize: 25),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              data[index]['month'],
                                              style: TextStyle(fontSize: 25),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                ElevatedButton.icon(
                                                  onPressed: () {
                                                    countryTxt.text =
                                                        data[index]['country'];
                                                    deathsTxt.text =
                                                        data[index]['deaths'];
                                                    recoveredTxt.text =
                                                        data[index]
                                                            ['recovered'];
                                                    activeCaseTxt.text =
                                                        data[index]
                                                            ['active_case'];
                                                    monthTxt.text =
                                                        data[index]['month'];
                                                    editCase(index);
                                                  },
                                                  icon: Icon(Icons.update),
                                                  label: Text("edit"),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    primary: Colors.green,
                                                    textStyle:
                                                        TextStyle(fontSize: 15),
                                                  ),
                                                ),
                                                ElevatedButton.icon(
                                                  onPressed: () {
                                                    _deleteCase(index);
                                                  },
                                                  icon: Icon(Icons.delete),
                                                  label: Text("delete"),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    primary: Colors.red,
                                                    textStyle:
                                                        TextStyle(fontSize: 15),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ))
                                ],
                              ));
                        }),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('btn press');
          addNewCase();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void addNewCase() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
            content: SingleChildScrollView(
          child: Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              Positioned(
                right: -40.0,
                top: -40.0,
                child: InkResponse(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: CircleAvatar(
                    child: Icon(Icons.close),
                    backgroundColor: Colors.red,
                  ),
                ),
              ),
              Form(
                // key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextField(
                          controller: countryTxt,
                          decoration: InputDecoration(
                              hintText: 'country',
                              border: InputBorder.none,
                              icon: Icon(Icons.flag)),
                        )),
                    Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextField(
                          controller: deathsTxt,
                          decoration: InputDecoration(
                              hintText: 'deaths',
                              border: InputBorder.none,
                              icon: Icon(Icons.accessibility)),
                        )),
                    Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextField(
                          controller: recoveredTxt,
                          decoration: InputDecoration(
                              hintText: 'recovered',
                              border: InputBorder.none,
                              icon: Icon(Icons.agriculture)),
                        )),
                    Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextField(
                          controller: activeCaseTxt,
                          decoration: InputDecoration(
                              hintText: 'active case',
                              border: InputBorder.none,
                              icon: Icon(Icons.calendar_view_month)),
                        )),
                    Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextField(
                          controller: monthTxt,
                          decoration: InputDecoration(
                              hintText: 'Month',
                              border: InputBorder.none,
                              icon: Icon(Icons.calendar_view_month)),
                        )),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
                        color: Colors.green,
                        child:
                            Text("Add", style: TextStyle(color: Colors.white)),
                        onPressed: () {
                          setState(() {
                            dataCreate();
                            print("data added");
                          });
                          Navigator.pop(context);
                        },
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
      },
    );
  }

  void editCase(index) {
    Expanded(
      child: ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            return Container(
                height: 210,
                child: Card(
                    color: Colors.blue,
                    child: Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            data[index]['country'],
                            style: TextStyle(fontSize: 25),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            data[index]['deaths'],
                            style: TextStyle(fontSize: 25),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            data[index]['recovered'],
                            style: TextStyle(fontSize: 25),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            data[index]['active_case'],
                            style: TextStyle(fontSize: 25),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            data[index]['month'],
                            style: TextStyle(fontSize: 25),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                  color: Colors.blue,
                                  onPressed: () {
                                    countryTxt.text = data[index]['country'];
                                    deathsTxt.text = data[index]['deaths'];
                                    recoveredTxt.text =
                                        data[index]['recovered'];
                                    activeCaseTxt.text =
                                        data[index]['active_case'];
                                    monthTxt.text = data[index]['month'];
                                  },
                                  icon: Icon(Icons.edit)),
                              IconButton(
                                  color: Colors.green,
                                  onPressed: () {
                                    setState(() {
                                      print('inner edit button');
                                      // update(data[index]['id']);
                                      // print(data[index]);
                                    });
                                  },
                                  icon: Icon(Icons.update)),
                              IconButton(
                                  color: Colors.red,
                                  onPressed: () {
                                    countryTxt.text = data[index]['country'];
                                    deathsTxt.text = data[index]['deaths'];
                                    recoveredTxt.text =
                                        data[index]['recovered'];
                                    activeCaseTxt.text =
                                        data[index]['active_case'];
                                    monthTxt.text = data[index]['month'];
                                    datadelet(data[index]['id']);
                                    print(index);
                                  },
                                  icon: Icon(Icons.delete)),
                              ElevatedButton.icon(
                                onPressed: () {
                                  editCase(index);
                                },
                                icon: Icon(Icons.email),
                                label: Text("Contact me"),
                                style: ElevatedButton.styleFrom(
                                  textStyle: TextStyle(fontSize: 15),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    )));
          }),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
            content: SingleChildScrollView(
          child: Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              Positioned(
                right: -40.0,
                top: -40.0,
                child: InkResponse(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: CircleAvatar(
                    child: Icon(Icons.close),
                    backgroundColor: Colors.red,
                  ),
                ),
              ),
              Form(
                // key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextField(
                          controller: countryTxt,
                          decoration: InputDecoration(
                              hintText: 'country',
                              border: InputBorder.none,
                              icon: Icon(Icons.flag)),
                        )),
                    Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextField(
                          controller: deathsTxt,
                          decoration: InputDecoration(
                              hintText: 'deaths',
                              border: InputBorder.none,
                              icon: Icon(Icons.accessibility)),
                        )),
                    Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextField(
                          controller: recoveredTxt,
                          decoration: InputDecoration(
                              hintText: 'recovered',
                              border: InputBorder.none,
                              icon: Icon(Icons.agriculture)),
                        )),
                    Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextField(
                          controller: activeCaseTxt,
                          decoration: InputDecoration(
                              hintText: 'active case',
                              border: InputBorder.none,
                              icon: Icon(Icons.calendar_view_month)),
                        )),
                    Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextField(
                          controller: monthTxt,
                          decoration: InputDecoration(
                              hintText: 'Month',
                              border: InputBorder.none,
                              icon: Icon(Icons.calendar_view_month)),
                        )),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
                        color: Colors.green,
                        child: Text(
                          "Update",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          setState(() {
                            update(data[index]['id']);
                            print("data updated");
                          });
                          Navigator.pop(context);
                        },
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
      },
    );
    print('edit');
  }

  void _deleteCase(index) {
    Expanded(
      child: ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            return Container(
                height: 210,
                child: Card(
                    color: Colors.blue,
                    child: Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            data[index]['country'],
                            style: TextStyle(fontSize: 25),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            data[index]['deaths'],
                            style: TextStyle(fontSize: 25),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            data[index]['recovered'],
                            style: TextStyle(fontSize: 25),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            data[index]['active_case'],
                            style: TextStyle(fontSize: 25),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            data[index]['month'],
                            style: TextStyle(fontSize: 25),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                  color: Colors.blue,
                                  onPressed: () {
                                    countryTxt.text = data[index]['country'];
                                    deathsTxt.text = data[index]['deaths'];
                                    recoveredTxt.text =
                                        data[index]['recovered'];
                                    activeCaseTxt.text =
                                        data[index]['active_case'];
                                    monthTxt.text = data[index]['month'];
                                  },
                                  icon: Icon(Icons.edit)),
                              IconButton(
                                  color: Colors.green,
                                  onPressed: () {
                                    setState(() {
                                      print('inner edit button');
                                      // update(data[index]['id']);
                                      // print(data[index]);
                                    });
                                  },
                                  icon: Icon(Icons.update)),
                              IconButton(
                                  color: Colors.red,
                                  onPressed: () {
                                    countryTxt.text = data[index]['country'];
                                    deathsTxt.text = data[index]['deaths'];
                                    recoveredTxt.text =
                                        data[index]['recovered'];
                                    activeCaseTxt.text =
                                        data[index]['active_case'];
                                    monthTxt.text = data[index]['month'];
                                    datadelet(data[index]['id']);
                                    print(index);
                                  },
                                  icon: Icon(Icons.delete)),
                              ElevatedButton.icon(
                                onPressed: () {
                                  editCase(index);
                                },
                                icon: Icon(Icons.email),
                                label: Text("Contact me"),
                                style: ElevatedButton.styleFrom(
                                  textStyle: TextStyle(fontSize: 15),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    )));
          }),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
            content: SingleChildScrollView(
          child: Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              Text("Are you sure?"),
              Padding(
                padding: const EdgeInsets.only(top: 40, left: 140),
                child: RaisedButton(
                  color: Colors.green,
                  child: Text("confirm", style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    setState(() {
                      datadelet(data[index]['id']);
                      print("data deleted");
                    });
                    Navigator.pop(context);
                  },
                ),
              )
            ],
          ),
        ));
      },
    );
  }
}
