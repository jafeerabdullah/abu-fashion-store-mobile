import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../bloc/auth/auth_cubit.dart';
import '../../../bloc/auth/auth_state.dart';
import '../../../bloc/cart/cart_cubit.dart';
import '../../../bloc/cart/cart_state.dart';
import '../../../bloc/order/order_cubit.dart';
import '../../../bloc/order/order_state.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/validators.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _zipController = TextEditingController();
  String _paymentMethod = 'card';

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthCubit>().state;
    if (authState is AuthAuthenticated) {
      _nameController.text = authState.user.name;
      _phoneController.text = authState.user.phone ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _zipController.dispose();
    super.dispose();
  }

  void _placeOrder(CartState cartState) {
    if (!_formKey.currentState!.validate()) return;

    final authState = context.read<AuthCubit>().state;
    final userId = authState is AuthAuthenticated
        ? authState.user.uid
        : 'guest';

    context.read<OrderCubit>().placeOrder(
      userId: userId,
      items: cartState.items,
      deliveryName: _nameController.text.trim(),
      deliveryPhone: _phoneController.text.trim(),
      deliveryAddress: _addressController.text.trim(),
      deliveryCity: _cityController.text.trim(),
      deliveryZipCode: _zipController.text.trim(),
      paymentMethod: _paymentMethod == 'card'
          ? AppStrings.creditDebitCard
          : AppStrings.cashOnDelivery,
      subtotal: cartState.subtotal,
      shipping: cartState.shipping,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrderCubit, OrderState>(
      listener: (context, state) {
        if (state is OrderSuccess) {
          context.read<CartCubit>().clearCart();
          Navigator.pushReplacementNamed(
            context,
            AppRoutes.orderConfirm,
            arguments: state.order,
          );
        } else if (state is OrderError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 18),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(AppStrings.checkout),
        ),
        body: BlocBuilder<CartCubit, CartState>(
          builder: (context, cartState) {
            if (cartState.items.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.shopping_bag_outlined,
                        size: 72,
                        color: AppColors.textHint,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        AppStrings.cartEmpty,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        AppStrings.cartEmptySubtitle,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 20),
                      CustomButton(
                        label: 'Browse Products',
                        onPressed: () => Navigator.pushReplacementNamed(
                          context,
                          AppRoutes.products,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionHeader(title: AppStrings.deliveryAddress),
                    const SizedBox(height: 14),
                    CustomTextField(
                      hint: AppStrings.fullName,
                      controller: _nameController,
                      validator: (v) => v == null || v.isEmpty
                          ? AppStrings.fieldRequired
                          : null,
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      hint: AppStrings.phoneNumber,
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      validator: AppValidators.phone,
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      hint: AppStrings.address,
                      controller: _addressController,
                      validator: (v) => v == null || v.isEmpty
                          ? AppStrings.fieldRequired
                          : null,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: CustomTextField(
                            hint: AppStrings.city,
                            controller: _cityController,
                            validator: (v) => v == null || v.isEmpty
                                ? AppStrings.fieldRequired
                                : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CustomTextField(
                            hint: AppStrings.zipCode,
                            controller: _zipController,
                            keyboardType: TextInputType.number,
                            validator: (v) => v == null || v.isEmpty
                                ? AppStrings.fieldRequired
                                : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _SectionHeader(title: AppStrings.paymentMethod),
                    const SizedBox(height: 12),
                    _buildPaymentOption(
                      value: 'card',
                      label: AppStrings.creditDebitCard,
                      icon: Icons.credit_card,
                    ),
                    const SizedBox(height: 8),
                    _buildPaymentOption(
                      value: 'cod',
                      label: AppStrings.cashOnDelivery,
                      icon: Icons.money,
                    ),
                    const SizedBox(height: 24),
                    _SectionHeader(title: AppStrings.orderSummary),
                    const SizedBox(height: 14),
                    _buildSummaryCard(cartState),
                    const SizedBox(height: 24),
                    BlocBuilder<OrderCubit, OrderState>(
                      builder: (context, orderState) {
                        return CustomButton(
                          label: AppStrings.placeOrder,
                          onPressed: () => _placeOrder(cartState),
                          isLoading: orderState is OrderPlacing,
                          variant: ButtonVariant.primary,
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPaymentOption({
    required String value,
    required String label,
    required IconData icon,
  }) {
    final selected = _paymentMethod == value;
    return GestureDetector(
      onTap: () => setState(() => _paymentMethod = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withValues(alpha: 0.05)
              : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: selected ? AppColors.primary : AppColors.textSecondary,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                color: selected
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
              ),
            ),
            const Spacer(),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? AppColors.primary : Colors.transparent,
                border: Border.all(
                  color: selected ? AppColors.primary : AppColors.border,
                  width: 2,
                ),
              ),
              child: selected
                  ? const Icon(Icons.check, size: 12, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(CartState cartState) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _Row(
            label: AppStrings.subtotal,
            value: '\$${cartState.subtotal.toStringAsFixed(2)}',
          ),
          const SizedBox(height: 8),
          _Row(
            label: AppStrings.shipping,
            value: '\$${cartState.shipping.toStringAsFixed(2)}',
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(),
          ),
          _Row(
            label: AppStrings.total,
            value: '\$${cartState.total.toStringAsFixed(2)}',
            isTotal: true,
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;

  const _Row({required this.label, required this.value, this.isTotal = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: isTotal ? 15 : 13,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w400,
            color: isTotal ? AppColors.textPrimary : AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: isTotal ? 16 : 13,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
            color: isTotal ? AppColors.accent : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
