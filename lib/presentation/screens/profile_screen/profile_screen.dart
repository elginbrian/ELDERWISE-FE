import 'package:elderwise/presentation/themes/colors.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity, // Agar memenuhi seluruh layar
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/presentation/screens/assets/images/bg_floral.png'),
            fit: BoxFit.cover, // Menyesuaikan ukuran gambar agar memenuhi layar
          ),
        ),
        child: Column(
  children: [
    SizedBox(height: 32),
    Row(
      mainAxisAlignment: MainAxisAlignment.start, // Pusatkan profil
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          width: 69,
          height: 69,
          decoration: BoxDecoration(
            shape: BoxShape.circle, // Bentuk lingkaran
            border: Border.all(
              color: Colors.white, // Outline putih
              width: 5, // Ketebalan outline
            ),
            image: const DecorationImage(
              image: AssetImage('lib/presentation/screens/assets/images/bg_floral.png'),
              fit: BoxFit.cover, // Sesuaikan gambar
            ),
          ),
        ),
        SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Mbah Goro", style: Theme.of(context).textTheme.displaySmall),
            Text("Mbah Goro"),
          ],
        ),
      ],
    ),
    SizedBox(height: 32),
    Expanded(
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(24),
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.neutral20,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32.0), 
                topRight: Radius.circular(32.0),
              ),
            ),
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Nama Lengkap", style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600, color: AppColors.neutral80),),
                    SizedBox(height: 8,),
                    Container(
                      width: double.infinity,
                      height: 42,
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.neutral10,
                        borderRadius: BorderRadius.circular(24)
                      ),
                      child: Text("Nama Lengkap", style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600, color: AppColors.neutral80),),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    ),
  ],
),

      ),
    );
  }
}
