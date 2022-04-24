# FancyTabs

some fancy looking tabbar

# Usage

```dart
// Controller
FancyTabsController({
  this.selected = 0,
});

// Widget
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
  this.controller});
```
