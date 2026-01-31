import { ReactNode } from 'react';
import { cn } from '@/lib/utils';

interface FloatingActionBarProps {
  children: ReactNode;
  className?: string;
}

export function FloatingActionBar({ children, className }: FloatingActionBarProps) {
  return (
    <div className={cn(
      "bg-[#0f0f0f]/90 backdrop-blur-xl border border-white/10 rounded-2xl p-4 shadow-2xl w-full",
      className
    )}>
      <div className="flex items-center justify-between gap-4">
        {children}
      </div>
    </div>
  );
}
