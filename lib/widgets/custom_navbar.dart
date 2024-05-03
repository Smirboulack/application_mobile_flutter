import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sevenapplication/utils/colors_app.dart';
import 'package:sevenapplication/utils/images.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sevenapplication/utils/styles.dart';
import 'package:sevenapplication/widgets/custom_navbar_item.dart';

class CustomNavBar extends StatefulWidget {
  const CustomNavBar({
    Key? key,
    required this.currentIndex,
    required this.items,
    this.height = 60,
    this.onItemSelected,
  }) : super(key: key);

  final int currentIndex;
  final double height;
  final ValueChanged<int>? onItemSelected;
  final List<Map<String, String>> items;

  @override
  State<CustomNavBar> createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<CustomNavBar> {
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.currentIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(12.w),
      height: 58.h,
      decoration: StylesApp.decorationNav,
      child: SizedBox(
        width: double.infinity,
        height: widget.height,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: widget.items
                .map((Map<String, String> e) => Flexible(
                      child: InkWell(
                        onTap: () {
                          if (widget.onItemSelected != null)
                            widget.onItemSelected!(widget.items.indexOf(e));
                          currentIndex = widget.items.indexOf(e);
                          setState(() {});
                        },
                        child: CustomNavItem(
                          text: e["name"]!,
                          isSelected: currentIndex == widget.items.indexOf(e),
                          icon: SvgPicture.asset(
                            e["icon"]!,
                            height: currentIndex == widget.items.indexOf(e)
                                ? 20.w
                                : 16.w,
                            width: currentIndex == widget.items.indexOf(e)
                                ? 20.w
                                : 16.w,
                            color: currentIndex == widget.items.indexOf(e)
                                ? ColorsConst.col_wite
                                : ColorsConst.col_app_black.withOpacity(0.3),
                          ),
                          unselectedColor:
                              ColorsConst.col_app_black.withOpacity(0.3),
                          selectedColor: ColorsConst.col_wite,
                        ),
                      ),
                    ))
                .toList() /*[
            Flexible(
              child: InkWell(
                onTap: () {
                  if (widget.onItemSelected != null) widget.onItemSelected!(0);
                  currentIndex = 0;
                  setState(() {});
                },
                child: CustomNavItem(
                  text: ,
                  isSelected: currentIndex == 0,
                  icon: SvgPicture.asset(
                    AppImages.home,
                    height: currentIndex == 0 ? 20.w : 16.w,
                    width: currentIndex == 0 ? 20.w : 16.w,
                    color: currentIndex == 0
                        ? ColorsConst.col_wite
                        : ColorsConst.col_app_black.withOpacity(0.3),
                  ),
                  unselectedColor: ColorsConst.col_app_black.withOpacity(0.3),
                  selectedColor: ColorsConst.col_wite,
                ),
              ),
            ),
            Flexible(
              child: InkWell(
                onTap: () {
                  if (widget.onItemSelected != null) widget.onItemSelected!(1);
                  currentIndex = 1;
                  setState(() {});
                },
                child: CustomNavItem(
                  text: "Offres",
                  isSelected: currentIndex == 1,
                  icon: SvgPicture.asset(
                    AppImages.offer,
                    height: currentIndex == 1 ? 20.w : 16.w,
                    width: currentIndex == 1 ? 20.w : 16.w,
                    color: currentIndex == 1
                        ? ColorsConst.col_wite
                        : ColorsConst.col_app_black.withOpacity(0.3),
                  ),
                  unselectedColor: ColorsConst.col_app_black.withOpacity(0.3),
                  selectedColor: ColorsConst.col_wite,
                ),
              ),
            ),
            Flexible(
              child: InkWell(
                onTap: () {
                  if (widget.onItemSelected != null) widget.onItemSelected!(2);
                  currentIndex = 2;
                  setState(() {});
                },
                child: CustomNavItem(
                  text: "Mes missions",
                  isSelected: currentIndex == 2,
                  icon: SvgPicture.asset(
                    AppImages.missions,
                    height: currentIndex == 2 ? 20.w : 16.w,
                    width: currentIndex == 2 ? 20.w : 16.w,
                    color: currentIndex == 2
                        ? ColorsConst.col_wite
                        : ColorsConst.col_app_black.withOpacity(0.3),
                  ),
                  unselectedColor: ColorsConst.col_app_black.withOpacity(0.3),
                  selectedColor: ColorsConst.col_wite,
                ),
              ),
            ),
            Flexible(
              child: InkWell(
                onTap: () {
                  if (widget.onItemSelected != null) widget.onItemSelected!(3);
                  currentIndex = 3;
                  setState(() {});
                },
                child: CustomNavItem(
                  text: "Paramètres",
                  isSelected: currentIndex == 3,
                  icon: SvgPicture.asset(
                    AppImages.params,
                    height: currentIndex == 3 ? 20.w : 16.w,
                    width: currentIndex == 3 ? 20.w : 16.w,
                    color: currentIndex == 3
                        ? ColorsConst.col_wite
                        : ColorsConst.col_app_black.withOpacity(0.3),
                  ),
                  unselectedColor: ColorsConst.col_app_black.withOpacity(0.3),
                  selectedColor: ColorsConst.col_wite,
                ),
              ),
            ),
          ],*/
            ),
      ),
    );
  }
}
