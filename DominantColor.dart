import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as imageLib;

class DominantColorsService {
  final Uint8List bytes;
  final int dominantColorsCount;

  DominantColorsService({required this.bytes, this.dominantColorsCount = 2});

  double distance(Color a, Color b) {
    return sqrt(pow(a.red - b.red, 2) + pow(a.green - b.green, 2) + pow(a.blue - b.blue, 2));
  }

  List<Color> initializeCentroids(List<Color> colors) {
    final random = Random();
    List<Color> centroids = [colors[random.nextInt(10)]];

    for (int i = 1; i < dominantColorsCount; i++) {
      List<double> distances = colors.map((color) {
        return centroids.map((centroid) => distance(color, centroid)).reduce(min);
      }).toList();

      double sum = distances.reduce((a, b) => a + b);
      double r = random.nextDouble() * sum;

      double accumulatedDistance = 0.0;
      for (int j = 0; j < colors.length; j++) {
        accumulatedDistance += distances[j];
        if (accumulatedDistance >= r) {
          centroids.add(colors[j]);
          break;
        }
      }
    }

    return centroids;
  }

  List<Color> extractDominantColors() {
    List<Color> colors = _getPixelsColorsFromImage();
    List<Color> centroids = initializeCentroids(colors);
    List<Color> oldCentroids = [];

    while (_isConverging(centroids, oldCentroids)) {
      oldCentroids = List.from(centroids);
      List<List<Color>> clusters = List.generate(dominantColorsCount, (_) => []);

      for (var color in colors) {
        int closestIndex = _findClosestCentroid(color, centroids);
        clusters[closestIndex].add(color);
      }

      for (int i = 0; i < dominantColorsCount; i++) {
        centroids[i] = _averageColor(clusters[i]);
      }
    }

    return centroids;
  }

  List<Color> _getPixelsColorsFromImage() {
    List<Color> colors = [];
    imageLib.Image? image = imageLib.decodeImage(bytes);
    if (image != null) {
      for (int y = 0; y < image.height; y += 10) {
        for (int x = 0; x < image.width; x += 10) {
          var pixel = image.getPixel(x, y);
          colors.add(Color.fromARGB(pixel.a.toInt(), pixel.r.toInt(), pixel.g.toInt(), pixel.b.toInt()));
        }
      }
    }
    return colors;
  }

  bool _isConverging(List<Color> centroids, List<Color> oldCentroids) {
    if (oldCentroids.isEmpty) return true;
    for (int i = 0; i < centroids.length; i++) {
      if (centroids[i] != oldCentroids[i]) return true;
    }
    return false;
  }

  int _findClosestCentroid(Color color, List<Color> centroids) {
    int minIndex = 0;
    double minDistance = distance(color, centroids[0]);
    for (int i = 1; i < centroids.length; i++) {
      double dist = distance(color, centroids[i]);
      if (dist < minDistance) {
        minDistance = dist;
        minIndex = i;
      }
    }
    return minIndex;
  }

  Color _averageColor(List<Color> colors) {
    int r = 0, g = 0, b = 0;
    for (var color in colors) {
      r += color.red;
      g += color.green;
      b += color.blue;
    }
    int length = colors.length;
    r = r ~/ length;
    g = g ~/ length;
    b = b ~/ length;
    return Color.fromRGBO(r, g, b, 1);
  }
}
