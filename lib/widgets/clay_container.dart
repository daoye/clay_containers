import 'package:clay_containers/constants.dart';
import 'package:clay_containers/extensions/context_extensions.dart';
import 'package:clay_containers/utils/clay_utils.dart';
import 'package:flutter/material.dart';

class ClayContainer extends StatefulWidget {
  const ClayContainer({
    super.key,
    this.child,
    this.height,
    this.width,
    this.color,
    this.surfaceColor,
    this.parentColor,
    this.spread,
    this.borderRadius,
    this.customBorderRadius,
    this.curveType,
    this.depth,
    this.emboss = false,
    this.shape = BoxShape.rectangle,
  });

  final double? height;
  final double? width;
  final Color? color;
  final Color? parentColor;
  final Color? surfaceColor;
  final double? spread;
  final Widget? child;
  final double? borderRadius;
  final BorderRadius? customBorderRadius;
  final CurveType? curveType;
  final int? depth;
  final bool emboss;
  final BoxShape shape;

  @override
  State<ClayContainer> createState() => _ClayContainerState();
}

class _ClayContainerState extends State<ClayContainer> {
  late double? height;
  late double? width;
  late Color color;
  late Color? parentColor;
  late Color? surfaceColor;
  late double? borderRadius;
  late BorderRadius? customBorderRadius;
  late int depth;
  late double spread;
  late BoxShape shape;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final clayTheme = context.clayTheme;
    height = widget.height ?? clayTheme?.height;
    width = widget.width ?? clayTheme?.width;
    color = widget.color ?? clayTheme?.color ?? const Color(0xFFf0f0f0);
    parentColor = widget.parentColor ?? clayTheme?.parentColor;
    surfaceColor = widget.surfaceColor ?? clayTheme?.surfaceColor;
    borderRadius = widget.borderRadius ?? clayTheme?.borderRadius;
    customBorderRadius =
        widget.customBorderRadius ?? clayTheme?.customBorderRadius;
    depth = widget.depth ?? clayTheme?.depth ?? 20;
    spread = widget.spread ?? clayTheme?.spread ?? 6;
    shape = widget.shape;
  }

  @override
  void didUpdateWidget(covariant ClayContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    final clayTheme = context.clayTheme;
    height = widget.height ?? clayTheme?.height;
    width = widget.width ?? clayTheme?.width;
    color = widget.color ?? clayTheme?.color ?? const Color(0xFFf0f0f0);
    parentColor = widget.parentColor ?? clayTheme?.parentColor;
    surfaceColor = widget.surfaceColor ?? clayTheme?.surfaceColor;
    borderRadius = widget.borderRadius ?? clayTheme?.borderRadius;
    customBorderRadius =
        widget.customBorderRadius ?? clayTheme?.customBorderRadius;
    depth = widget.depth ?? clayTheme?.depth ?? 20;
    spread = widget.spread ?? clayTheme?.spread ?? 6;
    shape = widget.shape;
  }

  @override
  Widget build(BuildContext context) {
    var colorValue = color;
    final parentColorValue = parentColor ?? colorValue;
    final surfaceColorValue = surfaceColor ?? colorValue;
    BorderRadius? borderRadiusValue = borderRadius == null
        ? BorderRadius.zero
        : BorderRadius.circular(borderRadius!);

    if (customBorderRadius != null) {
      borderRadiusValue = customBorderRadius;
    }
    final curveTypeValue = widget.curveType ?? CurveType.none;

    var shadowList = <BoxShadow>[
      BoxShadow(
        color: ClayUtils.getAdjustColor(
          parentColorValue,
          widget.emboss ? 0 - depth : depth,
        ),
        offset: Offset(0 - spread, 0 - spread),
        blurRadius: spread,
      ),
      BoxShadow(
        color: ClayUtils.getAdjustColor(
          parentColorValue,
          widget.emboss ? depth : 0 - depth,
        ),
        offset: Offset(spread, spread),
        blurRadius: spread,
      ),
    ];

    if (widget.emboss) shadowList = shadowList.reversed.toList();
    if (widget.emboss) {
      colorValue = ClayUtils.getAdjustColor(colorValue, 0 - depth ~/ 2);
    }
    if (surfaceColor != null) colorValue = surfaceColorValue;

    late List<Color?> gradientColors;
    switch (curveTypeValue) {
      case CurveType.concave:
        gradientColors = ClayUtils.getConcaveGradients(
          colorValue,
          depth,
        );
      case CurveType.convex:
        gradientColors = ClayUtils.getConvexGradients(
          colorValue,
          depth,
        );
      case CurveType.none:
        gradientColors = ClayUtils.getFlatGradients(
          colorValue,
          depth,
        );
    }

    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: shape == BoxShape.circle ? null : borderRadiusValue,
        color: colorValue,
        shape: shape,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors as List<Color>,
        ),
        boxShadow: shadowList,
      ),
      child: widget.child,
    );
  }
}
