import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:aivoiceweather/main.dart';
import 'package:aivoiceweather/model/weather.dart';
import 'package:aivoiceweather/widgets/current_conditions.dart';
import 'package:aivoiceweather/widgets/empty_widget.dart';
import 'package:aivoiceweather/widgets/temperature_line_chart.dart';

class WeatherSwipePager extends StatelessWidget {
  const WeatherSwipePager({
    Key key,
    @required this.weather,
  }) : super(key: key);

  final Weather weather;

  @override
  Widget build(BuildContext context) {
    ThemeData appTheme = AppStateContainer.of(context).theme;

    return Container(
      width: MediaQuery.of(context).size.width,
      height: 300,
      child: Swiper(
        itemCount: 2,
        index: 0,
        itemBuilder: (context, index) {
          if (index == 0) {
            return CurrentConditions(
              weather: weather,
            );
          } else if (index == 1) {
            return TemperatureLineChart(
              weather.forecast,
              animate: true,
            );
          }
          return EmptyWidget();
        },
        pagination: new SwiperPagination(
          margin: new EdgeInsets.all(5.0),
          builder: new DotSwiperPaginationBuilder(
              size: 5,
              activeSize: 5,
              color: AppStateContainer.of(context)
                  .theme
                  .accentColor
                  .withOpacity(0.4),
              activeColor: appTheme.accentColor),
        ),
      ),
    );
  }
}
