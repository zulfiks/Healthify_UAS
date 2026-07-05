import { useState } from "react";
import { useNavigate } from "react-router-dom";
import axiosClient from "../api/axios";

export default function AdminLogin() {
  const navigate = useNavigate();
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [remember, setRemember] = useState(false);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState("");
  const [success, setSuccess] = useState(false);

  

  const handleLogin = async () => {
    setError("");
    setSuccess(false);

    if (!email) return setError("Email wajib diisi.");
    if (!email.endsWith("@healthify.com"))
      return setError("Email harus menggunakan domain @healthify.com");
    if (!password) return setError("Password wajib diisi.");

    setLoading(true);
    try {
      const res = await axiosClient.post("/admin/login", { email, password });
      const token = res.data.token;

      localStorage.setItem("token", token);

      setSuccess(true);
      navigate("/dashboard");
    } catch (err) {
      const msg = err.response?.data?.message || "Email atau password salah.";
      setError(msg);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div
      style={{
        minHeight: "100vh",
        width: "100%",
        display: "flex",
        alignItems: "center",
        justifyContent: "center",
        padding: "2rem",
        background:
          "linear-gradient(135deg, #0a2a1f 0%, #061428 40%, #0d0a2e 70%, #1a0a2e 100%)",
        position: "relative",
        overflow: "hidden",
        boxSizing: "border-box",
      }}
    >
      {/* Glow kiri atas */}
      <div
        style={{
          position: "absolute",
          top: -100,
          left: -100,
          width: 500,
          height: 500,
          borderRadius: "50%",
          background:
            "radial-gradient(circle, rgba(29,233,182,0.25) 0%, transparent 70%)",
          pointerEvents: "none",
        }}
      />
      {/* Glow kanan bawah */}
      <div
        style={{
          position: "absolute",
          bottom: -120,
          right: 40,
          width: 450,
          height: 450,
          borderRadius: "50%",
          background:
            "radial-gradient(circle, rgba(120,60,220,0.2) 0%, transparent 70%)",
          pointerEvents: "none",
        }}
      />

      {/* Card */}
      <div
        style={{
          position: "relative",
          zIndex: 1,
          display: "flex",
          width: "100%",
          maxWidth: 860,
          minHeight: "auto",
          borderRadius: 24,
          overflow: "hidden",
          border: "0.5px solid rgba(255,255,255,0.12)",
          backdropFilter: "blur(4px)",
        }}
      >
        {/* Kiri — Form */}
        <div
          style={{
            flex: 1,
            display: "flex",
            flexDirection: "column",
            justifyContent: "center",
            padding: "2rem 2.5rem",
            background: "rgba(10,18,32,0.6)",
            borderRight: "0.5px solid rgba(255,255,255,0.07)",
            boxSizing: "border-box",
          }}
        >
          {/* Brand */}
          <div style={{ display: "flex", alignItems: "center", gap: 12, marginBottom: 16 }}>
            <div
              style={{
                width: 44,
                height: 44,
                background: "#1de9b6",
                borderRadius: 12,
                display: "flex",
                alignItems: "center",
                justifyContent: "center",
                flexShrink: 0,
              }}
            >
              <svg
                width="22"
                height="22"
                viewBox="0 0 24 24"
                fill="none"
                stroke="#060d18"
                strokeWidth="2.5"
                strokeLinecap="round"
                strokeLinejoin="round"
              >
                <path d="M22 12h-4l-3 9L9 3l-3 9H2" />
              </svg>
            </div>
            <span style={{ color: "#fff", fontWeight: 600, fontSize: 21 }}>
              Healthify
            </span>
          </div>

          {/* Heading */}
          <h1 style={{ color: "#fff", fontWeight: 700, fontSize: 34, margin: "0 0 6px" }}>
            <span style={{ color: "#1de9b6" }}>Admin</span> Login
          </h1>
          <p style={{ color: "rgba(255,255,255,0.38)", fontSize: 14, margin: "0 0 14px" }}>
            Masukkan kredensial Anda untuk melanjutkan.
          </p>

          {/* Error */}
          {error && (
            <div
              style={{
                display: "flex",
                alignItems: "center",
                gap: 8,
                background: "rgba(226,75,74,0.1)",
                border: "0.5px solid rgba(226,75,74,0.35)",
                borderRadius: 10,
                padding: "10px 14px",
                fontSize: 13,
                color: "#f09595",
                marginBottom: 16,
              }}
            >
              <svg
                width="14"
                height="14"
                viewBox="0 0 24 24"
                fill="none"
                stroke="currentColor"
                strokeWidth="2"
                strokeLinecap="round"
                strokeLinejoin="round"
              >
                <circle cx="12" cy="12" r="10" />
                <line x1="12" y1="8" x2="12" y2="12" />
                <line x1="12" y1="16" x2="12.01" y2="16" />
              </svg>
              {error}
            </div>
          )}

          {/* Success */}
          {success && (
            <div
              style={{
                display: "flex",
                alignItems: "center",
                gap: 8,
                background: "rgba(29,233,182,0.08)",
                border: "0.5px solid rgba(29,233,182,0.3)",
                borderRadius: 10,
                padding: "10px 14px",
                fontSize: 13,
                color: "#1de9b6",
                marginBottom: 16,
              }}
            >
              <svg
                width="14"
                height="14"
                viewBox="0 0 24 24"
                fill="none"
                stroke="currentColor"
                strokeWidth="2"
                strokeLinecap="round"
                strokeLinejoin="round"
              >
                <polyline points="20 6 9 17 4 12" />
              </svg>
              Login berhasil! Mengalihkan...
            </div>
          )}

          {/* Email field */}
          <div style={{ marginBottom: 12 }}>
            <label
              style={{
                display: "block",
                fontSize: 13,
                fontWeight: 600,
                color: "rgba(255,255,255,0.4)",
                letterSpacing: "0.08em",
                textTransform: "uppercase",
                marginBottom: 6,
              }}
            >
              Email Address
            </label>
            <div style={{ position: "relative" }}>
              <svg
                style={{
                  position: "absolute",
                  left: 18,
                  top: "50%",
                  transform: "translateY(-50%)",
                  pointerEvents: "none",
                }}
                width="20"
                height="20"
                viewBox="0 0 24 24"
                fill="none"
                stroke="rgba(255,255,255,0.3)"
                strokeWidth="2"
                strokeLinecap="round"
                strokeLinejoin="round"
              >
                <path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z" />
                <polyline points="22,6 12,13 2,6" />
              </svg>
              <input
                type="email"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                onKeyDown={(e) => e.key === "Enter" && handleLogin()}
                placeholder="admin@healthify.com"
                style={{
                  width: "100%",
                  height: 48,
                  background: "rgba(255,255,255,0.06)",
                  border: "0.5px solid rgba(255,255,255,0.14)",
                  borderRadius: 12,
                  paddingLeft: 46,
                  paddingRight: 16,
                  fontSize: 14,
                  color: "#fff",
                  outline: "none",
                  boxSizing: "border-box",
                  transition: "border-color 0.2s, background 0.2s",
                }}
                onFocus={(e) => {
                  e.target.style.borderColor = "rgba(29,233,182,0.55)";
                  e.target.style.background = "rgba(29,233,182,0.05)";
                }}
                onBlur={(e) => {
                  e.target.style.borderColor = "rgba(255,255,255,0.14)";
                  e.target.style.background = "rgba(255,255,255,0.06)";
                }}
              />
            </div>
          </div>

          {/* Password field */}
          <div style={{ marginBottom: 12 }}>
            <label
              style={{
                display: "block",
                fontSize: 13,
                fontWeight: 600,
                color: "rgba(255,255,255,0.4)",
                letterSpacing: "0.08em",
                textTransform: "uppercase",
                marginBottom: 6,
              }}
            >
              Password
            </label>
            <div style={{ position: "relative" }}>
              <svg
                style={{
                  position: "absolute",
                  left: 18,
                  top: "50%",
                  transform: "translateY(-50%)",
                  pointerEvents: "none",
                }}
                width="20"
                height="20"
                viewBox="0 0 24 24"
                fill="none"
                stroke="rgba(255,255,255,0.3)"
                strokeWidth="2"
                strokeLinecap="round"
                strokeLinejoin="round"
              >
                <rect x="3" y="11" width="18" height="11" rx="2" ry="2" />
                <path d="M7 11V7a5 5 0 0 1 10 0v4" />
              </svg>
              <input
                type="password"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                onKeyDown={(e) => e.key === "Enter" && handleLogin()}
                placeholder="••••••••"
                style={{
                  width: "100%",
                  height: 48,
                  background: "rgba(255,255,255,0.06)",
                  border: "0.5px solid rgba(255,255,255,0.14)",
                  borderRadius: 12,
                  paddingLeft: 46,
                  paddingRight: 16,
                  fontSize: 14,
                  color: "#fff",
                  outline: "none",
                  boxSizing: "border-box",
                  transition: "border-color 0.2s, background 0.2s",
                }}
                onFocus={(e) => {
                  e.target.style.borderColor = "rgba(29,233,182,0.55)";
                  e.target.style.background = "rgba(29,233,182,0.05)";
                }}
                onBlur={(e) => {
                  e.target.style.borderColor = "rgba(255,255,255,0.14)";
                  e.target.style.background = "rgba(255,255,255,0.06)";
                }}
              />
            </div>
          </div>

          {/* Remember & Forgot */}
          <div
            style={{
              display: "flex",
              alignItems: "center",
              justifyContent: "space-between",
              marginBottom: 12,
            }}
          >
            <label
              style={{
                display: "flex",
                alignItems: "center",
                gap: 9,
                fontSize: 15,
                color: "rgba(255,255,255,0.4)",
                cursor: "pointer",
              }}
            >
              <input
                type="checkbox"
                checked={remember}
                onChange={(e) => setRemember(e.target.checked)}
                style={{ accentColor: "#1de9b6", cursor: "pointer", width: 16, height: 16 }}
              />
              Ingat saya
            </label>
            <button
              style={{
                background: "none",
                border: "none",
                padding: 0,
                cursor: "pointer",
                fontSize: 15,
                color: "rgba(29,233,182,0.75)",
              }}
            >
              Lupa password?
            </button>
          </div>

          {/* Submit */}
          <button
            onClick={handleLogin}
            disabled={loading}
            style={{
              width: "100%",
              height: 48,
              background: "#1de9b6",
              color: "#060d18",
              border: "none",
              borderRadius: 12,
              fontSize: 15,
              fontWeight: 700,
              cursor: loading ? "not-allowed" : "pointer",
              opacity: loading ? 0.7 : 1,
              transition: "opacity 0.2s",
            }}
          >
            {loading ? "Memproses..." : "Masuk"}
          </button>

          {/* Badge */}
          <div
            style={{
              marginTop: 16,
              paddingTop: 14,
              borderTop: "0.5px solid rgba(255,255,255,0.07)",
            }}
          >
            <span
              style={{
                display: "inline-flex",
                alignItems: "center",
                gap: 8,
                background: "rgba(255,255,255,0.04)",
                border: "0.5px solid rgba(255,255,255,0.09)",
                borderRadius: 20,
                padding: "7px 16px",
                fontSize: 13,
                color: "rgba(255,255,255,0.3)",
              }}
            >
              <svg
                width="12"
                height="12"
                viewBox="0 0 24 24"
                fill="none"
                stroke="rgba(29,233,182,0.65)"
                strokeWidth="2"
                strokeLinecap="round"
                strokeLinejoin="round"
              >
                <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z" />
              </svg>
              Role: admin — @healthify.com
            </span>
          </div>
        </div>

        {/* Kanan — Dekorasi */}
        <div
          style={{
            flex: 1,
            display: "flex",
            alignItems: "center",
            justifyContent: "center",
            background: "rgba(8,12,24,0.38)",
          }}
        >
          <div style={{ textAlign: "center", padding: "2rem" }}>
            <div
              style={{
                width: 100,
                height: 100,
                borderRadius: 26,
                background: "rgba(29,233,182,0.1)",
                border: "0.5px solid rgba(29,233,182,0.25)",
                display: "flex",
                alignItems: "center",
                justifyContent: "center",
                margin: "0 auto 28px",
              }}
            >
              <svg
                width="42"
                height="42"
                viewBox="0 0 24 24"
                fill="none"
                stroke="rgba(29,233,182,0.75)"
                strokeWidth="1.5"
                strokeLinecap="round"
                strokeLinejoin="round"
              >
                <rect x="3" y="3" width="7" height="7" />
                <rect x="14" y="3" width="7" height="7" />
                <rect x="3" y="14" width="7" height="7" />
                <rect x="14" y="14" width="7" height="7" />
              </svg>
            </div>
            <h2 style={{ color: "#fff", fontWeight: 700, fontSize: 28, margin: "0 0 10px" }}>
              Welcome <span style={{ color: "#1de9b6" }}>back</span>
            </h2>
            <p
              style={{
                color: "rgba(255,255,255,0.32)",
                fontSize: 16,
                maxWidth: 240,
                margin: "0 auto",
                lineHeight: 1.7,
              }}
            >
              Log in to access your admin dashboard
            </p>
          </div>
        </div>
      </div>
    </div>
  );
}