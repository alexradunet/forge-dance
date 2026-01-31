import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:flutter_mvvm_riverpod/design_system/molecules/controls/pagination_dots.dart';
import 'package:flutter_mvvm_riverpod/design_system/tokens/app_colors.dart';

@widgetbook.UseCase(
  name: 'Pagination Dots',
  type: PaginationDots,
  path: 'Design System/Molecules/Controls',
)
Widget buildPaginationDots(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: PaginationDots(
          totalDots: context.knobs.int
              .slider(label: 'Total Dots', initialValue: 5, min: 2, max: 10),
          activeIndex: context.knobs.int
              .slider(label: 'Active Index', initialValue: 0, min: 0, max: 9),
          activeColor: context.knobs
              .color(label: 'Active Color', initialValue: AppColors.forgeFire),
          inactiveColor: context.knobs
              .color(label: 'Inactive Color', initialValue: AppColors.gray700),
        ),
      ),
    ),
  );
}
