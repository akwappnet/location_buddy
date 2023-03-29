// ignore_for_file: unused_element

import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:background_locator_2/location_dto.dart';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_buddy/provider/live_traking_view_provider.dart';
import 'package:location_buddy/provider/save_location_view_provider.dart';
import 'package:location_buddy/utils/colors/colors.dart';
import 'package:location_buddy/utils/constants.dart';
import 'package:location_buddy/utils/font/font_family.dart';
import 'package:location_buddy/widgets/loading_map.dart';
import 'package:provider/provider.dart';
import '../localization/app_localization.dart';
import '../models/location_data_navigate.dart';
import '../services/location_service_repository.dart';
import '../widgets/custom_button_widget.dart';

class LiveTrackingPage extends StatefulWidget {
  const LiveTrackingPage({super.key});

  @override
  State<LiveTrackingPage> createState() => _LiveTrackingPageState();
}

class _LiveTrackingPageState extends State<LiveTrackingPage> {
  ReceivePort port = ReceivePort();
  LocationDto? currentLocation;

  LocationData? _destination;
  final Completer<GoogleMapController> _controller = Completer();

//  static const LatLng destination = LatLng(23.0802, 72.5244);
  //store sourceLocation to destination location point to draw line

  final Set<Polyline> _polylines = {};
  final List<LatLng> _polylineCoordinates = [];
  String? length;

  PolylineId? _polylineId;

  @override
  void initState() {
    super.initState();

    _destination = Provider.of<LiveTrackingViewProvider>(context, listen: false)
        .locationData;
    // log('Latitude: ${_destination!.latitude}');
    // log('Longitude: ${_destination!.longitude}');
    if (IsolateNameServer.lookupPortByName(
            LocationServiceRepository.isolateName) !=
        null) {
      IsolateNameServer.removePortNameMapping(
          LocationServiceRepository.isolateName);
    }
    IsolateNameServer.registerPortWithName(
        port.sendPort, LocationServiceRepository.isolateName);
    port.listen(
      (dynamic data) async {
        await updateUI(data);
      },
    );
    Provider.of<SaveLocationViewProvider>(context, listen: false)
        .initPlatformState();

    Provider.of<SaveLocationViewProvider>(context, listen: false)
        .onStart(context);

    Provider.of<LiveTrackingViewProvider>(context, listen: false)
        .setCustomMarkerIcon();
  }

  @override
  void dispose() {
    Provider.of<SaveLocationViewProvider>(context, listen: false)
        .onStop(context);
    super.dispose();
  }

  Future<void> updateUI(dynamic data) async {
    LocationDto? locationDto =
        (data != null) ? LocationDto.fromJson(data) : null;

    setState(() {
      if (data != null) {
        currentLocation = locationDto;
      }
    });

    GoogleMapController googleMapController = await _controller.future;
    _updatePolyline(googleMapController);

    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(min(currentLocation!.latitude, _destination!.latitude),
          min(currentLocation!.longitude, _destination!.longitude)),
      northeast: LatLng(max(currentLocation!.latitude, _destination!.latitude),
          max(currentLocation!.longitude, _destination!.longitude)),
    );

    googleMapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
  }

//   // Function to calculate the distance between two LatLng points using Haversine formula

  double _distanceBetween(LatLng point1, LatLng point2) {
    const int earthRadius = 6371000; // in meters
    double lat1 = point1.latitude * (pi / 180);
    double lon1 = point1.longitude * (pi / 180);
    double lat2 = point2.latitude * (pi / 180);
    double lon2 = point2.longitude * (pi / 180);
    double dLat = lat2 - lat1;
    double dLon = lon2 - lon1;
    double a =
        pow(sin(dLat / 2), 2) + cos(lat1) * cos(lat2) * pow(sin(dLon / 2), 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = earthRadius * c;
    return distance;
  }

/* 

Future<List<LatLng>> getShortestPath(
    LatLng start,
    LatLng destination,
    Function(Map<LatLng, List<LatLng>>) onGraphCreated,
) async {
  PolylinePoints polylinePoints = PolylinePoints();
  PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
    google_api_key,
    PointLatLng(start.latitude, start.longitude),
    PointLatLng(destination.latitude, destination.longitude),
  );
  print('Retrieved polyline with ${result.points.length} points');

  Map<LatLng, List<LatLng>> graph = {};
  for (int i = 0; i < result.points.length - 1; i++) {
    LatLng node = LatLng(result.points[i].latitude, result.points[i].longitude);
    if (!graph.containsKey(node)) {
      graph[node] = [];
    }
    for (int j = i + 1; j < result.points.length; j++) {
      LatLng neighbor = LatLng(result.points[j].latitude, result.points[j].longitude);
      double distance = _distanceBetween(node, neighbor);
      print('Distance between $node and $neighbor: $distance');
      if (distance <= 3000) {
        if (!graph.containsKey(node)) {
          graph[node] = [];
        }
        graph[node]!.add(neighbor);
        if (!graph.containsKey(neighbor)) {
          graph[neighbor] = [];
        }
        graph[neighbor]!.add(node);
      }
    }
  }

  // Add start and destination nodes to graph if they are not already present
  if (!graph.containsKey(start)) {
    graph[start] = [];
  }
  if (!graph.containsKey(destination)) {
    graph[destination] = [];
  }

  print('Created graph with ${graph.length} nodes');
  onGraphCreated(graph);

  Map<LatLng, double> distances = {};
  Map<LatLng, LatLng> previous = {};
  PriorityQueue<LatLng> queue = PriorityQueue(
    (a, b) => (distances[a] ?? double.infinity).compareTo((distances[b] ?? double.infinity)),
  );

  // Set initial distances and add start node to queue
  distances[start] = 0;
  queue.add(start);

  while (queue.isNotEmpty) {
    LatLng current = queue.removeFirst();
    if (current == destination) {
      break;
    }
    for (LatLng neighbor in graph[current]!) {
      double distance = _distanceBetween(current, neighbor);
      double tentativeDistance = (distances[current] ?? double.infinity) +
          distance +
          _distanceBetween(neighbor, destination);
      if ((distances[neighbor] ?? double.infinity) > tentativeDistance) {
        distances[neighbor] = tentativeDistance;
        previous[neighbor] = current;
        if (queue.contains(neighbor)) {
          queue.remove(neighbor);
          queue.add(neighbor);
        } else {
          queue.add(neighbor);
        }
      }
    }
  }

  // Build the path by following the previous nodes from the destination to the start
  List<LatLng> path = [destination];
  LatLng current = destination;
  while (previous[current] != null) {
    path.insert(0, previous[current]!);
    current = previous[current]!;
  }

  print('Found shortest path with ${path.length} points');
  return path;
}
 */

  // void _updatePolyline(GoogleMapController controller) async {
  //   if (currentLocation != null && _destination != null) {
  //     List<LatLng> path = await getShortestPath(
  //         LatLng(currentLocation!.latitude, currentLocation!.longitude),
  //         LatLng(_destination!.latitude, _destination!.longitude), (graph) {
  //       // You can use this optional callback to access the graph if needed
  //     });
  //     if (path.isNotEmpty) {
  //       _polylineCoordinates.clear();
  //       for (var point in path) {
  //         _polylineCoordinates.add(LatLng(point.latitude, point.longitude));
  //       }
  //       print('Polyline Coordinates: $_polylineCoordinates');
  //     }
  //     setState(() {
  //       if (_polylineId != null) {
  //         _polylines.removeWhere(
  //             (Polyline polyline) => polyline.polylineId == _polylineId);
  //       }
  //       _polylineId = const PolylineId('route');
  //       _polylines.add(Polyline(
  //         width: 5,
  //         polylineId: _polylineId!,
  //         color: CustomColor.Violet,
  //         points: path,
  //         visible: true,
  //       ));
  //       print('Polylines: $_polylineCoordinates');
  //     });
  //   }
  // }

  void _updatePolyline(GoogleMapController controller) async {
    if (currentLocation != null) {
      PolylinePoints polylinePoints = PolylinePoints();
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
          google_api_key,
          PointLatLng(currentLocation!.latitude, currentLocation!.longitude),
          PointLatLng(_destination!.latitude, _destination!.longitude));
      if (result.points.isNotEmpty) {
        _polylineCoordinates.clear();
        for (var point in result.points) {
          _polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        }

        setState(() {
          if (_polylineId != null) {
            _polylines.removeWhere(
                (Polyline polyline) => polyline.polylineId == _polylineId);
          }
          _polylineId = const PolylineId('route');
          _polylines.add(Polyline(
            width: 3,
            polylineId: _polylineId!,
            color: CustomColor.primaryColor,
            points: _polylineCoordinates,
            visible: true,
          ));
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final liveTrackingViewProvider =
        Provider.of<LiveTrackingViewProvider>(context);
    final stop = GestureDetector(
      onTap: () {
        Provider.of<SaveLocationViewProvider>(context, listen: false)
            .onStop(context);
      },
      child: AppButton(
        height: 50.sp,
        sizes: 20.sp,
        text: AppLocalization.of(context)!.translate('stop-tracking'),
        mycolor: CustomColor.primaryColor,
      ),
    );
    final size = SizedBox(height: 40.h);
    final map = currentLocation == null
        ? SizedBox(
            height: 600.h,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                SizedBox(
                  height: 60.h,
                ),
                const Center(child: Maploading()),
                SizedBox(
                  height: 50.h,
                ),
                Text(
                  AppLocalization.of(context)!.translate('save-button2'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 28.sp,
                      fontFamily: FontFamliyM.SEMIBOLD,
                      color: CustomColor.primaryColor,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 20.h,
                ),
              ],
            ),
          )
        : SizedBox(
            height: 500,
            width: MediaQuery.of(context).size.width,
            child: GoogleMap(
              //myLocationEnabled: true,
              myLocationButtonEnabled: true,
              mapType: MapType.terrain,
              initialCameraPosition: CameraPosition(
                  target: LatLng(
                      currentLocation!.latitude, currentLocation!.longitude),
                  zoom: 16),
              polylines: _polylines,
              markers: {
                Marker(
                    icon: BitmapDescriptor.fromBytes(
                        liveTrackingViewProvider.currentLocationIcon),
                    markerId: const MarkerId("currentLocation"),
                    position: LatLng(
                        currentLocation!.latitude, currentLocation!.longitude)),
                Marker(
                    icon: BitmapDescriptor.fromBytes(
                        liveTrackingViewProvider.destinationIcon),
                    markerId: const MarkerId("destination"),
                    position:
                        LatLng(_destination!.latitude, _destination!.longitude))
              },
              onMapCreated: (mapController) {
                _controller.complete(mapController);
              },
            ),
          );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColor.primaryColor,
        title: Text(
          AppLocalization.of(context)!.translate('live-tracking'),
        ),
      ),
      body: Container(
        color: CustomColor.white,
        width: double.maxFinite,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(22.sp),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[map, size, stop],
          ),
        ),
      ),
    );
  }
}

class PriorityQueue<T> {
  final _heap = <_PriorityQueueEntry<T>>[];

  void add(T value, double priority) {
    final entry = _PriorityQueueEntry(value, priority);
    _heap.add(entry);
    _bubbleUp(_heap.length - 1);
  }

  T removeFirst() {
    final first = _heap.first;
    final last = _heap.removeLast();
    if (_heap.isNotEmpty) {
      _heap[0] = last;
      _bubbleDown(0);
    }
    return first.value;
  }

  bool get isEmpty => _heap.isEmpty;

  void updatePriority(T value, double priority) {
    final index = _heap.indexWhere((entry) => entry.value == value);
    if (index != -1) {
      final entry = _heap[index];
      final newEntry = _PriorityQueueEntry(entry.value, priority);
      _heap[index] = newEntry;
      if (priority < entry.priority) {
        _bubbleUp(index);
      } else {
        _bubbleDown(index);
      }
    }
  }

  void _bubbleUp(int index) {
    final entry = _heap[index];
    while (index > 0) {
      final parentIndex = (index - 1) ~/ 2;
      final parent = _heap[parentIndex];
      if (entry.priority < parent.priority) {
        _heap[index] = parent;
        index = parentIndex;
      } else {
        break;
      }
    }
    _heap[index] = entry;
  }

  void _bubbleDown(int index) {
    final entry = _heap[index];
    final endIndex = _heap.length - 1;
    while (true) {
      final leftChildIndex = 2 * index + 1;
      final rightChildIndex = 2 * index + 2;
      int minChildIndex = leftChildIndex;
      if (minChildIndex > endIndex) {
        break;
      }
      if (rightChildIndex <= endIndex &&
          _heap[rightChildIndex].priority < _heap[leftChildIndex].priority) {
        minChildIndex = rightChildIndex;
      }
      if (_heap[minChildIndex].priority < entry.priority) {
        _heap[index] = _heap[minChildIndex];
        index = minChildIndex;
      } else {
        break;
      }
    }
    _heap[index] = entry;
  }
}

class _PriorityQueueEntry<T> {
  final T value;
  final double priority;

  _PriorityQueueEntry(this.value, this.priority);
}
