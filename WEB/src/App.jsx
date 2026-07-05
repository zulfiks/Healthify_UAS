import { BrowserRouter } from "react-router-dom";
import AppRoutes from "./routes/AppRoutes"; // 💡 Sesuaikan path ini jika file AppRoutes Anda berada di folder lain (misal: "./AppRoutes")

function App() {
  return (
    <BrowserRouter>
      {/* Memanggil AppRoutes agar seluruh jalur navigasi dan layout aktif */}
      <AppRoutes />
    </BrowserRouter>
  );
}

export default App;