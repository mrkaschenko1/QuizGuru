import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class UserStatistics extends StatelessWidget {
  final int current;
  final int total;
  final String annotation;
  final bool isPercent;

  const UserStatistics(
      {Key key, this.current, this.total, this.annotation, this.isPercent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SfRadialGauge(
      axes: <RadialAxis>[
        RadialAxis(
            minimum: 0,
            maximum: total.toDouble(),
            startAngle: 270,
            endAngle: 270,
            showLabels: false,
            showTicks: false,
            radiusFactor: 1.0,
            axisLineStyle: AxisLineStyle(
                cornerStyle: CornerStyle.bothFlat,
                color: Colors.black12,
                thickness: 16),
            pointers: <GaugePointer>[
              RangePointer(
                value: current.toDouble(),
                cornerStyle: CornerStyle.bothCurve,
                width: 16,
                sizeUnit: GaugeSizeUnit.logicalPixel,
                color: Color(0xFFFE9D81),
              ),
            ],
            annotations: [
              GaugeAnnotation(
                  angle: 90,
                  axisValue: 5,
                  positionFactor: 0.1,
                  widget: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                          isPercent
                              ? ((current / total) * 100).ceil().toString() +
                                  '%'
                              : '$current/$total',
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: Colors.black)),
                      Text(
                        annotation,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black),
                      )
                    ],
                  ))
            ]),
      ],
      enableLoadingAnimation: true,
      animationDuration: 1500,
    );
  }
}
