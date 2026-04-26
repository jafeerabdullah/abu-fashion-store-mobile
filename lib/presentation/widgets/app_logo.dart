import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';

class AppLogo extends StatelessWidget {
  final double nameFontSize;
  final double taglineFontSize;

  const AppLogo({super.key, this.nameFontSize = 28, this.taglineFontSize = 14});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          AppStrings.appName,
          style: GoogleFonts.playfairDisplay(
            fontSize: nameFontSize,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          AppStrings.appTagline,
          style: GoogleFonts.poppins(
            fontSize: taglineFontSize,
            fontWeight: FontWeight.w500,
            color: AppColors.accent,
            letterSpacing: 2.0,
          ),
        ),
      ],
    );
  }
}
