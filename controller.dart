import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:obuna/models/BooksModel.dart';
import 'package:obuna/services/CacheService.dart';
import 'package:obuna/services/StorageService.dart';
import 'package:http/http.dart' as http;
import '../../../services/DominantColor.dart';

class DetailsController extends GetxController with GetTickerProviderStateMixin {
  StorageService storageService = Get.find<StorageService>();
  CacheService cacheService = Get.find<CacheService>();
  Rx<BooksModel?> book = Rx(null);

  late TabController tabController;
  final activeIndex = 0.obs;
  var isExpanded = false.obs;
  final int initialTextLength = 200;
  final String longText = 'This is a very long text that might not fit within a single line or even a few lines of text. '
      'You might want to show only a portion of this text initially and provide an option to show more. '
      'When the user clicks on the "Show more" button, the full text should be displayed. '
      'Similarly, clicking on "Show less" will collapse the text back to its shortened form.';

  final List<String> tabs = [
    "characteristics",
    "description",
  ];

  ScrollController? scrollController;
  var isShrink = false.obs;
  var dominantColor = Colors.transparent.obs;
  var secondaryColor = Colors.transparent.obs;

  @override
  void onInit() {
    super.onInit();
    scrollController = ScrollController()..addListener(scrollListener);
    load();
  }

  Future<void> extractDominantColorsFromImage(String imageUrl) async {
    try {
      var response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {

        Uint8List imageBytes = response.bodyBytes;
        DominantColorsService extractor = DominantColorsService(bytes: imageBytes, dominantColorsCount: 2);
        List<Color> colors = extractor.extractDominantColors();

        dominantColor.value = colors.isNotEmpty ? colors[0] : Colors.transparent;
        secondaryColor.value = colors.length > 1 ? colors[1] : Colors.transparent;
      }
    } catch (e) {
      print("Error extracting colors: $e");
    }
  }

  void load() {
    if (Get.arguments != null) {
      book.value = Get.arguments['books'];
      if (book.value?.imgUrl != null) {
        extractDominantColorsFromImage(book.value!.imgUrl!);
      }
    }
    tabController = TabController(length: tabs.length, vsync: this);
    tabController.addListener(() {
      activeIndex.value = tabController.index;
      super.onInit();
    });
  }

  void scrollListener() {
    isShrink.value = scrollController != null && scrollController!.hasClients && scrollController!.offset > 250;
  }

  void toggleExpanded() {
    isExpanded.value = !isExpanded.value;
  }

  void saveBasket() {
    if (book.value != null) {
      book.value!.isBasket = !book.value!.isBasket;
      book.refresh();
      cacheService.booksList.refresh();
    }
  }

  @override
  void onClose() {
    scrollController?.dispose();
    super.onClose();
  }
}
