import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const gradientSecondaryPrimaryStart = Color(0xFFD2FBE7);
const gradientSecondaryPrimaryEnd = Color(0xFF4FB3BF);
const colorPrimaryDark = Color(0xFF005662);

final blackTitle = GoogleFonts.roboto(
    color: Colors.black,
    fontSize: 54,
    fontWeight: FontWeight.w600
);

final textTheme = TextTheme(
  headline1: GoogleFonts.roboto(
      fontSize: 96,
      fontWeight: FontWeight.w300,
      letterSpacing: -1.5
  ),
  headline2: GoogleFonts.roboto(
      fontSize: 60,
      fontWeight: FontWeight.w300,
      letterSpacing: -0.5
  ),
  headline3: GoogleFonts.roboto(
      fontSize: 54,
      fontWeight: FontWeight.w400
  ),
  headline4: GoogleFonts.roboto(
      fontSize: 34,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25
  ),
  headline5: GoogleFonts.roboto(
      fontSize: 24,
      fontWeight: FontWeight.w400
  ),
  headline6: GoogleFonts.roboto(
      fontSize: 32,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15
  ),
  subtitle1: GoogleFonts.roboto(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.15
  ),
  subtitle2: GoogleFonts.roboto(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1
  ),
  bodyText1: GoogleFonts.roboto(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5
  ),
  bodyText2: GoogleFonts.roboto(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25
  ),
  button: GoogleFonts.roboto(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 1.25
  ),
  caption: GoogleFonts.roboto(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4
  ),
  overline: GoogleFonts.roboto(
      fontSize: 10,
      fontWeight: FontWeight.w400,
      letterSpacing: 1.5
  ),
);