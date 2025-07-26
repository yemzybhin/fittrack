import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../../../../core/utils/colors.dart';
import '../../../../core/utils/pageResource.dart';

class Mainpage extends StatefulWidget {
  const Mainpage({Key? key}) : super(key: key);

  @override
  State<Mainpage> createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  int _currentIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageItem.pages[_currentIndex].widget,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 0,
        unselectedFontSize: 0,
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.black,
        elevation: 4,
        items: [
          ...List.generate(PageItem.pages.length, (index) {
            return _buildNavItem(index, PageItem.pages[index].icon);
          }).toList()
        ],
      ),
    );
  }

  Widget _buildNavIcon({required String icon, required bool isSelected}) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        spacing: 7,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: SvgPicture.asset(
              icon,
              key: ValueKey(isSelected),
              height: isSelected ? 30 : 22,
              color: isSelected ? Colors.white : Colors.white30,
            ),
          ),
          if (isSelected)
            AnimatedOpacity(
              opacity: isSelected ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Container(
                height: 7.5,
                width: 7.5,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: CustomColors.white,
                    width: 2.5,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(int index, String icon) {
    return BottomNavigationBarItem(
      label: '',
      icon: _buildNavIcon(
        icon: icon,
        isSelected: _currentIndex == index,
      ),
    );
  }
}
