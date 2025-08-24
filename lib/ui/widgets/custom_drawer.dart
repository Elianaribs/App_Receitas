import 'package:app4_receitas/utils/theme/custom_theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {

    // * Get.find
    // Usado para encontrar uma instância já injetada do GetX
    final theme = Get.find<CustomThemeController>();

    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Eu Amo Cozinhar',
                    style: GoogleFonts.lobster(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: theme.toogleTheme,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.onSurface,
                      foregroundColor: Theme.of(context).colorScheme.surface,
                    ),
                    icon: Obx(
                          () => !theme.isDark.value
                          ? Icon(Icons.nightlight_round_sharp, size: 24)
                          : Icon(Icons.wb_sunny_outlined, size: 24),
                    ),
                    label: Text('Mudar Tema'),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.of(context).pop();
              context.go('/');
            },
          ),
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text('Favoritas'),
            onTap: () {
              Navigator.of(context).pop();
              context.go('/favorites');
            },
          ),
          ListTile(
            leading: Icon(Icons.search),
            title: Text('Buscar'),
            onTap: () {
              Navigator.of(context).pop();
              context.go('/search');
            },
          ),
        ],
      ),
    );
  }
}