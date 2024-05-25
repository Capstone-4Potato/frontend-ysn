// 중성 탭 위젯
import 'package:flutter/material.dart';
import 'package:flutter_application_1/class.dart';

class ReviewWordVowelTab extends StatefulWidget {
  const ReviewWordVowelTab({super.key});

  @override
  State<ReviewWordVowelTab> createState() => _ReviewWordVowelTabState();
}

class _ReviewWordVowelTabState extends State<ReviewWordVowelTab> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(15),
      itemCount: 3,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 6 / 4,
      ),
      itemBuilder: (context, index) {
        return _buildWordCard(context, CategoryLists.wordVowels[index]);
      },
    );
  }

  Widget _buildWordCard(BuildContext context, String title) {
    // final Map<String, Widget Function()> navigationMap = {
    //   CategoryLists.wordVowels[0]: () => const ReviewVowel1(),
    //   CategoryLists.wordVowels[1]: () => const ReviewVowel2(),
    //   CategoryLists.wordVowels[2]: () => const ReviewVowel3(),
    // };

    return Card(
      elevation: 0, // 그림자 제거
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(
          color: Color(0xfff26647),
          width: 1.2,
        ),
      ),
      child: InkWell(
        onTap: () {
          // if (navigationMap.containsKey(title)) {
          //   Navigator.push(
          //     context,
          //     MaterialPageRoute(builder: (context) => navigationMap[title]!()),
          //   );
          // }
        },
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff525252),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
