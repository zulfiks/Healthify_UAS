import { useEffect, useState } from "react";
import axiosClient from "../api/axios";

// ─── Reusable Components ──────────────────────────────────────────────────────

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
      <div style={{ fontSize: 13, color: "#9CA3AF" }}>{title}</div>
      <div style={{ fontSize: 28, fontWeight: 700, color: "#F9FAFB", marginTop: 6 }}>{value}</div>
    </div>
  );
}

function SectionCard({ title, children }) {
  return (
    <div style={{ background: "#1E1E2E", borderRadius: 14, padding: "20px 22px" }}>
      <h3 style={{ marginTop: 0, marginBottom: 18, color: "#F9FAFB" }}>{title}</h3>
      {children}
    </div>
  );
}

function Badge({ label, color }) {
  const colors = {
    Low:    { bg: "#D1FAE522", text: "#34D399" },
    Medium: { bg: "#FEF3C722", text: "#FBBF24" },
    High:   { bg: "#FEE2E222", text: "#F87171" },
    All:    { bg: "#EDE9FE22", text: "#A78BFA" },
  };
  const c = colors[label] || colors.All;
  return (
    <span style={{
      background: c.bg, color: c.text,
      padding: "3px 10px", borderRadius: 20,
      fontSize: 11, fontWeight: 600,
    }}>{label || "All"}</span>
  );
}

// ─── Modal ────────────────────────────────────────────────────────────────────

const EMPTY_FORM = { title: "", content: "", category: "", risk_level: "All", is_active: true };

function TemplateModal({ mode, initial, onClose, onSave }) {
  const [form, setForm] = useState(initial || EMPTY_FORM);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState("");

  const set = (k, v) => setForm(f => ({ ...f, [k]: v }));

  const handleSubmit = async () => {
    if (!form.title.trim() || !form.content.trim() || !form.category.trim()) {
      setError("Judul, Konten, dan Kategori wajib diisi.");
      return;
    }
    setLoading(true);
    setError("");
    try {
      const url = mode === "edit"
        ? `/admin/coaching/templates/${initial.id}`
        : `/admin/coaching/templates`;
      const res = mode === "edit"
        ? await axiosClient.put(url, form)
        : await axiosClient.post(url, form);
      const data = res.data;
      if (!data.success) throw new Error(data.message || "Gagal menyimpan.");
      onSave(data.template);
    } catch (e) {
      setError(e.message);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div style={overlayStyle} onClick={onClose}>
      <div style={modalStyle} onClick={e => e.stopPropagation()}>
        <h2 style={{ margin: "0 0 20px", color: "#F9FAFB", fontSize: 17 }}>
          {mode === "edit" ? "Edit Template" : "Tambah Template"}
        </h2>

        {error && (
          <div style={{ background: "#F8717133", color: "#F87171", padding: "10px 14px", borderRadius: 8, marginBottom: 14, fontSize: 13 }}>
            {error}
          </div>
        )}

        {[
          { label: "Judul", key: "title", type: "text", placeholder: "Contoh: Motivasi Pagi" },
          { label: "Kategori", key: "category", type: "text", placeholder: "motivation / craving / meal / activity / mindful" },
        ].map(({ label, key, placeholder }) => (
          <div key={key} style={{ marginBottom: 14 }}>
            <label style={labelStyle}>{label}</label>
            <input
              value={form[key]}
              onChange={e => set(key, e.target.value)}
              placeholder={placeholder}
              style={inputStyle}
            />
          </div>
        ))}

        <div style={{ marginBottom: 14 }}>
          <label style={labelStyle}>Konten</label>
          <textarea
            value={form.content}
            onChange={e => set("content", e.target.value)}
            placeholder="Tulis pesan coaching di sini..."
            rows={4}
            style={{ ...inputStyle, resize: "vertical" }}
          />
        </div>

        <div style={{ display: "flex", gap: 14, marginBottom: 18 }}>
          <div style={{ flex: 1 }}>
            <label style={labelStyle}>Risk Level</label>
            <select value={form.risk_level} onChange={e => set("risk_level", e.target.value)} style={inputStyle}>
              {["All", "Low", "Medium", "High"].map(v => <option key={v} value={v}>{v}</option>)}
            </select>
          </div>
          <div style={{ flex: 1 }}>
            <label style={labelStyle}>Status</label>
            <select value={form.is_active ? "1" : "0"} onChange={e => set("is_active", e.target.value === "1")} style={inputStyle}>
              <option value="1">Aktif</option>
              <option value="0">Nonaktif</option>
            </select>
          </div>
        </div>

        <div style={{ display: "flex", gap: 10, justifyContent: "flex-end" }}>
          <button onClick={onClose} style={cancelBtn}>Batal</button>
          <button onClick={handleSubmit} disabled={loading} style={primaryBtn}>
            {loading ? "Menyimpan..." : "Simpan"}
          </button>
        </div>
      </div>
    </div>
  );
}

// ─── Main Page ────────────────────────────────────────────────────────────────

export default function CoachingReminderCenter() {
  const [templates, setTemplates] = useState([]);
  const [histories, setHistories] = useState([]);
  const [stats, setStats] = useState({});
  const [loading, setLoading] = useState(true);

  // Modal state
  const [modal, setModal] = useState(null); // null | { mode: 'add'|'edit', data?: template }
  const [deleteTarget, setDeleteTarget] = useState(null);
  const [deleteLoading, setDeleteLoading] = useState(false);

  const fetchData = () => {
    setLoading(true);
    axiosClient.get("/admin/coaching")
      .then(res => {
        const data = res.data;
        setTemplates(data.templates || []);
        setHistories(data.histories || []);
        setStats(data);
      })
      .catch(console.error)
      .finally(() => setLoading(false));
  };

  useEffect(() => { fetchData(); }, []);

  // ── CRUD handlers ──
  const handleSave = (saved) => {
    setTemplates(prev => {
      const exists = prev.find(t => t.id === saved.id);
      return exists
        ? prev.map(t => t.id === saved.id ? saved : t)
        : [saved, ...prev];
    });
    setModal(null);
  };

  const handleDelete = async () => {
    if (!deleteTarget) return;
    setDeleteLoading(true);
    try {
      const res = await axiosClient.delete(`/admin/coaching/templates/${deleteTarget.id}`);
      const data = res.data;
      if (data.success) {
        setTemplates(prev => prev.filter(t => t.id !== deleteTarget.id));
        setDeleteTarget(null);
      }
    } catch (e) {
      console.error(e);
    } finally {
      setDeleteLoading(false);
    }
  };

  // ── Render ──
  return (
    <div style={{ background: "#13131F", minHeight: "100vh", padding: 28, color: "#F9FAFB", fontFamily: "'Inter', sans-serif" }}>

      {/* Header */}
      <div style={{ marginBottom: 28 }}>
        <h1 style={{ margin: 0, fontSize: 22, fontWeight: 700 }}>Coaching & Reminder Center</h1>
        <p style={{ marginTop: 5, color: "#6B7280", fontSize: 13 }}>
          Kelola template coaching, reminder otomatis, dan pantau aktivitas AI chat
        </p>
      </div>

      {/* Stat Cards */}
      <div style={{ display: "flex", gap: 14, marginBottom: 20 }}>
        <StatCard icon="💬" title="Total Messages"   value={stats.totalMessages  || 0} color="#818CF8" />
        <StatCard icon="🤖" title="AI Interactions"  value={stats.totalUsers     || 0} color="#34D399" />
        <StatCard icon="📚" title="Total Templates"  value={stats.totalTemplates || 0} color="#60A5FA" />
        <StatCard icon="✅" title="Template Aktif"   value={stats.activeTemplates|| 0} color="#FBBF24" />
      </div>

      {/* Coaching Templates */}
      <div style={{ marginBottom: 18 }}>
        <SectionCard title="Coaching Templates">
          {loading ? (
            <p style={{ color: "#6B7280", fontSize: 13 }}>Memuat data...</p>
          ) : (
            <>
              <table style={{ width: "100%", borderCollapse: "collapse" }}>
                <thead>
                  <tr>
                    {["Template", "Kategori", "Risk Level", "Status", "Aksi"].map(h => (
                      <th key={h} style={tableHead}>{h}</th>
                    ))}
                  </tr>
                </thead>
                <tbody>
                  {templates.length === 0 ? (
                    <tr>
                      <td colSpan={5} style={{ ...tableCell, color: "#6B7280", textAlign: "center", padding: 24 }}>
                        Belum ada template. Tambahkan sekarang.
                      </td>
                    </tr>
                  ) : templates.map(t => (
                    <tr key={t.id}>
                      <td style={tableCell}>
                        <div style={{ fontWeight: 600 }}>{t.title}</div>
                        <div style={{ fontSize: 11, color: "#6B7280", marginTop: 2, maxWidth: 240, overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap" }}>
                          {t.content}
                        </div>
                      </td>
                      <td style={tableCell}>
                        <span style={{ background: "#818CF822", color: "#818CF8", padding: "3px 10px", borderRadius: 20, fontSize: 11 }}>
                          {t.category}
                        </span>
                      </td>
                      <td style={tableCell}><Badge label={t.risk_level} /></td>
                      <td style={tableCell}>
                        <span style={{
                          background: t.is_active ? "#D1FAE522" : "#F3F4F622",
                          color: t.is_active ? "#34D399" : "#9CA3AF",
                          padding: "3px 10px", borderRadius: 20, fontSize: 11, fontWeight: 600,
                        }}>
                          {t.is_active ? "Aktif" : "Nonaktif"}
                        </span>
                      </td>
                      <td style={tableCell}>
                        <div style={{ display: "flex", gap: 8 }}>
                          <button style={editBtn} onClick={() => setModal({ mode: "edit", data: t })}>Edit</button>
                          <button style={deleteBtn} onClick={() => setDeleteTarget(t)}>Hapus</button>
                        </div>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>

              <button style={primaryBtn} onClick={() => setModal({ mode: "add" })}>
                + Tambah Template
              </button>
            </>
          )}
        </SectionCard>
      </div>

      {/* WA Chat Monitoring */}
      <SectionCard title="WA Chat Monitoring">
        <table style={{ width: "100%", borderCollapse: "collapse" }}>
          <thead>
            <tr>
              {["User", "Jumlah Pesan", "Template Digunakan", "Terakhir Aktif", "Aksi"].map(h => (
                <th key={h} style={tableHead}>{h}</th>
              ))}
            </tr>
          </thead>
          <tbody>
            {histories.length === 0 ? (
              <tr>
                <td colSpan={5} style={{ ...tableCell, color: "#6B7280", textAlign: "center", padding: 24 }}>
                  Belum ada riwayat coaching.
                </td>
              </tr>
            ) : histories.map((chat, i) => (
              <tr key={i}>
                <td style={tableCell}>{chat.user?.name || "-"}</td>
                <td style={tableCell}>{chat.message_count || 1}</td>
                <td style={tableCell}>{chat.template?.title || "-"}</td>
                <td style={tableCell}>
                  {chat.read_at
                    ? new Date(chat.read_at).toLocaleString("id-ID", { dateStyle: "short", timeStyle: "short" })
                    : <span style={{ color: "#6B7280" }}>Belum dibaca</span>
                  }
                </td>
                <td style={tableCell}>
                  <button style={detailBtn}>Lihat Riwayat</button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </SectionCard>

      {/* Modal Tambah/Edit */}
      {modal && (
        <TemplateModal
          mode={modal.mode}
          initial={modal.data}
          onClose={() => setModal(null)}
          onSave={handleSave}
        />
      )}

      {/* Konfirmasi Hapus */}
      {deleteTarget && (
        <div style={overlayStyle} onClick={() => setDeleteTarget(null)}>
          <div style={{ ...modalStyle, maxWidth: 400 }} onClick={e => e.stopPropagation()}>
            <h3 style={{ margin: "0 0 10px", color: "#F9FAFB" }}>Hapus Template?</h3>
            <p style={{ color: "#9CA3AF", fontSize: 13, marginBottom: 20 }}>
              Template <strong style={{ color: "#F9FAFB" }}>{deleteTarget.title}</strong> akan dihapus permanen.
            </p>
            <div style={{ display: "flex", gap: 10, justifyContent: "flex-end" }}>
              <button onClick={() => setDeleteTarget(null)} style={cancelBtn}>Batal</button>
              <button onClick={handleDelete} disabled={deleteLoading} style={{ ...deleteBtn, padding: "10px 18px" }}>
                {deleteLoading ? "Menghapus..." : "Ya, Hapus"}
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}

// ─── Styles ───────────────────────────────────────────────────────────────────

const tableHead = {
  textAlign: "left", paddingBottom: 12,
  color: "#6B7280", fontSize: 12,
  borderBottom: "1px solid #2D2D3F",
};

const tableCell = {
  padding: "14px 0", borderBottom: "1px solid #2D2D3F",
  color: "#F9FAFB", fontSize: 13,
};

const primaryBtn = {
  marginTop: 16, border: "none",
  background: "#7C3AED", color: "#fff",
  padding: "10px 16px", borderRadius: 10,
  cursor: "pointer", fontSize: 13, fontWeight: 600,
};

const cancelBtn = {
  border: "1px solid #2D2D3F",
  background: "transparent", color: "#9CA3AF",
  padding: "9px 16px", borderRadius: 10,
  cursor: "pointer", fontSize: 13,
};

const editBtn = {
  border: "none", background: "#FBBF24", color: "#fff",
  padding: "6px 12px", borderRadius: 8,
  cursor: "pointer", fontSize: 12,
};

const deleteBtn = {
  border: "none", background: "#F87171", color: "#fff",
  padding: "6px 12px", borderRadius: 8,
  cursor: "pointer", fontSize: 12,
};

const detailBtn = {
  border: "none", background: "#60A5FA", color: "#fff",
  padding: "6px 12px", borderRadius: 8,
  cursor: "pointer", fontSize: 12,
};

const overlayStyle = {
  position: "fixed", inset: 0,
  background: "rgba(0,0,0,0.6)",
  display: "flex", alignItems: "center",
  justifyContent: "center", zIndex: 1000,
};

const modalStyle = {
  background: "#1E1E2E", borderRadius: 16,
  padding: 28, width: "100%", maxWidth: 540,
};

const labelStyle = {
  display: "block", marginBottom: 6,
  fontSize: 12, color: "#9CA3AF",
};

const inputStyle = {
  width: "100%", background: "#13131F",
  border: "1px solid #2D2D3F", borderRadius: 8,
  padding: "10px 12px", color: "#F9FAFB",
  fontSize: 13, outline: "none",
  boxSizing: "border-box",
};