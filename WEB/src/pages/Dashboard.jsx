import { useEffect, useState } from "react";
import axiosClient from "../api/axios";
import {
  AreaChart,
  Area,
  BarChart,
  Bar,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  ResponsiveContainer,
  PieChart,
  Pie,
  Cell,
} from "recharts";

const weeklyUserData = [
  { day: "Sen", active: 820 },
  { day: "Sel", active: 940 },
  { day: "Rab", active: 880 },
  { day: "Kam", active: 1100 },
  { day: "Jum", active: 970 },
  { day: "Sab", active: 750 },
  { day: "Min", active: 690 },
];

const foodLogData = [
  { day: "Sen", logs: 1240 },
  { day: "Sel", logs: 1380 },
  { day: "Rab", logs: 1190 },
  { day: "Kam", logs: 1520 },
  { day: "Jum", logs: 1410 },
  { day: "Sab", logs: 980 },
  { day: "Min", logs: 870 },
];


const monthlyGrowth = [
  { bulan: "Jan", pengguna: 4200 },
  { bulan: "Feb", pengguna: 4800 },
  { bulan: "Mar", pengguna: 5300 },
  { bulan: "Apr", pengguna: 6100 },
  { bulan: "Mei", pengguna: 6800 },
  { bulan: "Jun", pengguna: 7540 },
];

const statusColor = {
  Kritis: { bg: "#FEE2E2", text: "#DC2626" },
  Review: { bg: "#FEF3C7", text: "#B45309" },
  Selesai: { bg: "#D1FAE5", text: "#059669" },
};

function StatCard({ icon, label, value, sub, subColor, accentColor }) {
  return (
    <div
      style={{
        background: "#1E1E2E",
        borderRadius: 14,
        padding: "20px 22px",
        display: "flex",
        flexDirection: "column",
        gap: 10,
        flex: "1 1 0",
        minWidth: 0,
      }}
    >
      <div
        style={{
          width: 40,
          height: 40,
          borderRadius: 10,
          background: accentColor + "22",
          display: "flex",
          alignItems: "center",
          justifyContent: "center",
          fontSize: 20,
          color: accentColor,
        }}
      >
        {icon}
      </div>
      <div>
        <div style={{ fontSize: 13, color: "#9CA3AF", marginBottom: 4 }}>{label}</div>
        <div style={{ fontSize: 26, fontWeight: 700, color: "#F9FAFB", letterSpacing: -0.5 }}>
          {value}
        </div>
        {sub && (
          <div style={{ fontSize: 12, color: subColor || "#6EE7B7", marginTop: 4 }}>{sub}</div>
        )}
      </div>
    </div>
  );
}

export default function AdminDashboard() {
  const [period, setPeriod] = useState("7 Hari");
  const [dashboardData, setDashboardData] = useState(null);
  const [recentAlerts, setRecentAlerts] = useState([]);
  const [obesityDistribution, setObesityDistribution] = useState([]);

  useEffect(() => {
    axiosClient
      .get("/admin/dashboard")
      .then((res) => {
        const data = res.data;

        setDashboardData(data);
        setRecentAlerts(data.recent_alerts || []);

        setObesityDistribution(
          (data.bmi_distribution || []).map((item) => ({
            ...item,
            color:
              item.name === "Normal"
                ? "#6EE7B7"
                : item.name === "Overweight"
                ? "#FCD34D"
                : item.name === "Obesitas"
                ? "#F87171"
                : "#EF4444",
          }))
        );
      })
      .catch((err) => console.error(err));
  }, []);

  return (
    <div
      style={{
        background: "#13131F",
        minHeight: "100vh",
        padding: "28px 32px",
        fontFamily: "'Inter', sans-serif",
        color: "#F9FAFB",
        boxSizing: "border-box",
      }}
    >
      {/* Header */}
      <div
        style={{
          display: "flex",
          justifyContent: "space-between",
          alignItems: "center",
          marginBottom: 28,
        }}
      >
        <div>
          <h1 style={{ fontSize: 22, fontWeight: 700, margin: 0, color: "#F9FAFB" }}>
            Dashboard Admin
          </h1>
          <p style={{ fontSize: 13, color: "#6B7280", margin: "4px 0 0" }}>
            Pantau aktivitas pengguna & kesehatan sistem
          </p>
        </div>
        <div style={{ display: "flex", gap: 8 }}>
          {["7 Hari", "30 Hari", "90 Hari"].map((p) => (
            <button
              key={p}
              onClick={() => setPeriod(p)}
              style={{
                padding: "7px 16px",
                borderRadius: 8,
                border: "none",
                cursor: "pointer",
                fontSize: 13,
                fontWeight: 500,
                background: period === p ? "#7C3AED" : "#1E1E2E",
                color: period === p ? "#fff" : "#9CA3AF",
                transition: "all 0.15s",
              }}
            >
              {p}
            </button>
          ))}
        </div>
      </div>

      {/* Stat Cards Row */}
      <div style={{ display: "flex", gap: 14, marginBottom: 22, flexWrap: "wrap" }}>
        <StatCard
          icon="👤"
          label="Total Pengguna"
          value={dashboardData?.total_users ?? 0}
          accentColor="#818CF8"
        />

        <StatCard
          icon="🍽️"
          label="Jumlah Food Log"
          value={dashboardData?.total_food_logs || 0}
          sub="Bulan ini"
          accentColor="#FBBF24"
        />

        <StatCard
          icon="⚠️"
          label="Alert Obesitas"
          value={dashboardData?.obesity_alerts ?? 0}
          sub="Pengguna risiko tinggi"
          subColor="#F87171"
          accentColor="#F87171"
        />
      </div>

      {/* Charts Row 1 */}
      <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: 16, marginBottom: 16 }}>
        {/* Active Users Chart */}
        <div style={{ background: "#1E1E2E", borderRadius: 14, padding: "20px 22px" }}>
          <div style={{ marginBottom: 16 }}>
            <div style={{ fontSize: 14, fontWeight: 600, color: "#F9FAFB" }}>
              Pengguna Aktif Harian
            </div>
            <div style={{ fontSize: 12, color: "#6B7280", marginTop: 2 }}>
              7 hari terakhir
            </div>
          </div>
          <ResponsiveContainer width="100%" height={180}>
            <AreaChart data={weeklyUserData}>
              <defs>
                <linearGradient id="activeGrad" x1="0" y1="0" x2="0" y2="1">
                  <stop offset="5%" stopColor="#818CF8" stopOpacity={0.3} />
                  <stop offset="95%" stopColor="#818CF8" stopOpacity={0} />
                </linearGradient>
              </defs>
              <CartesianGrid strokeDasharray="3 3" stroke="#2D2D3F" vertical={false} />
              <XAxis dataKey="day" tick={{ fill: "#6B7280", fontSize: 11 }} axisLine={false} tickLine={false} />
              <YAxis tick={{ fill: "#6B7280", fontSize: 11 }} axisLine={false} tickLine={false} />
              <Tooltip
                contentStyle={{ background: "#2D2D3F", border: "none", borderRadius: 8, fontSize: 12 }}
                labelStyle={{ color: "#9CA3AF" }}
              />
              <Area
                type="monotone"
                dataKey="active"
                stroke="#818CF8"
                strokeWidth={2}
                fill="url(#activeGrad)"
              />
            </AreaChart>
          </ResponsiveContainer>
        </div>

        {/* Food Log Chart */}
        <div style={{ background: "#1E1E2E", borderRadius: 14, padding: "20px 22px" }}>
          <div style={{ marginBottom: 16 }}>
            <div style={{ fontSize: 14, fontWeight: 600, color: "#F9FAFB" }}>Jumlah Food Log</div>
            <div style={{ fontSize: 12, color: "#6B7280", marginTop: 2 }}>7 hari terakhir</div>
          </div>
          <ResponsiveContainer width="100%" height={180}>
            <BarChart data={foodLogData} barSize={22}>
              <CartesianGrid strokeDasharray="3 3" stroke="#2D2D3F" vertical={false} />
              <XAxis dataKey="day" tick={{ fill: "#6B7280", fontSize: 11 }} axisLine={false} tickLine={false} />
              <YAxis tick={{ fill: "#6B7280", fontSize: 11 }} axisLine={false} tickLine={false} />
              <Tooltip
                contentStyle={{ background: "#2D2D3F", border: "none", borderRadius: 8, fontSize: 12 }}
                labelStyle={{ color: "#9CA3AF" }}
                cursor={{ fill: "#2D2D3F" }}
              />
              <Bar dataKey="logs" fill="#FBBF24" radius={[4, 4, 0, 0]} />
            </BarChart>
          </ResponsiveContainer>
        </div>
      </div>

      {/* Charts Row 2 */}
      <div style={{ display: "grid", gridTemplateColumns: "1fr", gap: 16, marginBottom: 16 }}>
        {/* Monthly Growth */}
        <div style={{ background: "#1E1E2E", borderRadius: 14, padding: "20px 22px" }}>
          <div style={{ marginBottom: 16 }}>
            <div style={{ fontSize: 14, fontWeight: 600, color: "#F9FAFB" }}>Pertumbuhan Pengguna Bulanan</div>
            <div style={{ fontSize: 12, color: "#6B7280", marginTop: 2 }}>Akumulasi 6 bulan terakhir</div>
          </div>
          <ResponsiveContainer width="100%" height={220}>
            <AreaChart data={monthlyGrowth}>
              <defs>
                <linearGradient id="growthGrad" x1="0" y1="0" x2="0" y2="1">
                  <stop offset="5%" stopColor="#34D399" stopOpacity={0.3} />
                  <stop offset="95%" stopColor="#34D399" stopOpacity={0} />
                </linearGradient>
              </defs>
              <CartesianGrid strokeDasharray="3 3" stroke="#2D2D3F" vertical={false} />
              <XAxis dataKey="bulan" tick={{ fill: "#6B7280", fontSize: 11 }} axisLine={false} tickLine={false} />
              <YAxis tick={{ fill: "#6B7280", fontSize: 11 }} axisLine={false} tickLine={false} />
              <Tooltip
                contentStyle={{ background: "#2D2D3F", border: "none", borderRadius: 8, fontSize: 12 }}
                labelStyle={{ color: "#9CA3AF" }}
              />
              <Area
                type="monotone"
                dataKey="pengguna"
                stroke="#34D399"
                strokeWidth={2}
                fill="url(#growthGrad)"
              />
            </AreaChart>
          </ResponsiveContainer>
        </div>
      </div>

      {/* Bottom Row */}
      <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: 16 }}>
        {/* Recent Obesity Alerts */}
        <div style={{ background: "#1E1E2E", borderRadius: 14, padding: "20px 22px" }}>
          <div
            style={{
              display: "flex",
              justifyContent: "space-between",
              alignItems: "center",
              marginBottom: 16,
            }}
          >
            <div>
              <div style={{ fontSize: 14, fontWeight: 600, color: "#F9FAFB" }}>Alert Obesitas Terbaru</div>
              <div style={{ fontSize: 12, color: "#6B7280", marginTop: 2 }}>Perlu perhatian segera</div>
            </div>
            <span
              style={{
                background: "#FEE2E2",
                color: "#DC2626",
                fontSize: 11,
                fontWeight: 600,
                padding: "3px 10px",
                borderRadius: 20,
              }}
            >
              142 aktif
            </span>
          </div>
          <table style={{ width: "100%", borderCollapse: "collapse" }}>
            <thead>
              <tr>
                {["ID", "Pengguna", "BMI", "Status", "Waktu"].map((h) => (
                  <th
                    key={h}
                    style={{
                      fontSize: 11,
                      color: "#6B7280",
                      fontWeight: 500,
                      textAlign: "left",
                      padding: "0 0 10px",
                      borderBottom: "1px solid #2D2D3F",
                    }}
                  >
                    {h}
                  </th>
                ))}
              </tr>
            </thead>
            <tbody>
              {recentAlerts.map((row, i) => (
                <tr key={i}>
                  <td style={{ fontSize: 12, color: "#818CF8", padding: "10px 0", borderBottom: "1px solid #2D2D3F" }}>
                    {row.id}
                  </td>
                  <td style={{ fontSize: 12, color: "#F9FAFB", padding: "10px 8px 10px 0", borderBottom: "1px solid #2D2D3F" }}>
                    {row.user}
                  </td>
                  <td style={{ fontSize: 12, color: "#F9FAFB", padding: "10px 8px 10px 0", borderBottom: "1px solid #2D2D3F" }}>
                    {row.bmi}
                  </td>
                  <td style={{ padding: "10px 8px 10px 0", borderBottom: "1px solid #2D2D3F" }}>
                    <span
                      style={{
                        fontSize: 11,
                        fontWeight: 600,
                        padding: "3px 10px",
                        borderRadius: 20,
                        background: statusColor[row.status]?.bg,
                        color: statusColor[row.status]?.text,
                      }}
                    >
                      {row.status}
                    </span>
                  </td>
                  <td style={{ fontSize: 11, color: "#6B7280", padding: "10px 0", borderBottom: "1px solid #2D2D3F" }}>
                    {row.time}
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>

        {/* Coaching & Expert Review */}
        <div style={{ display: "flex", flexDirection: "column", gap: 14 }}>
          {/* Coaching Status */}
          <div style={{ background: "#1E1E2E", borderRadius: 14, padding: "20px 22px" }}>
            <div style={{ fontSize: 14, fontWeight: 600, color: "#F9FAFB", marginBottom: 16 }}>
              Coaching Berjalan
            </div>
            <div style={{ display: "flex", flexDirection: "column", gap: 10 }}>
              {[
                { label: "Sesi aktif hari ini", value: 318, max: 500, color: "#60A5FA" },
                { label: "Selesai minggu ini", value: 212, max: 300, color: "#34D399" },
                { label: "Terjadwal besok", value: 95, max: 200, color: "#FBBF24" },
              ].map((item) => (
                <div key={item.label}>
                  <div
                    style={{
                      display: "flex",
                      justifyContent: "space-between",
                      fontSize: 12,
                      color: "#9CA3AF",
                      marginBottom: 5,
                    }}
                  >
                    <span>{item.label}</span>
                    <span style={{ color: "#F9FAFB", fontWeight: 600 }}>
                      {item.value} / {item.max}
                    </span>
                  </div>
                  <div
                    style={{
                      height: 6,
                      background: "#2D2D3F",
                      borderRadius: 99,
                      overflow: "hidden",
                    }}
                  >
                    <div
                      style={{
                        height: "100%",
                        width: `${(item.value / item.max) * 100}%`,
                        background: item.color,
                        borderRadius: 99,
                      }}
                    />
                  </div>
                </div>
              ))}
            </div>
          </div>

          {/* Expert Review */}
          <div style={{ background: "#1E1E2E", borderRadius: 14, padding: "20px 22px", flex: 1 }}>
            <div style={{ fontSize: 14, fontWeight: 600, color: "#F9FAFB", marginBottom: 16 }}>
              Review oleh Expert
            </div>
            <div
              style={{
                display: "grid",
                gridTemplateColumns: "1fr 1fr",
                gap: 10,
              }}
            >
              {[
                { label: "Menunggu Review", value: "23", color: "#FCD34D", bg: "#FCD34D22" },
                { label: "Sedang Diproses", value: "19", color: "#60A5FA", bg: "#60A5FA22" },
                { label: "Selesai Hari Ini", value: "25", color: "#34D399", bg: "#34D39922" },
                { label: "Eskalasi", value: "7", color: "#F87171", bg: "#F8717122" },
              ].map((item) => (
                <div
                  key={item.label}
                  style={{
                    background: item.bg,
                    borderRadius: 10,
                    padding: "12px 14px",
                  }}
                >
                  <div style={{ fontSize: 22, fontWeight: 700, color: item.color }}>{item.value}</div>
                  <div style={{ fontSize: 11, color: "#9CA3AF", marginTop: 3 }}>{item.label}</div>
                </div>
              ))}
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}