import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({super.key});

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  bool _isSmall = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(35, 22, 15, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(35, 22, 15, 1),
        centerTitle: true,
        title: Text(
          "About Us",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 24,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "About Our Project",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Presenting Our Project \n MealHub...",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(fontSize: 20, color: Colors.white),
              ),
              const SizedBox(height: 30),
              Text(
                "Our Institute-Core2Web",
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF2980B9),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/core2weblogo.png",
                    width: 100,
                    height: 100,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      "Core2Web is renowned for its real-world coding sessions, dedicated mentors, "
                      "and hands-on project building, shaping students into job-ready professionals.",
                      textAlign: TextAlign.left,
                      style: GoogleFonts.poppins(
                        fontSize: 17,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Text(
                "Special Thanks to ",
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF2980B9),
                ),
              ),
              const SizedBox(height: 20),
              TweenAnimationBuilder(
                tween: Tween<double>(
                  begin: _isSmall ? 0.9 : 1.1,
                  end: _isSmall ? 1.1 : 0.9,
                ),
                duration: const Duration(seconds: 1),
                curve: Curves.easeInOut,
                onEnd: () => setState(() => _isSmall = !_isSmall),
                builder: (context, scale, child) {
                  return Transform.scale(scale: scale, child: child);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //Glowing gradient text
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds),
                      child: Text(
                        "Shashi Sir",
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.white.withOpacity(0.9),
                              blurRadius: 20,
                              offset: const Offset(0, 0),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // 🔹 Image (no space above)
                    Transform.translate(
                      offset: const Offset(0, 30),
                      child: Image.asset(
                        "assets/sir.jpeg",
                        width: 250,
                        height: 250,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50),
              //Paragraph with bold "Shashi Sir"
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 5),
                  Expanded(
                    child: RichText(
                      textAlign: TextAlign.left,
                      text: TextSpan(
                        style: GoogleFonts.poppins(
                          fontSize: 17,
                          color: Colors.white,
                        ),
                        children: [
                          const TextSpan(text: "We sincerely thank "),
                          TextSpan(
                            text: "Shashi Sir",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const TextSpan(
                            text:
                                " for his inspirational teaching and constant support throughout our learning journey. "
                                "His clear explanations and motivating guidance helped us turn complex concepts into achievable goals. "
                                "The environment he created made learning truly engaging and effective.",
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Text(
                "Thanks to Our\n Instructors",
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2980B9),
                ),
              ),
              const SizedBox(height: 15),

              // 🔹 Paragraph with bold instructor names
              RichText(
                textAlign: TextAlign.left,
                text: TextSpan(
                  style: GoogleFonts.poppins(fontSize: 17, color: Colors.white),
                  children: [
                    const TextSpan(text: "We are also deeply grateful to "),
                    TextSpan(
                      text: "Akshay Sir",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const TextSpan(
                      text:
                          " and the entire Core2Web team for their commitment to excellence and our growth. "
                          "And also thank you to our mentors ",
                    ),
                    TextSpan(
                      text: "Rahul Sir",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const TextSpan(text: " and "),
                    TextSpan(
                      text: "Prajwal Sir",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const TextSpan(
                      text:
                          " for their consistent encouragement throughout our project journey. "
                          "We also like to thank our Team Lead ",
                    ),
                    TextSpan(
                      text: "Tejas Ahire",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const TextSpan(text: "."),
                  ],
                ),
              ),

              const SizedBox(height: 30),
              Text(
                "Project Members:",
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2980B9),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                " Mauli Rajmane\n"
                " Chandrakant Pote\n"
                " Diksha Shelke\n"
                " Mamta Jokare",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 40),
              Text(
                "Thank You From Bottom Of Our Heart To The Entire Core2Web Team...",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(fontSize: 17, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
