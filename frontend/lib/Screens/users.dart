import 'dart:convert';
import 'package:frontend/global.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
class UserStatsPage extends StatefulWidget {
  @override
  _UserStatsPageState createState() => _UserStatsPageState();
}
class AxisLabelMeta {
  final int index;
  final String xLabel;

  AxisLabelMeta(this.index, this.xLabel);
}
class _UserStatsPageState extends State<UserStatsPage> {
  // Simulated data for the number of users, vendors, and shelters

  final List<String> xLabels = ["Users","Vet", "Vendors"];
  Widget getAxisLabel(double value, TitleMeta meta) {
    return Text(xLabels[value.toInt()]);
  }
  List<double> userData = [0, 0, 0]; // Initialize with zeros

  @override
  void initState() {
    super.initState();
    fetchDataFromAPI();
  }

  Future<void> fetchDataFromAPI() async {

    var request = http.Request('GET', Uri.parse((global.url)+'/count/'));
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final jsonData = json.decode(responseBody);

        if (jsonData is List<dynamic>) {
          final list = jsonData.map((value) => (value is num) ? value.toDouble() : 0.0).toList();
          print(list);
          setState(() {
            userData = list;
          });
        }
    }
    else {
      print(response.reasonPhrase);
    }

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'User Statistics',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Container(
                height: 400, // Adjust the height as needed
                child: BarChart(
                  BarChartData(
                    // Customize your chart data here.
                    gridData: FlGridData(show: false),
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(
                        color: const Color(0xff37434d),
                        width: 1,
                      ),
                    ),
                    barTouchData: BarTouchData(
                      touchTooltipData: BarTouchTooltipData(
                        tooltipBgColor: Colors.white,
                      ),
                    ),

                    minY: 0,
                    maxY: userData.reduce((a, b) => a > b ? a : b) + 10,
                    groupsSpace: 12,
                    titlesData: FlTitlesData(
                        show: true,
                        leftTitles: AxisTitles(sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                        ),),
                        bottomTitles: AxisTitles(sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: getAxisLabel,
                        ),),
                        topTitles: AxisTitles(sideTitles: SideTitles(
                          showTitles: false,

                        ),),
                        rightTitles: AxisTitles(sideTitles: SideTitles(
                          showTitles: false,

                        ),)
                    ),
                    barGroups: [
                      BarChartGroupData(
                        x: 0,
                        barRods: [
                          BarChartRodData(
                            toY: userData[0],
                            color: Colors.blue,
                          ),
                        ],
                        showingTooltipIndicators: [0],
                      ),
                      BarChartGroupData(
                        x: 1,
                        barRods: [
                          BarChartRodData(
                            toY: userData[1],
                            color: Colors.green,
                          ),
                        ],
                        showingTooltipIndicators: [0],
                      ),
                      BarChartGroupData(
                        x: 2,
                        barRods: [
                          BarChartRodData(
                            toY: userData[2],
                            color: Colors.orange,
                          ),
                        ],
                        showingTooltipIndicators: [0],
                      ),

                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }}