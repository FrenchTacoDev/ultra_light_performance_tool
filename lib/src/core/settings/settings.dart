import 'package:flutter/material.dart';
import 'widgets/factor_adjust.dart';

//Todo documentation
class SettingsPanel extends StatelessWidget {
  const SettingsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: const Text("Einstellungen"),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  ListTile(
                    title: const Text("Faktoren Anpassen"),
                    subtitle: const Text("Passen Sie die Faktoren für die Performance-Berechnung an."),
                    onTap: () async{
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FactorAdjustPanel(),
                          )
                      );
                    },
                  ),
                  //Divider(color: Colors.white.withOpacity(0.35), height: 0.5),
                  //Divider(color: Colors.white.withOpacity(0.35), height: 0.5, indent: 16, endIndent: 16,),
                  const SizedBox(height: 16),
                ],
              ),
            )
        )
    );
  }
}