import { Bell } from "lucide-react";
import { Button } from "@/components/ui/button";
import { ThemeToggle } from "@/components/global/theme-toggle";
import { ProfileMenu } from "./profile-menu";
import { User } from "@/types/user";

interface CustomerHeaderProps {
  user: User;
  hasUnreadNotifications?: boolean;
}

export function CustomerHeader({ user, hasUnreadNotifications }: CustomerHeaderProps) {
  return (
    <header className="flex h-16 shrink-0 items-center justify-between border-b border-border bg-background px-4 md:px-6">
      {/* Brand mark only shows on mobile — the desktop sidebar already carries it */}
      <div className="grid h-7 w-7 place-items-center rounded-md bg-primary text-xs font-bold text-primary-foreground md:hidden">
        EH
      </div>
      <div className="hidden md:block" />

      <div className="flex items-center gap-1.5">
        <ThemeToggle />
        <Button variant="ghost" size="icon" className="relative text-muted-foreground">
          <Bell className="h-5 w-5" />
          {hasUnreadNotifications && (
            <span className="absolute right-1.5 top-1.5 h-1.5 w-1.5 rounded-full bg-destructive" />
          )}
          <span className="sr-only">Notifications</span>
        </Button>
        <ProfileMenu name={user.name} email={user.email} avatarUrl={user.avatarUrl} />
      </div>
    </header>
  );
}