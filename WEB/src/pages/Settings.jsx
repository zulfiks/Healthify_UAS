import { useState } from "react";
import axiosClient from "../api/axios";

function SectionCard({ title, children }) {
  return (
    <div style={{ background: "#1E1E2E", borderRadius: 14, padding: "20px 22px" }}>
      <h3 style={{ marginTop: 0, marginBottom: 18, color: "#F9FAFB" }}>{title}</h3>
      {children}
    </div>
  );
}

const inputStyle = {
  width: "100%",
  background: "#13131F",
  border: "1px solid #2D2D3F",
  borderRadius: 10,
  padding: "12px 14px",
  color: "#fff",
  outline: "none",
  boxSizing: "border-box",
  marginBottom: 14,
};

const labelStyle = {
  display: "block",
  fontSize: 12,
  color: "#9CA3AF",
  marginBottom: 6,
};

const saveBtn = {
  border: "none",
  background: "#2CF2B4",
  color: "#000",
  padding: "11px 18px",
  borderRadius: 10,
  cursor: "pointer",
  fontWeight: 700,
  fontSize: 13,
};

export default function Settings() {
  const [currentPassword, setCurrentPassword] = useState("");
  const [newPassword, setNewPassword] = useState("");
  const [confirmPassword, setConfirmPassword] = useState("");
  const [saving, setSaving] = useState(false);
  const [message, setMessage] = useState(null); // { type: 'success' | 'error', text }

  const handleChangePassword = async () => {
    setMessage(null);

    if (!currentPassword || !newPassword || !confirmPassword) {
      setMessage({ type: "error", text: "Semua field wajib diisi." });
      return;
    }
    if (newPassword !== confirmPassword) {
      setMessage({ type: "error", text: "Konfirmasi password tidak cocok." });
      return;
    }

    setSaving(true);
    try {
      await axiosClient.put("/admin/settings/password", {
        current_password: currentPassword,
        new_password: newPassword,
        new_password_confirmation: confirmPassword,
      });
      setMessage({ type: "success", text: "Password berhasil diubah." });
      setCurrentPassword("");
      setNewPassword("");
      setConfirmPassword("");
    } catch (err) {
      const msg = err.response?.data?.message || "Gagal mengubah password.";
      setMessage({ type: "error", text: msg });
    } finally {
      setSaving(false);
    }
  };

  return (
    <div
      style={{
        background: "#13131F",
        minHeight: "100vh",
        padding: 28,
        color: "#F9FAFB",
        fontFamily: "'Inter', sans-serif",
      }}
    >
      <div style={{ marginBottom: 28 }}>
        <h1 style={{ margin: 0, fontSize: 22, fontWeight: 700 }}>Settings</h1>
        <p style={{ marginTop: 5, color: "#6B7280", fontSize: 13 }}>
          Kelola pengaturan akun admin
        </p>
      </div>

      <div style={{ maxWidth: 480 }}>
        <SectionCard title="Ganti Password">
          {message && (
            <div
              style={{
                background: message.type === "success" ? "#0d2e2822" : "#7F1D1D33",
                border: `1px solid ${message.type === "success" ? "#1a4a3f" : "#DC2626"}`,
                color: message.type === "success" ? "#34D399" : "#FCA5A5",
                padding: "10px 14px",
                borderRadius: 10,
                marginBottom: 16,
                fontSize: 13,
              }}
            >
              {message.text}
            </div>
          )}

          <label style={labelStyle}>Password Saat Ini</label>
          <input
            type="password"
            value={currentPassword}
            onChange={(e) => setCurrentPassword(e.target.value)}
            style={inputStyle}
          />

          <label style={labelStyle}>Password Baru</label>
          <input
            type="password"
            value={newPassword}
            onChange={(e) => setNewPassword(e.target.value)}
            style={inputStyle}
          />

          <label style={labelStyle}>Konfirmasi Password Baru</label>
          <input
            type="password"
            value={confirmPassword}
            onChange={(e) => setConfirmPassword(e.target.value)}
            style={inputStyle}
          />

          <button onClick={handleChangePassword} disabled={saving} style={saveBtn}>
            {saving ? "Menyimpan..." : "Simpan Password"}
          </button>
        </SectionCard>
      </div>
    </div>
  );
}