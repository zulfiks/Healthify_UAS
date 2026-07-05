import axios from "axios";

// GANTI sesuai alamat backend Laravel kamu kalau bukan port 8000
const BASE_URL = "http://127.0.0.1:8000/api";

const axiosClient = axios.create({
  baseURL: BASE_URL,
  headers: {
    Accept: "application/json",
  },
});

// Selipkan token otomatis ke SETIAP request
axiosClient.interceptors.request.use((config) => {
  const token = localStorage.getItem("token");
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

// Kalau token expired/invalid (401), otomatis tendang ke /login
axiosClient.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response?.status === 401) {
      localStorage.removeItem("token");
      if (window.location.pathname !== "/login") {
        window.location.href = "/login";
      }
    }
    return Promise.reject(error);
  }
);

export default axiosClient;