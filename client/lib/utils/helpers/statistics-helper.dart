import 'package:covid19/covid19.dart';

/// A helper class to manage provising covid statisitics
class StatisticsHelper {
  static Future<String> getStatistics() async {
    var covid19Client = Covid19Client();
    var summary = await covid19Client.getSummary();
    var auTotalConfirmed_ = await covid19Client.getDayOneTotal(
        country: 'Australia', status: 'confirmed');
    var auTotalRecovered_ = await covid19Client.getDayOneTotal(
        country: 'Australia', status: 'recovered');
    var auTotalDeaths_ = await covid19Client.getDayOneTotal(
        country: 'Australia', status: 'deaths');
    var live = await covid19Client.getLive(country: 'Australia');
    String auActiveCases = live[live.length - 1].active.toString();
    String auTotalConfirmed =
        auTotalConfirmed_[auTotalConfirmed_.length - 1].cases.toString();
    String auTotalRecovered =
        auTotalRecovered_[auTotalRecovered_.length - 1].cases.toString();
    String auTotalDeaths =
        auTotalDeaths_[auTotalDeaths_.length - 1].cases.toString();
    String globalNewConfirmed = summary.global.newConfirmed.toString();
    String globalNewRecovered = summary.global.newRecovered.toString();
    String globalNewDeaths = summary.global.newDeaths.toString();
    String globalTotalConfirmed = summary.global.totalConfirmed.toString();
    String globalTotalRecovered = summary.global.totalRecovered.toString();
    String globalTotalDeaths = summary.global.totalDeaths.toString();

    return Future.value('\n'
        'Australia Active cases: ${auActiveCases}\n'
        'Australia Total confirmed: ${auTotalConfirmed}\n'
        'Australia Total recovered: ${auTotalRecovered}\n'
        'Australia Total deaths: ${auTotalDeaths}\n'
        'Global New confirmed: ${globalNewConfirmed}\n'
        'Global New recovered: ${globalNewRecovered}\n'
        'Global New deaths: ${globalNewDeaths}\n'
        'Global Total confirmed: ${globalTotalConfirmed}\n'
        'Global Total recovered: ${globalTotalRecovered}\n'
        'Global Total deaths: ${globalTotalDeaths}\n');
  }
}
