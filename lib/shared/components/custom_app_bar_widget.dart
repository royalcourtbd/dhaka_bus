import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    this.subTitle,
    this.isRoot = false,
    this.dropDownPath,
    this.actions,
    this.onTap,
    this.backgroundColor,
    this.leading,
    this.centerTitle,
    this.bottom,
    this.titleSpacing,
    this.backIconSize = 20,
    this.backIconColor,
    this.titleStyle,
    this.dropDownIconColor,
    this.dropDownIconSize = 30,
    this.subTitleStyle,
  });

  final String title;
  final bool isRoot;
  final IconData? dropDownPath;
  final List<Widget>? actions;
  final void Function()? onTap;
  final String? subTitle;
  final Color? backgroundColor;
  final Widget? leading;
  final bool? centerTitle;
  final PreferredSizeWidget? bottom;

  final double? titleSpacing;
  final double backIconSize;
  final Color? backIconColor;
  final TextStyle? titleStyle;
  final Color? dropDownIconColor;
  final double dropDownIconSize;
  final TextStyle? subTitleStyle;

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final textStyle = theme.textTheme;
    return AppBar(
      centerTitle: centerTitle ?? false,
      backgroundColor: backgroundColor ?? theme.appBarTheme.backgroundColor,
      titleSpacing: titleSpacing ?? (isRoot ? 18 : 0),
      leading:
          leading ??
          (isRoot
              ? null
              : IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: backIconSize,
                    color: backIconColor,
                  ),
                )),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: onTap,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                LimitedBox(
                  maxWidth: MediaQuery.of(context).size.width * 0.58,
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:
                        titleStyle ??
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ),
                if (dropDownPath != null) ...[
                  const SizedBox(width: 8),
                  Icon(
                    dropDownPath!,
                    size: dropDownIconSize,
                    color: dropDownIconColor,
                  ),
                ],
              ],
            ),
          ),
          if (subTitle != null && subTitle!.isNotEmpty) ...[
            const SizedBox(height: 3),
            Text(
              subTitle!,
              style:
                  subTitleStyle ??
                  textStyle.labelSmall!.copyWith(fontWeight: FontWeight.w400),
            ),
          ],
        ],
      ),
      actions: actions,
      bottom: bottom,
    );
  }
}
