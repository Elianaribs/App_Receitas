import 'package:app4_receitas/ui/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BaseScreen extends StatefulWidget {
  final Widget child;

  const BaseScreen({super.key, required this.child});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Eu Amo Cozinhar', style: GoogleFonts.dancingScript()),
      ),
      body: widget.child,
      endDrawer: const CustomDrawer(),
    );
  }
}
