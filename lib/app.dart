import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/auth/auth_cubit.dart';
import 'bloc/cart/cart_cubit.dart';
import 'bloc/product/product_cubit.dart';
import 'bloc/order/order_cubit.dart';
import 'core/constants/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'data/models/order_model.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/product_repository.dart';
import 'data/repositories/order_repository.dart';
import 'presentation/screens/auth/login_screen.dart';
import 'presentation/screens/auth/signup_screen.dart';
import 'presentation/screens/auth/forgot_password_screen.dart';
import 'presentation/screens/main/main_shell.dart';
import 'presentation/screens/products/products_screen.dart';
import 'presentation/screens/products/product_detail_screen.dart';
import 'presentation/screens/checkout/checkout_screen.dart';
import 'presentation/screens/order/order_confirm_screen.dart';
import 'presentation/screens/order/order_history_screen.dart';
import 'data/models/product_model.dart';

class AbuFashionApp extends StatelessWidget {
  const AbuFashionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => AuthRepository()),
        RepositoryProvider(create: (_) => ProductRepository()),
        RepositoryProvider(create: (_) => OrderRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (ctx) =>
                AuthCubit(ctx.read<AuthRepository>())..checkAuthStatus(),
          ),
          BlocProvider(create: (_) => CartCubit()),
          BlocProvider(
            create: (ctx) => ProductCubit(ctx.read<ProductRepository>()),
          ),
          BlocProvider(
            create: (ctx) => OrderCubit(ctx.read<OrderRepository>()),
          ),
        ],
        child: MaterialApp(
          title: 'Abu Fashion Store',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          initialRoute: AppRoutes.login,
          routes: {
            AppRoutes.login: (_) => const LoginScreen(),
            AppRoutes.signup: (_) => const SignupScreen(),
            AppRoutes.home: (_) => const MainShell(),
            AppRoutes.cart: (_) => const MainShell(initialIndex: 1),
            AppRoutes.profile: (_) => const MainShell(initialIndex: 2),
            AppRoutes.checkout: (_) => const CheckoutScreen(),
            AppRoutes.orderHistory: (_) => const OrderHistoryScreen(),
          },
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case AppRoutes.products:
                final category = settings.arguments as String?;
                return MaterialPageRoute(
                  builder: (_) => ProductsScreen(initialCategory: category),
                );
              case AppRoutes.productDetail:
                final product = settings.arguments as ProductModel;
                return MaterialPageRoute(
                  builder: (_) => ProductDetailScreen(product: product),
                );
              case AppRoutes.orderConfirm:
                final order = settings.arguments as OrderModel;
                return MaterialPageRoute(
                  builder: (_) => OrderConfirmScreen(order: order),
                );
              case AppRoutes.forgotPassword:
                final initialEmail = settings.arguments as String? ?? '';
                return MaterialPageRoute(
                  builder: (_) =>
                      ForgotPasswordScreen(initialEmail: initialEmail),
                );
              default:
                return MaterialPageRoute(builder: (_) => const LoginScreen());
            }
          },
          builder: (context, child) {
            // Ensure text scaling doesn't break layout
            return MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: TextScaler.noScaling),
              child: child!,
            );
          },
        ),
      ),
    );
  }
}
