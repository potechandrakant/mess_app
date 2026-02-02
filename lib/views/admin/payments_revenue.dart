import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaymentsRevenuePage extends StatefulWidget {
  const PaymentsRevenuePage({super.key});

  @override
  State<PaymentsRevenuePage> createState() => _PaymentsRevenuePageState();
}

class _PaymentsRevenuePageState extends State<PaymentsRevenuePage> {
  String button = "Today";

  // Hardcoded data for different tabs
  final Map<String, dynamic> revenueData = {
    "Today": {
      "totalRevenue": "₹1,234.56",
      "todaySales": "₹250.00",
      "weekSales": "₹890.00",

      "paid": 60,
      "pending": 25,
      "overdue": 15,
    },
    "This Week": {
      "totalRevenue": "₹5,400.00",
      "todaySales": "₹740.00",
      "weekSales": "₹3,250.00",

      "paid": 80,
      "pending": 12,
      "overdue": 8,
    },
    "Custom": {
      "totalRevenue": "₹9,200.00",
      "todaySales": "₹1,100.00",
      "weekSales": "₹6,000.00",

      "paid": 50,
      "pending": 30,
      "overdue": 20,
    },
  };

  //recent transactions
  Map<String, dynamic> transactions = {
    "Today": [
      {
        "name": "Alice Johnson",
        "orderId": "A123",
        "amount": "₹120.00",
        "status": "Paid",
      },
      {
        "name": "Bob Smith",
        "orderId": "B456",
        "amount": "₹85.50",
        "status": "Pending",
      },
      {
        "name": "Charlie Davis",
        "orderId": "C789",
        "amount": "₹60.75",
        "status": "Overdue",
      },
      {
        "name": "Diana Prince",
        "orderId": "D012",
        "amount": "₹150.00",
        "status": "Paid",
      },
      {
        "name": "Diana Prince",
        "orderId": "D012",
        "amount": "₹150.00",
        "status": "Paid",
      },
    ],
    "This Week": [
      {
        "name": "Mamta Jokare",
        "orderId": "A123",
        "amount": "₹120.00",
        "status": "Paid",
      },
      {
        "name": "Bob Smith",
        "orderId": "B456",
        "amount": "₹85.50",
        "status": "Pending",
      },
      {
        "name": "Charlie Davis",
        "orderId": "C789",
        "amount": "₹60.75",
        "status": "Overdue",
      },
      {
        "name": "Diana Prince",
        "orderId": "D012",
        "amount": "₹150.00",
        "status": "Paid",
      },
      {
        "name": "Diana Prince",
        "orderId": "D012",
        "amount": "₹150.00",
        "status": "Paid",
      },
    ],

    "Custom": [
      {
        "name": "Diksha Shelke",
        "orderId": "A123",
        "amount": "₹120.00",
        "status": "Paid",
      },
      {
        "name": "Bob Smith",
        "orderId": "B456",
        "amount": "₹85.50",
        "status": "Pending",
      },
      {
        "name": "Charlie Davis",
        "orderId": "C789",
        "amount": "₹60.75",
        "status": "Overdue",
      },
      {
        "name": "Diana Prince",
        "orderId": "D012",
        "amount": "₹150.00",
        "status": "Paid",
      },
      {
        "name": "Diana Prince",
        "orderId": "D012",
        "amount": "₹150.00",
        "status": "Paid",
      },
    ],
  };
  //payment list
  final Map<String, List<Map<String, dynamic>>> paymentStatusList = {
    "Today": [
      {"label": "Paid", "percent": 70, "color": Colors.green,},
      {"label": "Pending", "percent": 20, "color": Colors.orange},
      {"label": "Overdue", "percent": 10, "color": Colors.red},
    ],
    "This Week": [
      {"label": "Paid", "percent": 80, "color": Colors.green},
      {"label": "Pending", "percent": 12, "color": Colors.orange},
      {"label": "Overdue", "percent": 10, "color": Colors.red},
    ],
    "Custom": [
      {"label": "Paid", "percent": 50, "color": Colors.green},
      {"label": "Pending", "percent": 30, "color": Colors.orange},
      {"label": "Overdue", "percent": 20, "color": Colors.red},
    ],
  };

  @override
  Widget build(BuildContext context) {
    var data = revenueData[button]!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(35, 22, 15, 1),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_rounded, size: 30, color: Colors.white),
        ),
        centerTitle: true,
        title: Text(
          "Payments & Revenue",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: Color.fromRGBO(35, 22, 15, 1),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tabs
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomButton("Today"),
                CustomButton("This Week"),
                CustomButton("Custom"),
              ],
            ),
            const SizedBox(height: 18),

            // Revenue cards
            Row(
              children: [
                Expanded(child: cards("Total Revenue", data["totalRevenue"])),
                const SizedBox(width: 12),
                Expanded(child: cards("Today's Sales", data["todaySales"])),
              ],
            ),
            const SizedBox(height: 12),

            cards("This Week's Sales", data["weekSales"]),

            const SizedBox(height: 20),

            // Payment Status cards
            Text(
              "Payment Status",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),

            // Hardcoded payment status data
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: paymentStatusList[button]?.length ?? 0,
              itemBuilder: (context, index) {
                final item = paymentStatusList[button]![index];
                final label = item["label"];
                final percent = item["percent"];
                final color = item["color"];

                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(61, 43, 35, 1),
                    borderRadius: BorderRadius.circular(12),
                   // border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            label,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "$percent%",
                            style: GoogleFonts.quicksand(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: color,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Timeline / progress bar
                      Stack(
                        children: [
                          Container(
                            height: 8,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          Container(
                            height: 8,
                            width:
                                MediaQuery.of(context).size.width *
                                    (percent / 100) -
                                36,
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 10),

            const SizedBox(height: 22),

            // Recent Transactions
            Text(
              "Recent Transactions",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            //for dynamic transaction cards
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: transactions[button]?.length ?? 0,
              itemBuilder: (context, index) {
                final txn = transactions[button]![index];
                Color statusColor;

                if (txn["status"] == "Paid") {
                  statusColor = Colors.green;
                } else if (txn["status"] == "Pending") {
                  statusColor = Colors.orange;
                } else {
                  statusColor = Colors.red;
                }
                return transactionCards(
                  txn["name"]!,
                  txn["orderId"]!,
                  txn["amount"]!,
                  txn["status"]!,
                  statusColor,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // --- Widgets ---

  Widget CustomButton(String text) {
    bool isSelected = button == text;
    return GestureDetector(
      onTap: () {
        setState(() {
          button = text;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Color.fromRGBO(250, 111, 41, 1) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? Color.fromRGBO(250, 111, 41, 1)
                : Colors.grey.shade300,
          ),
        ),
        child: Text(
          text,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: isSelected ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget cards(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Color.fromRGBO(61, 43, 35, 1),
        borderRadius: BorderRadius.circular(12),
        // border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  Widget transactionCards(
    String name,
    String orderId,
    String amount,
    String status,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: Color.fromRGBO(61, 43, 35, 1),
        borderRadius: BorderRadius.circular(12),
       // border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Order $orderId",
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.circle, color: color, size: 10),
                  const SizedBox(width: 5),
                  Text(
                    status,
                    style: GoogleFonts.quicksand(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
