import 'package:flutter/material.dart';

import 'DatatableHeader.dart';

class ResponsiveDatatable extends StatelessWidget {
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
  final String sortColumn;
  final bool sortAscending;
  final bool isLoading;
  final bool autoHeight;

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
    this.sortColumn,
    this.sortAscending,
    this.isLoading: false,
    this.autoHeight: false,
  }) : super(key: key);
  Widget mobileHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Checkbox(
            value: selecteds.length == source.length &&
                source != null &&
                source.length > 0,
            onChanged: (value) {
              if (onSelectAll != null) onSelectAll(value);
            }),
        DropdownButton(
            hint: Text("SORT BY"),
            value: sortColumn,
            items: headers
                .where(
                    (header) => header.show == true && header.sortable == true)
                .toList()
                .map((header) => DropdownMenuItem(
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            "${header.text}",
                            textAlign: header.textAlign,
                          ),
                          if (sortColumn != null && sortColumn == header.value)
                            sortAscending
                                ? Icon(Icons.arrow_downward, size: 15)
                                : Icon(Icons.arrow_upward, size: 15)
                        ],
                      ),
                      value: header.value,
                    ))
                .toList(),
            onChanged: (value) {
              if (onSort != null) onSort(value);
            })
      ],
    );
  }

  List<Widget> mobileList() {
    return source.map((data) {
      return InkWell(
        onTap: () {
          if (onTabRow != null) onTabRow(data);
        },
        child: Container(
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: Colors.grey[300], width: 1))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Spacer(),
                  if (showSelect && selecteds != null)
                    Checkbox(
                        value: selecteds.indexOf(data) >= 0,
                        onChanged: (value) {
                          if (onSelect != null) onSelect(value, data);
                        }),
                ],
              ),
              ...headers
                  .where((header) => header.show == true)
                  .toList()
                  .map(
                    (header) => Container(
                      padding: EdgeInsets.all(11),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          header.headerBuilder != null
                              ? header.headerBuilder(header.value)
                              : Text(
                                  "${header.text}",
                                  overflow: TextOverflow.clip,
                                ),
                          Spacer(),
                          header.sourceBuilder != null
                              ? header.sourceBuilder(data[header.value])
                              : header.editable
                                  ? editAbleWidget(
                                      data: data,
                                      header: header,
                                      textAlign: TextAlign.end,
                                    )
                                  : Text("${data[header.value]}")
                        ],
                      ),
                    ),
                  )
                  .toList()
            ],
          ),
        ),
      );
    }).toList();
  }

  Widget desktopHeader() {
    return Container(
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey, width: 1))),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showSelect && selecteds != null)
            Checkbox(
                value: selecteds.length == source.length &&
                    source != null &&
                    source.length > 0,
                onChanged: (value) {
                  if (onSelectAll != null) onSelectAll(value);
                }),
          ...headers
              .where((header) => header.show == true)
              .map(
                (header) => Expanded(
                    flex: header.flex ?? 1,
                    child: InkWell(
                      onTap: () {
                        if (onSort != null && header.sortable)
                          onSort(header.value);
                      },
                      child: header.headerBuilder != null
                          ? header.headerBuilder(header.value)
                          : Container(
                              padding: EdgeInsets.all(11),
                              child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Text(
                                    "${header.text}",
                                    textAlign: header.textAlign,
                                  ),
                                  if (sortColumn != null &&
                                      sortColumn == header.value)
                                    sortAscending
                                        ? Icon(Icons.arrow_downward, size: 15)
                                        : Icon(Icons.arrow_upward, size: 15)
                                ],
                              ),
                            ),
                    )),
              )
              .toList()
        ],
      ),
    );
  }

  List<Widget> desktopList() {
    List<Widget> widgets = [];
    for (var index = 0; index < source.length; index++) {
      final data = source[index];
      widgets.add(InkWell(
        onTap: () {
          if (onTabRow != null) onTabRow(data);
        },
        child: Container(
            padding: EdgeInsets.all(showSelect ? 0 : 11),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: Colors.grey[300], width: 1))),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (showSelect && selecteds != null)
                  Checkbox(
                      value: selecteds.indexOf(data) >= 0,
                      onChanged: (value) {
                        if (onSelect != null) onSelect(value, data);
                      }),
                ...headers
                    .where((header) => header.show == true)
                    .map(
                      (header) => Expanded(
                        flex: header.flex ?? 1,
                        child: header.sourceBuilder != null
                            ? header.sourceBuilder(data[header.value])
                            : header.editable
                                ? editAbleWidget(
                                    data: data,
                                    header: header,
                                    textAlign: header.textAlign,
                                  )
                                : Container(
                                    child: Text(
                                      "${data[header.value]}",
                                      textAlign: header.textAlign,
                                    ),
                                  ),
                      ),
                    )
                    .toList()
              ],
            )),
      ));
    }
    return widgets;
  }


  Widget editAbleWidget(
      {@required Map<String, dynamic> data,
      @required DatatableHeader header,
      TextAlign textAlign: TextAlign.center}) {
    return Container(
      constraints: BoxConstraints(maxWidth: 150),
      padding: EdgeInsets.all(0),
      margin: EdgeInsets.all(0),
      child: TextField(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0),
          border: UnderlineInputBorder(borderSide: BorderSide(width: 1)),
          alignLabelWithHint: true,
        ),
        textAlign: textAlign,
        controller: TextEditingController.fromValue(
          TextEditingValue(text: "${data[header.value]}"),
        ),
        onChanged: (newValue) => data[header.value] = newValue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.of(context).size.width <= 992
        ?
        /**
         * for small screen
         */
        Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //title and actions
                if (title != null || actions != null)
                  Container(
                    padding: EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (title != null) title,
                        if (actions != null) ...actions
                      ],
                    ),
                  ),

                if (autoHeight)
                  Column(
                    children: [
                      if (showSelect && selecteds != null) mobileHeader(),
                      if (isLoading)
                        LinearProgressIndicator(),
                      //mobileList
                      ...mobileList(),
                    ],
                  ),
                if (!autoHeight)
                  Expanded(
                    child: Container(
                      child: ListView(
                        // itemCount: source.length,
                        children: [
                          if (showSelect && selecteds != null) mobileHeader(),
                          if (isLoading)
                            LinearProgressIndicator(),
                          //mobileList
                          ...mobileList(),
                        ],
                      ),
                    ),
                  ),
                //footer
                if (footers != null)
                  Container(
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [...footers],
                    ),
                  )
              ],
            ),
          )
        /**
          * for large screen
          */
        : Container(
            child: Column(
              children: [
                //title and actions
                if (title != null || actions != null)
                  Container(
                    padding: EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (title != null) title,
                        if (actions != null) ...actions
                      ],
                    ),
                  ),

                //desktopHeader
                if (headers != null && headers.isNotEmpty)
                  desktopHeader(),

                if (isLoading)
                  LinearProgressIndicator(),

                if (autoHeight)
                  Column(children: desktopList()),

                if (!autoHeight)
                  // desktopList
                  if (source != null && source.isNotEmpty)
                    Expanded(
                        child: Container(
                            child: ListView(children: desktopList()))),

                //footer
                if (footers != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [...footers],
                  )
              ],
            ),
          );
  }
}
