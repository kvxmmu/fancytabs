import 'package:flutter/material.dart';

class FancyTabsController {
  int selected;

  void Function(int, int)? _notificator;

  FancyTabsController({
    this.selected = 0,
  });

  // This function only should be called from fancytabs internals
  void listen(void Function(int, int) notificator) =>
      _notificator = notificator;

  void jumpTo(int index) {
    final was = selected;
    selected = index;

    if (_notificator != null) {
      _notificator!(was, selected);
    }
  }

  void next() => jumpTo(selected + 1);
  void previous() => jumpTo(selected + 1);
}

class FancyTabs extends StatefulWidget {
  final List<String> labels;
  final void Function(int) onChanged;

  final double outerRadius;
  final double innerRadius;

  final Size size;

  final Color unselectedColor;
  final Color selectedColor;

  final FancyTabsController? controller;

  final TextStyle style;

  const FancyTabs(
      {Key? key,
      required this.labels,
      required this.onChanged,
      this.size = const Size(double.infinity, 48),
      this.unselectedColor = const Color.fromRGBO(154, 176, 189, 0.24),
      this.selectedColor = const Color.fromRGBO(255, 255, 255, 1.0),
      this.outerRadius = 4.0,
      this.innerRadius = 2.0,
      this.style = const TextStyle(
          color: Color.fromRGBO(0, 0, 0, 1.0),
          fontSize: 13,
          letterSpacing: -0.08,
          fontWeight: FontWeight.w400),
      this.controller})
      : super(key: key);

  @override
  createState() => _FancyTabs();
}

class _FancyTabs extends State<FancyTabs> {
  late final FancyTabsController controller;

  late final ValueNotifier<int> selected;
  List<Widget> tabs = [];

  Size? _pSize;

  Size get perSize => _pSize!;
  set perSize(size) => _pSize = size;

  final _key = UniqueKey();

  @override
  void initState() {
    controller = widget.controller ?? FancyTabsController();
    selected = ValueNotifier<int>(controller.selected);

    controller.listen((_, now) {
      selected.value = now;
      widget.onChanged(now);
    });

    super.initState();
  }

  Future<bool> _waitNonzero() async {
    while (true) {
      if (MediaQuery.of(context).size.width != 0) {
        return true;
      }
      await Future.delayed(const Duration(milliseconds: 16));
    }
    throw UnimplementedError();
  }

  void initTabs() {
    int index = 0;
    for (var label in widget.labels) {
      tabs.add(_FancyTab(
        label: label,
        size: perSize,
        style: widget.style,
        myIndex: index,
        controller: controller,
      ));
      ++index;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.size;

    return FutureBuilder<bool>(
      builder: (ctx, snapshot) {
        if (snapshot.hasData) {
          return LayoutBuilder(builder: (_, constraints) {
            if (_pSize == null) {
              _pSize = Size(
                  (constraints.maxWidth - 2 * (widget.labels.length * 2)) /
                      widget.labels.length,
                  double.infinity);
              initTabs();
            }

            return Container(
              child: Stack(
                children: [
                  Row(
                      children: tabs,
                      mainAxisAlignment: MainAxisAlignment.start),
                  ValueListenableBuilder<int>(
                      valueListenable: selected,
                      builder: (_, selected, __) => AnimatedPositioned(
                            child: _FancyTab(
                              size: Size(perSize.width, size.height),
                              label: widget.labels[selected],
                              selected: true,
                              selectedColor: widget.selectedColor,
                              style: widget.style,
                              myIndex: selected,
                              controller: controller,
                            ),
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeOutExpo,
                            key: _key,
                            top: 0,
                            bottom: 0,
                            left: (perSize.width * selected.toDouble()) +
                                (selected == 0 ? 0.0 : 4 * selected.toDouble()),
                          ))
                ],
              ),
              height: size.height,
              width: size.width,
              decoration: BoxDecoration(
                  color: widget.unselectedColor,
                  borderRadius: BorderRadius.circular(widget.outerRadius)),
            );
          });
        } else if (snapshot.hasError) {
          throw snapshot.error as Error;
        }

        return const SizedBox();
      },
      future: _waitNonzero(),
    );
  }
}

class _FancyTab extends StatelessWidget {
  final Size size;
  final String label;

  final bool selected;
  final Color selectedColor;

  final TextStyle style;
  final FancyTabsController controller;

  final int myIndex;

  const _FancyTab({
    Key? key,
    required this.size,
    required this.label,
    required this.style,
    required this.controller,
    required this.myIndex,
    this.selectedColor = Colors.transparent,
    this.selected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        child: Text(label, style: style),
        width: size.width,
        height: size.height,
        alignment: Alignment.center,
        margin: const EdgeInsets.all(2),
        decoration: selected
            ? BoxDecoration(
                borderRadius: selected ? BorderRadius.circular(2) : null,
                color: selectedColor,
                boxShadow: const <BoxShadow>[
                    BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.16),
                        blurRadius: 2,
                        offset: Offset(0, 1)),
                    BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.12),
                        blurRadius: 4,
                        offset: Offset(0, 2)),
                    BoxShadow(
                        color: Color.fromRGBO(51, 51, 51, 0.1),
                        blurRadius: 8,
                        offset: Offset(0, 1)),
                  ])
            : null,
      ),
      onTap: () => controller.jumpTo(myIndex),
    );
  }
}
