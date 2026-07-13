import 'package:flutter/material.dart';
import '../models/station_info.dart';

/// Unlock order. Completing one unlocks the next; the summit unlocks last.
const List<String> kStationOrder = [
  'station1',
  'station2',
  'station3',
  'station4',
  'station5',
  'summit',
];

const List<StationInfo> kStations = [
  StationInfo(
    key: 'station1',
    order: 1,
    title: 'Moss Quest: Discovering the World of Mosses',
    badgeName: 'Research Beginner Badge',
    color: Color(0xFF2E7D32),
    implemented: true,
    splashAsset: 'assets/images/stations/station_1.png',
    logoAsset: 'assets/images/stations/logo_station1.png',
  ),
  StationInfo(
    key: 'station2',
    order: 2,
    title:
        'Mountain Sampling Expedition: Exploring Elevational Distribution of Mosses',
    badgeName: 'Field Sampling Pathfinder',
    color: Color(0xFF00838F),
    implemented: true,
    splashAsset: 'assets/images/stations/station_2.png',
    logoAsset: 'assets/images/stations/logo_station2.png',
  ),
  StationInfo(
    key: 'station3',
    order: 3,
    title: 'Green Growth Lab: The In Vitro Propagation of Moss',
    badgeName: 'Data Collection Specialist',
    color: Color(0xFF558B2F),
    implemented: true,
    splashAsset: 'assets/images/stations/station_3.png',
    logoAsset: 'assets/images/stations/logo_station3.png',
  ),
  StationInfo(
    key: 'station4',
    order: 4,
    title: 'Bioactive Secrets: The Phytochemical Screening of Moss',
    badgeName: 'Bioactive Codebreaker',
    color: Color(0xFF6A1B9A),
    implemented: true,
    splashAsset: 'assets/images/stations/station_4.png',
    logoAsset: 'assets/images/stations/logo_station4.png',
  ),
  StationInfo(
    key: 'station5',
    order: 5,
    title: 'Defense Mission: The Antibacterial Assay of Moss',
    badgeName: 'Data Decoding Master',
    color: Color(0xFFC62828),
    implemented: true,
    splashAsset: 'assets/images/stations/station_5.png',
    logoAsset: 'assets/images/stations/logo_station5.png',
  ),
];

StationInfo stationByKey(String key) =>
    kStations.firstWhere((s) => s.key == key);

/// Hub route for a station: splash when a title card exists, otherwise intro.
String stationHubRoute(String key) {
  final info = stationByKey(key);
  if (info.splashAsset != null) return '/station/$key/splash';
  return '/station/$key/intro';
}

String? nextStationKey(String key) {
  final i = kStationOrder.indexOf(key);
  if (i < 0 || i + 1 >= kStationOrder.length) return null;
  return kStationOrder[i + 1];
}
