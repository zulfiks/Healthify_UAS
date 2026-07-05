import { useEffect, useState } from "react";
import axiosClient from "../api/axios";

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
          fontSize: 13,
          color: "#9CA3AF",
        }}
      >
        {title}
      </div>

      <div
        style={{
          fontSize: 28,
          fontWeight: 700,
          color: "#F9FAFB",
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

export default function AchievementsCenter() {
const [badgeData, setBadgeData] = useState([]);
const [challengeData, setChallengeData] = useState([]);
const [userBadges, setUserBadges] = useState([]);
const [stats, setStats] = useState({});
const [showBadgeModal, setShowBadgeModal] = useState(false);
const [editingBadge, setEditingBadge] = useState(null);

const [badgeForm, setBadgeForm] = useState({
    name: "",
    category: "",
    icon: "",
    description: "",
    condition_type: "",
    condition_value: 1,
});

useEffect(() => {
  axiosClient
    .get("/admin/achievements")
    .then((res) => {
      const data = res.data;
      setBadgeData(data.badges || []);
      setChallengeData(data.challenges || []);
      setUserBadges(data.userBadges || []);
      setStats(data);
    })
    .catch(console.error);
}, []);

  return (
    <div
      style={{
        background: "#13131F",
        minHeight: "100vh",
        padding: 28,
        color: "#F9FAFB",
        fontFamily:
          "'Inter', sans-serif",
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
          Achievements Center
        </h1>

        <p
          style={{
            marginTop: 5,
            color: "#6B7280",
            fontSize: 13,
          }}
        >
          Kelola gamifikasi, badge,
          challenge, dan leaderboard
          pengguna
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
          icon="🏆"
          title="Total Badge"
          value={stats.totalBadges || 0}
          color="#FBBF24"
        />

        <StatCard
          icon="🎯"
          title="Challenges"
          value={stats.totalChallenges || 0}
          color="#818CF8"
        />

        <StatCard
          icon="🔥"
          title="Active Streaks"
          value={stats.earnedBadges || 0}
          color="#F87171"
        />

        <StatCard
          icon="👥"
          title="Participants"
          value={stats.totalUsers || 0}
          color="#34D399"
        />
      </div>

      {/* Badge & Challenge */}
      <div
        style={{
          display: "grid",
          gridTemplateColumns:
            "1fr 1fr",
          gap: 16,
          marginBottom: 18,
        }}
      >
        {/* Badge Management */}
        <SectionCard title="Badge Management">
          <table
            style={{
              width: "100%",
              borderCollapse:
                "collapse",
            }}
          >
            <thead>
              <tr>
                {[
                  "Badge",
                  "Kategori",
                  "User",
                  "Aksi",
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
              {badgeData.map(
                (badge) => (
                  <tr
                    key={badge.id}
                  >
                    <td
                      style={
                        tableCell
                      }
                    >
                      {badge.name}
                    </td>

                    <td
                      style={
                        tableCell
                      }
                    >
                      {
                        badge.category
                      }
                    </td>

                    <td
                      style={
                        tableCell
                      }
                    >
                      {userBadges.filter(
                        (item) => item.badge_id === badge.id
                      ).length}
                    </td>

                    <td
                      style={
                        tableCell
                      }
                    >
                      <div
                        style={{
                          display:
                            "flex",
                          gap: 8,
                        }}
                      >
                        <button
                          style={
                            editBtn
                          }
                        >
                          Edit
                        </button>

                        <button
                          style={
                            deleteBtn
                          }
                        >
                          Hapus
                        </button>
                      </div>
                    </td>
                  </tr>
                )
              )}
            </tbody>
          </table>

<button
    style={primaryBtn}
    onClick={() => {
        setEditingBadge(null);

        setBadgeForm({
            name: "",
            category: "",
            icon: "",
            description: "",
            condition_type: "",
            condition_value: 1,
        });

        setShowBadgeModal(true);
    }}
>
    + Tambah Badge
</button>
        </SectionCard>

        {/* Challenge Management */}
        <SectionCard title="Challenge Management">
          <table
            style={{
              width: "100%",
              borderCollapse:
                "collapse",
            }}
          >
            <thead>
              <tr>
                {[
                  "Challenge",
                  "Peserta",
                  "Status",
                  "Aksi",
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
              {challengeData.map(
                (
                  challenge
                ) => (
                  <tr
                    key={
                      challenge.id
                    }
                  >
                    <td
                      style={
                        tableCell
                      }
                    >
                      {
                        challenge.name
                      }
                    </td>

                    <td
                      style={
                        tableCell
                      }
                    >
                      -
                    </td>

                    <td
                      style={
                        tableCell
                      }
                    >
                      {
                        challenge.status
                      }
                    </td>

                    <td
                      style={
                        tableCell
                      }
                    >
                      <div
                        style={{
                          display:
                            "flex",
                          gap: 8,
                        }}
                      >
<button
    style={editBtn}
    onClick={() => {

        setEditingBadge(badge);

        setBadgeForm({
            ...badge,
        });

        setShowBadgeModal(true);

    }}
>
    Edit
</button>

<button
    style={deleteBtn}
    onClick={async () => {

        if (!window.confirm("Hapus badge?")) return;

        await axiosClient.delete(
            `/admin/achievements/badges/${badge.id}`
        );

        window.location.reload();

    }}
>
    Hapus
</button>
                      </div>
                    </td>
                  </tr>
                )
              )}
            </tbody>
          </table>

          <button
            style={primaryBtn}
          >
            + Tambah Challenge
          </button>
        </SectionCard>
      </div>

      {/* Leaderboard */}
      <SectionCard title="Leaderboard">
        <table
          style={{
            width: "100%",
            borderCollapse:
              "collapse",
          }}
        >
          <thead>
            <tr>
              {[
                "Rank",
                "User",
                "Aktivitas",
                "Streak",
                "Challenge",
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
{userBadges.map((item, index) => (
  <tr key={item.id}>
    <td style={tableCell}>
      #{index + 1}
    </td>

    <td style={tableCell}>
  {item.name}
</td>

<td style={tableCell}>
  {item.total_points}
</td>

<td style={tableCell}>
  -
</td>

    <td style={tableCell}>
      Badge Earned
    </td>
  </tr>

            
              )
            )}
          </tbody>
        </table>
      </SectionCard>
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

const primaryBtn = {
  marginTop: 16,
  border: "none",
  background: "#7C3AED",
  color: "#fff",
  padding: "10px 14px",
  borderRadius: 10,
  cursor: "pointer",
};

const editBtn = {
  border: "none",
  background: "#FBBF24",
  color: "#fff",
  padding: "7px 12px",
  borderRadius: 8,
  cursor: "pointer",
};

const deleteBtn = {
  border: "none",
  background: "#F87171",
  color: "#fff",
  padding: "7px 12px",
  borderRadius: 8,
  cursor: "pointer",
};