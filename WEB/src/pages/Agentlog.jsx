import { useEffect, useState } from "react";
import axiosClient from "../api/axios";

const statusColor = {
  success: { bg: "#D1FAE5", text: "#059669" },
  error: { bg: "#FEE2E2", text: "#DC2626" },
  pending: { bg: "#FEF3C7", text: "#B45309" },
};

const agentColor = {
  "Food Logging Agent": "#818CF8",
  "Calorie Agent": "#34D399",
  "Coaching Agent": "#FBBF24",
  "Reminder Agent": "#60A5FA",
  "Safety Agent": "#F87171",
  "Report Agent": "#A78BFA",
  "Expert Handoff Agent": "#F472B6",
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

export default function AgentLog() {
  const [logs, setLogs] = useState([]);
  const [loading, setLoading] = useState(true);
  const [search, setSearch] = useState("");
  const [agentFilter, setAgentFilter] = useState("Semua");

  useEffect(() => {
    axiosClient.get("/admin/agent-logs")
      .then((res) => setLogs(res.data.data || res.data || []))
      .catch(console.error)
      .finally(() => setLoading(false));
  }, []);

  const agents = ["Semua", ...new Set(logs.map((l) => l.agent_name).filter(Boolean))];

  const filtered = logs.filter((log) => {
    const matchSearch =
      log.intent?.toLowerCase().includes(search.toLowerCase()) ||
      log.user?.name?.toLowerCase().includes(search.toLowerCase());
    const matchAgent = agentFilter === "Semua" || log.agent_name === agentFilter;
    return matchSearch && matchAgent;
  });

  const errorCount = logs.filter((l) => l.status === "error").length;
  const successCount = logs.filter((l) => l.status === "success").length;

  return (
    <div style={{
      background: "#13131F", minHeight: "100vh",
      padding: 28, color: "#F9FAFB", fontFamily: "Inter, sans-serif",
    }}>
      <div style={{ marginBottom: 28 }}>
        <h1 style={{ margin: 0, fontSize: 22, fontWeight: 700 }}>Agent Activity Log</h1>
        <p style={{ marginTop: 5, color: "#6B7280", fontSize: 13 }}>
          Audit log workflow GoClaw multi-agent (intent, action, status)
        </p>
      </div>

      <div style={{ display: "flex", gap: 14, marginBottom: 20 }}>
        <StatCard icon="🧾" title="Total Log" value={logs.length} color="#818CF8" />
        <StatCard icon="✅" title="Success" value={successCount} color="#34D399" />
        <StatCard icon="⚠️" title="Error" value={errorCount} color="#F87171" />
        <StatCard icon="🤖" title="Agent Aktif" value={agents.length - 1} color="#FBBF24" />
      </div>

      <div style={{ background: "#1E1E2E", borderRadius: 14, padding: "20px 22px" }}>
        <div style={{ display: "flex", gap: 12, marginBottom: 18, flexWrap: "wrap" }}>
          <input
            placeholder="Cari intent atau user..."
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            style={{
              flex: 1, minWidth: 200, background: "#13131F", border: "1px solid #2D2D3F",
              borderRadius: 10, padding: "11px 14px", color: "#fff", outline: "none", fontSize: 13,
            }}
          />
          <select
            value={agentFilter}
            onChange={(e) => setAgentFilter(e.target.value)}
            style={{
              background: "#13131F", border: "1px solid #2D2D3F", borderRadius: 10,
              padding: "11px 14px", color: "#fff", outline: "none", fontSize: 13,
            }}
          >
            {agents.map((a) => (
              <option key={a} value={a}>{a}</option>
            ))}
          </select>
        </div>

        <table style={{ width: "100%", borderCollapse: "collapse" }}>
          <thead>
            <tr>
              {["Waktu", "User", "Agent", "Intent", "Action", "Status"].map((h) => (
                <th key={h} style={tableHead}>{h}</th>
              ))}
            </tr>
          </thead>
          <tbody>
            {loading ? (
              <tr><td colSpan={6} style={{ ...tableCell, textAlign: "center", color: "#6B7280", padding: "32px 0" }}>Memuat log...</td></tr>
            ) : filtered.length === 0 ? (
              <tr><td colSpan={6} style={{ ...tableCell, textAlign: "center", color: "#6B7280", padding: "32px 0" }}>Belum ada log aktivitas.</td></tr>
            ) : (
              filtered.map((log) => {
                const badge = statusColor[log.status] || statusColor.pending;
                return (
                  <tr key={log.id}>
                    <td style={{ ...tableCell, fontSize: 12, color: "#9CA3AF" }}>
                      {log.created_at ? new Date(log.created_at).toLocaleString("id-ID") : "-"}
                    </td>
                    <td style={tableCell}>{log.user?.name || "-"}</td>
                    <td style={tableCell}>
                      <span style={{
                        color: agentColor[log.agent_name] || "#9CA3AF",
                        fontSize: 12, fontWeight: 600,
                      }}>
                        {log.agent_name || "-"}
                      </span>
                    </td>
                    <td style={{ ...tableCell, maxWidth: 200, fontSize: 12, color: "#9CA3AF" }}>
                      {log.intent || "-"}
                    </td>
                    <td style={{ ...tableCell, maxWidth: 200, fontSize: 12, color: "#9CA3AF" }}>
                      {log.action || "-"}
                    </td>
                    <td style={tableCell}>
                      <span style={{
                        padding: "4px 10px", borderRadius: 999, background: badge.bg,
                        color: badge.text, fontSize: 11, fontWeight: 600,
                      }}>
                        {log.status || "pending"}
                      </span>
                    </td>
                  </tr>
                );
              })
            )}
          </tbody>
        </table>
      </div>
    </div>
  );
}

const tableHead = {
  textAlign: "left", paddingBottom: 12,
  color: "#6B7280", fontSize: 12, borderBottom: "1px solid #2D2D3F",
};
const tableCell = {
  padding: "14px 8px 14px 0", borderBottom: "1px solid #2D2D3F",
  color: "#F9FAFB", fontSize: 13, verticalAlign: "top",
};