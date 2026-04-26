import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/cart/cart_state.dart';
import '../../../bloc/cart/cart_cubit.dart';
import '../../widgets/app_bottom_nav_bar.dart';
import '../home/home_screen.dart';
import '../cart/cart_screen.dart';
import '../profile/profile_screen.dart';

class MainShell extends StatefulWidget {
  final int initialIndex;

  const MainShell({super.key, this.initialIndex = 0});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  late int _currentIndex;

  final List<Widget> _screens = const [
    HomeScreen(),
    CartScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: BlocBuilder<CartCubit, CartState>(
        builder: (context, cartState) {
          return AppBottomNavBar(
            currentIndex: _currentIndex,
            cartItemCount: cartState.itemCount,
            onTap: (index) => setState(() => _currentIndex = index),
          );
        },
      ),
    );
  }
}
