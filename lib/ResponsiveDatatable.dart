import 'package:flutter/material.dart';

import 'DatatableHeader.dart';

class ResponsiveDatatable extends StatefulWidget {
  final bool showSelect;
  final List<DatatableHeader> headers;
  final List<Map<String, dynamic>> source;
  final List<Map<String, dynamic>> selecteds;
  final Widget title;
  final List<Widget> actions;
  final List<Widget> footers;
  final Function(bool value) onSelectAll;
  final Function(bool value, Map<String, dynamic> data) onSelect;
  final Function(dynamic value) onTabRow;
  final Function(dynamic value) onSort;
  final BoxDecoration decoration;
  final BoxConstraints constraints;
  final String sortColumn;
  final bool sortAscending;
  final bool isLoading;

  const ResponsiveDatatable({
    Key key,
    this.showSelect: true,
    this.onSelectAll,
    this.onSelect,
    this.onTabRow,
    this.onSort,
    this.headers,
    this.source,
    this.selecteds,
    this.title,
    this.actions,
    this.footers,
    this.decoration,
    this.constraints,
    this.sortColumn,
    this.sortAscending,
    this.isLoading: false,
  }) : super(key: key);
  @override
  _ResponsiveDatatableState createState() => _ResponsiveDatatableState();
}

class _ResponsiveDatatableState extends State<ResponsiveDatatable> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return _size.width <= 600
        ?
        /**
         * for small screen
         */
        Container(
            constraints: this.widget.constraints ?? BoxConstraints(),
            decoration: this.widget.decoration ?? BoxDecoration(),
            child: Column(
              children: [
                //title and actions
                if (this.widget.title != null || this.widget.actions != null)
                  Container(
                    padding: EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (this.widget.title != null) this.widget.title,
                        if (this.widget.actions != null) ...this.widget.actions
                      ],
                    ),
                  ),
                Expanded(
                  child: Container(
                    child: ListView(
                        // itemCount: this.widget.source.length,
                        children: [
                          if (this.widget.showSelect && this.widget.selecteds != null)
                            Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              children: [
                                Checkbox(
                                    value: this.widget.selecteds.length ==
                                            this.widget.source.length &&
                                        this.widget.source != null &&
                                        this.widget.source.length > 0,
                                    onChanged: (value) {
                                      if (this.widget.onSelectAll != null)
                                        this.widget.onSelectAll(value);
                                    }),
                                DropdownButton(
                                    hint: Text("SORT BY"),
                                    value: this.widget.sortColumn,
                                    items: this
                                        .widget
                                        .headers
                                        .where((header) =>
                                            header.show == true &&
                                            header.sortable == true)
                                        .toList()
                                        .map((header) => DropdownMenuItem(
                                              child: Wrap(
                                                crossAxisAlignment:
                                                    WrapCrossAlignment.center,
                                                children: [
                                                  Text(
                                                    "${header.text}",
                                                    textAlign: header.textAlign,
                                                  ),
                                                  if (this.widget.sortColumn !=
                                                          null &&
                                                      this.widget.sortColumn ==
                                                          header.value)
                                                    this.widget.sortAscending
                                                        ? Icon(
                                                            Icons
                                                                .arrow_downward,
                                                            size: 15)
                                                        : Icon(
                                                            Icons.arrow_upward,
                                                            size: 15)
                                                ],
                                              ),
                                              value: header.value,
                                            ))
                                        .toList(),
                                    onChanged: (value) {
                                      if (this.widget.onSort != null)
                                        this.widget.onSort(value);
                                    })
                              ],
                            ),
                          if (this.widget.isLoading) LinearProgressIndicator(),
                          ...this.widget.source.map((data) {
                            return InkWell(
                              onTap: () {
                                if (this.widget.onTabRow != null)
                                  this.widget.onTabRow(data);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey[300],
                                            width: 1))),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Spacer(),
                                        if (this.widget.showSelect && this.widget.selecteds != null)
                                          Checkbox(
                                              value: this.widget.selecteds.indexOf(data) >= 0,
                                              onChanged: (value) {
                                                if (this.widget.onSelect !=
                                                    null)
                                                  this.widget.onSelect(value, data);
                                              }),
                                      ],
                                    ),
                                    ...this
                                        .widget
                                        .headers
                                        .where((header) => header.show == true)
                                        .toList()
                                        .map(
                                          (header) => Container(
                                            padding: EdgeInsets.all(11),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                header.headerBuilder != null
                                                    ? header.headerBuilder(
                                                        header.value)
                                                    : Text(
                                                        "${header.text}",
                                                        overflow:
                                                            TextOverflow.clip,
                                                      ),
                                                Spacer(),
                                                header.sourceBuilder != null
                                                    ? header.sourceBuilder(
                                                        data[header.value])
                                                    : Text(
                                                        "${data[header.value]}")
                                              ],
                                            ),
                                          ),
                                        )
                                        .toList()
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ]),
                  ),
                ),
                //footer
                if (this.widget.footers != null)
                  Container(
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [...this.widget.footers],
                    ),
                  )
              ],
            ))
        /**
           * for large screen
           */
        : Container(
            constraints: this.widget.constraints ?? BoxConstraints(),
            decoration: this.widget.decoration ?? BoxDecoration(),
            child: Column(
              children: [
                //title and actions
                if (this.widget.title != null || this.widget.actions != null)
                  Container(
                    padding: EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (this.widget.title != null) this.widget.title,
                        if (this.widget.actions != null) ...this.widget.actions
                      ],
                    ),
                  ),

                //title
                if (this.widget.headers != null &&
                    this.widget.headers.isNotEmpty)
                  Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Colors.grey, width: 1))),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (this.widget.showSelect && this.widget.selecteds != null)
                          Checkbox(
                              value: this.widget.selecteds.length ==
                                      this.widget.source.length &&
                                  this.widget.source != null &&
                                  this.widget.source.length > 0,
                              onChanged: (value) {
                                if (this.widget.onSelectAll != null)
                                  this.widget.onSelectAll(value);
                              }),
                        ...this
                            .widget
                            .headers
                            .where((header) => header.show == true)
                            .map(
                              (header) => Expanded(
                                  flex: header.flex ?? 1,
                                  child: InkWell(
                                    onTap: () {
                                      if (this.widget.onSort != null &&
                                          header.sortable)
                                        this.widget.onSort(header.value);
                                    },
                                    child: header.headerBuilder != null
                                        ? header.headerBuilder(header.value)
                                        : Container(
                                            padding: EdgeInsets.all(11),
                                            child: Wrap(
                                              crossAxisAlignment:
                                                  WrapCrossAlignment.center,
                                              children: [
                                                Text(
                                                  "${header.text}",
                                                  textAlign: header.textAlign,
                                                ),
                                                if (this.widget.sortColumn !=
                                                        null &&
                                                    this.widget.sortColumn ==
                                                        header.value)
                                                  this.widget.sortAscending
                                                      ? Icon(
                                                          Icons.arrow_downward,
                                                          size: 15)
                                                      : Icon(Icons.arrow_upward,
                                                          size: 15)
                                              ],
                                            ),
                                          ),
                                  )),
                            )
                            .toList()
                      ],
                    ),
                  ),

                if (this.widget.isLoading)
                  LinearProgressIndicator(),

                // data
                if (this.widget.source != null && this.widget.source.isNotEmpty)
                  Expanded(
                    child: Container(
                      child: ListView.builder(
                        itemCount: this.widget.source.length,
                        itemBuilder: (_, index) {
                          final data = this.widget.source[index];
                          return InkWell(
                            onTap: () {
                              if (this.widget.onTabRow != null)
                                this.widget.onTabRow(data);
                            },
                            child: Container(
                                padding: EdgeInsets.all(
                                    this.widget.showSelect ? 0 : 11),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey[300],
                                            width: 1))),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (this.widget.showSelect && this.widget.selecteds != null)
                                      Checkbox(
                                          value: this.widget.selecteds.indexOf(data) >= 0,
                                          onChanged: (value) {
                                            if (this.widget.onSelect != null)
                                              this.widget.onSelect(value, data);
                                          }),
                                    ...this
                                        .widget
                                        .headers
                                        .where((header) => header.show == true)
                                        .map(
                                          (header) => Expanded(
                                              flex: header.flex ?? 1,
                                              child: header.sourceBuilder !=
                                                      null
                                                  ? header.sourceBuilder(
                                                      data[header.value])
                                                  : Container(
                                                      child: Text(
                                                        "${data[header.value]}",
                                                        textAlign:
                                                            header.textAlign,
                                                      ),
                                                    )),
                                        )
                                        .toList()
                                  ],
                                )),
                          );
                        },
                      ),
                    ),
                  ),

                //footer
                if (this.widget.footers != null)
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [...this.widget.footers],
                    ),
                  )
              ],
            ),
          );
  }
}
