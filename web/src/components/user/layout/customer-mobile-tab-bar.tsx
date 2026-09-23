"use client";

import { useState } from "react";
import Link from "next/link";
import { usePathname } from "next/navigation";
import { Plus, MoreHorizontal } from "lucide-react";
import { cn } from "@/lib/utils";
import { Sheet, SheetContent, SheetHeader, SheetTitle } from "@/components/ui/sheet";
import {
  customerMainNavItems,
  customerMobileTabItems,
  customerUtilityNavItems,
  type NavItem,
} from "../../../app/constants/sidebar";

interface CustomerMobileTabBarProps {
  onAddExpense?: () => void;
}

export function CustomerMobileTabBar({ onAddExpense }: CustomerMobileTabBarProps) {
  const pathname = usePathname();
  const [moreOpen, setMoreOpen] = useState(false);

  const pinnedHrefs = new Set(customerMobileTabItems.map((item) => item.href));
  const moreItems = [
    ...customerMainNavItems.filter((item) => !pinnedHrefs.has(item.href)),
    ...customerUtilityNavItems,
  ];

  return (
    <>
      <nav
        className="fixed inset-x-0 bottom-0 z-40 grid grid-cols-5 items-end border-t border-border bg-card md:hidden"
        style={{ paddingBottom: "env(safe-area-inset-bottom, 0px)" }}
      >
        {customerMobileTabItems.slice(0, 2).map((item) => (
          <TabLink key={item.href} item={item} active={pathname === item.href} />
        ))}

        <div className="grid h-16 place-items-center">
          <button
            onClick={onAddExpense}
            aria-label="Add expense"
            className="-mt-6 grid h-12 w-12 place-items-center rounded-full bg-primary text-primary-foreground shadow-lg"
          >
            <Plus className="h-6 w-6" strokeWidth={2.5} />
          </button>
        </div>

        {customerMobileTabItems.slice(2).map((item) => (
          <TabLink key={item.href} item={item} active={pathname === item.href} />
        ))}

        <button
          onClick={() => setMoreOpen(true)}
          className="flex h-16 flex-col items-center justify-center gap-0.5 text-[0.65rem] font-medium text-muted-foreground"
        >
          <MoreHorizontal className="h-5 w-5" />
          More
        </button>
      </nav>

      <Sheet open={moreOpen} onOpenChange={setMoreOpen}>
        <SheetContent side="bottom" className="rounded-t-2xl">
          <SheetHeader>
            <SheetTitle>More</SheetTitle>
          </SheetHeader>
          <div className="mt-2 space-y-1">
            {moreItems.map((item) => {
              const Icon = item.icon;
              return (
                <Link
                  key={item.href}
                  href={item.href}
                  onClick={() => setMoreOpen(false)}
                  className="flex items-center gap-3 rounded-md px-3 py-2.5 text-sm font-medium hover:bg-accent"
                >
                  <Icon className="h-5 w-5 text-muted-foreground" />
                  {item.label}
                </Link>
              );
            })}
          </div>
        </SheetContent>
      </Sheet>
    </>
  );
}

function TabLink({ item, active }: { item: NavItem; active: boolean }) {
  const Icon = item.icon;
  return (
    <Link
      href={item.href}
      className={cn(
        "flex h-16 flex-col items-center justify-center gap-0.5 text-[0.65rem] font-medium",
        active ? "text-primary" : "text-muted-foreground"
      )}
    >
      <Icon className="h-5 w-5" />
      {item.label}
    </Link>
  );
}