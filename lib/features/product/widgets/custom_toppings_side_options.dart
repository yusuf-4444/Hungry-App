import 'package:flutter/material.dart';
import 'package:hungry_app/shared/custom_text.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CustomToppingsSideOptionsWidget extends StatelessWidget {
  const CustomToppingsSideOptionsWidget({
    super.key,
    required this.data,
    required this.isLoading,
    required this.selectedItems,
    required this.onItemSelection,
  });

  final dynamic data;
  final bool isLoading;
  final List<int> selectedItems;
  final Function(int) onItemSelection;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: isLoading,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(isLoading ? 4 : (data?.data.length ?? 0), (
            index,
          ) {
            final item = isLoading ? null : data.data[index];
            final isSelected = selectedItems.contains(item.id);
            return Padding(
              padding: const EdgeInsets.only(right: 20),
              child: GestureDetector(
                onTap: () {
                  onItemSelection(item.id);
                },
                child: Stack(
                  children: [
                    Material(
                      color: isSelected ? Colors.blue : null,
                      elevation: 4,
                      child: Container(
                        height: 110,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Color(0xff3C2F2F),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 10,
                            right: 10,
                            top: 20,
                            bottom: 18,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              CustomText(
                                text: !isLoading
                                    ? data.data[index].name
                                    : "tomato",
                                color: Colors.white,
                                fontsize: 12,
                              ),
                              Spacer(),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 20,
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
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                          ),
                        ),
                        child: !isLoading
                            ? Image.network(data.data[index].image, height: 60)
                            : Image.asset(
                                "assets/details/pngwing 15.png",
                                height: 60,
                                width: 60,
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
