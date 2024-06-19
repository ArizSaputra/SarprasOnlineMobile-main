import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({
    super.key,
    required this.controller,
    required this.onSearch,
  });

  final TextEditingController controller;
  final Function(String) onSearch;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey, 
          width: 1.0, 
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Iconsax.search_normal, color: Colors.grey,),
          const SizedBox(width: 10,),
          Expanded(
            child: TextFormField(
              controller: controller,
              decoration:  InputDecoration(
                hintText: "Cari barang",
                hintStyle: GoogleFonts.poppins(
                  textStyle: const TextStyle(color: Colors.grey),
                ),
                border: InputBorder.none,
              ),
              onChanged: onSearch,
            ),
          ),
        ],
      ),
    );
  }
}