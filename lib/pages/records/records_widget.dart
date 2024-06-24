import 'package:dio/dio.dart';
import 'package:dmp_app/data/Prescription.dart';

import '../../urls.dart';
import '../ListTileWidget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'records_model.dart';
export 'records_model.dart';

class RecordsWidget extends StatefulWidget {
  final String email;

  const RecordsWidget({Key? key, required this.email}) : super(key: key);
  @override
  _RecordsWidgetState createState() => _RecordsWidgetState();
}

class _RecordsWidgetState extends State<RecordsWidget> {
  late RecordsModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<Prescription> prescriptions = [];
  final Dio dio = Dio();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => RecordsModel());
    fetchPrescriptions();
  }

  void showValidationMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Container(
        padding: const EdgeInsets.all(16),
        height: 90,
        decoration: const BoxDecoration(
          color: Color(0xFFC72C41),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Text(
          message,
          style: TextStyle(fontSize: 18, color: Colors.white),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      ),
    ));
  }

  Future<void> fetchPrescriptions() async {
    try {
      print("email" + widget.email);
      var response = await dio
          .get(GET_PATIENT_PRESCRIPTION, data: {"email": widget.email});

      if (response.data['success']) {
        //print(response.data['prescriptions']);
        List<Prescription> pres = [];

        for (var presData in response.data['prescriptions']) {
          print(presData);
          Prescription prescription = Prescription.fromJson(presData);
          if (prescription.approved == "True") {
            pres.add(prescription);
          }
        }
        if (response.statusCode == 200) {
          setState(() {
            prescriptions = pres;
          });
        } else {
          print('Failed to fetch prescriptions.');
        }
      } else {
        showValidationMessage(context, response.data['msg']);
      }
    } catch (e) {
      showValidationMessage(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(0, 110, 194, 1),
          automaticallyImplyLeading: false,
          leading: InkWell(
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () async {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.chevron_left_rounded,
              color: FlutterFlowTheme.of(context).secondaryBackground,
              size: 24.0,
            ),
          ),
          title: Text(
            'Records',
            style: FlutterFlowTheme.of(context).titleSmall.override(
                  fontFamily: 'DM Sans',
                  color: Colors.white,
                  fontSize: 20
                ),
          ),
          actions: [],
          centerTitle: true,
          elevation: 0.0,
        ),
        // ... other properties ...
        body: prescriptions.isEmpty
            ? Center(child: CircularProgressIndicator())
            : SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: AnimatedList(
                        key: _listKey,
                        initialItemCount: prescriptions.length,
                        itemBuilder: (context, index, animation) {
                          return SlideTransition(
                            position: Tween<Offset>(
                              begin: Offset(1, 0),
                              end: Offset(0, 0),
                            ).animate(animation),
                            child: CustomTile(
                                prescription: prescriptions[
                                    index]), // your custom ListTile (as shown above)
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
