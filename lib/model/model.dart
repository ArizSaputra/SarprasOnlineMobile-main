class Item {
  final String nama;
  final String image;
  final String deskripsi;

  const Item({
    required this.nama,
    required this.image,
    required this.deskripsi,
  });
}

const allItem = [
 
  Item(
    nama: "Kabel RJ45", 
    image: "assets/images/laptop.png",
    deskripsi: "Lorem Ipsum is simply"),
  Item(
    nama: "Kabel RJ45", 
    image: "assets/images/laptop.png",
    deskripsi: "Lorem Ipsum is simply"),
  Item(
    nama: "Kabel RJ45", 
    image: "assets/images/laptop.png",
    deskripsi: "Lorem Ipsum is simply"),
  Item(
    nama: "Kabel RJ45", 
    image: "assets/images/laptop.png",
    deskripsi: "Lorem Ipsum is simply"),
  Item(
    nama: "Kabel RJ45", 
    image: "assets/images/laptop.png",
    deskripsi: "Lorem Ipsum is simply"),
  Item(
    nama: "Kabel RJ45", 
    image: "assets/images/laptop.png",
    deskripsi: "Lorem Ipsum is simply"),
];

// List<Item> ITEM_LIST = [
//   Item(
//     nama: "Kabel RJ45", 
//     image: "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.lazada.co.id%2Fproducts%2Fkabel-jaringan-kabel-lan-jadi-panjang-20-meter-sudah-di-pasang-konektor-rj45-i1149448455.html&psig=AOvVaw3z2rgYPm2f_DaZ7MiT4B37&ust=1714146597934000&source=images&cd=vfe&opi=89978449&ved=0CBIQjRxqFwoTCNit4Orb3YUDFQAAAAAdAAAAABAE")
// ];


// CustomAppBar(
//                 title: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Nathan Tjoe",
//                       style: GoogleFonts.poppins(
//                         textStyle: const TextStyle(
//                           color: Colors.grey,
//                           fontSize: 16,
//                           fontWeight: FontWeight.w400
//                         ),
//                       ),
//                     ),
//                     Text(
//                       "Teknik Komputer",
//                       style: GoogleFonts.poppins(
//                         textStyle: const TextStyle(
//                           color: Colors.black,
//                           fontSize: 17,
//                           fontWeight: FontWeight.w500
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 actions: [
//                   Stack(
//                     children: [
//                       IconButton(onPressed: (){}, icon: Icon(Iconsax.notification, color: Colors.black,)),
//                     ],
//                   )
//                 ],
//               ),
//               Container(
//                 width: double.infinity,
//                 padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
//                 decoration: BoxDecoration(
//                   color: Colors.transparent,
//                   borderRadius: BorderRadius.circular(10),
//                   border: Border.all(color: Colors.grey),
//                 ),
//                 child: const Row(
//                   children: [
//                     Icon(Iconsax.search_normal, color: Colors.grey,),
//                     SizedBox(width: 10,),
//                     Text("Cari barang", style: TextStyle(color: Colors.grey),)
//                   ],
//                 ),
//               ),

// CustomAppBar(
//                 title: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Nathan Tjoe",
//                       style: GoogleFonts.poppins(
//                         textStyle: const TextStyle(
//                           color: Colors.grey,
//                           fontSize: 16,
//                           fontWeight: FontWeight.w400
//                         ),
//                       ),
//                     ),
//                     Text(
//                       "Teknik Komputer",
//                       style: GoogleFonts.poppins(
//                         textStyle: const TextStyle(
//                           color: Colors.black,
//                           fontSize: 17,
//                           fontWeight: FontWeight.w500
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 actions: [
//                   Stack(
//                     children: [
//                       IconButton(onPressed: (){}, icon: Icon(Iconsax.notification, color: Colors.black,)),
//                     ],
//                   )
//                 ],
//               ),
//               Container(
//                 width: double.infinity,
//                 padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
//                 decoration: BoxDecoration(
//                   color: Colors.transparent,
//                   borderRadius: BorderRadius.circular(10),
//                   border: Border.all(color: Colors.grey),
//                 ),
//                 child: const Row(
//                   children: [
//                     Icon(Iconsax.search_normal, color: Colors.grey,),
//                     SizedBox(width: 10,),
//                     Text("Cari barang", style: TextStyle(color: Colors.grey),)
//                   ],
//                 ),
//               ),