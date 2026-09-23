import {
  LayoutGrid,
  Receipt,
  Users,
  Wallet,
  Tags,
  BarChart3,
  Repeat,
  HelpCircle,
  type LucideIcon,
} from "lucide-react";

export interface NavItem {
  label: string;
  href: string;
  icon: LucideIcon;
  badge?: string;
}

export const customerMainNavItems: NavItem[] = [
  { label: "Dashboard", href: "/dashboard", icon: LayoutGrid },
  { label: "Expenses", href: "/expenses", icon: Receipt },
  { label: "Groups", href: "/groups", icon: Users, badge: "3" },
  { label: "Budgets", href: "/budgets", icon: Wallet },
  { label: "Categories", href: "/categories", icon: Tags },
  { label: "Reports", href: "/reports", icon: BarChart3 },
  { label: "Recurring", href: "/recurring", icon: Repeat },
];

export const customerUtilityNavItems: NavItem[] = [
  { label: "Help & Support", href: "/help", icon: HelpCircle },
];

// The subset pinned directly in the mobile bottom tab bar.
// Keep this short — everything else surfaces in the "More" sheet.
export const customerMobileTabItems: NavItem[] = [
  customerMainNavItems[0], // Dashboard
  customerMainNavItems[1], // Expenses
  customerMainNavItems[2], // Groups
];