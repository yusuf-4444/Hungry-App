import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hungry_app/shared/custom_text.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CustomToppingsSideOptionsWidget extends StatefulWidget {
  const CustomToppingsSideOptionsWidget({
    super.key,
    required this.data,
    required this.isLoading,
    required this.selectedItems,
    required this.onItemSelection,
  });

  final dynamic data;
  final bool isLoading;
  final List<int>? selectedItems;
  final Function(int) onItemSelection;

  @override
  State<CustomToppingsSideOptionsWidget> createState() =>
      _CustomToppingsSideOptionsWidgetState();
}

class _CustomToppingsSideOptionsWidgetState
    extends State<CustomToppingsSideOptionsWidget> {
  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: widget.isLoading,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(
            widget.isLoading ? 4 : (widget.data?.data?.length ?? 0),
            (index) {
              final item = widget.isLoading ? null : widget.data?.data?[index];
              final itemId = item?.id;
              final isSelected =
                  widget.selectedItems?.contains(itemId ?? -1) ?? false;

              return Padding(
                padding: EdgeInsets.only(right: 20.w),
                child: GestureDetector(
                  onTap: () {
                    if (!widget.isLoading && itemId != null) {
                      widget.onItemSelection(itemId);
                      setState(() {});
                    }
                  },
                  child: Stack(
                    children: [
                      Material(
                        elevation: 4,
                        child: Container(
                          height: 110.h,
                          width: 100.w,
                          decoration: BoxDecoration(
                            color: const Color(0xff3C2F2F),
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: 10.w,
                              right: 10.w,
                              top: 20.h,
                              bottom: 18.h,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                CustomText(
                                  text: !widget.isLoading && item?.name != null
                                      ? item!.name
                                      : "Loading...",
                                  color: Colors.white,
                                  fontSize: 12.sp,
                                ),
                                const Spacer(),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                  child: Icon(
                                    isSelected ? Icons.remove : Icons.add,
                                    color: Colors.white,
                                    size: 20.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(15.r),
                              bottomRight: Radius.circular(15.r),
                            ),
                          ),
                          child: !widget.isLoading && item?.image != null
                              ? CachedNetworkImage(
                                  imageUrl: item!.image,
                                  height: 60.h,
                                  width: 60.w,
                                  fit: BoxFit.contain,
                                  errorWidget: (context, url, error) => Icon(
                                    Icons.error,
                                    color: Colors.red,
                                    size: 30.sp,
                                  ),
                                  placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator.adaptive(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.black,
                                      ),
                                    ),
                                  ),
                                )
                              : Image.asset(
                                  "assets/details/pngwing 15.png",
                                  height: 60.h,
                                  width: 60.w,
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
