import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:grocery_delivery/logic/api/api.dart';
import 'package:grocery_delivery/logic/bloc/cart_cubit.dart';
import 'package:grocery_delivery/logic/bloc/categories/categories_cubit.dart';
import 'package:grocery_delivery/logic/bloc/products/products_cubit.dart';
import 'package:grocery_delivery/logic/models/user.dart';
import 'package:grocery_delivery/logic/navigation/router.dart';
import 'package:grocery_delivery/ui/screens/cart_screen.dart';
import 'package:grocery_delivery/ui/screens/catalog_screen.dart';
import 'package:grocery_delivery/ui/screens/profile_screen.dart';
import 'package:grocery_delivery/ui/theme/brand_colors.dart';

class ProfileCubit extends Cubit<User?> {
  ProfileCubit(this.apiService) : super(null);
  final ApiService apiService;

  Future<void> authenticate(String emailOrPhone) async {
    final user = await ApiService.authenticate(emailOrPhone);
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
  final ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final FocusScopeNode f = FocusScope.of(context);
        if (!f.hasPrimaryFocus && f.focusedChild != null) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => CartCubit()),
          BlocProvider(create: (context) => ProfileCubit(apiService)),
          BlocProvider(create: (context) => ProductsCubit()),
          BlocProvider(create: (context) => CategoriesCubit()..getAllCategories()),
        ],
        child: MaterialApp(
          title: 'Доставка продуктов',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            appBarTheme: const AppBarTheme(
              backgroundColor: BrandColors.white,
              surfaceTintColor: BrandColors.white,
              elevation: 0.1,
              shadowColor: BrandColors.totalBlack,
            ),
            scaffoldBackgroundColor: BrandColors.white,
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              backgroundColor: BrandColors.white,
            ),
            textSelectionTheme: const TextSelectionThemeData(
              cursorColor: BrandColors.black,
            ),
          ),
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('ru'),
          ],
          onGenerateRoute: AppRouter.generateRoute,
          initialRoute: '/',
        ),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  late final TabController tabController = TabController(length: 3, vsync: this)
    ..addListener(() => setState(() {}));

  static final List<Widget> _screens = [
    CatalogScreen(),
    CartScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: tabController,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: BrandColors.accent,
        unselectedItemColor: BrandColors.textSecondary,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Каталог'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Корзина',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Профиль'),
        ],
        currentIndex: tabController.index,
        onTap: (value) {
          tabController.animateTo(value);
        },
      ),
    );
  }
}
