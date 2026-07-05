import { useEffect, useState } from "react";
import axiosClient from "../api/axios";

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

const EMPTY_FORM = {
  title: "",
  description: "",
  category: "",
  type: "article",
  image_url: "",
  url: "",
};

function ContentModal({ mode, initial, onClose, onSaved }) {
  const [form, setForm] = useState(initial || EMPTY_FORM);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState("");

  const set = (k, v) => setForm((f) => ({ ...f, [k]: v }));

  const handleSubmit = async () => {
    if (
    !form.title.trim() ||
    !form.category.trim() ||
    !form.description.trim()
) {
      setError("Judul, Kategori, dan Isi wajib diisi.");
      return;
    }
    setSaving(true);
    setError("");
    try {
      if (mode === "edit") {
        await axiosClient.put(`/admin/education-content/${initial.id}`, form);
      } else {
        await axiosClient.post("/admin/education-content", form);
      }
      onSaved();
    } catch (err) {
      setError(err.response?.data?.message || "Gagal menyimpan konten.");
    } finally {
      setSaving(false);
    }
  };

  return (
    <div onClick={onClose} style={{
      position: "fixed", inset: 0, background: "rgba(0,0,0,0.7)",
      display: "flex", alignItems: "center", justifyContent: "center", zIndex: 50, padding: 20,
    }}>
      <div onClick={(e) => e.stopPropagation()} style={{
        background: "#1E1E2E", borderRadius: 18, padding: 28,
        width: "100%", maxWidth: 520, color: "#F9FAFB", maxHeight: "85vh", overflowY: "auto",
      }}>
        <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: 20 }}>
          <h3 style={{ margin: 0, fontSize: 16, fontWeight: 700 }}>
            {mode === "edit" ? "Edit Konten Edukasi" : "Tambah Konten Edukasi"}
          </h3>
          <button onClick={onClose} style={{
            border: "none", background: "#2D2D3F", color: "#9CA3AF",
            width: 28, height: 28, borderRadius: 8, cursor: "pointer", fontSize: 14,
          }}>✕</button>
        </div>

        {error && (
          <div style={{ background: "#7F1D1D33", color: "#FCA5A5", padding: "10px 14px", borderRadius: 8, marginBottom: 14, fontSize: 13 }}>
            {error}
          </div>
        )}

        {[
          { key: "title", label: "Judul", placeholder: "Mindful Eating untuk Pemula" },
          { key: "category", label: "Kategori", placeholder: "Nutrisi / Aktivitas / Mindset" },
          { key: "image_url", label: "URL Gambar/Video (opsional)", placeholder: "https://..." },
        ].map((f) => (
          <div key={f.key} style={{ marginBottom: 14 }}>
            <label style={{ display: "block", fontSize: 12, color: "#9CA3AF", marginBottom: 6 }}>{f.label}</label>
            <input
              value={form[f.key]}
              placeholder={f.placeholder}
              onChange={(e) => set(f.key, e.target.value)}
              style={{
                width: "100%", background: "#13131F", border: "1px solid #2D2D3F",
                borderRadius: 10, padding: "10px 12px", color: "#fff", outline: "none", boxSizing: "border-box",
              }}
            />
          </div>
        ))}

        <div style={{ marginBottom: 20 }}>
          <label style={{ display: "block", fontSize: 12, color: "#9CA3AF", marginBottom: 6 }}>Isi Konten</label>
          <textarea
            value={form.description}

onChange={(e)=>set("description",e.target.value)}
            rows={6}
            style={{
              width: "100%", background: "#13131F", border: "1px solid #2D2D3F",
              borderRadius: 10, padding: 12, color: "#fff", outline: "none",
              resize: "vertical", boxSizing: "border-box", fontSize: 13, lineHeight: 1.6,
            }}
          />
        </div>

        <button onClick={handleSubmit} disabled={saving} style={{
          border: "none", background: "#2CF2B4", color: "#000",
          padding: "11px 18px", borderRadius: 10, cursor: "pointer", fontWeight: 700, fontSize: 13,
        }}>
          {saving ? "Menyimpan..." : "Simpan"}
        </button>
      </div>
    </div>
  );
}

export default function ContentEducation() {
  const [contents, setContents] = useState([]);
  const [loading, setLoading] = useState(true);
  const [search, setSearch] = useState("");
  const [modal, setModal] = useState(null); // { mode: 'add' | 'edit', data? }
  const [deleteTarget, setDeleteTarget] = useState(null);

  const fetchData = () => {
    setLoading(true);
    axiosClient.get("/admin/education-content")
      .then((res) => setContents(res.data.data || res.data || []))
      .catch(console.error)
      .finally(() => setLoading(false));
  };

  useEffect(() => { fetchData(); }, []);

  const handleDelete = async () => {
    if (!deleteTarget) return;
    try {
      await axiosClient.delete(`/admin/education-content/${deleteTarget.id}`);
      setContents((prev) => prev.filter((c) => c.id !== deleteTarget.id));
      setDeleteTarget(null);
    } catch (err) {
      console.error(err);
    }
  };

  const filtered = contents.filter(
    (c) =>
      c.title?.toLowerCase().includes(search.toLowerCase()) ||
      c.category?.toLowerCase().includes(search.toLowerCase())
  );

  const categories = new Set(contents.map((c) => c.category).filter(Boolean));

  return (
    <div style={{
      background: "#13131F", minHeight: "100vh",
      padding: 28, color: "#F9FAFB", fontFamily: "Inter, sans-serif",
    }}>
      <div style={{ marginBottom: 28 }}>
        <h1 style={{ margin: 0, fontSize: 22, fontWeight: 700 }}>Content & Education Management</h1>
        <p style={{ marginTop: 5, color: "#6B7280", fontSize: 13 }}>
          Kelola konten edukasi yang dikirim AI secara personal ke pengguna
        </p>
      </div>

      <div style={{ display: "flex", gap: 14, marginBottom: 20 }}>
        <StatCard icon="📚" title="Total Konten" value={contents.length} color="#818CF8" />
        <StatCard icon="🏷️" title="Kategori" value={categories.size} color="#34D399" />
        <StatCard icon="🤖" title="Dikirim AI Minggu Ini" value={contents.filter(c => c.sent_count).length} color="#FBBF24" />
      </div>

      <div style={{ background: "#1E1E2E", borderRadius: 14, padding: "20px 22px" }}>
        <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: 18, gap: 12 }}>
          <input
            placeholder="Cari judul atau kategori..."
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            style={{
              flex: 1, background: "#13131F", border: "1px solid #2D2D3F",
              borderRadius: 10, padding: "11px 14px", color: "#fff", outline: "none", fontSize: 13,
            }}
          />
          <button
            onClick={() => setModal({ mode: "add" })}
            style={{
              border: "none", background: "#7C3AED", color: "#fff",
              padding: "11px 16px", borderRadius: 10, cursor: "pointer", fontWeight: 600, fontSize: 13, whiteSpace: "nowrap",
            }}
          >
            + Tambah Konten
          </button>
        </div>

        <table style={{ width: "100%", borderCollapse: "collapse" }}>
          <thead>
            <tr>
              {["Judul", "Kategori", "Ringkasan", "Aksi"].map((h) => (
                <th key={h} style={tableHead}>{h}</th>
              ))}
            </tr>
          </thead>
          <tbody>
            {loading ? (
              <tr><td colSpan={4} style={{ ...tableCell, textAlign: "center", color: "#6B7280", padding: "32px 0" }}>Memuat...</td></tr>
            ) : filtered.length === 0 ? (
              <tr><td colSpan={4} style={{ ...tableCell, textAlign: "center", color: "#6B7280", padding: "32px 0" }}>Belum ada konten edukasi.</td></tr>
            ) : (
              filtered.map((item) => (
                <tr key={item.id}>
                  <td style={{ ...tableCell, fontWeight: 600 }}>{item.title}</td>
                  <td style={tableCell}>
                    <span style={{
                      background: "#818CF822", color: "#818CF8", padding: "4px 10px",
                      borderRadius: 999, fontSize: 11, fontWeight: 600,
                    }}>
                      {item.category}
                    </span>
                  </td>
                  <td style={{ ...tableCell, maxWidth: 320, fontSize: 12, color: "#9CA3AF" }}>
                    {(item.description || "").slice(0,90)}{item.content?.length > 90 ? "..." : ""}
                  </td>
                  <td style={tableCell}>
                    <div style={{ display: "flex", gap: 8 }}>
                      <button onClick={() => setModal({ mode: "edit", data: item })} style={editBtn}>Edit</button>
                      <button onClick={() => setDeleteTarget(item)} style={deleteBtn}>Hapus</button>
                    </div>
                  </td>
                </tr>
              ))
            )}
          </tbody>
        </table>
      </div>

      {modal && (
        <ContentModal
          mode={modal.mode}
          initial={modal.data}
          onClose={() => setModal(null)}
          onSaved={() => { setModal(null); fetchData(); }}
        />
      )}

      {deleteTarget && (
        <div onClick={() => setDeleteTarget(null)} style={{
          position: "fixed", inset: 0, background: "rgba(0,0,0,0.7)",
          display: "flex", alignItems: "center", justifyContent: "center", zIndex: 50,
        }}>
          <div onClick={(e) => e.stopPropagation()} style={{
            background: "#1E1E2E", borderRadius: 16, padding: 24, width: 360, color: "#F9FAFB",
          }}>
            <p style={{ marginTop: 0 }}>Hapus konten "<strong>{deleteTarget.title}</strong>"?</p>
            <div style={{ display: "flex", gap: 10, justifyContent: "flex-end", marginTop: 20 }}>
              <button onClick={() => setDeleteTarget(null)} style={{
                border: "none", background: "#2D2D3F", color: "#fff", padding: "9px 14px", borderRadius: 8, cursor: "pointer",
              }}>Batal</button>
              <button onClick={handleDelete} style={deleteBtn}>Hapus</button>
            </div>
          </div>
        </div>
      )}
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
const editBtn = {
  border: "none", background: "#FBBF24", color: "#fff",
  padding: "7px 12px", borderRadius: 8, cursor: "pointer", fontSize: 12,
};
const deleteBtn = {
  border: "none", background: "#F87171", color: "#fff",
  padding: "7px 12px", borderRadius: 8, cursor: "pointer", fontSize: 12,
};