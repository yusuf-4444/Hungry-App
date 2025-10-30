import 'package:flutter/material.dart';
import 'package:hungry_app/shared/custom_text.dart';

class CustomToppingsSideOptionsWidget extends StatelessWidget {
  const CustomToppingsSideOptionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(5, (index) {
          return Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Stack(
              children: [
                Container(
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
                          text: "Tomato",
                          color: Colors.white,
                          fontsize: 12,
                        ),
                        Spacer(),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(Icons.add, color: Colors.white, size: 20),
                        ),
                      ],
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
                    child: Image.asset(
                      "assets/details/pngwing 15.png",
                      height: 60,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
