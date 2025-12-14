import 'package:flutter/material.dart';

enum TabSwitcherAlignStates {
  left,
  right
}

class IsselTabSwitcher extends StatefulWidget {

  final TabSwitcherAlignStates state;
  final double height;
  final String leftText;
  final String rightText;
  final ValueChanged<TabSwitcherAlignStates> onChanged;
  final Color? color;

  const IsselTabSwitcher({
    super.key,
    required this.state,
    required this.leftText,
    required this.rightText,
    required this.onChanged,
    this.height = 50,
    this.color,
  });

  @override
  State<IsselTabSwitcher> createState() => _IsselTabSwitcherState();
}

class _IsselTabSwitcherState extends State<IsselTabSwitcher> with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }

  void _toggleMovement() {

    TabSwitcherAlignStates? newState;

    if (isLeftAlign()) {
      newState = TabSwitcherAlignStates.right;
    } else {
      newState = TabSwitcherAlignStates.left;
    }

    widget.onChanged.call(newState);
    setState(() {});
  }

  bool isLeftAlign() => widget.state == TabSwitcherAlignStates.left;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TextTheme textTheme = theme.textTheme;
    ColorScheme colorScheme = theme.colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => _toggleMovement(),
        child: Ink(
          height: widget.height,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color:  widget.color ?? colorScheme.surface,
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [

                  // Selected
                  AnimatedAlign(
                    duration: Duration(milliseconds: 250),
                    alignment: isLeftAlign() ? Alignment.centerLeft : Alignment.centerRight,
                    child: Container(
                      width: constraints.maxWidth / 2,
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        borderRadius: BorderRadius.circular(10)
                      ),

                    ),
                  ),

                  // Button Texts
                  Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            widget.leftText,
                            style: textTheme.bodyMedium?.copyWith(
                              color: isLeftAlign() ? colorScheme.onPrimary : colorScheme.outline,
                              fontWeight: isLeftAlign() ? FontWeight.bold : FontWeight.normal
                            ),
                          )
                        )
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            widget.rightText,
                            style: textTheme.bodyMedium?.copyWith(
                              color: isLeftAlign() ? colorScheme.outline : colorScheme.onPrimary,
                              fontWeight: isLeftAlign() ? FontWeight.normal : FontWeight.bold,
                            ),
                          )
                        )
                      ),
                    ],
                  ),


                ],


              );
            },
          ),
        ),
      ),
    );
  }
}
