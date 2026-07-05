import { useEffect, useState } from "react";
import axiosClient from "../api/axios";
import {
  ResponsiveContainer, AreaChart, Area,
  XAxis, YAxis, CartesianGrid, Tooltip, BarChart, Bar,
} from "recharts";

// =====================
// Reusable Components
// =====================
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
      <div style={{ color: "#F9FAFB", fontSize: 26, fontWeight: 700, marginTop: 6 }}>{value}</div>
    </div>
  );
}

function SectionCard({ title, children }) {
  return (
    <div style={{ background: "#1E1E2E", borderRadius: 14, padding: "20px 22px" }}>
      <h3 style={{ marginTop: 0, marginBottom: 18, color: "#F9FAFB", fontSize: 15 }}>{title}</h3>
      {children}
    </div>
  );
}

// =====================
// Modal Detail Report per User
// =====================
function ReportDetailModal({ userId, userName, onClose }) {
  const [report, setReport] = useState(null);
  const [loading, setLoading] = useState(true);
  const [expertNote, setExpertNote] = useState("");
  const [saving, setSaving] = useState(false);

  useEffect(() => {
    axiosClient.get(`/weekly-report/${userId}`)
      .then((res) => {
        setReport(res.data);
        setExpertNote(res.data.data?.expert_note || "");
      })
      .catch(console.error)
      .finally(() => setLoading(false));
  }, [userId]);

  const handleSaveNote = async () => {
    setSaving(true);
    try {
      await axiosClient.put(`/admin/weekly-reports/${report.data.id}/note`, {
        expert_note: expertNote,
      });
      alert("Catatan berhasil disimpan.");
    } catch {
      alert("Gagal menyimpan catatan.");
    } finally {
      setSaving(false);
    }
  };

  return (
    <div onClick={onClose} style={{
      position: "fixed", inset: 0, background: "rgba(0,0,0,0.7)",
      display: "flex", alignItems: "center", justifyContent: "center",
      zIndex: 50, padding: 20,
    }}>
      <div onClick={(e) => e.stopPropagation()} style={{
        background: "#1E1E2E", borderRadius: 18, padding: 28,
        width: "100%", maxWidth: 560, color: "#F9FAFB",
        maxHeight: "85vh", overflowY: "auto",
      }}>
        {/* Header */}
        <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: 24 }}>
          <div>
            <h3 style={{ margin: 0, fontSize: 16, fontWeight: 700 }}>Weekly Report</h3>
            <p style={{ margin: "4px 0 0", fontSize: 12, color: "#6B7280" }}>{userName}</p>
          </div>
          <button onClick={onClose} style={{
            border: "none", background: "#2D2D3F", color: "#9CA3AF",
            width: 28, height: 28, borderRadius: 8, cursor: "pointer", fontSize: 14,
          }}>✕</button>
        </div>

        {loading ? (
          <p style={{ color: "#6B7280", textAlign: "center" }}>Memuat laporan...</p>
        ) : !report ? (
          <p style={{ color: "#6B7280", textAlign: "center" }}>Laporan tidak ditemukan.</p>
        ) : (
          <>
            {/* Ringkasan */}
            <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: 10, marginBottom: 20 }}>
              <StatTile label="Perubahan Berat" value={
                report.data?.weight_change != null
                  ? `${report.data.weight_change > 0 ? "+" : ""}${report.data.weight_change} kg`
                  : "-"
              } color={report.data?.weight_change < 0 ? "#34D399" : "#F87171"} />
              <StatTile label="Rata-rata Kalori" value={report.data?.avg_calories ? `${report.data.avg_calories} kkal` : "-"} />
              <StatTile label="Makanan Terpopuler" value={report.data?.frequent_food || "-"} />
              <StatTile label="BMI Terakhir" value={report.latest_screening?.imt_value || "-"} />
            </div>

            {/* Ringkasan teks */}
            {report.data?.report_text && (
              <div style={{
                background: "#13131F", borderRadius: 12, padding: "14px 16px",
                fontSize: 13, color: "#9CA3AF", lineHeight: 1.7, marginBottom: 20,
              }}>
                {report.data.report_text}
              </div>
            )}

            {/* Rekomendasi AI */}
            {report.data?.recommendation && (
              <div style={{ marginBottom: 20 }}>
                <p style={{ fontSize: 11, color: "#6B7280", textTransform: "uppercase", letterSpacing: 0.5, marginBottom: 8 }}>
                  Rekomendasi AI
                </p>
                <div style={{
                  background: "#0d2e28", border: "1px solid #1a4a3f",
                  borderRadius: 12, padding: "14px 16px",
                  fontSize: 13, color: "#34D399", lineHeight: 1.7,
                }}>
                  {report.data.recommendation}
                </div>
              </div>
            )}

            {/* Top Foods */}
            {report.top_foods?.length > 0 && (
              <div style={{ marginBottom: 20 }}>
                <p style={{ fontSize: 11, color: "#6B7280", textTransform: "uppercase", letterSpacing: 0.5, marginBottom: 8 }}>
                  Top Makanan Minggu Ini
                </p>
                {report.top_foods.map((food, i) => (
                  <div key={i} style={{
                    display: "flex", justifyContent: "space-between",
                    padding: "10px 0", borderBottom: "1px solid #2D2D3F",
                    fontSize: 13,
                  }}>
                    <span>{food.food_name}</span>
                    <span style={{ color: "#9CA3AF" }}>{food.jumlah}x</span>
                  </div>
                ))}
              </div>
            )}

            {/* Catatan Expert */}
            <div>
              <p style={{ fontSize: 11, color: "#6B7280", textTransform: "uppercase", letterSpacing: 0.5, marginBottom: 8 }}>
                Catatan Expert
              </p>
              <textarea
                value={expertNote}
                onChange={(e) => setExpertNote(e.target.value)}
                placeholder="Tambahkan catatan untuk user ini..."
                style={{
                  width: "100%", height: 100,
                  background: "#13131F", border: "1px solid #2D2D3F",
                  borderRadius: 10, padding: 12, color: "#fff",
                  resize: "none", outline: "none", fontSize: 13,
                  boxSizing: "border-box",
                }}
              />
              <button onClick={handleSaveNote} disabled={saving} style={{
                marginTop: 10, border: "none", background: "#34D399",
                color: "#fff", padding: "10px 16px", borderRadius: 10,
                cursor: "pointer", fontSize: 13, fontWeight: 600,
              }}>
                {saving ? "Menyimpan..." : "Simpan Catatan"}
              </button>
            </div>
          </>
        )}
      </div>
    </div>
  );
}

function StatTile({ label, value, color }) {
  return (
    <div style={{ background: "#13131F", borderRadius: 12, padding: "12px 14px" }}>
      <div style={{ fontSize: 11, color: "#6B7280", marginBottom: 4 }}>{label}</div>
      <div style={{ fontSize: 15, fontWeight: 700, color: color || "#F9FAFB" }}>{value}</div>
    </div>
  );
}

// =====================
// Main Component
// =====================
export default function WeeklyReports() {
  const [plans, setPlans] = useState([]);
  const [loading, setLoading] = useState(true);
  const [selectedUser, setSelectedUser] = useState(null); // { id, name }
  const [search, setSearch] = useState("");

  useEffect(() => {
    axiosClient.get("/admin/weekly-plans")
      .then((res) => setPlans(res.data.data || []))
      .catch(console.error)
      .finally(() => setLoading(false));
  }, []);

  const filteredPlans = plans.filter((p) =>
    p.user?.name?.toLowerCase().includes(search.toLowerCase()) ||
    p.focus?.toLowerCase().includes(search.toLowerCase())
  );

  // Stat summary
  const totalPlans = plans.length;

  return (
    <div style={{
      background: "#13131F", minHeight: "100vh",
      padding: 28, color: "#F9FAFB", fontFamily: "Inter, sans-serif",
    }}>
      {/* Header */}
      <div style={{ marginBottom: 28 }}>
        <h1 style={{ margin: 0, fontSize: 22, fontWeight: 700 }}>Weekly AI Reports</h1>
        <p style={{ marginTop: 5, color: "#6B7280", fontSize: 13 }}>
          Pantau perkembangan mingguan seluruh pengguna dan kelola catatan expert
        </p>
      </div>

      {/* Stat Cards */}
      <div style={{ display: "flex", gap: 14, marginBottom: 20 }}>
        <StatCard icon="📋" title="Total Weekly Plans" value={totalPlans} color="#818CF8" />
        <StatCard icon="⚖️" title="Avg Weight Target" value="−1 kg/minggu" color="#34D399" />
        <StatCard icon="🤖" title="AI Generated Plans" value={totalPlans} color="#FBBF24" />
        <StatCard icon="👨‍⚕️" title="Perlu Review Expert" value={totalPlans} color="#60A5FA" />
      </div>

      {/* Weekly Plans Table */}
      <SectionCard title="Weekly AI Plans — Semua User">
        {/* Search */}
        <div style={{ marginBottom: 16 }}>
          <input
            placeholder="Cari user atau fokus plan..."
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            style={{
              background: "#13131F", border: "1px solid #2D2D3F",
              borderRadius: 10, padding: "11px 14px", color: "#fff",
              outline: "none", fontSize: 13, width: "100%", boxSizing: "border-box",
            }}
          />
        </div>

        <table style={{ width: "100%", borderCollapse: "collapse" }}>
          <thead>
            <tr>
              {["User", "Fokus Minggu Ini", "Target Aktivitas", "Kebiasaan Kecil", "Menu", "Aksi"].map((h) => (
                <th key={h} style={tableHead}>{h}</th>
              ))}
            </tr>
          </thead>
          <tbody>
            {loading ? (
              <tr>
                <td colSpan={6} style={{ ...tableCell, textAlign: "center", color: "#6B7280", padding: "32px 0" }}>
                  Memuat data...
                </td>
              </tr>
            ) : filteredPlans.length === 0 ? (
              <tr>
                <td colSpan={6} style={{ ...tableCell, textAlign: "center", color: "#6B7280", padding: "32px 0" }}>
                  Belum ada weekly plan.
                </td>
              </tr>
            ) : (
              filteredPlans.map((plan) => (
                <tr key={plan.id}>
                  <td style={tableCell}>
                    <div style={{ fontWeight: 600 }}>{plan.user?.name || `User #${plan.user_id}`}</div>
                    <div style={{ fontSize: 11, color: "#6B7280", marginTop: 2 }}>
                      {plan.updated_at ? new Date(plan.updated_at).toLocaleDateString("id-ID") : "-"}
                    </div>
                  </td>
                  <td style={{ ...tableCell, maxWidth: 160 }}>
                    <div style={{ fontSize: 12, color: "#9CA3AF", lineHeight: 1.5 }}>
                      {plan.focus || "-"}
                    </div>
                  </td>
                  <td style={{ ...tableCell, maxWidth: 140 }}>
                    <div style={{ fontSize: 12, color: "#9CA3AF", lineHeight: 1.5 }}>
                      {plan.activity_target || "-"}
                    </div>
                  </td>
                  <td style={{ ...tableCell, maxWidth: 140 }}>
                    <div style={{ fontSize: 12, color: "#9CA3AF", lineHeight: 1.5 }}>
                      {plan.small_habit || "-"}
                    </div>
                  </td>
                  <td style={{ ...tableCell, maxWidth: 140 }}>
                    <div style={{ fontSize: 12, color: "#9CA3AF", lineHeight: 1.5 }}>
                      {plan.menu_recommendation || "-"}
                    </div>
                  </td>
                  <td style={tableCell}>
                    <button
                      style={detailBtn}
                      onClick={() => setSelectedUser({ id: plan.user_id, name: plan.user?.name || `User #${plan.user_id}` })}
                    >
                      Lihat Report
                    </button>
                  </td>
                </tr>
              ))
            )}
          </tbody>
        </table>
      </SectionCard>

      {/* Modal Detail */}
      {selectedUser && (
        <ReportDetailModal
          userId={selectedUser.id}
          userName={selectedUser.name}
          onClose={() => setSelectedUser(null)}
        />
      )}
    </div>
  );
}

// =====================
// Styles
// =====================
const tableHead = {
  textAlign: "left", paddingBottom: 12,
  color: "#6B7280", fontSize: 12,
  borderBottom: "1px solid #2D2D3F",
};

const tableCell = {
  padding: "14px 8px 14px 0",
  borderBottom: "1px solid #2D2D3F",
  color: "#F9FAFB", fontSize: 13,
  verticalAlign: "top",
};

const detailBtn = {
  border: "none", background: "#818CF8",
  color: "#fff", padding: "7px 12px",
  borderRadius: 8, cursor: "pointer", fontSize: 12, fontWeight: 600,
};