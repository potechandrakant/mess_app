import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaymentQRScreen extends StatelessWidget {
  const PaymentQRScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(35, 22, 15, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(35, 22, 15, 1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Scan & Pay",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            color: Colors.white,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "PhonePe Payment",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 24,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 25),

            // QR Image
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                "assets/QR_image_new.jpg",
                height: 500,
                fit: BoxFit.contain,
              ),
            ),

            const SizedBox(height: 25),
            Text(
              "MAULEE  RAJMANE",
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w700,
                fontSize: 20,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 10),
            Text(
              "Scan the QR using PhonePe app to complete your payment.",
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: const Color.fromARGB(255, 235, 223, 223),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
