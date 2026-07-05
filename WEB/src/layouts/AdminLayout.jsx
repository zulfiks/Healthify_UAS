import { Outlet } from "react-router-dom";
import Sidebar from "../components/Sidebar";

export default function AdminLayout() {
  return (
    <>
      <Sidebar />
      <main
        className="min-h-screen p-8"
        style={{
          marginLeft: "280px",
          width: "calc(100vw - 280px)",
          overflowX: "hidden",
        }}
      >
        <Outlet />
      </main>
    </>
  );
}