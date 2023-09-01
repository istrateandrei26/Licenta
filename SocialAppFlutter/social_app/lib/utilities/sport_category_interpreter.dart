import 'package:social_app/Models/sport_category.dart';
import 'package:social_app/components/sport_icons_list.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}

class SportCategoryInterpreter {
  static SportCategory createSportCategoryByIndex(int index) {
    var category;

    var categoryWidget = icon_list[index];

    var categoryId = categoryWidget.id;
    var categoryName =
        categoryWidget.iconPath.split("/").last.split(".").first.capitalize();

    category = SportCategory(categoryId, categoryName, "");

    return category;
  }
}
