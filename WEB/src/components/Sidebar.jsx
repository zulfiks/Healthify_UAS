import { NavLink, useNavigate } from "react-router-dom";
import axiosClient from "../api/axios";
import {
  Home,
  Users,
  Scale,
  UtensilsCrossed,
  ShieldCheck,
  ClipboardCheck,
  FileText,
  Bell,
  Trophy,
  Settings,
  LogOut,
  HeartPulse,
  BookOpen,
  ScrollText,
} from "lucide-react";

const menus = [
  { name: "Dashboard", path: "/dashboard", icon: Home },
  { name: "User Monitoring", path: "/users", icon: Users },
  { name: "AI Weight Loss Plan", path: "/ai-weight", icon: Scale },
  { name: "Food Intelligence Center", path: "/food-center", icon: UtensilsCrossed },
  { name: "Risk & Safety Center", path: "/risk-safety", icon: ShieldCheck },
 
  { name: "Weekly AI Reports", path: "/weekly-reports", icon: FileText },
  { name: "Coaching & Reminder", path: "/coaching", icon: Bell },
  { name: "Achievements", path: "/achievements", icon: Trophy },
  { name: "Content & Education", path: "/content-education", icon: BookOpen },
  { name: "Agent Activity Log", path: "/agent-log", icon: ScrollText },
  { name: "Settings", path: "/settings", icon: Settings },
];

export default function Sidebar() {
  const navigate = useNavigate();

  const handleLogout = async () => {
    try {
      await axiosClient.post("/admin/logout");
    } catch {
      // Tetap logout meski request gagal
    } finally {
      localStorage.removeItem("token");
      navigate("/login");
    }
  };

return (
  <aside className="w-[280px] h-screen bg-[#081318] text-white fixed left-0 top-0 flex flex-col overflow-hidden">

    {/* Logo */}
    <div className="px-6 pt-6 pb-5 shrink-0">
      <div className="flex items-center gap-3">
        <div className="w-10 h-10 rounded-2xl bg-[#0d2e28] border border-[#1a4a3f] flex items-center justify-center shrink-0">
          <HeartPulse size={18} className="text-[#2CF2B4]" />
        </div>
        <div>
          <h1 className="text-[22px] font-bold text-white leading-none tracking-tight">
            Healthify
          </h1>
          <p className="text-[10px] text-[#4a6e6a] mt-[4px] tracking-widest uppercase">
            Admin Panel
          </p>
        </div>
      </div>
    </div>

    {/* Divider */}
    <div className="mx-6 border-t border-[#0f2426] shrink-0" />

    {/* Menu - Diubah dari px-3 ke px-4 agar menjauh dari tepi kiri */}
<nav className="flex-1 overflow-y-auto pt-4 pb-4">
  <div className="px-4 space-y-1">
    {menus.map((menu) => {
      const Icon = menu.icon;

      return (
        <NavLink
          key={menu.path}
          to={menu.path}
className={({ isActive }) =>
  `w-full flex items-center gap-3 pl-6 pr-4 h-[46px] rounded-xl text-[13.5px] font-medium transition-all duration-150 ${
    isActive
      ? "bg-[#0d2e28] text-[#e8f8f5]"
      : "text-[#5a8a84] hover:bg-[#0d2022] hover:text-[#b0d4cf]"
  }`
}
        >
          {({ isActive }) => (
            <>
              <Icon
                size={18}
                strokeWidth={isActive ? 2 : 1.6}
                className={isActive ? "text-[#2CF2B4]" : ""}
              />

              <span className="truncate">{menu.name}</span>
            </>
          )}
        </NavLink>
      );
    })}
  </div>
</nav>
    {/* Divider */}
    <div className="mx-6 border-t border-[#0f2426] shrink-0" />

    {/* User + Logout — Diubah container luarnya ke px-4 agar konsisten */}
    <div className="px-5 pt-3 pb-6 shrink-0 space-y-2">
      <div className="flex items-center gap-3 px-4 py-2.5 rounded-xl hover:bg-[#0d2022] transition-all cursor-pointer">
        <div className="w-8 h-8 rounded-full shrink-0 bg-[#0d2e28] border border-[#1a4a3f] flex items-center justify-center">
          <span className="text-[12px] font-bold text-[#2CF2B4]">DA</span>
        </div>
        <div className="min-w-0">
          <h3 className="text-[13px] font-semibold text-[#e8f8f5] truncate">Dr. Admin</h3>
          <p className="text-[11px] text-[#4a6e6a]">Super Admin</p>
        </div>
      </div>

      <button
        onClick={handleLogout}
        className="w-full h-[44px] px-5 rounded-xl flex items-center gap-3 text-[13.5px] font-medium text-[#5a8a84] hover:bg-[#0d2022] hover:text-[#b0d4cf] transition-all duration-150"
      >
        <LogOut size={17} strokeWidth={1.6} />
        Logout
      </button>
    </div>

  </aside>
);
}