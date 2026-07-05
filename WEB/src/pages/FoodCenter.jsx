import { useEffect, useState } from "react";
import {
  PieChart, Pie, Cell, ResponsiveContainer,
  BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip,
} from "recharts";
import axiosClient from "../api/axios";

const pieColors = ["#818CF8", "#34D399", "#FBBF24", "#F87171", "#60A5FA"];

// =====================
// Reusable Components
// =====================
function StatCard({ icon, label, value, color }) {
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
      <div style={{ fontSize: 13, color: "#9CA3AF" }}>{label}</div>
      <div style={{ fontSize: 28, fontWeight: 700, color: "#F9FAFB", marginTop: 5 }}>{value}</div>
    </div>
  );
}

function SectionCard({ title, children }) {
  return (
    <div style={{ background: "#1E1E2E", borderRadius: 14, padding: "20px 22px" }}>
      <h3 style={{ marginTop: 0, marginBottom: 18, color: "#F9FAFB", fontSize: 15 }}>{title}</h3>
      {children}
    </div>
  );
}

// =====================
// Modal Tambah / Edit Makanan
// =====================
function FoodModal({ food, onClose, onSaved }) {
  const isEdit = !!food?.id;
const [form, setForm] = useState({
    name: food?.name || "",
    calories: food?.calories || "",
    protein: food?.protein || "",
    carbs: food?.carbs || "",
    fat: food?.fat || "",
    serving_size: food?.serving_size || "",
});
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState("");

  const handleSubmit = async () => {
    if (
    !form.name ||
    !form.calories ||
    !form.serving_size
) {
      setError("Semua field wajib diisi.");
      return;
    }

    setLoading(true);
    setError("");

    try {


      if (isEdit) {
        await axiosClient.put(`/admin/foods/${food.id}`, form);
      } else {
        await axiosClient.post("/admin/foods", form);
      }

      onSaved();
      onClose();
    } catch (err) {
      setError("Gagal menyimpan. Coba lagi.");
    } finally {
      setLoading(false);
    }
  };

  return (
    <div onClick={onClose} style={{
      position: "fixed", inset: 0, background: "rgba(0,0,0,0.6)",
      display: "flex", alignItems: "center", justifyContent: "center", zIndex: 50,
    }}>
      <div onClick={(e) => e.stopPropagation()} style={{
        background: "#1E1E2E", borderRadius: 18, padding: 28,
        width: "100%", maxWidth: 420, color: "#F9FAFB",
      }}>
        <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: 24 }}>
          <h3 style={{ margin: 0, fontSize: 16, fontWeight: 700 }}>
            {isEdit ? "Edit Makanan" : "Tambah Makanan"}
          </h3>
          <button onClick={onClose} style={closeBtn}>✕</button>
        </div>

        {error && (
          <div style={{ background: "#FEE2E2", color: "#DC2626", padding: "10px 14px", borderRadius: 10, marginBottom: 16, fontSize: 13 }}>
            {error}
          </div>
        )}

        <div style={{ display: "flex", flexDirection: "column", gap: 14 }}>
          <div>
            <label style={labelStyle}>Nama Makanan</label>
            <input
              value={form.name}
              onChange={(e) => setForm({
    ...form,
    name:e.target.value
})}
              placeholder="cth: Nasi Padang"
              style={inputStyle}
            />
          </div>

          <div>
            <label style={labelStyle}>Kalori (kkal)</label>
            <input
              type="number"
              value={form.calories}
              onChange={(e) => setForm({ ...form, calories:e.target.value })}
              placeholder="cth: 483"
              style={inputStyle}
            />
          </div>

          <div>
            <label style={labelStyle}>Satuan</label>
            <input
              value={form.serving_size}
              onChange={(e) => setForm({ ...form, serving_size: e.target.value })}
              placeholder="cth: 1 porsi"
              style={inputStyle}
            />
          </div>
        </div>

        <div style={{ display: "flex", gap: 10, marginTop: 24 }}>
          <button onClick={onClose} style={cancelBtn}>Batal</button>
          <button onClick={handleSubmit} disabled={loading} style={submitBtn}>
            {loading ? "Menyimpan..." : isEdit ? "Simpan Perubahan" : "Tambah Makanan"}
          </button>
        </div>
      </div>
    </div>
  );
}

// =====================
// Modal Konfirmasi Hapus
// =====================
function DeleteModal({ food, onClose, onDeleted }) {
  const [loading, setLoading] = useState(false);

  const handleDelete = async () => {
    setLoading(true);
    try {
      await axiosClient.delete(`/admin/foods/${food.id}`);
      onDeleted();
      onClose();
    } catch (err) {
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div onClick={onClose} style={{
      position: "fixed", inset: 0, background: "rgba(0,0,0,0.6)",
      display: "flex", alignItems: "center", justifyContent: "center", zIndex: 50,
    }}>
      <div onClick={(e) => e.stopPropagation()} style={{
        background: "#1E1E2E", borderRadius: 18, padding: 28,
        width: "100%", maxWidth: 380, color: "#F9FAFB", textAlign: "center",
      }}>
        <div style={{ fontSize: 40, marginBottom: 16 }}>🗑️</div>
        <h3 style={{ margin: "0 0 8px", fontSize: 16 }}>Hapus Makanan?</h3>
        <p style={{ color: "#9CA3AF", fontSize: 13, margin: "0 0 24px" }}>
          <strong style={{ color: "#F9FAFB" }}>{food.name}</strong> akan dihapus permanen dari database.
        </p>
        <div style={{ display: "flex", gap: 10 }}>
          <button onClick={onClose} style={cancelBtn}>Batal</button>
          <button onClick={handleDelete} disabled={loading} style={{ ...submitBtn, background: "#EF4444" }}>
            {loading ? "Menghapus..." : "Ya, Hapus"}
          </button>
        </div>
      </div>
    </div>
  );
}

// =====================
// Main Component
// =====================
export default function FoodIntelligenceCenter() {
  const [foods, setFoods] = useState([]);
  const [topFoods, setTopFoods] = useState([]);
  const [highCalories, setHighCalories] = useState([]);
  const [trend, setTrend] = useState([]);
  const [search, setSearch] = useState("");

  const [modalAdd, setModalAdd] = useState(false);
  const [modalEdit, setModalEdit] = useState(null);   // food object
  const [modalDelete, setModalDelete] = useState(null); // food object

  const fetchFoods = () => {
    axiosClient.get("/admin/foods").then((res) => setFoods(res.data.data || []));
  };

  const fetchStats = () => {
    axiosClient.get("/admin/food-statistics").then((res) => {
      setTopFoods(res.data.top_foods || []);
      setHighCalories(res.data.high_calories || []);
      setTrend(res.data.trend || []);
    });
  };

  useEffect(() => {
    fetchFoods();
    fetchStats();
  }, []);

const filteredFoods = foods.filter((f) =>
    f.name?.toLowerCase().includes(search.toLowerCase())
);
  

  const totalFoodLogs = topFoods.reduce((sum, item) => sum + item.total, 0);

  return (
    <div style={{
      background: "#13131F", minHeight: "100vh",
      padding: 28, color: "#F9FAFB", fontFamily: "'Inter', sans-serif",
    }}>
      {/* Header */}
      <div style={{ marginBottom: 28 }}>
        <h1 style={{ fontSize: 22, fontWeight: 700, margin: 0 }}>Food Intelligence Center</h1>
        <p style={{ fontSize: 13, color: "#6B7280", marginTop: 5 }}>
          Kelola database makanan dan pantau pola konsumsi pengguna
        </p>
      </div>

      {/* Stat Cards */}
      <div style={{ display: "flex", gap: 14, marginBottom: 20 }}>
        <StatCard icon="🍽️" label="Food Database" value={foods.length} color="#818CF8" />
        <StatCard icon="📊" label="Total Food Logs" value={totalFoodLogs} color="#F87171" />
        <StatCard icon="🔥" label="Makanan Tertinggi Kalori"
          value={highCalories[0]?.name || "-"} color="#FBBF24" />
        <StatCard icon="📈" label="Makanan Terpopuler"
          value={topFoods[0]?.name || "-"} color="#34D399" />
      </div>

      {/* Food Database Table */}
      <div style={{ marginBottom: 18 }}>
        <SectionCard title="Food Database">
          {/* Search + Tambah */}
          <div style={{ display: "flex", gap: 10, marginBottom: 16 }}>
            <input
              placeholder="Cari makanan..."
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              style={{ ...inputStyle, flex: 1 }}
            />
            <button onClick={() => setModalAdd(true)} style={primaryBtn}>
              + Tambah Makanan
            </button>
          </div>

          <table style={{ width: "100%", borderCollapse: "collapse" }}>
            <thead>
              <tr>
                {["No", "Nama Makanan", "Kalori (kkal)", "Satuan", "Aksi"].map((h) => (
                  <th key={h} style={tableHead}>{h}</th>
                ))}
              </tr>
            </thead>
            <tbody>
              {filteredFoods.length === 0 ? (
                <tr>
                  <td colSpan={5} style={{ ...tableCell, textAlign: "center", color: "#6B7280", padding: "32px 0" }}>
                    {search ? "Makanan tidak ditemukan." : "Belum ada data makanan."}
                  </td>
                </tr>
              ) : (
                filteredFoods.map((food, index) => (
                  <tr key={food.id}>
                    <td style={tableCell}>{index + 1}</td>
                    <td style={tableCell}>{food.name}</td>
                    <td style={tableCell}>{food.calories}</td>
                    <td style={tableCell}>{food.serving_size}</td>
                    <td style={tableCell}>
                      <div style={{ display: "flex", gap: 6 }}>
                        <button style={editBtn} onClick={() => setModalEdit(food)}>Edit</button>
                        <button style={deleteBtn} onClick={() => setModalDelete(food)}>Hapus</button>
                      </div>
                    </td>
                  </tr>
                ))
              )}
            </tbody>
          </table>
        </SectionCard>
      </div>

      {/* Charts */}
      <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: 16, marginBottom: 16 }}>
        <SectionCard title="Makanan Paling Sering Dikonsumsi">
          {topFoods.length === 0 ? (
            <p style={{ color: "#6B7280", fontSize: 13 }}>Belum ada data food log.</p>
          ) : (
            <ResponsiveContainer width="100%" height={260}>
              <PieChart>
                <Pie
    data={topFoods}
    dataKey="total"
    nameKey="name"
    outerRadius={90}
>
                  {topFoods.map((_, index) => (
                    <Cell key={index} fill={pieColors[index % pieColors.length]} />
                  ))}
                </Pie>
                <Tooltip />
              </PieChart>
            </ResponsiveContainer>
          )}
        </SectionCard>

        <SectionCard title="Makanan Tinggi Kalori">
          {highCalories.length === 0 ? (
            <p style={{ color: "#6B7280", fontSize: 13 }}>Belum ada data.</p>
          ) : (
            <ResponsiveContainer width="100%" height={260}>
              <BarChart data={highCalories}>
                <CartesianGrid strokeDasharray="3 3" stroke="#2D2D3F" />
                <XAxis
    dataKey="name"
    tick={{ fill: "#9CA3AF", fontSize: 11 }}
/>
                <YAxis tick={{ fill: "#9CA3AF", fontSize: 11 }} />
                <Tooltip />
                <Bar dataKey="total_kalori" fill="#F87171" />
              </BarChart>
            </ResponsiveContainer>
          )}
        </SectionCard>
      </div>

      <SectionCard title="Tren Konsumsi User">
        {trend.length === 0 ? (
          <p style={{ color: "#6B7280", fontSize: 13 }}>Belum ada data tren.</p>
        ) : (
          <ResponsiveContainer width="100%" height={280}>
            <BarChart data={trend}>
              <CartesianGrid strokeDasharray="3 3" stroke="#2D2D3F" />
              <XAxis dataKey="tanggal_catat" tick={{ fill: "#9CA3AF" }} />
              <YAxis tick={{ fill: "#9CA3AF" }} />
              <Tooltip />
              <Bar dataKey="total_kalori" fill="#818CF8" />
            </BarChart>
          </ResponsiveContainer>
        )}
      </SectionCard>

      {/* Modals */}
      {modalAdd && (
        <FoodModal onClose={() => setModalAdd(false)} onSaved={fetchFoods} />
      )}
      {modalEdit && (
        <FoodModal food={modalEdit} onClose={() => setModalEdit(null)} onSaved={fetchFoods} />
      )}
      {modalDelete && (
        <DeleteModal food={modalDelete} onClose={() => setModalDelete(null)} onDeleted={fetchFoods} />
      )}
    </div>
  );
}

// =====================
// Styles
// =====================
const tableHead = {
  textAlign: "left", paddingBottom: 12,
  color: "#6B7280", fontSize: 12,
  borderBottom: "1px solid #2D2D3F",
};

const tableCell = {
  padding: "14px 0", borderBottom: "1px solid #2D2D3F",
  color: "#F9FAFB", fontSize: 13,
};

const inputStyle = {
  background: "#13131F", border: "1px solid #2D2D3F",
  borderRadius: 10, padding: "11px 14px",
  color: "#fff", outline: "none", fontSize: 13, width: "100%",
  boxSizing: "border-box",
};

const labelStyle = {
  display: "block", fontSize: 12,
  color: "#9CA3AF", marginBottom: 6,
};

const primaryBtn = {
  border: "none", background: "#7C3AED", color: "#fff",
  padding: "11px 16px", borderRadius: 10,
  cursor: "pointer", fontSize: 13, fontWeight: 600,
  whiteSpace: "nowrap",
};

const editBtn = {
  border: "none", background: "#FBBF24", color: "#fff",
  padding: "6px 10px", borderRadius: 8,
  cursor: "pointer", fontSize: 12,
};

const deleteBtn = {
  border: "none", background: "#F87171", color: "#fff",
  padding: "6px 10px", borderRadius: 8,
  cursor: "pointer", fontSize: 12,
};

const closeBtn = {
  border: "none", background: "#2D2D3F", color: "#9CA3AF",
  width: 28, height: 28, borderRadius: 8,
  cursor: "pointer", fontSize: 14,
};

const cancelBtn = {
  flex: 1, border: "1px solid #2D2D3F", background: "transparent",
  color: "#9CA3AF", padding: "11px", borderRadius: 10,
  cursor: "pointer", fontSize: 13,
};

const submitBtn = {
  flex: 1, border: "none", background: "#7C3AED",
  color: "#fff", padding: "11px", borderRadius: 10,
  cursor: "pointer", fontSize: 13, fontWeight: 600,
};