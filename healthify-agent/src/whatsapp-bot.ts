import pkg from "whatsapp-web.js";
const { Client, LocalAuth } = pkg;

import qrcode from "qrcode-terminal";

const client = new Client({
    authStrategy: new LocalAuth()
});

client.on("qr", (qr: string) => {
    qrcode.generate(qr, { small: true });
    console.log("Scan QR WhatsApp");
});

client.on("ready", () => {
    console.log("WhatsApp Bot Ready");
});

// Simpan mapping sementara LID → Real Number (kalau suatu saat ketemu)
const numberMapping = new Map<string, string>();

client.on("message", async (msg: any) => {
    if (msg.fromMe) return;

    console.log("==================================");
    console.log("PESAN MASUK:", msg.body);
    console.log("==================================");

    try {
        let senderWa = "";

        // ================== PRO DETECTION LOGIC ==================
        const rawFrom = msg.from;

const contact = await msg.getContact();

console.log("RAW FROM:", msg.from);
console.log("CONTACT:", contact);
console.log("CONTACT ID:", contact?.id);
console.log("CONTACT USER:", contact?.id?.user);
console.log("CONTACT NUMBER:", contact?.number);

const candidates = [
    contact?.id?.user,
    contact?.number,
    msg?.author,
    msg?.id?.participant,
    rawFrom?.replace("@c.us", "")
];

for (const candidate of candidates) {
    if (
        candidate &&
        candidate.startsWith("62") &&
        candidate.length >= 10 &&
        candidate.length <= 15
    ) {
        senderWa = candidate;
        break;
    }
}

        // 3. Kalau masih LID (angka panjang > 12 digit), simpan dulu
        if (senderWa.length > 12 && /^\d+$/.test(senderWa)) {
            console.log("⚠️ Mendeteksi LID:", senderWa);
            // Kita tetap pakai dulu, nanti mapping kalau ketemu nomor asli
        }

        // Validasi akhir
        if (!senderWa || !/^\d+$/.test(senderWa) || senderWa.length < 8) {
            console.log("❌ Gagal deteksi nomor:", rawFrom);
            await msg.reply("Maaf, aku belum bisa membaca nomor kamu. Coba chat lagi ya.");
            return;
        }

        console.log("✅ Nomor WA yang dipakai:", senderWa);
        // =======================================================
        const pesan = msg.body.toLowerCase();

        if (
            pesan.includes("progress saya minggu ini") ||
            pesan.includes("laporan minggu ini") ||
            pesan.includes("weekly report") ||
            pesan.includes("perkembangan saya")
        ) {
            try {
                const reportResponse = await fetch(
                    `http://localhost/healthify/weekly-report.php?nomor_wa=${senderWa}`
                );

                const reportData = await reportResponse.json();

                await msg.reply(reportData.report);

                return;
            } catch (err) {
                console.error("Weekly Report Error:", err);
                await msg.reply("Gagal mengambil laporan mingguan.");
                return;
            }
        }

        

        const response = await fetch(
            "https://araeostyle-pura-transgressively.ngrok-free.dev/agents/healthify-agent/chat",
            {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({
                    input: `[Sistem: Nomor_WA=${senderWa}]\n\n${msg.body}`,
                    options: {
                        conversationId: senderWa
                    }
                })
            }
        );

        const rawText = await response.text();
        const cleanText = parseVoltAgentStream(rawText);

        console.log("RESPON BERSIH:");
        console.log(cleanText);

        await msg.reply(cleanText || "Maaf, aku lagi sibuk nih. Coba lagi ya!");

    } catch (error) {
        console.error("Error:", error);
        await msg.reply("Server VoltAgent sedang tidak aktif. Coba lagi nanti ya.");
    }
});

function parseVoltAgentStream(rawText: string): string {
    const lines = rawText.split("\n");
    let textResponse = "";
    let isToolCall = false;

    for (const line of lines) {
        if (line.startsWith("data: ")) {
            const jsonText = line.replace("data: ", "").trim();

            if (jsonText === "" || jsonText === "[DONE]") continue;

            try {
                const data = JSON.parse(jsonText);

                if (data.type === "tool-call") isToolCall = true;
                if (data.type === "text-delta" && data.delta) textResponse += data.delta;
                if (data.type === "final" && data.content) textResponse = data.content;

            } catch (e) { continue; }
        }
    }

    textResponse = textResponse.trim();

    if (!textResponse && isToolCall) {
        return "Data sudah tercatat ya. Ada yang bisa aku bantu lagi?";
    }

    return textResponse || "Maaf, aku kurang paham. Bisa diulang lagi?";
}

client.initialize();