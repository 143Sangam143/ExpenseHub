
import { CustomerShell } from "@/components/user/layout/customer-shell";
import { User } from "@/types/user";

export default async function Layout({ children }: { children: React.ReactNode }) {
    const user: User = {
      'name': 'test',
      'email' : 'test-email',
      'avatarUrl': 'TT'
    };

  return <CustomerShell user={user}>{children}</CustomerShell>;
}