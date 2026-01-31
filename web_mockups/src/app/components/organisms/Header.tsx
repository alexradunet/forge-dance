import { Icon } from '@/app/components/atoms/Icon';
import { ReactNode } from 'react';

interface HeaderProps {
  title: string;
  subtitle?: string;
  leftSlot?: ReactNode;
  rightSlot?: ReactNode;
  className?: string;
}

export function Header({ title, subtitle, leftSlot, rightSlot, className = '' }: HeaderProps) {
  return (
    <header className={`flex items-center justify-between px-6 pt-14 pb-4 bg-gradient-to-b from-bg-deep via-bg-deep/95 to-transparent z-30 sticky top-0 ${className}`}>
      {/* Left Slot - Fixed width for alignment */}
      <div className="w-10 h-10 flex items-center justify-center">
        {leftSlot}
      </div>
      
      {/* Center Content */}
      <div className="text-center flex-1 mx-2">
        <h1 className="font-title text-2xl tracking-widest text-white drop-shadow-md uppercase">{title}</h1>
        {subtitle && (
          <p className="text-[10px] font-bold text-primary uppercase tracking-[0.2em]">{subtitle}</p>
        )}
      </div>
      
      {/* Right Slot - Fixed width for alignment */}
      <div className="w-10 h-10 flex items-center justify-center gap-2">
        {rightSlot}
      </div>
    </header>
  );
}