import 'dart:ui';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:obuna/AppRoutes.dart';
import 'package:obuna/config/Config.dart';
import 'package:obuna/pages/dashboard/views/BookCategoryView.dart';
import 'package:obuna/pages/details/controllers/controller.dart';
import 'package:obuna/pages/details/views/TabBarView.dart';
import 'package:obuna/widgets/CustomContainer.dart';
import 'package:obuna/widgets/CustomNetworkImg.dart';
import 'package:obuna/widgets/TabBarWidget.dart';
import 'SelectSubscription.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<DetailsController>();
    controller.load();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(
        () => NestedScrollView(
          controller: controller.scrollController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverAppBar(
                flexibleSpace: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return FlexibleSpaceBar(
                      collapseMode: CollapseMode.parallax,
                      background: Stack(
                        clipBehavior: Clip.hardEdge,
                        children: [
                          Obx(
                            () => AnimatedContainer(
                              duration: const Duration(milliseconds: 1000),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    controller.dominantColor.value.withOpacity(0.7),
                                    controller.secondaryColor.value.withOpacity(0.7),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: CustomNetworkImage(
                              height: 210,
                              width: 164,
                              imgUrl: controller.book.value?.imgUrl ?? "",
                              imageFit: BoxFit.fill,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                expandedHeight: 330,
                automaticallyImplyLeading: false,
                centerTitle: true,
                elevation: 0,
                pinned: true,
                floating: true,
                leading: IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(60),
                  child: Container(
                    height: 60,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                      color: Colors.white,
                    ),
                    child: Obx(
                      () => Stack(
                        children: [
                          controller.isShrink.value
                              ? Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 4.0),
                                    child: IconButton(
                                      onPressed: () {
                                        Get.back();
                                        controller.isShrink.value = false;
                                      },
                                      icon: const Icon(
                                        Icons.arrow_back_ios, color: Colors.black,
                                        // size: 22,
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                          controller.isShrink.value
                              ? Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 16),
                                    child: Text(
                                      controller.book.value?.title ?? "",
                                      style: const TextStyle(
                                        color: Config.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 24,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(left: 16, top: 12),
                                  child: Text(
                                    controller.book.value?.title ?? "",
                                    style: const TextStyle(
                                      color: Config.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 24,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ];
          },
          body: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          CustomContainer(
                            borderRadius: 8,
                            width: 123,
                            padding: const EdgeInsets.all(5),
                            borderColor: Config.greyBorder,
                            child: Row(
                              children: [
                                SvgPicture.asset("assets/icons/discount.svg"),
                                const SizedBox(width: 2),
                                Text(
                                  " ${controller.book.value?.discount ?? ""}% ",
                                  style: const TextStyle(color: Config.green, fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  "discount".tr,
                                  style: const TextStyle(color: Config.green, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          CustomContainer(
                            width: 62,
                            borderRadius: 8,
                            padding: const EdgeInsets.all(5),
                            borderColor: Config.greyBorder,
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  "assets/icons/star.svg",
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  "4,9".tr,
                                  style: const TextStyle(color: Config.black, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      CustomContainer(
                        maxWidth: 450,
                        margin: const EdgeInsets.symmetric(vertical: 12),
                        color: Config.greyFillColor,
                        borderRadius: 8,
                        padding: const EdgeInsets.all(12),
                        child: Center(
                          child: Row(
                            children: [
                              Text(
                                "${controller.book.value?.price.toString().spaceSeparateNumbers().toString()} ${"sum".tr}",
                                style: const TextStyle(color: Config.black, fontWeight: FontWeight.w600, fontSize: 20),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                "free_delivery".tr,
                                style: const TextStyle(color: Config.greyText, fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Text(
                        "select_subscription_month".tr,
                        style: const TextStyle(
                          color: Config.black,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SelectSubscriptionView(
                        lang: controller.storageService.lang,
                      ),
                      TabBarWidget(
                        tabController: controller.tabController,
                        tabs: controller.tabs,
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: 300),
                        child: TabBarWidgetView(controller: controller),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    CategoryTitle(
                      categoryName: "similar".tr,
                      onTap: () {},
                    ),
                    BooksCategory(
                      onTap: (book) {
                        Get.toNamed("${AppRoutes.DETAILS}/${book.id}", arguments: {"books": book});
                      },
                      model: controller.cacheService.booksList,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Obx(
        () => Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: Colors.white,
          child: SafeArea(
            child: ElevatedButton(
              onPressed: controller.book.value!.isBasket
                  ? null
                  : () {
                      controller.saveBasket();
                    },
              style: ElevatedButton.styleFrom(disabledBackgroundColor: Colors.grey),
              child: Text(
                controller.book.value!.isBasket ? "Savatda bor" : "add_to_cart".tr,
                style: TextStyle(color: controller.book.value!.isBasket ? Colors.black : Colors.white, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

extension StringNumberExtension on String {
  String spaceSeparateNumbers() {
    final result = replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]} ');
    return result;
  }
}
