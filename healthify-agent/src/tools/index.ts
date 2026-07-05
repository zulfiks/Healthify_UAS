import { createTool } from "@voltagent/core";
import { z } from "zod";

let lastInsert = "";
let lastInsertTime = 0;

export const logMakanan = createTool({
  name: "logMakanan",

  description: "Mencatat makanan ke database",

  parameters: z.object({
    namaMakanan: z.string(),
    kalori: z.number(),
    nomorWa: z.string().describe("Nomor WA user dari konteks sistem"),
  }),

  execute: async ({ namaMakanan, kalori, nomorWa }) => {

    const currentKey = `${namaMakanan}-${kalori}-${nomorWa}`;
    const now = Date.now();

    // Anti duplicate 10 detik
    if (
      lastInsert === currentKey &&
      now - lastInsertTime < 10000
    ) {
      console.log("DUPLIKAT DICEGAH");

      return `Berhasil mencatat ${namaMakanan} (${kalori} kalori)`;
    }

    lastInsert = currentKey;
    lastInsertTime = now;

    try {

      console.log("=================================");
      console.log("TOOL logMakanan DIPANGGIL");
      console.log("Makanan :", namaMakanan);
      console.log("Kalori  :", kalori);
      console.log("Nomor WA:", nomorWa);
      console.log("=================================");

      const response = await fetch(
        "https://api-healthify.tifpsdku.com/api/log-makanan.php",
        {
          method: "POST",
          headers: {
            "Content-Type": "application/json"
          },
          body: JSON.stringify({
            makanan: namaMakanan,
            kalori: kalori,
            nomor_wa: nomorWa // Kirim nomor WA ke PHP
          })
        }
      );

      const result = await response.json();

      console.log("RESPON PHP:");
      console.log(result);

      if (result.status === "success") {
        return `Berhasil mencatat ${namaMakanan} (${kalori} kalori)`;
      }

      return `Gagal menyimpan data: ${result.message}`;

    } catch (error: any) {

      console.error(error);

      return `Error: ${error.message}`;
    }
  }
});

export const cekRiwayatMakan = createTool({
  name: "cekRiwayatMakan",

  description: "Melihat riwayat makanan hari ini",

  parameters: z.object({
    nomorWa: z.string().describe("Nomor WA user dari konteks sistem"),
  }),

  execute: async ({ nomorWa }) => {

    try {
      console.log("=================================");
      console.log("TOOL cekRiwayatMakan DIPANGGIL");
      console.log("Nomor WA:", nomorWa);
      console.log("=================================");

      const response = await fetch(
        `https://api-healthify.tifpsdku.com/api/cek-riwayat.php?nomor_wa=${nomorWa}&hari_ini=true`
      );

      const result = await response.json();

      if (result.status === "success") {
        if (result.data.length === 0) {
          return "Tidak ada riwayat makan hari ini.";
        }
        
        // Buat ringkasan yang mudah dibaca oleh LLM
        let summary = `Riwayat makan hari ini (${result.data[0].log_date}):\n`;
        result.data.forEach((item: any, index: number) => {
          summary += `${index+1}. ${item.food_name} - ${item.total_calories} kalori\n`;
        });
        return summary;
      }

      return "Gagal mengambil riwayat makan";

    } catch (error) {
      console.error(error);
      return "Gagal mengambil riwayat makan";
    }
  }
});

// ==========================================
// TOOL BARU DITAMBAHKAN DI BAWAH SINI
// ==========================================

export const cekProfilUser = createTool({
  name: "cekProfilUser",

  description: "Mengambil data profil kesehatan user (penyakit, target, tingkat aktivitas, stres, dll) dari database berdasarkan nomor WA",

  parameters: z.object({
    nomorWa: z.string().describe("Nomor WA user dari konteks sistem"),
  }),

  execute: async ({ nomorWa }) => {
    try {
      console.log("=================================");
      console.log("TOOL cekProfilUser DIPANGGIL");
      console.log("Nomor WA:", nomorWa);
      console.log("=================================");

      const response = await fetch(
        `https://api-healthify.tifpsdku.com/api/cek-profil.php?nomor_wa=${nomorWa}`
      );

      const result = await response.json();

      if (result.status === "error") {
        return "Profil tidak ditemukan. User mungkin belum mengisi data di aplikasi.";
      }

      // Mengembalikan data JSON profil kesehatan agar dibaca oleh AI
      return JSON.stringify(result.data);

    } catch (error) {
      return "Gagal mengambil data profil user.";
    }
  }
});

export const weeklyHealthReport = createTool({
  name: "weeklyHealthReport",

  description: "Mengambil laporan kesehatan mingguan user",

  parameters: z.object({
    nomorWa: z.string()
  }),

  execute: async ({ nomorWa }) => {

    const response = await fetch(
      `https://api-healthify.tifpsdku.com/api/weekly-report.php?nomor_wa=${nomorWa}`
    );

    const result = await response.json();

    return `
LAPORAN_MINGGUAN_SELESAI

${result.report}
`;
  }
});

// ==========================================
// TOOL UPDATE TINGGI & BERAT BADAN
// ==========================================

export const updateProfilUser = createTool({
  name: "updateProfilUser",
  description: "Memperbarui data tinggi dan berat badan user di database",
  parameters: z.object({
    tinggi: z.number().optional().describe("Tinggi badan dalam cm"),
    berat: z.number().optional().describe("Berat badan dalam kg"),
    height: z.number().optional().describe("Tinggi badan fallback"),
    weight: z.number().optional().describe("Berat badan fallback"),
    nomorWa: z.string().describe("Nomor WA user dari konteks sistem"),
  }),
  execute: async (args) => {
    // Tangkap angka dari bahasa Indonesia maupun bahasa Inggris
    const finalTinggi = args.tinggi || args.height || 0;
    const finalBerat = args.berat || args.weight || 0;

    try {
      console.log("=================================");
      console.log("TOOL updateProfilUser DIPANGGIL");
      console.log("Tinggi Baru:", finalTinggi, "Berat Baru:", finalBerat);
      console.log("Nomor WA:", args.nomorWa);
      console.log("=================================");

      const response = await fetch("https://api-healthify.tifpsdku.com/api/update-profil.php", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          tinggi: finalTinggi,
          berat: finalBerat,
          nomor_wa: args.nomorWa
        })
      });

      const result = await response.json();

      if (result.status === "success") {
        return `Berhasil memperbarui profil. Tinggi: ${finalTinggi}cm, Berat: ${finalBerat}kg. Sistem menghitung BMI Baru menjadi ${result.data.bmi_baru} (${result.data.klasifikasi_baru}). Beritahu user hasilnya dengan ramah.`;
      }

      return `Gagal mengupdate data: ${result.message}`;

    } catch (error: any) {
      console.error(error);
      return `Error: ${error.message}`;
    }
  }
});