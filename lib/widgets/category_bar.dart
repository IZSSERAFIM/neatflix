import 'package:flutter/material.dart';
import 'package:neatflix/utils/utils.dart';
import 'package:neatflix/models/models.dart';

class CategoryBar extends StatefulWidget {
  final Function(List<Content>) onCategorySelected; // 添加回调函数

  CategoryBar({required this.onCategorySelected}); // 修改构造函数

  @override
  _CategoryBarState createState() => _CategoryBarState();
}

class _CategoryBarState extends State<CategoryBar> {
  List<String> categories = [];
  String selectedCategory = '';

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      final categories = await getCategories();
      setState(() {
        this.categories = categories;
      });
    } catch (e) {
      print("Error fetching categories: $e");
    }
  }

  void selectCategory(String category) async {
    setState(() {
      if (selectedCategory == category) {
        selectedCategory = "";
      } else {
        selectedCategory = category;
      }
    });

    try {
      final contents = await searchCategory(selectedCategory);
      widget.onCategorySelected(contents); // 调用回调函数
    } catch (e) {
      print("Error fetching content for category $selectedCategory: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return CategoryItem(
            category: category,
            isSelected: category == selectedCategory,
            onSelect: selectCategory,
          );
        },
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final String category;
  final bool isSelected;
  final Function(String) onSelect;

  const CategoryItem({
    Key? key,
    required this.category,
    required this.isSelected,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onSelect(category),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        margin: EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.grey[600],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            category,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
