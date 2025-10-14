import 'package:flutter/material.dart';

class ListHeader extends StatelessWidget {
  final String title;
  final String? subTitle;

  const ListHeader({super.key, required this.title, this.subTitle});

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.titleLarge;

    return Container(
      padding: EdgeInsets.only(top: 10, bottom: (subTitle == null) ? 5 : 0),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: titleStyle),

          if (subTitle != null)
            FilledButton.tonal(
              style: ButtonStyle(
                visualDensity: VisualDensity.compact,
                padding: WidgetStateProperty.all(
                  EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
              onPressed: () {},
              child: Text(subTitle!),
            ),
        ],
      ),
    );
  }
}
