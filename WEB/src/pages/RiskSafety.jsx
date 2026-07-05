import { useEffect, useState } from "react";
import axiosClient from "../api/axios";

const defaultBadgeColor = { bg: "#E5E7EB", text: "#374151" };

const severityColor = {
  High: {
    bg: "#FEE2E2",
    text: "#DC2626",
  },
  Medium: {
    bg: "#FEF3C7",
    text: "#B45309",
  },
};

const riskColor = {
  Kritis: {
    bg: "#FEE2E2",
    text: "#DC2626",
  },
  Tinggi: {
    bg: "#FED7AA",
    text: "#EA580C",
  },
  Sedang: {
    bg: "#FEF3C7",
    text: "#B45309",
  },
};

function StatCard({
  icon,
  title,
  value,
  color,
}) {
  return (
    <div
      style={{
        background: "#1E1E2E",
        borderRadius: 14,
        padding: 20,
        flex: 1,
      }}
    >
      <div
        style={{
          width: 42,
          height: 42,
          borderRadius: 10,
          background: `${color}22`,
          display: "flex",
          alignItems: "center",
          justifyContent: "center",
          marginBottom: 12,
          fontSize: 18,
        }}
      >
        {icon}
      </div>

      <div
        style={{
          color: "#9CA3AF",
          fontSize: 13,
        }}
      >
        {title}
      </div>

      <div
        style={{
          color: "#F9FAFB",
          fontSize: 28,
          fontWeight: 700,
          marginTop: 6,
        }}
      >
        {value}
      </div>
    </div>
  );
}

function SectionCard({
  title,
  children,
}) {
  return (
    <div
      style={{
        background: "#1E1E2E",
        borderRadius: 14,
        padding: "20px 22px",
      }}
    >
      <h3
        style={{
          marginTop: 0,
          marginBottom: 18,
          color: "#F9FAFB",
        }}
      >
        {title}
      </h3>

      {children}
    </div>
  );
}

export default function RiskSafetyCenter() {
const [alerts, setAlerts] = useState([]);

useEffect(() => {
  axiosClient
    .get("/admin/risk-alerts")
    .then((res) => {
      setAlerts(res.data.data || []);
    })
    .catch(console.error);
}, []);

const activeAlerts = alerts.filter(
  (a) => a.status === "Aktif"
).length;

const highRiskCases = alerts.filter(
  (a) => a.severity === "High"
).length;

const needReview = alerts.filter(
  (a) => a.status === "Review"
).length;

  const medicalFlags = alerts;

  return (
    <div
      style={{
        background: "#13131F",
        minHeight: "100vh",
        padding: 28,
        color: "#F9FAFB",
        fontFamily: "Inter, sans-serif",
      }}
    >
      {/* Header */}
      <div style={{ marginBottom: 28 }}>
        <h1
          style={{
            margin: 0,
            fontSize: 22,
            fontWeight: 700,
          }}
        >
          Risk & Safety Center
        </h1>

        <p
          style={{
            marginTop: 5,
            color: "#6B7280",
            fontSize: 13,
          }}
        >
          Monitoring risiko obesitas dan keamanan kesehatan pengguna
        </p>
      </div>

      {/* Stat Cards */}
      <div
        style={{
          display: "flex",
          gap: 14,
          marginBottom: 20,
        }}
      >
        <StatCard
          icon="⚠️"
          title="Active Alerts"
          value={activeAlerts}
          color="#F87171"
        />

        <StatCard
          icon="🚨"
          title="High Risk Cases"
          value={highRiskCases}
          color="#EF4444"
        />

        <StatCard
          icon="🩺"
          title="Medical Flags"
          value={alerts.length}
          color="#FBBF24"
        />

        <StatCard
          icon="👨‍⚕️"
          title="Need Review"
          value={needReview}
          color="#60A5FA"
        />
      </div>

      {/* Alert Table */}
      <div
        style={{
          background: "#1E1E2E",
          borderRadius: 14,
          padding: "20px 22px",
          marginBottom: 18,
        }}
      >
        <h3 style={{ marginTop: 0 }}>
          Obesity Risk Alerts
        </h3>

        <table
          style={{
            width: "100%",
            borderCollapse: "collapse",
          }}
        >
          <thead>
            <tr>
              {[
                "ID",
                "User",
                "Alert",
                "Severity",
                "Status",
                "Action",
              ].map((item) => (
                <th
                  key={item}
                  style={tableHead}
                >
                  {item}
                </th>
              ))}
            </tr>
          </thead>

          <tbody>
            {alerts.map((alert) => (
              <tr key={alert.id}>
                <td style={tableCell}>#{alert.id}</td>
                <td style={tableCell}>{alert.user?.name || "-"}</td>
                <td style={tableCell}>{alert.title}</td>

                <td style={tableCell}>
                  <span
                    style={{
                      padding: "4px 10px",
                      borderRadius: 999,
                      background:
                        (severityColor[alert.severity] || defaultBadgeColor)
                          .bg,
                      color:
                        (severityColor[alert.severity] || defaultBadgeColor)
                          .text,
                      fontSize: 11,
                      fontWeight: 600,
                    }}
                  >
                    {alert.severity}
                  </span>
                </td>

                <td style={tableCell}>
                  {alert.status}
                </td>

                <td style={tableCell}>
                  <button style={archiveBtn}>
                    Arsipkan
                  </button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>

      {/* Bottom Grid */}
      <div
        style={{
          display: "grid",
          gridTemplateColumns:
            "1fr 1fr",
          gap: 16,
        }}
      >
        {/* Medical Flags */}
        <SectionCard title="Medical Safety Flags">
          {medicalFlags.slice(0, 5).map((item) => (
            <div
              key={item.id}
              style={{
                padding: "12px 0",
                borderBottom:
                  "1px solid #2D2D3F",
              }}
            >
              <div
                style={{
                  display: "flex",
                  justifyContent:
                    "space-between",
                  alignItems: "center",
                }}
              >
                <div>
                  <div>
                    {item.user?.name || "-"}
                  </div>

                  <div
                    style={{
                      fontSize: 12,
                      color: "#6B7280",
                    }}
                  >
                    {item.title}
                  </div>
                </div>

                <span
                  style={{
                    padding:
                      "4px 10px",
                    borderRadius: 999,
                    background:
                      (severityColor[item.severity] || defaultBadgeColor)
                        .bg,
                    color:
                      (severityColor[item.severity] || defaultBadgeColor)
                        .text,
                    fontSize: 11,
                    fontWeight: 600,
                  }}
                >
                  {item.severity}
                </span>
              </div>
            </div>
          ))}
        </SectionCard>

        {/* Admin + Expert */}
        <SectionCard title="Safety Management">
          <div
            style={{
              display: "flex",
              flexDirection:
                "column",
              gap: 12,
            }}
          >
            <button style={purpleBtn}>
              Atur Rule Alert
            </button>

            <button style={yellowBtn}>
              Review Kasus
            </button>

            <button style={greenBtn}>
              Beri Rekomendasi
            </button>
          </div>

          <div
            style={{
              marginTop: 24,
            }}
          >
            <h4
              style={{
                marginBottom: 10,
              }}
            >
              Catatan Expert
            </h4>

            <div
              style={{
                background:
                  "#13131F",
                border:
                  "1px solid #2D2D3F",
                borderRadius: 10,
                padding: 12,
                color: "#9CA3AF",
                fontSize: 13,
              }}
            >
              Pasien dengan BMI
              ekstrem perlu
              evaluasi pola
              makan dan
              aktivitas fisik
              secara berkala.
            </div>
          </div>
        </SectionCard>
      </div>
    </div>
  );
}

const tableHead = {
  textAlign: "left",
  paddingBottom: 12,
  color: "#6B7280",
  fontSize: 12,
  borderBottom: "1px solid #2D2D3F",
};

const tableCell = {
  padding: "14px 0",
  borderBottom: "1px solid #2D2D3F",
  color: "#F9FAFB",
  fontSize: 13,
};

const archiveBtn = {
  border: "none",
  background: "#F87171",
  color: "#fff",
  padding: "7px 12px",
  borderRadius: 8,
  cursor: "pointer",
};

const purpleBtn = {
  border: "none",
  background: "#7C3AED",
  color: "#fff",
  padding: "10px 14px",
  borderRadius: 10,
  cursor: "pointer",
};

const yellowBtn = {
  border: "none",
  background: "#FBBF24",
  color: "#fff",
  padding: "10px 14px",
  borderRadius: 10,
  cursor: "pointer",
};

const greenBtn = {
  border: "none",
  background: "#34D399",
  color: "#fff",
  padding: "10px 14px",
  borderRadius: 10,
  cursor: "pointer",
};