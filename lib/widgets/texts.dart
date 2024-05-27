import '../utils/colors.dart';
import '../utils/text_sizes.dart';
import 'package:flutter/material.dart';

Text headerText(String text, Color color) {
  return Text(
    text,
    style: TextStyle(
      fontSize: headerSize,
      fontWeight: FontWeight.w600,
      color: color,
    ),
  );
}

Text titleText(String text, Color color, TextAlign alignment) {
  return Text(
    text,
    textAlign: alignment,
    style: TextStyle(
      fontSize: titleSize,
      fontWeight: FontWeight.w600,
      color: color,
    ),
  );
}

Text smallerTitleText(String text, Color color, TextAlign alignment) {
  return Text(
    text,
    textAlign: alignment,
    style: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: color,
    ),
  );
}

Text subText(String text, TextAlign alignment) {
  return Text(
    text,
    textAlign: alignment,
    style: TextStyle(
      fontSize: defaultSize,
      fontWeight: FontWeight.w400,
      color: greyTextColor,
    ),
    softWrap: true,
  );
}

Text disableSubText(String text, TextAlign alignment) {
  return Text(
    text,
    textAlign: alignment,
    style: TextStyle(
      fontSize: smallSize,
      fontWeight: FontWeight.w400,
      color: lightGreyColor,
    ),
    softWrap: true,
  );
}

Text boldDefaultText(String text, TextAlign alignment) {
  return Text(
    text,
    textAlign: alignment,
    style: TextStyle(
      fontSize: defaultSize,
      fontWeight: FontWeight.w600,
      color: blackColor,
    ),
    softWrap: true,
  );
}

Text boldDefaultDisableText(String text, TextAlign alignment) {
  return Text(
    text,
    textAlign: alignment,
    style: TextStyle(
      fontSize: defaultSize,
      fontWeight: FontWeight.w600,
      color: lightGreyColor,
    ),
    softWrap: true,
  );
}

Text boldSmallText(String text, TextAlign alignment) {
  return Text(
    text,
    textAlign: alignment,
    style: TextStyle(
      fontSize: smallSize,
      fontWeight: FontWeight.w600,
      color: blackColor,
    ),
    softWrap: true,
  );
}

Text boldSmallDisableText(String text, TextAlign alignment) {
  return Text(
    text,
    textAlign: alignment,
    style: TextStyle(
      fontSize: smallSize,
      fontWeight: FontWeight.w600,
      color: lightGreyColor,
    ),
    softWrap: true,
  );
}

Text smallerSubText(String text, TextAlign alignment) {
  return Text(
    text,
    textAlign: alignment,
    style: TextStyle(
      fontSize: smallSize,
      fontWeight: FontWeight.w400,
      color: greyTextColor,
    ),
    softWrap: true,
  );
}

Text smallerText(String text, TextAlign alignment) {
  return Text(
    text,
    textAlign: alignment,
    style: TextStyle(
      fontSize: smallSize,
      fontWeight: FontWeight.w400,
      color: blackColor,
    ),
    softWrap: true,
  );
}

Text dangerSubText(String text, TextAlign alignment) {
  return Text(
    text,
    textAlign: alignment,
    style: TextStyle(
      fontSize: smallSize,
      fontWeight: FontWeight.w400,
      color: dangerColor,
    ),
    softWrap: true,
  );
}

Text safeSubText(String text, TextAlign alignment) {
  return Text(
    text,
    textAlign: alignment,
    style: TextStyle(
      fontSize: smallSize,
      fontWeight: FontWeight.w400,
      color: safeColor,
    ),
    softWrap: true,
  );
}

Text listTitleText(String text) {
  return Text(
    text,
    textAlign: TextAlign.left,
    style: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: blackColor,
    ),
    softWrap: true,
  );
}

Text contentTitleText(String text) {
  return Text(
    text,
    textAlign: TextAlign.left,
    style: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: blackColor,
    ),
    softWrap: true,
  );
}
