import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const _blueColor = Color(0xFF3B82F6);
const _darkblueColor = Color(0xff194185);

class TabBarWidget extends StatelessWidget {
  final TabController tabController;
  final int pengajuanCount;
  final int dipinjamCount;
  final int selesaiCount;

  const TabBarWidget({
    super.key,
    required this.tabController,
    required this.pengajuanCount,
    required this.dipinjamCount,
    required this.selesaiCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            child: TabBar(
              controller: tabController,
              physics: const ClampingScrollPhysics(),
              unselectedLabelColor: Colors.white,
              dividerColor: Colors.transparent,
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: _blueColor,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: _darkblueColor,
              ),
              tabs: [
                _buildTab("Pengajuan", pengajuanCount),
                _buildTab("Dipinjam", dipinjamCount),
                _buildTab("Riwayat", selesaiCount),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String title, int count) {
    return Stack(
      children: [
        Tab(
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          right: 0,
          top: 5,
          child: Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Center(
              child: Text(
                count.toString(),
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(color: Colors.blue, fontSize: 10),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
