import { useEffect, useState } from "react";
import axiosClient from "../api/axios";

const riskColor = {
  Normal: {
    bg: "#D1FAE5",
    text: "#059669",
  },
  Sedang: {
    bg: "#FEF3C7",
    text: "#B45309",
  },
  Tinggi: {
    bg: "#FED7AA",
    text: "#EA580C",
  },
  Kritis: {
    bg: "#FEE2E2",
    text: "#DC2626",
  },
};

const getRiskColor = (riskLevel) => {
  switch (riskLevel) {
    case "High":
      return riskColor.Tinggi;

    case "Medium":
      return riskColor.Sedang;

    case "Low":
      return riskColor.Normal;

    default:
      return {
        bg: "#E5E7EB",
        text: "#6B7280",
      };
  }
};

const getInitials = (name) => {
  if (!name) return "?";
  const parts = name.trim().split(" ");
  const initials = parts[0][0] + (parts.length > 1 ? parts[parts.length - 1][0] : "");
  return initials.toUpperCase();
};

const formatGender = (gender) => {
  if (!gender) return "-";
  const value = gender.toLowerCase();
  if (value === "male" || value === "l" || value === "laki-laki") return "Laki-laki";
  if (value === "female" || value === "p" || value === "perempuan") return "Perempuan";
  return gender;
};

export default function UserMonitoring() {

  const [search, setSearch] =
    useState("");

  const [users, setUsers] =
    useState([]);

  const [selectedUser, setSelectedUser] = useState(null);

  useEffect(() => {

    axiosClient
      .get("/admin/users")
      .then((res) => {
        setUsers(res.data.data || res.data || []);
      })
      .catch(console.error);

  }, []);

    const filteredUsers = users.filter((user) =>
    user.name
      ?.toLowerCase()
      .includes(search.toLowerCase())
  );

  return (
    <div
      style={{
        background: "#13131F",
        minHeight: "100vh",
        padding: "28px",
        color: "#F9FAFB",
        fontFamily: "'Inter', sans-serif",
      }}
    >
      {/* Header */}
      <div
        style={{
          marginBottom: 28,
        }}
      >
        <h1
          style={{
            fontSize: 22,
            fontWeight: 700,
            margin: 0,
          }}
        >
          User Monitoring
        </h1>

        <p
          style={{
            fontSize: 13,
            color: "#6B7280",
            marginTop: 6,
          }}
        >
          Pantau kondisi kesehatan dan aktivitas seluruh pengguna
        </p>
      </div>

      {/* Stat Cards */}
      <div
        style={{
          display: "grid",
          gridTemplateColumns: "repeat(4,1fr)",
          gap: 16,
          marginBottom: 22,
        }}
      >
        <StatCard
          title="Total User"
          value={users.length}
          color="#818CF8"
        />

        <StatCard
          title="Risiko Tinggi"
          value={users.filter((user) => user.risk_level === "High").length}
          color="#F87171"
        />

        <StatCard
          title="User Aktif"
          value={users.length}
          color="#34D399"
        />

      </div>

      {/* Filter */}
      <div
        style={{
          background: "#1E1E2E",
          borderRadius: 14,
          padding: 20,
          marginBottom: 18,
        }}
      >
        <input
          placeholder="Cari pengguna..."
          value={search}
          onChange={(e) => setSearch(e.target.value)}
          style={{
            width: "100%",
            background: "#13131F",
            border: "1px solid #2D2D3F",
            color: "#fff",
            padding: "12px 14px",
            borderRadius: 10,
            outline: "none",
          }}
        />
      </div>

      {/* Table */}
      <div
        style={{
          background: "#1E1E2E",
          borderRadius: 14,
          padding: "20px 22px",
        }}
      >
        <div
          style={{
            fontSize: 15,
            fontWeight: 600,
            marginBottom: 18,
          }}
        >
          Daftar Pengguna
        </div>

        <table
          style={{
            width: "100%",
            borderCollapse: "collapse",
          }}
        >
          <thead>
            <tr>
              {[
                "Nama",
                "Tanggal Pembuatan",
                "BMI",
                "BB Terakhir",
                "Target BB",
                "Risiko",
                "Status",
                "Aksi",
              ].map((head) => (
                <th
                  key={head}
                  style={{
                    textAlign: "left",
                    paddingBottom: 14,
                    borderBottom: "1px solid #2D2D3F",
                    color: "#6B7280",
                    fontSize: 12,
                    fontWeight: 500,
                  }}
                >
                  {head}
                </th>
              ))}
            </tr>
          </thead>

<tbody>
  {filteredUsers.map((user) => (
    <tr key={user.id}>
      {/* Nama */}
      <td
        style={{
          padding: "16px 0",
          borderBottom: "1px solid #2D2D3F",
        }}
      >
        {user.name}
      </td>

      {/* Tanggal Join */}
      <td
        style={{
          borderBottom: "1px solid #2D2D3F",
        }}
      >
        {user.created_at
          ? new Date(user.created_at).toLocaleString("id-ID")
          : "-"}
      </td>

      {/* BMI */}
      <td
        style={{
          borderBottom: "1px solid #2D2D3F",
        }}
      >
        {user.imt_value ?? "-"}
      </td>

      {/* Berat Badan */}
      <td
        style={{
          borderBottom: "1px solid #2D2D3F",
        }}
      >
        {user.weight ? `${user.weight} kg` : "-"}
      </td>

      {/* Target BB */}
      <td
        style={{
          borderBottom: "1px solid #2D2D3F",
        }}
      >
        {user.target_weight
          ? `${user.target_weight} kg`
          : "-"}
      </td>

      {/* Risiko */}
      <td
        style={{
          borderBottom: "1px solid #2D2D3F",
        }}
      >
        <span
          style={{
            background: getRiskColor(
              user.risk_level
            ).bg,
            color: getRiskColor(
              user.risk_level
            ).text,
            padding: "4px 10px",
            borderRadius: 999,
            fontSize: 11,
            fontWeight: 600,
          }}
        >
          {user.risk_level ||
            "Belum Screening"}
        </span>
      </td>

      {/* Status */}
      <td
        style={{
          borderBottom: "1px solid #2D2D3F",
        }}
      >
        <span
          style={{
            color: "#34D399",
            fontWeight: 600,
          }}
        >
          Aktif
        </span>
      </td>

      {/* Aksi */}
      <td
        style={{
          borderBottom: "1px solid #2D2D3F",
        }}
      >
        <div
          style={{
            display: "flex",
            gap: 8,
          }}
        >
          <button
            style={buttonStyle("#818CF8")}
            onClick={() => {
              console.log("Detail user clicked:", user);
              setSelectedUser(user);
            }}
          >
            Detail
          </button>
          
        </div>
      </td>
    </tr>
  ))}
</tbody>
        </table>
      </div>

      {selectedUser && (
        <UserDetailModal
          user={selectedUser}
          onClose={() => setSelectedUser(null)}
        />
      )}
    </div>
  );
}

function StatCard({ title, value, color }) {
  return (
    <div
      style={{
        background: "#1E1E2E",
        borderRadius: 14,
        padding: 20,
      }}
    >
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
          marginTop: 8,
          fontSize: 28,
          fontWeight: 700,
          color,
        }}
      >
        {value}
      </div>
    </div>
  );
}

function buttonStyle(color) {
  return {
    border: "none",
    background: color,
    color: "#fff",
    padding: "7px 12px",
    borderRadius: 8,
    cursor: "pointer",
    fontSize: 12,
    fontWeight: 600,
  };
}

function UserDetailModal({ user, onClose }) {
  const risk = getRiskColor(user.risk_level);
  const isHighRisk = user.risk_level === "High";

  return (
    <div
      onClick={onClose}
      style={{
        position: "fixed",
        inset: 0,
        background: "rgba(0,0,0,0.6)",
        display: "flex",
        alignItems: "center",
        justifyContent: "center",
        padding: 20,
        zIndex: 50,
      }}
    >
      <div
        onClick={(e) => e.stopPropagation()}
        style={{
          background: "#1E1E2E",
          borderRadius: 18,
          padding: 24,
          width: "100%",
          maxWidth: 380,
          color: "#F9FAFB",
          fontFamily: "'Inter', sans-serif",
        }}
      >
        {/* Header */}
        <div
          style={{
            display: "flex",
            justifyContent: "space-between",
            alignItems: "flex-start",
            marginBottom: 20,
          }}
        >
          <div style={{ display: "flex", gap: 12, alignItems: "center" }}>
            <div
              style={{
                width: 48,
                height: 48,
                borderRadius: "50%",
                background: "#818CF8",
                display: "flex",
                alignItems: "center",
                justifyContent: "center",
                fontSize: 17,
                fontWeight: 700,
                color: "#13131F",
                flexShrink: 0,
              }}
            >
              {getInitials(user.name)}
            </div>
            <div>
              <div style={{ fontSize: 16, fontWeight: 700 }}>{user.name}</div>
              <div style={{ fontSize: 12, color: "#6B7280", marginTop: 2 }}>
                {user.email}
              </div>
            </div>
          </div>

          <button
            onClick={onClose}
            style={{
              border: "none",
              background: "#2D2D3F",
              color: "#9CA3AF",
              width: 28,
              height: 28,
              borderRadius: 8,
              cursor: "pointer",
              fontSize: 14,
              lineHeight: "28px",
              padding: 0,
            }}
          >
            ✕
          </button>
        </div>

        {/* Status badges */}
        <div style={{ display: "flex", gap: 8, marginBottom: 20 }}>
          <span
            style={{
              background: "#34D39922",
              color: "#34D399",
              fontSize: 11,
              fontWeight: 600,
              padding: "5px 12px",
              borderRadius: 999,
            }}
          >
            ● Aktif
          </span>
          {isHighRisk && (
            <span
              style={{
                background: risk.bg,
                color: risk.text,
                fontSize: 11,
                fontWeight: 600,
                padding: "5px 12px",
                borderRadius: 999,
              }}
            >
              ⚠ Risiko Tinggi
            </span>
          )}
        </div>

        {/* Profil */}
        <div
          style={{
            fontSize: 11,
            fontWeight: 600,
            color: "#6B7280",
            textTransform: "uppercase",
            letterSpacing: 0.5,
            marginBottom: 10,
          }}
        >
          Profil
        </div>
        <div
          style={{
            background: "#13131F",
            borderRadius: 12,
            padding: "4px 16px",
            marginBottom: 20,
          }}
        >
          <InfoRow
            label="Tanggal Join"
            value={
              user.created_at
                ? new Date(user.created_at).toLocaleDateString("id-ID", {
                    day: "numeric",
                    month: "long",
                    year: "numeric",
                  })
                : "-"
            }
          />
          <InfoRow label="Umur" value={user.age ? `${user.age} tahun` : "-"} />
          <InfoRow label="Gender" value={formatGender(user.gender)} last />
        </div>

        {/* Kesehatan */}
        <div
          style={{
            fontSize: 11,
            fontWeight: 600,
            color: "#6B7280",
            textTransform: "uppercase",
            letterSpacing: 0.5,
            marginBottom: 10,
          }}
        >
          Kesehatan
        </div>
        <div
          style={{
            display: "grid",
            gridTemplateColumns: "1fr 1fr",
            gap: 10,
          }}
        >
          <StatTile label="BMI Terakhir" value={user.imt_value ?? "-"} />
          <StatTile label="Kategori BMI" value={user.bmi_category ?? "-"} />
          <StatTile
            label="Risk Level"
            value={user.risk_level || "Belum Screening"}
            valueColor={risk.text}
          />
          <StatTile
            label="Target BB"
            value={user.target_weight ? `${user.target_weight} kg` : "-"}
          />
        </div>
      </div>
    </div>
  );
}

function InfoRow({ label, value, last }) {
  return (
    <div
      style={{
        display: "flex",
        justifyContent: "space-between",
        alignItems: "center",
        padding: "12px 0",
        borderBottom: last ? "none" : "1px solid #2D2D3F",
      }}
    >
      <span style={{ fontSize: 13, color: "#9CA3AF" }}>{label}</span>
      <span style={{ fontSize: 13, fontWeight: 600 }}>{value}</span>
    </div>
  );
}

function StatTile({ label, value, valueColor }) {
  return (
    <div
      style={{
        background: "#13131F",
        borderRadius: 12,
        padding: "12px 14px",
      }}
    >
      <div style={{ fontSize: 11, color: "#6B7280", marginBottom: 4 }}>
        {label}
      </div>
      <div
        style={{
          fontSize: 15,
          fontWeight: 700,
          color: valueColor || "#F9FAFB",
        }}
      >
        {value}
      </div>
    </div>
  );
}