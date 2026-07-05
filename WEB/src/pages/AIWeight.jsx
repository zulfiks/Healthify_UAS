import { useEffect, useState } from "react";
import axiosClient from "../api/axios";

const statusColor = {
  Aktif: { bg: "#D1FAE5", text: "#059669" },
};

function StatCard({ icon, title, value, color }) {
  return (
    <div style={{ background: "#1E1E2E", borderRadius: 14, padding: 20, flex: 1 }}>
      <div style={{
        width: 42, height: 42, borderRadius: 10,
        background: `${color}22`, display: "flex",
        alignItems: "center", justifyContent: "center",
        marginBottom: 12, fontSize: 18,
      }}>
        {icon}
      </div>
      <div style={{ color: "#9CA3AF", fontSize: 13 }}>{title}</div>
      <div style={{ color: "#F9FAFB", fontSize: 28, fontWeight: 700, marginTop: 6 }}>{value}</div>
    </div>
  );
}

function PlanDetailModal({ plan, onClose }) {
  return (
    <div onClick={onClose} style={{
      position: "fixed", inset: 0, background: "rgba(0,0,0,0.7)",
      display: "flex", alignItems: "center", justifyContent: "center", zIndex: 50, padding: 20,
    }}>
      <div onClick={(e) => e.stopPropagation()} style={{
        background: "#1E1E2E", borderRadius: 18, padding: 28,
        width: "100%", maxWidth: 500, color: "#F9FAFB", maxHeight: "85vh", overflowY: "auto",
      }}>
        <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: 24 }}>
          <div>
            <h3 style={{ margin: 0, fontSize: 16, fontWeight: 700 }}>Detail Plan</h3>
            <p style={{ margin: "4px 0 0", fontSize: 12, color: "#6B7280" }}>{plan.user?.name}</p>
          </div>
          <button onClick={onClose} style={{
            border: "none", background: "#2D2D3F", color: "#9CA3AF",
            width: 28, height: 28, borderRadius: 8, cursor: "pointer", fontSize: 14,
          }}>✕</button>
        </div>

        {[
          { label: "Fokus Minggu Ini", value: plan.focus },
          { label: "Target Aktivitas", value: plan.activity_target },
          { label: "Kebiasaan Kecil", value: plan.small_habit },
          { label: "Menu Rekomendasi", value: plan.menu_recommendation },
        ].map((item) => (
          <div key={item.label} style={{ marginBottom: 16 }}>
            <p style={{ fontSize: 11, color: "#6B7280", textTransform: "uppercase", letterSpacing: 0.5, marginBottom: 6 }}>
              {item.label}
            </p>
            <div style={{
              background: "#13131F", borderRadius: 10, padding: "12px 14px",
              fontSize: 13, color: "#9CA3AF", lineHeight: 1.6,
            }}>
              {item.value || "-"}
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}

export default function AIWeightPlan() {
  const [search, setSearch]   = useState("");
  const [plans, setPlans]     = useState([]);
  const [loading, setLoading] = useState(true);
  const [prompt, setPrompt]   = useState("");
  const [saving, setSaving]   = useState(false);
  const [selectedPlan, setSelectedPlan] = useState(null);

  useEffect(() => {
    // Fetch weekly plans
    axiosClient.get("/admin/weekly-plans")
      .then((res) => setPlans(res.data.data || []))
      .catch(console.error)
      .finally(() => setLoading(false));

    // Fetch AI prompt
    axiosClient.get("/admin/ai-settings")
      .then((res) => {
        const data = res.data.data || [];
        const promptSetting = data.find((s) => s.key === "ai_plan_prompt");
        setPrompt(promptSetting?.value || "");
      })
      .catch(console.error);
  }, []);

  const savePrompt = async () => {
    try {
      setSaving(true);
      await axiosClient.put("/admin/ai-settings/ai_plan_prompt", {
        value: prompt,
      });
      alert("AI Prompt berhasil disimpan!");
    } catch {
      alert("Gagal menyimpan prompt.");
    } finally {
      setSaving(false);
    }
  };

  const filteredPlans = plans.filter((item) =>
    item.user?.name?.toLowerCase().includes(search.toLowerCase())
  );

  return (
    <div style={{
      background: "#13131F", minHeight: "100vh",
      padding: 28, color: "#F9FAFB", fontFamily: "Inter, sans-serif",
    }}>
      {/* Header */}
      <div style={{ marginBottom: 28 }}>
        <h1 style={{ margin: 0, fontSize: 22, fontWeight: 700 }}>AI Weight Loss Plan</h1>
        <p style={{ marginTop: 5, color: "#6B7280", fontSize: 13 }}>
          Kelola dan pantau rekomendasi penurunan berat badan yang dibuat AI
        </p>
      </div>

      {/* Stat Cards */}
      <div style={{ display: "flex", gap: 14, marginBottom: 20 }}>
        <StatCard icon="🤖" title="Plan Aktif"        value={plans.length} color="#818CF8" />
        <StatCard icon="📉" title="Total User"         value={plans.length} color="#34D399" />
        <StatCard icon="🔥" title="Target Aktivitas"   value={plans.length} color="#FBBF24" />
        <StatCard icon="🩺" title="Need Review"        value="0"            color="#F87171" />
      </div>

      {/* Search */}
      <div style={{ background: "#1E1E2E", borderRadius: 14, padding: 20, marginBottom: 18 }}>
        <input
          placeholder="Cari pengguna..."
          value={search}
          onChange={(e) => setSearch(e.target.value)}
          style={{
            width: "100%", background: "#13131F", border: "1px solid #2D2D3F",
            borderRadius: 10, padding: "12px 14px", color: "#fff", outline: "none",
          }}
        />
      </div>

      {/* Table */}
      <div style={{ background: "#1E1E2E", borderRadius: 14, padding: "20px 22px", marginBottom: 18 }}>
        <h3 style={{ marginTop: 0, marginBottom: 18 }}>Active AI Plans</h3>
        <table style={{ width: "100%", borderCollapse: "collapse" }}>
          <thead>
            <tr>
              {["User", "Focus", "Target Aktivitas", "Status", "Aksi"].map((h) => (
                <th key={h} style={tableHead}>{h}</th>
              ))}
            </tr>
          </thead>
          <tbody>
            {loading ? (
              <tr><td colSpan={5} style={{ ...tableCell, textAlign: "center", color: "#6B7280", padding: "32px 0" }}>Memuat...</td></tr>
            ) : filteredPlans.length === 0 ? (
              <tr><td colSpan={5} style={{ ...tableCell, textAlign: "center", color: "#6B7280", padding: "32px 0" }}>Belum ada plan.</td></tr>
            ) : (
              filteredPlans.map((plan) => (
                <tr key={plan.id}>
                  <td style={{ ...tableCell, fontWeight: 600 }}>{plan.user?.name || "-"}</td>
                  <td style={{ ...tableCell, maxWidth: 180, fontSize: 12, color: "#9CA3AF" }}>{plan.focus || "-"}</td>
                  <td style={{ ...tableCell, maxWidth: 160, fontSize: 12, color: "#9CA3AF" }}>{plan.activity_target || "-"}</td>
                  <td style={tableCell}>
                    <span style={{
                      padding: "4px 10px", borderRadius: 999, fontSize: 11, fontWeight: 600,
                      background: statusColor.Aktif.bg, color: statusColor.Aktif.text,
                    }}>Aktif</span>
                  </td>
                  <td style={tableCell}>
                    <button
                      onClick={() => setSelectedPlan(plan)}
                      style={{ border: "none", background: "#818CF8", color: "#fff", padding: "7px 12px", borderRadius: 8, cursor: "pointer", fontSize: 12, fontWeight: 600 }}
                    >
                      Lihat Plan
                    </button>
                  </td>
                </tr>
              ))
            )}
          </tbody>
        </table>
      </div>

      {/* AI Prompt Control */}
      <div style={{ background: "#1E1E2E", borderRadius: 14, padding: 24, marginBottom: 18 }}>
        <h3 style={{ marginTop: 0, marginBottom: 8 }}>AI Prompt Control</h3>
        <p style={{ color: "#9CA3AF", fontSize: 13, marginBottom: 14 }}>
          Ubah perilaku AI Weight Loss Plan realtime tanpa edit code.
        </p>
        <textarea
          value={prompt}
          onChange={(e) => setPrompt(e.target.value)}
          rows={16}
          style={{
            width: "100%", background: "#13131F", border: "1px solid #2D2D3F",
            borderRadius: 12, padding: 14, color: "#fff", outline: "none",
            resize: "vertical", fontSize: 13, lineHeight: 1.6, boxSizing: "border-box",
          }}
        />
        <button
          onClick={savePrompt}
          disabled={saving}
          style={{
            marginTop: 16, border: "none", background: "#2CF2B4", color: "#000",
            padding: "12px 20px", borderRadius: 10, cursor: "pointer", fontWeight: 700, fontSize: 13,
          }}
        >
          {saving ? "Menyimpan..." : "Simpan AI Prompt"}
        </button>
      </div>

      {/* Modal */}
      {selectedPlan && <PlanDetailModal plan={selectedPlan} onClose={() => setSelectedPlan(null)} />}
    </div>
  );
}

const tableHead = {
  textAlign: "left", paddingBottom: 12,
  color: "#6B7280", fontSize: 12,
  borderBottom: "1px solid #2D2D3F",
};
const tableCell = {
  padding: "14px 8px 14px 0",
  borderBottom: "1px solid #2D2D3F",
  color: "#F9FAFB", fontSize: 13, verticalAlign: "top",
};