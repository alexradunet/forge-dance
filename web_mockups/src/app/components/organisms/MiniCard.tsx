import { ReactNode } from 'react';
import { cn } from '@/lib/utils';
import { motion } from 'motion/react';

interface MiniCardProps {
  title: ReactNode;
  subtitle?: string;
  media: ReactNode;
  footer?: ReactNode;
  onClick?: () => void;
  className?: string;
}

export function MiniCard({
  title,
  subtitle,
  media,
  footer,
  onClick,
  className
}: MiniCardProps) {
  return (
    <motion.button
      onClick={onClick}
      className={cn(
        "relative w-full h-full bg-[#121212] rounded-[16px] border border-white/10 overflow-hidden flex flex-col ring-1 ring-white/5 shadow-md hover:ring-forge-orange/50 hover:border-forge-orange/30 transition-all text-left group",
        className
      )}
      whileHover={{ scale: 1.02 }}
      whileTap={{ scale: 0.98 }}
    >
      {/* Media Area */}
      <div className="absolute inset-0 bg-neutral-900 overflow-hidden">
        {media}
        
        {/* Overlay Gradient */}
        <div className="absolute inset-0 bg-gradient-to-b from-black/20 via-transparent to-black/90 pointer-events-none" />
      </div>

      {/* Content Layer */}
      <div className="absolute inset-0 flex flex-col justify-end z-20 pt-[16px] pr-[16px] pb-[16px] pl-[0px] p-[16px]">
        <div className="relative">
          {subtitle && (
            <div className="inline-block bg-black/60 backdrop-blur-sm px-1.5 py-0.5 text-[8px] font-mono text-forge-orange border border-forge-orange/30 rounded mb-1">
              {subtitle}
            </div>
          )}
          <div className="font-title text-xl leading-none text-transparent bg-clip-text bg-gradient-to-b from-white via-white to-white/60 drop-shadow-lg tracking-wide opacity-90 mb-2">
            {title}
          </div>
          
          {/* Divider */}
          <div className="w-full h-px bg-white/10 mb-2" />
          
          {/* Mini Footer */}
          <div className="opacity-80 scale-90 origin-left -ml-1">
            {footer}
          </div>
        </div>
      </div>
      
      {/* Hover Effect */}
      <div className="absolute inset-0 bg-white/5 opacity-0 group-hover:opacity-100 transition-opacity pointer-events-none" />
    </motion.button>
  );
}
