import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? height;
  final TextDecoration? decoration;

  const CustomText({
    Key? key,
    required this.text,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.height,
    this.decoration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: TextStyle(
        fontSize: fontSize ?? 14,
        fontWeight: fontWeight ?? FontWeight.normal,
        color: color ?? Colors.black,
        height: height,
        decoration: decoration,
      ),
    );
  }
}

class HeadingText extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;

  const HeadingText({
    Key? key,
    required this.text,
    this.color,
    this.textAlign,
    this.maxLines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomText(
      text: text,
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: color ?? Color(0xFF111827),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: maxLines != null ? TextOverflow.ellipsis : null,
    );
  }
}

class TitleText extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;

  const TitleText({
    Key? key,
    required this.text,
    this.color,
    this.textAlign,
    this.maxLines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomText(
      text: text,
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: color ?? Color(0xFF111827),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: maxLines != null ? TextOverflow.ellipsis : null,
    );
  }
}

class SubtitleText extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;

  const SubtitleText({
    Key? key,
    required this.text,
    this.color,
    this.textAlign,
    this.maxLines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomText(
      text: text,
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: color ?? Color(0xFF111827),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: maxLines != null ? TextOverflow.ellipsis : null,
    );
  }
}

class BodyText extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final double? height;

  const BodyText({
    Key? key,
    required this.text,
    this.color,
    this.textAlign,
    this.maxLines,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomText(
      text: text,
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: color ?? Color(0xFF6B7280),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: maxLines != null ? TextOverflow.ellipsis : null,
      height: height ?? 1.5,
    );
  }
}

class CaptionText extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final FontWeight? fontWeight;

  const CaptionText({
    Key? key,
    required this.text,
    this.color,
    this.textAlign,
    this.maxLines,
    this.fontWeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomText(
      text: text,
      fontSize: 12,
      fontWeight: fontWeight ?? FontWeight.normal,
      color: color ?? Color(0xFF9CA3AF),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: maxLines != null ? TextOverflow.ellipsis : null,
    );
  }
}

class PriceText extends StatelessWidget {
  final double price;
  final String currency;
  final Color? color;
  final double? fontSize;

  const PriceText({
    Key? key,
    required this.price,
    this.currency = '\$',
    this.color,
    this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomText(
      text: '$currency${price.toStringAsFixed(0)}',
      fontSize: fontSize ?? 20,
      fontWeight: FontWeight.bold,
      color: color ?? Color(0xFF1B5E52),
    );
  }
}

class LabelText extends StatelessWidget {
  final String text;
  final Color? color;
  final bool isRequired;

  const LabelText({
    Key? key,
    required this.text,
    this.color,
    this.isRequired = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomText(
          text: text,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: color ?? Color(0xFF374151),
        ),
        if (isRequired)
          CustomText(
            text: ' *',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.red,
          ),
      ],
    );
  }
}

class LinkText extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color? color;
  final double? fontSize;

  const LinkText({
    Key? key,
    required this.text,
    required this.onTap,
    this.color,
    this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CustomText(
        text: text,
        fontSize: fontSize ?? 14,
        fontWeight: FontWeight.w600,
        color: color ?? Color(0xFF10B981),
        decoration: TextDecoration.underline,
      ),
    );
  }
}

class ErrorText extends StatelessWidget {
  final String text;

  const ErrorText({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomText(
      text: text,
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: Color(0xFFEF4444),
    );
  }
}