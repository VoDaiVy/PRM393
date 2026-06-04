import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
	final String label;
	final IconData icon;
	final VoidCallback onPressed;
	final bool isPrimary;

	const CustomButton({
		super.key,
		required this.label,
		required this.icon,
		required this.onPressed,
		this.isPrimary = false,
	});

	@override
	Widget build(BuildContext context) {
		final ColorScheme colors = Theme.of(context).colorScheme;

		return InkWell(
			borderRadius: BorderRadius.circular(18),
			onTap: onPressed,
			child: Ink(
				padding: const EdgeInsets.symmetric(
					horizontal: 18,
					vertical: 12,
				),
				decoration: BoxDecoration(
					borderRadius: BorderRadius.circular(18),
					gradient: isPrimary
							? LinearGradient(
									colors: [
										colors.primary,
										colors.secondary,
									],
								)
							: null,
					color: isPrimary ? null : colors.surface,
					border: Border.all(
						color: isPrimary ? Colors.transparent : colors.outline,
					),
				),
				child: Row(
					mainAxisSize: MainAxisSize.min,
					children: [
						Icon(
							icon,
							size: 18,
							color: isPrimary ? colors.onPrimary : colors.onSurface,
						),
						const SizedBox(width: 8),
						Text(
							label,
							style: TextStyle(
								fontWeight: FontWeight.w600,
								color: isPrimary ? colors.onPrimary : colors.onSurface,
							),
						),
					],
				),
			),
		);
	}
}
