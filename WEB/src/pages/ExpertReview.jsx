import { useEffect, useState } from "react";

const pendingReviews = [
  {
    user: "Kristianto",
    bmi: 34.8,
    currentWeight: "108 kg",
    targetWeight: "78 kg",
    aiPlan: "-1.0 kg/minggu",
    priority: "Kritis",
  },
  {
    user: "Dirgafiansyah",
    bmi: 32.4,
    currentWeight: "96 kg",
    targetWeight: "75 kg",
    aiPlan: "-0.8 kg/minggu",
    priority: "Tinggi",
  },
  {
    user: "Diandra",
    bmi: 33.5,
    currentWeight: "95 kg",
    targetWeight: "72 kg",
    aiPlan: "-0.8 kg/minggu",
    priority: "Tinggi",
  },
  {
    user: "Velisha",
    bmi: 32.0,
    currentWeight: "84 kg",
    targetWeight: "70 kg",
    aiPlan: "-0.6 kg/minggu",
    priority: "Sedang",
  },
  {
    user: "Rahmanovita",
    bmi: 32.0,
    currentWeight: "82 kg",
    targetWeight: "68 kg",
    aiPlan: "-0.6 kg/minggu",
    priority: "Sedang",
  },
  {
    user: "Bilqis Kirana",
    bmi: 31.2,
    currentWeight: "78 kg",
    targetWeight: "68 kg",
    aiPlan: "-0.5 kg/minggu",
    priority: "Sedang",
  },
]

const priorityColor = {
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
          fontSize: 15,
        }}
      >
        {title}
      </h3>

      {children}
    </div>
  );
}

export default function ExpertReviewCenter() {
  const [reviews] = useState(
    pendingReviews
  );

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
          Expert Review Center
        </h1>

        <p
          style={{
            marginTop: 5,
            color: "#6B7280",
            fontSize: 13,
          }}
        >
          Review rekomendasi AI dan
          berikan intervensi profesional
          untuk pengguna berisiko
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
          icon="📋"
          title="Pending Reviews"
          value="6"
          color="#818CF8"
        />

        <StatCard
          icon="👨‍⚕️"
          title="Reviewed Today"
          value="3"
          color="#34D399"
        />

        <StatCard
          icon="✏️"
          title="Revised Plans"
          value="2"
          color="#FBBF24"
        />

        <StatCard
          icon="🚨"
          title="Critical Cases"
          value="1"
          color="#F87171"
        />
      </div>

      {/* Pending Review Table */}
      <div
        style={{
          background: "#1E1E2E",
          borderRadius: 14,
          padding: "20px 22px",
          marginBottom: 18,
        }}
      >
        <h3
          style={{
            marginTop: 0,
            marginBottom: 18,
          }}
        >
          Pending Reviews
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
                "User",
                "BMI",
                "BB Saat Ini",
                "Target BB",
                "AI Plan",
                "Priority",
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
            {reviews.map((item) => (
              <tr key={item.id}>
                <td style={tableCell}>
                  {item.user}
                </td>

                <td style={tableCell}>
                  {item.bmi}
                </td>

                <td style={tableCell}>
                  {item.currentWeight}
                </td>

                <td style={tableCell}>
                  {item.targetWeight}
                </td>

                <td style={tableCell}>
                  {item.aiPlan}
                </td>

                <td style={tableCell}>
                  <span
                    style={{
                      padding:
                        "4px 10px",
                      borderRadius: 999,
                      background:
                        priorityColor[
                          item.priority
                        ].bg,
                      color:
                        priorityColor[
                          item.priority
                        ].text,
                      fontSize: 11,
                      fontWeight: 600,
                    }}
                  >
                    {item.priority}
                  </span>
                </td>

                <td style={tableCell}>
                  <button
                    style={reviewBtn}
                  >
                    Review
                  </button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>

      {/* Bottom */}
      <div
        style={{
          display: "grid",
          gridTemplateColumns:
            "1fr 1fr",
          gap: 16,
        }}
      >
        {/* Expert Notes */}
        <SectionCard title="Expert Notes">
          <textarea
            placeholder="Masukkan catatan profesional..."
            style={{
              width: "100%",
              height: 180,
              background:
                "#13131F",
              border:
                "1px solid #2D2D3F",
              borderRadius: 10,
              padding: 14,
              color: "#F9FAFB",
              resize: "none",
              outline: "none",
            }}
          />

          <button
            style={{
              marginTop: 16,
              border: "none",
              background:
                "#34D399",
              color: "#fff",
              padding:
                "10px 14px",
              borderRadius: 10,
              cursor: "pointer",
            }}
          >
            Simpan Catatan
          </button>
        </SectionCard>

        {/* AI Recommendation Review */}
        <SectionCard title="AI Recommendation Review">
          <div
            style={{
              background:
                "#13131F",
              border:
                "1px solid #2D2D3F",
              borderRadius: 10,
              padding: 14,
              marginBottom: 16,
            }}
          >
            <div
              style={{
                color: "#9CA3AF",
                fontSize: 12,
                marginBottom: 6,
              }}
            >
              AI Recommendation
            </div>

            <div
              style={{
                color: "#F9FAFB",
              }}
            >
              Target penurunan berat badan disesuaikan dengan tingkat risiko obesitas pengguna. Fokus pada pengurangan konsumsi fast food, peningkatan aktivitas fisik minimal 150 menit per minggu, serta monitoring food logging harian selama 4 minggu berturut-turut.
            </div>
          </div>

          <div
            style={{
              display: "flex",
              flexDirection:
                "column",
              gap: 10,
            }}
          >
            <button
              style={approveBtn}
            >
              Approve
            </button>

            <button
              style={reviseBtn}
            >
              Revise Target
            </button>

            <button
              style={rejectBtn}
            >
              Reject
            </button>
          </div>

          <div
            style={{
              marginTop: 20,
            }}
          >
            <label
              style={{
                display: "block",
                fontSize: 12,
                color: "#9CA3AF",
                marginBottom: 8,
              }}
            >
              Ubah Target User
            </label>

            <input
              type="text"
              placeholder="-0.8 kg/minggu"
              style={{
                width: "100%",
                background:
                  "#13131F",
                border:
                  "1px solid #2D2D3F",
                borderRadius: 10,
                padding: 12,
                color: "#fff",
                outline: "none",
              }}
            />
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

const reviewBtn = {
  border: "none",
  background: "#7C3AED",
  color: "#fff",
  padding: "7px 12px",
  borderRadius: 8,
  cursor: "pointer",
};

const approveBtn = {
  border: "none",
  background: "#34D399",
  color: "#fff",
  padding: "10px 14px",
  borderRadius: 10,
  cursor: "pointer",
};

const reviseBtn = {
  border: "none",
  background: "#FBBF24",
  color: "#fff",
  padding: "10px 14px",
  borderRadius: 10,
  cursor: "pointer",
};

const rejectBtn = {
  border: "none",
  background: "#F87171",
  color: "#fff",
  padding: "10px 14px",
  borderRadius: 10,
  cursor: "pointer",
};