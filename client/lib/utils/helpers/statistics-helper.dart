import 'package:covid19/covid19.dart';

/// A helper class to manage provising covid statisitics
class StatisticsHelper {
  static Future<String> getStatistics() async {
    var covid19Client = Covid19Client();
    var summary = await covid19Client.getSummary();
    var live = await covid19Client.getLive(country: 'Australia');
    var auTotalConfirmed_ = await covid19Client.getDayOneTotal(
        country: 'Australia', status: 'confirmed');
    var auTotalRecovered_ = await covid19Client.getDayOneTotal(
        country: 'Australia', status: 'recovered');
    var auTotalDeaths_ = await covid19Client.getDayOneTotal(
        country: 'Australia', status: 'deaths');

    return Future.value('\n'
        'Australia Active cases: ${live[live.length - 1].active.toString()}\n'
        'Australia Total confirmed: ${auTotalConfirmed_[auTotalConfirmed_.length - 1].cases.toString()}\n'
        'Australia Total recovered: ${auTotalRecovered_[auTotalRecovered_.length - 1].cases.toString()}\n'
        'Australia Total deaths: ${auTotalDeaths_[auTotalDeaths_.length - 1].cases.toString()}\n'
        'Global New confirmed: ${summary.global.newConfirmed.toString()}\n'
        'Global New recovered: ${summary.global.newRecovered.toString()}\n'
        'Global New deaths: ${summary.global.newDeaths.toString()}\n'
        'Global Total confirmed: ${summary.global.totalConfirmed.toString()}\n'
        'Global Total recovered: ${summary.global.totalRecovered.toString()}\n'
        'Global Total deaths: ${summary.global.totalDeaths.toString()}\n');
  }
}
