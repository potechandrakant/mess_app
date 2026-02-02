import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mess_app/views/User_Home_Screens/homescreen.dart';
// import 'package:flutter_charge_provider/User/user_homescreen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'dart:math' as math;

class PaymentMethod extends StatefulWidget {
  // final double unitsConsumed;
  // final double batteryGained;
  final double totalCost;
  // final Duration chargingDuration;
  // final String stationName;
  // final DateTime startTime;
  // final DateTime endTime;
  final String startDate;
  final String endDate;

  const PaymentMethod({
    super.key,
    // required this.unitsConsumed,
    // required this.batteryGained,
    required this.totalCost,
    // required this.chargingDuration,
    // required this.stationName,
    // required this.startTime,
    // required this.endTime,
    required this.startDate,
    required this.endDate,
  });

  @override
  State<PaymentMethod> createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
  String? selectedMethod;
  bool isProcessingPayment = false;

  // Rating variables
  int selectedRating = 0;
  TextEditingController commentController = TextEditingController();

  Map<String, Color> appColors = {
    "MainBackground": const Color(0xFF0D1B15),
    "Heading": const Color(0xFFFFFFFF),
    "Subtext": const Color(0xFF757575),
    "Button": const Color(0xFF00C853),
    "Buttontext": const Color(0xFF0D0D0D),
    "Backgroundfields": const Color(0xFF1B2B24),
  };

  final String merchantUpiId = "8767787151@axl";
  final String merchantName = "MessOwner";

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  String _generateTransactionId() {
    return 'TXN${DateTime.now().millisecondsSinceEpoch}';
  }

  // Simple Rating Bottom Sheet - No data needed
  void _showRatingSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        int localSelectedRating = 0;

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              decoration: BoxDecoration(
                color: appColors['MainBackground'],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Drag Handle
                  Container(
                    width: 50,
                    height: 5,
                    margin: const EdgeInsets.only(top: 12),
                    decoration: BoxDecoration(
                      color: appColors['Subtext'],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  // Title
                  Padding(
                    padding: const EdgeInsets.only(top: 24, bottom: 8),
                    child: Text(
                      "Rate Your Experience",
                      style: GoogleFonts.quicksand(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: appColors['Heading'],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  // Subtitle
                  Text(
                    "Your feedback helps us improve",
                    style: TextStyle(fontSize: 14, color: appColors['Subtext']),
                  ),

                  const SizedBox(height: 32),

                  // Stars Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return GestureDetector(
                        onTap: () {
                          setModalState(() {
                            localSelectedRating = index + 1;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Icon(
                            localSelectedRating >= index + 1
                                ? Icons.star_rounded
                                : Icons.star_outline_rounded,
                            size: 50,
                            color: localSelectedRating >= index + 1
                                ? appColors['Button']
                                : appColors['Subtext'],
                          ),
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 20),

                  // Rating Text
                  if (localSelectedRating > 0)
                    Text(
                      _getRatingText(localSelectedRating),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: appColors['Button'],
                      ),
                    )
                  else
                    const SizedBox(height: 26),

                  const SizedBox(height: 32),

                  // Buttons
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                    child: Row(
                      children: [
                        // Skip Button
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (context) => Homescreen(),
                                  ),
                                  (route) => false,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: appColors['Backgroundfields'],
                                foregroundColor: appColors['Heading'],
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child: const Text(
                                "Skip",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Submit Button
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: ElevatedButton(
                              onPressed: localSelectedRating == 0
                                  ? null
                                  : () {
                                      // Just print the rating
                                      log("Rating: $localSelectedRating stars");

                                      // Show thank you message
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Row(
                                            children: [
                                              Icon(
                                                Icons.check_circle,
                                                color: Colors.white,
                                              ),
                                              SizedBox(width: 12),
                                              Text(
                                                'Thank you for your feedback!',
                                              ),
                                            ],
                                          ),
                                          backgroundColor: appColors['Button'],
                                          behavior: SnackBarBehavior.floating,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );

                                      // Navigate to home
                                      Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                          builder: (context) => Homescreen(),
                                        ),
                                        (route) => false,
                                      );
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: localSelectedRating == 0
                                    ? appColors['Subtext']
                                    : appColors['Button'],
                                foregroundColor: appColors['Buttontext'],
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child: const Text(
                                "Submit",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  String _getRatingText(int rating) {
    switch (rating) {
      case 1:
        return "Poor ⭐";
      case 2:
        return "Fair ⭐⭐";
      case 3:
        return "Good ⭐⭐⭐";
      case 4:
        return "Very Good ⭐⭐⭐⭐";
      case 5:
        return "Excellent! ⭐⭐⭐⭐⭐";
      default:
        return "";
    }
  }

  void _launchPaymentApp() async {
    if (selectedMethod == null || selectedMethod!.isEmpty) {
      _showError('Please select a payment method to continue');
      return;
    }

    if (isProcessingPayment) return;

    setState(() {
      isProcessingPayment = true;
    });

    String upiUrl = "";
    final amount = widget.totalCost.toStringAsFixed(2);
    // final transactionNote = "Charging at ${widget.stationName}";
    final transactionId = _generateTransactionId();

    final upiParams =
        "pa=$merchantUpiId&pn=$merchantName&mc=0000&tid=$transactionId&tr=$transactionId&am=$amount&cu=INR";

    switch (selectedMethod) {
      case "Google Pay":
        final url = "upi://pay?$upiParams";
        if (await canLaunch(url)) {
          await launch(url); // No LaunchMode here
        } else {
          _showError('Could not launch payment app');
        }
        break;
      case "PhonePe":
        final url = "phonepe://pay?$upiParams";
        if (await canLaunch(url)) {
          await launch(url); // No LaunchMode here
        } else {
          _showError('Could not launch payment app');
        }
        break;
      case "Razorpay":
        final url = "upi://pay?$upiParams";
        if (await canLaunch(url)) {
          await launch(url); // No LaunchMode here
        } else {
          _showError('Could not launch payment app');
        }
        break;
      default:
        final url = "upi://pay?$upiParams";
        if (await canLaunch(url)) {
          await launch(url); // No LaunchMode here
        } else {
          _showError('Could not launch payment app');
        }
    }

    try {
      final Uri url = Uri.parse(upiUrl);
      bool launched = await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );

      if (launched) {
        _showPaymentVerificationDialog(transactionId);
      } else {
        _showError(
          'Could not launch $selectedMethod. Please ensure the app is installed.',
        );
        _showDemoPaymentOption();
      }
    } catch (e) {
      _showError('Error launching payment app: $e');
      _showDemoPaymentOption();
    } finally {
      setState(() {
        isProcessingPayment = false;
      });
    }
  }

  void _showDemoPaymentOption() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: appColors['Backgroundfields'],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Payment App Not Available',
          style: TextStyle(color: appColors['Heading']),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.info_outline, color: appColors['Button'], size: 50),
            const SizedBox(height: 16),
            Text(
              'Would you like to simulate the payment for testing?',
              textAlign: TextAlign.center,
              style: TextStyle(color: appColors['Subtext']),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: appColors['MainBackground'],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Amount: ₹${widget.totalCost.toStringAsFixed(2)}',
                style: TextStyle(
                  color: appColors['Button'],
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: appColors['Subtext']),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSuccessDialog();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: appColors['Button'],
            ),
            child: Text(
              'Demo Payment',
              style: TextStyle(color: appColors['Buttontext']),
            ),
          ),
        ],
      ),
    );
  }

  void _showPaymentVerificationDialog(String transactionId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: appColors['Backgroundfields'],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Verify Payment',
          style: TextStyle(color: appColors['Heading']),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: appColors['Button']),
            const SizedBox(height: 20),
            Text(
              'Please complete the payment in $selectedMethod',
              textAlign: TextAlign.center,
              style: TextStyle(color: appColors['Subtext']),
            ),
            const SizedBox(height: 10),
            Text(
              'Transaction ID: $transactionId',
              textAlign: TextAlign.center,
              style: TextStyle(color: appColors['Subtext'], fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showSuccessDialog();
            },
            child: Text(
              'Payment Done',
              style: TextStyle(color: appColors['Button']),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showPaymentFailedDialog();
            },
            child: const Text(
              'Failed/Cancel',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: appColors['Backgroundfields'],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: appColors['Button'],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle,
                color: appColors['MainBackground'],
                size: 50,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Payment Successful!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: appColors['Heading'],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '₹${widget.totalCost.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: appColors['Button'],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Paid via $selectedMethod',
              textAlign: TextAlign.center,
              style: TextStyle(color: appColors['Subtext']),
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: appColors['Button'],
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
                // Show rating sheet after payment success
                _showRatingSheet();
              },
              child: Text(
                'Continue',
                style: TextStyle(
                  color: appColors['Buttontext'],
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPaymentFailedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: appColors['Backgroundfields'],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, color: Colors.white, size: 50),
            ),
            const SizedBox(height: 20),
            Text(
              'Payment Failed',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: appColors['Heading'],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Please try again or choose a different payment method',
              textAlign: TextAlign.center,
              style: TextStyle(color: appColors['Subtext']),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Retry', style: TextStyle(color: appColors['Button'])),
          ),
        ],
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final serviceFee = widget.totalCost * 0.10;
    // final energyCost = widget.totalCost - serviceFee;

    return Scaffold(
      backgroundColor: appColors['MainBackground'],
      appBar: AppBar(
        backgroundColor: appColors['MainBackground'],
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: appColors['Heading']),
        ),
        title: Text(
          "Payment",
          style: TextStyle(
            color: appColors['Heading'],
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Success Icon
              Center(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: appColors['Button']?.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle_outline,
                    color: appColors['Button'],
                    size: 60,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Station Info
              // Container(
              //   decoration: BoxDecoration(
              //     color: appColors['Backgroundfields'],
              //     borderRadius: BorderRadius.circular(12),
              //   ),
              //   padding: const EdgeInsets.all(16),
              //   child: Row(
              //     children: [
              //       Icon(
              //         Icons.ev_station,
              //         color: appColors['Button'],
              //         size: 30,
              //       ),
              //       const SizedBox(width: 12),
              // Expanded(
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Text(
              //         widget.stationName,
              //         style: TextStyle(
              //           color: appColors['Heading'],
              //           fontWeight: FontWeight.bold,
              //           fontSize: 16,
              //         ),
              //       ),
              //       const SizedBox(height: 4),
              //       Text(
              //         "Duration: ${_formatDuration(widget.chargingDuration)}",
              //         style: TextStyle(
              //           color: appColors['Subtext'],
              //           fontSize: 12,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              //     ],
              //   ),
              // ),
              // const SizedBox(height: 20),

              // Units and Battery Row
              // Row(
              //   children: [
              //     Expanded(
              //       child: _infoBox(
              //         "Units Consumed",
              //         "${widget.unitsConsumed.toStringAsFixed(1)} kWh",
              //         appColors['Heading']!,
              //       ),
              //     ),
              //     const SizedBox(width: 12),
              //     Expanded(
              //       child: _infoBox(
              //         "Battery Gained",
              //         "+${widget.batteryGained.toInt()}%",
              //         appColors['Button']!,
              //       ),
              //     ),
              //   ],
              // ),
              // const SizedBox(height: 25),

              // Cost Breakdown
              // Text(
              //   "Cost Breakdown",
              //   style: TextStyle(
              //     color: appColors['Heading'],
              //     fontSize: 18,
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
              // const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: appColors['Backgroundfields'],
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // _costRow(
                    //   "Energy Cost",
                    //   "₹${energyCost.toStringAsFixed(2)}",
                    //   appColors,
                    // ),
                    // _costRow(
                    //   "Service Fee (10%)",
                    //   "₹${serviceFee.toStringAsFixed(2)}",
                    //   appColors,
                    // ),
                    // Divider(color: appColors['Subtext'], height: 24),
                    _costRow(
                      "Total Amount",
                      "₹${widget.totalCost.toStringAsFixed(2)}",
                      appColors,
                      bold: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),

              // Payment Method
              Text(
                "Select Payment Method",
                style: TextStyle(
                  color: appColors['Heading'],
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              _buildPaymentOptionWithImage(
                "Google Pay",
                'assets/google.png',
                isSelected: selectedMethod == "Google Pay",
                onTap: () => setState(() => selectedMethod = "Google Pay"),
              ),
              const SizedBox(height: 8),
              _buildPaymentOptionWithImage(
                "PhonePe",
                'assets/phone.png',
                isSelected: selectedMethod == "PhonePe",
                onTap: () => setState(() => selectedMethod = "PhonePe"),
              ),
              const SizedBox(height: 8),
              _buildPaymentOptionWithImage(
                "Razorpay",
                'assets/razor.png',
                isSelected: selectedMethod == "Razorpay",
                onTap: () => setState(() => selectedMethod = "Razorpay"),
              ),
              const SizedBox(height: 30),

              // Pay Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedMethod != null
                        ? appColors['Button']
                        : appColors['Subtext'],
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  onPressed: isProcessingPayment ? null : _launchPaymentApp,
                  child: isProcessingPayment
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: appColors['Buttontext'],
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          selectedMethod != null
                              ? "Pay ₹${widget.totalCost.toStringAsFixed(2)}"
                              : "Select Payment Method",
                          style: TextStyle(
                            fontSize: 18,
                            color: selectedMethod != null
                                ? appColors['Buttontext']
                                : Colors.white70,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentOptionWithImage(
    String name,
    String imagePath, {
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: appColors['Backgroundfields'],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? appColors['Button']! : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(6),
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.payment, color: Colors.grey);
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  color: appColors['Heading'],
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? appColors['Button']!
                      : appColors['Subtext']!,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: appColors['Button'],
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  // String _formatDuration(Duration duration) {
  //   String twoDigits(int n) => n.toString().padLeft(2, "0");
  //   String hours = twoDigits(duration.inHours);
  //   String minutes = twoDigits(duration.inMinutes.remainder(60));
  //   String seconds = twoDigits(duration.inSeconds.remainder(60));
  //   return "$hours:$minutes:$seconds";
  // }

  // Widget _infoBox(String title, String value, Color valueColor) {
  //   return Container(
  //     padding: const EdgeInsets.all(16),
  //     decoration: BoxDecoration(
  //       color: appColors['Backgroundfields'],
  //       borderRadius: BorderRadius.circular(12),
  //     ),
  //     child: Column(
  //       children: [
  //         Text(
  //           title,
  //           style: TextStyle(color: appColors['Subtext'], fontSize: 12),
  //           textAlign: TextAlign.center,
  //         ),
  //         const SizedBox(height: 8),
  //         Text(
  //           value,
  //           style: TextStyle(
  //             color: valueColor,
  //             fontSize: 20,
  //             fontWeight: FontWeight.bold,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}

class _costRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;
  final Map<String, Color> colorMap;

  const _costRow(this.label, this.value, this.colorMap, {this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: colorMap['Subtext'],
              fontSize: bold ? 16 : 14,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: colorMap['Heading'],
              fontSize: bold ? 18 : 14,
              fontWeight: bold ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
