import { Routes, Route, Navigate } from "react-router-dom";

import AdminLayout from "../layouts/AdminLayout";
import ProtectedRoute from "./ProtectedRoute";

import AdminLogin from "../pages/AdminLogin";
import Dashboard from "../pages/Dashboard";
import UserMonitoring from "../pages/UserMonitoring";
import AIWeight from "../pages/AIWeight";
import FoodCenter from "../pages/FoodCenter";
import RiskSafety from "../pages/RiskSafety";
import ExpertReview from "../pages/ExpertReview";
import WeeklyReports from "../pages/WeeklyReports";
import Coaching from "../pages/Coaching";
import Achievements from "../pages/Achievements";
import Settings from "../pages/Settings";
import ContentEducation from "../pages/Contenteducation";
import AgentLog from "../pages/Agentlog";

export default function AppRoutes() {
  return (
    <Routes>
      {/* Public */}
      <Route path="/login" element={<AdminLogin />} />

      {/* Protected — semua route di bawah ini butuh token */}
      <Route
        element={
          <ProtectedRoute>
            <AdminLayout />
          </ProtectedRoute>
        }
      >
        <Route
          path="/"
          element={
            <Navigate
              to={localStorage.getItem("token") ? "/dashboard" : "/login"}
              replace
            />
          }
        />
        <Route path="/dashboard" element={<Dashboard />} />
        <Route path="/users" element={<UserMonitoring />} />
        <Route path="/ai-weight" element={<AIWeight />} />
        <Route path="/food-center" element={<FoodCenter />} />
        <Route path="/risk-safety" element={<RiskSafety />} />
        <Route path="/expert-review" element={<ExpertReview />} />
        <Route path="/weekly-reports" element={<WeeklyReports />} />
        <Route path="/coaching" element={<Coaching />} />
        <Route path="/achievements" element={<Achievements />} />
        <Route path="/content-education" element={<ContentEducation />} />
        <Route path="/agent-log" element={<AgentLog />} />
        <Route path="/settings" element={<Settings />} />
      </Route>

      {/* Fallback */}
      <Route path="*" element={<Navigate to="/login" replace />} />
    </Routes>
  );
}