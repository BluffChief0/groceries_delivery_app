import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_delivery/logic/api/api.dart';
import 'package:grocery_delivery/logic/bloc/cart_cubit.dart';
import 'package:grocery_delivery/logic/bloc/catalog_cubit.dart';
import 'package:grocery_delivery/logic/models/user.dart';
import 'package:grocery_delivery/ui/screens/cart_screen.dart';
import 'package:grocery_delivery/ui/screens/catalog_screen.dart';
import 'package:grocery_delivery/ui/screens/category_screen.dart';
import 'package:grocery_delivery/ui/screens/checkout_screen.dart';
import 'package:grocery_delivery/ui/screens/profile_screen.dart';

// Cubit для профиля
class ProfileCubit extends Cubit<User?> {
  ProfileCubit(this.apiService) : super(null);
  final MockApiService apiService;

  Future<void> authenticate(String emailOrPhone) async {
    final user = await apiService.authenticate(emailOrPhone);
    emit(user);
  }

  void logout() {
    emit(null);
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final MockApiService apiService = MockApiService();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => CartCubit()),
        BlocProvider(create: (context) => ProfileCubit(apiService)),
        BlocProvider(create: (context) => CatalogCubit(apiService)),
      ],
      child: MaterialApp(
        title: 'Доставка продуктов',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: MainScreen(),
        routes: {
          '/category': (context) => CategoryScreen(),
          '/checkout': (context) => CheckoutScreen(),
        },
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _screens = [
    CatalogScreen(),
    CartScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Каталог'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Корзина',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Профиль'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
