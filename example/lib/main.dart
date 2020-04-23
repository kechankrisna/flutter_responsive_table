import 'dart:math';
import 'package:flutter/material.dart';
import 'package:responsive_table/responsive_table.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => DataPage(),
      },
    );
  }
}

class DataPickerPage extends StatefulWidget {
  @override
  _DataPickerPageState createState() => _DataPickerPageState();
}

class _DataPickerPageState extends State<DataPickerPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class DataPage extends StatefulWidget {
  DataPage({Key key}) : super(key: key);
  @override
  _DataPageState createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  List<DatatableHeader> _headers = [
    DatatableHeader(
        text: "ID",
        value: "id",
        show: false,
        sortable: true,
        textAlign: TextAlign.right),
    DatatableHeader(
        text: "Name",
        value: "name",
        show: true,
        flex: 2,
        sortable: true,
        textAlign: TextAlign.left),
    DatatableHeader(
        text: "SKU",
        value: "sku",
        show: true,
        sortable: true,
        textAlign: TextAlign.center),
    DatatableHeader(
        text: "Category",
        value: "category",
        show: true,
        sortable: true,
        textAlign: TextAlign.left),
    DatatableHeader(
        text: "Price",
        value: "price",
        show: true,
        sortable: true,
        textAlign: TextAlign.left),
    DatatableHeader(
        text: "Margin",
        value: "margin",
        show: true,
        sortable: true,
        textAlign: TextAlign.left),
    DatatableHeader(
        text: "In Stock",
        value: "in_stock",
        show: true,
        sortable: true,
        textAlign: TextAlign.left),
    DatatableHeader(
        text: "Alert",
        value: "alert",
        show: true,
        sortable: true,
        textAlign: TextAlign.left),
    DatatableHeader(
        text: "Received",
        value: "received",
        show: true,
        sortable: false,
        sourceBuilder: (value) {
          List list = List.from(value);
          return Container(
            child: Column(
              children: [
                Container(
                  width: 85,
                  child: LinearProgressIndicator(
                    value: list.first / list.last,
                  ),
                ),
                Text("${list.first} of ${list.last}")
              ],
            ),
          );
        },
        textAlign: TextAlign.center),
  ];

  List<int> _perPages = [5, 10, 15, 100];
  int _total = 100;
  int _currentPerPage;
  int _currentPage = 1;
  bool _isSearch = false;
  List<Map<String, dynamic>> _source = List<Map<String, dynamic>>();
  List<Map<String, dynamic>> _selecteds = List<Map<String, dynamic>>();
  String _selectableKey = "id";

  String _sortColumn;
  bool _sortAscending = true;
  bool _isLoading = true;

  List<Map<String, dynamic>> _generateData({int n: 100}) {
    final List source = List.filled(n, Random.secure());
    List<Map<String, dynamic>> temps = List<Map<String, dynamic>>();
    var i = _source.length;
    print(i);
    for (var data in source) {
      temps.add({
        "id": i,
        "sku": "$i\000$i",
        "name": "Product Product Product Product $i",
        "category": "Category-$i",
        "price": "${i}0.00",
        "cost": "20.00",
        "margin": "${i}0.20",
        "in_stock": "${i}0",
        "alert": "5",
        "received": [i + 20, 150]
      });
      i++;
    }
    return temps;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("DATA TABLE"),
      ),
      drawer: Drawer(
        child: ListView.separated(
          itemCount: List.filled(100, Random.secure()).length,
          itemBuilder: (_, index) => ExpansionTile(
            leading: Icon(Icons.verified_user),
            title: Text("$index"),
            // trailing: Text("$index"),
            children: List.filled(10, Random.secure())
                .map((e) => ListTile(
                      leading: SizedBox(),
                      title: Text("$e"),
                    ))
                .toList(),
          ),
          separatorBuilder: (_, index) => Divider(
            thickness: 1,
            height: 1,
          ),
        ),
      ),
      body: ResponsiveDatatable(
        constraints: BoxConstraints(maxHeight: 450),
       isLoading: _isLoading,
       title: !_isSearch
           ? RaisedButton.icon(
               onPressed: () {},
               icon: Icon(Icons.add),
               label: Text("ADD CATEGORY"))
           : null,
       actions: [

         if (_isSearch)
           Expanded(
               child: TextField(
             decoration: InputDecoration(
                 prefixIcon: IconButton(
                     icon: Icon(Icons.cancel),
                     onPressed: () {
                       setState(() {
                         _isSearch = false;
                       });
                     }),
                 suffixIcon:
                     IconButton(icon: Icon(Icons.search), onPressed: () {})),
           )),
         if (!_isSearch)
           IconButton(
               icon: Icon(Icons.search),
               onPressed: () {
                 setState(() {
                   _isSearch = true;
                 });
               })
       ],
        headers: _headers,
        source: _source,
        selecteds: _selecteds,
        onSelect: (value, item) {
          print("$value 157 $item ");
          if (value) {
            setState(() => _selecteds.add(item));
          } else {
            setState(() => _selecteds.removeAt(_selecteds.indexOf(item)));
          }
        },
        onSelectAll: (value) {
          print(value);
          if (value) {
            setState(() => _selecteds =
                _source.map((entry) => entry).toList().cast());
          } else {
            setState(() => _selecteds.clear());
          }
        },
        onTabRow: (value) => print(value),
        sortColumn: _sortColumn,
        sortAscending: _sortAscending,
        showSelect: true,
        onSort: (value) {
          setState(() {
            _sortColumn = value;
            _sortAscending = !_sortAscending;
          });
          setState(() {
            if (_sortAscending) {
              _source.sort(
                  (a, b) => b["$_sortColumn"].compareTo(a["$_sortColumn"]));
            } else {
              _source.sort(
                  (a, b) => a["$_sortColumn"].compareTo(b["$_sortColumn"]));
            }
          });
        },
       footers: [
         Container(
           padding: EdgeInsets.symmetric(horizontal: 15),
           child: Text("Rows per page:"),
         ),
         if (_perPages != null)
           Container(
             padding: EdgeInsets.symmetric(horizontal: 15),
             child: DropdownButton(
                 value: _currentPerPage,
                 items: _perPages
                     .map((e) => DropdownMenuItem(
                           child: Text("$e"),
                           value: e,
                         ))
                     .toList(),
                 onChanged: (value) {
                   setState(() {
                     _currentPerPage = value;
                   });
                 }),
           ),
         Container(
           padding: EdgeInsets.symmetric(horizontal: 15),
           child: Text("$_currentPage - $_currentPerPage of $_total"),
         ),
         IconButton(
           icon: Icon(
             Icons.arrow_back_ios,
             size: 16,
           ),
           onPressed: () {
             setState(() {
               _currentPage = _currentPage >= 2 ? _currentPage - 1 : 1;
             });
           },
           padding: EdgeInsets.symmetric(horizontal: 15),
         ),
         IconButton(
           icon: Icon(Icons.arrow_forward_ios, size: 16),
           onPressed: () {
             setState(() {
               _currentPage++;
             });
           },
           padding: EdgeInsets.symmetric(horizontal: 15),
         )
       ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          var temp = _generateData();

          setState(() {
            _source.addAll(temp);
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
