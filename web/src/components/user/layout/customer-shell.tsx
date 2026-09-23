import type { ReactNode } from "react";
import { CustomerSidebar } from "./customer-sidebar";
import { CustomerHeader } from "./customer-header";
import { CustomerMobileTabBar } from "./customer-mobile-tab-bar";
import { User } from "@/types/user";

interface CustomerShellProps {
  children: ReactNode;
  user: User;
}

export function CustomerShell({ children, user }: Readonly<CustomerShellProps>) {
  return (
    <div className="flex h-screen overflow-hidden bg-background">
      <CustomerSidebar />

      <div className="flex min-w-0 flex-1 flex-col">
        <CustomerHeader user={user} hasUnreadNotifications />
        <main className="flex-1 overflow-y-auto p-4 pb-24 md:p-6 md:pb-6">{children}</main>
      </div>

      <CustomerMobileTabBar />
    </div>
  );
}