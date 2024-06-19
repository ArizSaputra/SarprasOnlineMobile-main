class Api {
  static const String serverIp = "http://192.168.1.11:8000";
  static const String apinative = "http://192.168.1.11";
 

  static const String urlLogin = "$serverIp/api/login";

  static const String urlToolman ="$serverIp/api/toolman";
  static const String urlRegister = "$serverIp/api/store";
  static const String Inventory = "$serverIp/api/inventory";
  static const String InventoryPengajuan = "$serverIp/api/pengajuan";
  static const String InventoryDipinjam = "$serverIp/api/dipinjam";
  static const String InventorySelesai = "$serverIp/api/riwayat";
  static const String updateBarang = "$serverIp/api/store/barang";
  static const String updateBarangUn = "$serverIp/api/store/barangUn";
  static const String lmao = "$serverIp/api/user";
  
 static const String baseUrl = "$serverIp/api/inventory";
//   static const String urlListInventory = "$baseUrl";
// static const String urlListInventoryDetail = "$baseUrl/list-inventory-detail";
// static const String urlTotalItems = "$baseUrl/total-items";
// static const String urlEditInventoryDetail = "$baseUrl"; // Assuming PUT request with ID appended
// static const String urlDeleteInventoryDetail = "$baseUrl/delete-list";
// static const String urlDeleteItem = "$baseUrl"; // Assuming DELETE request with ID appended
// static const String addItem = "$baseUrl";
  static const String urlListInventory = baseUrl;
  static const String urlListInventoryDetail = "$baseUrl/list-inventory-detail";
  static const String urlTotalItems = "$baseUrl/total-items";
  static const String urlEditInventoryDetail = baseUrl; // Assuming PUT request with ID appended
  static const String urlDeleteInventoryDetail = "$baseUrl/delete-list";
  static const String urlDeleteItem = baseUrl; // Assuming DELETE request with ID appended
  static const String addItem = baseUrl;

  static String getEditInventoryDetailUrl(String id) {
    return "$urlEditInventoryDetail/$id";
  }

  static String getDeleteItemUrl(String id) {
    return "$urlDeleteItem/$id";
  }
}

  
  // static const String urlListInventory = "$apinative/api_sarpras/list_inventory.php";
  // static const String urlListInventoryDetail = "$apinative/api_sarpras/list_inventory_detail.php"; 
  // static const String urlTotalItems = "$apinative/api_sarpras/total_items.php"; 
  // static const String urlEditInventoryDetail = "$apinative/api_sarpras/edit_list.php";
  // static const String urlDeleteInventoryDetail = "$apinative/api_sarpras/delete_list.php";
  // static const String urlDeleteItem = "$apinative/api_sarpras/delete_barang.php";
  // static const String addItem = "$apinative/api_sarpras/add_item.php";
  
    // static const String urlProfile = "$apinative/api_sarpras/profil_akun.php";

